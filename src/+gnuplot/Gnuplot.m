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

classdef Gnuplot < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    m_program;
    m_version;

    m_term;
    m_term_options;

    m_output;

    m_key;

    m_title;

    m_axes;

    m_line_styles;

    m_stats;
    m_labels;

    m_ranges;
    m_plot_elements;
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
      gnuplot.is_color(this);

      this.m_term = '';
      this.m_term_options = {};

      this.m_title = gnuplot.Title();
      this.m_key = gnuplot.Key();

      this.m_axes = struct;
      this.m_axes.x = gnuplot.Axis('x');
      this.m_axes.y = gnuplot.Axis('y');
      this.m_axes.z = gnuplot.Axis('z');

      this.m_line_styles = {};

      this.m_stats = {};
      this.m_labels = {};

      this.m_ranges = {};
      this.m_plot_elements = {};
    end
  end


  %% Getters
  methods
    function axis = getAxis(this, type)
      axis = this.m_axes.(type);
    end

    function style = getLineStyle(this, index)
      try
        style = this.m_line_styles{index};
      catch exception
        if strcmp(exception.identifier, 'MATLAB:badsubscript')
          style = gnuplot.LineStyle(index);
          this.m_line_styles{index} = style;
        end
      end
    end
  end


  %% Setters
  methods
    function setOutput(this, output)
      this.m_output = output;
    end

    function setTerminal(this, terminal, options)
      if nargin > 1
        if strcmp(terminal, 'aqua')
          system('pkill AquaTerm');
        end

        this.m_term = terminal;

        if exist('options', 'var')
          this.m_term_options = options;
        end
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
      this.m_title.setText(title);

      m_title = this.m_title;
    end
  end


  %% Other methods
  methods
    % TODO: Consider create methods through inheritance
    function label = createLabel(this)
      label = gnuplot.Label();
      this.m_labels = [this.m_labels, label];
      label.setTag(length(this.m_labels));
    end

    function data_stats = stats(this, varargin)
      data_stats = gnuplot.DataStats(varargin{:});
      this.m_stats = [this.m_stats, data_stats];
      data_stats.setID(length(this.m_stats));
    end

    function output = execute(this, do_execute)
      if nargin == 1
        do_execute = true;
      end

      fragments = {};

      % Terminal
      if ~isempty(this.m_term)
        term = sprintf('set terminal %s', this.m_term);
        options = strjoin(this.m_term_options, ' ');
        fragments = [fragments, sprintf('%s %s', term, options)
                     ];
      end

      % Stats
      num_stats = length(this.m_stats);
      stats_fragments = cell(1, num_stats);
      for i = 1:num_stats
        stats_fragments{i} = this.m_stats(i).toString();
      end
      fragments = [fragments, strjoin(stats_fragments, '\n')];

      % Title
      fragments = [fragments, this.m_title.toString()];

      % Axes
      fragments = [fragments, this.m_axes.x.toString()];
      fragments = [fragments, this.m_axes.y.toString()];
      fragments = [fragments, this.m_axes.z.toString()];

      % Key
      fragments = [fragments, this.m_key.toString()];

      % Line styles
      num_line_styles = length(this.m_line_styles);
      line_style_fragments = cell(1, num_line_styles);
      for i = 1:num_line_styles
        line_style = this.m_line_styles{i};
        if ~isempty(line_style)
          line_style_fragments{i} = line_style.toString();
        end
      end

      fragments = [fragments, ...
                   strjoin(filter_empty(line_style_fragments), '\n')];

      % Labels
      % TODO: Refactor the following loops
      num_labels = length(this.m_labels);
      label_fragments = cell(1, num_labels);
      for i = 1:num_labels
        label_fragments{i} = this.m_labels(i).toString();
      end
      fragments = [fragments, strjoin(label_fragments, '\n')];

      % Ranges and plots
      num_ranges = length(this.m_ranges);
      range_fragments = cell(1, num_ranges);
      for i = 1:num_ranges
        range_fragments{i} = [this.m_ranges(i).toString(), ' '];
      end

      num_plot_elements = length(this.m_plot_elements);
      plot_fragments = cell(1, num_plot_elements);
      for i = 1:num_plot_elements
        plot_fragments{i} = this.m_plot_elements(i).toString();
      end

      ranges = strjoin(range_fragments, '');
      plots = strjoin(plot_fragments, ', ');
      fragments = [fragments, ...
                   sprintf('plot %s%s', ranges, plots)];

      commands = strjoin(fragments, '\n');
      if do_execute
        this.invoke(commands);

        this.m_output = '';
        this.m_plot_elements = {};
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
                        'gnuplot ([\d\.]*) patchlevel (\d*)', 'tokens'));

      this.m_version = sprintf('%s-%s', version{:}, patchlevel{:});
    end

    function plot_element = plot(this, varargin)
      args = varargin;
      if isa(args{1}, 'gnuplot.Range')
        this.m_ranges = [this.m_ranges, args{1}];
        args = {args{2:end}};
      end

      plot_element = gnuplot.PlotElement();
      plot_element.set(args{:});

      this.m_plot_elements = [this.m_plot_elements, plot_element];
    end

    function [status, stdout] = run(this, arguments)
      [status, stdout] = ...
          system(sprintf('%s %s', this.m_program, arguments));
    end
  end

end