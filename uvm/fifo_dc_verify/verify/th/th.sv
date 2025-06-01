module th;

   // clocks
   logic clk   =  0;
   logic wclk  =  0;
   logic rclk  =  0;

   // clock generation
   always #15 clk = ~clk;
   always #10 wclk = ~wclk;
   always #30 rclk = ~rclk;

   // interfaces
   fifo_rst_if rst_if (clk, wclk, rclk);
   fifo_dc_if  fifo_if(wclk, rclk);
   reg_bus_if  reg_if (clk);

   // initial
   initial // power on hard reset
   begin
      rst_if.rst_n      = 1'b0;  // Active low
      #120 rst_if.rst_n = 1'b1;
   end

   initial begin
      reg_if.reg_req = 1'b0;
      fifo_if.we     = 1'b0;
      fifo_if.re     = 1'b0;
   end

   // uut instantiation
   dc_fifo_wrapper #(
      .DW      (`FIFO_DW   ),
      .AW      (`FIFO_AW   ),
      .REG_DW  (`REG_BUS_DW),
      .REG_AW  (`REG_BUS_AW)
   ) uut (
      .rst_n      (  rst_if.rst_n      ),  
      .clk        (  clk               ),
      .reg_req    (  reg_if.reg_req    ),
      .reg_wr     (  reg_if.reg_wr     ),  
      .reg_addr   (  reg_if.reg_addr   ),  
      .reg_wdata  (  reg_if.reg_wdata  ), 
      .reg_rdata  (  reg_if.reg_rdata  ), 
      .rd_clk     (  rclk              ),  
      .wr_clk     (  wclk              ),  
      .din        (  fifo_if.din       ),  
      .we         (  fifo_if.we        ),  
      .dout       (  fifo_if.dout      ),  
      .re         (  fifo_if.re        ),  
      .full       (  fifo_if.full      ),     
      .empty      (  fifo_if.empty     )
);

endmodule