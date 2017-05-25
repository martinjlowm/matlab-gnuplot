gpl = gnuplot.Gnuplot();
gpl.setTerminal('aqua');


from = gpl.createLabel();
from.setText('This is a label pointed from');
from.setPosition(3, 1);
from.setAlignment('right');

to = gpl.createLabel();
to.setText('This is a label pointed to');
to.setPosition(5, 2);

arrow = gpl.createArrow();
arrow.pointFrom(from);
arrow.pointTo(to);

gpl.plot('x');

output = gpl.execute(false);

shouldExistIn('set arrow 1 from 3, 1, 0 to 5, 2, 0', output);

gpl.execute();