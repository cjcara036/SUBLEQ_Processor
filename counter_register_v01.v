/*
	Module Name: counter_register_v01
	Module Description: Counter Register in SUBLEQ Processor
	
	Dependencies:
*/

module counter_reg #(
		parameter DATA_WIDTH = 8,
		parameter LOOP_COUNTER = 1'b0			//1'b1 if counter loops back to zero when maximum value is reached. 1'b0 if counter stops at maximum value
	)
	(
		input CLOCK,
		input RESET_bar,						//Active-LOW Reset
		input DATA_INC,							//Active-HIGH increment DATA_STORE
		input DATA_STORE_VAL,					//Active-HIGH to store DATA_IN to DATA_STORE
		input SHOW_DATA,						//Active-HIGH Tigger to show register value to DATA_OUT
		
		input [DATA_WIDTH-1:0] DATA_IN,
		output [DATA_WIDTH-1:0] DATA_OUT
	);
	
	reg [DATA_WIDTH-1:0] DATA_STORE;
	always @(posedge CLOCK, negedge RESET_bar)
		begin
			if(!RESET_bar)
				DATA_STORE <= {DATA_WIDTH{1'b0}};
			else if(DATA_INC & (LOOP_COUNTER | ~(&DATA_STORE)))
				DATA_STORE <= DATA_STORE + 1;
			else if(DATA_STORE_VAL)
				DATA_STORE <= DATA_IN;
		end
	
	assign DATA_OUT = SHOW_DATA ? DATA_STORE : {DATA_WIDTH{1'bz}};
	
endmodule