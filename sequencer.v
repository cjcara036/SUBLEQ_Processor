/*
	Module Name: sequencer
	Module Description: CLC sequencer circuit
	
	Dependencies:	
	
*/

module sequencer #(
		parameter STATE_BITS = 0,
		parameter IN_BITS = 0,
		parameter OUT_BITS = 0
	)(
		input CLOCK,
		input RESET_bar,					//Active-LOW Reset
		input [IN_BITS-1:0] in_lines,
		output [OUT_BITS-1:0] out_lines
	);
	
	reg [STATE_BITS+OUT_BITS-1:0] LUT [84-1:0];
	reg [OUT_BITS-1:0] OUTPUT_BUFFER;
	reg [STATE_BITS-1:0] STATE_BUFFER;
	always @(posedge CLOCK, negedge RESET_bar)
		begin
			if(!RESET_bar)
				begin
					$readmemb("CU_microcode.mem",LUT);
					OUTPUT_BUFFER <= {OUT_BITS{1'b0}};
					STATE_BUFFER <= {STATE_BITS{1'b0}};
				end
			else
				{STATE_BUFFER,OUTPUT_BUFFER} <= LUT[{STATE_BUFFER,in_lines}];
		end
		
	assign out_lines = OUTPUT_BUFFER;	
endmodule

