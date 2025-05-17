`ifndef TEST_PKG__SV
`define TEST_PKG__SV

package top_test_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import genfifo_pkg::*;
  import env_pkg::*;

  `include "base_test.sv"
  `include "genfifo_base_sequence.sv"
  `include "case1_sequence.sv"
  `include "case1.sv"

endpackage : top_test_pkg

`endif // TEST_PKG__SV
