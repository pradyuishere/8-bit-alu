module cpu(
	input clk,
	input rst,
	output data_out,
	output opcode,
	output signed [7:0] operand_A_out,
	output signed [7:0] operand_B_out,
	output signed [7:0] output_ready
	);
	
	reg [7:0] this_instr;
	reg [23:0] instr_mem [0:128];

	reg program_counter;
	integer state;
	//state = 0 : instr_read
	//state = 1 : load_operands
	//state = 2 : perform operation
	//state = 3 : save outputs
	//state = 4 : update program_counter and send the outputs
	reg instr;
	reg signed [7:0] operand_A, operand_B;
	reg signed [7:0] operand_A_alu, operand_B_alu;
	reg [4:0] opcode_alu;
	reg signed [7:0] registers [0:7];

	integer iterator;



	always @(posedge clk or negedge rst_n) begin
		if(reset == 1)
		begin
			instr_mem <= 0;
			program_counter <= 0;
			state <= 0;

			for(iterator = 0; iterator < 8; iterator = iterator + 1)
			begin
				registers[iterator] <= 0;
			end
		end // If end
		else	//else
		begin
			if(state==0)
			begin
				this_instr <= instr_men[program_counter][23:16];
				operand_A <= instr_mem[program_counter][15:8];
				operand_B <= instr_mem[program_counter][7:0];

				state <= 1;
			end // if(state==0) end

			if(state==1)
			begin
				if(this_instr[31:30]==2'b01)	//instr_mov reg to reg
				begin
					registers[this_instr[29:27]] = registers[this_instr[26:24]];
				end

				if(this_instr[31:30]==2'b00 && this_instr[26:24]==3'b110) //instr_mvi
				begin
					registers[this_instr[29:27]] = operand_A;
				end

				if(this_instr[31:27]==5'b10000)	//instr_add
				begin
					operand_A_alu <= registers[this_instr[26:24]];
					operand_B_alu <= registers[0];
					opcode_alu <= 0;
				end
			end

		end   //else end
	end  //else always


endmodule