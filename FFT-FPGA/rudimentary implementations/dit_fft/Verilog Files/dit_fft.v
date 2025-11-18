//31:24 -> Re(INT)
//23:16 -> Re(FRAC)
//15:8 -> Im(INT)
//7:0 -> Im(FRAC)

//numbers upto +_ 32

module dit_fft (
    input [31:0] xn0, xn1, xn2, xn3, xn4, xn5, xn6, xn7,
    output [31:0] xk0, xk1, xk2, xk3, xk4, xk5, xk6, xk7
);
    integer W_0 = 32'h0100_0000; //1
    integer W_1 = 32'h00b5_ff4b; //0.707-0.707j
    integer W_2 = 32'h0000_ff00; //-j
    integer W_3 = 32'hff4b_ff4b; //-0.707-0.707j

    wire [31:0] s10, s11, s12, s13, s14, s15, s16, s17;
    wire [31:0] s20, s21, s22, s23, s24, s25, s26, s27;

    dit_mul m1(xn0, xn4, W_0, s10, s11);
    dit_mul m2(xn2, xn6, W_0, s12, s13);
    dit_mul m3(xn1, xn5, W_0, s14, s15);
    dit_mul m4(xn3, xn7, W_0, s16, s17);

    dit_mul m5(s10, s12, W_0, s20, s22);
    dit_mul m6(s11, s13, W_2, s21, s23);
    dit_mul m7(s14, s16, W_0, s24, s26);
    dit_mul m8(s15, s17, W_2, s25, s27);

    dit_mul m9(s20, s24, W_0, xk0, xk4);
    dit_mul m10(s21, s25, W_1, xk1, xk5);
    dit_mul m11(s22, s26, W_2, xk2, xk6);
    dit_mul m12(s23, s27, W_3, xk3, xk7);    
endmodule

module dit_mul (
    input [31:0] in_up, in_down, twiddle,
    output [31:0] out_up, out_down
);
    wire [31:0] temp;
    comp_mul mul(.a(in_down), .b(twiddle), .y(temp));
    comp_add add(.a(in_up), .b(temp), .y(out_up));
    comp_sub sub(.a(in_up), .b(temp), .y(out_down));
endmodule

module comp_add (
    input [31:0] a, b,
    output [31:0] y
);
    wire signed [15:0] re_A = a[31:16];
    wire signed [15:0] im_A = a[15:0];
    wire signed [15:0] re_B = b[31:16];
    wire signed [15:0] im_B = b[15:0];
    assign y = {(re_A + re_B), (im_A + im_B)}; 
endmodule

module comp_sub (
    input [31:0] a, b,
    output [31:0] y
);
    wire signed [15:0] re_A = a[31:16];
    wire signed [15:0] im_A = a[15:0];
    wire signed [15:0] re_B = b[31:16];
    wire signed [15:0] im_B = b[15:0];
    assign y = {(re_A - re_B), (im_A - im_B)}; 
endmodule

//(a + ib) (c + id) = (ac - bd) + i(ad + bc)
module comp_mul (
    input [31:0] a, b,
    output [31:0] y
);
    wire signed [15:0] re_A = a[31:16];
    wire signed [15:0] im_A = a[15:0];
    wire signed [15:0] re_B = b[31:16];
    wire signed [15:0] im_B = b[15:0];
    wire [31:0] ac = re_A * re_B;
    wire [31:0] bd = im_A * im_B;
    wire [31:0] ad = re_A * im_B;
    wire [31:0] bc = re_B * im_A;
    assign y = {($signed(ac[23:8])-$signed(bd[23:8])),($signed(ad[23:8])+$signed(bc[23:8]))};
endmodule
