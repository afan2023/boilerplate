`ifndef REG_BUS_MONITOR__SV
`define REG_BUS_MONITOR__SV

class reg_bus_monitor extends uvm_monitor;
   `uvm_component_utils(reg_bus_monitor)

   virtual reg_bus_if   reg_vif ;

   uvm_analysis_port #(reg_action_item) ap_act;

   function new(string name = "reg_bus_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual reg_bus_if)::get(this, "", "reg_vif", reg_vif))
         `uvm_fatal(get_type_name(), "virtual interface must be set for reg_vif!!!")
      // create the analysis ports
      ap_act = new("ap_act", this);
   endfunction

   // extern task main_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
endclass : reg_bus_monitor

// task reg_bus_monitor::main_phase(uvm_phase phase);
task reg_bus_monitor::run_phase(uvm_phase phase);
   reg_action_item act;
   bit   softreset = 1'b0;
   `uvm_info(get_type_name(), "in main phase...", UVM_HIGH)
   forever begin
      // @(reg_vif.clk);
      if (reg_vif.reg_req && reg_vif.reg_wr 
         && reg_vif.reg_addr == `DCFIFO_REG_ADDR_RESET 
         && reg_vif.reg_wdata[0]
      ) 
         softreset = 1'b1;
      else
         softreset = 1'b0;

      @(reg_vif.clk);
      if (softreset) begin
         act = new("soft_rst");
         `uvm_info(get_type_name(), "got a soft reset", UVM_MEDIUM);
         ap_act.write(act);
      end

   end
   `uvm_info(get_type_name(), "exit main phase.", UVM_HIGH)
endtask

`endif // REG_BUS_MONITOR__SV