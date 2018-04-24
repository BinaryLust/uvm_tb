
class div_constrained_random_item extends div_random_item;
    // register this class with uvm
    `uvm_object_utils(div_constrained_random_item)

	constraint dividendIn_constraint { dividendIn >= 0; dividendIn < 256; }
    constraint divisorIn_constraint  { divisorIn  >= 0; divisorIn  < 256; }
	
	// constructor
    //function new (string name = "");
        //super.new(name);
    //endfunction
	
endclass

