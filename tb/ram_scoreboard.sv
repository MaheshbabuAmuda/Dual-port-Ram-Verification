class ram_scoreboard extends uvm_scoreboard;

  //--------------------------------------------------------------------------
  // TLM FIFOs
  //--------------------------------------------------------------------------
  uvm_tlm_analysis_fifo #(read_xtn)  fifo_rdh;
  uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;

  //--------------------------------------------------------------------------
  // Scoreboard Statistics
  //--------------------------------------------------------------------------
  int wr_xtns_in;
  int rd_xtns_in;
  int xtns_compared;
  int xtns_dropped;

  //--------------------------------------------------------------------------
  // Reference Model
  //--------------------------------------------------------------------------
  // Associative array used as a memory model.
  // Address : 32-bit, Data : 64-bit
  logic [63:0] ref_data [bit [31:0]];

  // Transaction handles
  write_xtn wr_data;
  read_xtn  rd_data;

  // Transactions used for functional coverage
  read_xtn  read_cov_data;
  write_xtn write_cov_data;

  `uvm_component_utils(ram_scoreboard)

  //--------------------------------------------------------------------------
  // Write Functional Coverage
  //--------------------------------------------------------------------------
  covergroup ram_fcov1;

    option.per_instance = 1;

    // Address coverage
    WR_ADD : coverpoint write_cov_data.address {
      bins low  = {[0:100]};
      bins mid1 = {[101:511]};
      bins mid2 = {[512:1023]};
      bins mid3 = {[1024:1535]};
      bins mid4 = {[1536:2047]};
      bins mid5 = {[2048:2559]};
      bins mid6 = {[2560:3071]};
      bins mid7 = {[3072:3583]};
      bins mid8 = {[3584:3995]};
      bins high = {[3996:4095]};
    }

    // Data coverage
    DATA: coverpoint write_cov_data.data {
      bins low  = {[0:64'h0000_0000_0000_ffff]};
      bins mid1 = {[64'h0000_0000_0001_0000:
                   64'h0000_0000_ffff_ffff]};
      bins mid2 = {[64'h0000_0001_0000_0000:
                   64'h0000_ffff_ffff_ffff]};
      bins high = {[64'h0001_0000_0000_0000:
                   64'hffff_ffff_ffff_ffff]};
    }

    // Write operation coverage
    WR: coverpoint write_cov_data.write {
      bins wr_bin = {1};
    }

    // Cross coverage of write operation, address and data
    WRITE_FC : cross WR, WR_ADD, DATA;

  endgroup


  //--------------------------------------------------------------------------
  // Read Functional Coverage
  //--------------------------------------------------------------------------
  covergroup ram_fcov2;

    option.per_instance = 1;

    // Address coverage
    RD_ADD : coverpoint read_cov_data.address {
      bins low  = {[0:100]};
      bins mid1 = {[101:511]};
      bins mid2 = {[512:1023]};
      bins mid3 = {[1024:1535]};
      bins mid4 = {[1536:2047]};
      bins mid5 = {[2048:2559]};
      bins mid6 = {[2560:3071]};
      bins mid7 = {[3072:3583]};
      bins mid8 = {[3584:3995]};
      bins high = {[3996:4095]};
    }

    // Data coverage
    DATA: coverpoint read_cov_data.data {
      bins low  = {[0:64'h0000_0000_0000_ffff]};
      bins mid1 = {[64'h0000_0000_0001_0000:
                   64'h0000_0000_ffff_ffff]};
      bins mid2 = {[64'h0000_0001_0000_0000:
                   64'h0000_ffff_ffff_ffff]};
      bins high = {[64'h0001_0000_0000_0000:
                   64'hffff_ffff_ffff_ffff]};
    }

    // Read operation coverage
    RD: coverpoint read_cov_data.read {
      bins rd_bin = {1};
    }

    // Cross coverage of read operation, address and data
    READ_FC : cross RD, RD_ADD, DATA;

  endgroup


  //--------------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------------
  extern function new(string name, uvm_component parent);
  extern function void mem_write(write_xtn wd);
  extern function bit  mem_read(ref read_xtn rd);
  extern function void check_data(read_xtn rd);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

    endclass: ram_scoreboard


//==============================================================================
// Constructor
//==============================================================================

function ram_scoreboard::new(string name, uvm_component parent);

  super.new(name, parent);

  // Create TLM analysis FIFOs
  fifo_rdh = new("fifo_rdh", this);
  fifo_wrh = new("fifo_wrh", this);

  // Create functional coverage instances
  ram_fcov1 = new();
  ram_fcov2 = new();

endfunction: new


//==============================================================================
// Memory Write
//==============================================================================

function void ram_scoreboard::mem_write(write_xtn wd);

  if (wd.write) begin

    `uvm_info("MEM_WRITE",
              $sformatf("Address = %h", wd.address),
              UVM_LOW)

    // Store write data in the reference model
    ref_data[wd.address] = wd.data;

    `uvm_info(get_type_name(),
              $sformatf("Write Transaction:\n%s", wd.sprint()),
              UVM_HIGH)

    wr_xtns_in++;

  end

endfunction: mem_write


//==============================================================================
// Memory Read
//==============================================================================

function bit ram_scoreboard::mem_read(ref read_xtn rd);

  if (rd.read) begin

    `uvm_info(get_type_name(),
              $sformatf("Read Transaction:\n%s", rd.sprint()),
              UVM_HIGH)

    `uvm_info("MEM_READ",
              $sformatf("Address = %h", rd.address),
              UVM_LOW)

    // Check whether the address exists in the reference model
    if (ref_data.exists(rd.address)) begin

      rd.data = ref_data[rd.address];
      rd_xtns_in++;

      return 1;

    end
    else begin

      xtns_dropped++;
      return 0;

    end

  end

  return 0;

endfunction: mem_read


//==============================================================================
// Run Phase
//==============================================================================

task ram_scoreboard::run_phase(uvm_phase phase);

  fork

    // Process write transactions
    forever begin

      fifo_wrh.get(wr_data);

      mem_write(wr_data);

      `uvm_info("WRITE_SB",
                "Write transaction received",
                UVM_LOW)

      wr_data.print();

      // Sample write functional coverage
      write_cov_data = wr_data;
      ram_fcov1.sample();

    end


    // Process read transactions
    forever begin

      fifo_rdh.get(rd_data);

      `uvm_info("READ_SB",
                "Read transaction received",
                UVM_LOW)

      rd_data.print();

      // Compare DUT read data with reference model
      check_data(rd_data);

    end

  join

endtask: run_phase


//==============================================================================
// Data Check
//==============================================================================

function void ram_scoreboard::check_data(read_xtn rd);

  read_xtn ref_xtn;

  // Create a copy of the received read transaction
  $cast(ref_xtn, rd.clone());

  // Get expected data from the reference model
  if (mem_read(ref_xtn)) begin

    `uvm_info(get_type_name(),
              $sformatf("Expected Transaction:\n%s",
                        ref_xtn.sprint()),
              UVM_HIGH)

    // Compare received data with expected data
    if (rd.compare(ref_xtn)) begin

      `uvm_info(get_type_name(),
                "Scoreboard - Data Match Successful",
                UVM_MEDIUM)

      xtns_compared++;

    end
    else begin

      `uvm_error(
        get_type_name(),
        $sformatf(
          "\nScoreboard Error [Data Mismatch]"
          "\nReceived Transaction:\n%s"
          "\nExpected Transaction:\n%s",
          rd.sprint(),
          ref_xtn.sprint()
        )
      )

    end

  end
  else begin

    `uvm_info(
      get_type_name(),
      $sformatf(
        "No data written at address = %0d\n%s",
        rd.address,
        rd.sprint()
      ),
      UVM_LOW
    )

  end

  // Sample read functional coverage
  read_cov_data = rd;
  ram_fcov2.sample();

endfunction: check_data


//==============================================================================
// Report Phase
//==============================================================================

function void ram_scoreboard::report_phase(uvm_phase phase);

  `uvm_info(
    get_type_name(),
    $sformatf(
      "\nScoreboard Simulation Report"
      "\n----------------------------"
      "\nRead Transactions       : %0d"
      "\nWrite Transactions      : %0d"
      "\nDropped Read Transactions: %0d"
      "\nTransactions Compared   : %0d\n",
      rd_xtns_in,
      wr_xtns_in,
      xtns_dropped,
      xtns_compared
    ),
    UVM_LOW
  )

endfunction: report_phase

