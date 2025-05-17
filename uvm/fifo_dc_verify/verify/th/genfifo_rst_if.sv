`ifndef GENFIFO_RST_IF__SV
`define GENFIFO_RST_IF__SV

interface genfifo_rst_if 
#(parameter DW = 8)
(input wclk, input rclk);

   logic rst_n ;
   logic clr   ;
   
endinterface

`endif // GENFIFO_RST_IF__SV