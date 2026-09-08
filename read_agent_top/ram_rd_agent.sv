class ram_rd_agent extends uvm_agent;

  // Factory registration
  `uvm_component_utils(ram_rd_agent)

  // Agent configuration
  ram_rd_agent_config m_cfg;

  // Agent components
  ram_rd_monitor    monh;
  ram_rd_sequencer seqrh;
  ram_rd_driver     drvh;

  // UVM methods
  extern function new(string name = "ram_rd_agent",
                      uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: ram_rd_agent


// Constructor
function ram_rd_agent::new(string name = "ram_rd_agent",
                           uvm_component parent = null);
  super.new(name, parent);
endfunction: new


// Build agent components
function void ram_rd_agent::build_phase(uvm_phase phase);

  super.build_phase(phase);

  // Get configuration
  if (!uvm_config_db #(ram_rd_agent_config)::get(
        this, "", "ram_rd_agent_config", m_cfg))
    `uvm_fatal("CONFIG",
               "Cannot get m_cfg from uvm_config_db")

  // Create monitor
  monh = ram_rd_monitor::type_id::create("monh", this);

  // Create active components
  if (m_cfg.is_active == UVM_ACTIVE) begin
    drvh  = ram_rd_driver::type_id::create("drvh", this);
    seqrh = ram_rd_sequencer::type_id::create("seqrh", this);
  end

endfunction: build_phase


// Connect driver and sequencer
function void ram_rd_agent::connect_phase(uvm_phase phase);

  if (m_cfg.is_active == UVM_ACTIVE)
    drvh.seq_item_port.connect(seqrh.seq_item_export);

endfunction: connect_phase

