// CS 4341.502
// Group name: Verilog Vultures

//=============================================
// Half Adder
//=============================================
module HalfAdder(A,B,carry,sum);
	input A;
	input B;
	output carry;
	output sum;
	reg carry;
	reg sum;
//---------------------------------------------	
	always @(*) 
	  begin
	    sum= A ^ B;
	    carry= A & B;
	  end
//---------------------------------------------
endmodule


//=============================================
// Full Adder
//=============================================
module FullAdder(A,B,C,carry,sum);
	input A;
	input B;
	input C;
	output carry;
	output sum;
	reg carry;
	reg sum;
//---------------------------------------------	
	wire c0;
	wire s0;
	wire c1;
	wire s1;
//---------------------------------------------
	HalfAdder ha1(A ,B,c0,s0);
	HalfAdder ha2(s0,C,c1,s1);
//---------------------------------------------
	always @(*) 
	  begin
	    sum=s1;
		//sum= A^B^C;	 Behavoral code
	    carry=c1|c0;
		//carry= ((A^B)&C)|(A&B);  Behavoral code
	  end
//---------------------------------------------
	
endmodule

/*
	AddSub-32Bit performs addition or subtraction depending on the mode bit.
	AddSub Module for 16-bit inputs and 32-bit output.
	The module akes 2 inputs A and B where each holds 16-bit.
	The module takes mode.
		If mode is 0, AddSub module performs addition.
		If mode is 1, AddSub module performs subtraction.
	The module takes sum, the 32-bit output.
	The module takes carry and overflow.
*/
module ADD_SUB(A,B,M,S,C,V);
    input [15:0] A;
	input [15:0] B;
    input M;
    output [31:0] S;
	output C;
    output V;
    wire b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15;		// Wires to hold XOR.
	wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16; // Wires to hold carry.
	
	// XOR each bit of inputB and mode.
	assign b0 = B[0] ^ M;
	assign b1 = B[1] ^ M;
	assign b2 = B[2] ^ M;
	assign b3 = B[3] ^ M;
	assign b4 = B[4] ^ M;
	assign b5 = B[5] ^ M;
	assign b6 = B[6] ^ M;
	assign b7 = B[7] ^ M;
	assign b8 = B[8] ^ M;
	assign b9 = B[9] ^ M;
	assign b10 = B[10] ^ M;
	assign b11 = B[11] ^ M;
	assign b12 = B[12] ^ M;
	assign b13 = B[13] ^ M;
	assign b14 = B[14] ^ M;
	assign b15 = B[15] ^ M;

	// Use FullAdder to calculate the sum.
	FullAdder FA0(A[0],b0,M,c1,S[0]);
	FullAdder FA1(A[1],b1,  c1,c2,S[1]);
	FullAdder FA2(A[2],b2,  c2,c3,S[2]);
	FullAdder FA3(A[3],b3,  c3,c4,S[3]);
	FullAdder FA4(A[4],b4,  c4,c5,S[4]);
	FullAdder FA5(A[5],b5,  c5,c6,S[5]);
	FullAdder FA6(A[6],b6,  c6,c7,S[6]);
	FullAdder FA7(A[7],b7,  c7,c8,S[7]);
	FullAdder FA8(A[8],b8,  c8,c9,S[8]);
	FullAdder FA9(A[9],b9,  c9,c10,S[9]);
	FullAdder FA10(A[10],b10, c10,c11,S[10]);
	FullAdder FA11(A[11],b11, c11,c12,S[11]);
	FullAdder FA13(A[12],b12, c12,c13,S[12]);
	FullAdder FA14(A[13],b13, c13,c14,S[13]);
	FullAdder FA15(A[14],b14, c14,c15,S[14]);
	FullAdder FA16(A[15],b15, c15,c16,S[15]);

	// c16 is the carry.
	assign C = c16;
	
	// If the mode is 0, overflow = c16.
	// If the mode is 1, overflow = c15 ^ c16.
	assign V = (M == 1'b0) ? c16 : (c15 ^ c16);
	
	// If overflow is 1, assign 1 to sum[16].
	// If overflow is 0, assign 0 to sum[16].
	assign S[16] = (V == 1'b1) ? 1'b1 : 1'b0;
	
	// Assign bit 0 to sum[17] to sum[31].
	assign S[17] = 1'b0;
	assign S[18] = 1'b0;
	assign S[19] = 1'b0;
	assign S[20] = 1'b0;
	assign S[21] = 1'b0;
	assign S[22] = 1'b0;
	assign S[23] = 1'b0;
	assign S[24] = 1'b0;
	assign S[25] = 1'b0;
	assign S[26] = 1'b0;
	assign S[27] = 1'b0;
	assign S[28] = 1'b0;
	assign S[29] = 1'b0;
	assign S[30] = 1'b0;
	assign S[31] = 1'b0;
 
endmodule

/*
	Multiplier performs multiplication.
	Multiplier takes 2 16-bit inputs and outputs 32-bit Result.
*/
module MULTIPLIER(A, B, P);
    input [15:0] A;
	input [15:0] B;
    output [31:0] P;
	wire [15:0] b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15; 	// Wires to hold ANDs of inputB and inputA
	wire [15:0] s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14;		// Wires to hold sum.
	wire [15:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13;			// Wires to hold shift.
	wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14;				// Wires to hold carry.
	output overflow;

	// product[0]	

	// product[0] = AND of the least significant bits of inputB and inputA.
	assign P[0] = B[0] & A[0];
	
	// Calculating product[1]

	// Assign AND of inputB and inputA[0] to b0.
	// Shift and assign 0 to b0[15].
	assign b0[0] = B[1] & A[0];
	assign b0[1] = B[2] & A[0];
	assign b0[2] = B[3] & A[0];
	assign b0[3] = B[4] & A[0];
	assign b0[4] = B[5] & A[0];
	assign b0[5] = B[6] & A[0];
	assign b0[6] = B[7] & A[0];
	assign b0[7] = B[8] & A[0];
	assign b0[8] = B[9] & A[0];
	assign b0[9] = B[10] & A[0];
	assign b0[10] = B[11] & A[0];
	assign b0[11] = B[12] & A[0];
	assign b0[12] = B[13] & A[0];
	assign b0[13] = B[14] & A[0];
	assign b0[14] = B[15] & A[0];
	assign b0[15] = 1'b0;
	
	// Assign AND of inputB and inputA[1] to b1
	assign b1[0] = B[0] & A[1];
	assign b1[1] = B[1] & A[1];
	assign b1[2] = B[2] & A[1];
	assign b1[3] = B[3] & A[1];
	assign b1[4] = B[4] & A[1];
	assign b1[5] = B[5] & A[1];
	assign b1[6] = B[6] & A[1];
	assign b1[7] = B[7] & A[1];
	assign b1[8] = B[8] & A[1];
	assign b1[9] = B[9] & A[1];
	assign b1[10] = B[10] & A[1];
	assign b1[11] = B[11] & A[1];
	assign b1[12] = B[12] & A[1];
	assign b1[13] = B[13] & A[1];
	assign b1[14] = B[14] & A[1];
	assign b1[15] = B[15] & A[1];
    
	// Assign the sum of b0 and b1 to s0.
	// c0 holds the carry.
	ADD_SUB AS1(b0,b1,1'b0,s0,c0,overflow);
	
	// Assign the least significant bit of the sum to product[1].
	assign P[1] = s0[0];
	
	// Calculating product[2]

    // Shift and assign the new values from s0 to w0.
	// Assign carry, c0, to the most significant bit of w0.
	assign w0[0] = s0[1];
	assign w0[1] = s0[2];
	assign w0[2] = s0[3];
	assign w0[3] = s0[4];
	assign w0[4] = s0[5];
	assign w0[5] = s0[6];
	assign w0[6] = s0[7];
	assign w0[7] = s0[8];
	assign w0[8] = s0[9];
	assign w0[9] = s0[10];
	assign w0[10] = s0[11];
	assign w0[11] = s0[12];
	assign w0[12] = s0[13];
	assign w0[13] = s0[14];
	assign w0[14] = s0[15];
	assign w0[15] = c0;
	
	// Assign AND of inputB and inputA[2] to b2.
	assign b2[0] = B[0] & A[2];
	assign b2[1] = B[1] & A[2];
	assign b2[2] = B[2] & A[2];
	assign b2[3] = B[3] & A[2];
	assign b2[4] = B[4] & A[2];
	assign b2[5] = B[5] & A[2];
	assign b2[6] = B[6] & A[2];
	assign b2[7] = B[7] & A[2];
	assign b2[8] = B[8] & A[2];
	assign b2[9] = B[9] & A[2];
	assign b2[10] = B[10] & A[2];
	assign b2[11] = B[11] & A[2];
	assign b2[12] = B[12] & A[2];
	assign b2[13] = B[13] & A[2];
	assign b2[14] = B[14] & A[2];
	assign b2[15] = B[15] & A[2];

	// Assign the sum of w0 and b2 to s1.
	// c1 holds the carry.
	ADD_SUB AS2(w0,b2,1'b0,s1,c1,overflow);
	
	// Assign the least significant bit of the sum to product[2].
	assign P[2] = s1[0];
	
	// Calculating product[3]
	
	// Shift and assign the new values from s1 to w1.
	// Assign carry, c1, to the most significant bit of w1.
	assign w1[0] = s1[1];
	assign w1[1] = s1[2];
	assign w1[2] = s1[3];
	assign w1[3] = s1[4];
	assign w1[4] = s1[5];
	assign w1[5] = s1[6];
	assign w1[6] = s1[7];
	assign w1[7] = s1[8];
	assign w1[8] = s1[9];
	assign w1[9] = s1[10];
	assign w1[10] = s1[11];
	assign w1[11] = s1[12];
	assign w1[12] = s1[13];
	assign w1[13] = s1[14];
	assign w1[14] = s1[15];
	assign w1[15] = c1;
	
	// Assign AND of inputB and inputA[3] to b3.
	assign b3[0] = B[0] & A[3];
	assign b3[1] = B[1] & A[3];
	assign b3[2] = B[2] & A[3];
	assign b3[3] = B[3] & A[3];
	assign b3[4] = B[4] & A[3];
	assign b3[5] = B[5] & A[3];
	assign b3[6] = B[6] & A[3];
	assign b3[7] = B[7] & A[3];
	assign b3[8] = B[8] & A[3];
	assign b3[9] = B[9] & A[3];
	assign b3[10] = B[10] & A[3];
	assign b3[11] = B[11] & A[3];
	assign b3[12] = B[12] & A[3];
	assign b3[13] = B[13] & A[3];
	assign b3[14] = B[14] & A[3];
	assign b3[15] = B[15] & A[3];
    
	// Assign the sum of w1 and b3 to s2.
	// c2 holds the carry.
	ADD_SUB AS3(w1,b3,1'b0,s2,c2,overflow);
	
	// Assign the least significant bit of the sum to product[3].
	assign P[3] = s2[0];
	
	// Calculating product[4]
	
	// Shift and assign the new values from s2 to w2.
	// Assign carry, c2, to the most significant bit of w2.
	assign w2[0] = s2[1];
	assign w2[1] = s2[2];
	assign w2[2] = s2[3];
	assign w2[3] = s2[4];
	assign w2[4] = s2[5];
	assign w2[5] = s2[6];
	assign w2[6] = s2[7];
	assign w2[7] = s2[8];
	assign w2[8] = s2[9];
	assign w2[9] = s2[10];
	assign w2[10] = s2[11];
	assign w2[11] = s2[12];
	assign w2[12] = s2[13];
	assign w2[13] = s2[14];
	assign w2[14] = s2[15];
	assign w2[15] = c2;
	
	// Assign AND of inputB and inputA[4] to b4.
	assign b4[0] = B[0] & A[4];
	assign b4[1] = B[1] & A[4];
	assign b4[2] = B[2] & A[4];
	assign b4[3] = B[3] & A[4];
	assign b4[4] = B[4] & A[4];
	assign b4[5] = B[5] & A[4];
	assign b4[6] = B[6] & A[4];
	assign b4[7] = B[7] & A[4];
	assign b4[8] = B[8] & A[4];
	assign b4[9] = B[9] & A[4];
	assign b4[10] = B[10] & A[4];
	assign b4[11] = B[11] & A[4];
	assign b4[12] = B[12] & A[4];
	assign b4[13] = B[13] & A[4];
	assign b4[14] = B[14] & A[4];
	assign b4[15] = B[15] & A[4];
    
	// Assign the sum of w2 and b4 to s3.
	// c3 holds the carry.
	ADD_SUB AS4(w2,b4,1'b0,s3,c3,overflow);
	
	// Assign the least significant bit of the sum to product[4].
	assign P[4] = s3[0];

	// Calculating product [5]

	// Shift and assign the new values from s3 to w3.
	// Assign carry, c3, to the most significant bit of w3.
	assign w3[0] = s3[1];
	assign w3[1] = s3[2];
	assign w3[2] = s3[3];
	assign w3[3] = s3[4];
	assign w3[4] = s3[5];
	assign w3[5] = s3[6];
	assign w3[6] = s3[7];
	assign w3[7] = s3[8];
	assign w3[8] = s3[9];
	assign w3[9] = s3[10];
	assign w3[10] = s3[11];
	assign w3[11] = s3[12];
	assign w3[12] = s3[13];
	assign w3[13] = s3[14];
	assign w3[14] = s3[15];
	assign w3[15] = c3;
	
	// Assign AND of inputB and inputA[5] to b5.
	assign b5[0] = B[0] & A[5];
	assign b5[1] = B[1] & A[5];
	assign b5[2] = B[2] & A[5];
	assign b5[3] = B[3] & A[5];
	assign b5[4] = B[4] & A[5];
	assign b5[5] = B[5] & A[5];
	assign b5[6] = B[6] & A[5];
	assign b5[7] = B[7] & A[5];
	assign b5[8] = B[8] & A[5];
	assign b5[9] = B[9] & A[5];
	assign b5[10] = B[10] & A[5];
	assign b5[11] = B[11] & A[5];
	assign b5[12] = B[12] & A[5];
	assign b5[13] = B[13] & A[5];
	assign b5[14] = B[14] & A[5];
	assign b5[15] = B[15] & A[5];
	
	// Assign the sum of w3 and b5 to s4.
	// c4 holds the carry.
	ADD_SUB AS5(w3,b5,1'b0,s4,c4,overflow);
	
	// Assign the least significant bit of the sum to product[5].
	assign P[5] = s4[0];
	
	// Calculating product [6]

	// Shift and assign the new values from s4 to w4.
	// Assign carry, c4, to the most significant bit of w4.
	assign w4[0] = s4[1];
	assign w4[1] = s4[2];
	assign w4[2] = s4[3];
	assign w4[3] = s4[4];
	assign w4[4] = s4[5];
	assign w4[5] = s4[6];
	assign w4[6] = s4[7];
	assign w4[7] = s4[8];
	assign w4[8] = s4[9];
	assign w4[9] = s4[10];
	assign w4[10] = s4[11];
	assign w4[11] = s4[12];
	assign w4[12] = s4[13];
	assign w4[13] = s4[14];
	assign w4[14] = s4[15];
	assign w4[15] = c4;
	
	// Assign AND of inputB and inputA[6] to b6.
	assign b6[0] = B[0] & A[6];
	assign b6[1] = B[1] & A[6];
	assign b6[2] = B[2] & A[6];
	assign b6[3] = B[3] & A[6];
	assign b6[4] = B[4] & A[6];
	assign b6[5] = B[5] & A[6];
	assign b6[6] = B[6] & A[6];
	assign b6[7] = B[7] & A[6];
	assign b6[8] = B[8] & A[6];
	assign b6[9] = B[9] & A[6];
	assign b6[10] = B[10] & A[6];
	assign b6[11] = B[11] & A[6];
	assign b6[12] = B[12] & A[6];
	assign b6[13] = B[13] & A[6];
	assign b6[14] = B[14] & A[6];
	assign b6[15] = B[15] & A[6];

	// Assign the sum of w4 and b6 to s5.
	// c5 holds the carry.
	ADD_SUB AS6(w4,b6,1'b0,s5,c5,overflow);
	
	// Assign the least significant bit of the sum to product[6].
	assign P[6] = s5[0];
	
	// Calculating product [7]

	// Shift and assign the new values from s5 to w5.
	// Assign carry, c5, to the most significant bit of w5.
	assign w5[0] = s5[1];
	assign w5[1] = s5[2];
	assign w5[2] = s5[3];
	assign w5[3] = s5[4];
	assign w5[4] = s5[5];
	assign w5[5] = s5[6];
	assign w5[6] = s5[7];
	assign w5[7] = s5[8];
	assign w5[8] = s5[9];
	assign w5[9] = s5[10];
	assign w5[10] = s5[11];
	assign w5[11] = s5[12];
	assign w5[12] = s5[13];
	assign w5[13] = s5[14];
	assign w5[14] = s5[15];
	assign w5[15] = c5;
	
	// Assign AND of inputB and inputA[7] to b7.
	assign b7[0] = B[0] & A[7];
	assign b7[1] = B[1] & A[7];
	assign b7[2] = B[2] & A[7];
	assign b7[3] = B[3] & A[7];
	assign b7[4] = B[4] & A[7];
	assign b7[5] = B[5] & A[7];
	assign b7[6] = B[6] & A[7];
	assign b7[7] = B[7] & A[7];
	assign b7[8] = B[8] & A[7];
	assign b7[9] = B[9] & A[7];
	assign b7[10] = B[10] & A[7];
	assign b7[11] = B[11] & A[7];
	assign b7[12] = B[12] & A[7];
	assign b7[13] = B[13] & A[7];
	assign b7[14] = B[14] & A[7];
	assign b7[15] = B[15] & A[7];

	// Assign the sum of w5 and b7 to s6.
	// c6 holds the carry.
	ADD_SUB AS7(w5,b7,1'b0,s6,c6,overflow);
	
	// Assign the least significant bit of the sum to product[7].
	assign P[7] = s6[0];
	
	// Calculating product [8]

	// Shift and assign the new values from s6 to w6.
	// Assign carry, c6, to the most significant bit of w6.
	assign w6[0] = s6[1];
	assign w6[1] = s6[2];
	assign w6[2] = s6[3];
	assign w6[3] = s6[4];
	assign w6[4] = s6[5];
	assign w6[5] = s6[6];
	assign w6[6] = s6[7];
	assign w6[7] = s6[8];
	assign w6[8] = s6[9];
	assign w6[9] = s6[10];
	assign w6[10] = s6[11];
	assign w6[11] = s6[12];
	assign w6[12] = s6[13];
	assign w6[13] = s6[14];
	assign w6[14] = s6[15];
	assign w6[15] = c6;
	
	// Assign AND of inputB and inputA[8] to b8.
	assign b8[0] = B[0] & A[8];
	assign b8[1] = B[1] & A[8];
	assign b8[2] = B[2] & A[8];
	assign b8[3] = B[3] & A[8];
	assign b8[4] = B[4] & A[8];
	assign b8[5] = B[5] & A[8];
	assign b8[6] = B[6] & A[8];
	assign b8[7] = B[7] & A[8];
	assign b8[8] = B[8] & A[8];
	assign b8[9] = B[9] & A[8];
	assign b8[10] = B[10] & A[8];
	assign b8[11] = B[11] & A[8];
	assign b8[12] = B[12] & A[8];
	assign b8[13] = B[13] & A[8];
	assign b8[14] = B[14] & A[8];
	assign b8[15] = B[15] & A[8];
    
	// Assign the sum of w6 and b8 to s7.
	// c7 holds the carry.
	ADD_SUB AS8(w6,b8,1'b0,s7,c7,overflow);
	
	// Assign the least significant bit of the sum to product[8].
	assign P[8] = s7[0];
	
	// Calculating product [9]

	// Shift and assign the new values from s7 to w7.
	// Assign carry, c7, to the most significant bit of w7.
	assign w7[0] = s7[1];
	assign w7[1] = s7[2];
	assign w7[2] = s7[3];
	assign w7[3] = s7[4];
	assign w7[4] = s7[5];
	assign w7[5] = s7[6];
	assign w7[6] = s7[7];
	assign w7[7] = s7[8];
	assign w7[8] = s7[9];
	assign w7[9] = s7[10];
	assign w7[10] = s7[11];
	assign w7[11] = s7[12];
	assign w7[12] = s7[13];
	assign w7[13] = s7[14];
	assign w7[14] = s7[15];
	assign w7[15] = c7;
	
	// Assign AND of inputB and inputA[9] to b9.
	assign b9[0] = B[0] & A[9];
	assign b9[1] = B[1] & A[9];
	assign b9[2] = B[2] & A[9];
	assign b9[3] = B[3] & A[9];
	assign b9[4] = B[4] & A[9];
	assign b9[5] = B[5] & A[9];
	assign b9[6] = B[6] & A[9];
	assign b9[7] = B[7] & A[9];
	assign b9[8] = B[8] & A[9];
	assign b9[9] = B[9] & A[9];
	assign b9[10] = B[10] & A[9];
	assign b9[11] = B[11] & A[9];
	assign b9[12] = B[12] & A[9];
	assign b9[13] = B[13] & A[9];
	assign b9[14] = B[14] & A[9];
	assign b9[15] = B[15] & A[9];

	// Assign the sum of w7 and b9 to s8.
	// c8 holds the carry.
	ADD_SUB AS9(w7,b9,1'b0,s8,c8,overflow);
	
	// Assign the least significant bit of the sum to product[9].
	assign P[9] = s8[0];
	
	// Calculating product [10]

	// Shift and assign the new values from s8 to w8.
	// Assign carry, c8, to the most significant bit of w8.
	assign w8[0] = s8[1];
	assign w8[1] = s8[2];
	assign w8[2] = s8[3];
	assign w8[3] = s8[4];
	assign w8[4] = s8[5];
	assign w8[5] = s8[6];
	assign w8[6] = s8[7];
	assign w8[7] = s8[8];
	assign w8[8] = s8[9];
	assign w8[9] = s8[10];
	assign w8[10] = s8[11];
	assign w8[11] = s8[12];
	assign w8[12] = s8[13];
	assign w8[13] = s8[14];
	assign w8[14] = s8[15];
	assign w8[15] = c8;
	
	// Assign AND of inputB and inputA[10] to b10.
	assign b10[0] = B[0] & A[10];
	assign b10[1] = B[1] & A[10];
	assign b10[2] = B[2] & A[10];
	assign b10[3] = B[3] & A[10];
	assign b10[4] = B[4] & A[10];
	assign b10[5] = B[5] & A[10];
	assign b10[6] = B[6] & A[10];
	assign b10[7] = B[7] & A[10];
	assign b10[8] = B[8] & A[10];
	assign b10[9] = B[9] & A[10];
	assign b10[10] = B[10] & A[10];
	assign b10[11] = B[11] & A[10];
	assign b10[12] = B[12] & A[10];
	assign b10[13] = B[13] & A[10];
	assign b10[14] = B[14] & A[10];
	assign b10[15] = B[15] & A[10];
    
	// Assign the sum of w8 and b10 to s9.
	// c9 holds the carry.
	ADD_SUB AS10(w8,b10,1'b0,s9,c9,overflow);
	
	// Assign the least significant bit of the sum to product[10].
	assign P[10] = s9[0];
	
	
	// Calculating product [11]

	// Shift and assign the new values from s9 to w9.
	// Assign carry, c9, to the most significant bit of w9.
	assign w9[0] = s9[1];
	assign w9[1] = s9[2];
	assign w9[2] = s9[3];
	assign w9[3] = s9[4];
	assign w9[4] = s9[5];
	assign w9[5] = s9[6];
	assign w9[6] = s9[7];
	assign w9[7] = s9[8];
	assign w9[8] = s9[9];
	assign w9[9] = s9[10];
	assign w9[10] = s9[11];
	assign w9[11] = s9[12];
	assign w9[12] = s9[13];
	assign w9[13] = s9[14];
	assign w9[14] = s9[15];
	assign w9[15] = c9;
	
	// Assign AND of inputB and inputA[11] to b11.
	assign b11[0] = B[0] & A[11];
	assign b11[1] = B[1] & A[11];
	assign b11[2] = B[2] & A[11];
	assign b11[3] = B[3] & A[11];
	assign b11[4] = B[4] & A[11];
	assign b11[5] = B[5] & A[11];
	assign b11[6] = B[6] & A[11];
	assign b11[7] = B[7] & A[11];
	assign b11[8] = B[8] & A[11];
	assign b11[9] = B[9] & A[11];
	assign b11[10] = B[10] & A[11];
	assign b11[11] = B[11] & A[11];
	assign b11[12] = B[12] & A[11];
	assign b11[13] = B[13] & A[11];
	assign b11[14] = B[14] & A[11];
	assign b11[15] = B[15] & A[11];

	// Assign the sum of w9 and b11 to s10.
	// c10 holds the carry.
	ADD_SUB AS11(w9,b11,1'b0,s10,c10,overflow);
	
	// Assign the least significant bit of the sum to product[11].
	assign P[11] = s10[0];
	
	// Calculating product [12]

	// Shift and assign the new values from s10 to w10.
	// Assign carry, c10, to the most significant bit of w10.
	assign w10[0] = s10[1];
	assign w10[1] = s10[2];
	assign w10[2] = s10[3];
	assign w10[3] = s10[4];
	assign w10[4] = s10[5];
	assign w10[5] = s10[6];
	assign w10[6] = s10[7];
	assign w10[7] = s10[8];
	assign w10[8] = s10[9];
	assign w10[9] = s10[10];
	assign w10[10] = s10[11];
	assign w10[11] = s10[12];
	assign w10[12] = s10[13];
	assign w10[13] = s10[14];
	assign w10[14] = s10[15];
	assign w10[15] = c10;
	
	// Assign AND of inputB and inputA[12] to b12.
	assign b12[0] = B[0] & A[12];
	assign b12[1] = B[1] & A[12];
	assign b12[2] = B[2] & A[12];
	assign b12[3] = B[3] & A[12];
	assign b12[4] = B[4] & A[12];
	assign b12[5] = B[5] & A[12];
	assign b12[6] = B[6] & A[12];
	assign b12[7] = B[7] & A[12];
	assign b12[8] = B[8] & A[12];
	assign b12[9] = B[9] & A[12];
	assign b12[10] = B[10] & A[12];
	assign b12[11] = B[11] & A[12];
	assign b12[12] = B[12] & A[12];
	assign b12[13] = B[13] & A[12];
	assign b12[14] = B[14] & A[12];
	assign b12[15] = B[15] & A[12];

	// Assign the sum of w10 and b12 to s11.
	// c11 holds the carry.
    ADD_SUB AS12(w10,b12,1'b0,s11,c11,overflow);
	
	// Assign the least significant bit of the sum to product[12].
	assign P[12] = s11[0];
	
	// Calculating product [13]

	// Shift and assign the new values from s11 to w11.
	// Assign carry, c11, to the most significant bit of w11.
	assign w11[0] = s11[1];
	assign w11[1] = s11[2];
	assign w11[2] = s11[3];
	assign w11[3] = s11[4];
	assign w11[4] = s11[5];
	assign w11[5] = s11[6];
	assign w11[6] = s11[7];
	assign w11[7] = s11[8];
	assign w11[8] = s11[9];
	assign w11[9] = s11[10];
	assign w11[10] = s11[11];
	assign w11[11] = s11[12];
	assign w11[12] = s11[13];
	assign w11[13] = s11[14];
	assign w11[14] = s11[15];
	assign w11[15] = c11;
	
	// Assign AND of inputB and inputA[13] to b13.
	assign b13[0] = B[0] & A[13];
	assign b13[1] = B[1] & A[13];
	assign b13[2] = B[2] & A[13];
	assign b13[3] = B[3] & A[13];
	assign b13[4] = B[4] & A[13];
	assign b13[5] = B[5] & A[13];
	assign b13[6] = B[6] & A[13];
	assign b13[7] = B[7] & A[13];
	assign b13[8] = B[8] & A[13];
	assign b13[9] = B[9] & A[13];
	assign b13[10] = B[10] & A[13];
	assign b13[11] = B[11] & A[13];
	assign b13[12] = B[12] & A[13];
	assign b13[13] = B[13] & A[13];
	assign b13[14] = B[14] & A[13];
	assign b13[15] = B[15] & A[13];

	// Assign the sum of w11 and b13 to s12.
	// c12 holds the carry.
	ADD_SUB AS13(w11,b13,1'b0,s12,c12,overflow);
	
	// Assign the least significant bit of the sum to product[13].
	assign P[13] = s12[0];
	
	// Calculating product [14]

	// Shift and assign the new values from s12 to w12.
	// Assign carry, c12, to the most significant bit of w12.
	assign w12[0] = s12[1];
	assign w12[1] = s12[2];
	assign w12[2] = s12[3];
	assign w12[3] = s12[4];
	assign w12[4] = s12[5];
	assign w12[5] = s12[6];
	assign w12[6] = s12[7];
	assign w12[7] = s12[8];
	assign w12[8] = s12[9];
	assign w12[9] = s12[10];
	assign w12[10] = s12[11];
	assign w12[11] = s12[12];
	assign w12[12] = s12[13];
	assign w12[13] = s12[14];
	assign w12[14] = s12[15];
	assign w12[15] = c12;
	
	// Assign AND of inputB and inputA[14] to b14.
	assign b14[0] = B[0] & A[14];
	assign b14[1] = B[1] & A[14];
	assign b14[2] = B[2] & A[14];
	assign b14[3] = B[3] & A[14];
	assign b14[4] = B[4] & A[14];
	assign b14[5] = B[5] & A[14];
	assign b14[6] = B[6] & A[14];
	assign b14[7] = B[7] & A[14];
	assign b14[8] = B[8] & A[14];
	assign b14[9] = B[9] & A[14];
	assign b14[10] = B[10] & A[14];
	assign b14[11] = B[11] & A[14];
	assign b14[12] = B[12] & A[14];
	assign b14[13] = B[13] & A[14];
	assign b14[14] = B[14] & A[14];
	assign b14[15] = B[15] & A[14];

	// Assign the sum of w12 and b14 to s13.
	// c13 holds the carry.
	ADD_SUB AS14(w12,b14,1'b0,s13,c13,overflow);
	
	// Assign the least significant bit of the sum to product[14].
	assign P[14] = s13[0];
	
	// Calculating product [15]

	// Shift and assign the new values from s13 to w13.
	// Assign carry, c13, to the most significant bit of w13.
	assign w13[0] = s13[1];
	assign w13[1] = s13[2];
	assign w13[2] = s13[3];
	assign w13[3] = s13[4];
	assign w13[4] = s13[5];
	assign w13[5] = s13[6];
	assign w13[6] = s13[7];
	assign w13[7] = s13[8];
	assign w13[8] = s13[9];
	assign w13[9] = s13[10];
	assign w13[10] = s13[11];
	assign w13[11] = s13[12];
	assign w13[12] = s13[13];
	assign w13[13] = s13[14];
	assign w13[14] = s13[15];
	assign w13[15] = c13;
	
	// Assign AND of inputB and inputA[15] to b15.
	assign b15[0] = B[0] & A[15];
	assign b15[1] = B[1] & A[15];
	assign b15[2] = B[2] & A[15];
	assign b15[3] = B[3] & A[15];
	assign b15[4] = B[4] & A[15];
	assign b15[5] = B[5] & A[15];
	assign b15[6] = B[6] & A[15];
	assign b15[7] = B[7] & A[15];
	assign b15[8] = B[8] & A[15];
	assign b15[9] = B[9] & A[15];
	assign b15[10] = B[10] & A[15];
	assign b15[11] = B[11] & A[15];
	assign b15[12] = B[12] & A[15];
	assign b15[13] = B[13] & A[15];
	assign b15[14] = B[14] & A[15];
	assign b15[15] = B[15] & A[15];

	// Assign the sum of w13 and b15 to s14.
	// c14 holds the carry.
	ADD_SUB AS15(w13,b15,1'b0,s14,c14,overflow);
	
	// Assign each bit of s14 to product[15] to product[30].
	assign P[15] = s14[0];
	assign P[16] = s14[1];
	assign P[17] = s14[2];
	assign P[18] = s14[3];
	assign P[19] = s14[4];
	assign P[20] = s14[5];
	assign P[21] = s14[6];
	assign P[22] = s14[7];
	assign P[23] = s14[8];
	assign P[24] = s14[9];
	assign P[25] = s14[10];
	assign P[26] = s14[11];
	assign P[27] = s14[12];
	assign P[28] = s14[13];
	assign P[29] = s14[14];
	assign P[30] = s14[15];
	
	// Assign the last carry to product[31].
	assign P[31] = c14;

endmodule

/*
	Divider divides inputA / inputB.
	Divider takes 2 16-bit inputs and outputs 32-bit Result.
	The module also outputs divideZero where it holds 1 when inputB is 0.
*/
module DIVIDER(A,B,Q,divideZero);
    input [15:0] A;
	input [15:0] B;
    output [31:0] Q;
	output divideZero;

	// If the inputB is 0, assign value x to the quotient.
	// If the inputB is not 0, perform inputA / inputB.
	assign Q = (B == 16'b0) ? 1'bx : (A / B);
	
	// If the inputB is 0, assign 1 to divideZero.
	// Else, assign 0 to divideZero.
	assign divideZero = (B == 16'b0) ? 1'b1 : 1'b0;
	
endmodule

/*
	Modulo mods inputA % inputB.
	Modulo takes 2 16-bit inputs and outputs 32-bit Result.
	The module also outputs moduloZero where it holds 1 when inputB is 0.
*/
module MODULO(A,B,R,moduloZero);
    input [15:0] A;
	input [15:0] B;
    output [31:0] R;
	output moduloZero;
	
	// If the inputB is 0, assign value x to the remainder.
	// If the inputB is not 0, perform inputA % inputB.
	assign R = (B == 16'b0) ? 1'bx : (A % B);
	
	// If the inputB is 0, assign 1 to moduloZero.
	// Else, assign 0 to moduloZero.
	assign moduloZero = (B == 16'b0) ? 1'b1 : 1'b0;
	
endmodule

/*
	DEC is 4x16 DECoder that takes 4-bit inputs and outputs 16-bit onehot select.
*/
module DEC(op,onehot);
	input [3:0] op;
	output [15:0]onehot;
	
	assign onehot[ 0]=~op[3]&~op[2]&~op[1]&~op[0];
	assign onehot[ 1]=~op[3]&~op[2]&~op[1]& op[0];
	assign onehot[ 2]=~op[3]&~op[2]& op[1]&~op[0];
	assign onehot[ 3]=~op[3]&~op[2]& op[1]& op[0];
	assign onehot[ 4]=~op[3]& op[2]&~op[1]&~op[0];
	assign onehot[ 5]=~op[3]& op[2]&~op[1]& op[0];
	assign onehot[ 6]=~op[3]& op[2]& op[1]&~op[0];
	assign onehot[ 7]=~op[3]& op[2]& op[1]& op[0];
	assign onehot[ 8]= op[3]&~op[2]&~op[1]&~op[0];
	assign onehot[ 9]= op[3]&~op[2]&~op[1]& op[0];
	assign onehot[10]= op[3]&~op[2]& op[1]&~op[0];
	assign onehot[11]= op[3]&~op[2]& op[1]& op[0];
	assign onehot[12]= op[3]& op[2]&~op[1]&~op[0];
	assign onehot[13]= op[3]& op[2]&~op[1]& op[0];
	assign onehot[14]= op[3]& op[2]& op[1]&~op[0];
	assign onehot[15]= op[3]& op[2]& op[1]& op[0];
	
endmodule

/*
	MUX is 16x32 multipliexer with onehot select.
	It has 16 channels where channel input is 32-bit.
*/
module MUX(channels,select,b);
	input [15:0][31:0]channels;
	input       [15:0] select;
	output      [31:0] b;

	assign b = ({32{select[15]}} & channels[15]) | 
		({32{select[14]}} & channels[14]) |
		({32{select[13]}} & channels[13]) |
		({32{select[12]}} & channels[12]) |
		({32{select[11]}} & channels[11]) |
		({32{select[10]}} & channels[10]) |
		({32{select[ 9]}} & channels[ 9]) |
		({32{select[ 8]}} & channels[ 8]) |
		({32{select[ 7]}} & channels[ 7]) |
		({32{select[ 6]}} & channels[ 6]) |
		({32{select[ 5]}} & channels[ 5]) |
		({32{select[ 4]}} & channels[ 4]) |
		({32{select[ 3]}} & channels[ 3]) |
		({32{select[ 2]}} & channels[ 2]) | 
		({32{select[ 1]}} & channels[ 1]) |
		({32{select[ 0]}} & channels[ 0]) ;
endmodule


module BreadBoard(A, B, Op, Result, Error);
	input [15:0] A;
	input [15:0] B;
	input [3:0] Op;
	output [31:0] Result;
	output [1:0] Error;

	reg [31:0] Result;
	reg [1:0] Error;

	// Full Adder
	reg M;
	wire [31:0] S;
	wire C;
	wire V;

	// Multiplier
	wire [31:0] P;

	// Divider
	wire [31:0] Q;
	wire divideZero;

	// Modulo
	wire [31:0] R;
	wire moduloZero;

	//Multiplexer
	wire [15:0][31:0] channels;
	wire [15:0] onehot;
	wire [31:0] b;

	// DECoder
	DEC DEC(Op,onehot);

	// AddSub
	ADD_SUB add_sub(A, B, M, S, C, V);

	// Multiplier
	MULTIPLIER multiplier(A, B, P);

	// Dider
	DIVIDER divider(A, B, Q, divideZero);

	// Modulo
	MODULO mod(A, B, R, moduloZero);

	// Multiplexer
	MUX Mux(channels,onehot,b);

	assign channels[ 0]= 0;			// GROUND=0
	assign channels[ 1]= 0;			// GROUND=0
	assign channels[ 2]= P; 		// Multiplication
	assign channels[ 3]= Q; 		// Divider
	assign channels[ 4]= R; 		// Modulo
	assign channels[ 5]= 0;			// GROUND=0
	assign channels[ 6]= 0;			// GROUND=0
	assign channels[ 7]= 0;			// GROUND=0
	assign channels[ 8]= 0;			// GROUND=0
	assign channels[ 9]= 0;			// GROUND=0
	assign channels[10]= S;			// Addition
	assign channels[11]= S;			// Subtraction
	assign channels[12]= 0;			// GROUND=0
	assign channels[13]= 0;			// GROUND=0
	assign channels[14]= 0;			// GROUND=0
	assign channels[15]= 0;			// GROUND=0

	always @(*)  
	begin
	 M = Op[0];									// mode is 1 when op[0] is 1.
	 Result = b;								// Assign b to Result.
	 Error[1] = divideZero | moduloZero;		// The most significant bit holds divideZero error.
	 Error[0] = V;								// The least significant bit holds overflow error.
	 end

endmodule

module TestBench();
    reg [15:0] inputA;	// less than 250
    reg [15:0] inputB;	// less than 250
    reg [3:0] Op;
    wire [31:0] Result;
    wire [1:0] Error;
	
    BreadBoard BB250(inputA, inputB, Op, Result, Error);
  
    initial begin
	
	// Inputs less than 250
    assign inputA  = 16'b0000000010110100; // 180
	assign inputB  = 16'b0000000001111111; // 127
	
	assign Op = 4'b1010;
	#10;
	$display("[Input A: %d, Input B: %d][Add:1010][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign Op = 4'b1011;
	#10;
	$display("[Input A: %d, Input B: %d][Sub:1011][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign Op = 4'b0010;
	#10
	$display("[Input A: %d, Input B: %d][Mul:0010][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign Op = 4'b0011;
	#10;
	$display("[Input A: %d, Input B: %d][Div:0011][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign inputB  = 16'b0000000000000000;
	assign Op = 4'b0100;
	#10;
	$display("[Input A: %d, Input B: %d][Mod:0100][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	
	// Inputs greater than 
	assign inputA = 16'b0111110100000000; //32,000
	assign inputB = 16'b0011111010000000; // 16,000
	
	assign Op = 4'b1010;
	#10;
	$display("[Input A: %d, Input B: %d][Add:1010][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign Op = 4'b1011;
	#10;
	$display("[Input A: %d, Input B: %d][Sub:1011][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign Op = 4'b0010;
	#10
	$display("[Input A: %d, Input B: %d][Mul:0010][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign Op = 4'b0011;
	#10;
	$display("[Input A: %d, Input B: %d][Div:0011][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	assign Op = 4'b0100;
	#10;
	$display("[Input A: %d, Input B: %d][Mod:0100][Output: %d, Error: %b]", inputA, inputB, Result, Error);
	
	end
endmodule
