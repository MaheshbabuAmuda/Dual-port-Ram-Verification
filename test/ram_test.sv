class ram_base_test extends uvm_test;

  // Factory registration
  `uvm_component_utils(ram_base_test)

  // Testbench configuration
  ram_tb          ram_envh;
  ram_env_config  m_tb_cfg;

  // Agent configurations
  ram_wr_agent_config m_wr_cfg[];
  ram_rd_agent_config m_rd_cfg[];

  // Test configuration
  int no_of_duts  = 4;
  int has_ragent  = 1;
  int has_wagent  = 1;

  // UVM methods
  extern function new(string name = "ram_base_test",
                      uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void config_ram();

endclass: ram_base_test


// Constructor
function ram_base_test::new(string name = "ram_base_test",
                            uvm_component parent);
  super.new(name, parent);
endfunction: new


// Configure RAM agents
function void ram_base_test::config_ram();

  // Configure write agents
  if (has_wagent) begin

    m_wr_cfg = new[no_of_duts];

    foreach (m_wr_cfg[i]) begin

      m_wr_cfg[i] =
        ram_wr_agent_config::type_id::create(
          $sformatf("m_wr_cfg[%0d]", i));

      if (!uvm_config_db #(virtual ram_if)::get(
            this, "", $sformatf("vif_%0d", i), m_wr_cfg[i].vif))
        `uvm_fatal("VIF CONFIG",
                   "Cannot get interface vif from uvm_config_db")

      m_wr_cfg[i].is_active = UVM_ACTIVE;
      m_tb_cfg.m_wr_agent_cfg[i] = m_wr_cfg[i];

    end
  end

  // Configure read agents
  if (has_ragent) begin

    m_rd_cfg = new[no_of_duts];

    foreach (m_rd_cfg[i]) begin

      m_rd_cfg[i] =
        ram_rd_agent_config::type_id::create(
          $sformatf("m_rd_cfg[%0d]", i));

      if (!uvm_config_db #(virtual ram_if)::get(
            this, "", $sformatf("vif_%0d", i), m_rd_cfg[i].vif))
        `uvm_fatal("UVM_CONFIG",
                   "Cannot get ram_if from uvm_config_db")

      m_rd_cfg[i].is_active = UVM_ACTIVE;
      m_tb_cfg.m_rd_agent_cfg[i] = m_rd_cfg[i];

    end
  end

  // Set environment configuration
  m_tb_cfg.no_of_duts  = no_of_duts;
  m_tb_cfg.has_ragent  = has_ragent;
  m_tb_cfg.has_wagent  = has_wagent;

endfunction: config_ram


// Build testbench
function void ram_base_test::build_phase(uvm_phase phase);

  m_tb_cfg = ram_env_config::type_id::create("m_tb_cfg");

  if (has_wagent)
    m_tb_cfg.m_wr_agent_cfg = new[no_of_duts];

  if (has_ragent)
    m_tb_cfg.m_rd_agent_cfg = new[no_of_duts];

  config_ram();                 
  // Call function config_ram which configures all the parameters

  // Set environment configuration
  uvm_config_db #(ram_env_config)::set(
    this, "*", "ram_env_config", m_tb_cfg);

  super.build_phase(phase);

  // Create testbench
  ram_envh = ram_tb::type_id::create("ram_envh", this);

endfunction: build_phase


// Single-address test
class ram_single_addr_test extends ram_base_test;

  // Factory registration
  `uvm_component_utils(ram_single_addr_test)

  // Virtual sequence
  ram_single_vseq ram_seqh;

  // UVM methods
  extern function new(string name = "ram_single_addr_test",
                      uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: ram_single_addr_test


// Constructor
function ram_single_addr_test::new(
  string name = "ram_single_addr_test",
  uvm_component parent
);
  super.new(name, parent);
endfunction: new


// Build test
function void ram_single_addr_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase


// Run single-address sequence
task ram_single_addr_test::run_phase(uvm_phase phase);

  phase.raise_objection(this);

  ram_seqh = ram_single_vseq::type_id::create("ram_seqh");
  ram_seqh.start(ram_envh.v_sequencer);

  phase.drop_objection(this);

endtask: run_phase


// Ten-address test
class ram_ten_addr_test extends ram_base_test;

  // Factory registration
  `uvm_component_utils(ram_ten_addr_test)

  // Virtual sequence
  ram_ten_vseq ram_seqh;

  // UVM methods
  extern function new(string name = "ram_ten_addr_test",
                      uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: ram_ten_addr_test


// Constructor
function ram_ten_addr_test::new(
  string name = "ram_ten_addr_test",
  uvm_component parent
);
  super.new(name, parent);
endfunction: new


// Build test
function void ram_ten_addr_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase


// Run ten-address sequence
task ram_ten_addr_test::run_phase(uvm_phase phase);

  phase.raise_objection(this);

  ram_seqh = ram_ten_vseq::type_id::create("ram_seqh");
  ram_seqh.start(ram_envh.v_sequencer);

  phase.drop_objection(this);

endtask: run_phase


// Odd-address test
class ram_odd_addr_test extends ram_base_test;

  // Factory registration
  `uvm_component_utils(ram_odd_addr_test)

  // Virtual sequence
  ram_odd_vseq ram_seqh;

  // UVM methods
  extern function new(string name = "ram_odd_addr_test",
                      uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: ram_odd_addr_test


// Constructor
function ram_odd_addr_test::new(
  string name = "ram_odd_addr_test",
  uvm_component parent
);
  super.new(name, parent);
endfunction: new


// Build test
function void ram_odd_addr_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase


// Run odd-address sequence
task ram_odd_addr_test::run_phase(uvm_phase phase);

  phase.raise_objection(this);

  ram_seqh = ram_odd_vseq::type_id::create("ram_seqh");
  ram_seqh.start(ram_envh.v_sequencer);

  phase.drop_objection(this);

endtask: run_phase


// Even-address test
class ram_even_addr_test extends ram_base_test;

  // Factory registration
  `uvm_component_utils(ram_even_addr_test)

  // Virtual sequence
  ram_even_vseq ram_seqh;

  // UVM methods
  extern function new(string name = "ram_even_addr_test",
                      uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: ram_even_addr_test


// Constructor
function ram_even_addr_test::new(
  string name = "ram_even_addr_test",
  uvm_component parent
);
  super.new(name, parent);
endfunction: new


// Build test
function void ram_even_addr_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase


// Run even-address sequence
task ram_even_addr_test::run_phase(uvm_phase phase);

  phase.raise_objection(this);

  ram_seqh = ram_even_vseq::type_id::create("ram_seqh");
  ram_seqh.start(ram_envh.v_sequencer);

  phase.drop_objection(this);

endtask: run_phase

