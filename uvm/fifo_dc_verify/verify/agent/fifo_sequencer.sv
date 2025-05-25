`ifndef FIFO_SEQUENCER__SV
`define FIFO_SEQUENCER__SV

class fifo_sequencer extends uvm_sequencer #(fifo_transaction);
   `uvm_component_utils(fifo_sequencer)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
endclass : fifo_sequencer

`endif // FIFO_SEQUENCER__SV