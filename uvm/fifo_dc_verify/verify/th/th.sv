module th;

   // clocks
   logic wclk   =  0;
   logic rclk   =  0;

   // clock generation
   always #10 wclk = ~wclk;
   always #30 rclk = ~rclk;

   // interfaces
   genfifo_rst_if rst_if (wclk, rclk);
   dc_fifo_if     fifo_if(wclk, rclk);

   // // power on reset
   // initial
   // begin
   //    // inbitial reset
   //    rst_if.clr        = 1'b0;
   //    rst_if.rst_n      = 1'b0; 
   //    #75 rst_if.rst_n  = 1'b1;
   //    fifo_if.we        = 1'b0;
   //    fifo_if.re        = 1'b0;      
   // end

   // uut instantiation
   generic_fifo_dc   #( .dw(8), .aw(4)) uut (
      .rd_clk  (  rclk        ),    // read clock
      .wr_clk  (  wclk        ),    // write clock
      .rst     (  rst_if.rst_n),    // active low
      .clr     (  rst_if.clr  ),    // clear
      .din     (  fifo_if.din ),    // data in      
      .we      (  fifo_if.we  ),    // write enable 
      .dout    (  fifo_if.dout),    // data out     
      .re      (  fifo_if.re  ),    // read enable  
      .full    (  fifo_if.full),    // full
      .empty   (  fifo_if.empty)    // empty
      // other signals not in the test scope
   );

endmodule