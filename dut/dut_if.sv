

interface dut_if;
    logic          clk;
    logic          reset;
    logic  [31:0]  dividendIn;
    logic  [31:0]  divisorIn;
    logic          sign;
    logic          start;
    logic  [31:0]  quotientOut;
    logic  [31:0]  remainderOut;
    logic          error;
    logic          done;
	
	// interface assertions can go in here
	//always @(negedge clk) begin
	    //assert property
	//end
	
	// we can put the clocking block in here
	
	// we can put read and write methods in here
	
endinterface

