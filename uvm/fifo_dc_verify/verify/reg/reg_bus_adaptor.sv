`ifndef REG_BUS_ADAPTOR__SV
`define REG_BUS_ADAPTOR__SV

class reg_bus_adaptor extends uvm_reg_adapter;
    `uvm_object_utils(reg_bus_adaptor)

   function new(string name="reg_bus_adaptor");
      super.new(name);
   endfunction : new

   function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
      reg_bus_transaction bus_trans;
      bus_trans = new("bus_trans");
      bus_trans.reg_addr = rw.addr;
      bus_trans.reg_wr = (rw.kind == UVM_READ) ? 1'b0: 1'b1;
      if (bus_trans.reg_wr)
         bus_trans.reg_data = rw.data; 
      return bus_trans;
   endfunction : reg2bus

   function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      reg_bus_transaction bus_trans;
      if(!$cast(bus_trans, bus_item)) begin
         `uvm_fatal(get_type_name(),
          "Provided bus_item is not of the correct type. Expecting reg_bus_transaction.")
          return;
      end
      rw.kind = (bus_trans.reg_wr) ? UVM_WRITE : UVM_READ;
      rw.addr = bus_trans.reg_addr;
      rw.data = bus_trans.reg_data;
      rw.status = UVM_IS_OK;
   endfunction : bus2reg

endclass : reg_bus_adaptor

`endif // REG_BUS_ADAPTOR__SV