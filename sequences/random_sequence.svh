

class random_sequence extends uvm_sequence #(div_random_item);

    // register this class with uvm
    `uvm_object_utils(random_sequence)
	
    div_random_item div_input;

	// we could have a field that defines the number of iterations to do
	
	// constructor
    function new (string name = "random_sequence");
        super.new(name);
    endfunction

	// this is the main method that generates transactions
    task body;
	    //if(starting_phase != null) // might not need to do this in uvm 1.2???
		//    starting_phase.raise_objection(this);
		
		//sequence_name::start(); // do this to start other sequences inside this one
		//we can run multiple sequences in parallel by using a fork join block
		
		// create a new transaction object
		div_input = div_random_item::type_id::create("div_input"); // create a div_random_item object named div_input, it can be overriden by this name later
		
        repeat(100) begin
			start_item(div_input);

			// we can skip the randomize method here if we want to manually set the values instead
            if (!div_input.randomize()) begin
                `uvm_error("random_sequence", "Randomize failed.");
            end
            // we can also do randomize() with {} to change constraints here
			
            // If using ModelSim, which does not support randomize(),
            // we must randomize item using traditional methods, like
            //div_input.opA = $urandom_range(0, 255);
            //div_input.opB = $urandom_range(0, 255);
            
			//`uvm_info("Sequence", div_input.convert2string(), UVM_MEDIUM)
			
            finish_item(div_input);
			
			// we can get a response from the driver here if needed
			// get_response(resp);
        end
		
	    //if(starting_phase != null) // might not need to do this in uvm 1.2???
		//    starting_phase.drop_objection(this);
    endtask
	
endclass

