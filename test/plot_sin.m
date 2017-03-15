gpl = Gnuplot();
gpl.setTerminal('tikz');
gpl.setOutput('output/plot_sin.tex');

key.position = 'outside';
key.anchor = {'center', 'top'};
key.spacing = 2;
gpl.setKey(key);

gpl.setXLabel('$x$', 'offset -1');
gpl.setXRange(1:10);

gpl.setYLabel('$sin(x)$', 'offset -1');

gpl.plot('sin(x)')
