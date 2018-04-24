
// we can put a reference module here
// a transaction checker goes here

`uvm_analysis_imp_decl(_input)
`uvm_analysis_imp_decl(_output)

class div_scoreboard extends uvm_scoreboard;
    // register this component with uvm
	`uvm_component_utils(div_scoreboard)
	
	uvm_analysis_export   #(div_random_item)  ap_input;
	uvm_analysis_export   #(div_output_trans) ap_output;
	
	uvm_tlm_analysis_fifo #(div_random_item)  in_fifo;
	uvm_tlm_analysis_fifo #(div_output_trans) out_fifo;

	int total_count;
	int pass_count;
	int fail_count;
	
	function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
		ap_input  = new("ap_input", this);
		ap_output = new("ap_output", this);
		in_fifo  = new("in_fifo", this);
		out_fifo  = new("out_fifo", this);
    endfunction : build_phase
   
    function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
	    ap_input.connect(in_fifo.analysis_export);
		ap_output.connect(out_fifo.analysis_export);
	endfunction
	
    task run_phase(uvm_phase phase);
	    div_random_item  div_input;
		div_output_trans div_output;
		div_output_trans expected;
		
		forever begin
		    // get actual transactions
			in_fifo.get(div_input);
			out_fifo.get(div_output);
			
			// get expected tranactions
			expected = reference_model(div_input);
			
			// compare transactions
			if(div_output.compare(expected)) begin
			    `uvm_info("SELF CHECKER", $sformatf("Actual: %s, Expected: %s, Result: %s", div_output.convert2string, expected.convert2string, "PASS"), UVM_HIGH)
				hadPass();
			end
			else begin
			    `uvm_error("SELF CHECKER", $sformatf("Actual: %s, Expected: %s, Result: %s", div_output.convert2string, expected.convert2string, "FAIL"))
				hadFail();
		    end
		end
	endtask
	
	function void report_phase(uvm_phase phase);
	    super.report_phase(phase);
	    
		if(fail_count == 0)
    		`uvm_info("PASSED", $sformatf("Total vectors: %d, Passed vectors: %d, Failed vectors %d", total_count, pass_count, fail_count), UVM_LOW)
		else
		    `uvm_error("FAILED", $sformatf("Total vectors: %d, Passed vectors: %d, Failed vectors %d", total_count, pass_count, fail_count))
		
	endfunction
	
    function void hadPass();
	    total_count++;
		pass_count++;
	endfunction
	
	function void hadFail();
	    total_count++;
		fail_count++;
	endfunction
	
	function div_output_trans reference_model(div_random_item div_input);
	    logic [31:0] dividendIn;
		logic [31:0] divisorIn;
		logic        sign;
		
		div_output_trans predicted;
	
	    predicted = new("predicted");
		
		// extract
		dividendIn = div_input.dividendIn;
		divisorIn  = div_input.divisorIn;
		sign       = div_input.sign;
		
		case(sign)
		    1'b0: begin
			          predicted.quotientOut  = (divisorIn == 32'b0) ? divisorIn  : unsigned'(unsigned'(dividendIn) / unsigned'(divisorIn));
					  predicted.remainderOut = (divisorIn == 32'b0) ? dividendIn : unsigned'(unsigned'(dividendIn) % unsigned'(divisorIn));
					  predicted.error        = (divisorIn == 32'b0) ? 1'b1 : 1'b0;
			      end
			1'b1: begin
			          predicted.quotientOut  = (divisorIn == 32'b0) ? divisorIn  : signed'(signed'(dividendIn) / signed'(divisorIn));
					  predicted.remainderOut = (divisorIn == 32'b0) ? dividendIn : signed'(signed'(dividendIn) % signed'(divisorIn));
					  predicted.error        = (divisorIn == 32'b0) ? 1'b1 : 1'b0;
			      end
	    endcase
		
		return predicted;
	endfunction
	
endclass

