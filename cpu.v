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
	reg [15:0] instr_mem [0:128];

	reg program_counter;
	integer state;
	//state = 0 : instr_read
	//state = 1 : load_operands
	//state = 2 : perform operation
	//state = 3 : save outputs
	//state = 4 : update program_counter and send the outputs

	reg carry;
	reg borrow;
	reg enable_alu;
	reg input_ready_alu;
	reg rst_in;

	wire result_out_alu;
	wire carry_out_alu;
	wire borrow_out_alu;
	wire result_ready_alu;
	wire zero_out_alu;
	wire negative_out_alu;
	wire overflow_out_alu;
	
	reg signed [7:0] operand_A, operand_B;
	reg signed [7:0] operand_A_alu, operand_B_alu;
	reg [4:0] opcode_alu;
	reg signed [7:0] registers [0:7];

	integer iterator;


	module alu alu1(
			.clk(clk),
			.opcode(opcode_alu),
			.operand_A(operand_A_alu),
			.operand_B(operand_B_alu),
			.enable(enable_alu),
			.input_ready(input_ready_alu),
			.carry_in(carry),
			.borrow_in(borrow),
			.rst(rst_in),
			.result_out(result_out_alu),
			.borrow_out(borrow_out_alu),
			.result_ready(result_ready_alu),
			.carry_out(carry_out_alu),
			.zero(zero_out_alu),
			.negative(negative_out_alu),
			.overflow(overflow_out_alu)
		);


	always @(posedge clk or negedge rst_n) begin
		if(reset == 1)
		begin
			instr_mem <= 0;
			program_counter <= 0;
			state <= 0;
			rst_in <= 1;

			carry <= 0;
			borrow <= 0;
			for(iterator = 0; iterator < 8; iterator = iterator + 1)
			begin
				registers[iterator] <= 0;
			end
		end // If end
		else	//else
		begin
			
			rst_in <= 0;
			enable_alu <= 1;

			if(state==0)
			begin
				this_instr <= instr_men[program_counter][15:8];
				operand_A <= instr_mem[program_counter][7:0];

				state <= 1;
			end // if(state==0) end

			if(state==1)
			begin
				state <= 2;

				if(this_instr[7:6]==2'b01)	//instr_mov reg to reg
				begin
					registers[this_instr[5:3]] = registers[this_instr[2:0]];
					state <= 0;
				end

				if(this_instr[7:6]==2'b00 && this_instr[2:0]==3'b110) //instr_mvi
				begin
					registers[this_instr[5:3]] = operand_A;
					state <= 0;
				end

				if(this_instr[7:3]==5'b10000)	//instr_add
				begin
					operand_A_alu <= registers[this_instr[2:0]];
					operand_B_alu <= registers[0];
					opcode_alu <= 0;
				end

				if(this_instr[7:3]==5'b10001)	//instr_addc
				begin
					operand_A_alu <= registers[0];
					operand_B_alu <= registers[this_instr[2:0]];
					opcode_alu <= 1;
				end

				if(this_instr[7:3]==5'b10010)	//instr_sub
				begin
					operand_A_alu <= registers[0];
					operand_B_alu <= registers[this_instr[2:0]];
					opcode_alu <= 2;
				end

				if(this_instr[7:3]==5'b10010)	//instr_subb
				begin
					operand_A_alu <= registers[0];
					operand_B_alu <= registers[this_instr[2:0]];
					opcode_alu <= 3;
				end

				if(this_instr[7:6]==2'b00 && this_instr[2:0]==3'b100) //instr_inr
				begin
					registers[this_instr[5:3]] <= operand_A;
					opcode_alu <= 5;
				end

				if(this_instr[7:6]==2'b00 && this_instr[2:0]==3'b101) //instr_dcr
				begin
					registers[this_instr[5:3]] <= operand_A;
					opcode_alu <= 6;
				end

				if(this_instr[7:3]==5'b10100)	//instr_ana
				begin
					operand_A_alu <= registers[this_instr[2:0]];
					opcode_alu <= 8;
				end				

				if(this_instr[7:3]==5'b10110)	//instr_ora
				begin
					operand_A_alu <= registers[this_instr[2:0]];
					opcode_alu <= 9;
				end				

				if(this_instr[7:3]==5'b10101)	//instr_xra
				begin
					operand_A_alu <= registers[this_instr[2:0]];
					opcode_alu <= 8;
				end				

				if(this_instr[7:3]==5'b10111)	//instr_cmp
				begin
					operand_A_alu <= registers[0];
					operand_B_alu <= registers[this_instr[2:0]];
					opcode_alu <= 2;
				end

				if(this_instr[7:0]==8'b00000111)	//instr_rlc
				begin
					operand_A_alu <= registers[0];
					opcode_alu <= 16;
				end

				if(this_instr[7:0]==8'b00001111)	//instr_rrc
				begin
					operand_A_alu <= registers[0];
					opcode_alu <= 17;
				end

				if(this_instr[7:0]==8'b00010111)	//instr_ral
				begin
					operand_A_alu <= registers[0];
					opcode_alu <= 18;
				end

				if(this_instr[7:0]==8'b00011111)	//instr_rar
				begin
					operand_A_alu <= registers[0];
					opcode_alu <= 19;
				end

				if(this_instr[7:0]==8'b00101111)	//instr_cma
				begin
					operand_A_alu <= registers[0];
					opcode_alu <= 11;
				end

				if(this_instr[7:0]==8'b00111111)	//instr_cmc
				begin
					state <= 0;
					carry <= ~carry;
				end

				if(this_instr[7:0]==8'b11000011)	//instr_jmp
				begin
					program_counter <= operand_A;
					state <= 0;
				end

				if(this_instr[7:6]==2'b11 && this_instr[2:0]==3'b010)
				begin
					if(registers[this_instr[5:3]] > 0)
					begin
						program_counter <= operand_A;
					end
					state <= 0;
				end

				if(this_instr[7:0]==8'b01110110)
				begin
					state <= 6;
				end

				if(this_instr[7:0]==8'b00000000)
				begin
					state <= 0;
				end

			end 	//state==1 end

			if(state==2)
			begin
				if(result_ready_alu != 1)
					input_ready_alu <= 1;
				else
				begin
					state <= 3;
				end
			end 	//state==2 end

			if(state == 3)
			begin

			end

		end   //else end
	end  //else always


endmodule