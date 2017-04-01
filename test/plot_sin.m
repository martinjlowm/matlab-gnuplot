gpl = Gnuplot();
gpl.setTerminal('pdfcairo');
gpl.setOutput('test/output/plot_sin.pdf');

key.position = 'outside';
key.anchor = {'center', 'top'};
key.spacing = 2;
gpl.setKey(key);

gpl.setLogScale('y');
gpl.setXLabel('$x$', 'offset -1');
gpl.setXRange(1:10);

gpl.setYLabel('$sin(x)$', 'offset -1');

gpl.setTitle('sin(x)')

gpl.plot('sin(x)')
