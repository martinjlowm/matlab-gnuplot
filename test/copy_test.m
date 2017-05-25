gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua');

key = gpl.getKey();
key.setAnchor('left', 'top');

gpl_copy = gpl.copy();

key_copy = gpl_copy.getKey();
key_copy.setAnchor('right', 'bottom');

output = gpl.execute(false);

shouldExistIn('set key on left top', output);
