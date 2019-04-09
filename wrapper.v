module wrapper(
	input clk,
	input rst,
	output reg [7:0] data_out,
	output reg [2:0] data_type
	);

	reg result_ready_cpu, clk_cpu, rst_cpu, next_out_cpu, data_out_cpu, carry_out_cpu, borrow_out_cpu;
	reg signed [7:0] operand_A, operand_B, result_out_cpu;
	reg [7:0] opcode_out_cpu, pc_out_cpu;



	cpu cpu1(
		.clk(clk_cpu),
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

	initial begin
		data_type = 0;
		rst_cpu = 1;
		#50 rst_cpu = 0;
		next_out_cpu = 1;
		#1000 $finish;
	end


	always@(posedge clk)
	begin

		if(rst)
		begin
			data_type <= 0;
			rst_cpu <= 1;
		end
		else
		begin
			if(data_out_cpu == 1)
			begin
				data_type = (data_type+1)%7;
				if(data_type == 0)
				begin
					data_out = opcode;
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