`ifndef TOP_ENV__SV
`define TOP_ENV__SV

class top_env extends uvm_env;
   `uvm_component_utils(top_env)

   // sub-env
   reg_bus_env reg_env;

   // and let's have a virtual sequencer?
   top_vsqr vsqr;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   // extern virtual function void end_of_elaboration_phase(uvm_phase phase);
endclass : top_env

function void top_env::build_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "in build phase...", UVM_HIGH)
   reg_env = reg_bus_env::type_id::create("reg_env", this);
   vsqr = top_vsqr::type_id::create("vsqr", this);
   `uvm_info(get_type_name(), "exit build phase.", UVM_HIGH)
endfunction : build_phase

function void top_env::connect_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "in connect phase...", UVM_HIGH)
   // fifo_env.mdl.p_rm = reg_env.regmodel;
   // vsqr.p_fifo_sqr = fifo_env.i_agt.sqr;
   // `uvm_info(get_type_name(), "vsqr.p_fifo_sqr = fifo_env.i_agt.sqr;", UVM_MEDIUM)
   // if (vsqr.p_fifo_sqr == null || fifo_env.i_agt.sqr == null)
   //    `uvm_error(get_type_name(), "NULL sequencer!")
   vsqr.p_reg_sqr = reg_env.agt.sqr;
   // may collect sequencers in other sub env into vsqr for convenience
   `uvm_info(get_type_name(), "exit connect phase.", UVM_HIGH)
endfunction : connect_phase

`endif // TOP_ENV__SV