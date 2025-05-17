`ifndef DC_FIFO_IF__SV
`define DC_FIFO_IF__SV
/**
 * Essential interface of a DC FIFO.
 */

interface dc_fifo_if 
#(parameter DW = 8)
(input wclk, input rclk);

   logic          re    ;
   logic [DW-1:0] dout  ;
   logic          empty ;
   logic          we    ; 
   logic [DW-1:0] din   ; 
   logic          full  ; 
   
endinterface

`endif // DC_FIFO_IF__SV