`ifndef REG_DEFINES__VH
`define REG_DEFINES__VJ

// control registers
`define DCFIFO_REG_BASEADDR   8'h0
// reset: W; bit 0, 1'b1 = sw reset; bit [7:1] reserved.
`define DCFIFO_REG_ADDR_RESET 8'h0
// configure: W/R; bit 0 - 1'b1 = FWFT(first word fall through), 1'b0 = normal.
`define DCFIFO_REG_ADDR_CFG   8'h1
// status: R; bit 0 - emtpy; bit 1 - full; bit [7:2] reserved.
`define DCFIFO_REF_ADDR_STATUS   8'h2

`endif // REG_DEFINES__VH