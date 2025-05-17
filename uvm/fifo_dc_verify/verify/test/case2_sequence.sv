`ifndef CASE2_SEQUENCE__SV
`define CASE2_SEQUENCE__SV

import uvm_pkg::*;

class case2_reset_seq extends genfifo_base_sequence;
   `uvm_object_utils(case2_reset_seq);

   function new(string name = "case2_reset_seq");
      super.new(name);
   endfunction : new   
   
   virtual task body();
      genfifo_transaction tr = new("reset");
      start_item(tr);
      tr.reset = 1'b1;
      tr.rst_time = 120;
      tr.clear = 1'b0;
      tr.rcount = 0;
      tr.wdata = new [0];
      finish_item(tr);
   endtask : body
endclass : case2_reset_seq

class case2_write_seq extends genfifo_base_sequence;
   `uvm_object_utils(case2_write_seq);
   genfifo_transaction tr;

   function new(string name = "case2_write_seq");
      super.new(name);
   endfunction : new

   virtual task body();
      repeat(8) begin
         `uvm_create(tr);
         assert(tr.randomize() with {wdata.size == 1; rcount == 0;});
         // tr.reset = 1'b0; tr.clear = 1'b0; // new default
         `uvm_send(tr);
      end
   endtask : body
endclass : case2_write_seq

class case2_read_seq extends genfifo_base_sequence;
   `uvm_object_utils(case2_read_seq);
   genfifo_transaction tr;

   function new(string name = "case2_read_seq");
      super.new(name);
   endfunction : new

   virtual task body();
      repeat(8) begin
         `uvm_create(tr);
         assert(tr.randomize() with {wdata.size == 0; rcount == 1;});
         `uvm_send(tr);
      end
   endtask : body
endclass : case2_read_seq

class case2_vseq extends uvm_sequence;

   `uvm_object_utils(case2_vseq)
   `uvm_declare_p_sequencer(genfifo_sequencer)
   
   function new(string name= "case3_vseq");
      super.new(name);
   endfunction : new

   extern virtual task body();
   
`ifndef UVM_POST_VERSION_1_1
   extern function uvm_phase get_starting_phase();
   extern function void set_starting_phase(uvm_phase phase);
`endif

endclass : case2_vseq

task case2_vseq::body();
   case2_reset_seq seq_rst;
   case2_write_seq seq_wr;
   case2_read_seq seq_rd;
   uvm_phase phase;
   `uvm_info(get_type_name(), "in body...", UVM_HIGH)
   phase = get_starting_phase();
   if(phase != null) 
      phase.raise_objection(this);
   else
      `uvm_error(get_type_name, "starting phase is null, can not complete the test sequence.")      
   seq_rst = new("seq_rst");
   seq_wr = new("seq_wr");
   seq_rd = new("seq_rd");
   p_sequencer.set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
   // fork
   //    seq_rst.start(env.i_agt.sqr, null, 100); // priority of seq_rst set to 100, will run first
   //    seq_wr.start(env.i_agt.sqr); // default priority is -1
   //    seq_rd.start(env.i_agt.sqr); 
   // join
   fork
      seq_rst.start(p_sequencer, null, 100); // priority of seq_rst set to 100, will run first
      seq_wr.start(p_sequencer); // default priority is -1
      seq_rd.start(p_sequencer); 
   join
   #100;
   if(phase != null) 
      phase.drop_objection(this);
   `uvm_info(get_type_name(), "exit body.", UVM_HIGH)
endtask : body

`ifndef UVM_POST_VERSION_1_1
function uvm_phase case2_vseq::get_starting_phase();
   `uvm_info(get_type_name(), "get starting phase", UVM_MEDIUM);
   return starting_phase;
endfunction: get_starting_phase

function void case2_vseq::set_starting_phase(uvm_phase phase);
  starting_phase = phase;
endfunction: set_starting_phase
`endif // UVM_POST_VERSION_1_1

`endif // CASE2_SEQUENCE__SV