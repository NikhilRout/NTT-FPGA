module fpMUL32 (
    input [31:0] A, B,
    output [31:0] P
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
    wire a_is_zero = (~hidden_a) & (~|frac_a); //(exp_a == 8'b0) && (frac_a == 23'b0);
    wire b_is_zero = (~hidden_b) & (~|frac_b);
    wire a_is_inf = (&exp_a) & (~|frac_a); //(exp_a == 8'hFF) && (frac_a == 23'b0);
    wire b_is_inf = (&exp_b) & (~|frac_b);
    wire a_is_nan = (&exp_a) & (|frac_a); //(exp_a == 8'hFF) && (frac_a == 23'b0);
    wire b_is_nan = (&exp_b) & (|frac_b);
    
    //Product Sign bit
    wire sign_p = sign_a ^ sign_b;
    
    //Product Mantissa calc
    wire [23:0] full_frac_a = {hidden_a, frac_a};
    wire [23:0] full_frac_b = {hidden_b, frac_b};
    wire [47:0] frac_mul = full_frac_a * full_frac_b;
    //Normalization
    wire frac_mul_msb = frac_mul[47];
    wire [47:0] normalized_frac = frac_mul_msb ? frac_mul : frac_mul << 1;
    //Round to Nearest, Ties to Even (RNE)
    wire [22:0] rounded_frac = normalized_frac[46:24] + (normalized_frac[23] & (|normalized_frac[22:0] | normalized_frac[24]));
    
    //Product Exponent calc
    wire [9:0] exp_sum = {2'b0, exp_a} + {2'b0, exp_b} - 10'd127 + frac_mul_msb; //10bits cause {sign-bit, carry, number}
    wire underflow = exp_sum[9] | (~|exp_sum[8:0]); //underflow detected if sign-bit is 1 --> -ve exp (out of bounds) or exp=0
    wire overflow = (~exp_sum[9]) & (exp_sum[8] | (&exp_sum[7:0])); //overflow detected if +ve exp and exp >= 255 
    
    //Result selection based on exceptions/special cases
    wire result_is_nan = a_is_nan | b_is_nan | (a_is_inf & b_is_zero) | (a_is_zero & b_is_inf);
    wire result_is_inf = overflow | (a_is_inf & ~b_is_zero) | (b_is_inf & ~a_is_zero);
    wire result_is_zero = underflow | a_is_zero | b_is_zero;

    reg [7:0] exp_p;
    reg [22:0] frac_p;

    always @(*) begin
        case({result_is_nan, result_is_inf, result_is_zero})
            3'b100: begin
                        exp_p = 8'hFF;
                        frac_p = 23'h400000;
            end
            3'b010: begin
                        exp_p = 8'hFF;
                        frac_p = 23'h000000;
            end
            3'b001: begin
                        exp_p = 8'h00;
                        frac_p = 23'h000000;
            end
            default: begin
                        exp_p = exp_sum[7:0];
                        frac_p = rounded_frac;
            end
        endcase
    end           
    assign P = {sign_p, exp_p, frac_p};
endmodule
