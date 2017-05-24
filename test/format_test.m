gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua');

x_data = .2 * randn(1, 20);
y_data = .5 * randn(1, 20);

max_val = max(max(x_data, y_data));

x_axis = gpl.getAxis('x');
x_axis.setRange(0, max_val);
x_axis.setFormat('scientific');

y_axis = gpl.getAxis('y');
y_axis.setRange(0, max_val);
y_axis.setFormat('engineering');

gpl.plot(x_data, y_data);

output = gpl.execute(false);

shouldExistIn('set format x "%h"', output);
shouldExistIn('set format y "%g"', output);
