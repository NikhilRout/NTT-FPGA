`include "complex_add.v"
`include "complex_sub.v"
`include "complex_mul.v"

module dit_block (
    input [63:0] in_up, in_down, twiddle,
    output [63:0] out_up, out_down
);
    wire [63:0] temp;
    complex_mul M(.a(in_down), .b(twiddle), .y(temp));
    complex_add A(.a(in_up), .b(temp), .y(out_up));
    complex_sub S(.a(in_up), .b(temp), .y(out_down));
endmodule
