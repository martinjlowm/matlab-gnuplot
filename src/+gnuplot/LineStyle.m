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

classdef LineStyle < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    m_index;

    m_line_type;
    m_line_color;
    m_line_width;
    m_point_type;
    m_point_size;
    m_point_interval;
    m_dash_type;
    m_palette;
  end


  %% Constructors
  methods (Access = ?gnuplot.Gnuplot)
    function this = LineStyle(index)
      this.m_index = index;

      this.m_line_type = index;
      this.m_line_color = gnuplot.Colorspec();
      this.m_line_width = '';
      this.m_point_type = '';
      this.m_point_size = '';
      this.m_point_interval = '';
      this.m_dash_type = '';
      this.m_palette = '';
    end
  end


  %% Getters
  methods
    function index = getIndex(this)
      index = this.m_index;
    end
  end


  %% Setters
  methods
    function setLineType(this, type_or_color)
      if isa(type_or_color, 'double')
        this.m_line_type = type_or_color;
      else
        this.setLineColor(type_or_color)
      end
    end

    function setLineColor(this, color)
      this.m_line_color.set(color);
    end

    function setLineWidth(this, width)
      this.m_line_width = width;
    end

    function setPointType(this, type)
      this.m_point_type = type;
    end

    function setPointSize(this, size)
      this.m_point_size = size;
    end

    function setPointInterval(this, interval)
      this.m_point_interval = interval;
    end

    function setDashType(this, type)
      this.m_dash_type = type;
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      fragments = [fragments, sprintf('set style line %d', this.m_index)];

      if ~isempty(this.m_line_type)
        fragments = [fragments, sprintf('linetype %d', this.m_line_type)];
      end

      color = this.m_line_color.toString();
      if ~isempty(color)
        fragments = [fragments, sprintf('linecolor %s', color)];
      end

      if ~isempty(this.m_line_width)
        fragments = [fragments, sprintf('linewidth %d', this.m_line_width)];
      end

      if ~isempty(this.m_point_type)
        fragments = [fragments, sprintf('pointtype %d', this.m_point_type)];
      end

      if ~isempty(this.m_point_size)
        fragments = [fragments, sprintf('pointsize %d', this.m_point_size)];
      end

      if ~isempty(this.m_point_interval)
        fragments = [fragments, sprintf('pointinterval %d', this.m_point_interval)];
      end

      if ~isempty(this.m_dash_type)
        fragments = [fragments, sprintf('dashtype %d', this.m_dash_type)];
      end

      str = strjoin(fragments, ' ');
    end
  end

end