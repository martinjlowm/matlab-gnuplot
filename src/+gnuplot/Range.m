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

classdef Range < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    % [{{<min>}:{<max>}}] {{no}reverse} {{no}writeback} {{no}extend}
    % | restore
    m_type;

    m_dummy_var;

    m_min;
    m_max;

    m_reverse;   % default: noreverse
    m_writeback; % default: nowriteback
    m_extend;    % default: extend (omitted)
  end


  %% Constructors
  methods
    function this = Range(type)
      if nargin > 0
        this.m_type = type;
      else
        this.m_type = '';
      end

      this.m_dummy_var = '';

      this.m_min = '';
      this.m_max = '';

      this.m_reverse = false;
      this.m_writeback = false;
      this.m_extend = true;
    end
  end


  %% Setters
  methods
    function set(this, range)
      assert(~isempty(range), 'Range is empty!');

      if isnumeric(range)
        this.m_min = num2str(min(range));
        this.m_max = num2str(max(range));
      else
        range = regexp(range, '\[?(?<min>"?[^"]*"?):(?<max>[^\]]*)\]?');

        this.m_min = range.min;
        this.m_max = range.max;
      end
    end

    function setDummy(this, dummy_var)
      this.m_dummy = dummy_var;
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      if ~isempty(this.m_min) || ~isempty(this.m_max)
        if ~isempty(this.m_type)
          fragments = [fragments, sprintf('set %srange', this.m_type)];
        end

        dummy_var = '';
        if ~isempty(this.m_dummy_var)
          dummy_var = sprintf('%s = ', this.m_dummy_var);
        end

        fragments = [fragments, ...
                     sprintf('[%s%s:%s]', dummy_var, this.m_min, this.m_max)];

        if ~isempty(this.m_type)
          if this.m_reverse
            fragments = [fragments, 'reverse'];
          end

          if this.m_writeback
            fragments = [fragments, 'writeback'];
          end
        end
      end

      str = strjoin(fragments, ' ');
    end
  end

end