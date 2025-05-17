`ifndef FIFO_ACTION_ITEM__SV
`define FIFO_ACTION_ITEM__SV

class fifo_action_item extends uvm_sequence_item;

   `uvm_object_utils(fifo_action_item);
   bit   hasreset ;  // set if performed a reset action
   bit   empty ;  // result status

   function new(string name = "fifo_action_item");
      super.new();
      hasreset = 1'b0;
      empty = 1'b0;
   endfunction

endclass : fifo_action_item

`endif // FIFO_ACTION_ITEM__SV