`ifndef GENFIFO_TRANSACTION__SV
`define GENFIFO_TRANSACTION__SV

class genfifo_transaction #(parameter int DW = 8) extends uvm_sequence_item;

   `uvm_object_utils(genfifo_transaction);

   bit         reset    ;
   bit         clear    ;
   rand int    rst_time ;
   rand int    clr_time ;

   rand int    rcount   ;  // number of data items to read in
   
   rand bit [DW-1:0] wdata[]  ;  // data to write
   // int               wcount   ;  // number of data items write, convenient parameter, if keep it, has the wcount_constr as well
   // constraint wcount_constr{
   //    wcount == wdata.size;
   // }

   function new(string name = "genfifo_transaction");
      super.new();
      reset = 1'b0;
      clear = 1'b0;
      rcount= 0;
      // wcount= 0; 
   endfunction

   extern virtual function void do_print(uvm_printer printer);
   extern virtual function string convert2string();

endclass : genfifo_transaction

function void genfifo_transaction::do_print(uvm_printer printer);
   if (printer.knobs.sprint == 0)
      `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
   else
      printer.m_string = convert2string();
endfunction : do_print

function string genfifo_transaction::convert2string();
   string ss, s, swd;
   $sformat(s, "%s\n", super.convert2string());
   $sformat(s, {"%s\n",
      "reset: %u; clear: %u; rst_time: %0d; clr_time: %0d;\n",
      "rcount: %0d; wdata (%0d):\n"},
      get_full_name(), reset, clear, rst_time, clr_time, 
      rcount, wdata.size);
   for( int i = 0; i < wdata.size; i++ )
      $sformat(swd, {"%s", " 'h%0h "}, swd, wdata[i]);
   return {ss, s, swd};
endfunction : convert2string

`endif // GENFIFO_TRANSACTION__SV-
