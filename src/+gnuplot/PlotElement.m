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

classdef PlotElement < handle

  properties (Access = private)
    % plot-element:
    %      {<iteration>}
    %      <definition> | {sampling-range} <function> | <data source>
    %      {axes <axes>} {<title-spec>}
    %      {with <style>}
    m_source; % Function or data file
    m_title;
    m_line_style;
  end


  %% Constructors
  methods (Access = ?gnuplot.Gnuplot)
    function this = PlotElement(varargin)
      this.m_source = '';
      this.m_title = gnuplot.Text();
    end
  end


  %% Setters
  methods
    function set(this, varargin)
      i = 1;

      while i < nargin
        arg = varargin{i};
        if isa(arg, 'char')
          % Either a datafile or a function if it's the first argument
          if exist(arg, 'file')
            this.m_source = gnuplot.DataFile(arg);
          else
            this.m_source = arg;
          end
        elseif isa(arg, 'function_handle')
          % Support plotting of MATLAB functions
          [~, this.m_source] = unpack(regexp(func2str(arg), ...
                                             '@\((.*?)\)(.+)', 'tokens'));
        elseif isa(arg, 'double')
          % Plot data vector

          if (i + 1 >= nargin) || ~isa(varargin{i + 1}, 'double')
            y_data = arg;
            x_data = 1:length(y_data);
          else
            x_data = arg;
            y_data = varargin{i + 1};
            i = i + 1;
          end

          assert(isequal(length(x_data), length(y_data)), ...
                 'Vectors must be the same length');

          % TODO: May need updating for `splot'
          this.m_source = gnuplot.DataFile(x_data, y_data);
        end

        i = i + 1;
      end
    end

    function setLineStyle(this, index)
      if isa(index, 'gnuplot.LineStyle')
        index = index.getIndex();
      end

      this.m_line_style = index;
    end

    function setTitle(this, title)
      this.m_title.set(title);
    end

    function unsetTitle(this)
      this.m_title.set('_NOTITLE_');
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      if isa(this.m_source, 'gnuplot.DataFile')
        source = this.m_source.toString();
      else
        source = this.m_source;
      end
      fragments = [fragments, source];

      title = this.m_title.toString();
      if ~isempty(title)
        if strcmp(title, '_NOTITLE_')
          fragments = [fragments, 'notitle'];
        else
          fragments = [fragments, sprintf('title %s', title)];
        end
      end

      % With

      if ~isempty(this.m_line_style)
        fragments = [fragments, sprintf('linestyle %d', this.m_line_style)];
      end

      str = strjoin(fragments, ' ');
    end
  end

end