
//// there can be 1 or more tests
//// a test is composed of 1 or more sequences

// a sequence is 1 or more specific transactions such as read then write, or read modify write
// a transaction is called a sequence item
// a sequence can be composed of other sequences in a layered manor
// a sequence runs on a sequencer
// a sequencer drives sequence items on to the driver which in turn does low level pin wiggles on the dut

// a driver can be uni-directional?, it can not only drive signals it can collect them too
// monitors are usually composed of a collector and a monitor
// a collector captures low level pin wiggles and generates a transaction
// a monitor takes the transaction from the collector and does functionial coverage and checking
// it also sends the transaction out to other components of the uvm software using an analysis port

// virtual sequencers run virtual sequences, a virtual sequence drives the sequence of multiple interfaces

// when we set an agent as passive we turn off the active components of it such as the driver and the sequencer

// we can do checking/scoreboard and transaction coverage in the agent or at the envirnment level

// ports, and TLM fifos should be constructed with new() not the uvm factory

/******************************************************************************************/
/* top   -> test, clock generator, dut and interface instantiation                        */
/* test  -> env and set sequence(s)                                                       */
/* env   -> agent, coverage and scoreboard                                                */
/* agent -> sequencer, driver, monitor, base transaction                                  */
/*                                                                                        */
/*                                                                                        */
/*                                                                                        */
/******************************************************************************************/

`include "uvm_macros.svh"
`include "div_pkg.svh"


module top;
    import uvm_pkg::*;
	import div_pkg::*;
	
	// Instantiate the DUT interface
	dut_if dut_if1();

	// Instantiate the DUT and connect it to the interface
	dut dut1(.dif(dut_if1));
	
	// Clock generator
	initial begin // we could put this code in the dut interface
	    // we can do a dut reset here if we want to
		dut_if1.clk = 1'b0;
		forever #5 dut_if1.clk = ~dut_if1.clk;
	end
	
	// Configure uvm database and run test
	initial begin
	    // Map the Instantiated DUT interface in this module to the uvm object database
		// we use null and "*" here because this is the top level and not a sub component
		// "*" means set to everyone
		uvm_config_db #(virtual dut_if)::set(null, "*", "dut_if", dut_if1);
		// set $finish when when we are done testing
		//uvm_top.finish_on_completion = 1; // might not have to do this in uvm 1.2???
		
		// Start the test
        run_test("base_test"); // this runs a hardcoded test
		
		//run_test(); // if we do an empty run_test() here we can then select which test to run at the command line at run time
		//            // we do this with +UVM_TESTNAME=testname
	end
	
	// Dump waves
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end
	
endmodule

