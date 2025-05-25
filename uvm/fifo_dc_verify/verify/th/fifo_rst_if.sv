`ifndef FIFO_RST_IF__SV
`define FIFO_RST_IF__SV

interface fifo_rst_if (input wclk, input rclk);

   logic rst_n ;
   logic clr   ;
   
endinterface

`endif // FIFO_RST_IF__SV