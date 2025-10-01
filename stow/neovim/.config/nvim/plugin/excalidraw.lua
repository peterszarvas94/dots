vim.api.nvim_create_user_command("ExcalidrawOpen", function(opts)
	local file_path = opts.args
	if file_path == "" then
		file_path = vim.fn.expand("%:p")
	end

	if not file_path:match("%.excalidraw$") then
		vim.notify("File must have .excalidraw extension", vim.log.levels.ERROR)
		return
	end

	if vim.fn.filereadable(file_path) == 0 then
		vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
		return
	end

	local base64_cmd = string.format("base64 -i '%s' | tr -d '\\n'", file_path)
	local base64_result = vim.fn.system(base64_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to encode file", vim.log.levels.ERROR)
		return
	end

	local url = "https://excalidraw.com/#json=" .. base64_result
	local open_cmd = string.format("open '%s'", url)

	vim.fn.system(open_cmd)
	if vim.v.shell_error == 0 then
		vim.notify("Opened " .. vim.fn.fnamemodify(file_path, ":t") .. " in Excalidraw")
	else
		vim.notify("Failed to open browser", vim.log.levels.ERROR)
	end
end, {
	nargs = "?",
	complete = "file",
	desc = "Open .excalidraw file in browser",
})