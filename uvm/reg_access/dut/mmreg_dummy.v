`include "reg_defines.vh"

module mmreg_dummy #(
   parameter REG_DW = 8,
   parameter REG_AW = 8
)(
   input                rst_n    ,  // global reset
   // reg access
   input                clk      ,
   input                reg_req  ,  // 1: valid reg access request, 0: no request
   input                reg_wr   ,  // 1: write, 0: read
   input [REG_AW-1:0]   reg_addr ,  // reg address
   input [REG_DW-1:0]   reg_wdata,  // reg write data
   output[REG_DW-1:0]   reg_rdata   // reg read data
   // no work interface (functionality skipped) 
);

   reg [REG_DW-1:0] rg_cfg; // rg_cfg register

   // a simple counter as example
   localparam MAX_CNT = 2**8 - 9;
   localparam CNT_WIDTH = $clog2(MAX_CNT) + 1;
   reg [CNT_WIDTH-1:0] dummy_cnt;
   // status
   reg overflow;
   wire zero = overflow ? 0 : (dummy_cnt == {CNT_WIDTH{1'b0}});
   // go / stop
   wire go = rg_cfg[0];
   // reset
   wire do_reset = reg_req && reg_wr && (reg_addr == `MM_REG_ADDR_RESET) && reg_wdata[0];

   // reg read
   reg [REG_DW-1:0] reg_rdata_r;
   assign reg_rdata = reg_rdata_r;
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         reg_rdata_r <= {REG_DW{1'b0}};
      end
      if (reg_req && !reg_wr) begin
         case (reg_addr)
         `MM_REG_ADDR_CFG :
            reg_rdata_r <= rg_cfg;
         `MM_REG_ADDR_STATUS :
            reg_rdata_r <= {{(REG_DW-2){1'b0}}, overflow, zero};
         default:
            reg_rdata_r <= {REG_DW{1'b0}};
         endcase
      end
   end

   // write cfg
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         rg_cfg <= {REG_DW{1'b0}};
      end
      else if (do_reset) begin
         rg_cfg <= {REG_DW{1'b0}};
      end
      else begin
         if (reg_req && reg_wr) begin
            case (reg_addr)
            `MM_REG_ADDR_CFG    :
               rg_cfg <= reg_wdata;
            default  :  ;
            endcase
         end
      end
   end

   // the toy has a counter with soft reset & go
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         dummy_cnt <= {CNT_WIDTH{1'b0}};
      end
      else if (do_reset) begin
         dummy_cnt <= {CNT_WIDTH{1'b0}};
      end
      else if (go) begin
         dummy_cnt <= dummy_cnt + 1'b1;
      end
   end
   always@(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         overflow <= 1'b0;
      end
      else if (do_reset) begin
         overflow <= 1'b0;
      end
      else if (go && (dummy_cnt >= MAX_CNT)) begin
         overflow <= 1'b1;
      end
   end

endmodule // mmreg_dummy
