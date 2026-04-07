-- Local custom language server for *.sid files.
-- This only works on machines that have the development binary at the path below.

return {
	filetypes = { 'sid' },
	name = 'educationlsp',
	cmd = {
		'/Users/sid/dev/cksidharthan/educationlsp/main',
	},
}
