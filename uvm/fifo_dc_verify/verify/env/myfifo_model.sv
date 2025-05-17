`ifndef MYFIFO_MODEL__SV
`define MYFIFO_MODEL__SV

// class myfifo_model extends uvm_component;
class myfifo_model #(parameter int DW = 8) extends uvm_component;

   `uvm_component_utils(myfifo_model)

   uvm_get_port #(fifo_data_item)  port_data;
   uvm_analysis_port #(fifo_data_item)  ap_data;
   uvm_get_port #(fifo_action_item) port_act;
   // uvm_get_port #(fifo_action_item) port_oact;
   // uvm_analysis_port #(fifo_data_item)  ap_act;

   // fifo_data_item data_q[$];
   logic [DW-1:0] data_q[$];
   semaphore lock = new(1);

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);

endclass 

function myfifo_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void myfifo_model::build_phase(uvm_phase phase);
   super.build_phase(phase);

   port_data = new("port_data", this);
   ap_data = new("ap_data", this);
   port_act = new("port_act", this);
   // port_oact = new("port_oact", this);
endfunction : build_phase

task myfifo_model::main_phase(uvm_phase phase);
   // super.main_phase(phase);
   fifo_data_item get_data;
   fifo_data_item new_data;
   fifo_action_item  get_act;
   // fifo_action_item  get_oact;

   `uvm_info(get_type_name(), "in main phase...", UVM_HIGH)
   
   fork
      // for simplicity now skip verify the reset functionality, but a reset shall clear data in this reference model...
      // maybe, in case reset/clear functionality itself need be verified w/ uvm,
      // it could be something like:
      //    the i_agt collects a reset/clear, the o_agt monitors the "empty" status after a reset/clear,
      //    besides to clear data in the reference model, the messages should also be checked match, a
      //    mismatch may alert an error...
      forever begin
         port_act.get(get_act);
         if (get_act.hasreset) begin
            if (get_act.empty) begin
               lock.get();
               data_q.delete();
               lock.put();
               `uvm_info(get_type_name(), "FIFO reset to empty!", UVM_MEDIUM);
            end
         end
      end

      forever begin
         port_data.get(get_data);
         `uvm_info(get_type_name(), {"get event \n",get_data.sprint}, UVM_HIGH)
         begin
            if (get_data.wr) begin // write
               lock.get();
               data_q.push_back(get_data.data);
               lock.put();
            end
            if (! get_data.wr) begin // read
               new_data = new("new_data");
               new_data.wr = 1'b0;
               lock.get();
               new_data.data = data_q.pop_front();
               lock.put();
               ap_data.write(new_data);
               `uvm_info(get_type_name(), {"send \n",new_data.sprint}, UVM_HIGH)
            end
         end
      end
   join

   `uvm_info(get_type_name(), "exit main phase.", UVM_HIGH)
endtask : main_phase

`endif // MYFIFO_MODEL__SV
