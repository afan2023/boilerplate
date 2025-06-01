`ifndef REG_ACTION_ITEM__SV
`define REG_ACTION_ITEM__SV

class reg_action_item extends uvm_sequence_item;

   `uvm_object_utils(reg_action_item);
   bit   softreset ;  // set if performed a soft reset

   function new(string name = "fifo_action_item");
      super.new();
      softreset = 1'b1;
   endfunction

endclass : reg_action_item

`endif // REG_ACTION_ITEM__SV