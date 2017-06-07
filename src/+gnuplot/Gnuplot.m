% Documentation is available at:
%   https://github.com/martinjlowm/matlab-gnuplot/wiki

%{
Copyright 2017 Martin Jesper Low Madsen <martin@martinjlowm.dk>

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%}

classdef Gnuplot < gnuplot.ElementCreator

  properties
    program;
    version;

    terminal;

    output;
  end


  methods (Static)
    function str = CollectFragments(array, separator)
      if ~logical(exist('separator', 'var'))
        separator = '\n';
      end

      num_items = length(array);
      fragments = cell(1, num_items);
      for i = 1:num_items
        item = array(i);
        if ~isempty(item)
          fragments{i} = item.toString();
        end
      end

      str = strjoin(fragments, separator);
    end

    function is_local = CheckCallee()
      is_local = false;

      callee = dbstack;
      if length(callee) > 2
        callee = callee(2).name;

        valid_callee = strsplit(mfilename('class'), '.');
        valid_callee = valid_callee{end};
        is_local = strncmp(callee, valid_callee, ...
                           length(valid_callee));
      end
    end
  end


  %% Getters
  methods
    function str = get.terminal(this)
      if gnuplot.Gnuplot.CheckCallee()
        str = this.terminal;
      else
        options = this.terminal.getOptions();
        if ~isempty(options)
          options = sprintf(' with options: %s', options);
        end

        str = sprintf('Terminal is "%s"%s', ...
                      this.terminal.get(), options);
      end
    end

    function str = get.output(this)
      if gnuplot.Gnuplot.CheckCallee()
        str = this.output;
      else
        str = sprintf('Output is "%s"', this.output.toString());
      end
    end
  end

  %% Constructors
  methods
    function this = Gnuplot(binary_path)
      if logical(nargin)
        this.program = binary_path;
      else
        this.program = 'gnuplot';
      end

      assert(this.isInstalled(), ...
             sprintf(['Unable to find `%s''.', ...
                      'Make sure Gnuplot is installed!'], this.program));

      % Stores supported Gnuplot color names in a persistent variable.
      % Confusing, I know...
      gnuplot.is_color(this);

      this.terminal = gnuplot.Terminal();
      this.output = gnuplot.Output();
    end
  end


  %% Setters
  methods
    function setOutput(this, file)
      this.output.set(file);
    end

    function setOutputDirectory(this, directory)
      this.output.setDirectory(directory);
    end

    function setTerminal(this, term, options)
      if nargin == 1
        terminals = this.invoke('set terminal');
        terminals = strrep(terminals, 'Press return for more: ', '');
        terminals = strrep(terminals, '\s', '\\s');
        terminals = strip(terminals, 'both', newline);
        gnuplot.log(terminals);
      else
        if ~logical(exist('options', 'var'))
          options = {};
        end

        this.terminal.set(term, options);
      end
    end
  end


  %% Other methods
  methods
    function commands = buildCommands(this)
      fragments = {};

      % Terminal
      fragments = [fragments, this.terminal.toString()];

      % Output
      file_output = this.output.toString();
      if ~isempty(file_output)
        fragments = [fragments, ...
                     sprintf('set output "%s"', file_output)];
      end

      % Stats
      fragments = [fragments, ...
                   gnuplot.Gnuplot.CollectFragments(this.m_data_stats)];

      % Title
      fragments = [fragments, this.m_title.toString()];

      % Axes
      fragments = [fragments, this.m_axes.x.toString()];
      fragments = [fragments, this.m_axes.y.toString()];
      fragments = [fragments, this.m_axes.z.toString()];

      % Key
      fragments = [fragments, this.m_key.toString()];

      % Line types
      fragments = [fragments, ...
                   gnuplot.Gnuplot.CollectFragments([this.m_line_types{:}])];

      % Line styles
      fragments = [fragments, ...
                   gnuplot.Gnuplot.CollectFragments([this.m_line_styles{:}])];

      % Arrow styles
      fragments = [fragments, ...
                   gnuplot.Gnuplot.CollectFragments([this.m_arrow_styles{:}])];

      % Labels
      fragments = [fragments, ...
                   gnuplot.Gnuplot.CollectFragments(this.m_labels)];

      % Arrows
      fragments = [fragments, ...
                   gnuplot.Gnuplot.CollectFragments(this.m_arrows)];

      % Ranges and plot elements
      ranges = gnuplot.Gnuplot.CollectFragments(this.m_ranges, ' ');
      if ~isempty(ranges)
        ranges = [ranges, ' '];
      end
      plots = gnuplot.Gnuplot.CollectFragments(this.m_plot_elements, ', ');

      fragments = [fragments, sprintf('plot %s%s', ranges, plots)];

      commands = strjoin(fragments, '\n');
    end

    function output = execute(this, debug_flag)
      commands = this.buildCommands();

      if ~logical(exist('debug_flag', 'var')) || ~logical(debug_flag)
        if this.preparePath()
          file = this.output.toString();
          if ~isempty(file)
            gnuplot.log('Writing output to file: `%s'' using %s terminal', ...
                        file, this.terminal.get());
          end

          this.invoke(commands);
        else
          return
        end

        this.setOutput('');
        this.m_plot_elements = {};
      end

      output = commands;
    end

    function stdout = invoke(this, commands)
      [~, stdout] = this.run(sprintf('<<EOF\n%s\nEOF', commands));
    end

    function installed = isInstalled(this)
      [~, status] = evalc(sprintf('system(''which %s'')', this.program));

      installed = ~logical(status);
      if ~installed
        return
      end

      [~, stdout] = this.run('--version');
      [ver, patchlvl] = ...
          unpack(regexp(stdout, ...
                        'gnuplot ([\d\.]*) patchlevel (\d*)', 'tokens'));

      this.version = sprintf('%s-%s', ver{:}, patchlvl{:});
    end

    function success = preparePath(this)
      success = true;

      file = this.output.toString();
      if ~isempty(file)
        directory = fileparts(file);
        try
          if ~logical(exist(directory, 'dir'))
            mkdir(directory);
          end

          success = true;
        catch exception
          if strcmp(exception, 'MATLAB:MKDIR:OSError')
            gnuplot.log('Failed to prepare path `%s'': Permission denied', ...
                        directory);
            success = false;
          end
        end
      end
    end

    function [status, stdout] = run(this, arguments)
      [status, stdout] = ...
          system(sprintf('%s %s', this.program, arguments));
    end
  end

end