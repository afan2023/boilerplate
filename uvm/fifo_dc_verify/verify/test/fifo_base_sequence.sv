`ifndef FIFO_BASE_SEQUENCE__SV
`define FIFO_BASE_SEQUENCE__SV

class fifo_base_sequence extends uvm_sequence #(fifo_transaction);
   `uvm_object_utils(fifo_base_sequence)
   `uvm_declare_p_sequencer(fifo_sequencer) // can start only on a fifo_sequencer

   function new(string name = "fifo_base_sequence");
      super.new(name);
   endfunction : new

`ifndef UVM_POST_VERSION_1_1
   extern function uvm_phase get_starting_phase();
   // extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : fifo_base_sequence

`ifndef UVM_POST_VERSION_1_1
function uvm_phase fifo_base_sequence::get_starting_phase();
   `uvm_info(get_type_name(), "get starting phase", UVM_MEDIUM);
   return starting_phase;
endfunction: get_starting_phase
// function void fifo_base_sequence::set_starting_phase(uvm_phase phase);
//   starting_phase = phase;
// endfunction: set_starting_phase
`endif

`endif // FIFO_BASE_SEQUENCE__SV