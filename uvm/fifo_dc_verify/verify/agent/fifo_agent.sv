`ifndef FIFO_AGENT__SV
`define FIFO_AGENT__SV

class fifo_agent extends uvm_agent;
   `uvm_component_utils(fifo_agent)

   fifo_sequencer  sqr;
   fifo_driver     drv;
   fifo_monitor    mon;

   event    rst_event;
   
   // uvm_analysis_port #(fifo_transaction)  ap;
   uvm_analysis_port #(fifo_data_item) ap_data;
   uvm_analysis_port #(fifo_action_item) ap_act;
   
   function new(string name = "fifo_agent", uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass : fifo_agent


function void fifo_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   sqr = fifo_sequencer::type_id::create("sqr", this);
   drv = fifo_driver::type_id::create("drv", this);
   mon = fifo_monitor::type_id::create("mon", this);
endfunction 

function void fifo_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   drv.seq_item_port.connect(sqr.seq_item_export);
   ap_data = mon.ap_data;
   ap_act = mon.ap_act;
   drv.rst_event = rst_event;
   mon.rst_event = rst_event;   
endfunction

`endif // FIFO_AGENT__SV