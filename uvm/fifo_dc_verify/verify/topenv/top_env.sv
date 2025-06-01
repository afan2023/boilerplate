`ifndef TOP_ENV__SV
`define TOP_ENV__SV

class top_env extends uvm_env;
   `uvm_component_utils(top_env)

   // sub-env
   reg_bus_env reg_env ;
   fifo_env    the_fifo_env;

   // and let's have a virtual sequencer?
   top_vsqr vsqr;

   // a channel between reg bus mon & fifo model
   uvm_tlm_analysis_fifo #(reg_action_item) reg_agt_fifo_mdl_act_fifo;


   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
endclass : top_env

function void top_env::build_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "in build phase...", UVM_HIGH)
   reg_env = reg_bus_env::type_id::create("reg_env", this);
   the_fifo_env = fifo_env::type_id::create("the_fifo_env", this);
   vsqr = top_vsqr::type_id::create("vsqr", this);
   reg_agt_fifo_mdl_act_fifo = new("reg_agt_fifo_mdl_act_fifo", this);
   `uvm_info(get_type_name(), "exit build phase.", UVM_HIGH)
endfunction : build_phase

function void top_env::connect_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "in connect phase...", UVM_HIGH)
   // the_fifo_env.mdl.p_rm = reg_env.regmodel;
   reg_env.agt.mon.ap_act.connect(reg_agt_fifo_mdl_act_fifo.analysis_export);
   the_fifo_env.mdl.port_reg_act.connect(reg_agt_fifo_mdl_act_fifo.blocking_get_export);

   vsqr.p_fifo_sqr = the_fifo_env.i_agt.sqr;
   vsqr.p_reg_sqr = reg_env.agt.sqr;
   `uvm_info(get_type_name(), "exit connect phase.", UVM_HIGH)
endfunction : connect_phase

`endif // TOP_ENV__SV