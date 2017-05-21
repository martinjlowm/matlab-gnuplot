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

classdef Colorspec < handle

  properties (Access = private)
    % ... {linecolor | lc} {"colorname" | <colorspec> | <n>}
    % ... {textcolor | tc} {<colorspec> | {linetype | lt} <n>}
    %
    % rgbcolor "colorname"    # e.g. "blue"
    % rgbcolor "0xRRGGBB"     # string containing hexadecimal constant
    % rgbcolor "0xAARRGGBB"   # string containing hexadecimal constant
    % rgbcolor "#RRGGBB"      # string containing hexadecimal in x11 format
    % rgbcolor "#AARRGGBB"    # string containing hexadecimal in x11 format
    % rgbcolor <integer val>  # integer value representing AARRGGBB
    % rgbcolor variable       # integer value is read from input file
    % palette frac <val>      # <val> runs from 0 to 1
    % palette cb <value>      # <val> lies within cbrange
    % palette z
    % variable                # color index is read from input file
    % bgnd                    # background color
    % black
    m_type; % default: `first'
    m_palette_type;
    m_value;
  end


  %% Constructors
  methods
    function this = Colorspec()
      this.m_value = 0;
      this.m_palette_type = '';
      this.m_type = '';
    end
  end


  %% Setters
  methods
    function set(this, value, palette_type)
      if gnuplot.isColor(value) || this.isHexValue(value)
        this.m_type = 'rgbcolor';
      elseif isnumeric(value) && (0 <= value && value <= 1)
        % TODO: Reconsider this
        this.m_type = 'palette';

        if nargin > 2
          this.m_palette_type = palette_type;
        end
      end

      this.m_value = value;
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      if ~isempty(this.m_type)
        fragments = [fragments, this.m_type];

        if strcmp(this.m_type, 'rgbcolor')
          fragments = [fragments, sprintf('"%s"', this.m_value)];
        else
          fragments = [fragments, this.m_palette_type];
          fragments = [fragments, num2str(this.m_value)];
        end
      end

      str = strjoin(fragments, ' ');
    end
  end

end