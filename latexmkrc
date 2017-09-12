$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;
$out_dir = 'build';
$pdflatex .= ' && (cp "%D" "%R.pdf"; echo Output file copied from "%D" to "%R.pdf" in current directory)';
