#!/usr/bin/env python3
"""
Kitty kitten to pass keys to Neovim when focused, otherwise handle window navigation.
Save this as ~/.config/kitty/pass_keys.py
"""

import sys
from kitty.boss import get_boss
from kitty.fast_data_types import screen_size_function
from kitty.key_encoding import KeyEvent, parse_shortcut

def is_window_vim(window):
    """Check if the current window is running Neovim"""
    fp = window.child.foreground_processes
    return any('nvim' in p['cmdline'][0] if p['cmdline'] else False for p in fp)

def main(args):
    if len(args) < 3:
        return
    
    direction = args[1]  # top, bottom, left, right
    key_combo = args[2]  # e.g., ctrl+j
    
    boss = get_boss()
    if boss is None:
        return
    
    window = boss.active_window
    if window is None:
        return
    
    if is_window_vim(window):
        # Pass the key combination to Neovim
        window.write_to_child(key_combo.encode())
    else:
        # Handle window navigation
        if direction == 'left':
            boss.active_tab.neighboring_window('left')
        elif direction == 'right':
            boss.active_tab.neighboring_window('right')
        elif direction == 'top':
            boss.active_tab.neighboring_window('top')
        elif direction == 'bottom':
            boss.active_tab.neighboring_window('bottom')

if __name__ == '__main__':
    main(sys.argv)
