# Gnuplot interface for MATLAB #

Allows you to plot wonderful Gnuplot graphs directly from MATLAB without
any external Gnuplot scripts.

## Installation ##

Add the root of this library to your MATLAB path, e.g.,
`addpath('/home/user/matlab_libs/matlab-gnuplot/')`.

## Usage ##

```matlab
matlab_gnuplot; % Initialize

gpl = gnuplot.Gnuplot();
gpl.setTerminal('tikz');
gpl.setOutput('sin_x.tex');
gpl.plot('sin(x)');
gpl.execute();
```

The `test/` directory contains several other examples on how to use this
library.

Invoking `gpl.setTerminal()` without arguments lists all available terminals of
your Gnuplot installation.
