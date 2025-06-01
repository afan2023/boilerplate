
`include "reg_defines.vh"

module dc_fifo_wrapper #(
   parameter DW = 8,
   parameter AW = 8,
   parameter REG_DW = 8,
   parameter REG_AW = 8
)(
   input                rst_n    ,  // global reset
   // simple mm reg access
   input                clk      ,
   input                reg_req  ,  // 1: valid reg access request, 0: no request
   input                reg_wr   ,  // 1: write, 0: read
   input [REG_AW-1:0]   reg_addr ,  // reg address
   input [REG_DW-1:0]   reg_wdata,  // reg write data
   output[REG_DW-1:0]   reg_rdata,  // reg read data
   // fifo interface
   input                rd_clk   ,  // read clock
   input                wr_clk   ,  // write clock
   input  [AW-1:0]      din      ,  // data in      
   input                we       ,  // write enable 
   output [DW-1:0]      dout     ,  // data out     
   input                re       ,  // read enable  
   output               full     ,     
   output               empty    
);

   // RESET
   reg do_reset; 
   wire reset_done;
   // CFG
   reg [REG_DW-1:0] rg_cfg;
   wire fwft = rg_cfg[0];

   // reg read
   reg [1:0] empty_s;
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         empty_s <= 2'b0;
      else
         empty_s <= {empty_s[0], empty};
   end
   reg [1:0] full_s;
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         full_s <= 2'b00;
      else
         full_s <= {full_s[0], full};
   end
   
   reg [REG_DW-1:0] reg_rdata_r;
   assign reg_rdata = reg_rdata_r;
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         reg_rdata_r <= {REG_DW{1'b0}};
      end
      if (reg_req && !reg_wr) begin
         case (reg_addr)
         `DCFIFO_REG_ADDR_CFG :
            reg_rdata_r <= rg_cfg;
         `DCFIFO_REF_ADDR_STATUS :
            reg_rdata_r <= {{(REG_DW-2){1'b0}}, empty_s[1], full_s[1]};
         default:
            reg_rdata_r <= {REG_DW{1'b0}};
         endcase
      end
   end

   // reg write
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         do_reset <= 1'b0;
         rg_cfg <= {REG_DW{1'b0}};
      end
      else begin
         if (reg_req && reg_wr) begin
            case (reg_addr)
            `DCFIFO_REG_ADDR_RESET  :
               if (reg_wdata[0]) begin
                  do_reset <= 1'b1;
                  rg_cfg <= {REG_DW{1'b0}};
               end
            `DCFIFO_REG_ADDR_CFG    :
               rg_cfg <= reg_wdata;
            endcase
         end
         else if (reset_done)
            do_reset <= 1'b0;
      end
   end

   // soft reset
   reg [1:0] do_reset_sw;
   always @(posedge wr_clk or negedge rst_n) begin
      if (!rst_n)
         do_reset_sw <= 2'b00;
      else begin
         do_reset_sw <= {do_reset_sw[0], do_reset};
      end
   end
   reg [1:0] do_reset_sr;
   always @(posedge rd_clk or negedge rst_n) begin
      if (!rst_n)
         do_reset_sr <= 2'b00;
      else begin
         do_reset_sr <= {do_reset_sr[0], do_reset};
      end
   end
   // wire do_reset_s = do_reset_sw[1] & do_reset_sr[1];

   reg reset_donew;
   always @(posedge wr_clk or negedge rst_n) begin
      if (!rst_n)
         reset_donew <= 1'b0;
      // else if (do_reset_s)
      else if (do_reset_sw)
         reset_donew <= 1'b1;
      else
         reset_donew <= 1'b0;
   end

   reg reset_doner;
   always @(posedge rd_clk or negedge rst_n) begin
      if (!rst_n)
         reset_doner <= 1'b0;
      // else if (do_reset_s)
      else if (do_reset_sr)
         reset_doner <= 1'b1;
      else
         reset_doner <= 1'b0;
   end

   wire reset_done_wr = reset_donew & reset_doner;

   reg [1:0] reset_done_s;
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n)
         reset_done_s <= 2'b00;
      else
         reset_done_s <= {reset_done_s[0], reset_done_wr};
   end

   assign reset_done = reset_done_s[1];

   wire clr_eff = do_reset;

   wire [DW-1:0]  fifo_dout;
   generic_fifo_dc #( .dw(DW), .aw(AW)) u_genfifo (
      .rd_clk   ( rd_clk   ),   
      .wr_clk   ( wr_clk   ),   
      .rst      ( rst_n    ),   // low active reset
      .clr      ( clr_eff  ),   
      .din      ( din      ),   // data in      
      .we       ( we       ),   // fifo_doutwrite enable 
      .dout     ( fifo_dout),// data out     
      .re       ( re       ),   // read enable  
      .full     ( full     ),
      .empty    ( empty    )        
   ); 

   reg [DW-1:0]   fifo_dout_r;
   always @(posedge rd_clk) begin
      fifo_dout_r <= fifo_dout;
   end

   assign dout = fwft ? fifo_dout : fifo_dout_r;

endmodule // dc_fifo_wrapper
