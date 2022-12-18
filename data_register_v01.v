/*
	Module Name: data_register_v01
	Module Description: Basic Register in SUBLEQ Processor
	
	Dependencies:	
*/

module data_reg #(
		parameter DATA_WIDTH = 8
	)
	(
		input CLOCK,
		input RESET_bar,						//Active-LOW Reset
		input STORE_DATA,						//Active-HIGH Trigger to store DATA_IN Value
		input SHOW_DATA,						//Active-HIGH Tigger to show register value to DATA_OUT				
		
		input [DATA_WIDTH-1:0] DATA_IN,
		output [DATA_WIDTH-1:0] DATA_OUT
	);
	
	reg [DATA_WIDTH-1:0] DATA_STORE;
	always @(posedge CLOCK, negedge RESET_bar)
		begin
			if(!RESET_bar)
				DATA_STORE <= {DATA_WIDTH{1'b1}};
			else if(STORE_DATA)
				DATA_STORE <=DATA_IN;
		end
	
	assign DATA_OUT = SHOW_DATA ? DATA_STORE : {DATA_WIDTH{1'bz}}; 
		
	
endmodule