-- Script to fetch Kubernetes schemas and append a yaml schema modeline
-- It will query
-- https://github.com/yannh/kubernetes-json-schema - for native K8s objects
-- https://github.com/datreeio/CRDs-catalog - for CRDS

local curl = require 'plenary.curl'

local sources = {
  native = {
    schemas_catalog = 'yannh/kubernetes-json-schema',
    branch = 'master',
    select_prefix = 'K8s: ',
  },
  crds = {
    schemas_catalog = 'datreeio/CRDs-catalog',
    branch = 'main',
    select_prefix = 'CRD: ',
  }
}

local list_github_tree = function(source)
  local url = 'https://api.github.com/repos/' .. source.schemas_catalog .. '/git/trees/' .. source.branch
  local response = curl.get(url, {
    headers = {
      Accept = 'application/vnd.github+json',
      ['X-GitHub-Api-Version'] = '2022-11-28',
    },
    query = { recursive = 1 },
  })
  local body = vim.fn.json_decode(response.body)
  local trees = {}
  for _, tree in ipairs(body.tree) do
    if tree.type == 'blob' and tree.path:match '%.json$' then
      table.insert(trees, source.select_prefix .. tree.path)
    end
  end
  return trees
end

local select_schema = function(schemas)
  vim.ui.select(schemas, { prompt = 'Select schema: ' }, function(selection)

    if not selection then
      vim.notify('Canceled schema selection.', vim.log.levels.INFO)
      return
    end

    local source = nil
    if string.find(selection, sources.native.select_prefix) == 1 then
      source = sources.native
    elseif string.find(selection, sources.crds.select_prefix) == 1 then
      source = sources.crds
    else
      vim.notify('Unknown schema source: ' .. selection, vim.log.levels.ERROR)
      return
    end

    local selection_path = selection:gsub('^' .. source.select_prefix, '')

    local schema_url = 'https://raw.githubusercontent.com/' .. source.schemas_catalog .. '/' .. source.branch .. '/' .. selection_path
    local schema_modeline = '# yaml-language-server: $schema=' .. schema_url
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {
      schema_modeline,
      '',
    })
    vim.notify('Added schema modeline: ' .. schema_modeline)
  end)
end

return {
  init = function ()
    local crds = list_github_tree(sources.crds)
    local native = list_github_tree(sources.native)
    local all_schemas = vim.list_extend(crds, native)

    select_schema(all_schemas)
  end
}
