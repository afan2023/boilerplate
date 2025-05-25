`ifndef FIFO_OAGENT__SV
`define FIFO_OAGENT__SV

class fifo_oagent extends uvm_agent ;
   `uvm_component_utils(fifo_oagent)
   fifo_omonitor  mon;
   
   uvm_analysis_port #(fifo_data_item) ap_data;
   uvm_analysis_port #(fifo_action_item) ap_act;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass : fifo_oagent

function void fifo_oagent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   mon = fifo_omonitor::type_id::create("mon", this);
endfunction 

function void fifo_oagent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   ap_data = mon.ap_data;
   ap_act = mon.ap_act;
endfunction

`endif // FIFO_OAGENT__SV