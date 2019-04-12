`timescale 10ns / 1ns


module tb_wrapper();

	reg clk, rst;
	wire signed [7:0] data_out;
	wire [2:0] data_type;

	wrapper w1(
		.clk(clk),
		.rst(rst),
		.data_out(data_out),
		.data_type(data_type)
		);

	initial begin
		$dumpfile("wrapper.vcd");
		$dumpvars;
		clk = 0;
		$monitor("data_out : %d, data_type : %d\nrst : %d", data_out, data_type, rst);
		rst = 1;
		#1000000 rst = 0;
		#100000000 $finish;
	end

	always
	begin
		#1 clk = ~clk;
	end

endmodule // tb_wrapper
