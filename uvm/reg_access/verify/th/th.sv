module th;

   // clocks
   logic clk   =  0;
   logic rst_n =  0;

   // clock generation
   always #15 clk = ~clk;

   // interfaces
   reg_bus_if #(.REG_AW(`REG_BUS_AW), .REG_DW(`REG_BUS_DW))  reg_if (clk, rst_n);

   initial // power on hard reset
   begin
      rst_n = 1'b0;
      #50 rst_n = 1'b1;
   end

   initial begin
      reg_if.reg_req = 1'b0;
   end

   // uut instantiation
   mmreg_dummy #(
      .REG_DW  (`REG_BUS_DW),
      .REG_AW  (`REG_BUS_AW)
   ) uut (
      .rst_n      (  rst_n             ),  
      .clk        (  clk               ),
      .reg_req    (  reg_if.reg_req    ),
      .reg_wr     (  reg_if.reg_wr     ),  
      .reg_addr   (  reg_if.reg_addr   ),  
      .reg_wdata  (  reg_if.reg_wdata  ), 
      .reg_rdata  (  reg_if.reg_rdata  )
);

endmodule