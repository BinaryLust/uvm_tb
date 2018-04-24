
// what goes here?
// agent, coverage and scoreboard

// do connect_phase here to connect monitors/drivers to coverage/scoreboards

class div_env extends uvm_env;

    `uvm_component_utils(div_env)
    
    div_agent          agent;
	div_coverage       coverage;
    div_scoreboard     scoreboard;
	
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        agent    = div_agent::type_id::create("agent", this);
		coverage = div_coverage::type_id::create("coverage", this);
		scoreboard = div_scoreboard::type_id::create("scoreboard", this);
    endfunction
	
	function void connect_phase(uvm_phase phase);
        // get agent monitor and connect to coverage
		
		// get to me "", the object called "monitor" and set it to the pointer named monitor
		//if(!uvm_config_db #(div_output_monitor)::get(this, "", "monitor", monitor))
            //`uvm_fatal("ENV", "Failed to get Output Monitor")
		
		agent.input_monitor.analysis_port.connect(coverage.analysis_export);
		
		agent.input_monitor.analysis_port.connect(scoreboard.ap_input);
		agent.output_monitor.analysis_port.connect(scoreboard.ap_output);
		
		//if(m_cfg.active == UVM_ACTIVE) begin
		    // do connections here if agent is active
		//end
    endfunction
   
endclass

