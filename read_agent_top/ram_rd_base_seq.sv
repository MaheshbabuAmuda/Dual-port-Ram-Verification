// Base read sequence
class ram_rbase_seq extends uvm_sequence #(read_xtn);

  // Factory registration
  `uvm_object_utils(ram_rbase_seq)

  // Constructor
  extern function new(string name = "ram_rbase_seq");

endclass: ram_rbase_seq


// Constructor
function ram_rbase_seq::new(string name = "ram_rbase_seq");
  super.new(name);
endfunction: new


// Single-address read sequence
class ram_single_addr_rd_xtns extends ram_rbase_seq;

  // Factory registration
  `uvm_object_utils(ram_single_addr_rd_xtns)

  // Methods
  extern function new(string name = "ram_single_addr_rd_xtns");
  extern task body();

endclass: ram_single_addr_rd_xtns


// Constructor
function ram_single_addr_rd_xtns::new(string name = "ram_single_addr_rd_xtns");
  super.new(name);
endfunction: new


// Generate 10 reads from address 55
task ram_single_addr_rd_xtns::body();

  repeat(10) begin
    req = read_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == 55;
    });

    `uvm_info("RAM_RD_SEQUENCE",
              $sformatf("Printing from sequence\n%s", req.sprint()),
              UVM_HIGH)

    finish_item(req);
  end

endtask: body


// Sequential read sequence
class ram_ten_rd_xtns extends ram_rbase_seq;

  // Factory registration
  `uvm_object_utils(ram_ten_rd_xtns)

  // Methods
  extern function new(string name = "ram_ten_rd_xtns");
  extern task body();

endclass: ram_ten_rd_xtns


// Constructor
function ram_ten_rd_xtns::new(string name = "ram_ten_rd_xtns");
  super.new(name);
endfunction: new


// Read addresses 0 through 9
task ram_ten_rd_xtns::body();

  int addrseq = 0;

  repeat(10) begin
    req = read_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == addrseq;
      read == 1'b1;
    });

    `uvm_info("RAM_RD_SEQUENCE",
              $sformatf("Printing from sequence\n%s", req.sprint()),
              UVM_HIGH)

    finish_item(req);

    addrseq++;
  end

endtask: body


// Odd-address read sequence
class ram_odd_rd_xtns extends ram_rbase_seq;

  // Factory registration
  `uvm_object_utils(ram_odd_rd_xtns)

  // Methods
  extern function new(string name = "ram_odd_rd_xtns");
  extern task body();

endclass: ram_odd_rd_xtns


// Constructor
function ram_odd_rd_xtns::new(string name = "ram_odd_rd_xtns");
  super.new(name);
endfunction: new


// Read 10 odd memory addresses
task ram_odd_rd_xtns::body();

  int addrseq = 0;

  repeat(10) begin
    req = read_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == (2 * addrseq + 1);
      read == 1'b1;
    });

    `uvm_info("RAM_RD_SEQUENCE",
              $sformatf("Printing from sequence\n%s", req.sprint()),
              UVM_HIGH)

    finish_item(req);

    addrseq++;
  end

endtask: body


// Even-address read sequence
class ram_even_rd_xtns extends ram_rbase_seq;

  // Factory registration
  `uvm_object_utils(ram_even_rd_xtns)

  // Methods
  extern function new(string name = "ram_even_rd_xtns");
  extern task body();

endclass: ram_even_rd_xtns


// Constructor
function ram_even_rd_xtns::new(string name = "ram_even_rd_xtns");
  super.new(name);
endfunction: new


// Read 10 even memory addresses
task ram_even_rd_xtns::body();

  int addrseq = 0;

  repeat(10) begin
    req = read_xtn::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      address == (2 * addrseq);
      read == 1'b1;
    });

    `uvm_info("RAM_RD_SEQUENCE",
              $sformatf("Printing from sequence\n%s", req.sprint()),
              UVM_HIGH)

    finish_item(req);

    addrseq++;
  end

endtask: body

