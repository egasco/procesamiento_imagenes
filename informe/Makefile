TEX = pdflatex -synctex=1 -interaction=nonstopmode 

.PHONY: all clean

all: clean informe

informe:
		$(TEX) -interaction=nonstopmode -halt-on-error informe.tex
			### Compilando de nuevo para que matchee bien el índice
				$(TEX) -interaction=batchmode informe.tex

clean:
		rm -f *.log *.aux *.toc
