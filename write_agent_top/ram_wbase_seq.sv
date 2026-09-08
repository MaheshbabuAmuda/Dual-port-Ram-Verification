// Base write sequence
class ram_wbase_seq extends uvm_sequence #(write_xtn);

  // Factory registration
  `uvm_object_utils(ram_wbase_seq)

  // Constructor
  extern function new(string name = "ram_wbase_seq");

endclass: ram_wbase_seq


// Constructor
function ram_wbase_seq::new(string name = "ram_wbase_seq");
  super.new(name);
endfunction: new


// Single-address write sequence
class ram_single_addr_wr_xtns extends ram_wbase_seq;

  // Factory registration
  `uvm_object_utils(ram_single_addr_wr_xtns)

  // Methods
  extern function new(string name = "ram_single_addr_wr_xtns");
  extern task body();

endclass: ram_single_addr_wr_xtns


// Constructor
function ram_single_addr_wr_xtns::new(
  string name = "ram_single_addr_wr_xtns"
);
  super.new(name);
endfunction: new


// Generate 10 writes to address 55
task ram_single_addr_wr_xtns::body();

  repeat(10) begin
    req = write_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == 55;
    });

    `uvm_info("RAM_WR_SEQUENCE",
              $sformatf("Printing from sequence\n%s",
                        req.sprint()),
              UVM_HIGH)

    finish_item(req);
  end

endtask: body


// Sequential write sequence
class ram_ten_wr_xtns extends ram_wbase_seq;

  // Factory registration
  `uvm_object_utils(ram_ten_wr_xtns)

  // Methods
  extern function new(string name = "ram_ten_wr_xtns");
  extern task body();

endclass: ram_ten_wr_xtns


// Constructor
function ram_ten_wr_xtns::new(string name = "ram_ten_wr_xtns");
  super.new(name);
endfunction: new


// Write to addresses 0 through 9
task ram_ten_wr_xtns::body();

  int addrseq = 0;

  repeat(10) begin
    req = write_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == addrseq;
      write == 1'b1;
    });

    `uvm_info("RAM_WR_SEQUENCE",
              $sformatf("Printing from sequence\n%s",
                        req.sprint()),
              UVM_HIGH)

    finish_item(req);

    addrseq++;
  end

endtask: body


// Odd-address write sequence
class ram_odd_wr_xtns extends ram_wbase_seq;

  // Factory registration
  `uvm_object_utils(ram_odd_wr_xtns)

  // Methods
  extern function new(string name = "ram_odd_wr_xtns");
  extern task body();

endclass: ram_odd_wr_xtns


// Constructor
function ram_odd_wr_xtns::new(string name = "ram_odd_wr_xtns");
  super.new(name);
endfunction: new


// Write to 10 odd addresses
task ram_odd_wr_xtns::body();

  int addrseq = 0;

  repeat(10) begin
    req = write_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == (2 * addrseq + 1);
      write == 1'b1;
    });

    `uvm_info("RAM_WR_SEQUENCE",
              $sformatf("Printing from sequence\n%s",
                        req.sprint()),
              UVM_HIGH)

    finish_item(req);

    addrseq++;
  end

endtask: body


// Even-address write sequence
class ram_even_wr_xtns extends ram_wbase_seq;

  // Factory registration
  `uvm_object_utils(ram_even_wr_xtns)

  // Methods
  extern function new(string name = "ram_even_wr_xtns");
  extern task body();

endclass: ram_even_wr_xtns


// Constructor
function ram_even_wr_xtns::new(string name = "ram_even_wr_xtns");
  super.new(name);
endfunction: new


// Write to 10 even addresses
task ram_even_wr_xtns::body();

  int addrseq = 0;

  repeat(10) begin
    req = write_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == (2 * addrseq);
      write == 1'b1;
    });

    `uvm_info("RAM_WR_SEQUENCE",
              $sformatf("Printing from sequence\n%s",
                        req.sprint()),
              UVM_HIGH)

    finish_item(req);

    addrseq++;
  end

endtask: body

