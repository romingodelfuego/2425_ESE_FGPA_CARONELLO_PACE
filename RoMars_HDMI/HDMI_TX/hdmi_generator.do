quit -sim

vcom hdmi_generator.vhd
vcom hdmi_generator_tb.vhd
vsim -c work.hdmi_generator_tb

add wave -divider Inputs:
add wave -color yellow i_clk
add wave -color yellow i_reset_n

add wave -divider Outputs:
add wave o_hdmi_hs
add wave o_hdmi_vs
add wave o_hdmi_de
add wave o_x_pixel_pos
add wave o_y_pixel_pos
add wave o_pixel_address

add wave -divider Internal:
add wave uut/h_act
add wave uut/v_act
add wave uut/h_counter
add wave uut/v_counter

run -all