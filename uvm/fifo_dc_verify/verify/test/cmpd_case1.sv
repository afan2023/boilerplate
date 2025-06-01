`ifndef CMPD_CASE1__SV
`define CMPD_CASE1__SV


class case1_rst_vseq extends reg_base_vsequence;
   `uvm_object_utils(case1_rst_vseq)

   function new(string name = "case1_rst_vseq");
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
      #100;
      find_reg_model();
      p_regm.rb_control.rg_reset.write(status, 1, UVM_FRONTDOOR);
      `uvm_info(get_full_name(), "clear fifo by writting reg reset", UVM_MEDIUM);
      #100;
      p_regm.rb_control.rg_status.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("after reset, reg status value: 'h%0h", value), UVM_MEDIUM);
      #100;
      if(phase != null) 
         phase.drop_objection(this);
      `uvm_info(get_type_name(), "exit body.", UVM_HIGH)
   endtask : body
endclass : case1_rst_vseq

class case1_cfg_vseq extends reg_base_vsequence;
   `uvm_object_utils(case1_cfg_vseq)

   function new(string name = "case1_cfg_vseq");
      super.new(name);
   endfunction : new

   virtual task body();
      uvm_status_e   status;
      uvm_reg_data_t value;
      // uvm_phase phase;
      `uvm_info(get_type_name(), "in body...", UVM_HIGH)
      // phase = get_starting_phase();
      // if(phase != null) 
      //    phase.raise_objection(this);
      // else
      //    `uvm_error(get_type_name(), "starting phase is null, can not complete the test sequence.")
      #100;
      find_reg_model();
      p_regm.rb_control.rg_cfg.read(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("reg cfg value: 'h%0h", value), UVM_MEDIUM);
      #100;
      value = value ^ 1;
      p_regm.rb_control.rg_cfg.write(status, value, UVM_FRONTDOOR);
      `uvm_info(get_type_name(), $sformatf("reg cfg set with: 'h%0h", value), UVM_MEDIUM);
      #100;
      p_regm.rb_control.rg_cfg.peek(status, value);
      `uvm_info(get_type_name(), $sformatf("peek reg cfg value: 'h%0h", value), UVM_MEDIUM);
      #100;
      // if(phase != null) 
      //    phase.drop_objection(this);
      `uvm_info(get_type_name(), "exit body.", UVM_HIGH)
   endtask : body
endclass : case1_cfg_vseq


class case1_write_seq extends fifo_base_sequence;
   `uvm_object_utils(case1_write_seq);
   fifo_transaction tr;

   function new(string name = "case1_write_seq");
      super.new(name);
   endfunction : new

   virtual task body();
      repeat(8) begin
         `uvm_create(tr);
         assert(tr.randomize() with {wdata.size == 1; rcount == 0;});
         `uvm_send(tr);
      end
   endtask : body
endclass : case1_write_seq

class case1_read_seq extends fifo_base_sequence;
   `uvm_object_utils(case1_read_seq);
   fifo_transaction tr;

   function new(string name = "case1_read_seq");
      super.new(name);
   endfunction : new

   virtual task body();
      repeat(8) begin
         `uvm_create(tr);
         assert(tr.randomize() with {wdata.size == 0; rcount == 1;});
         `uvm_send(tr);
      end
   endtask : body
endclass : case1_read_seq

class case1_vseq extends reg_base_vsequence;
   `uvm_object_utils(case1_vseq);
   `uvm_declare_p_sequencer(top_vsqr)

   function new(string name = "case1_vseq");
      super.new(name);
   endfunction : new

   virtual task body();
      case1_write_seq w_seq;
      case1_read_seq r_seq;
      case1_cfg_vseq cfg_vseq;
      uvm_status_e   status;
      uvm_phase phase;
      `uvm_info(get_type_name(), "in body...", UVM_HIGH)

      phase = get_starting_phase();
      if(phase != null) 
         phase.raise_objection(this);
      else
         `uvm_error(get_type_name(), "starting phase is null, can not complete the test sequence.")

      #200;
      `uvm_info(get_type_name(), "write fifo...", UVM_MEDIUM)
      w_seq = case1_write_seq::type_id::create("w_seq");
      w_seq.start(p_sequencer.p_fifo_sqr);

      `uvm_info(get_type_name(), "read fifo...", UVM_MEDIUM)
      r_seq = case1_read_seq::type_id::create("r_seq");
      r_seq.start(p_sequencer.p_fifo_sqr);

      #100;
      `uvm_info(get_type_name(), "have a soft reset...", UVM_MEDIUM)
      find_reg_model();
      p_regm.rb_control.rg_reset.write(status, 1, UVM_FRONTDOOR);

      #100;
      `uvm_info(get_type_name(), "reconfigure fifo...", UVM_MEDIUM)
      cfg_vseq = case1_cfg_vseq::type_id::create("cfg_vseq");
      cfg_vseq.start(p_sequencer.p_reg_sqr);

      #100;
      `uvm_info(get_type_name(), "write & read fifo...", UVM_MEDIUM)
      w_seq = case1_write_seq::type_id::create("w_seq");
      r_seq = case1_read_seq::type_id::create("r_seq");
      fork
         w_seq.start(p_sequencer.p_fifo_sqr);
         r_seq.start(p_sequencer.p_fifo_sqr);
      join

      #100;
      if(phase != null) 
         phase.drop_objection(this);
      `uvm_info(get_type_name(), "exit body.", UVM_HIGH)
   endtask : body
endclass : case1_vseq

class cmpd_case1 extends base_test;
   `uvm_component_utils(cmpd_case1)

   function new(string name = "reg_case1", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase); 

endclass : cmpd_case1

function void cmpd_case1::build_phase(uvm_phase phase);
   super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.reg_env.agt.sqr.reset_phase", 
                                           "default_sequence", 
                                           case1_rst_vseq::type_id::get());

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.vsqr.main_phase", 
                                           "default_sequence", 
                                           case1_vseq::type_id::get());

endfunction : build_phase

`endif // CMPD_CASE1__SV