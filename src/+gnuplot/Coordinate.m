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

classdef Coordinate < handle

  properties (Access = private)
    % {<system>} <value>
    m_type;
    m_system; % default: `first'
    m_value;
  end


  %% Constructors
  methods (Access = ?gnuplot.CoordinateSet)
    function this = Coordinate(type)
      this.m_type = type;
      this.m_value = 0;
      this.m_system = '';
    end
  end


  %% Setters
  methods
    function set(this, varargin)
      num_args = nargin - 1;

      if num_args > 2
        this.m_system = varargin{1};
      end

      this.m_value = varargin{num_args};
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      if ~isempty(this.m_system)
        fragments = [fragments, this.m_system];
      end

      fragments = [fragments, num2str(this.m_value)];

      str = strjoin(fragments, ' ');
    end
  end

end