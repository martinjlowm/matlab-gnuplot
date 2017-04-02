function matlab_gnuplot(varargin)
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
    fprintf(1, 'Initializing MATLAB-Gnuplot\n');
    addpath([path, 'src/']);

    GNUPLOT = true;
  end

  if run_tests
    fprintf(1, 'Running tests\n');
    addpath([path, 'test/']);

    test_files = dir([path, 'test/*.m']);
    for file_idx = 1:length(test_files)
      file = test_files(file_idx);
      test = file.name(1:(end - 2));
      fprintf('%s', test);
      test = str2func(test);
      test();
      fprintf(' - DONE\n');
    end
  end
end