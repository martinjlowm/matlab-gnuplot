function shouldNotExistIn(command, output)
  is_equal = logical(sum(regexp(output, command)));

  fprintf('.');

  if is_equal
    fprintf('\n');
  end

  assert(~is_equal, ...
         sprintf('`%s'' matches `%s'' but shouldn''t!', command, output));
end