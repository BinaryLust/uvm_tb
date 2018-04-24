

// a mostly empty class, we use the base class methods mostly.
// we can have a 2 way port here if needed like this uvm_sequencer #(in_type, out_type);
class div_sequencer extends uvm_sequencer #(div_random_item);
    `uvm_component_utils(div_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
	
endclass

