`ifndef FIFO_DC_IF__SV
`define FIFO_DC_IF__SV
/**
 * Essential interface of a DC FIFO.
 */

interface fifo_dc_if 
#(parameter DW = `FIFO_DW)
(input wclk, input rclk);

   logic          re    ;
   logic [DW-1:0] dout  ;
   logic          empty ;
   logic          we    ; 
   logic [DW-1:0] din   ; 
   logic          full  ; 
   
endinterface

`endif // FIFO_DC_IF__SV