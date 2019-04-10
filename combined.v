module wrapper(
	input clk,
	input rst,
	output reg [7:0] data_out,
	output reg [2:0] data_type
	);

	reg  clk_cpu, rst_cpu, next_out_cpu ;
	wire result_ready_cpu, data_out_cpu, carry_out_cpu, borrow_out_cpu;
	wire signed [7:0] operand_A, operand_B, result_out_cpu;
	wire [7:0] opcode_out_cpu, pc_out_cpu;

	reg clk_wrapper;
	reg[26:0] delay;

	initial begin
		delay = 0;
		clk_wrapper = 0;
	end // initial

	always@(posedge clk)
	begin
		if(next_out_cpu == 1)
		begin
			next_out_cpu <= 0;
		end
		delay = delay+1;
		if(delay == 27'b101111101011110000100000)
		begin
			delay = 0;
			clk_wrapper = ~clk_wrapper;
		end
	end

	cpu cpu1(
		.clk(clk),
		.rst(rst_cpu),
		.next_out(next_out_cpu),
		.data_out(data_out_cpu),
		.opcode(opcode_out_cpu),
		.operand_A_out(operand_A),
		.operand_B_out(operand_B),
		.result_out_cpu(result_out_cpu),
		.carry_out_cpu(carry_out_cpu),
		.borrow_out_cpu(borrow_out_cpu),
		.result_ready(result_ready_cpu),
		.pc_out(pc_out_cpu)
		);


	always@(posedge clk_wrapper)
	begin
		// $display("data_out_cpu : %d", data_out_cpu);
		// $display("pc_out_cpu : %d", pc_out_cpu);
		if(rst)
		begin
			// $display("Resetting wrapper");
			data_type <= 0;
			rst_cpu <= 1;
			next_out_cpu <= 1;
		end
		else
		begin

			next_out_cpu <= 0;
			rst_cpu <= 0;
			// $display("data_out_cpu : %d", data_out_cpu);
			if(data_out_cpu == 1)
			begin
				// $display("If data_out_cpu == 1"); 
				next_out_cpu <= 0;
				data_type = (data_type+1)%7;
				if(data_type == 0)
				begin
					// $display("opcode_out_cpu : %b",opcode_out_cpu);
					data_out = opcode_out_cpu;
				end

				if(data_type == 1)
					data_out = operand_A;

				if(data_type == 2)
					data_out = operand_B;

				if(data_type == 3)
					data_out = result_out_cpu;

				if(data_type == 4)
					data_out = carry_out_cpu;

				if(data_type == 5)
					data_out = borrow_out_cpu;

				if(data_type == 6)
				begin
					data_out = pc_out_cpu;
					next_out_cpu <= 1;
				end
			end
		end
	end

endmodule // wrapper




module cpu(
	input clk,
	input rst,
	input next_out,
	output reg data_out,
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
	reg temp_state2;

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
		// $display("Connected rst : %d", rst);
		if(rst == 1)
		begin
			// $display("CPU been reset\n");
			this_instr <= 0;
			program_counter <= 0;
			state <= 0;
			rst_in <= 1;
			data_out <= 0;
			
instr_mem[0]=16'b0000000000000000;
instr_mem[1]=16'b0000011001100100;
instr_mem[2]=16'b0000111000101001;
instr_mem[3]=16'b1000000100000000;
instr_mem[4]=16'b1000000100000000;
instr_mem[5]=16'b1010000100000000;
instr_mem[6]=16'b1011000100000000;
instr_mem[7]=16'b0000011100000000;
instr_mem[8]=16'b0000111100000000;
instr_mem[9]=16'b0001011100000000;
instr_mem[10]=16'b0001111100000000;
instr_mem[11]=16'b1100001100000011;

			
			carry <= 0;
			borrow <= 0;
			for(iterator = 0; iterator < 8; iterator = iterator + 1)
			begin
				registers[iterator] <= 0;
			end

			temp_state2 <= 0;
		end // If end
		else	//else
		begin
			
			rst_in <= 0;
			enable_alu <= 1;

			if(state==0)
			begin
				// $display("In state 0");
				temp_16 = instr_mem[program_counter];
				this_instr <= temp_16[15:8];
				operand_A <= temp_16[7:0];

				// $display("operand_A in state 1 : %d\n", operand_A);

				state <= 1;
			end // if(state==0) end

			if(state==1)
			begin
				// $display("In state 1");
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
					operand_A_alu <= registers[0];
					operand_B_alu <= registers[this_instr[2:0]];
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
					// $display("this_instr[2:0] : %d", this_instr[2:0]);
					operand_A_alu <= registers[0];
					operand_B_alu <= registers[this_instr[2:0]];
					opcode_alu <= 10;
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
					// $display("In JMP");
					// $display("carry_out : %d", carry);
					program_counter <= operand_A -1;
					state <= 3;
				end

				if(this_instr[7:6]==2'b11 && this_instr[2:0]==3'b010)
				begin
					if(registers[this_instr[5:3]] > 0)
					begin
						program_counter <= operand_A;
					end
					state <= 4;
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
				// $display("In state 2");
				if(temp_state2 == 0)
				begin
					input_ready_alu <= 1;
					temp_state2 <= 1;
				end
				else
				begin
					input_ready_alu <= 0;
					temp_state2 <= 0;
					state <= 3;
				end

				// input_ready_alu <= 1;
				// state <= 3;
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
				// $display("pc : %d", program_counter);
				// $display("In state 3");
				// $display("in state 3 carry_out_alu : %d",carry_out_alu);
				input_ready_alu <= 0;
				state <= 4;
				program_counter <= program_counter + 1;
				if(this_instr[7:3]==5'b10000 || this_instr[7:3]==5'b10001 || this_instr[7:3]==5'b10010 || this_instr[7:3]==5'b10010 || this_instr[7:3]==5'b10100 || this_instr[7:3]==5'b10110 || this_instr[7:3]==5'b10101 ||
					this_instr[7:0]==8'b00010111 || this_instr[7:0]==8'b00011111 || this_instr[7:0]==8'b00001111 || this_instr[7:0]==8'b00000111 || this_instr[7:0]==8'b00101111 || this_instr[7:0]==8'b00111111)
				begin
					// $display("result_out_alu : %b", result_out_alu);
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
				data_out <= 1;
				// $display("carry_out : %d\n\n", carry_out_alu);
				// $display("next_out : %d", next_out);
				if(next_out == 1)
				begin
					state <= 0;
					data_out <= 0;
				end

			end 	//state==4 end

		end   //else end
	end  //else always


endmodule



`define ADD 0
`define CADD 1
`define SUB 2
`define BSUB 3
`define NEG 4
`define INC 5
`define DEC 6
`define PASS 7
`define AND 8
`define OR 9
`define XOR 10
`define COMP 11
`define L_ARITH_SHIFT 12
`define R_ARITH_SHIFT 13
`define L_LOG_SHIFT 14
`define R_LOG_SHIFT 15
`define L_ROT 16
`define R_ROT 17
`define L_CROT 18
`define R_CROT 19

module alu
(
  input clk,
  input [4:0] opcode,
  input signed [7:0] operand_A,
  input signed [7:0] operand_B,
  input enable,
  input input_ready,
  input carry_in,
  input borrow_in,
  input rst,
  output reg signed [7:0] result_out,
  output reg borrow_out,
  output reg result_ready,
  output reg carry_out,
  output zero,
  output negative,
  output reg overflow
);

  
  reg signed [7:0] temp;

  reg finished;
  reg running;

  assign zero = ~(&(result_out));
  assign negative = (result_out < 0);  

  always@( posedge clk)
    begin
      if(rst)
        begin
          carry_out <= 0;
          result_ready <= 0;
          result_out <= 0;
          overflow <= 0;
          finished <= 1;
          running <= 0;
        end
      else
        begin
          if(enable && input_ready)
            begin
              result_ready <= 0;
              overflow <= 0;
              result_out <= 0;
              carry_out <= 0;
              borrow_out <= 0;
              
              if(opcode == 0)
                begin
                  temp = operand_A+operand_B;
                  if(operand_A[7]==1 && operand_B[7]==1 && temp[7]==0)
                    begin
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end
                  
                  else if(operand_A[7]==0 && operand_B[7]==0 && temp[7]==1)
                    begin
                      carry_out <= 1;
                      // tmp = operand_A + operand_B;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;                  

                end
              
              if(opcode == 1)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, operand_A + operand_B + carry_in );
                  temp = operand_A+operand_B+carry_in;
                  if(operand_A[7]==1 && operand_B[7]==1 && temp[7]==0)
                    begin
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end
                  
                  else if(operand_A[7]==0 && operand_B[7]==0 && temp[7]==1)
                    begin
                      carry_out <= 1;
                      // tmp = operand_A + operand_B;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;
                end
              
              if(opcode == 2)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, $signed(operand_A - operand_B));
                  temp = operand_A - operand_B;
                  if(operand_A[7]==1 && operand_B[7]==0 && temp[7]==0)
                    begin
                      // $display("In <-127");
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end
                  // operand_A[7]==0 && operand_B[7]==1 && temp[7]==0
                  else if(operand_A[7]==0 && operand_B[7]==1 && temp[7]==1)
                    begin
                      // $display("In >127");
                      carry_out <= 1;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;

                end
              
              if(opcode == 3)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, operand_A - operand_B - carry_in );
                  temp = operand_A - operand_B - borrow_in;
                  if(operand_A[7]==1 && operand_B[7]==0 && temp[7]==0)
                    begin
                      // $display("In <-127");
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end
                  // operand_A[7]==0 && operand_B[7]==1 && temp[7]==0
                  else if(operand_A[7]==0 && operand_B[7]==1 && temp[7]==1)
                    begin
                      // $display("In >127");
                      carry_out <= 1;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;

                end
              
              if(opcode == 4)
                begin
                  if(operand_A==-128)
                    begin
                      carry_out <= 1;
                      result_out <= 0;
                      overflow <= 1;
                    end
                  else
                    result_out <= -operand_A;
                end
              
              if(opcode == 5)
                begin
                  if(operand_A==127)
                    begin
                      carry_out <= 1;
                      result_out <= 0;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A + 1;

                end
              
              if(opcode == 6)
                begin
                  if(operand_A == -128)
                    begin
                      borrow_out <= 1;
                      result_out <= -1;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A - 1;

                end
              
              if(opcode == 7)
                begin
                  result_out <= operand_A;
                end
              
              if(opcode == 8)
                result_out <= operand_A & operand_B;
              
              if(opcode == 9)
                result_out <= operand_A | operand_B;
              
              if(opcode == 10)
                result_out <= operand_A ^ operand_B;
              
              if(opcode == 11)
                result_out <= ~operand_A;
              
              if(opcode == 12)
                begin
                  result_out[0] <= 0;
                  result_out[7:1] <= operand_A[6:0];
                end
              
              if(opcode == 13)
                begin
                  result_out[7] <= operand_A[7];
                  result_out[6:0] <= operand_A[7:1];
                end
              
              
              if(opcode == 14)
                begin
                  result_out[0] <= 0;
                  result_out[7:1] <= operand_A[6:0];
                end
              
              if(opcode == 15)
                begin
                  result_out[7] <= 0;
                  result_out[6:0] <= operand_A[7:1];
                end
              
              if(opcode == 16)
                begin
                  // $display("operand_A : %b", operand_A);
                  result_out[0] <= operand_A[7];
                  result_out[7:1] <= operand_A[6:0];
                  // $display("operand_A[7] : %b", operand_A[7]);
                  // $display("operand_A[6:0] : %b", operand_A[6:0]);
                  // $display("result_out : %b", result_out);
                end
              
              if(opcode == 17)
                begin
                  result_out[7] <= operand_A[0];
                  result_out[6:0] <= operand_A[7:1];
                end
              
              if(opcode == 18)
                begin
                  carry_out <= operand_A[7];
                  result_out[7:1] <= operand_A[6:0];
                  result_out[0] <= carry_in;
                end
              
              if(opcode == 19)
                begin
                  carry_out <= operand_A[0];
                  result_out[7] <= carry_in;
                  result_out[6:0] <= operand_A[7:1];
                end
              result_ready <= 1;
            end
        end
    end

endmodule
