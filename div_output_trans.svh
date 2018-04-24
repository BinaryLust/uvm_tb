

class div_output_trans extends uvm_transaction; // or extends uvm_transaction???
    // register this class with uvm
    `uvm_object_utils(div_output_trans)

    logic        [31:0]  quotientOut;
    logic        [31:0]  remainderOut;
    logic                error;

	// constructor
    function new (string name = "");
        super.new(name);
    endfunction

	function string convert2string();
		string str;
		str = super.convert2string();
		$sformat(str, "%s\n quotientOut=%d, remainderOut=%d, error=%d", str, quotientOut, remainderOut, error);
	    return str;
	endfunction
	
	// overridden from uvm_transaction class
	function void do_copy(uvm_object rhs);
	    div_output_trans copy;
		if(!$cast(copy, rhs)) begin // convert generic uvm_object to div_output_trans object
		    uvm_report_error("do_copy:", "Cast failed");
			return;
		end
		super.do_copy(rhs);
		quotientOut  = copy.quotientOut;
		remainderOut = copy.remainderOut;
		error        = copy.error;
	endfunction
	
	// overridden from uvm_transaction class
	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	    div_output_trans copy;
		bit same = 1;
		if(!$cast(copy, rhs)) begin // convert generic uvm_object to div_output_trans object
		    return 0;
		end
		same &= super.do_compare(rhs, comparer);
		same &= (quotientOut  == copy.quotientOut);
		same &= (remainderOut == copy.remainderOut);
		same &= (error        == copy.error);
		return same;
	endfunction
	
endclass

