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

classdef Axis < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    m_type;
    m_range;
    m_format;
    m_label;

    m_logscale;
  end


  %% Constructors
  methods (Access = ?gnuplot.Gnuplot)
    function this = Axis(type)
      this.m_type = type;
      this.m_range = gnuplot.Range(type);
      this.m_format = '% h';
      this.m_label = gnuplot.AxisLabel(type);
      this.m_logscale = false;
    end
  end


  %% Getters
  methods
    function format = getFormat(this)
      format = this.m_format;
    end

    function range = getRange(this)
      range = this.m_range;
    end
  end


  %% Setters
  methods
    function setFormat(this, format)
      assert(nargin > 1, 'Axis format must be specified!');
      assert(~isempty(format), 'Axis format cannot be empty!');

      this.m_format = format;
    end

    function setRange(this, varargin)
      this.m_range.set(varargin{:});
    end

    function setLabel(this, varargin)
      this.m_label.setText(varargin{:});
    end

    function setLogScale(this, state)
      this.m_logscale = state;
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      label = this.m_label.toString();
      if ~isempty(label)
        fragments = [fragments, label];
      end

      range = this.m_range.toString();
      if ~isempty(range)
        fragments = [fragments, range];
      end

      if this.m_logscale
        fragments = [fragments, sprintf('set logscale %s', this.m_type)];
      end

      str = strjoin(fragments, '\n');
    end
  end

end