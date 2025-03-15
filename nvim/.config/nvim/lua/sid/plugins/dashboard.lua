return {
	'nvimdev/dashboard-nvim',
	event = 'UIEnter',
	dependencies = {
		'echasnovski/mini.icons',
	},
	opts = function()
		local logo = [[
                       .####++-.                                             ..++####.                       
                         -##############+-.                       .-+##############-                         
                           +################.                   .+###############+                           
                             +###############+.                +###############+                             
                               +###############+             +###############+.                              
                                 +###############+         +###############+.                                
                                  .################+     -################-                                  
                                    -################- -################-                                    
                                ++    -###############################+    ++.                               
                              +####-    +###########################+    -####+                              
                            +########-    +#######################+    -########+                            
                          -############.    +###################+.   .############-                          
                        -###############+.   .+################.   .+###############-                        
                       ++++++++++++++++++++    -#############-    -+++++++++++++++++++.                      
                                                 -#########-                                                 
                                                   -#####+                                                   
                                                     +#+                                                     
    ]]

		logo = string.rep("\n", 4) .. logo .. "\n\n"

		local opts = {
			theme = 'hyper',
			hide = {
				-- this is taken care of by lualine
				-- enabling this messes up the actual laststatus setting after loading a file
				statusline = false,
        tabline = false,
			},
			config = {
				header = vim.split(logo, '\n'),
        project = { enable = false, limit = 10, label = ' Recently Opened Projects', cwd_only = false },
				mru = { enable = false, limit = 5, label = ' Recently Opened Files', cwd_only = false },
				vertical_center = true,
        footer = {
          "🚀 Keep Calm and believe in Max !!! 🚀"
        }
			},
		}

		return opts
	end,
}
