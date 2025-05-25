`ifndef REG_BUS_AGENT__SV
`define REG_BUS_AGENT__SV

class reg_bus_agent extends uvm_agent;
   `uvm_component_utils(reg_bus_agent)

   reg_bus_sequencer sqr;
   reg_bus_driver    drv;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass : reg_bus_agent

function void reg_bus_agent::build_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "in build phase...", UVM_HIGH)
   super.build_phase(phase);
   // auto predict
   sqr = reg_bus_sequencer::type_id::create("sqr", this);
   drv = reg_bus_driver::type_id::create("drv", this);
   `uvm_info(get_type_name(), "exit build phase.", UVM_HIGH)
endfunction : build_phase

function void reg_bus_agent::connect_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "in connect phase...", UVM_HIGH)
   drv.seq_item_port.connect(sqr.seq_item_export);
   `uvm_info(get_type_name(), "exit connect phase.", UVM_HIGH)
endfunction: connect_phase

`endif // REG_BUS_AGENT__SV