gpl = gnuplot.Gnuplot();
gpl.setTerminal('pdf');

% Test script output and file existence when executed
output_file = 'test/output_test.pdf';
gpl.setOutput(output_file);

gpl.plot('x');

output = gpl.execute(false);

shouldExistIn(sprintf('set output "%s"', output_file), output);

gpl.execute();

assert(logical(exist(output_file, 'file')), 'Output file does not exist!');
delete(output_file);

% Test file existence if path doesn't already exist
output_file = 'test/dir-does-not-exist/output_test.pdf';

gpl.setOutput(output_file);

gpl.execute();

assert(logical(exist(output_file, 'file')), 'Output file does not exist!');
delete(output_file);
rmdir(fileparts(output_file));