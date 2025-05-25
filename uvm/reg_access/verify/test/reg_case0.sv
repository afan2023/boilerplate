`ifndef REG_CASE0__SV
`define REG_CASE0__SV

/**
 * just to see that the reg env works
 */
 
class reg_case0_vsequence extends reg_base_vsequence;
   `uvm_object_utils(reg_case0_vsequence)

   function new(string name = "reg_case0_seq");
      super.new(name);
   endfunction : new

   virtual task body();
      uvm_status_e   status;
      uvm_reg_data_t value;
      uvm_phase phase;
      `uvm_info(get_type_name(), "in body...", UVM_HIGH)
      phase = get_starting_phase();
      if(phase != null) 
         phase.raise_objection(this);
      else
         `uvm_error(get_type_name(), "starting phase is null, can not complete the test sequence.")
      // uvm_config_db#(reg_model)::get(null, "uvm_test_top.env.reg_env", "regmodel", p_regm); // this works
      find_reg_model(); // this works as well
      #100;
      p_regm.rb_dummy.rg_cfg.poke(status, 1);
      if (status == UVM_NOT_OK) begin
         `uvm_error(get_type_name(), "error in poking reg cfg");
      end
      else begin
         `uvm_info(get_type_name(), $sformatf("poke reg cfg value: 'h1"), UVM_MEDIUM);
      end
      p_regm.rb_dummy.rg_cfg.read(status, value, UVM_FRONTDOOR);
      if (status == UVM_NOT_OK) begin
         `uvm_error(get_type_name(), "error in reading reg cfg");
      end
      else begin
         `uvm_info(get_type_name(), $sformatf("reg cfg value: 'h%0h", value), UVM_MEDIUM);
      end
      p_regm.rb_dummy.rg_reset.write(status, 1, UVM_FRONTDOOR);
      if (status == UVM_NOT_OK) begin
         `uvm_error(get_type_name(), "error in writng reg reset");
      end
      else begin
         `uvm_info(get_type_name(), "soft reset by writting reg reset", UVM_MEDIUM);
      end
      #100;
      p_regm.rb_dummy.rg_cfg.read(status, value, UVM_FRONTDOOR);
      if (status == UVM_IS_OK) begin
         `uvm_info(get_type_name(), $sformatf("reg cfg value: 'h%0h", value), UVM_MEDIUM);
      end
      else begin
         `uvm_error(get_type_name(), "error in reading reg cfg");
      end
      value = value ^ 1;
      p_regm.rb_dummy.rg_cfg.write(status, value, UVM_FRONTDOOR);
      if (status == UVM_IS_OK) begin
         `uvm_info(get_type_name(), $sformatf("reg cfg set with: 'h%0h", value), UVM_MEDIUM);
      end
      else begin
         `uvm_error(get_type_name(), "error in writing reg cfg");
      end
      p_regm.rb_dummy.rg_cfg.peek(status, value);
      if (status == UVM_IS_OK) begin
         `uvm_info(get_type_name(), $sformatf("peek reg cfg value: 'h%0h", value), UVM_MEDIUM);
      end
      else begin
         `uvm_error(get_type_name(), "error in peeking reg cfg");
      end
      #5000;
      p_regm.rb_dummy.rg_status.read(status, value, UVM_FRONTDOOR);
      if (status == UVM_IS_OK) begin
         `uvm_info(get_type_name(), $sformatf("reg status value: 'h%0h", value), UVM_MEDIUM);
      end
      else begin
         `uvm_error(get_type_name(), "error in reading reg status");
      end
      #5000;
      p_regm.rb_dummy.rg_status.read(status, value, UVM_FRONTDOOR);
      if (status == UVM_IS_OK) begin
         `uvm_info(get_type_name(), $sformatf("reg status value: 'h%0h", value), UVM_MEDIUM);
      end
      else begin
         `uvm_error(get_type_name(), "error in reading reg status");
      end
      #100;
      p_regm.rb_dummy.rg_reset.write(status, 1, UVM_FRONTDOOR);
      if (status == UVM_IS_OK) begin
         `uvm_info(get_type_name(), "soft reset by writting reg reset", UVM_MEDIUM);
      end
      else begin
         `uvm_error(get_type_name(), "error in writing reg reset");
      end
      #100;
      p_regm.rb_dummy.rg_status.read(status, value, UVM_FRONTDOOR);
      if (status == UVM_IS_OK) begin
         `uvm_info(get_type_name(), $sformatf("reg status value: 'h%0h", value), UVM_MEDIUM);
      end
      else begin
         `uvm_error(get_type_name(), "error in reading reg status");
      end
      #100;
      if(phase != null) 
         phase.drop_objection(this);
      `uvm_info(get_type_name(), "exit body.", UVM_HIGH)
   endtask : body

endclass : reg_case0_vsequence

class reg_case0 extends base_test;
   `uvm_component_utils(reg_case0)

   function new(string name = "reg_case0", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase); 

endclass : reg_case0

function void reg_case0::build_phase(uvm_phase phase);
   super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.reg_env.agt.sqr.main_phase", 
                                           "default_sequence", 
                                           reg_case0_vsequence::type_id::get());
   `uvm_info(get_full_name(), "set default sequence to run by env.reg_env.agt.sqr main_phase", UVM_HIGH);

endfunction : build_phase

`endif // REG_CASE0__SV