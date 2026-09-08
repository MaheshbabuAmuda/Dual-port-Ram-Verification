// Read transaction class
class read_xtn extends uvm_sequence_item;

  // Factory registration
  `uvm_object_utils(read_xtn)

  // Transaction fields
  rand bit[`RAM_WIDTH-1 : 0] data;
  rand bit[`ADDR_SIZE-1 : 0] address;
  rand bit read;

  // Transaction control fields
  rand addr_t xtn_type;
  rand bit[63:0] xtn_delay;

  // Address and transaction type constraints
  constraint a {
    address inside {[0:200]};
    xtn_type dist {BAD_XTN := 2, GOOD_XTN := 30};
  }

  // UVM methods
  extern function new(string name = "read_xtn");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void post_randomize();

endclass: read_xtn


// Constructor
function read_xtn::new(string name = "read_xtn");
  super.new(name);
endfunction: new


// Copy transaction data
function void read_xtn::do_copy(uvm_object rhs);

  read_xtn rhs_;

  if (!$cast(rhs_, rhs))
    `uvm_fatal("do_copy", "Cast of rhs object failed")

  super.do_copy(rhs);

  data      = rhs_.data;
  address   = rhs_.address;
  read      = rhs_.read;
  xtn_type  = rhs_.xtn_type;
  xtn_delay = rhs_.xtn_delay;

endfunction: do_copy


// Compare two transactions
function bit read_xtn::do_compare(uvm_object rhs, uvm_comparer comparer);

  read_xtn rhs_;

  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_compare", "Cast of rhs object failed")
    return 0;
  end

  return super.do_compare(rhs, comparer) &&
         data      == rhs_.data &&
         address   == rhs_.address &&
         read      == rhs_.read &&
         xtn_type  == rhs_.xtn_type &&
         xtn_delay == rhs_.xtn_delay;

endfunction: do_compare


// Print transaction information
function void read_xtn::do_print(uvm_printer printer);

  super.do_print(printer);

  printer.print_field("data",      this.data,      64, UVM_DEC);
  printer.print_field("address",   this.address,   12, UVM_DEC);
  printer.print_field("read",      this.read,       1, UVM_DEC);
  printer.print_field("xtn_delay", this.xtn_delay, 64, UVM_DEC);

  printer.print_generic("xtn_type", "addr_t",
                        $bits(xtn_type), xtn_type.name);

endfunction: do_print


// Generate invalid address for bad transactions
function void read_xtn::post_randomize();

  if (xtn_type == BAD_XTN)
    address = 6000;

endfunction: post_randomize
```
