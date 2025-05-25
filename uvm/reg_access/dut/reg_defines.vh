`ifndef REG_DEFINES__VH
`define REG_DEFINES__VH

// base address
`define MM_REG_BASEADDR    'h0
// reset: W; bit 0, 1'b1 = soft reset; other bits reserved.
`define MM_REG_ADDR_RESET  'h0
// configure: W/R; bit 0 - 1'b1 = go and do your job, 1'b0 = do nothing.
`define MM_REG_ADDR_CFG    'h2
// status: R; bit 0 - zero; bit 1 - overflow; other bits reserved.
`define MM_REG_ADDR_STATUS 'h4

`endif // REG_DEFINES__VH