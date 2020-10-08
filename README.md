# Template for R Markdown "remark" slides

This repository is a template for presentations based on [remark.js](https://remarkjs.com).
The slides are stored in an `HTML` file containing JavaScript code.
This repository uses the [xaringan](https://github.com/yihui/xaringan) `R` package to let you write slides in [R markdown](https://rmarkdown.rstudio.com).

You can do a lot with this platform.
See the [demo](https://slides.yihui.org/xaringan/#1) for examples and visit the [GitHub page](https://github.com/yihui/xaringan) for more info.
The [remark.js wiki](https://github.com/gnab/remark/wiki) is also useful.

## An alternative to this template

Follow the instructions from the `xaringan` author about how to get a template presentation from within `R Studio`.

This template repository mostly exists for people who prefer to work outside of that environment.
This template may also be useful for those who want to create the new presentation repository under immediate version control from within GitHub.

## To use this repository

Click `Use this template` from the `GitHub` interface.
Choose a name for your new repository.
You will get a copy of this repository with all the files but none of the commit history.

## Required R packages

It is probably helpful to make sure all of your packages are up to date!

At the very least:

* `rmarkdown`
* `knitr`
* `kableExtra`
* `magrittr`
* `xaringan`

## Steps to get your own talk started.

1. Rename `PresentationSlides.Rmd` to whatever you want it to be
2. Rename the value of the `SLIDES` variable in `Makefile` to match your new `Rmd` file name.
3. Update `Makefile` to reflect removing `Model.png`
4. Write your slides!

If you add external images to this repository that will be graphics for slides:

1. Commit them!
2. Add them to the `IMAGES` variable in `Makefile` so that your slides rebuild if they change.

### Building your presentation

Execute `make`.
If you use a `vim`-like editor, then execute this command when in `normal` mode:

```
:make
```

### Changing the theme

See the [demo presentation](https://slides.yihui.org/xaringan/#1) for a list of themes.

### Configuring the R environment

1. Make the changes to the `r setup` block near the top of the `Rmd` file.

### Notes regarding Python

1. If you aren't using Python, remove these two lines:
	
```
library(reticulate) # For Python
use_python("/usr/bin/python3", required=T)
```

2. You may need to configure the path in the `use_python` command.

### Using a local copy of MathJax

[MathJax](https://github.com/mathjax/MathJax) is used to generate images for rendering equations written in `LaTeX`.
It is a `JavaScript` service.
By default, your slides will need a network connection to access it.
Also, you cannot print your slides to `PDF` using `Chrome` or `chromium` from the command line when using `MathJax` in the default way.
(Well, you *can*, but you don't get your nicely-rendered equations.)

So, if you want to show slides without a network and/or export to `PDF`, you need a local `MathJax`:

```sh
git clone https://github.com/mathjax/MathJax mjtemp
mv mjtemp/es5 MathJax
```

You probably also want to add and commit the `MathJax` to your repo:

```sh
git add MathJax
git commit MathJax -m "Added local MathJax"
```

Then, edit the `YAML` front matter to look like this:

```
output:
  xaringan::moon_reader:
    css: [default, metropolis, metropolis-fonts]
    self_contained: true
    mathjax: MathJax/tex-chtml.js
```

You still need a network connection to *build* your slides, but you can view them when offline.

Advanced options here include:

1. Using `MathJax` as a git submodule.
   Doing this will save a lot of space.
2. Reading the `README` at the [MathJax repo](https://github.com/mathjax/MathJax) to learn what files you can delete from `MathJax/` to save space.
