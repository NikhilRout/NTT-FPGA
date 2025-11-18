`include "complex_add.v"
`include "complex_sub.v"
`include "complex_mul.v"

module dif_block (
    input [63:0] in_up, in_down, twiddle,
    output [63:0] out_up, out_down
);
    wire [63:0] temp;
    complex_add A(.a(in_up), .b(in_down), .y(out_up));
    complex_sub S(.a(in_up), .b(in_down), .y(temp));
    complex_mul M(.a(temp), .b(twiddle), .y(out_down));
endmodule
