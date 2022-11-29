local status, tt = pcall(require, "toggleterm")
if not status then
	return
end

tt.setup({
	direction = "float",
	open_mapping = [[<c-\>]],
})
