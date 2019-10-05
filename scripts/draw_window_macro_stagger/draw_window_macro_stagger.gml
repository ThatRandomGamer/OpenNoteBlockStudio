// draw_window_macro_stagger()
var x1, y1, a, b, i, pattern, str, total_vals, val, arplen, maxlength, conf;
curs = cr_default
text_exists[0] = 0
x1 = floor(window_width / 2 - 80)
y1 = floor(window_height / 2 - 70)
draw_window(x1, y1, x1 + 140, y1 + 140)
draw_theme_color()
draw_set_font(fnt_mainbold)
draw_text(x1 + 8, y1 + 8, "Stagger")
pattern = ""
if (selected = 0) return 0
str = selection_code
arr_data = selection_to_array(str)
total_vals = string_count("|", str)
val = 0
conf = 0
draw_set_font(fnt_main)
if (theme = 0) {
    draw_set_color(c_white)
    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 102, 0)
    draw_set_color(make_color_rgb(137, 140, 149))
    draw_rectangle(x1 + 6, y1 + 26, x1 + 134, y1 + 102, 1)
}
draw_areaheader(x1 + 10, y1 + 33, 120, 35, "Pattern")

pattern = draw_textarea(5, x1 + 15, y1 + 40, 113, 25, string(pattern), "Must separate relative keys with pipes.") 
draw_set_font(fnt_main)
draw_text(x1 + 20, y1 + 72,"This may replace \nlower note blocks!")
if (draw_button2(x1 + 10, y1 + 108, 60, "OK")) {
	if string_count("|", pattern) = 0 {
		message("Please add pipes ( | ) to separate values!", "Error")
		return -1
	}
	if string_count("-", pattern) != 0 {
		message("Stagger can only extend downwards!", "Error")
		return -1
	}

	window = 0
	pattern = string(pattern + "|")
	arp = selection_to_array(pattern)
	arplen = string_count("|", pattern)

	maxlength = 0;
	
	var patlen = array_length_1d(arp);
	for (i = 0; i < patlen; i++) { // Calculate highest number in given pattern
	    if (arp[i] > arp[maxlength]) {
	        maxlength = i;
	    }
	}
	for (a = 0; a < selection_arraylength; a++) {  // Expand array entries by highest number
	    for (b = 0; b <= arp[maxlength]; b ++) {
	        selection_exists[a, b] = 0
	    }
	}

	selection_arrayheight = arp[maxlength]

	while (val < total_vals) {
		for (i = 0; i < arplen; i++;) {
			val += 1
			arr_data[val] = real(arr_data[val]) + real(arp[i])
			val += 6
			while arr_data[val] != -1 {
				arr_data[val] = real(arr_data[val]) + real(arp[i])
				val += 6
			}
		val ++
		if val >= total_vals break
		}
	if val >= total_vals break
	}
	str = array_to_selection(arr_data, total_vals)
	selection_load(selection_x,selection_y,str,true)
	selection_code_update()
	history_set(h_selectchange, selection_x, selection_y, selection_code, selection_x, selection_y, str)
}
if (draw_button2(x1 + 70, y1 + 108, 60, "Cancel")) {window = 0}
window_set_cursor(curs)