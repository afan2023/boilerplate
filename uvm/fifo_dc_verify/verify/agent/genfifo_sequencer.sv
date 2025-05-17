`ifndef GENFIFO_SEQUENCER__SV
`define GENFIFO_SEQUENCER__SV

class genfifo_sequencer extends uvm_sequencer #(genfifo_transaction);
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   `uvm_component_utils(genfifo_sequencer)
endclass : genfifo_sequencer

`endif // GENFIFO_SEQUENCER__SV