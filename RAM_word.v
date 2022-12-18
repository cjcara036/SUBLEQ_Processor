/*
	Module Name: RAM_word
	Module Description: Addressable Memory module
	Revision History:
		0.01:	Initial module writeup
		
*/

module RAM_word #(
		parameter WORD_LENGTH = 16,
		parameter ADDR_LENGTH = 16,
		parameter RESET_VALUE = 0,
		parameter TRIGGER_ADDRESS = 16'h0000
	)(
		input STORE_DATA,
		input bar_RST,
	
		input [ADDR_LENGTH-1:0] ADDR_IN,
		input [WORD_LENGTH-1:0] DATA_IN,
		output [WORD_LENGTH-1:0] DATA_OUT,
		
		output DATA_OUT_VALID,
		output [WORD_LENGTH-1:0] RAM_CONTENT
	);
	
	reg [WORD_LENGTH-1:0] WORD;
	always @(posedge STORE_DATA, negedge bar_RST)
		begin
			if(!bar_RST)
				WORD <= RESET_VALUE;
			else if(STORE_DATA)
				WORD <= DATA_IN;
		end
	
	assign DATA_OUT = (ADDR_IN==TRIGGER_ADDRESS) ? WORD : {WORD_LENGTH{1'bz}};
	assign DATA_OUT_VALID = (ADDR_IN==TRIGGER_ADDRESS) ? 1'b1 : 1'b0;
	assign RAM_CONTENT = WORD;

endmodule