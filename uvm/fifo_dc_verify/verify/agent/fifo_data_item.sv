`ifndef FIFO_DATA_ITEM__SV
`define FIFO_DATA_ITEM__SV

class fifo_data_item #(parameter int DW = 8) extends uvm_sequence_item;

   `uvm_object_utils(fifo_data_item)
   bit            wr    ;  // 1: write data; 0: read
   logic [DW-1:0] data  ;

   function new(string name = "fifo_data_item");
      super.new();
   endfunction

   extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
   extern function void do_print(uvm_printer printer);
   extern function string convert2string();

endclass : fifo_data_item

function bit fifo_data_item::do_compare(uvm_object rhs, uvm_comparer comparer);
   bit isSame;
   fifo_data_item the_other;
   if (!$cast(the_other, rhs))
     `uvm_fatal(get_type_name(), "Cast of rhs object failed")
   isSame = super.do_compare(rhs, comparer);
   isSame &= comparer.compare_field("wr", wr, the_other.wr, $bits(wr));
   isSame &= comparer.compare_field("data", data, the_other.data, $bits(data));
   return isSame;
endfunction : do_compare

function void fifo_data_item::do_print(uvm_printer printer);
   if (printer.knobs.sprint == 0)
      `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
   else
      printer.m_string = convert2string();
endfunction : do_print

function string fifo_data_item::convert2string();
   string s;
   $sformat(s, "%s\n", super.convert2string());
   $sformat(s, {"%s\n",
      "wr = %u; data = 'h%0h\n"},
      get_full_name(), wr, data);
   return s;
endfunction : convert2string

`endif // FIFO_DATA_ITEM__SV