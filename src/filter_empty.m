function filtered = filter_empty(cell_array)
  filtered = cell_array(~cellfun('isempty', cell_array));
end