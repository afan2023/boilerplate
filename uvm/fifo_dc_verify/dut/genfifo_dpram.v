
module genfifo_dpram #(
    parameter addr_width = 8    ,
    parameter data_width = 8
)(
    input                       wclk    ,   // write clock
    input                       wrst    ,   // high active
    input                       we      ,
    input   [addr_width-1:0]    waddr   ,   // write address input
    input   [data_width-1:0]    di      ,   // write data input

    input                       rclk    ,
    input                       rrst    ,
    input   [addr_width-1:0]    raddr   ,
    input                       oe      ,   // output enable
    output  [data_width-1:0]    do          // read data output
);

    localparam  ram_depth   =   1<<addr_width    ;
    reg [data_width-1:0]    ram [0:ram_depth-1] ;

    always @(posedge wclk, posedge wrst) begin
        if (wrst)
            ; //$display("Que faire?");
        else if (we)
            ram[waddr] <= di    ;
    end

   //  always @(posedge rclk, posedge rrst) begin
   //      if (rrst)
   //          do <= {data_width{1'b0}};
   //      else if (oe)
   //          do <= ram[raddr];
   //      else
   //          do <= {data_width{1'b0}};
   //  end

   // FWFT
   assign do = oe ? ram[raddr] : {data_width{1'b0}};

endmodule