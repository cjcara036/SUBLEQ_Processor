/*
	Module Name: subtractor_block_v01
	Module Description: Perform Subtraction Operation
	
	Dependencies:	
*/

module subtractor_AB #(
		parameter DATA_WIDTH = 8
	)(
		input SHOW_DATA,					//Active-HIGH Tigger to show operation difference
		input [DATA_WIDTH-1:0] DATA_A,
		input [DATA_WIDTH-1:0] DATA_B,
		output LEQ_FLAG,					//1'b1 if DATA_B > DATA_A
		output [DATA_WIDTH-1:0] DATA_OUT
	);
	
	wire [DATA_WIDTH-1:0] DIFFERENCE;
	assign DIFFERENCE = DATA_A - DATA_B;
	
	assign DATA_OUT = SHOW_DATA ? DIFFERENCE : {DATA_WIDTH{1'bz}};
	assign LEQ_FLAG = (DATA_A <= DATA_B) ? 1'b1: 1'b0;
	
endmodule