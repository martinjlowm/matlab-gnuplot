function assert(condition, error_msg)
  prefix = '';
  call_stack = dbstack;

  if length(call_stack) > 1
    prefix = sprintf('[%s] ', call_stack(2).name);
  end

  assert(condition, sprintf('%s%s', prefix, error_msg));
end