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

  properties (Access = private)
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
    m_anchor;
    m_level;
    m_point;
    m_boxed;
    m_hypertext;
  end


  %% Constructors
  methods
    function this = Label()
      this.m_position = gnuplot.Position();
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
  end


  %% Other methods
  methods
    function str = toString(this)
      axis_fragments = this.collectFragments();

      if ~isempty(axis_fragments)
        fragments = {};

        fragments = [fragments, axis_fragments{1}];
        fragments = [fragments, num2str(this.m_tag)];
        fragments = [fragments, axis_fragments{2}];
        fragments = [fragments, this.m_position.toString()];

        str = strjoin(fragments, ' ');
      else
        str = '';
      end
    end
  end

end