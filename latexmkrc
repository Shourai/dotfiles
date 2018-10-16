$pdf_mode = 1;
$postscript_mode = $dvi_mode = 0;
$out_dir = 'build';
$pdflatex = 'pdflatex --shell-escape %O %S';
$pdflatex .= ' && (cp %D %R.pdf; echo Output file copied from %D to %R.pdf in current directory)';
$pdflatex .= ' && (cp %Z%R.synctex.gz %R.synctex.gz; echo Synctex file copied from %Z%R.synctex.gz to %R.synctex.gz)';

# $pdf_mode [0]
# If zero, do NO Tg enerate a pdf version of the document.  If equal
# to 1, generate a pdf version of the document using pdflatex ,u sing the command
# specified by the $pdflatex variable.  If equal to 2, generate a pdf version of
# the document from the ps file, by using the command specified by the $ps2pdf
# variable.  If equal to 3, generate a pdf version of the document from the dvi
# file, by using the command specified by the $dvipdf variable.  If equal to 4,
# generate a pdf v ersion of the docu- ment using lualatex ,u sing the command
# specified by the $lualatex variable.  If equal to 5, generate a pdf version (and an xdv version)
# of the document using xelatex ,using the
# commands speci- fied by the $xelatex and xdvipdfmx variables.  In $pdf_mode =2,
# it is ensured that .dvi and .ps files are also made.  In $pdf_mode =3, it is
# ensured that a .dvi file is also made.