`ifndef GENFIFO_BASE_SEQUENCE__SV
`define GENFIFO_BASE_SEQUENCE__SV

class genfifo_base_sequence extends uvm_sequence #(genfifo_transaction);
   `uvm_object_utils(genfifo_base_sequence)
   `uvm_declare_p_sequencer(genfifo_sequencer) // can start only on a genfifo_sequencer

   function new(string name = "genfifo_base_sequence");
      super.new(name);
   endfunction : new

`ifndef UVM_POST_VERSION_1_1
   extern function uvm_phase get_starting_phase();
   // extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : genfifo_base_sequence

`ifndef UVM_POST_VERSION_1_1
function uvm_phase genfifo_base_sequence::get_starting_phase();
   `uvm_info(get_type_name(), "get starting phase", UVM_MEDIUM);
   return starting_phase;
endfunction: get_starting_phase
// function void genfifo_base_sequence::set_starting_phase(uvm_phase phase);
//   starting_phase = phase;
// endfunction: set_starting_phase
`endif

`endif // GENFIFO_BASE_SEQUENCE__SV