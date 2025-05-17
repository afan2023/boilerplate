`ifndef CASE2__SV
`define CASE2__SV

class case2 extends base_test;
   `uvm_component_utils(case2)
   
   function new(string name = "case2", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   
   extern virtual task main_phase(uvm_phase phase);
endclass : case2

task case2::main_phase(uvm_phase phase);
   case2_vseq vseq;
   `uvm_info("test case2", "in main phase...", UVM_HIGH);
   // phase.raise_objection(this);
   // env.i_agt.sqr.set_arbitration(SEQ_ARB_STRICT_FIFO); // first respect priority, then respect fifo if same priority
   vseq = case2_vseq::type_id::create("vseq");
   vseq.set_starting_phase(phase);
   vseq.start(this.env.i_agt.sqr);
   // phase.drop_objection(this);
   `uvm_info("test case2", "main phase done.", UVM_HIGH);
endtask : main_phase

`endif // CASE2__SV