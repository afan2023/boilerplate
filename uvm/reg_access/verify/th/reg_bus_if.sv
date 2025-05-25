`ifndef REG_BUS_IF__SV
`define REG_BUS_IF__SV

interface reg_bus_if #(
   parameter REG_AW = 8, 
   parameter REG_DW = 8
)(input clk, input rst_n);
   logic                reg_req  ;  // 1: valid access request, 0: no request
   logic                reg_wr   ;  // 1: write, 0: read
   logic [REG_AW-1:0]   reg_addr ;  // reg address
   logic [REG_DW-1:0]   reg_wdata;  // reg write data
   logic [REG_DW-1:0]   reg_rdata;  // reg read data
   
endinterface : reg_bus_if

`endif // REG_BUS_IF__SV