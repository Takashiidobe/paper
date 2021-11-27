.PHONY: phony

PAPER_NAME="Paper"
GRAPHVIZ_FILES = $(shell find ./graphviz -name '*.dot')
FIGURES = $(shell find ./figures -name '*.svg')

PANDOCFLAGS =                        \
	--metadata title=$(PAPER_NAME)     \
	--bibliography references.bib      \
  --table-of-contents                \
  --from=markdown                    \
  --number-sections                  \
	--filter pandoc-fignos 						 \
	--filter pandoc-tablenos 					 \
	--filter pandoc-eqnos 						 \
	--citeproc 												 \
  --indented-code-classes=javascript

HTML_FLAGS =                         \
	--template=./templates/paper.html   \
	--self-contained

PDF_FLAGS =                          \
  --pdf-engine=xelatex               \
  -V mainfont="Palatino"             \
  -V documentclass=report            \
  -V papersize=A5                    \
  -V geometry:"top=1cm, bottom=2cm, left=1cm, right=1cm"


html: phony output/paper.html

epub: phony output/paper.epub

pdf: phony output/paper.pdf

docx: phony output/paper.docx

figures: phony
	./bin/figures

output/%.pdf: %.md references.bib $(FIGURES) Makefile | output figures
	pandoc $< -o $@ $(PDF_FLAGS) $(PANDOCFLAGS)

output/%.epub: %.md references.bib $(FIGURES) Makefile | output figures
	pandoc $< -o $@ $(PANDOCFLAGS)

output/%.html: %.md references.bib $(FIGURES) Makefile | output figures
	pandoc $< -o $@ $(HTML_FLAGS) $(PANDOCFLAGS)

output/%.docx: %.md references.bib $(FIGURES) Makefile | output figures
	pandoc $< -o $@ $(PANDOCFLAGS)

output:
	mkdir ./output

clean: phony
	rm -rf ./output

open: phony output/paper.pdf
	open output/paper.pdf
