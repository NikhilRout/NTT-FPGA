module fpADD32 (
    input [31:0] A, B, //fp32 numbers
    output [31:0] S //fp32 number
);

    wire sign_a = A[31];
    wire sign_b = B[31];

    wire [7:0] exp_a = A[30:23];
    wire [7:0] exp_b = B[30:23];
    wire [22:0] frac_a = A[22:0];
    wire [22:0] frac_b = B[22:0];

    //Hidden bits (implied 1)
    wire hidden_a = |exp_a; //0 if exp_a is all zeros (denormal), 1 otherwise
    wire hidden_b = |exp_b;

    //Exceptions/Special Cases
    wire a_is_zero = (~hidden_a) & (~|frac_a); //(exp_a == 8'd0) && (frac_a == 23'd0);
    wire b_is_zero = (~hidden_b) & (~|frac_b);
    wire a_is_inf = (&exp_a) & (~|frac_a); //(exp_a == 8'hFF) && (frac_a == 23'd0);
    wire b_is_inf = (&exp_b) & (~|frac_b);
    wire a_is_nan = (&exp_a) & (|frac_a); //(exp_a == 8'hFF) && (frac_a != 23'd0);
    wire b_is_nan = (&exp_b) & (|frac_b);
    
    //Result selection based on exceptions/special cases
    wire result_is_nan = a_is_nan | b_is_nan | (a_is_inf & b_is_zero) | (a_is_zero & b_is_inf);
    wire result_is_inf = (a_is_inf & ~b_is_zero) | (b_is_inf & ~a_is_zero);
    wire result_is_zero = a_is_zero & b_is_zero;
    
    reg sign_s;
    reg [7:0] exp_diff, exp_s, exp_ss;
    reg [22:0] mantissa_ss;
    reg [23:0] mantissa_a, mantissa_b;
    reg [24:0] mantissa_s;

    always @(*) begin
        mantissa_a = {hidden_a, frac_a};
        mantissa_b = {hidden_b, frac_b};

        //Align mantissas based on exponents
        if (exp_a >= exp_b) begin
            exp_diff = exp_a - exp_b;
            mantissa_b = mantissa_b >> exp_diff;
            exp_s = exp_a;
            sign_s = sign_a;
        end else begin
            exp_diff = exp_b - exp_a;
            mantissa_a = mantissa_a >> exp_diff;
            exp_s = exp_b;
            sign_s = sign_b;
        end

        //Perform addition or subtraction based on sign
        if (sign_a ~^ sign_b)
            mantissa_s = mantissa_a + mantissa_b;
        else begin
            if (mantissa_a > mantissa_b)
                mantissa_s = mantissa_a - mantissa_b;
            else 
                mantissa_s = mantissa_b - mantissa_a;
            
        end

        //Normalization
        if (mantissa_s[24]) begin
            exp_s = exp_s + 1'b1;
            mantissa_s = mantissa_s >> 1;
        end

        case({result_is_nan, result_is_inf, result_is_zero})
            3'b100: begin
                        exp_ss = 8'hFF;
                        mantissa_ss = 23'h400000;
            end
            3'b010: begin
                        exp_ss = 8'hFF;
                        mantissa_ss = 23'h000000;
            end
            3'b001: begin
                        exp_ss = 8'h00;
                        mantissa_ss = 23'h000000;
            end
            default: begin
                        exp_ss = exp_s;
                        mantissa_ss = mantissa_s;
            end
        endcase
    end

    assign S = {sign_s, exp_ss, mantissa_ss};
endmodule
