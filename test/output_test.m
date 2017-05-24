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
system(sprintf('rm -r %s', fileparts(output_file)));

% Test using output directory
output_directory = 'test/dir-does-not-exist';
output_file = 'output_test.pdf';

gpl.setOutput(output_file);
gpl.setOutputDirectory(output_directory);

gpl.execute();

assert(logical(exist(gpl.m_output, 'file')), 'Output file does not exist!');
system(sprintf('rm -r %s', output_directory));

% Test using nested output directory
nested_output_directory = 'test/dir-does-not-exist/nor-this-one';
output_file = 'output_test.pdf';

gpl.setOutput(output_file);
gpl.setOutputDirectory(nested_output_directory);

gpl.execute();

assert(logical(exist(gpl.m_output, 'file')), 'Output file does not exist!');
system(sprintf('rm -r %s', output_directory));
