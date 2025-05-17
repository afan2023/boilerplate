`ifndef CASE1__SV
`define CASE1__SV

class case1 extends base_test;
   `uvm_component_utils(case1)

   function new(string name = "case1", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase); 
endclass : case1

function void case1::build_phase(uvm_phase phase);
   super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.i_agt.sqr.main_phase", 
                                           "default_sequence", 
                                           case1_sequence::type_id::get());
endfunction

`endif // CASE1__SV