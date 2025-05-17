`ifndef GENFIFO_AGENT__SV
`define GENFIFO_AGENT__SV

class genfifo_agent extends uvm_agent;
   `uvm_component_utils(genfifo_agent)
   // `uvm_component_utils(my_agent)

   genfifo_sequencer  sqr;
   genfifo_driver     drv;
   genfifo_monitor    mon;

   event    rst_event;
   
   // uvm_analysis_port #(genfifo_transaction)  ap;
   uvm_analysis_port #(fifo_data_item) ap_data;
   uvm_analysis_port #(fifo_action_item) ap_act;
   
   function new(string name = "genfifo_agent", uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass : genfifo_agent


function void genfifo_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   sqr = genfifo_sequencer::type_id::create("sqr", this);
   drv = genfifo_driver::type_id::create("drv", this);
   mon = genfifo_monitor::type_id::create("mon", this);
endfunction 

function void genfifo_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   drv.seq_item_port.connect(sqr.seq_item_export);
   ap_data = mon.ap_data;
   ap_act = mon.ap_act;
   drv.rst_event = rst_event;
   mon.rst_event = rst_event;   
endfunction

`endif // GENFIFO_AGENT__SV