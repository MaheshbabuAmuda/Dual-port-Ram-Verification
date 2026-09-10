class ram_vbase_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(ram_vbase_seq)

  // Agent sequencer handles
  ram_wr_sequencer wr_seqrh[];
  ram_rd_sequencer rd_seqrh[];

  // Virtual sequencer
  ram_virtual_sequencer vsqrh;

  // Sequence handles
  ram_single_addr_wr_xtns single_wxtns;
  ram_single_addr_rd_xtns single_rxtns;

  ram_ten_wr_xtns ten_wxtns;
  ram_ten_rd_xtns ten_rxtns;

  ram_even_wr_xtns even_wxtns;
  ram_even_rd_xtns even_rxtns;

  ram_odd_wr_xtns odd_wxtns;
  ram_odd_rd_xtns odd_rxtns;

  // Environment configuration
  ram_env_config m_cfg;

  // UVM methods
  extern function new(string name = "ram_vbase_seq");
  extern task body();

    endclass: ram_vbase_seq


// Constructor
function ram_vbase_seq::new(string name = "ram_vbase_seq");

  super.new(name);

endfunction: new


// Base sequence body
task ram_vbase_seq::body();

  // Get environment configuration
  if (!uvm_config_db #(ram_env_config)::get(
        null,
        get_full_name(),
        "ram_env_config",
        m_cfg)) begin

    `uvm_fatal(
      "UVM_CONFIG",
      "Cannot get ram_env_config from uvm_config_db"
    )

  end

  // Allocate sequencer arrays
  wr_seqrh = new[m_cfg.no_of_duts];
  rd_seqrh = new[m_cfg.no_of_duts];

  // Get virtual sequencer handle
  assert ($cast(vsqrh, m_sequencer))
  else begin

    `uvm_error(
      "BODY",
      "Error in $cast of virtual sequencer"
    )

  end

  // Get individual sequencer handles
  foreach (wr_seqrh[i])
    wr_seqrh[i] = vsqrh.wr_seqrh[i];

  foreach (rd_seqrh[i])
    rd_seqrh[i] = vsqrh.rd_seqrh[i];

endtask: body


//==============================================================================
// Single Address Virtual Sequence
//==============================================================================

class ram_single_vseq extends ram_vbase_seq;

  `uvm_object_utils(ram_single_vseq)

  extern function new(string name = "ram_single_vseq");
  extern task body();

    endclass: ram_single_vseq


function ram_single_vseq::new(string name = "ram_single_vseq");

  super.new(name);

endfunction: new


task ram_single_vseq::body();

  super.body();

  // Create read and write sequences
  single_wxtns =
    ram_single_addr_wr_xtns::type_id::create("single_wxtns");

  single_rxtns =
    ram_single_addr_rd_xtns::type_id::create("single_rxtns");


  // Start write sequence on all write sequencers
  if (m_cfg.has_wagent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      single_wxtns.start(wr_seqrh[i]);

  end


  // Start read sequence on all read sequencers
  if (m_cfg.has_ragent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      single_rxtns.start(rd_seqrh[i]);

  end

endtask: body


//==============================================================================
// Ten Address Virtual Sequence
//==============================================================================

class ram_ten_vseq extends ram_vbase_seq;

  `uvm_object_utils(ram_ten_vseq)

  extern function new(string name = "ram_ten_vseq");
  extern task body();

    endclass: ram_ten_vseq


function ram_ten_vseq::new(string name = "ram_ten_vseq");

  super.new(name);

endfunction: new


task ram_ten_vseq::body();

  super.body();

  // Create read and write sequences
  ten_wxtns =
    ram_ten_wr_xtns::type_id::create("ten_wxtns");

  ten_rxtns =
    ram_ten_rd_xtns::type_id::create("ten_rxtns");


  // Start write sequence on all write sequencers
  if (m_cfg.has_wagent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      ten_wxtns.start(wr_seqrh[i]);

  end


  // Start read sequence on all read sequencers
  if (m_cfg.has_ragent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      ten_rxtns.start(rd_seqrh[i]);

  end

endtask: body


//==============================================================================
// Even Address Virtual Sequence
//==============================================================================

class ram_even_vseq extends ram_vbase_seq;

  `uvm_object_utils(ram_even_vseq)

  extern function new(string name = "ram_even_vseq");
  extern task body();

endclass: ram_even_vseq


function ram_even_vseq::new(string name = "ram_even_vseq");

  super.new(name);

endfunction: new


task ram_even_vseq::body();

  super.body();

  // Create read and write sequences
  even_wxtns =
    ram_even_wr_xtns::type_id::create("even_wxtns");

  even_rxtns =
    ram_even_rd_xtns::type_id::create("even_rxtns");


  // Start write sequence on all write sequencers
  if (m_cfg.has_wagent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      even_wxtns.start(wr_seqrh[i]);

  end


  // Start read sequence on all read sequencers
  if (m_cfg.has_ragent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      even_rxtns.start(rd_seqrh[i]);

  end

endtask: body


//==============================================================================
// Odd Address Virtual Sequence
//==============================================================================

class ram_odd_vseq extends ram_vbase_seq;

  `uvm_object_utils(ram_odd_vseq)

  extern function new(string name = "ram_odd_vseq");
  extern task body();

endclass: ram_odd_vseq


function ram_odd_vseq::new(string name = "ram_odd_vseq");

  super.new(name);

endfunction: new


task ram_odd_vseq::body();

  super.body();

  // Create read and write sequences
  odd_wxtns =
    ram_odd_wr_xtns::type_id::create("odd_wxtns");

  odd_rxtns =
    ram_odd_rd_xtns::type_id::create("odd_rxtns");


  // Start write sequence on all write sequencers
  if (m_cfg.has_wagent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      odd_wxtns.start(wr_seqrh[i]);

  end


  // Start read sequence on all read sequencers
  if (m_cfg.has_ragent) begin

    for (int i = 0; i < m_cfg.no_of_duts; i++)
      odd_rxtns.start(rd_seqrh[i]);

  end

endtask: body

