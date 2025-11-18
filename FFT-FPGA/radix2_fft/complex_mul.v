//Complex multiplication: (a + ib) * (c + id) = (ac - bd) + i(ad + bc)

`include "fpADD32.v"
`include "fpMUL32.v"

module complex_mul (
    input [63:0] a, b,
    output [63:0] y
);
    wire [31:0] re_a = a[63:32];
    wire [31:0] im_a = a[31:0];
    wire [31:0] re_b = b[63:32];
    wire [31:0] im_b = b[31:0];
    
    wire [31:0] ac, bd, ad, bc;
    wire [31:0] neg_bd;
    wire [31:0] re_result, im_result;
    
    fpMUL32 mul_ac(.A(re_a), .B(re_b), .P(ac));
    fpMUL32 mul_bd(.A(im_a), .B(im_b), .P(bd));
    fpMUL32 mul_ad(.A(re_a), .B(im_b), .P(ad));
    fpMUL32 mul_bc(.A(im_a), .B(re_b), .P(bc));

    assign neg_bd = {~bd[31], bd[30:0]}; // Flip sign bit to negate
    
    fpADD32 add_re(.A(ac), .B(neg_bd), .S(re_result));
    fpADD32 add_im(.A(ad), .B(bc), .S(im_result));

    assign y = {re_result, im_result};
endmodule
