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

classdef Output < gnuplot.Copyable

  properties (Access = {?gnuplot.Copyable, ?gnuplot.Gnuplot})
    m_file;
    m_directory;
    m_value;
  end


  %% Constructors
  methods
    function this = Output(binary_path)
      this.m_file = '';
      this.m_directory = '';
      this.m_value = '';
    end
  end


  %% Setters
  methods
    function set(this, file)
      this.m_file = file;
    end

    function setDirectory(this, directory)
      this.m_directory = directory;
    end
  end


  %% Other methods
  methods
    function evaluateOutput(this)
      if ~isempty(this.m_directory)
        this.m_value = ...
            strjoin({this.m_directory, this.m_file}, '/');
        this.m_value = regexprep(this.m_value, '/{2,}', '/');
      else
        this.m_value = this.m_file;
      end
    end

    function str = toString(this)
      this.evaluateOutput();
      str = this.m_value;
    end
  end

end