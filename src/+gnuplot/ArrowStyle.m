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

classdef ArrowStyle < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % set style arrow <index> {nohead | head | heads}
    %                         {size <length>,<angle>{,<backangle>} {fixed}}
    %                         {filled | empty | nofilled | noborder}
    %                         {front | back}
    %                         { {linestyle | ls <line_style>}
    %                           | {linetype | lt <line_type>}
    %                             {linewidth | lw <line_width}
    %                             {linecolor | lc <colorspec>}
    %                             {dashtype | dt <dashtype>} }
    m_index;

    m_heads;
    m_heads_size;
    m_contour;
    m_draw_layer;

    m_line_style;

    m_line_type;
    m_line_width;
    m_line_color;
    m_dash_type;
  end


  %% Constructors
  methods
    function this = ArrowStyle(index)
      this.m_index = index;
      this.m_heads = '';
      this.m_heads_size = gnuplot.ArrowHeadSize();
      this.m_draw_layer = gnuplot.DrawLayer();
    end
  end


  %% Setters
  methods
    function setHeads(this, heads)
      gnuplot.assert(nargin == 2, 'Heads must be specified!');
      gnuplot.assert(gnuplot.match(heads, 'nohead|head|backhead|heads'), ...
                     'Usage: {nohead | head | backhead | heads}');

      this.m_heads = heads;
    end

    function setHeadsSize(this, varargin)
      this.m_heads_size.set(varargin{:});
    end

    function setContour(this, contour)
      valid_contour = gnuplot.match(contour, ...
                                    'filled|empty|nofilled|noborder');
      gnuplot.assert(valid_contour, ...
                     'Usage: {filled | empty | nofilled | noborder}');

      this.m_contour = contour;
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      fragments = [fragments, sprintf('set style arrow %d', this.m_index)];

      if ~isempty(this.m_heads)
        fragments = [fragments, this.m_heads];
      end

      heads_size = this.m_heads_size.toString();
      if ~isempty(heads_size)
        fragments = [fragments, heads_size];
      end

      if ~isempty(this.m_contour)
        fragments = [fragments, this.m_contour];
      end

      fragments = [fragments, this.m_draw_layer.toString()];

      str = strjoin(fragments, ' ');
    end
  end

end