SLIDES:=PresentationSlides.html
FILES_DIRECTORY:=$(subst .html,_files,$(SLIDES))
HANDOUTS:=$(subst .html,_handout.pdf,$(SLIDES))
HANDOUT_DEPENDENCIES:=$(subst .html,.pdf,$(SLIDES))


# It is a good idea for your presentation
# to rebuild if any external graphics change,
# so we list them as build dependencies
IMAGES:=Model.png

all: $(SLIDES)

handouts: $(HANDOUTS) blank.pdf
	latexmk -pdf blank

clean:
	rm -f $(SLIDES)
	rm -rf $(FILES_DIRECTORY)

# List the dependencies for the presentation
$(SLIDES): $(IMAGES)

%.html: %.Rmd
	R --no-save --quiet -e "rmarkdown::render('$<')"

%.pdf: %.html blank.pdf
	$(eval TFILE=$(shell basename $@ .pdf))
	chromium --headless --print-to-pdf=$(TFILE)"_temp.pdf" $<
	$(eval NPAGES=$(shell exiftool -T -PageCount $(TFILE)"_temp.pdf"))
	echo "NP=$(NPAGES)"
	$(eval RANGE=$(shell seq 1 ${NPAGES}))
	$(eval PDFJAM_ARG=$(foreach I,$(RANGE), $(TFILE)"_temp.pdf" $(I) blank.pdf 1 ))
	pdfjam -o $@ --fitpaper true $(PDFJAM_ARG)
	# rm -f $(TFILE)"_temp.pdf"


%_handout.pdf: %.pdf
	pdfjam --nup 2x2 --landscape --paper a4paper --frame true --noautoscale false   --delta "0.2cm 0.3cm" --scale 0.95 $<
	# pdfjam --suffix 6up --nup 2x3 --frame true --noautoscale false   --delta "0.2cm 0.3cm" --scale 0.95 PresentationSlides_handout.pdf

%.pdf: %.tex
	pdflatex blank

$(HANDOUTS): $(HANDOUT_DEPENDENCIES)
