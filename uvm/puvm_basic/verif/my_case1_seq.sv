`ifndef MY_CASE1_SEQ__SV
`define MY_CASE1_SEQ__SV

/**
 * keep functional aligned with that in puvm
 * just to 
 *    1. make it more clear
 *    2. make it works uvm 1.2 (while keeping workable in uvm 1.1)
 */

class case1_sequence extends uvm_sequence #(my_transaction);
   // comment out m_trans because "req" is already in base class uvm_sequence
   // my_transaction m_trans;

   function  new(string name= "case1_sequence");
      super.new(name);
   endfunction 

   /**
    * TO CHANGE according to need
    *    the part between raise/drop objection should do something substantial
    */
   virtual task body();
      uvm_phase phase = get_starting_phase();
      if(phase != null) 
         phase.raise_objection(this);
      repeat (10) begin
         // I'd prefer not to use `uvm_do... macro because it blurs a little
         // `uvm_do_with(m_trans, { m_trans.pload.size() == 60;})
         req = my_transaction::type_id::create("req");
         start_item(req); 
         if ( !req.randomize() with {req.pload.size() == 60;} )
            `uvm_error(get_type_name(), "Failed to randomize transaction")
         finish_item(req); 
      end
      #100;
      if(phase != null) 
         phase.drop_objection(this);
   endtask

   `uvm_object_utils(case1_sequence)

/**
 * in order to accomodate both UVM 1.1 & 1.2
 */
`ifndef UVM_POST_VERSION_1_1
   function uvm_phase get_starting_phase();
      return starting_phase;
   endfunction: get_starting_phase
`endif

endclass

`endif
