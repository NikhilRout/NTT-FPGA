`include "dif_fft.v"

module dif_fft_tb;
    reg [31:0] xn0, xn1, xn2, xn3, xn4, xn5, xn6, xn7;
    wire [31:0] xk0, xk1, xk2, xk3, xk4, xk5, xk6, xk7;
    dif_fft uut(.xn0(xn0), .xn1(xn1), .xn2(xn2), .xn3(xn3), .xn4(xn4), .xn5(xn5), .xn6(xn6), .xn7(xn7),
                .xk0(xk0), .xk1(xk1), .xk2(xk2), .xk3(xk3), .xk4(xk4), .xk5(xk5), .xk6(xk6), .xk7(xk7));
    initial begin
        $dumpfile("dif_fft.vcd");
        $dumpvars(0, dif_fft_tb);
        repeat (1000) begin
            xn0 = $urandom_range(0, 4294967295);
            xn1 = $urandom_range(0, 4294967295);
            xn2 = $urandom_range(0, 4294967295);
            xn3 = $urandom_range(0, 4294967295);
            xn4 = $urandom_range(0, 4294967295);
            xn5 = $urandom_range(0, 4294967295);
            xn6 = $urandom_range(0, 4294967295);
            xn7 = $urandom_range(0, 4294967295);
            #100;
        end
    end
endmodule
