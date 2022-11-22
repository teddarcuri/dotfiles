local status, _ = pcall(vim.cmd, "colorscheme mellow") 
if not status then
    print ("Colorscheme don't exist homie!")
    return
end
