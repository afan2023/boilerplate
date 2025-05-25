`timescale 1ns/100ps

`include "uvm_macros.svh"

import uvm_pkg::*;

`include "reg_defines.vh"
`include "reg_bus_defines.svh"

`include "reg_bus_if.sv"
`include "th.sv"

`include "reg_model.sv"
`include "reg_bus_transaction.sv"
`include "reg_bus_sequencer.sv"
`include "reg_bus_driver.sv"
`include "reg_bus_adaptor.sv"
`include "reg_bus_agent.sv"
`include "reg_bus_env.sv"

`include "top_vsqr.sv"
`include "top_env.sv"

`include "reg_base_vsequence.sv"
`include "base_test.sv"
`include "reg_case0.sv"


module top_tb;

   // my_env_config config;
   th th();

   initial begin   
      uvm_config_db#(virtual reg_bus_if #(.REG_AW(`REG_BUS_AW), .REG_DW(`REG_BUS_DW)))::set(null, "uvm_test_top.env.reg_env.agt.drv", "vif", th.reg_if);
      uvm_config_db#(string)::set(null, "uvm_test_top.env.reg_env", "uut_hdl_path", "top_tb.th.uut");

      run_test();
   end

   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(2, top_tb.th.uut);
   end

endmodule