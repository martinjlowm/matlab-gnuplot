gpl = gnuplot.Gnuplot();

gpl.setTerminal('aqua');

title = gpl.setTitle('Sine wave');
title.setOffset(1, 1);
title.setColor('red');

key = gpl.getKey();
key.setPosition('outside');

x_axis = gpl.getAxis('x');
x_axis.setLabel('$x$');
x_axis.setRange(0:10);

range = gnuplot.Range();
range.set(0:2);

gpl.plot('sin(x)');
gpl.plot(range, 'cos(x)');
output = gpl.execute(false);

shouldExistIn('set terminal aqua', output);
shouldExistIn('set title "Sine wave" offset 1, 1, 0 textcolor rgbcolor "red"', output);
shouldExistIn('set xlabel "\$x\$"', output);
shouldExistIn('set xrange \[0:10\]', output);
shouldNotExistIn('set yrange', output);
shouldNotExistIn('set zrange', output);
shouldExistIn('plot \[0:2\] sin\(x\), cos\(x\)', output);
