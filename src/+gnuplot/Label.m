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

classdef Label < gnuplot.AxisLabel

  properties (Access = ?gnuplot.Copyable)
    % set label {<tag>} {"<label text>"} {at <position>}
    %           {left | center | right}
    %           {norotate | rotate {by <degrees>}}
    %           {font "<name>{,<size>}"}
    %           {noenhanced}
    %           {front | back}
    %           {textcolor <colorspec>}
    %           {point <pointstyle> | nopoint}
    %           {offset <offset>}
    %           {boxed}
    %           {hypertext}
    % unset label {<tag>}
    m_tag;
    m_position;
    m_alignment;
    m_draw_layer;

    m_point;
    m_boxed;
    m_hypertext;
  end


  %% Constructors
  methods
    function this = Label()
      this.m_tag = '';
      this.m_position = gnuplot.Position();
      this.m_alignment = '';
      this.m_draw_layer = gnuplot.DrawLayer();
      this.m_offset = gnuplot.Position();
      this.m_boxed = false;
      this.m_hypertext = false;
    end
  end


  %% Getters
  methods
    function position = getPosition(this)
      position = this.m_position;
    end
  end


  %% Setters
  methods
    function setPosition(this, varargin)
      this.m_position.set(varargin{:})
    end

    function setTag(this, value)
      this.m_tag = value;
    end

    function setAlignment(this, alignment)
      this.m_alignment = alignment;
    end

    function setBoxed(this, state)
      this.m_boxed = state;
    end

    function setHypertext(this, state)
      this.m_hypertext = state;
    end

    function setDrawLayer(this, layer)
      this.m_draw_layer.set(layer);
    end

    function setOffset(this, varargin)
      this.m_offset.set(varargin{:});
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      axis_fragments = this.collectFragments();

      if ~isempty(axis_fragments)
        fragments = {};

        fragments = [fragments, axis_fragments{1}];

        if ~isempty(this.m_tag)
          fragments = [fragments, num2str(this.m_tag)];
        end

        fragments = [fragments, axis_fragments{2}];
        fragments = [fragments, sprintf('at %s', ...
                                        this.m_position.toString())];
        if ~isempty(this.m_alignment)
          fragments = [fragments, this.m_alignment];
        end

        fragments = [fragments, this.m_draw_layer.toString()];

        offset = this.m_offset.toString();
        if ~isempty(offset)
          fragments = [fragments, sprintf('offset %s', offset)];
        end

        if this.m_boxed
          fragments = [fragments, 'boxed'];
        end

        if this.m_hypertext
          fragments = [fragments, 'hypertext'];
        end

        str = strjoin(fragments, ' ');
      else
        str = '';
      end
    end
  end

end