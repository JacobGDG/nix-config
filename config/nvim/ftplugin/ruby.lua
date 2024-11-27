for i = 1, vim.fn.line('$') do

  -- Get the current line
  local line = vim.fn.getline(i)

  -- Check if the line is a comment
    if line:match('^%s*#') then
      -- If it is a comment, continue to the next line
      goto continue
    else
      -- If it is not a comment, set the mark at this line
      vim.fn.setpos('.', {0, i, 0, 0})
      break
    end

    ::continue::
  end
