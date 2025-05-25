`ifndef FIFO_MONITOR__SV
`define FIFO_MONITOR__SV
class fifo_monitor extends uvm_monitor;

   `uvm_component_utils(fifo_monitor)

   virtual fifo_dc_if   fifo_vif ;
   virtual fifo_rst_if  rst_vif  ;

   event    rst_event;

   uvm_analysis_port #(fifo_data_item) ap_data;
   uvm_analysis_port #(fifo_action_item) ap_act;

   function new(string name = "fifo_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // simply take in the vif passed on
      if(!uvm_config_db#(virtual fifo_dc_if)::get(this, "", "fifo_vif", fifo_vif))
         `uvm_fatal(get_type_name(), "virtual interface must be set for fifo_vif!!!")
      if(!uvm_config_db#(virtual fifo_rst_if)::get(this, "", "rst_vif", rst_vif))
         `uvm_fatal(get_type_name(), "virtual interface must be set for rst_vif!!!")
      // create the analysis ports
      ap_data = new("ap_data", this);
      ap_act = new("ap_act", this);
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect();
endclass

task fifo_monitor::main_phase(uvm_phase phase);
   `uvm_info(get_type_name(), "in main phase...", UVM_HIGH)
   collect();
   `uvm_info(get_type_name(), "exit main phase.", UVM_HIGH)
endtask

task fifo_monitor::collect();
   fifo_action_item tr;
   fifo_data_item tx, rx;
   `uvm_info(get_type_name(), "begin to collect data items", UVM_HIGH);

   fork

      forever begin
         @(posedge fifo_vif.wclk)
         begin
            if (fifo_vif.we) begin
               tx = new("tx");
               tx.wr = 1'b1;
               tx.data = fifo_vif.din;
               `uvm_info(get_type_name(), $sformatf("got a write, data = 'h%0h", tx.data), UVM_HIGH);
               ap_data.write(tx);
            end
         end
      end

      forever begin // to collect the read event... 
         @(posedge fifo_vif.rclk)
         begin
            // in case normal
            if (fifo_vif.re) begin
               rx = new("rx");
               rx.wr = 1'b0;
               `uvm_info(get_type_name(), "got a read", UVM_HIGH);
               // rx.data = fifo_vif.dout; // skip because this data won't matter
               // this will be sent to ref model 
               // (and in turn the ref model pop a data it received before on write event, to send to scoreboard)
               ap_data.write(rx);
            end
         end
      end

      forever begin
         @rst_event;
         `uvm_info(get_type_name(), "a reset / clear detected", UVM_MEDIUM);
         tr = new("tr");
         tr.hasreset = 1'b1;
         tr.empty = fifo_vif.empty;
         ap_act.write(tr);
      end

   join

   `uvm_info(get_type_name(), "end collect data items", UVM_HIGH)
endtask : collect

`endif // FIFO_MONITOR__SV
