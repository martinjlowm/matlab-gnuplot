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

classdef ElementCreator < gnuplot.Copyable

  properties (Access = {?gnuplot.Copyable, ?gnuplot.Gnuplot})
    m_title;
    m_key;

    m_arrow_styles;
    m_line_styles;
    m_data_stats;

    m_labels;
    m_arrows;

    m_axes;

    m_ranges;
    m_plot_elements;
  end


  %% Constructors
  methods (Access = ?gnuplot.Gnuplot)
    function this = ElementCreator()
      this.m_title = gnuplot.Title();
      this.m_key = gnuplot.Key();

      this.m_arrow_styles = {};
      this.m_line_styles = {};
      this.m_data_stats = gnuplot.DataStats.empty();

      this.m_labels = gnuplot.Label.empty();
      this.m_arrows = gnuplot.Arrow.empty();

      this.m_axes = struct;
      this.m_axes.x = gnuplot.Axis('x');
      this.m_axes.y = gnuplot.Axis('y');
      this.m_axes.z = gnuplot.Axis('z');

      this.m_ranges = gnuplot.Range.empty();
      this.m_plot_elements = gnuplot.PlotElement.empty();
    end
  end


  methods
    function arrow = createArrow(this)
      arrow = gnuplot.Arrow();
      this.m_arrows = [this.m_arrows, arrow];
      arrow.setTag(length(this.m_arrows));
    end

    function label = createLabel(this)
      label = gnuplot.Label();
      this.m_labels = [this.m_labels, label];
      label.setTag(length(this.m_labels));
    end

    function axis = getAxis(this, type)
      axis = this.m_axes.(type);
    end

    function key = getKey(this)
      this.m_key.enable();

      key = this.m_key;
    end

    function data_stats = getStats(this, varargin)
      data_stats = gnuplot.DataStats(varargin{:});
      this.m_data_stats = [this.m_data_stats, data_stats];
      data_stats.setID(length(this.m_data_stats));
    end

    function style = getStyle(this, field, constructor, index)
      try
        style = this.(field)(index);
      catch exception
        if strcmp(exception.identifier, 'MATLAB:badsubscript')
          style = constructor(index);
          this.(field){index} = style;
        end
      end
    end

    function style = getArrowStyle(this, index)
      style = this.getStyle('m_arrow_styles', @gnuplot.ArrowStyle, index);
    end

    function style = getLineStyle(this, index)
      style = this.getStyle('m_line_styles', @gnuplot.LineStyle, index);
    end

    function plot_element = plot(this, varargin)
      args = varargin;
      if isa(args{1}, 'gnuplot.Range')
        this.m_ranges = [args{1}];
        args = {args{2:end}};
      end

      plot_element = gnuplot.PlotElement();
      plot_element.set(args{:});

      this.m_plot_elements = [this.m_plot_elements, plot_element];
    end

    function m_title = setTitle(this, title)
      this.m_title.setText(title);

      m_title = this.m_title;
    end

  end

end