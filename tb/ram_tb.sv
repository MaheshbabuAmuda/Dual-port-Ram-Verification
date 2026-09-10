class ram_tb extends uvm_env;

  `uvm_component_utils(ram_tb)

  // Agents
  ram_wr_agt_top wagt_top[];
  ram_rd_agt_top ragt_top[];

  // Virtual sequencer and scoreboard
  ram_virtual_sequencer v_sequencer;
  ram_scoreboard sb[];

  // Environment configuration
  ram_env_config m_cfg;

  // UVM methods
  extern function new(string name = "ram_tb", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: ram_tb


// Constructor
function ram_tb::new(string name = "ram_tb", uvm_component parent);

  super.new(name, parent);

endfunction: new


// Build phase
function void ram_tb::build_phase(uvm_phase phase);

  // Get environment configuration
  if (!uvm_config_db #(ram_env_config)::get(
        this, "", "ram_env_config", m_cfg)) begin

    `uvm_fatal("CONFIG",
      "Cannot get m_cfg from uvm_config_db. Have you set() it?")

  end


  // Create write agents
  if (m_cfg.has_wagent) begin

    wagt_top = new[m_cfg.no_of_duts];

    foreach (wagt_top[i]) begin

      uvm_config_db #(ram_wr_agent_config)::set(
        this,
        $sformatf("wagt_top[%0d]*", i),
        "ram_wr_agent_config",
        m_cfg.m_wr_agent_cfg[i]
      );

      wagt_top[i] = ram_wr_agt_top::type_id::create(
        $sformatf("wagt_top[%0d]", i),
        this
      );

    end

  end


  // Create read agents
  if (m_cfg.has_ragent) begin

    ragt_top = new[m_cfg.no_of_duts];

    foreach (ragt_top[i]) begin

      uvm_config_db #(ram_rd_agent_config)::set(
        this,
        $sformatf("ragt_top[%0d]*", i),
        "ram_rd_agent_config",
        m_cfg.m_rd_agent_cfg[i]
      );

      ragt_top[i] = ram_rd_agt_top::type_id::create(
        $sformatf("ragt_top[%0d]", i),
        this
      );

    end

  end


  super.build_phase(phase);


  // Create virtual sequencer
  if (m_cfg.has_virtual_sequencer) begin

    v_sequencer = ram_virtual_sequencer::type_id::create(
      "v_sequencer",
      this
    );

  end


  // Create scoreboards
  if (m_cfg.has_scoreboard) begin

    sb = new[m_cfg.no_of_duts];

    foreach (sb[i]) begin

      sb[i] = ram_scoreboard::type_id::create(
        $sformatf("sb[%0d]", i),
        this
      );

    end

  end

endfunction: build_phase


// Connect phase
function void ram_tb::connect_phase(uvm_phase phase);

  // Connect virtual sequencer
  if (m_cfg.has_virtual_sequencer) begin

    if (m_cfg.has_wagent) begin

      foreach (wagt_top[i]) begin

        v_sequencer.wr_seqrh[i] =
          wagt_top[i].agnth.seqrh;

      end

    end


    if (m_cfg.has_ragent) begin

      foreach (ragt_top[i]) begin

        v_sequencer.rd_seqrh[i] =
          ragt_top[i].agnth.seqrh;

      end

    end

  end


  // Connect monitors to scoreboard FIFOs
  if (m_cfg.has_scoreboard) begin

    if (m_cfg.has_wagent) begin

      foreach (wagt_top[i]) begin

        wagt_top[i].agnth.monh.monitor_port.connect(
          sb[i].fifo_wrh.analysis_export
        );

      end

    end


    if (m_cfg.has_ragent) begin

      foreach (ragt_top[i]) begin

        ragt_top[i].agnth.monh.monitor_port.connect(
          sb[i].fifo_rdh.analysis_export
        );

      end

    end

  end

endfunction: connect_phase

