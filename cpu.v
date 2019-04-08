module cpu(
	input clk,
	input rst,
	input next_out,
	output data_out,
	output reg [7:0] opcode,
	output reg signed [7:0] operand_A_out,
	output reg signed [7:0] operand_B_out,
	output reg signed [7:0] result_out_cpu,
	output reg carry_out_cpu,
	output reg borrow_out_cpu,
	output reg result_ready,
	output reg [7:0] pc_out
	);
	
	reg [7:0] this_instr;
	reg [15:0] instr_mem [0:128];

	reg [7:0] program_counter;
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

	reg [15:0] temp_16;

	wire [7:0] result_out_alu;
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


	alu alu1(
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


	always @(posedge clk) begin
		if(rst == 1)
		begin
			$display("Has been reset\n");
			this_instr <= 0;
			program_counter <= 0;
			state <= 0;
			rst_in <= 1;
			
			instr_mem[0]=16'b0000000000000000; 
			instr_mem[1]=16'b0000011000000010; 
			instr_mem[2]=16'b0000111011110110; 
			instr_mem[3]=16'b1000000100000000; 
			instr_mem[4]=16'b0001011000000100; 
			instr_mem[5]=16'b1001000100000000; 
			instr_mem[6]=16'b1100001100000011;
			
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
				temp_16 = instr_mem[program_counter];
				this_instr <= temp_16[15:8];
				operand_A <= temp_16[7:0];

				// $display("operand_A in state 1 : %d\n", operand_A);

				state <= 1;
			end // if(state==0) end

			if(state==1)
			begin
				state <= 2;

				if(this_instr[7:6]==2'b01)	//instr_mov reg to reg
				begin
					registers[this_instr[5:3]] = registers[this_instr[2:0]];
					state <= 3;
				end

				if(this_instr[7:6]==2'b00 && this_instr[2:0]==3'b110) //instr_mvi
				begin
					registers[this_instr[5:3]] = operand_A;
					// $display("In MVI, state1.\nvalue : %d, registers[value] : %d", this_instr[5:3], operand_A);
					state <= 3;
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
					operand_B_alu <= registers[0];
					opcode_alu <= 8;
				end				

				if(this_instr[7:3]==5'b10110)	//instr_ora
				begin
					operand_A_alu <= registers[this_instr[2:0]];
					operand_B_alu <= registers[0];
					opcode_alu <= 9;
				end				

				if(this_instr[7:3]==5'b10101)	//instr_xra
				begin
					operand_A_alu <= registers[this_instr[2:0]];
					operand_B_alu <= registers[0];
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
					state <= 3;
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
					// $display("In NOP state 1, Set state to 0");
					state <= 3;
					// program_counter <= program_counter + 1;
				end

			end 	//state==1 end

			if(state==2)
			begin
				input_ready_alu <= 1;
				state <= 3;
				// if(result_ready_alu != 1 && input_ready_alu == 0)
				// 	input_ready_alu <= 1;
				// else
				// begin
				// 	input_ready_alu <= 0;
				// 	state <= 3;
				// end
			end 	//state==2 end

			if(state == 3)
			begin
				input_ready_alu <= 0;
				state <= 4;
				program_counter <= program_counter + 1;
				if(this_instr[7:3]==5'b10000 || this_instr[7:3]==5'b10001 || this_instr[7:3]==5'b10010 || this_instr[7:3]==5'b10010 || this_instr[7:3]==5'b10100 || this_instr[7:3]==5'b10110 || this_instr[7:3]==5'b10101 ||
					this_instr[7:0]==8'b00010111 || this_instr[7:0]==8'b00011111 || this_instr[7:0]==8'b00001111 || this_instr[7:0]==8'b00000111 || this_instr[7:0]==8'b00101111 || this_instr[7:0]==8'b00111111)
				begin
					registers[0] <= result_out_alu;
					carry <= carry_out_alu;
					borrow <= borrow_out_alu;
				end
				else if((this_instr[7:6]==2'b00 && this_instr[2:0]==3'b100) || (this_instr[7:6]==2'b00 && this_instr[2:0]==3'b101))
				begin
					registers[this_instr[5:3]] <= result_out_alu;
					carry <= carry_out_alu;
					borrow <= borrow_out_alu;
				end
			end

			if(state == 4)
			begin
				// $display("In state 4");

				opcode <= this_instr;
				pc_out <= program_counter;
				operand_A_out <= operand_A_alu;
				operand_B_out <= operand_B_alu;
				result_out_cpu <= result_out_alu;
				carry_out_cpu <= carry_out_alu;
				borrow_out_cpu <= borrow_out_alu;
				result_ready <= 1;
				$display("carry_out : %d\n\n", carry_out_alu);
				if(next_out == 1)
					state <= 0;

			end 	//state==4 end

		end   //else end
	end  //else always


endmodule