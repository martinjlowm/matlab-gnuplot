function gnuplot(varargin)
  mlock;
  global GNUPLOT;
  if isempty(GNUPLOT)
    GNUPLOT = false;
  end
  path = fileparts(mfilename('fullpath'));
  if ~isempty(path)
    path = [path, '/'];
  end

  run_tests = false;
  if nargin > 0
    run_tests = varargin{1};
  end

  if ~GNUPLOT
    addpath([path, 'src/']);
    gnuplot.log('MATLAB-Gnuplot has been initialized!');
    gnuplot.log('To instantiate an object, use `gpl = gnuplot.Gnuplot();''');

    GNUPLOT = true;
  end

  if run_tests
    gnuplot.log('Running tests');
    addpath([path, 'test/']);
    addpath([path, 'test/helper_functions']);

    test_files = dir([path, 'test/*.m']);
    for file_idx = 1:length(test_files)
      file = test_files(file_idx);
      test = file.name(1:(end - 2));
      fprintf('%s', test);
      test = str2func(test);
      test();
      fprintf(' ✓\n');
    end
  end
end