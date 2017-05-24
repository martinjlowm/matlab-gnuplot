gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua');

x_data = .2 * randn(1, 20);
y_data = .5 * randn(1, 20);

max_val = max(max(x_data, y_data));

% Test x and y range of `[0:max_val]'
x_axis = gpl.getAxis('x');
x_axis.setRange(0, max_val);
y_axis = gpl.getAxis('y');
y_axis.setRange(0, max_val);

gpl.plot(x_data, y_data);

output = gpl.execute(false);


shouldExistIn(escape(sprintf('set xrange [0:%d]', max_val)), output);
shouldExistIn(escape(sprintf('set yrange [0:%d]', max_val)), output);

% Test `[0:10]' with vector
x_axis = gpl.getAxis('x');
x_axis.setRange(0:10);

output = gpl.execute(false);

shouldExistIn('set xrange \[0:10\]', output);

% Test `[-pi:pi]'
x_range = gnuplot.Range();
x_range.set(-pi:pi:pi);

gpl.plot(x_range, x_data, y_data);

output = gpl.execute(false);

shouldExistIn(escape(sprintf('plot [%d:%d]', -pi, pi)), output);

% Test `[-pi:pi] [-eps:eps]' with vector
y_range = gnuplot.Range();
y_range.set(-eps:eps:eps);

gpl.plot([x_range, y_range], x_data, y_data);

output = gpl.execute(false);

shouldExistIn(escape(sprintf('plot [%d:%d] [%d:%d]', -pi, pi, -eps, eps)), ...
              output);

% Test `[]' without arguments
x_range.set();

gpl.plot([x_range, y_range], x_data, y_data);

output = gpl.execute(false);

shouldExistIn('plot \[\]', output);

% Test `[:pi]' with NaN and max value
x_range.set('', pi);

gpl.plot(x_range, x_data, y_data);

output = gpl.execute(false);

shouldExistIn(escape(sprintf('plot [:%d]', pi)), output);

% Test `[-pi:]' with min value and NaN
x_range.set(-pi, '');

gpl.plot(x_range, x_data, y_data);

output = gpl.execute(false);

shouldExistIn(escape(sprintf('plot [%d:]', -pi)), output);
