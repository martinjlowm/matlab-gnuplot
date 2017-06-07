gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua', {'enhanced', 'dashed'});

x_axis = gpl.getAxis('x');
x_axis.setLabel('X Axis');

y_axis = gpl.getAxis('y');
y_axis.setLabel('Y Axis');

line_type = gpl.getLineType(1);
line_type.setColor('#FF0000');

line_type = gpl.getLineType(2);
line_type.setColor('#00FF00');

line_type = gpl.getLineType(3);
line_type.setColor('#0000FF');

gpl.plot('sin(x)');
gpl.plot('cos(x)');
gpl.plot('tan(x)');

output = gpl.execute(true);

shouldExistIn('set linetype 1 linecolor rgbcolor "#FF0000"', output);
shouldExistIn('set linetype 2 linecolor rgbcolor "#00FF00"', output);
shouldExistIn('set linetype 3 linecolor rgbcolor "#0000FF"', output);
