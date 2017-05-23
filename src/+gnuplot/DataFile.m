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

classdef DataFile < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % '<file_name>' {binary <binary list>}
    %               {{nonuniform} matrix}
    %               {index <index list> | index "<name>"}
    %               {every <every list>}
    %               {skip <number-of-lines>}
    %               {using <using list>}
    %               {smooth <option>}
    %               {volatile} {noautoscale}
    m_file_name;
    m_binary_list;
    m_matrix;
    m_index;
    m_every_list;
    m_skip;
    m_using;
    m_smooth;
    m_volatile;
    m_autoscale;
  end


  methods (Static)
    function file_name = WriteTempFile(varargin)
      file_name = tempname;
      file_id = fopen(file_name, 'w');

      data = cell2mat(varargin');
      [~, num_rows] = size(data);
      data = [num2str(data'), repmat(newline, num_rows, 1)]';
      fprintf(file_id, data);
      fclose(file_id);
    end
  end


  %% Constructors
  methods
    function this = DataFile(varargin)
      if isa([varargin{:}], 'double')
        this.m_file_name = gnuplot.DataFile.WriteTempFile(varargin{:});
      else
        this.m_file_name = varargin{1};
      end
      this.m_binary_list = {};
      this.m_matrix = '';
      this.m_index = {};
      this.m_every_list = {};
      this.m_skip = 0;
      this.m_using = '1:2'; % Usually the default format
      this.m_smooth = gnuplot.SmoothOption();
      this.m_volatile = '';
      this.m_autoscale = '';
    end
  end


  %% Getters
  methods
  end


  %% Setters
  methods
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      fragments = [fragments, sprintf('''%s''', this.m_file_name)];

      if ~isempty(this.m_using)
        fragments = [fragments, sprintf('using %s', this.m_using)];
      end

      smooth = this.m_smooth.toString();
      if ~isempty(smooth)
        fragments = [fragments, smooth];
      end

      str = strjoin(fragments, ' ');
    end
  end

end