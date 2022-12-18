/*
	Module Name: SUBLEQ_v01
	Module Description: Basic Processor using a SUBLEQ instruction set
	
	Dependencies:
	> data_reg (data_register_v01)
	> counter_reg (counter_register_v01)
	> subtractor_AB (subtractor_block_v01)

	Notes:
	> This processor can only interact via memory, so memory-mapped IOs may be required if HW interaction is needed
*/

module SUBLEQ_proc #(
		parameter DATA_ADDR_WIDTH = 16
	)(
		input CLOCK,
		input RESET_bar,
		input DATA_IN_VALID,						//Flag provided by memory to show DATA_IN is valid. Warning: Can't be in hiZ
		output DATA_OUT_VALID,						//Flag to show memory that ADDR_OUT and DATA_OUT is valid
		
		output [DATA_ADDR_WIDTH-1:0] ADDR_OUT,		// Provides Address of memory location to be accessed
		input [DATA_ADDR_WIDTH-1:0] DATA_IN,		// Data from memory
		output [DATA_ADDR_WIDTH-1:0] DATA_OUT		// Contains Data to write in a memory location
	);
	
	wire [DATA_ADDR_WIDTH-1:0] BUS;					//Main Processor Bus
	//assign BUS = RESET_bar ? {DATA_ADDR_WIDTH{1'bz}} : {DATA_ADDR_WIDTH{1'b0}};
	
	//Signal Wires
	wire datain_valid;								//1'b1 if DATA_IN is valid
	//wire datain_valid2;
	wire alu_LEQ;									//1'b1 if difference between content of DATA_REG_A and DATA_REG_B is less than or equal to zero
	
	//Control Wires
	wire bufIN_toBus;								//1'b1 to connect DATA_IN to BUS
	wire datout_valid;								//1'b1 to signal externally that DATA_BUF_OUT content is valid
	wire bufOUT_storeBus;							//1'b1 to store BUS content to output buffer DATA_BUF_OUT
	wire MAR_storeBus;								//1'b1 to store BUS content to MAR
	wire regA_storeBus;								//1'b1 if Bus content is stored to DATA_REG_A
	wire regB_storeBus;								//1'b1 if Bus content is stored to DATA_REG_B
	wire alu_toBus;									//1'b1 if ALU content will be dump to BUS
	wire pc_inc;									//1'b1 to increment value to PC
	wire pc_storeBUS;								//1'b1 to store BUS value to PC
	wire pc_toBus;									//1'b1 to dump PC value to BUS
	
	reg buf_rst;
	always @(posedge CLOCK)
		begin
			buf_rst <= ~ RESET_bar;
		end
	//assign datain_valid2 = datain_valid|buf_rst;
	
	//Processor Control Unit
	sequencer #(
		.STATE_BITS(5),
		.IN_BITS(2),
		.OUT_BITS(10)
	)
	CU(
		.CLOCK(CLOCK),
		.RESET_bar(RESET_bar),						//Active-LOW Reset
		.in_lines({datain_valid|buf_rst,alu_LEQ|buf_rst}),
		.out_lines({bufIN_toBus,datout_valid,bufOUT_storeBus,MAR_storeBus,regA_storeBus,regB_storeBus,alu_toBus,pc_inc,pc_storeBUS,pc_toBus})
	);
	
	//Processor External Buffers
	buffer_block #(
		.DATA_WIDTH(DATA_ADDR_WIDTH)
	)
	DATA_BUF_IN(
		.SHOW_DATA(bufIN_toBus),
		.DATA_IN(DATA_IN),
		.DATA_OUT(BUS)
	);
	
	data_reg #(
		.DATA_WIDTH(DATA_ADDR_WIDTH)
	)
	DATA_BUF_OUT (
		.CLOCK(CLOCK),
		.RESET_bar(RESET_bar),						//Active-LOW Reset
		.STORE_DATA(bufOUT_storeBus),				//Active-HIGH Trigger to store DATA_IN Value
		.SHOW_DATA(1'b1),							//Active-HIGH Tigger to show register value to DATA_OUT				
		
		.DATA_IN(BUS),
		.DATA_OUT(DATA_OUT)
	);
	assign DATA_OUT_VALID = datout_valid;
	assign datain_valid = DATA_IN_VALID;
	
	//Memory Access Register
	data_reg #(
		.DATA_WIDTH(DATA_ADDR_WIDTH)
	)
	MAR (
		.CLOCK(CLOCK),
		.RESET_bar(RESET_bar),						//Active-LOW Reset
		.STORE_DATA(MAR_storeBus),					//Active-HIGH Trigger to store DATA_IN Value
		.SHOW_DATA(1'b1),							//Active-HIGH Tigger to show register value to DATA_OUT				
		
		.DATA_IN(BUS),
		.DATA_OUT(ADDR_OUT)
	);
	
	//Data Registers A: Minuend Register for Subtractor Block
	wire [DATA_ADDR_WIDTH-1:0] regA_SUB;
	data_reg #(
		.DATA_WIDTH(DATA_ADDR_WIDTH)
	)
	DATA_REG_A (
		.CLOCK(CLOCK),
		.RESET_bar(RESET_bar),						//Active-LOW Reset
		.STORE_DATA(regA_storeBus),					//Active-HIGH Trigger to store DATA_IN Value
		.SHOW_DATA(1'b1),							//Active-HIGH Tigger to show register value to DATA_OUT				
		
		.DATA_IN(BUS),
		.DATA_OUT(regA_SUB)
	);
	
	//Data Registers B: Subtrahend Register for Subtractor Block and Data holder for PC
	wire [DATA_ADDR_WIDTH-1:0] regB_SUB_PC;
	data_reg #(
		.DATA_WIDTH(DATA_ADDR_WIDTH)
	)
	DATA_REG_B (
		.CLOCK(CLOCK),
		.RESET_bar(RESET_bar),						//Active-LOW Reset
		.STORE_DATA(regB_storeBus),					//Active-HIGH Trigger to store DATA_IN Value
		.SHOW_DATA(1'b1),							//Active-HIGH Tigger to show register value to DATA_OUT				
		
		.DATA_IN(BUS),
		.DATA_OUT(regB_SUB_PC)
	);
	
	//ALU
	subtractor_AB #(
		.DATA_WIDTH(DATA_ADDR_WIDTH)
	)
	ALU_SUBTRACT(
		.SHOW_DATA(alu_toBus),						//Active-HIGH Tigger to show operation difference
		.DATA_A(regA_SUB),
		.DATA_B(regB_SUB_PC),
		.LEQ_FLAG(alu_LEQ),							//1'b1 if DATA_B > DATA_A
		.DATA_OUT(BUS)
	);
	
	//Program Counter
	counter_reg #(
		.DATA_WIDTH(DATA_ADDR_WIDTH),
		.LOOP_COUNTER(1'b1)
	)
	PC (
		.CLOCK(CLOCK),
		.RESET_bar(RESET_bar),						//Active-LOW Reset
		.DATA_INC(pc_inc),							//Active-HIGH increment DATA_STORE
		.DATA_STORE_VAL(pc_storeBUS),				//Active-HIGH to store DATA_IN to DATA_STORE
		.SHOW_DATA(pc_toBus),						//Active-HIGH Tigger to show register value to DATA_OUT
		
		.DATA_IN(BUS),
		.DATA_OUT(BUS)
	);
	
endmodule
