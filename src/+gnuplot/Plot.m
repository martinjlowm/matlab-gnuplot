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

classdef Plot < handle

  properties (Access = private)
    m_ranges;
    m_source; % Function or data file
  end


  %% Constructors
  methods (Access = ?gnuplot.Gnuplot)
    function this = Plot(varargin)
      this.m_ranges = {};

      i = 1;
      while i <= nargin
        arg = varargin{i};
        if isa(arg, 'gnuplot.Range')
          this.m_ranges = [this.m_ranges, varargin{i}];
        elseif isa(arg, 'char')
          % Either a datafile or a function
          if exist(arg, 'file')
            arg = sprintf('''%s''', arg);
          end
          this.m_source = arg;
        elseif isa(arg, 'function_handle')
          % Support plotting of MATLAB functions
          [~, this.m_source] = unpack(regexp(func2str(arg), ...
                                             '@\((.*?)\)(.+)', 'tokens'));
        elseif isa(arg, 'double')
          % Plot data vector

          if (i + 1 > nargin) || ~isa(varargin{i + 1}, 'double')
            y_data = arg;
            x_data = 1:length(y_data);
          else
            x_data = arg;
            y_data = varargin{i + 1};
            i = i + 1;
          end

          assert(isequal(length(x_data), length(y_data)), ...
                 'Vectors must be the same length');

          this.m_source = ...
              sprintf('"%s" using 1:2', gnuplot.writeTempDataFile(x_data, y_data));
        end

        i = i + 1;
      end
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      num_ranges = length(this.m_ranges);
      if num_ranges > 0
        ranges_fragments = cell(1, num_ranges);
        for i = 1:num_ranges
          ranges_fragments{i} = this.m_ranges(i).toString();
        end

        fragments = [fragments, strjoin(ranges_fragments, ' ')];
      end

      fragments = [fragments, this.m_source];

      str = strjoin(fragments, ' ');
    end
  end

end