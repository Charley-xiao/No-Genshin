set_property IOSTANDARD LVCMOS33 [get_ports *]
set_property PACKAGE_PIN R1 [get_ports sel[6]]
set_property PACKAGE_PIN P4 [get_ports sel[0]]
set_property PACKAGE_PIN P3 [get_ports sel[1]]
set_property PACKAGE_PIN P2 [get_ports sel[2]]
set_property PACKAGE_PIN R2 [get_ports sel[3]]
set_property PACKAGE_PIN M4 [get_ports sel[4]]
set_property PACKAGE_PIN N4 [get_ports sel[5]]
set_property PACKAGE_PIN U3 [get_ports octave[1]]
set_property PACKAGE_PIN U2 [get_ports octave[0]]
set_property PACKAGE_PIN P17 [get_ports clk]
set_property PACKAGE_PIN T1 [get_ports speaker]
set_property PACKAGE_PIN V2 [get_ports _mode[1]]
set_property PACKAGE_PIN V5 [get_ports _mode[0]]
set_property PACKAGE_PIN R11 [get_ports up]
set_property PACKAGE_PIN V1 [get_ports down]
set_property PACKAGE_PIN M6 [get_ports md]
set_property PACKAGE_PIN G4 [get_ports led[6]]
set_property PACKAGE_PIN G3 [get_ports led[5]]
set_property PACKAGE_PIN J4 [get_ports led[4]]
set_property PACKAGE_PIN H4 [get_ports led[3]]
set_property PACKAGE_PIN J3 [get_ports led[2]]
set_property PACKAGE_PIN J2 [get_ports led[1]]
set_property PACKAGE_PIN K2 [get_ports led[0]]
set_property PACKAGE_PIN R15 [get_ports butscale]
set_property PACKAGE_PIN D4 [get_ports seg_out0[7]]
set_property PACKAGE_PIN E3 [get_ports seg_out0[6]]
set_property PACKAGE_PIN D3 [get_ports seg_out0[5]]
set_property PACKAGE_PIN F4 [get_ports seg_out0[4]]
set_property PACKAGE_PIN F3 [get_ports seg_out0[3]]
set_property PACKAGE_PIN E2 [get_ports seg_out0[2]]
set_property PACKAGE_PIN D2 [get_ports seg_out0[1]]
set_property PACKAGE_PIN H2 [get_ports seg_out0[0]]
set_property PACKAGE_PIN B4 [get_ports seg_out1[7]]
set_property PACKAGE_PIN A4 [get_ports seg_out1[6]]
set_property PACKAGE_PIN A3 [get_ports seg_out1[5]]
set_property PACKAGE_PIN B1 [get_ports seg_out1[4]]
set_property PACKAGE_PIN A1 [get_ports seg_out1[3]]
set_property PACKAGE_PIN B3 [get_ports seg_out1[2]]
set_property PACKAGE_PIN B2 [get_ports seg_out1[1]]
set_property PACKAGE_PIN D5 [get_ports seg_out1[0]]
set_property PACKAGE_PIN G1 [get_ports tub_sel0[3]]
set_property PACKAGE_PIN F1 [get_ports tub_sel0[2]]
set_property PACKAGE_PIN E1 [get_ports tub_sel0[1]]
set_property PACKAGE_PIN G6 [get_ports tub_sel0[0]]
set_property PACKAGE_PIN G2 [get_ports tub_sel1[3]]
set_property PACKAGE_PIN C2 [get_ports tub_sel1[2]]
set_property PACKAGE_PIN C1 [get_ports tub_sel1[1]]
set_property PACKAGE_PIN H1 [get_ports tub_sel1[0]]

set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports {red[0]}]
set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVCMOS33} [get_ports {red[1]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {red[2]}]
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports {red[3]}]
set_property -dict {PACKAGE_PIN B6 IOSTANDARD LVCMOS33} [get_ports {green[0]}]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS33} [get_ports {green[1]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {green[2]}]
set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVCMOS33} [get_ports {green[3]}]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS33} [get_ports {blue[0]}]
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {blue[1]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {blue[2]}]
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS33} [get_ports {blue[3]}]

set_property PACKAGE_PIN D7 [get_ports hs]
set_property PACKAGE_PIN C4 [get_ports vs]

# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets mode_IBUF[1]]