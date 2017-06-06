gpl = gnuplot.Gnuplot();

gpl.setTerminal('aqua');

f = @(x) 3 * cos(x);

title = gpl.setTitle('Anonymous MATLAB function');

x_axis = gpl.getAxis('x');
x_axis.setLabel('x');

y_axis = gpl.getAxis('y');
y_axis.setLabel('f(x)');

gpl.plot(f);

output = gpl.execute(true);

shouldExistIn('set terminal aqua', output);
shouldExistIn('set title "Anonymous MATLAB function"', output);
shouldExistIn('set xlabel "x"', output);
shouldExistIn('set ylabel "f\(x\)"', output);
shouldExistIn('plot 3\*cos\(x\)', output);
