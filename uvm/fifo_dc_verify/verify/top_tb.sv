`timescale 1ns/100ps

`include "uvm_macros.svh"

import uvm_pkg::*;
`include "fifo_dc_if.sv"
`include "fifo_rst_if.sv"

`include "th.sv"

`include "fifo_transaction.sv"
`include "fifo_action_item.sv"
`include "fifo_data_item.sv"
`include "fifo_sequencer.sv"
`include "fifo_monitor.sv"
`include "fifo_driver.sv"
`include "fifo_agent.sv"
`include "fifo_omonitor.sv"
`include "fifo_oagent.sv"

`include "fifo_scoreboard.sv"
`include "fifo_model.sv"
`include "fifo_env.sv"

`include "base_test.sv"
`include "fifo_base_sequence.sv"
`include "case1_sequence.sv"
`include "case1.sv"
`include "case2_sequence.sv"
`include "case2.sv"

module top_tb;

   // my_env_config config;
   th th();

   initial begin   
      // config.fifo_if = th.fifo_if;
      // config.rst_if = th.rst_if;
      // uvm_config_db #(my_env_config)::set(null, "uvm_test_top.env", "config", config);
      // simply connect the interfaces, no other configurations needed
      uvm_config_db#(virtual fifo_dc_if)::set(null, "uvm_test_top.env.i_agt.drv", "fifo_vif", th.fifo_if);
      uvm_config_db#(virtual fifo_rst_if)::set(null, "uvm_test_top.env.i_agt.drv", "rst_vif", th.rst_if);
      uvm_config_db#(virtual fifo_dc_if)::set(null, "uvm_test_top.env.i_agt.mon", "fifo_vif", th.fifo_if);
      uvm_config_db#(virtual fifo_rst_if)::set(null, "uvm_test_top.env.i_agt.mon", "rst_vif", th.rst_if);
      uvm_config_db#(virtual fifo_dc_if)::set(null, "uvm_test_top.env.o_agt.mon", "fifo_vif", th.fifo_if);
      uvm_config_db#(virtual fifo_rst_if)::set(null, "uvm_test_top.env.o_agt.mon", "rst_vif", th.rst_if);

      run_test();
   end

   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(3, top_tb.th);
   end

endmodule