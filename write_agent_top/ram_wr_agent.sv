class ram_wr_agent extends uvm_agent;

  // Factory registration
  `uvm_component_utils(ram_wr_agent)

  // Agent configuration
  ram_wr_agent_config m_cfg;

  // Agent components
  ram_wr_monitor    monh;
  ram_wr_sequencer seqrh;
  ram_wr_driver     drvh;

  // UVM methods
  extern function new(string name = "ram_wr_agent",
                      uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: ram_wr_agent


// Constructor
function ram_wr_agent::new(string name = "ram_wr_agent",
                           uvm_component parent = null);
  super.new(name, parent);
endfunction: new


// Build agent components
function void ram_wr_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Get configuration
  if (!uvm_config_db #(ram_wr_agent_config)::get(
        this, "", "ram_wr_agent_config", m_cfg))
    `uvm_fatal("CONFIG",
               "Cannot get m_cfg from uvm_config_db")

  // Create monitor
  monh = ram_wr_monitor::type_id::create("monh", this);

  // Create active components
  if (m_cfg.is_active == UVM_ACTIVE) begin
    drvh  = ram_wr_driver::type_id::create("drvh", this);
    seqrh = ram_wr_sequencer::type_id::create("seqrh", this);
  end
endfunction: build_phase


// Connect driver and sequencer
function void ram_wr_agent::connect_phase(uvm_phase phase);
  if (m_cfg.is_active == UVM_ACTIVE)
    drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction: connect_phase
```
