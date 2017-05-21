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

classdef Gnuplot < handle

  properties (Access = private)
    m_program;
    m_version;

    m_terminal;

    m_output;

    m_key;

    m_title;

    m_axes;

    m_plots;
  end


  %% Constructors
  methods
    function this = Gnuplot(binary_path)
      if logical(nargin)
        this.m_program = binary_path;
      else
        this.m_program = 'gnuplot';
      end

      assert(this.isInstalled(), ...
             sprintf(['Unable to find `%s''.', ...
                      'Make sure Gnuplot is installed!'], this.m_program));

      % Stores supported Gnuplot color names in a persistent variable.
      % Confusing, I know...
      gnuplot.isColor(this);

      this.m_title = gnuplot.Title();
      this.m_key = gnuplot.Key();

      this.m_axes = struct;
      this.m_axes.x = gnuplot.Axis('x');
      this.m_axes.y = gnuplot.Axis('y');
      this.m_axes.z = gnuplot.Axis('z');

      this.m_plots = {};
    end
  end


  %% Getters
  methods
    function axis = getAxis(this, type)
      axis = this.m_axes.(type);
    end
  end


  %% Setters
  methods
    function setOutput(this, output)
      this.m_output = output;
    end

    function setTerminal(this, terminal)
      if nargin > 1
        this.m_terminal = terminal;
      else
        terms = this.invoke('set terminal');
        terms = strrep(terms, 'Press return for more: ', '');
        terms = strrep(terms, '\s', '\\s');
        terms = strip(terms, 'both', newline);
        gnuplot.log(terms);
      end
    end
  end


  %% Other accessors
  methods
    function key = enableKey(this)
      this.m_key.enable();

      key = this.m_key;
    end

    function m_title = setTitle(this, title)
      this.m_title.set(title);

      m_title = this.m_title;
    end
  end


  %% Other methods
  methods
    function output = execute(this, do_execute)
      if nargin == 1
        do_execute = true;
      end

      fragments = {};

      if ~isempty(this.m_terminal)
        fragments = [fragments, sprintf('set terminal %s', this.m_terminal)];
      end

      fragments = [fragments, this.m_title.toString()];

      fragments = [fragments, this.m_axes.x.toString()];
      fragments = [fragments, this.m_axes.y.toString()];
      fragments = [fragments, this.m_axes.z.toString()];

      num_plots = length(this.m_plots);
      plot_fragments = cell(1, num_plots);
      for i = 1:length(this.m_plots)
        plot_fragments{i} = this.m_plots(i).toString();
      end
      fragments = [fragments, ...
                   sprintf('plot %s', strjoin(plot_fragments, ', '))];

      commands = strjoin(fragments, '\n');
      if do_execute
        this.invoke(commands);
      else
        output = commands;
      end
    end

    function stdout = invoke(this, commands)
      [~, stdout] = this.run(sprintf('<<EOF\n%s\nEOF', commands));
    end

    function installed = isInstalled(this)
      [~, status] = evalc(sprintf('system(''which %s'')', this.m_program));

      installed = ~logical(status);
      if ~installed
        return
      end

      [~, stdout] = this.run('--version');
      [version, patchlevel] = ...
          unpack(regexp(stdout, ...
                        'gnuplot (.*) patchlevel (\d*)', 'tokens'));

      this.m_version = sprintf('%s-%s', version{:}, patchlevel{:});
    end

    function plot(this, varargin)
      this.m_plots = [this.m_plots, gnuplot.Plot(varargin{:})];
    end

    function [status, stdout] = run(this, arguments)
      [status, stdout] = ...
          system(sprintf('%s %s', this.m_program, arguments));
    end
  end

end