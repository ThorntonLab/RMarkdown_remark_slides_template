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
	rm -f blank.pdf

# List the dependencies for the presentation
$(SLIDES): $(IMAGES)

%.html: %.Rmd
	R --no-save --quiet -e "rmarkdown::render('$<')"

%.pdf: %.html
	chromium --headless --print-to-pdf=$@ $<

blank.pdf: blank.tex
	pdflatex $<
	
$(PDF): $(SLIDES)

$(HANDOUTS): $(PDF) blank.pdf
	$(eval TFILE=$(shell basename $< .pdf))
	$(shell cp $< $(TFILE)"_temp.pdf")
	$(eval NPAGES=$(shell exiftool -T -PageCount $(TFILE)"_temp.pdf"))
	$(eval RANGE=$(shell seq 1 ${NPAGES}))
	$(eval PDFJAM_ARG=$(foreach I,$(RANGE), $(TFILE)"_temp.pdf" $(I) blank.pdf 1 ))
	pdfjam -o $(TFILE)"_preslides.pdf" --fitpaper true $(PDFJAM_ARG)
	rm -f $(TFILE)"_temp.pdf"
	pdfjam --nup 2x2 --landscape --paper a4paper --frame true --noautoscale false --delta "0.2cm 0.3cm" --scale 0.95 -o $(TFILE)"_bigslides.pdf" $(TFILE)"_preslides.pdf"
	rm -f $(TFILE)"_preslides.pdf"
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dPrinted=false -dNOPAUSE -dQUIET -dBATCH -sOUTPUTFILE=$@ $(TFILE)"_bigslides.pdf"
	rm -f $(TFILE)"_bigslides.pdf"
