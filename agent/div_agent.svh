

// what goes here?
// sequencer
// input driver
// input monitor
// output monitor

class div_agent extends uvm_agent;
    `uvm_component_utils(div_agent)
    
    div_driver         driver;
	div_input_monitor  input_monitor;
	div_output_monitor output_monitor;
    div_sequencer      sequencer;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
        // create a driver from div_driver class
		driver    = div_driver::type_id::create("driver", this);
		// create an input monitor
		input_monitor   = div_input_monitor::type_id::create("input_monitor", this);
		// create an output monitor
		output_monitor   = div_output_monitor::type_id::create("output_monitor", this);
        // we are using the base uvm sequencer here
		sequencer = div_sequencer::type_id::create("sequencer", this);
		
		//if(m_cfg.active == UVM_ACTIVE) begin
		    // build sequencer and driver here agent is active
		//end
    endfunction    
    
    // In UVM connect phase, we connect the sequencer to the driver.
    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
		
		//if(m_cfg.active == UVM_ACTIVE) begin
		    // do connections here if agent is active
		//end
		
		// optionial reponse port connections
		//driver.rsp_port.connect(sequencer.rsp_export)
		
		// set the drivers virtual interface to the config object virtual interface
		//driver.vif = cfg.vif;
    endfunction

endclass

