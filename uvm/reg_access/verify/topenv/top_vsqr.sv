`ifndef TOP_VSQR__SV
`define TOP_VSQR__SV

class top_vsqr extends uvm_sequencer;
   `uvm_component_utils(top_vsqr)
   
   // collects sequencers from sub envs, for convenience
   reg_bus_sequencer p_reg_sqr;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
endclass : top_vsqr

`endif // TOP_VSQR__SV