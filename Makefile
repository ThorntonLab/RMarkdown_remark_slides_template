# No guarantees for how hard it is to extend this to many presentations.
PRESENTATIONNAME=PresentationSlides
SLIDES:=$(PRESENTATIONNAME).html
FILES_DIRECTORY:=$(subst .html,_files,$(SLIDES))
PDF:=$(subst html,pdf,$(SLIDES))
HANDOUTS:=$(subst .html,_handouts.pdf,$(SLIDES))

# It is a good idea for your presentation
# to rebuild if any external graphics change,
# so we list them as build dependencies
IMAGES:=Model.png

all: $(SLIDES)

pdf: $(PDF)

handouts: $(HANDOUTS) $(PDF) blank.pdf

clean:
	rm -f $(SLIDES)
	rm -f $(PDF)
	rm -rf $(FILES_DIRECTORY)
	rm -f $(HANDOUTS)
	rm -f blank.pdf
	rm -f *.bigslides.pdf

# List the dependencies for the presentation
$(SLIDES): $(IMAGES)

%.html: %.Rmd
	R --no-save --quiet -e "rmarkdown::render('$<')"

%.pdf: %.html
	chromium --headless --print-to-pdf=$@ $<

$(PDF): $(SLIDES)

# Below are the rules for generating handouts from slides.
# If you use equations, you need local MathJax.  
# See README about that.

# Create our blank page.
blank.pdf: blank.tex
	pdflatex $<

# Take the pdf export of the slides and:
# 1. Copy it to a temp file, which is the target of this rule
# 2. Figure out how many pages it is.
# 3. Add a blank page after each slide.
%.temp.pdf: %.pdf blank.pdf
	$(eval TFILE=$(shell basename $< .pdf))
	$(shell cp $< $(TFILE)".temp.pdf")
	$(eval NPAGES=$(shell exiftool -T -PageCount $<))
	$(eval RANGE=$(shell seq 1 ${NPAGES}))
	$(eval PDFJAM_ARG=$(foreach I,$(RANGE), $(TFILE)".temp.pdf" $(I) blank.pdf 1 ))
	pdfjam -o $@ --fitpaper true $(PDFJAM_ARG)

# Create the handout.
# The output file is very large!
%.bigslides.pdf: %.temp.pdf
	pdfjam --nup 2x2 --landscape --paper a4paper --frame true --noautoscale false --delta "0.2cm 0.3cm" --scale 0.95 -o $@ $<

# Run the hantout thru ghostcript to reduce file size.
# The big version is kep.
$(HANDOUTS): $(PRESENTATIONNAME).bigslides.pdf $(PDF)
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dPrinted=false -dNOPAUSE -dQUIET -dBATCH -sOUTPUTFILE=$@ $<
