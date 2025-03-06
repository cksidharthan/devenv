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

		-- logo = string.rep("\n", 8) .. logo .. "\n\n"

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
				mru = { enable = true, limit = 5, label = ' Recently Opened Files', cwd_only = false },
				vertical_center = true,
			},
		}

		return opts
	end,
}
