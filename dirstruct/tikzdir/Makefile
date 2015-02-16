# ./Makefile

ECHOCMD:=/bin/echo -e
LATEX:=lualatex --shell-escape -interaction=batchmode

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
