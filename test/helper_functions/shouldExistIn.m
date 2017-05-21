function shouldExistIn(command, output)
  is_equal = logical(sum(regexp(output, command)));

  fprintf('.');

  if ~is_equal
    fprintf('\n');
  end

  assert(is_equal, ...
         sprintf('`%s'' does not match `%s''', command, output));
end