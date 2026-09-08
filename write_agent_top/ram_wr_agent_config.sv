class ram_wr_agent_config extends uvm_object;

  // Factory registration
  `uvm_object_utils(ram_wr_agent_config)

  // Virtual interface
  virtual ram_if vif;

  // Agent activity mode
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Transaction counters
  static int mon_rcvd_xtn_cnt = 0;
  static int drv_data_sent_cnt = 0;

  // Constructor
  extern function new(string name = "ram_wr_agent_config");

endclass: ram_wr_agent_config


// Constructor
function ram_wr_agent_config::new(string name = "ram_wr_agent_config");
  super.new(name);
endfunction: new

