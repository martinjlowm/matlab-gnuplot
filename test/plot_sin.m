gpl = Gnuplot();
gpl.setTerminal('pdfcairo');
gpl.setOutput('test/output/plot_sin.pdf');

key.position = 'outside';
key.anchor = {'center', 'top'};
key.spacing = 2;
gpl.setKey(key);

gpl.setXLabel('$x$', 'offset -1');
gpl.setXRange(0:10);
gpl.setYRange(-2:2);
gpl.setFormat('y', '%.1e');
gpl.setYLabel('$sin(x)$', 'offset -1');

gpl.setTitle('sin(x)')

gpl.plot('sin(x)')
