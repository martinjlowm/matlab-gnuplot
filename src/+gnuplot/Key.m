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

classdef Key < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % set key {on|off} {default}
    %         {{inside | outside} | {lmargin | rmargin | tmargin | bmargin}
    %          | {at <position>}}
    %         {left | right | center} {top | bottom | center}
    %         {vertical | horizontal} {Left | Right}
    %         {{no}opaque}
    %         {{no}reverse} {{no}invert}
    %         {samplen <sample_length>} {spacing <vertical_spacing>}
    %         {width <width_increment>}
    %         {height <height_increment>}
    %         {{no}autotitle {columnheader}}
    %         {title "<text>"} {{no}enhanced}
    %         {{no}box { {linestyle | ls <line_style>}
    %                    | {linetype | lt <line_type>}
    %                      {linewidth | lw <line_width>}}}
    m_state;

    m_position;
    m_anchor;
    m_growth;        % default: vertical
    m_justification; % default: Right

    m_opaque;
    m_reverse;
    m_invert;

    m_sample_length;

    m_spacing;
    m_width;
    m_height;

    m_autotitle;
    m_title;
    m_box;
  end


  %% Constructors
  methods
    function this = Key()
      this.m_state = '';

      this.m_position = gnuplot.Position();
      this.m_anchor = '';
      this.m_growth = '';
      this.m_justification = '';

      this.m_opaque = false;
      this.m_reverse = '';
      this.m_invert = '';

      this.m_sample_length = '';

      this.m_spacing = '';
      this.m_width = '';
      this.m_height = '';

      this.m_autotitle = '';
      this.m_title = '';
      this.m_box = false;
    end
  end


  %% Setters
  methods
    function setAnchor(this, horizontal, vertical)
      this.m_anchor = sprintf('%s %s', horizontal, vertical);
    end

    function setPosition(this, varargin)
      this.m_position.set(varargin{:});
    end

    function setBox(this)
      this.m_box = true;
    end

    function setOpaque(this)
      this.m_opaque = true;
    end
  end


  %% Other methods
  methods
    function enable(this)
      this.m_state = 'on';
    end

    function str = toString(this)
      fragments = {};

      if ~isempty(this.m_state)
        fragments = [fragments, 'set key'];

        if ~isempty(this.m_state)
          fragments = [fragments, this.m_state];
        end

        position = this.m_position.toString();
        if ~isempty(position)
          fragments = [fragments, position];
        end

        if ~isempty(this.m_anchor)
          fragments = [fragments, this.m_anchor];
        end

        if this.m_box
          fragments = [fragments, 'box'];
        end

        if this.m_opaque
          fragments = [fragments, 'opaque'];
        end

      end

      str = strjoin(fragments, ' ');
    end
  end

end