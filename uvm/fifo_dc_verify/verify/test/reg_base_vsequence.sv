`ifndef REG_BASE_VSEQUENCE__SV
`define REG_BASE_VSEQUENCE__SV

class reg_base_vsequence extends uvm_sequence;
   `uvm_object_utils(reg_base_vsequence)

   reg_model p_regm; // pointer to reg model

   function  new(string name= "case0_cfg_vseq");
      super.new(name);
   endfunction 

   extern function void find_reg_model();
   extern task read_reg_by_addr(input bit[`REG_BUS_AW-1:0] addr, output bit[`REG_BUS_DW-1:0] value, output uvm_status_e status);
   extern task write_reg_by_addr(input bit[`REG_BUS_AW-1:0] addr, input bit[`REG_BUS_DW-1:0] value, output uvm_status_e status);
`ifndef UVM_POST_VERSION_1_1
   extern function uvm_phase get_starting_phase();
   extern function void set_starting_phase(uvm_phase phase);
`endif
endclass : reg_base_vsequence

function void reg_base_vsequence::find_reg_model();
   uvm_reg_block blks[$];

   uvm_reg_block::get_root_blocks(blks);
   if(blks.size() == 0) begin
      `uvm_fatal(get_type_name(), "cannot find root blocks");
   end
   else begin
      if (!$cast(p_regm, blks[0]))
         `uvm_fatal(get_full_name(), "root block cannot cast to reg_model.");
   end
endfunction : find_reg_model

task reg_base_vsequence::read_reg_by_addr(input bit[`REG_BUS_AW-1:0] addr, output bit[`REG_BUS_DW-1:0] value, output uvm_status_e status);
   // uvm_status_e   status;
   // the status can be UVM_IS_OK, UVM_NOT_OK, or UVM_HAS_X, see definition in reg/uvm_reg_model.sv
   uvm_reg_data_t data  ;
   uvm_reg_addr_t addrs[];

   uvm_reg  the_reg;
   the_reg = p_regm.default_map.get_reg_by_offset(addr);
   if (the_reg == null) begin
      `uvm_error(get_type_name(), {"no reg found at this address", $sformatf(" 'h%0h", addr)});
      status = UVM_NOT_OK;
      return;
   end 

   the_reg.read(status, data, UVM_FRONTDOOR);
   if (status == UVM_NOT_OK)
      return;
   void'(the_reg.get_addresses(null, addrs));
   if(addrs.size == 1)
      value = data[`REG_BUS_DW-1:0];
   else begin
      // according to get_addresses function definition, addresses are specified in little endian order
      for (int i = 0; i < addrs.size; i++) begin
         if (addrs[i] == addr) begin // addrs[0] is for LSB
            // this DUT is designed big endian
            data = data >> (`REG_BUS_DW * (addrs.size - i));
            value = data[`REG_BUS_DW-1:0];
            break;
         end
      end
   end

endtask : read_reg_by_addr

task reg_base_vsequence::write_reg_by_addr(input bit[`REG_BUS_AW-1:0] addr, input bit[`REG_BUS_DW-1:0] value, output uvm_status_e status);
   // uvm_status_e   status;
   uvm_reg_data_t data  ;
   uvm_reg_addr_t addrs[];

   uvm_reg  the_reg;
   the_reg = p_regm.default_map.get_reg_by_offset(addr);
   if (the_reg == null) begin
      status = UVM_NOT_OK;
      `uvm_error(get_type_name(), {"no reg found at this address", $sformatf(" 'h%0h", addr)});
      return; 
   end 

   void'(the_reg.get_addresses(null, addrs));
   if(addrs.size == 1)
      the_reg.write(status, value, UVM_FRONTDOOR);
   else begin
      // first read out the old data
      the_reg.read(status, data, UVM_FRONTDOOR);
      if (status == UVM_NOT_OK)
         return;
      // seek for the segment to update
      for (int i = 0; i < addrs.size; i++) begin
         if (addrs[i] == addr) begin
            // big endian, sgdd, for i = 0, data[bus_dw * addrs.size : bus_dw * (addrs.size - 1)]
            // data[(`REG_BUS_DW * (addrs.size - i) - 1):(`REG_BUS_DW * (addrs.size - i - 1))] = value;
            // have to set bit by bit, cause syntax constraint that Range must be bounded by constant expressions.
            for (int j = 0; j < `REG_BUS_DW; j++)
               data[`REG_BUS_DW * (addrs.size - i - 1) + j] = value[j];
            break;
         end
      end
      // write the data
      the_reg.write(status, data, UVM_FRONTDOOR);
   end

endtask : write_reg_by_addr

`ifndef UVM_POST_VERSION_1_1
function uvm_phase reg_base_vsequence::get_starting_phase();
   `uvm_info(get_type_name(), "get starting phase", UVM_MEDIUM);
   return starting_phase;
endfunction: get_starting_phase
function void reg_base_vsequence::set_starting_phase(uvm_phase phase);
   starting_phase = phase;
endfunction: set_starting_phase
`endif


`endif // REG_BASE_VSEQUENCE__SV