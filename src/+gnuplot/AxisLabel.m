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

classdef AxisLabel < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % set xlabel {"<label>"} {offset <offset>} {font "<font>{,<size>}"}
    %            {textcolor <colorspec>} {{no}enhanced}
    %            {rotate by <degrees> | rotate parallel | norotate}
    % show xlabel
    m_type;

    m_text;
    m_offset;
    m_font;
    m_color;

    m_enhanced;
    m_rotation;
  end


  %% Constructors
  methods
    function this = AxisLabel(type)
      if ~exist('type', 'var')
        type = '';
      end

      this.m_type = type;
      this.m_text = gnuplot.Text();
      this.m_font = gnuplot.Font();
      this.m_offset = gnuplot.CoordinateSet();
      this.m_color = gnuplot.Colorspec();
    end
  end


  %% Setters
  methods
    function setText(this, varargin)
      this.m_text.set(varargin{:})
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = this.collectFragments();

      str = strjoin(fragments, ' ');
    end
  end

  methods (Access = protected)
    function fragments = collectFragments(this)
      fragments = {};

      text = this.m_text.toString();
      if ~isempty(text)
        fragments = [fragments, sprintf('set %slabel', this.m_type)];

        fragments = [fragments, text];

        offset = this.m_offset.toString();
        if ~isempty(offset)
          fragments = [fragments, offset];
        end

        font = this.m_font.toString();
        if ~isempty(font)
          fragments = [fragments, font];
        end

        color = this.m_color.toString();
        if ~isempty(color)
          fragments = [fragments, color];
        end
      end
    end
  end

end