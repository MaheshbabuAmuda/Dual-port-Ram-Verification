// Read sequencer
class ram_rd_sequencer extends uvm_sequencer #(read_xtn);

  // Factory registration
  `uvm_component_utils(ram_rd_sequencer)

  // Constructor
  extern function new(string name = "ram_rd_sequencer",
                      uvm_component parent);

endclass: ram_rd_sequencer


// Constructor
function ram_rd_sequencer::new(string name = "ram_rd_sequencer",
                               uvm_component parent);
  super.new(name, parent);
endfunction: new

