//======================================================
// DAY 6 : 4-BIT ALU
//======================================================


//======================================================
// 1. BASIC GATES
//======================================================

module and_gate(
    input A,
    input B,
    output Y
);
    assign Y = A & B;
endmodule


module or_gate(
    input A,
    input B,
    output Y
);
    assign Y = A | B;
endmodule


module xor_gate(
    input A,
    input B,
    output Y
);
    assign Y = A ^ B;
endmodule


module not_gate(
    input A,
    output Y
);
    assign Y = ~A;
endmodule


//======================================================
// 2. 2:1 MUX
//======================================================

module mux_2to1(
    input I0,
    input I1,
    input S,
    output Y
);
    assign Y = S ? I1 : I0;
endmodule


//======================================================
// 3. HALF ADDER
//======================================================

module half_adder(
    input A,
    input B,
    output SUM,
    output CARRY
);

    xor_gate x1(
        .A(A),
        .B(B),
        .Y(SUM)
    );

    and_gate a1(
        .A(A),
        .B(B),
        .Y(CARRY)
    );

endmodule


//======================================================
// 4. FULL ADDER
//======================================================

module full_adder(
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);

    wire sum1;
    wire carry1;
    wire carry2;

    half_adder HA1(
        .A(A),
        .B(B),
        .SUM(sum1),
        .CARRY(carry1)
    );

    half_adder HA2(
        .A(sum1),
        .B(CIN),
        .SUM(SUM),
        .CARRY(carry2)
    );

    or_gate O1(
        .A(carry1),
        .B(carry2),
        .Y(COUT)
    );

endmodule


//======================================================
// 5. 4-BIT RIPPLE CARRY ADDER
//======================================================

module ripple_carry_adder_4bit(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] SUM,
    output COUT
);

    wire c1;
    wire c2;
    wire c3;

    full_adder FA0(
        .A(A[0]),
        .B(B[0]),
        .CIN(CIN),
        .SUM(SUM[0]),
        .COUT(c1)
    );

    full_adder FA1(
        .A(A[1]),
        .B(B[1]),
        .CIN(c1),
        .SUM(SUM[1]),
        .COUT(c2)
    );

    full_adder FA2(
        .A(A[2]),
        .B(B[2]),
        .CIN(c2),
        .SUM(SUM[2]),
        .COUT(c3)
    );

    full_adder FA3(
        .A(A[3]),
        .B(B[3]),
        .CIN(c3),
        .SUM(SUM[3]),
        .COUT(COUT)
    );

endmodule


//======================================================
// 6. 4-BIT ADDER/SUBTRACTOR
//======================================================

module adder_subtractor_4bit(
    input [3:0] A,
    input [3:0] B,
    input MODE,
    output [3:0] RESULT,
    output COUT
);

    wire [3:0] B_MODIFIED;

    // MODE = 0 → B
    // MODE = 1 → ~B

    assign B_MODIFIED = B ^ {4{MODE}};

    // MODE = 0 → A + B
    // MODE = 1 → A + ~B + 1 = A - B

    ripple_carry_adder_4bit ADDER(
        .A(A),
        .B(B_MODIFIED),
        .CIN(MODE),
        .SUM(RESULT),
        .COUT(COUT)
    );

endmodule


//======================================================
// 7. 4-BIT AND
//======================================================

module and_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);

    assign Y = A & B;

endmodule


//======================================================
// 8. 4-BIT OR
//======================================================

module or_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);

    assign Y = A | B;

endmodule


//======================================================
// 9. 4-BIT XOR
//======================================================

module xor_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);

    assign Y = A ^ B;

endmodule


//======================================================
// 10. 4-BIT INCREMENTER
//======================================================

module incrementer_4bit(
    input [3:0] A,
    output [3:0] Y,
    output COUT
);

    assign {COUT, Y} = {1'b0, A} + 5'b00001;

endmodule


//======================================================
// 11. 4-BIT DECREMENTER
//======================================================

module decrementer_4bit(
    input [3:0] A,
    output [3:0] Y,
    output COUT
);

    assign {COUT, Y} = {1'b0, A} - 5'b00001;

endmodule


//======================================================
// 12. 8:1 MUX FOR 4-BIT DATA
//======================================================

module mux_8to1_4bit(
    input [3:0] I0,
    input [3:0] I1,
    input [3:0] I2,
    input [3:0] I3,
    input [3:0] I4,
    input [3:0] I5,
    input [3:0] I6,
    input [3:0] I7,
    input [2:0] S,
    output reg [3:0] Y
);

    always @(*) begin

        case(S)

            3'b000: Y = I0;
            3'b001: Y = I1;
            3'b010: Y = I2;
            3'b011: Y = I3;
            3'b100: Y = I4;
            3'b101: Y = I5;
            3'b110: Y = I6;
            3'b111: Y = I7;

            default: Y = 4'b0000;

        endcase

    end

endmodule


//======================================================
// 13. 4-BIT ALU
//======================================================

module alu_4bit(
    input [3:0] A,
    input [3:0] B,
    input [2:0] OP,
    output [3:0] Y,
    output COUT
);

    wire [3:0] ADD_RESULT;
    wire [3:0] SUB_RESULT;
    wire [3:0] AND_RESULT;
    wire [3:0] OR_RESULT;
    wire [3:0] XOR_RESULT;
    wire [3:0] INC_RESULT;
    wire [3:0] DEC_RESULT;

    wire ADD_COUT;
    wire SUB_COUT;
    wire INC_COUT;
    wire DEC_COUT;

    // Arithmetic operations
    adder_subtractor_4bit ADD_UNIT(
        .A(A),
        .B(B),
        .MODE(1'b0),
        .RESULT(ADD_RESULT),
        .COUT(ADD_COUT)
    );

    adder_subtractor_4bit SUB_UNIT(
        .A(A),
        .B(B),
        .MODE(1'b1),
        .RESULT(SUB_RESULT),
        .COUT(SUB_COUT)
    );

    incrementer_4bit INC_UNIT(
        .A(A),
        .Y(INC_RESULT),
        .COUT(INC_COUT)
    );

    decrementer_4bit DEC_UNIT(
        .A(A),
        .Y(DEC_RESULT),
        .COUT(DEC_COUT)
    );

    // Logic operations
    and_4bit AND_UNIT(
        .A(A),
        .B(B),
        .Y(AND_RESULT)
    );

    or_4bit OR_UNIT(
        .A(A),
        .B(B),
        .Y(OR_RESULT)
    );

    xor_4bit XOR_UNIT(
        .A(A),
        .B(B),
        .Y(XOR_RESULT)
    );

    // Select required ALU result
    mux_8to1_4bit RESULT_MUX(
        .I0(ADD_RESULT),
        .I1(SUB_RESULT),
        .I2(AND_RESULT),
        .I3(OR_RESULT),
        .I4(XOR_RESULT),
        .I5(INC_RESULT),
        .I6(DEC_RESULT),
        .I7(A),
        .S(OP),
        .Y(Y)
    );

    // Carry output
    assign COUT =
        (OP == 3'b000) ? ADD_COUT :
        (OP == 3'b001) ? SUB_COUT :
        (OP == 3'b101) ? INC_COUT :
        (OP == 3'b110) ? DEC_COUT :
        1'b0;

endmodule
