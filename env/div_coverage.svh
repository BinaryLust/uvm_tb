// coverage goes here

class div_coverage extends uvm_subscriber #(div_random_item);
    // register this component with uvm
	`uvm_component_utils(div_coverage)
	
    logic  [31:0]  dividendIn;
    logic  [31:0]  divisorIn;
    logic          sign;
	
	// constructor
	function new (string name, uvm_component parent);
        super.new(name, parent);
        
		// create coverage objects
		test_cover = new();
    endfunction
   
	// called by analysis port
    function void write(div_random_item t);
        dividendIn = t.dividendIn; // these are the actual variables that are sampled by the covergroups
        divisorIn  = t.divisorIn;
        sign       = t.sign;
        
		//`uvm_info("Coverage", $sformatf("Sampled: q->%0d r->%0d error->%d", t.quotientOut, t.remainderOut, t.error), UVM_MEDIUM)
		
		// sample coverage points
		test_cover.sample();
    endfunction
	
	// coverage groups below
	covergroup test_cover;

	    option.per_instance = 1;
        
		dividend: coverpoint dividendIn {
            bins all_zeros = {32'h0};
            bins others1   = {[32'h1:32'hF]};
			bins others2   = {[32'h10:32'hFF]};
			bins others3   = {[32'h100:32'hFFF]};
			bins others4   = {[32'h1000:32'hFFFF]};
			bins others5   = {[32'h10000:32'hFFFFF]};
			bins others6   = {[32'h100000:32'hFFFFFF]};
			bins others7   = {[32'h1000000:32'hFFFFFFF]};
			bins others8   = {[32'h10000000:32'hFFFFFFFE]};
            bins all_ones  = {32'hFFFFFFFF};
        }

		divisor: coverpoint divisorIn {
            bins all_zeros = {32'h0};
            bins others1   = {[32'h1:32'hF]};
			bins others2   = {[32'h10:32'hFF]};
			bins others3   = {[32'h100:32'hFFF]};
			bins others4   = {[32'h1000:32'hFFFF]};
			bins others5   = {[32'h10000:32'hFFFFF]};
			bins others6   = {[32'h100000:32'hFFFFFF]};
			bins others7   = {[32'h1000000:32'hFFFFFFF]};
			bins others8   = {[32'h10000000:32'hFFFFFFFE]};
            bins all_ones  = {32'hFFFFFFFF};
        }
		
		div_type: coverpoint sign {
		    bins unsigned_division = {1'b0};
			bins signed_division   = {1'b1};
		}
		
    endgroup
	
endclass

