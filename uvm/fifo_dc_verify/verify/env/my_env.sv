`ifndef MY_ENV__SV
`define MY_ENV__SV

class my_env extends uvm_env;
   `uvm_component_utils(my_env)

   genfifo_agent  i_agt;
   genfifo_oagent o_agt;
   myfifo_model   mdl;
   my_scoreboard  scb;
   
   uvm_tlm_analysis_fifo #(fifo_data_item) iagt_mdl_data_fifo;
   uvm_tlm_analysis_fifo #(fifo_action_item) iagt_mdl_act_fifo;
   uvm_tlm_analysis_fifo #(fifo_data_item) mdl_scb_fifo;
   // uvm_tlm_analysis_fifo #(fifo_action_item) oagt_mdl_act_fifo;
   uvm_tlm_analysis_fifo #(fifo_data_item) oagt_scb_fifo;
   
   function new(string name = "my_env", uvm_component parent);
      super.new(name, parent);
   endfunction

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
endclass : my_env

function void my_env::build_phase(uvm_phase phase);
      super.build_phase(phase);
      // components
      i_agt = genfifo_agent::type_id::create("i_agt", this);
      o_agt = genfifo_oagent::type_id::create("o_agt", this);
      scb = my_scoreboard::type_id::create("scb", this);
      mdl = new("mdl", this);
      // message channels
      iagt_mdl_data_fifo = new("iagt_mdl_data_fifo", this);
      iagt_mdl_act_fifo = new("iagt_mdl_act_fifo", this);
      mdl_scb_fifo = new("mdl_scb_fifo", this);
      // oagt_mdl_act_fifo = new("oagt_mdl_act_fifo", this);
      oagt_scb_fifo = new("oagt_scb_fifo", this);
endfunction : build_phase

function void my_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   // i_agt -- mdl, data connection
   i_agt.ap_data.connect(iagt_mdl_data_fifo.analysis_export); // connect to a uvm_analysis_imp in the fifo
   mdl.port_data.connect(iagt_mdl_data_fifo.blocking_get_export); // the fifo's blocking_get_exportasctually aliased to uvm_get_peek_imp #(T, this_type) get_peek_export; 
   // i_agt -- mdl, act connection
   i_agt.ap_act.connect(iagt_mdl_act_fifo.analysis_export);
   mdl.port_act.connect(iagt_mdl_act_fifo.blocking_get_export);
   // mdl -- scb, data connection
   mdl.ap_data.connect(mdl_scb_fifo.analysis_export);
   scb.exp_data_port.connect(mdl_scb_fifo.blocking_get_export);
   // o_agt -- mdl, act connection
   // o_agt.ap_act.connect(oagt_mdl_act_fifo.analysis_export);
   // mdl.port_oact.connect(oagt_mdl_act_fifo.blocking_get_export);
   // o_agt -- scb, data connection
   o_agt.ap_data.connect(oagt_scb_fifo.analysis_export);
   scb.act_data_port.connect(oagt_scb_fifo.blocking_get_export);
endfunction

`endif
