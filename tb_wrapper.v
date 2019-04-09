module tb_wrapper();

	reg clk, rst;
	reg signed [7:0] data_out;
	reg [2:0] data_type;

	wrapper w1(
		.clk(clk),
		.rst(rst),
		.data_out(data_out),
		.data_type(data_type)
		);

	initial begin
		clk = 0;
		$monitor("data_out : %d, data_type : %d\nrst : %d\n\n", data_out, data_type, rst);
		rst = 1;
		#50 rst = 0;
		#1000 $finish;
	end

	always
	begin
		#5 clk = ~clk;
	end

endmodule // tb_wrapper