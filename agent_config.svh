

class agent_config extends uvm_object;
    `uvm_object_utils(agent_config);
	
	// config params here
	//virtual dut_if vif; // the virtual interface that you want the agent to use
    
	//int id;        // agent id
	//int address;   // address for things that need an address like a mac address for ethernet
	//int verbosity; // the desired verbosity level for this components of this agent
	
	// constructor
	function new(string name = "");
	    super.new(name);
	endfunction
	
endclass

