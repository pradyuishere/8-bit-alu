module tb_cpu();
	reg clk;
	reg rst;
	reg next_out;
	wire data_out, carry_out, borrow_out, result_ready;
	wire signed [7:0] operand_A_out, operand_B_out, result_out;
	wire [7:0] pc_out, opcode_out;

	cpu cpu1(
		.clk(clk),
		.rst(rst),
		.next_out(next_out),
		.data_out(data_out),
		.opcode(opcode_out),
		.operand_A_out(operand_A_out),
		.operand_B_out(operand_B_out),
		.result_out_cpu(result_out),
		.carry_out_cpu(carry_out),
		.borrow_out_cpu(borrow_out),
		.result_ready(result_ready),
		.pc_out(pc_out)
		);


	initial begin
		clk = 0;
		rst = 1;
		#50 rst = 0;
		next_out = 1;
		$monitor("\noperand_A_out : %b, operand_B_out : %b, opcode : %b \nresult_out : %b, carry_out : %b, borrow_out : %b\n pc : %d, data_out : %b\n", operand_A_out, operand_B_out, opcode_out, result_out, carry_out, borrow_out, pc_out, data_out);
		#20000 $finish;
	end

	always
		#5 clk = ~clk;

	always
		#100 next_out = ~next_out;


endmodule // tb_cpu