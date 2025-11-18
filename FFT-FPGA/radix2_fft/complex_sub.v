`include "fpADD32.v"

module complex_sub (
    input [63:0] a, b,
    output [63:0] y
);
    wire [31:0] re_a = a[63:32];
    wire [31:0] im_a = a[31:0];
    wire [31:0] re_b = b[63:32];
    wire [31:0] im_b = b[31:0];

    wire [31:0] neg_re_b = {~re_b[31], re_b[30:0]}; //flip sign bit to negate
    wire [31:0] neg_im_b = {~im_b[31], im_b[30:0]};

    wire [31:0] re_diff, im_diff;
    
    fpADD32 sub_real(.A(re_a), .B(neg_re_b), .S(re_diff));
    fpADD32 sub_imag(.A(im_a), .B(neg_im_b), .S(im_diff));
    
    assign y = {re_diff, im_diff};
endmodule
