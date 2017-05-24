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

classdef DataStats < gnuplot.Copyable

  properties (Access = ?gnuplot.Copyable)
    m_id;

    m_file;
  end


  %% Constructors
  methods (Access = ?gnuplot.Gnuplot)
    function this = DataStats(varargin)
      this.m_file = gnuplot.DataFile(varargin{:});
    end
  end


  %% Getters
  methods (Access = private)
    function var_str = get(this, var)
      var_str = sprintf('%s_%s', this.m_id, var);
    end
  end

  methods
    % Statistics
    function records = getNumRecords(this)
      records = this.get('records');
    end

    function outofrange = getNumRecordsFilteredOut(this)
      outofrange = this.get('outofrange');
    end

    function invalid = getNumInvalidRecords(this)
      invalid = this.get('invalid');
    end

    function blank = getNumBlankLines(this)
      blank = this.get('blank');
    end

    function blocks = getNumIndexableBlocks(this)
      blocks = this.get('blocks');
    end

    function columns = getNumColumns(this)
      columns = this.get('columns');
    end

    % Data properties of a single column
    function min = getMin(this)
      min = this.get('min');
    end

    function max = getMax(this)
      max = this.get('max');
    end

    function index_min = getIndexMin(this)
      index_min = this.get('index_min');
    end

    function index_max = getIndexMax(this)
      index_max = this.get('index_max');
    end

    function lower_quartile = getLowerQuartile(this)
      lower_quartile = this.get('lo_quartile');
    end

    function median = getMedian(this)
      median = this.get('median');
    end

    function upper_quartile = getUpperQuartile(this)
      upper_quartile = this.get('up_quartile');
    end

    function mean = getMean(this)
      mean = this.get('mean');
    end

    function ssd = getSampleStandardDeviation(this)
      ssd = this.get('ssd');
    end

    function stddev = getStandardDeviation(this)
      stddev = this.get('stddev');
    end

    function sum = getSum(this)
      sum = this.get('sum');
    end

    function sumsq = getSumSquares(this)
      sumsq = this.get('sumsq');
    end

    function skewness = getSkewness(this)
      skewness = this.get('skewness');
    end

    function kurtosis = getKurtosis(this)
      kurtosis = this.get('kurtosis');
    end

    function adev = getMeanAbsoluteDeviation(this)
      adev = this.get('adev');
    end

    function mean_err = getMeanError(this)
      mean_err = this.get('mean_err');
    end

    function stddev_err = getStandardDeviationError(this)
      stddev_err = this.get('stddev_err');
    end

    function skewness_err = getSkewnessError(this)
      skewness_err = this.get('skewness_err');
    end

    function kurtosis_err = getKurtosisError(this)
      kurtosis_err = this.get('kurtosis_err');
    end

    % Data properties of two columns
    function correlation = getCorrelation(this)
      correlation = this.get('correlation');
    end

    function slope = getSlope(this)
      slope = this.get('slope');
    end

    function slope_err = getSlopeError(this)
      slope_err = this.get('slope_err');
    end

    function intercept = getIntercept(this)
      intercept = this.get('intercept');
    end

    function intercept_err = getInterceptError(this)
      intercept_err = this.get('intercept_err');
    end

    function sumxy = getSumXTimesY(this)
      sumxy = this.get('sumxy');
    end

    function pos_min_y = getPositionMinY(this)
      pos_min_y = this.get('pos_min_y');
    end

    function pos_max_y = getPositionMaxY(this)
      pos_max_y = this.get('pos_max_y');
    end
  end


  %% Setters
  methods
    function setID(this, id)
      this.m_id = sprintf('_%d', id);
    end
  end


  %% Other methods
  methods
    function str = toString(this)
      fragments = {};

      fragments = [fragments, 'stats'];

      fragments = [fragments, this.m_file.toString()];

      fragments = [fragments, sprintf('name "%s"', this.m_id)];

      str = strjoin(fragments, ' ');
    end
  end

end