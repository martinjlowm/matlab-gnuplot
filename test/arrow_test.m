gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua');

% Test pointing from one label to another
from = gpl.createLabel();
from.setText('This is a label pointed from');
from.setPosition(3, 1);
from.setOffset(-1);
from.setAlignment('right');

to = gpl.createLabel();
to.setText('This is a label pointed to');
to.setPosition('graph', 0.5, 'graph', 0.8);
to.setOffset(1);

arrow = gpl.createArrow();
arrow.pointFrom(from);
arrow.pointTo(to);

gpl.plot('x');

output = gpl.execute(true);

shouldExistIn('set arrow 1 from 3, 1, 0 to graph 0.5, graph 0.8, 0', output);

% Test arrow style
arrow_style = gpl.getArrowStyle(1);
arrow_style.setHeads('backhead');

gpl.plot('x');

output = gpl.execute(true);

shouldExistIn('set style arrow 1 backhead', output);
