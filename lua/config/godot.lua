local projectfile = vim.fn.getcwd() .. '/project.godot'

print(projectfile)

local function file_exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == 'file'
end

if file_exists(projectfile) then
    vim.fn.serverstart("./godothost")
end
