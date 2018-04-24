

class div_driver extends uvm_driver #(div_random_item);
    `uvm_component_utils(div_driver)

    virtual dut_if vif;
 
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
   
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual dut_if)::get(null, "*", "dut_if", vif))
            `uvm_fatal("DRIVER", "Failed to get DUT interface")
    endfunction

    task run_phase(uvm_phase phase);
        div_random_item dut_input;

		// First toggle reset
		do_reset();
	    
        forever begin
		    // blocking get
			seq_item_port.get_next_item(dut_input); // or req?
			
            // wait a random number of clock cycles
            repeat ($urandom_range(0, 3)) @(posedge vif.clk); 
         
		    do_drive(dut_input);
			
            seq_item_port.item_done();
			
			// if we need to send a response back on the same port
			// seq_item_port.put_response(res);
			
			// send a response back on another port
			// rsp_port.write(rsp);
        end
    endtask
   
    task do_drive(input div_random_item trans);
		@(posedge vif.clk);
		#1
		// Wiggle pins of DUT
        vif.dividendIn = trans.dividendIn; // we could put this code in the dut interface
        vif.divisorIn  = trans.divisorIn;
        vif.sign       = trans.sign;
        vif.start      = 1'b1;
        @(posedge vif.clk);
		#1
        vif.start      = 1'b0;
	    wait(vif.done);
	endtask
	
	task do_reset();
		// First toggle reset
		@(posedge vif.clk);
		#1
        vif.reset      = 1'b1;
		vif.dividendIn = 32'b0;
        vif.divisorIn  = 32'b0;
		vif.sign       = 1'b0;
		vif.start      = 1'b0;
        repeat(10) @(posedge vif.clk);
        #1;
        vif.reset = 1'b0;
	endtask
	
endclass

