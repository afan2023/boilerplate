`ifndef FIFO_DRIVER__SV
`define FIFO_DRIVER__SV

class fifo_driver extends uvm_driver #(fifo_transaction);

   `uvm_component_utils(fifo_driver)
   
   virtual fifo_dc_if   fifo_vif ;
   virtual fifo_rst_if  rst_vif  ;

   event    rst_event;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // simply take in the vif passed on from the tb
      if(!uvm_config_db#(virtual fifo_dc_if)::get(this, "", "fifo_vif", fifo_vif))
         `uvm_fatal(get_type_name(), "virtual interface must be set for fifo_vif!!!")
      if(!uvm_config_db#(virtual fifo_rst_if)::get(this, "", "rst_vif", rst_vif))
         `uvm_fatal(get_type_name(), "virtual interface must be set for rst_vif!!!")
   endfunction

   task main_phase(uvm_phase phase);
      `uvm_info(get_type_name(), "in main phase...", UVM_HIGH)
      forever
      begin
         seq_item_port.get_next_item(req);
         `uvm_info("genfifo driver", {"req item\n",req.sprint}, UVM_HIGH)
         drive_one_req(req);
         seq_item_port.item_done();
      end
      `uvm_info(get_type_name(), "exit main phase.", UVM_HIGH)
   endtask : main_phase
   
   /** actually drive one data item */
   extern task drive_one_req(fifo_transaction greq);

endclass : fifo_driver

task fifo_driver::drive_one_req(fifo_transaction greq);
   int wcnt;
   int rcnt;

   `uvm_info(get_type_name(), $sformatf("greq, reset: %z, clear: %z", greq.reset, greq.clear), UVM_HIGH)
   `uvm_info(get_type_name(), $sformatf("fifo_vif, empty: %z, full: %z", fifo_vif.empty, fifo_vif.full), UVM_HIGH)
   fork
      // reset
      begin
         if (greq.reset | greq.clear) begin
            `uvm_info(get_type_name(), "reset requested...", UVM_HIGH)
            if (greq.reset) begin
               rst_vif.rst_n = 1'b0;
               #greq.rst_time; rst_vif.rst_n = 1'b1;
            end
            else begin
               rst_vif.rst_n = 1'b1;
            end

            if (greq.clear) begin
               rst_vif.clr = 1'b1;
               #greq.clr_time; rst_vif.clr = 1'b0;
            end
            else begin
               rst_vif.clr = 1'b0;
            end
            -> rst_event;
            // `uvm_info(get_type_name(), $sformatf("rst_vif, rst_n: %z, clr: %z", rst_vif.rst_n, rst_vif.clr), UVM_HIGH)
            // `uvm_info(get_type_name(), $sformatf("fifo_vif, empty: %z, full: %z", fifo_vif.empty, fifo_vif.full), UVM_HIGH)
         end
         else begin
            rst_vif.rst_n = 1'b1;
            rst_vif.clr = 1'b0;
         end
      end

      // read
      begin
         if (!greq.reset && !greq.clear) // skip while reset is requested
         begin
            rcnt = greq.rcount;
            while(rcnt > 0)
            @(posedge fifo_vif.rclk) begin
               if (! fifo_vif.empty) begin
                  fifo_vif.re <= 1'b1;
                  rcnt--;
               end
               else begin
                  fifo_vif.re <= 1'b0;
               end
            end
            // still another tick to finish
            @(posedge fifo_vif.rclk)
               fifo_vif.re <= 1'b0;
         end
      end

      // write
      begin
         if (!greq.reset && !greq.clear) // skip while reset is requested
         begin
            wcnt = greq.wdata.size;
            while(wcnt > 0)
            @(posedge fifo_vif.wclk) begin
               if (! fifo_vif.full) begin
                  fifo_vif.we <= 1'b1;
                  fifo_vif.din <= greq.wdata[greq.wdata.size - wcnt];
                  wcnt--;
               end
               else begin
                  fifo_vif.we <= 1'b0;
               end
            end
            // still another tick to finish
            @(posedge fifo_vif.wclk)
               fifo_vif.we <= 1'b0;
         end
      end
   join
   `uvm_info(get_type_name(), $sformatf("fifo_vif, empty: %z, full: %z", fifo_vif.empty, fifo_vif.full), UVM_HIGH)

   `uvm_info(get_type_name(), "end drive once.", UVM_HIGH)
endtask : drive_one_req

`endif // FIFO_DRIVER__SV