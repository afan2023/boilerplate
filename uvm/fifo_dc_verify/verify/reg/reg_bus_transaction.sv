`ifndef REG_BUS_TRANSACTION__SV
`define REG_BUS_TRANSACTION__SV

class reg_bus_transaction extends uvm_sequence_item;

   `uvm_object_utils(reg_bus_transaction);

   bit                     reg_wr   ;
   bit [`REG_BUS_AW-1:0]   reg_addr ;
   bit [`REG_BUS_DW-1:0]   reg_data ;

   function new(string name = "");
      super.new(name);
   endfunction

endclass : reg_bus_transaction

`endif // REG_BUS_TRANSACTION__SV