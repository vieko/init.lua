local M = {}

--- This function formats the selected text with JSON format
function M.format_json_with_jq()
  -- Check if jq is available
  if vim.fn.executable("jq") == 0 then
    vim.notify("jq is not installed or not in PATH", vim.log.levels.ERROR, { title = "Format JSON" })
    return
  end

  local temp_name = vim.fn.tempname()
  
  -- Add error handling for file operations
  local success, err = pcall(function()
    -- Save the selected text to a temporary file
    vim.cmd("'<,'>write !jq '.' >" .. temp_name)
    
    -- Check if jq processing was successful
    local temp_file = io.open(temp_name, "r")
    if not temp_file then
      error("Failed to create temporary file")
    end
    
    local content = temp_file:read("*all")
    temp_file:close()
    
    if content == "" then
      error("jq failed to process JSON - invalid JSON format")
    end

    -- Replace the selected text with the formatted JSON
    vim.cmd("'<,'>read " .. temp_name)
    vim.cmd("'<,'>delete")
  end)

  -- Clean up temporary file
  pcall(vim.fn.delete, temp_name)
  
  if not success then
    vim.notify("JSON formatting failed: " .. (err or "unknown error"), vim.log.levels.ERROR, { title = "Format JSON" })
  end
end

return M
