local projectfile = vim.fn.getcwd() .. '/project.godot'

local function file_exists(path)
    local stat = vim.uv.fs_stat(path)
    return stat and stat.type == 'file'
end

if file_exists(projectfile) then
    vim.fn.serverstart("./godothost")
end
