classdef Gnuplot < handle
  properties (Access = private)
    % Terminal
    s_terminal;

    % Output
    s_output;

    % Key
    s_key;

    % Plot input name (used for data legend)
    s_input_name;

    % Titles
    s_titles;

    % Titles
    formats;

    % X Range
    s_x_range;

    % Y Range
    s_y_range;

    % Logscale
    s_logscale;

    x_label;
    y_label;
  end

  methods (Access = private)
    function processed_input = processInput(obj, input)
      if isnumeric(input)
        % Dump data to a temporary file for plotting
        filename = tempname;
        file_id = fopen(filename, 'w');
        [rows, cols] = size(input');

        % Column format
        fmt = '%.4f';
        for i = 1:(cols - 1)
          fmt = [fmt, '\t%10.15f'];
          obj.s_titles{i} = ['using 1:', num2str(i + 1), ' ', ...
                             obj.s_titles{i}];
        end
        fmt = [fmt, '\n'];

        fprintf(file_id, fmt, input);
        fclose(file_id);

        input = filename;
      end

      if exist(input, 'file')
        % Plot the input
        input = sprintf('''%s''', input);
      end

      processed_input = input;
    end

    function string = stringify(obj, input, with)
      processed_input = obj.processInput(input);

      commands = {};

      % Terminal
      commands = [commands, {sprintf('set terminal %s', obj.s_terminal)}];

      % Output
      % Ensure the path exists
      dir = fileparts(obj.s_output);
      if ~exist(dir)
        system(['mkdir -p ', dir]);
      end
      commands = [commands, {sprintf('set output ''%s''', obj.s_output)}];

      % Key
      key_string = obj.stringifyKey();
      if ~isempty(strtrim(key_string))
        commands = [commands, {sprintf('set key %s', key_string)}];
      end

      % X Range
      x_range = obj.getXRange();
      if ~isempty(x_range)
        commands = [commands, {sprintf('set xrange %s', x_range)}];
      end

      % Y Range
      y_range = obj.getYRange();
      if ~isempty(y_range)
        commands = [commands, {sprintf('set yrange %s', y_range)}];
      end

      if ~isempty(obj.x_label)
        commands = [commands, {sprintf('set xlabel ''%s''', obj.x_label)}];
      end

      if ~isempty(obj.y_label)
        commands = [commands, {sprintf('set ylabel ''%s''', obj.y_label)}];
      end

      if ~isempty(obj.s_logscale)
        commands = [commands, {sprintf('set logscale %s', obj.s_logscale)}];
      end

      keys = fieldnames(obj.formats);
      for i = 1:numel(keys)
        commands = [commands, {sprintf('set format %s "%s"', keys{i}, obj.formats.(keys{i}))}];
      end

      % Input
      plotting = 'plot ';
      for title = obj.s_titles
        plotting = [plotting, processed_input, ' ', title{:}, ...
                   ' with ', with, ', '];
      end
      commands = [commands, {plotting(1:end-2)}];

      string = strjoin(commands, '\n');
    end

    function string = stringifyKey(obj)
    % set key {on|off} {default}
    %        {{inside | outside} | {lmargin | rmargin | tmargin | bmargin}
    %          | {at <position>}}
    %        {left | right | center} {top | bottom | center}
    %        {vertical | horizontal} {Left | Right}
    %        {{no}reverse} {{no}invert}
    %        {samplen <sample_length>} {spacing <vertical_spacing>}
    %        {width <width_increment>}
    %        {height <height_increment>}
    %        {{no}autotitle {columnheader}}
    %        {title "<text>"} {{no}enhanced}
    %        {{no}box { {linestyle | ls <line_style>}
    %                   | {linetype | lt <line_type>}
    %                     {linewidth | lw <line_width>}}}
      params = {};

      % {on|off}
      params = [params, {sprintf('%s', obj.s_key.state)}];
      % {{inside | outside} | {lmargin | rmargin | tmargin | bmargin}
      %          | {at <position>}}
      if isstruct(obj.s_key.position)
        position = sprintf('at %s,%s', ...
                           obj.s_key.position.x, ...
                           obj.s_key.position.y);
      else
        position = sprintf('%s', obj.s_key.position);
      end
      params = [params, {position}];

      % {left | right | center} {top | bottom | center}
      params = [params, {sprintf('%s %s', ...
                                 obj.s_key.anchor{1}, ...
                                 obj.s_key.anchor{2})}];

      % {samplen <sample_length>}
      if ~isempty(obj.s_key.sample_length)
        params = [params, {sprintf('samplen %s', obj.s_key.sample_length)}];
      end

      % {spacing <vertical_spacing>}
      if ~isempty(obj.s_key.spacing)
        params = [params, {sprintf('spacing %s', num2str(obj.s_key.spacing))}];
      end

      % {title "<text>"} {{no}enhanced}
      if ~isempty(obj.s_key.title)
        params = [params, {sprintf('title "%s"', obj.s_key.title)}];
      end

      string = strjoin(params, ' ');
    end
  end

  methods
    function obj = Gnuplot()
      obj.s_key = struct;
      obj.s_key.state = '';
      obj.s_key.sample_length = '';
      obj.s_key.position = '';
      obj.s_key.anchor = {'', ''};
      obj.s_key.spacing = '';
      obj.s_key.title = '';

      obj.formats = struct;

      obj.s_titles = {};
    end

    function setTerminal(obj, terminal)
      obj.s_terminal = terminal;
    end

    function setTitle(obj, varargin)
      obj.s_titles = {};

      for k = 1:length(varargin)
        obj.s_titles{k} = ['title "', varargin{k}, '"'];
      end
    end

    function setOutput(obj, output)
      obj.s_output = output;
    end

    function setLogScale(obj, axes)
      obj.s_logscale = axes;
    end

    function setFormat(obj, axis, format)
      obj.formats.(axis) = format;
    end

    function setKey(obj, key)
      if ~isstruct(key)
        error('Input `key'' is not a struct!');
      end

      fields = fieldnames(key);
      for i = 1:numel(fields)
        obj.s_key.(fields{i}) = key.(fields{i});
      end
    end

    function setXLabel(obj, label, options)
      obj.x_label = strrep(label, '$', '\$');
    end

    function setYLabel(obj, label, options)
      obj.y_label = strrep(label, '$', '\$');
    end

    function range = getXRange(obj)
    % { [{{<min>}:{<max>}}] {{no}reverse} {{no}writeback} }
    %           | restore
      if isstruct(obj.s_x_range)
        range = ['[', num2str(obj.s_x_range.min), ':', ...
                 num2str(obj.s_x_range.max), ']'];
      else
        range = obj.s_x_range;
      end
    end

    function setXRange(obj, range)
      if isnumeric(range)
        obj.s_x_range = struct;
        obj.s_x_range.min = min(range);
        obj.s_x_range.max = max(range);
      else
        obj.s_x_range = range;
      end
    end

    function range = getYRange(obj)
    % { [{{<min>}:{<max>}}] {{no}reverse} {{no}writeback} }
    %           | restore
      if isstruct(obj.s_y_range)
        range = ['[', num2str(obj.s_y_range.min), ':', ...
                 num2str(obj.s_y_range.max), ']'];
      else
        range = obj.s_y_range;
      end
    end

    function setYRange(obj, range)
      if isnumeric(range)
        obj.s_y_range = struct;
        obj.s_y_range.min = min(range);
        obj.s_y_range.max = max(range);
      else
        obj.s_y_range = range;
      end
    end

    function plot(obj, input, with)
      if nargin < 3
        with = 'lines';
      end

      obj.s_input_name = inputname(2);
      commands = obj.stringify(input, with);

      system(sprintf('gnuplot <<EOF\n%s\nEOF', commands));
    end
  end
end