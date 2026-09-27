# Combo II-DLD S75 / MAIN CLOCK F = 50 MHz.

set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property PACKAGE_PIN K4 [get_ports rst_p]

set_property PACKAGE_PIN A6 [get_ports lcd_e]
set_property PACKAGE_PIN G6 [get_ports lcd_rs]
set_property PACKAGE_PIN D6 [get_ports lcd_rw]

set_property PACKAGE_PIN A4 [get_ports {lcd_data[0]}]
set_property PACKAGE_PIN B2 [get_ports {lcd_data[1]}]
set_property PACKAGE_PIN C3 [get_ports {lcd_data[2]}]
set_property PACKAGE_PIN D4 [get_ports {lcd_data[3]}]
set_property PACKAGE_PIN A2 [get_ports {lcd_data[4]}]
set_property PACKAGE_PIN C5 [get_ports {lcd_data[5]}]
set_property PACKAGE_PIN C1 [get_ports {lcd_data[6]}]
set_property PACKAGE_PIN D1 [get_ports {lcd_data[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports *]

create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]

set_false_path -from [get_ports rst_p]
