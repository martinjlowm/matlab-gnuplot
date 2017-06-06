gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua', {'enhanced', 'dashed'});

x_axis = gpl.getAxis('x');
x_axis.setLabel('Targets - y');

y_axis = gpl.getAxis('y');
y_axis.setLabel('Estimates - $\hat{y}$');

key = gpl.getKey();
key.setAnchor('left', 'top');
key.setPosition('inside');
key.setBox();
key.setOpaque();

style_point = gpl.getLineStyle(1);
style_point.setPointType(2);

style_fit = gpl.getLineStyle(2);
style_fit.setLineWidth(2);

style_eq = gpl.getLineStyle(4);
style_eq.setDashType(3);

targets = 1:10;
estimates = targets + .5 * randn(1, 10);
stats = gpl.getStats(estimates, targets);

gpl.setTitle({'Regression with correlation: R = %1.4f', ...
              stats.getCorrelation()});

label = gpl.createLabel();
label.setText('This is a label');
label.setPosition(7, 5);

data_plot = gpl.plot(targets, estimates);
data_plot.setTitle('Data');
data_plot.setLineStyle(style_point);
data_plot.setStyle('lines');

a = stats.getSlope();
b = stats.getIntercept();
fit_plot = gpl.plot(sprintf('%s * x + %s', a, b));
fit_plot.setTitle('Fit');
fit_plot.setLineStyle(style_fit);

plot_element = gpl.plot('x');
plot_element.setTitle('$\hat{y} = y$');
plot_element.setLineStyle(style_eq);

output = gpl.execute(true);

shouldExistIn('stats ''(.*?)'' using 1:2 name "_1"', output);
shouldExistIn('set title (.*?) _1_correlation\)', output);
shouldExistIn('set label 1 (.*?) at 7, 5, 0', output);
shouldExistIn('set style line 1 linetype 1 pointtype 2', output);
shouldExistIn('set style line 2 linetype 2 linewidth 2', output);