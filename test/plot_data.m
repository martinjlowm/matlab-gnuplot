gpl = Gnuplot();
gpl.setTerminal('pdfcairo');
gpl.setOutput('test/output/plot_data.pdf');

dat = [1,2,3,4; 1,2,3,4];
gpl.plot(dat)
