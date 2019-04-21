module tb_wrapper_alu();
  reg clk, clk_test, rst;
  wire next_in, output_done;
  reg [7:0] data_in;
  wire [7:0] data_out;
  reg [26:0] delay_test;

  wrapper_alu w1(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out),
    .next_in(next_in),
    .output_done(output_done)
    );

    initial begin
      $dumpfile("alu_wrapper.vcd");
      $dumpvars;
      clk = 0;
      rst = 1;
      data_in = 0;
      delay_test = 0;
      clk_test = 0;
      #50000
      rst = 0;
      #1000000 $finish;
    end

    always begin
      #5 clk = ~clk;
    end

    always @ ( posedge clk ) begin
      delay_test = delay_test+1;
      if(delay_test==5)
      begin
        delay_test = 0;
        clk_test = ~clk_test;
      end
    end

    always@( posedge next_in ) begin
        data_in = data_in + 1;
    end

endmodule
