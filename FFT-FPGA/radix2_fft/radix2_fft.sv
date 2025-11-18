`define dit
// `define dif
//(un)comment as required

`ifdef dit
    `include "dit_block.v"
`elsif dif
    `include "dif_block.v"
`endif

module radix2_fft (
    input clk, rst,
    input [63:0] xn[0:7],  //32-bit real + 32-bit imaginary parts
    output reg [63:0] xk[0:7]
);
    //Twiddle factors
    wire [63:0] W_0 = {32'h3F800000, 32'h00000000}; // 1 + 0j
    wire [63:0] W_1 = {32'h3F3504F3, 32'hBF3504F3}; // 0.707 - 0.707j
    wire [63:0] W_2 = {32'h00000000, 32'hBF800000}; // 0 - 1j
    wire [63:0] W_3 = {32'hBF3504F3, 32'hBF3504F3}; // -0.707 - 0.707j

    wire [63:0] s1_out[0:7]; //intermediate stage outputs
    wire [63:0] s2_out[0:7];
    wire [63:0] s3_out[0:7];

    reg [63:0] s1[0:7]; // pipeline registers
    reg [63:0] s2[0:7];

`ifdef dit
    //Stage 1
    dit_block m1(xn[0], xn[4], W_0, s1_out[0], s1_out[1]);
    dit_block m2(xn[2], xn[6], W_0, s1_out[2], s1_out[3]);
    dit_block m3(xn[1], xn[5], W_0, s1_out[4], s1_out[5]);
    dit_block m4(xn[3], xn[7], W_0, s1_out[6], s1_out[7]);

    //Stage 2
    dit_block m5(s1[0], s1[2], W_0, s2_out[0], s2_out[2]);
    dit_block m6(s1[1], s1[3], W_2, s2_out[1], s2_out[3]);
    dit_block m7(s1[4], s1[6], W_0, s2_out[4], s2_out[6]);
    dit_block m8(s1[5], s1[7], W_2, s2_out[5], s2_out[7]);

    //Stage 3
    dit_block m9(s2[0], s2[4], W_0, s3_out[0], s3_out[4]);
    dit_block m10(s2[1], s2[5], W_1, s3_out[1], s3_out[5]);
    dit_block m11(s2[2], s2[6], W_2, s3_out[2], s3_out[6]);
    dit_block m12(s2[3], s2[7], W_3, s3_out[3], s3_out[7]);

`elsif dif
    //Stage 1
    dif_block m1(xn[0], xn[4], W_0, s1_out[0], s1_out[4]);
    dif_block m2(xn[1], xn[5], W_1, s1_out[1], s1_out[5]);
    dif_block m3(xn[2], xn[6], W_2, s1_out[2], s1_out[6]);
    dif_block m4(xn[3], xn[7], W_3, s1_out[3], s1_out[7]);

    //Stage 2
    dif_block m5(s1[0], s1[2], W_0, s2_out[0], s2_out[2]);
    dif_block m6(s1[1], s1[3], W_2, s2_out[1], s2_out[3]);
    dif_block m7(s1[4], s1[6], W_0, s2_out[4], s2_out[6]);
    dif_block m8(s1[5], s1[7], W_2, s2_out[5], s2_out[7]);

    //Stage 3
    dif_block m9(s2[0], s2[1], W_0, s3_out[0], s3_out[1]);
    dif_block m10(s2[2], s2[3], W_0, s3_out[2], s3_out[3]);
    dif_block m11(s2[4], s2[5], W_0, s3_out[4], s3_out[5]);
    dif_block m12(s2[6], s2[7], W_0, s3_out[6], s3_out[7]);
`endif

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            xk[0] <= 0; xk[1] <= 0; xk[2] <= 0; xk[3] <= 0;
            xk[4] <= 0; xk[5] <= 0; xk[6] <= 0; xk[7] <= 0;
        end else begin
            s1[0] <= s1_out[0]; s1[1] <= s1_out[1]; s1[2] <= s1_out[2]; s1[3] <= s1_out[3];
            s1[4] <= s1_out[4]; s1[5] <= s1_out[5]; s1[6] <= s1_out[6]; s1[7] <= s1_out[7];

            s2[0] <= s2_out[0]; s2[1] <= s2_out[1]; s2[2] <= s2_out[2]; s2[3] <= s2_out[3]; 
            s2[4] <= s2_out[4]; s2[5] <= s2_out[5]; s2[6] <= s2_out[6]; s2[7] <= s2_out[7];

            xk[0] <= s3_out[0]; xk[1] <= s3_out[1]; xk[2] <= s3_out[2]; xk[3] <= s3_out[3];
            xk[4] <= s3_out[4]; xk[5] <= s3_out[5]; xk[6] <= s3_out[6]; xk[7] <= s3_out[7];
        end
    end
endmodule
