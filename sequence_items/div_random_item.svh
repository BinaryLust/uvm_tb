
// this is the base transaction item with default constraints
// extend this to set different constraints
// or use randomize with???

class div_random_item extends uvm_sequence_item; // or extends uvm_transaction???
    // register this class with uvm
    `uvm_object_utils(div_random_item)

    rand  logic  [31:0]  dividendIn;
    rand  logic  [31:0]  divisorIn;
    rand  logic          sign;
	
	// the number of cycles to delay before sending the item to the driver
	//rand  int            delay;
	//constraint delay_cycles { delay inside {[1:20]; } // 1 to 20 cycles of delay
	
	// we can have other fields here that arent part of the data that is used by the driver
	// such as a time field ect

	// there are no constraints here everything is truly random

	// constructor
    function new (string name = "div_random_item");
        super.new(name);
    endfunction

	function string convert2string();
	    string str;
		str = super.convert2string();
		$sformat(str, "%s\n dividendIn=%d, divisorIn=%d, sign=%d", str, dividendIn, divisorIn, sign);
	    return str;
	endfunction
	
	// overridden from uvm_sequence_item class
	function void do_copy(uvm_object rhs);
	    div_random_item copy;
		if(!$cast(copy, rhs)) begin // convert generic uvm_object to div_random_item object
		    uvm_report_error("do_copy:", "Cast failed");
			return;
		end
		super.do_copy(rhs);
		dividendIn   = copy.dividendIn;
		divisorIn    = copy.divisorIn;
		sign         = copy.sign;
	endfunction
	
	// overridden from uvm_sequence_item class
	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	    div_random_item copy;
		bit same = 1;
		if(!$cast(copy, rhs)) begin // convert generic uvm_object to div_random_item object
		    return 0;
		end
		same &= super.do_compare(rhs, comparer);
		same &= (dividendIn == copy.dividendIn);
		same &= (divisorIn  == copy.divisorIn);
		same &= (sign       == copy.sign);
		return same;
	endfunction
	
endclass

