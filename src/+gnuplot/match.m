function result = match(str, regex)
  result = logical(sum(regexp(str, regex)));
end