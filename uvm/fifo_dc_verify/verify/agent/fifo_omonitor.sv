`ifndef FIFO_OMONITOR__SV
`define FIFO_OMONITOR__SV
class fifo_omonitor extends uvm_monitor;

   `uvm_component_utils(fifo_omonitor)

   virtual fifo_dc_if   fifo_vif ;
   virtual fifo_rst_if  rst_vif  ;

   uvm_analysis_port #(fifo_data_item) ap_data;
   uvm_analysis_port #(fifo_action_item) ap_act;

   function new(string name = "fifo_omonitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual fifo_dc_if)::get(this, "", "fifo_vif", fifo_vif))
         `uvm_fatal("fifo_omonitor", "virtual interface must be set for fifo_vif!!!")
      if(!uvm_config_db#(virtual fifo_rst_if)::get(this, "", "rst_vif", rst_vif))
         `uvm_fatal("fifo_omonitor", "virtual interface must be set for rst_vif!!!")
      ap_data = new("ap_data", this);
      ap_act = new("ap_act", this);
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one();
   // extern task monitor_clear();
endclass

task fifo_omonitor::main_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "begin to collect data items", UVM_HIGH)
   forever begin
      collect_one();
   end
   `uvm_info(get_type_name(), "end collect data items", UVM_HIGH)
endtask : main_phase

task fifo_omonitor::collect_one();
   fifo_action_item act;
   fifo_data_item   rx;
   bit reading = 1'b0;

   reading = fifo_vif.re;
   @(posedge fifo_vif.rclk) 
   begin
      if (reading) begin
         rx = new("rx");
         rx.wr = 1'b0;
         rx.data = fifo_vif.dout;
         `uvm_info(get_type_name(), {"got a data read: ", $sformatf("'h%0h", rx.data)}, UVM_HIGH)
         #0 ap_data.write(rx);
      end
   end

   `uvm_info(get_type_name(), "end collect one...", UVM_HIGH)
endtask : collect_one

`endif // FIFO_OMONITOR__SV
