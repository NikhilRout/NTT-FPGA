`include "fpADD32.v"

module complex_add (
    input [63:0] a, b,
    output [63:0] y
);
    wire [31:0] re_a = a[63:32];
    wire [31:0] im_a = a[31:0];
    wire [31:0] re_b = b[63:32];
    wire [31:0] im_b = b[31:0];
    
    wire [31:0] re_sum, im_sum;
    
    fpADD32 add_real(.A(re_a), .B(re_b), .S(re_sum));
    fpADD32 add_imag(.A(im_a), .B(im_b), .S(im_sum));

    assign y = {re_sum, im_sum};
endmodule
