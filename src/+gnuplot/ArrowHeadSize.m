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

classdef ArrowHeadSize < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % {size <headlength>,<headangle>{,<backangle>}}
    m_length;
    m_angle;
    m_back_angle;
  end


  methods (Static)
    function head = SetAngle(angle)
      gnuplot.assert(isa(angle, 'double'), ...
                     'Angle must be a numeric scalar!');

      head = angle;
    end
  end


  %% Constructors
  methods
    function this = ArrowHeadSize()
      this.m_length = '';
      this.m_angle = '';
      this.m_back_angle = '';
    end
  end


  %% Setters
  methods
    function set(this, varargin)
      num_args = nargin - 1;

      gnuplot.assert(num_args >= 2 && num_args <= 3, ...
                     'Usage: <headlength>,<headangle>{,<backangle>}');

      this.setLength(varargin{1});
      this.setAngle(varargin{2});

      if num_args == 3
        this.setBackAngle(varargin{3});
      end
    end

    function setLength(this, length)
      gnuplot.assert(isa(length, 'double'), ...
                     'Length must be a numeric scalar');

      this.m_length = length;
    end

    function setAngle(this, angle)
      this.m_angle = gnuplot.ArrowHeadSize.SetAngle(angle);
    end

    function setBackAngle(this, angle)
      this.m_back_angle = gnuplot.ArrowHeadSize.SetAngle(angle);
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      str = '';

      fragments = {};

      if ~isempty(this.m_length)
        fragments = [fragments, num2str(this.m_length)];
      end

      if ~isempty(this.m_angle)
        fragments = [fragments, num2str(this.m_angle)];
      end

      if ~isempty(this.m_back_angle)
        fragments = [fragments, num2str(this.m_back_angle)];
      end

      if length(fragments) > 1
        str = sprintf('size %s', strjoin(fragments, ', '));
      end
    end
  end

end