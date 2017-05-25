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

classdef Arrow < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % set arrow {<tag>} from <position> to <position>
    % set arrow {<tag>} from <position> rto <position>
    % set arrow {<tag>} from <position> length <coord> angle <ang>
    % set arrow <tag> arrowstyle | as <arrow_style>
    % set arrow <tag> {nohead | head | backhead | heads}
    %                 {size <headlength>,<headangle>{,<backangle>}}
    %                 {filled | empty | nofilled | noborder}
    %                 {front | back}
    %                 {linestyle <line_style>}
    %                 {linetype <line_type>} {linewidth <line_width>}
    %                 {linecolor <colorspec>} {dashtype <dashtype>}
    m_tag;
    m_from_position;
    m_to_position;
    m_anchor;
    m_level;
    m_point;
    m_boxed;
    m_hypertext;
  end


  methods (Static)
    function position = Point(varargin)
      assert(length(varargin) >= 1, ...
             'The position pointed to or from cannot be empty!');

      if isa(varargin{1}, 'gnuplot.Label')
        position = varargin{1}.getPosition();
      elseif isa(varargin{1}, 'gnuplot.Position')
        position = varargin{1};
      else
        position = gnuplot.Position();
        position.set(varargin{:});
      end
    end
  end


  %% Constructors
  methods
    function this = Arrow()
      this.m_tag = '';
      this.m_from_position = '';
      this.m_to_position = '';
    end
  end


  %% Setters
  methods
    function setTag(this, tag)
      this.m_tag = tag;
    end

    function pointFrom(this, varargin)
      this.m_from_position = gnuplot.Arrow.Point(varargin{:});
    end

    function pointTo(this, varargin)
      this.m_to_position = gnuplot.Arrow.Point(varargin{:});
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      fragments = [fragments, 'set arrow'];

      fragments = [fragments, sprintf('%d', this.m_tag)];

      if ~isempty(this.m_from_position) && ~isempty(this.m_to_position)
        fragments = [fragments, ...
                     sprintf('from %s', this.m_from_position.toString())];
        fragments = [fragments, ...
                     sprintf('to %s', this.m_to_position.toString())];
      end

      str = strjoin(fragments, ' ');
    end
  end

end