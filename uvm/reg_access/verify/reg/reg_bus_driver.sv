`ifndef REG_BUS_DRIVER__SV
`define REG_BUS_DRIVER__SV

class reg_bus_driver extends uvm_driver#(reg_bus_transaction);
   `uvm_component_utils(reg_bus_driver)
   
   virtual reg_bus_if #(.REG_AW(`REG_BUS_AW), .REG_DW(`REG_BUS_DW)) vif;

   function new(string name="reg_bus_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual reg_bus_if #(.REG_AW(`REG_BUS_AW), .REG_DW(`REG_BUS_DW)))::get(this, "", "vif", vif))
         `uvm_fatal(get_type_name(), "virtual interface must be set for vig!!!")
   endfunction : build_phase

   extern virtual task run_phase(uvm_phase phase);
   extern task drive_one(reg_bus_transaction rreq);

endclass : reg_bus_driver

task reg_bus_driver::run_phase(uvm_phase phase);
   forever begin
      seq_item_port.get_next_item(req);
      drive_one(req);
      seq_item_port.item_done();
   end
endtask : run_phase

task reg_bus_driver::drive_one(reg_bus_transaction rreq);
   `uvm_info(get_type_name(), "drive one request...", UVM_HIGH)
   @(posedge vif.clk) begin
      vif.reg_req <= 1'b1;
      vif.reg_wr <= rreq.reg_wr;
      vif.reg_addr <= rreq.reg_addr;
      if (rreq.reg_wr) begin
         vif.reg_wdata <= rreq.reg_data;
         `uvm_info(get_type_name(), $sformatf("write reg@'h%0h : 'h%0h", rreq.reg_addr, rreq.reg_data), UVM_HIGH)
      end
   end
   @(posedge vif.clk) begin
      vif.reg_req <= 1'b0;
      vif.reg_wr <= 1'b0;
   end
   @(posedge vif.clk) begin
      if (!rreq.reg_wr) begin
         rreq.reg_data = vif.reg_rdata; 
         `uvm_info(get_type_name(), $sformatf("read reg@'h%0h : 'h%0h", rreq.reg_addr, rreq.reg_data), UVM_HIGH)
      end
   end
   `uvm_info(get_type_name(), "end driving one request.", UVM_HIGH)
endtask : drive_one

`endif