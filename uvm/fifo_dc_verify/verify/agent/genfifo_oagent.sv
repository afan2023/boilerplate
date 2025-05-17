`ifndef GENFIFO_OAGENT__SV
`define GENFIFO_OAGENT__SV

class genfifo_oagent extends uvm_agent ;
   `uvm_component_utils(genfifo_oagent)
   genfifo_omonitor    mon;
   
   uvm_analysis_port #(fifo_data_item) ap_data;
   uvm_analysis_port #(fifo_action_item) ap_act;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass : genfifo_oagent

function void genfifo_oagent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   mon = genfifo_omonitor::type_id::create("mon", this);
endfunction 

function void genfifo_oagent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   ap_data = mon.ap_data;
   ap_act = mon.ap_act;
endfunction

`endif // GENFIFO_OAGENT__SV