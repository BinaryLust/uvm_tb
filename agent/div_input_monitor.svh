

class div_input_monitor extends uvm_monitor; //extends uvm_component;
    `uvm_component_utils(div_input_monitor)

	virtual dut_if vif;
	// bit checks_enable = 1;   // controls checking
	// bit coverage_enable = 1; // controls coverage
	// event cover_transaction; // events need to trigger covergroups?
	
	uvm_analysis_port #(div_random_item) analysis_port;
	div_random_item                      div_input;
	
	/*uvm_component_utils_begin(monitor)
	    `uvm_field_int(checks_enable, UVM_ALL_ON)
		`uvm_field_int(coverage_enable, UVM_ALL_ON)
    uvm_component_utils_end*/
	
	// low level pin/interface coverage here
	/*covergroup cover_trans @cover_transaction;
        option.per_instance = 1;
        // coverage here
    endgroup*/
	
	function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
	
	function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual dut_if)::get(null, "*", "dut_if", vif))
            `uvm_fatal("INPUT_MONITOR", "Failed to get DUT interface");
		//cover_trans = new();
		//cover_trans.set_inst_name({get_full_name(), ".cover_trans"});
		analysis_port  = new("analysis_port", this);
		div_input = new();//div_random_item::type_id::create("div_input");
    endfunction

	task run_phase(uvm_phase phase);
	    `uvm_info("INPUT_MONITOR", "Running", UVM_MEDIUM)
	    forever @(posedge vif.clk) begin
            if(vif.start) begin
			    do_monitor();
				//do_checks();
				//do_coverage();
            end
        end
	endtask

    task do_monitor();
	    #1
        div_input.dividendIn = vif.dividendIn;
        div_input.divisorIn  = vif.divisorIn;
        div_input.sign       = vif.sign;
        analysis_port.write(div_input);
        `uvm_info(get_type_name(), div_input.convert2string(), UVM_HIGH)
	endtask
	
	//function void do_checks();
	
	//endtask
	
	//function void do_coverage();
	//    -> cover_transaction; // do coverage sampling
	//endtask
	
endclass

