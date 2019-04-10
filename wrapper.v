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