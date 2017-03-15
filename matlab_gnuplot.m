function matlab_gnuplot(varargin)
  mlock;
  persistent GNUPLOT;
  if isempty(GNUPLOT)
    GNUPLOT = false;
  end

  run_tests = false;
  if nargin > 0
    run_tests = varargin{1};
  end

  if ~GNUPLOT
    fprintf(1, 'Initializing MATLAB-Gnuplot\n');
    addpath('src/');

    GNUPLOT = true;
  end

  if run_tests
    fprintf(1, 'Running tests\n');
    addpath('test/');

    for file = dir('test/*.m')
      test = file.name(1:(end - 2));
      fprintf('%s', test);
      script = str2func(test);
      script();
      fprintf(' - DONE\n');
    end
  end
end