/*
	Module Name: buffer_block_v01
	Module Description: Simple Buffer implementation in SUBLEQ Processor
	
	Dependencies:	
	
*/

module buffer_block #(
		parameter DATA_WIDTH = 8
	)(
		input SHOW_DATA,
		input [DATA_WIDTH-1:0] DATA_IN,
		output [DATA_WIDTH-1:0] DATA_OUT
	);
	
	assign DATA_OUT = SHOW_DATA ? DATA_IN : {DATA_WIDTH{1'bz}};

endmodule