`ifndef CASE1_SEQUENCE__SV
`define CASE1_SEQUENCE__SV

// class case1_sequence extends uvm_sequence(#fifo_transaction);
class case1_sequence extends fifo_base_sequence;
   `uvm_object_utils(case1_sequence);
    
   fifo_transaction tr;

   function new(string name = "case1_seq");
      super.new(name);
   endfunction : new

   virtual task body();
      uvm_phase phase;
      `uvm_info(get_type_name(), "in body...", UVM_HIGH)
      phase = get_starting_phase();
      if(phase != null) 
         phase.raise_objection(this);
      else
         `uvm_error(get_type_name, "starting phase is null, can not complete the test sequence.")
      #100;
      `uvm_info("test case1 seq", "reset...", UVM_HIGH)
      tr = new("trans_rst");
      start_item(tr);
      tr.reset = 1'b1;
      assert(tr.randomize() with {rst_time > 120 && rst_time < 360; wdata.size == 0; rcount == 0;})
      finish_item(tr);
      #100;
      `uvm_info("test case1 seq", "data write...", UVM_HIGH)
      `uvm_do_with(tr, {tr.wdata.size == 8; tr.rcount == 0;}) // default pri = -1
      #100;
      `uvm_info("test case1 seq", "data read...", UVM_HIGH)
      `uvm_do_with(tr, {tr.wdata.size == 0; tr.rcount == 8;})
      #100;
      if(phase != null) 
         phase.drop_objection(this);
      `uvm_info(get_type_name(), "exit body.", UVM_HIGH)
   endtask : body
endclass : case1_sequence

`endif // CASE1_SEQUENCE__SV