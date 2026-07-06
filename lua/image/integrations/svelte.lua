local document = require 'image/utils/document'

local function resolve_lib_alias(root_dir, path)
  -- strip vite-imagetools query params first ("?w=480;800...&as=run:64")
  local clean_path = path:match '^([^?]*)'
  if clean_path:sub(1, 5) == '$lib/' then return root_dir .. '/src/lib/' .. clean_path:sub(6) end
  return nil
end

return document.create_document_integration {
  name = 'svelte',
  debug = true,
  default_options = {
    clear_in_insert_mode = false,
    download_remote_images = true,
    only_render_image_at_cursor = false,
    filetypes = { 'svelte' },
  },
  query_buffer_images = function(buffer)
    local buf = buffer or vim.api.nvim_get_current_buf()
    local images = {}
    local doc_path = vim.api.nvim_buf_get_name(buf)
    local root_dir = vim.fs.root(doc_path, { 'svelte.config.js', 'package.json', '.git' })

    -- 1. Markup: <img src="...">
    local parser = vim.treesitter.get_parser(buf)
    parser:parse(true) -- force full parse, including injections
    local markup_root = parser:parse()[1]:root()
    local markup_query = vim.treesitter.query.parse(parser:lang(), '(attribute (attribute_name) @name (#eq? @name "src")' .. ' (quoted_attribute_value))')
    ---@diagnostic disable-next-line: missing-parameter
    for id, node in markup_query:iter_captures(markup_root, 0) do
      if markup_query.captures[id] == 'name' then
        local start_row, start_col, end_row, end_col = node:range()
        local line = vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, false)[1]
        local path = line:sub(start_col):gsub('.*src=["\'](.-)["\'].*$', '%1')
        local url = nil
        if path:sub(1, 1) == '/' then
          url = root_dir and (root_dir .. '/static' .. path) or nil
        else
          url = path
        end
        if url and (path:sub(1, 1) ~= '/' or (url and vim.uv.fs_stat(url))) then
          table.insert(images, {
            node = node,
            range = { start_row = start_row, start_col = start_col, end_row = end_row, end_col = end_col },
            url = url,
          })
        end
      end
    end

    -- 2. <script> imports: import x from '$lib/assets/foo.jpg?w=...'
    for lang, child in pairs(parser:children()) do
      if lang == 'javascript' or lang == 'typescript' then
        local import_query = vim.treesitter.query.parse(lang, '(import_statement source: (string (string_fragment) @path))')
        for _, tree in ipairs(child:trees()) do
          local iroot = tree:root()
          ---@diagnostic disable-next-line: missing-parameter
          for id, node in import_query:iter_captures(iroot, 0) do
            if import_query.captures[id] == 'path' then
              local start_row, start_col, end_row, end_col = node:range()
              local spec = vim.treesitter.get_node_text(node, buf)
              local url = nil
              if spec:sub(1, 1) == '/' then
                url = root_dir and (root_dir .. '/static' .. spec:match '^([^?]*)') or nil
              elseif spec:sub(1, 5) == '$lib/' then
                url = root_dir and resolve_lib_alias(root_dir, spec) or nil
              elseif spec:sub(1, 1) == '.' then
                -- relative to the document itself
                local clean = spec:match '^([^?]*)'
                url = vim.fs.dirname(doc_path) .. '/' .. clean
              end
              if url and vim.uv.fs_stat(url) then
                table.insert(images, {
                  node = node,
                  range = { start_row = start_row, start_col = start_col, end_row = end_row, end_col = end_col },
                  url = url,
                })
              end
            end
          end
        end
      end
    end

    return images
  end,
}
