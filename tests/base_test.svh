
// build envirnment here
// override sequences and configuration here then run the test

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    div_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
	    //super.build_phase(phase);
		
		
		// tell the uvm factory if it sees a random_sequence being created to instead
        // build the override type sequence instead
		//random_sequence::type_id::set_type_override(random_sequence::get_type());
		
		// build a config class objects here, for env's and agent's, ect
		// set config class params here
		
		env = div_env::type_id::create("env", this);
    endfunction

	// we can start a sequence on an agent from here in the run phase
	task run_phase(uvm_phase phase);
        // We raise objection to keep the test from completing
        phase.raise_objection(this);
        
		// we can start this sequence in the test, env, or the agent
		begin
            //`uvm_info("Sequencer", "Running", UVM_MEDIUM)
			random_sequence seq;
            seq = random_sequence::type_id::create("seq"); // this creates a random_sequence object named "seq"
            seq.start(env.agent.sequencer);                // this runs random_sequence on the sequencer
        end
		
        // We drop objection to allow the test to complete
        phase.drop_objection(this);
    endtask
	
endclass

