`ifndef REG_MODEL__SV
`define REG_MODEL__SV

class reg_reset extends uvm_reg;
   `uvm_object_utils(reg_reset)
   uvm_reg_field rf_reset;

   function new(input string name="reg_reset");
      // args: name, n_bits(total number of bits in the register), has_coverage(uvm_coverage_model_e))
      super.new(name, 8, UVM_NO_COVERAGE);
   endfunction : new

   virtual function void build();
      rf_reset = uvm_reg_field::type_id::create("rf_reset");
      // ref reg/uvm_reg_fied.svh    uvm_reg_field::configure
      // args: parent, size, lsb_pos, access(RO, WO, RW, WRC, WRS...), 
      //       volatile, reset(value), has reset?, is rand?, individually accessible?
      rf_reset.configure(this, 1, 0, "WO", 
                        1, 0, 0, 0, 0);
   endfunction : build

endclass : reg_reset

class reg_cfg extends uvm_reg;
   `uvm_object_utils(reg_cfg)
   uvm_reg_field rf_fifo_mode;

   function new(input string name="reg_cfg");
      super.new(name, 8, UVM_NO_COVERAGE);
   endfunction : new

   virtual function void build();
      rf_fifo_mode = uvm_reg_field::type_id::create("rf_fifo_mode");
      // args: parent, size, lsb_pos, access, 
      //       volatile, reset(value), has reset?, is rand?, individually accessible?
      rf_fifo_mode.configure(this, 1, 0, "RW", 
                        1, 0, 1, 0, 0);
   endfunction : build
endclass : reg_cfg

class reg_status extends uvm_reg;
   `uvm_object_utils(reg_status)
   uvm_reg_field rf_status_empty;
   uvm_reg_field rf_status_full;

   function new(input string name="reg_status");
      super.new(name, 8, UVM_NO_COVERAGE);
   endfunction : new

   virtual function void build();
      rf_status_empty = uvm_reg_field::type_id::create("rf_status_empty");
      rf_status_full = uvm_reg_field::type_id::create("rf_status_full");
      // args: parent, size, lsb_pos, access, 
      //       volatile, reset(value), has reset?, is rand?, individually accessible?
      rf_status_empty.configure(this, 1, 0, "RO", 
                        1, 1, 1, 0, 0);
      rf_status_full.configure(this, 1, 1, "RO", 
                        1, 0, 1, 0, 0);
   endfunction : build
endclass : reg_status

class rblk_control extends uvm_reg_block;
   `uvm_object_utils(rblk_control)

   reg_reset   rg_reset;
   reg_cfg     rg_cfg;
   reg_status  rg_status;

   function new(input string name="rblk_control");
      super.new(name, UVM_NO_COVERAGE);
   endfunction : new

   virtual function void build();

      // ref reg/uvm_reg_block.svh  uvm_reg_block::create_map
      // args: name, base_addr, bus width(n_bytes), endian, byte_addressing = TRUE
      default_map = create_map("default_map", `REG_BUS_AW'h0, 1, UVM_BIG_ENDIAN);

      rg_reset = reg_reset::type_id::create("rg_reset", , get_full_name());
      // args: blk_parent, regfile_parent = null, hdl_path = ""
      rg_reset.configure(this, null, "");
      // in case forget to rg_xxx.configure(this), the build phase will fail: uvm_reg_map.svh(721) @ 0: reporter [RegModel] Register 'rg_reset' may not be added to address map 'regmodel.rb_control.default_map' : they are not in the same block
      rg_reset.build();
      // ref reg/uvm_reg_map.svh    uvm_reg_map::add_reg
      // args: rg, offset, rights = "RW", unmapped=0 (unmapped means doesn't occupy any address)
      default_map.add_reg(rg_reset, `DCFIFO_REG_ADDR_RESET, "WO");

      rg_cfg = reg_cfg::type_id::create("rg_cfg", , get_full_name());
      rg_cfg.configure(this, null, "rg_cfg");
      rg_cfg.build();
      default_map.add_reg(rg_cfg, `DCFIFO_REG_ADDR_CFG, "RW");

      rg_status = reg_status::type_id::create("rg_status", , get_full_name());
      rg_status.configure(this);
      rg_status.build();
      default_map.add_reg(rg_status, `DCFIFO_REF_ADDR_STATUS, "RO");
   endfunction : build

endclass : rblk_control

// top reg block
class reg_model extends uvm_reg_block;
   `uvm_object_utils(reg_model)

   rblk_control rb_control;

   function new(input string name="reg_model");
      super.new(name, UVM_NO_COVERAGE);
   endfunction : new

   virtual function void build();
      default_map = create_map("default_map", `REG_BUS_AW'h0, 1, UVM_BIG_ENDIAN);

      rb_control = rblk_control::type_id::create("rb_control");
      rb_control.configure(this, ""); // don't need path because won't use backdoor access
      rb_control.build();
      rb_control.lock_model();
      default_map.add_submap(rb_control.default_map, `DCFIFO_REG_BASEADDR);

   endfunction : build

endclass : reg_model

`endif // REG_MODEL__SV