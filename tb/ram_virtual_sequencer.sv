class ram_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

  `uvm_component_utils(ram_virtual_sequencer)

  // Agent sequencer handles
  ram_wr_sequencer wr_seqrh[];
  ram_rd_sequencer rd_seqrh[];

  // Environment configuration
  ram_env_config m_cfg;

  // UVM methods
  extern function new(
    string name = "ram_virtual_sequencer",
    uvm_component parent
  );

  extern function void build_phase(uvm_phase phase);

endclass: ram_virtual_sequencer


// Constructor
function ram_virtual_sequencer::new(
  string name = "ram_virtual_sequencer",
  uvm_component parent
);

  super.new(name, parent);

endfunction: new


// Build phase
function void ram_virtual_sequencer::build_phase(uvm_phase phase);

  // Get environment configuration
  if (!uvm_config_db #(ram_env_config)::get(
        this,
        "",
        "ram_env_config",
        m_cfg)) begin

    `uvm_fatal(
      "CONFIG",
      "Cannot get m_cfg from uvm_config_db"
    )

  end

  super.build_phase(phase);

  // Allocate sequencer arrays
  wr_seqrh = new[m_cfg.no_of_duts];
  rd_seqrh = new[m_cfg.no_of_duts];

endfunction: build_phase

