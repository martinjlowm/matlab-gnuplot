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
          fmt = [fmt, ' %10.4f'];
          obj.s_titles{i} = [obj.s_input_name, '(', num2str(i), ', :', ')'];
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

    function string = stringify(obj, input)
      processed_input = obj.processInput(input);

      commands = {};

      % Terminal
      commands = [commands, {sprintf('set terminal %s', obj.s_terminal)}];

      % Output
      commands = [commands, {sprintf('set output ''%s''', obj.s_output)}];

      % Key
      key_string = obj.stringifyKey();
      if ~isempty(strtrim(key_string))
        commands = [commands, {sprintf('set key %s', key_string)}];
      end

      % Input
      plotting = sprintf('plot %s', processed_input);
      for title = obj.s_titles
        plotting = [plotting, ' title "', title{:}, '"'];
      end
      commands = [commands, {plotting}];

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

      obj.s_titles = {};
    end

    function setTerminal(obj, terminal)
      obj.s_terminal = terminal;
    end

    function setOutput(obj, output)
      obj.s_output = output;
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
    end

    function setYLabel(obj, label, options)
    end

    function setXRange(obj, range)
    end

    function plot(obj, input)
      obj.s_input_name = inputname(2);
      commands = obj.stringify(input);

      system(sprintf('gnuplot <<EOF\n%s\nEOF', commands));
    end
  end
end