# Switches 

set_property -dict { PACKAGE_PIN V17    IOSTANDARD LVCMOS33 } [get_ports { switches[0] }];
set_property -dict { PACKAGE_PIN V16    IOSTANDARD LVCMOS33 } [get_ports { switches[1] }];
set_property -dict { PACKAGE_PIN W16    IOSTANDARD LVCMOS33 } [get_ports { switches[2] }];
set_property -dict { PACKAGE_PIN W17    IOSTANDARD LVCMOS33 } [get_ports { switches[3] }];

# LEDs

set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { leds[0] }];
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }];
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { leds[2] }];
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports { leds[3] }];
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { leds[4] }];
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { leds[5] }];
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { leds[6] }];
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { leds[7] }];
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { leds[8] }];
set_property -dict { PACKAGE_PIN V3   IOSTANDARD LVCMOS33 } [get_ports { leds[9] }];
set_property -dict { PACKAGE_PIN W3   IOSTANDARD LVCMOS33 } [get_ports { leds[10] }];
set_property -dict { PACKAGE_PIN U3   IOSTANDARD LVCMOS33 } [get_ports { leds[11] }];
set_property -dict { PACKAGE_PIN P3   IOSTANDARD LVCMOS33 } [get_ports { leds[12] }];
set_property -dict { PACKAGE_PIN N3   IOSTANDARD LVCMOS33 } [get_ports { leds[13] }];
set_property -dict { PACKAGE_PIN P1   IOSTANDARD LVCMOS33 } [get_ports { leds[14] }];
set_property -dict { PACKAGE_PIN L1   IOSTANDARD LVCMOS33 } [get_ports { leds[15] }];

# 7 SEGMENT - anodes

set_property -dict { PACKAGE_PIN W4     IOSTANDARD LVCMOS33 } [get_ports { anodes[3] }];
set_property -dict { PACKAGE_PIN V4     IOSTANDARD LVCMOS33 } [get_ports { anodes[2] }];
set_property -dict { PACKAGE_PIN U4     IOSTANDARD LVCMOS33 } [get_ports { anodes[1] }];
set_property -dict { PACKAGE_PIN U2     IOSTANDARD LVCMOS33 } [get_ports { anodes[0] }];

# 7 SEGMENT - cathodes
set_property -dict { PACKAGE_PIN W7     IOSTANDARD LVCMOS33 } [get_ports { sev_seg[6] }];
set_property -dict { PACKAGE_PIN W6     IOSTANDARD LVCMOS33 } [get_ports { sev_seg[5] }];
set_property -dict { PACKAGE_PIN U8     IOSTANDARD LVCMOS33 } [get_ports { sev_seg[4] }];
set_property -dict { PACKAGE_PIN V8     IOSTANDARD LVCMOS33 } [get_ports { sev_seg[3] }];
set_property -dict { PACKAGE_PIN U5     IOSTANDARD LVCMOS33 } [get_ports { sev_seg[2] }];
set_property -dict { PACKAGE_PIN V5     IOSTANDARD LVCMOS33 } [get_ports { sev_seg[1] }];
set_property -dict { PACKAGE_PIN U7     IOSTANDARD LVCMOS33 } [get_ports { sev_seg[0] }];
