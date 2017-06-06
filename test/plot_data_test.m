gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua');

y_axis = gpl.getAxis('y');
y_axis.setLogScale(true);

gpl.setTitle('Exponential functions');
ydata = exp(1:10);
gpl.plot(ydata);

xdata = 1:0.1:10;
ydata = exp(xdata);
gpl.plot(xdata, ydata);

output = gpl.execute(true);

shouldExistIn('set title "Exponential functions"', output);
shouldExistIn('set logscale y', output);
shouldExistIn('plot (.*?) using 1:2, (.*?) using 1:2', output);
