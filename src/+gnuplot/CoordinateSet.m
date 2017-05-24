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

classdef CoordinateSet < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % {<system>} <x>, {<system>} <y> {,{<system>} <z>}
    m_coords;
  end


  %% Constructors
  methods
    function this = CoordinateSet()
      this.m_coords{1} = gnuplot.Coordinate('x');
      this.m_coords{2} = gnuplot.Coordinate('y');
      this.m_coords{3} = gnuplot.Coordinate('z');
    end
  end


  %% Setters
  methods
    function set(this, varargin)
      assert((nargin >= 2) && (nargin <= 6), ...
             'Usage: {<system>} <x>, {<system>} <y> {,{<system>} <z>}');

      i = 1;
      while i < nargin
        arg = varargin{i};
        if ischar(arg)
          coord = varargin{i + 1};
          assert(isnumeric(coord), 'Coordinate must be numeric!');

          this.m_coords{i}.set(arg, coord);
          incr = 2;
        else
          this.m_coords{i}.set(arg);
          incr = 1;
        end

        i = i + incr;
      end
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = cell(1, length(this.m_coords));

      for i = 1:length(this.m_coords)
        coord = this.m_coords{i}.toString();
        if ~isempty(coord)
          fragments{i} = coord;
        end
      end

      str = strjoin(fragments, ', ');

      if strcmp(str, '0, 0, 0')
        str = '';
      end
    end
  end

end