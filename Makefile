SLIDES:=PresentationSlides.html
FILES_DIRECTORY:=$(subst .html,_files,$(SLIDES))

# It is a good idea for your presentation
# to rebuild if any external graphics change,
# so we list them as build dependencies
IMAGES:=Model.png

all: $(SLIDES)

clean:
	rm -f $(SLIDES)
	rm -rf $(FILES_DIRECTORY)

# List the dependencies for the presentation
$(SLIDES): $(IMAGES)

%.html: %.Rmd
	R --no-save --quiet -e "rmarkdown::render('$<')"
