function varargout = unpack(array)
% UNPACK Unpacks an array to a variable output variables
  if isnumeric(array)
    varargout = num2cell(array);
  else
    varargout = num2cell(array{:});
  end
end