-- plugin to shower with snowflakes after the completion of 30 minutes of a coding session.
return {
	'wildfunctions/myeyeshurt',
	event = 'VeryLazy',
	opts = {
		initialFlakes = 1,
		flakeOdds = 20,
		maxFlakes = 750,
		nextFrameDelay = 175,
		useDefaultKeymaps = true,
		flake = { '*', '.' },
		minutesUntilRest = 30,
	},
	keys = {
		{
			'<leader>ms',
			function()
				require('myeyeshurt').start()
			end,
			{ noremap = true, silent = true },
		},
		{
			'<leader>mx',
			function()
				require('myeyeshurt').stop()
			end,
			{ noremap = true, silent = true },
		},
	},
}
