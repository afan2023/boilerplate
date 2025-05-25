`ifndef REG_BUS_ENV__SV
`define REG_BUS_ENV__SV

// let's have a sub env
class reg_bus_env extends uvm_env;
   `uvm_component_utils(reg_bus_env)

   reg_bus_agent     agt;
   reg_bus_adaptor   adaptor; // adaptor is an object, but there's no need to manage it dynamically
   reg_model         regmodel; // or maybe create at top level, just a pointer here; put here to be better packed

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);

endclass : reg_bus_env

function void reg_bus_env::build_phase(uvm_phase phase);
   string uut_hdl_path;
   `uvm_info(get_type_name(), "in build phase.", UVM_HIGH)
   agt = reg_bus_agent::type_id::create("agt", this);
   adaptor = reg_bus_adaptor::type_id::create("adaptor", this);
   regmodel = reg_model::type_id::create("regmodel");
   regmodel.configure(null, "");
   regmodel.build();
   regmodel.lock_model();
   regmodel.reset(); // what's the result? how this reset drives the DUT?
                     // the reset() is to reset reg model itself, 
                     // no transaction to DUT at all !
   uvm_config_db#(string)::get(this, "", "uut_hdl_path", uut_hdl_path);
   `uvm_info(get_type_name(), $sformatf("uut_hdl_path = %s", uut_hdl_path), UVM_HIGH)
   // regmodel.set_hdl_path_root("top_tb.th.uut");
   regmodel.set_hdl_path_root(uut_hdl_path);
   uvm_config_db#(reg_model)::set(this, "", "regmodel", regmodel);
   `uvm_info(get_type_name(), "exit build phase.", UVM_HIGH)
endfunction : build_phase

function void reg_bus_env::connect_phase(uvm_phase phase);
   regmodel.default_map.set_sequencer(agt.sqr, adaptor);
   regmodel.default_map.set_auto_predict(1);
endfunction : connect_phase

`endif // REG_BUS_ENV__SV