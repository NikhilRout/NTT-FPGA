`include "ntt.v"

module ntt4point_tb;
  reg clk, rst;
  reg [15:0] in0, in1, in2, in3;
  wire [15:0] out0, out1, out2, out3;
  ntt4point uut(.clk(clk), .rst(rst),
                .in0(in0), .in1(in1), .in2(in2), .in3(in3),
                .out0(out0), .out1(out1), .out2(out2), .out3(out3));
  always #50 clk = ~clk;
  initial begin
    $dumpfile("ntt4point.vcd");
    $dumpvars(0, ntt4point_tb);
    clk = 1;
    rst = 1;
    #100; rst = 0;
    repeat (1000) begin
        in0 = $urandom_range(0, 7681);
        in1 = $urandom_range(0, 7681);
        in2 = $urandom_range(0, 7681);
        in3 = $urandom_range(0, 7681);
        #100;
    end
    $stop;
  end
endmodule