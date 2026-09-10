class ram_env_config extends uvm_object;

  // Enable/disable environment components
  bit has_functional_coverage       = 0;
  bit has_wagent_functional_coverage = 0;
  bit has_scoreboard                = 1;

  // Enable/disable write and read agents
  bit has_wagent = 1;
  bit has_ragent = 1;

  // Enable/disable virtual sequencer
  bit has_virtual_sequencer = 1;

  // Configuration handles for write and read agents
  ram_wr_agent_config m_wr_agent_cfg[];
  ram_rd_agent_config m_rd_agent_cfg[];

  // Number of DUT instances
  int no_of_duts = 4;

  `uvm_object_utils(ram_env_config)

  // Constructor
  extern function new(string name = "ram_env_config");

endclass: ram_env_config


function ram_env_config::new(string name = "ram_env_config");
  super.new(name);
endfunction: new

