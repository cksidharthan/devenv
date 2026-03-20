from kittens.tui.handler import result_handler


def main():
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    direction = args[1]  # 'h' or 'l'
    increment = 5.0

    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    tab = boss.active_tab
    if tab is None:
        return

    # Check if any window exists to the right of the current window
    current_right = window.geometry.right
    has_right_neighbor = any(
        w.id != window.id and w.geometry.left >= current_right - 2
        for w in tab.windows
    )

    if direction == 'h':
        # Left pane: narrow (divider left). Right pane: widen (divider left).
        resize_increment = -increment if has_right_neighbor else increment
    elif direction == 'l':
        resize_increment = increment if has_right_neighbor else -increment
    else:
        return

    boss.resize_layout_window(window, resize_increment, is_horizontal=True)
