gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua');

key = gpl.enableKey();
key.setAnchor('left', 'top');

gpl_copy = gpl.copy();

key_copy = gpl_copy.enableKey();
key_copy.setAnchor('right', 'bottom');

output = gpl.execute(false);

shouldExistIn('set key on left top', output);
