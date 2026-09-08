class ram_rd_agt_top extends uvm_env;

  // Factory registration
  `uvm_component_utils(ram_rd_agt_top)

  // Read agent handle
  ram_rd_agent agnth;

  // UVM methods
  extern function new(string name = "ram_rd_agt_top",
                      uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: ram_rd_agt_top


// Constructor
function ram_rd_agt_top::new(string name = "ram_rd_agt_top",
                             uvm_component parent);
  super.new(name, parent);
endfunction: new


// Create read agent
function void ram_rd_agt_top::build_phase(uvm_phase phase);

  super.build_phase(phase);

  agnth = ram_rd_agent::type_id::create("agnth", this);

endfunction: build_phase


// Print UVM topology
task ram_rd_agt_top::run_phase(uvm_phase phase);

  uvm_top.print_topology();

endtask: run_phase

