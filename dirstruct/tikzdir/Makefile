# ./Makefile

ECHOCMD:=/bin/echo -e
#LATEX:=lualatex --shell-escape --time-statistics -interaction=batchmode
LATEX:=pdflatex --shell-escape --time-statistics -interaction=batchmode
#LATEX:=pdflatex --enable-write18 --extra-mem-bot=10000000 --synctex=1 --shell-escape --time-statistics -interaction=batchmode

TEST_SRCS:=$(wildcard *.tex)
TEST_PDFS:=$(TEST_SRCS:.tex=.pdf)

default: $(TEST_PDFS)

%.pdf: %.tex
	@$(LATEX) $<

.PHONY: clean

clean:
	rm -f *.aux \
		*.log \
		*.pdf

distclean: clean
	rm -f *.tex 
