`ifndef MY_SCOREBOARD__SV
`define MY_SCOREBOARD__SV
class my_scoreboard extends uvm_scoreboard;
   fifo_data_item  expect_queue[$];
   uvm_blocking_get_port #(fifo_data_item)  exp_data_port;
   uvm_blocking_get_port #(fifo_data_item)  act_data_port;
   `uvm_component_utils(my_scoreboard)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
endclass 

function my_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 

function void my_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_data_port = new("exp_data_port", this);
   act_data_port = new("act_data_port", this);
endfunction 

task my_scoreboard::main_phase(uvm_phase phase);
   fifo_data_item  get_expect,  get_actual, tmp_tran;
   bit result;
   
   `uvm_info(get_type_name(), "in main phase...", UVM_HIGH)

   super.main_phase(phase);
   fork 
      forever begin
         exp_data_port.get(get_expect);
         `uvm_info(get_type_name(), $sformatf("expect 'h%0h", get_expect.data), UVM_LOW);
         expect_queue.push_back(get_expect);
      end
      forever begin
         act_data_port.get(get_actual); 
         `uvm_info(get_type_name(), $sformatf("actual read 'h%0h", get_actual.data), UVM_LOW);
         if(expect_queue.size() > 0) begin
            tmp_tran = expect_queue.pop_front();
            result = get_actual.compare(tmp_tran);
            if(result) begin 
               `uvm_info("my_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
            end
            else begin
               `uvm_error("my_scoreboard", "Compare FAILED");
               $display("the expect data is");
               tmp_tran.print();
               $display("the actual data is");
               get_actual.print();
            end
         end
         else begin
            `uvm_error("my_scoreboard", "Received from DUT, while Expect Queue is empty");
            $display("the unexpected data is");
            get_actual.print();
         end 
      end
   join

   `uvm_info(get_type_name(), "exit main phase.", UVM_HIGH)
endtask
`endif
