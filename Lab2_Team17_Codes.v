`timescale 1ns/10ps

module Q1_4_bit_Comparator(A_lt_B, A_gt_B, A_eq_B, A, B);
	output A_lt_B, A_gt_B, A_eq_B;
    input[3:0] A, B;
    //Code
    assign A_gt_B = (A > B);
    assign A_lt_B = (A < B);
    assign A_eq_B = (A == B);

endmodule

module Q2_Binary_to_Grey(Dout, Din);
	output	[3:0] Dout;
	input	[3:0] Din;
	//Code
	wire t0, t1, t2, t3, t4, t5;
	assign Dout[3] = Din[3];
	assign t0 = ~Din[2] & Din[3];
	assign t1 = Din[2] & ~Din[3];
	assign Dout[2] = t0 | t1;
	assign t2 = ~Din[1] & Din[2];
	assign t3 = Din[1] & ~Din[2];
	assign Dout[1] = t2 | t3;
	assign t4 = ~Din[0] & Din[1];
	assign t5 = Din[0] & ~Din[1];
	assign Dout[0] = t4 | t5;
	
endmodule

module Q3_Decode_and_Execute(Rd, Op_code, Rs, Rt);
	output	[3:0] Rd;
	input	[3:0] Rs, Rt;
	input	[2:0] Op_code;
	//Code
	wire Rs_lt_Rt, Rs_gt_Rt, Rs_eq_Rt;
    reg NC_in = 1,C_in = 0;
    wire C_out, NC_out;
    //reg [2:0]    Op;
    wire [2:0] w;
    wire [2:0] v;
    Q1_4_bit_Comparator Com1(Rs_lt_Rt, Rs_gt_Rt, Rs_eq_Rt, Rs, Rt);
    wire [3:0] nRt;
    reg [3:0] temp, t0, t1, t2, t3;
    assign nRt[3] = ~Rt[3];
    assign nRt[2] = ~Rt[2];
    assign nRt[1] = ~Rt[1];
    assign nRt[0] = ~Rt[0];
    wire[7:0] ans;
    wire [7:0] bns;
    reg [3:0] Rd;
    FullAdder sub0(ans[0], v[0], NC_in, Rs[0], nRt[0]);
    FullAdder sub1(ans[1], v[1], v[0], Rs[1], nRt[1]);
    FullAdder sub2(ans[2], v[2], v[1], Rs[2], nRt[2]);
    FullAdder sub3(ans[3], NC_out, v[2], Rs[3], nRt[3]);
    FullAdder add0(ans[4], w[0], C_in, Rs[0], Rt[0]);
    FullAdder add1(ans[5], w[1], w[0], Rs[1], Rt[1]);
    FullAdder add2(ans[6], w[2], w[1], Rs[2], Rt[2]);
    FullAdder add3(ans[7], C_out, w[2], Rs[3], Rt[3]);
    nand nand1(bns[0], Rs[0], Rt[0]);
    nand nand2(bns[1], Rs[1], Rt[1]);
    nand nand3(bns[2], Rs[2], Rt[2]);
    nand nand4(bns[3], Rs[3], Rt[3]);
    nor nor1(bns[4], Rs[0], Rt[0]);
    nor nor2(bns[5], Rs[1], Rt[1]);
    nor nor3(bns[6], Rs[2], Rt[2]);
    nor nor4(bns[7], Rs[3], Rt[3]);

    always @* begin
    
    if (Op_code == 3'b000)
        begin
        if(Rs_gt_Rt == 1'b1)
            begin
                 Rd[3] = ans[3];
                 Rd[2] = ans[2];
                 Rd[1] = ans[1];
                 Rd[0] = ans[0];
            end
        else
             Rd = 4'b0;
        end
     else if(Op_code == 3'b001)
        begin
         Rd[3] = ans[7];
         Rd[2] = ans[6];
         Rd[1] = ans[5];
         Rd[0] = ans[4];

        end
    else if (Op_code == 3'b010)
        begin
         t0 = (Rt[0] == 1) ? Rs : 4'b0;
         t1 = (Rt[1] == 1) ? Rs : 4'b0;
         t2 = (Rt[2] == 1) ? Rs : 4'b0;
         t3 = (Rt[3] == 1) ? Rs : 4'b0;
         temp = t0 + (t1<<1) + (t2<<2) + (t3<<3);
         Rd[0] = temp[0];
         Rd[1] = temp[1];
         Rd[2] = temp[2];
         Rd[3] = temp[3];
        end
    else if (Op_code == 3'b011)
        begin
         Rd[3] = bns[3];
         Rd[2] = bns[2];
         Rd[1] = bns[1];
         Rd[0] = bns[0];

        end
    else if (Op_code == 3'b100)
        begin
         Rd[3] = bns[7];
         Rd[2] = bns[6];
         Rd[1] = bns[5];
         Rd[0] = bns[4];

        end
    else if (Op_code == 3'b101)
        begin
        if (Rt == 4'b0)
            begin
             Rd[3] = Rs[3];
             Rd[2] = Rs[2];
             Rd[1] = Rs[1];
             Rd[0] = Rs[0];
            end
        else if (Rt == 4'b0001)
            begin
             Rd[3] = Rs[2];
             Rd[2] = Rs[1];
             Rd[1] = Rs[0];
             Rd[0] = 0;
            end
        else if (Rt == 4'b0010)
            begin
             Rd[3] = Rs[1];
             Rd[2] = Rs[0];
             Rd[1] = 0;
             Rd[0] = 0;
            end
        else if (Rt == 4'b0011)
            begin
             Rd[3] = Rs[0];
             Rd[2] = 0;
             Rd[1] = 0;
             Rd[0] = 0;
            end
        else 
            begin
             Rd[3] = 0;
             Rd[2] = 0;
             Rd[1] = 0;
             Rd[0] = 0;
            end
        end
    else if (Op_code == 3'b110)
        begin
        if (Rt == 4'b0)
            begin
             Rd[3] = Rs[3];
             Rd[2] = Rs[2];
             Rd[1] = Rs[1];
             Rd[0] = Rs[0];
            end
        else if (Rt == 4'b0001)
            begin
             Rd[3] = 0;
             Rd[2] = Rs[3];
             Rd[1] = Rs[2];
             Rd[0] = Rs[1];
            end
        else if (Rt == 4'b0010)
            begin
             Rd[3] = 0;
             Rd[2] = 0;
             Rd[1] = Rs[3];
             Rd[0] = Rs[2];
            end
        else if (Rt == 4'b0011)
            begin
             Rd[3] = 0;
             Rd[2] = 0;
             Rd[1] = 0;
             Rd[0] = Rs[3];
            end
        else 
            begin
             Rd[3] = 0;
             Rd[2] = 0;
             Rd[1] = 0;
             Rd[0] = 0;
            end
        end
    else
        begin 
        if(Rs_eq_Rt == 1)
        Rd = Rs;
        else
        Rd = Rt;
        end
    end
endmodule

module Q4_NAND_Implement(Out, A, B, Sel);
	output 	Out;
	input 	A, B;
	input	[2:0] Sel;
	//Cdoe
	wire [12:0] w;
	wire [7:0]  w_mux;
	nand nand1(w[0], A, A);
	nand nand2(w[1], B, B);
	nand nand3(w[2], w[0], w[1]);
	nand nand4(w[3], w[2], w[2]);
	nand nand5(w[4], A, B);
	nand nand6(w[5], w[4], w[4]);
	nand nand7(w[6], A, w[4]);
	nand nand8(w[7], B, w[4]);
	nand nand9(w[8], w[6], w[7]);
	nand nand10(w[9], w[8], w[8]);
	nand nand11(w[10], Sel[0], Sel[0]);
	nand nand12(w[11], Sel[1], Sel[1]);
	nand nand13(w[12], Sel[2], Sel[2]);
	nand nand000(w_mux[0], w[0], w[12], w[11], w[10]);
	nand nand001(w_mux[1], w[3], w[12], w[11], Sel[0]);
	nand nand010(w_mux[2], w[5], w[12], Sel[1], w[10]);
	nand nand011(w_mux[3], w[2], w[12], Sel[1], Sel[0]);
	nand nand100(w_mux[4], w[8], Sel[2], w[11], w[10]);
	nand nand101(w_mux[5], w[9], Sel[2], w[11], Sel[0]);
	nand nand110(w_mux[6], w[4], Sel[2], Sel[1], w[10]);
	nand nand111(w_mux[7], w[4], Sel[2], Sel[1], Sel[0]);
	nand nand0(Out, w_mux[0], w_mux[1], w_mux[2], w_mux[3], w_mux[4], w_mux[5], w_mux[6], w_mux[7]);
	
endmodule

module Q5_NOR_Implement(Out, A, B, Sel);
	output 	Out;
	input 	A, B;
	input 	[2:0] Sel;
	//Code
	wire [10:0] w;
    wire [7:0]  w_mux;
    wire        out1;
    nor nor1(w[0], A, A);
    nor nor2(w[1], B, B);
    nor nor3(w[2], w[0], w[1]);
    nor nor4(w[3], w[2], w[2]);
    nor nor5(w[4], A, B);
    nor nor6(w[5], w[2], w[4]);
    nor nor7(w[6], w[5], w[5]);
    nor nor8(w[7], w[4], w[4]);
    nor nor9(w[8], Sel[0], Sel[0]);
    nor nor10(w[9], Sel[1], Sel[1]);
    nor nor11(w[10], Sel[2], Sel[2]);
    nor nor000(w_mux[0], A, Sel[2], Sel[1], Sel[0]);
    nor nor001(w_mux[1], w[2], Sel[2], Sel[1], w[8]);
    nor nor010(w_mux[2], w[3], Sel[2], w[9], Sel[0]);
    nor nor011(w_mux[3], w[4], Sel[2], w[9], w[8]);
    nor nor100(w_mux[4], w[6], w[10], Sel[1], Sel[0]);
    nor nor101(w_mux[5], w[5], w[10], Sel[1], w[8]);
    nor nor110(w_mux[6], w[7], w[10], w[9], Sel[0]);
    nor nor111(w_mux[7], w[7], w[10], w[9], w[8]);
    nor nor0(out1, w_mux[0], w_mux[1], w_mux[2], w_mux[3], w_mux[4], w_mux[5], w_mux[6], w_mux[7]);
    nor nor01(Out, out1, out1);
	
endmodule

module Q6_Latch(Q, D, clk);
	output	Q;
	input	D, clk;
	//Code
	wire       n_D;
	wire [2:0] w;
	not not0(n_D, D);
	nand nand0(w[0], D, clk);
	nand nand1(w[1], n_D, clk);
	nand nand2(Q, w[0], w[2]);    
	nand nand3(w[2], w[1], Q);
	
endmodule

module Q6_FlipFlop(Q, D, clk);
	output	Q;
	input	D, clk;
	//Code
	wire w;
	Q6_Latch Q6_ML(w, D, clk);
    Q6_Latch Q6_SL(Q, w, ~clk);

endmodule


module FullAdder(Sum, C_out, C_in, A, B);
    output Sum, C_out;
    input  C_in, A, B;
    wire xor_w, w1, w2;
    xor xor1 (xor_w, A, B) ;
    xor xor2 (Sum, xor_w, C_in);
    and and1(w1, C_in, xor_w);
    and and2(w2, A, B);
    or or1(C_out, w1, w2);
endmodule

module FullAdder_CLA(S, P, G, C_in, A, B);
    output S, P, G;
    input  C_in, A, B;
    assign S = A ^ B ^ C_in;
    assign P = A ^ B;
    assign G = A & B;
endmodule

module OQ1_4_bits_CLA(C_out, S, C_in, A, B);
	output	C_out;
	output	[3:0] S;
	input 	C_in;
	input	[3:0] A, B;
	//Code
    wire [3:0] P, G;
    wire [2:0] C;
    wire [9:0] w;
    FullAdder_CLA FA1(S[0], P[0], G[0], C_in ,A[0], B[0]);
    FullAdder_CLA FA2(S[1], P[1], G[1], C[0] ,A[1], B[1]);
    FullAdder_CLA FA3(S[2], P[2], G[2], C[1] ,A[2], B[2]);
    FullAdder_CLA FA4(S[3], P[3], G[3], C[2] ,A[3], B[3]);
    and and0(w[0], C_in, P[0]);
    or or0(C[0], G[0], w[0]);
    and and10(w[1], G[0], P[1]);
    and and11(w[2], C_in, P[0], P[1]);
    or or1(C[1], G[1], w[1], w[2]);
    and and20(w[3], G[1], P[2]);
    and and21(w[4], G[0], P[1], P[2]);
    and and22(w[5], C_in, P[0], P[1], P[2]);
    or or2(C[2], G[2], w[3], w[4], w[5]);
    and and30(w[6], G[2], P[3]);
    and and31(w[7], G[1], P[2], P[3]);
    and and32(w[8], G[0], P[1], P[2], P[3]);
    and and33(w[9], C_in, P[0], P[1], P[2], P[3]);
    or or3(C_out, G[3], w[6], w[7], w[8], w[9]);
endmodule

module OQ2_4bit_Multiplier(P, A, B);
	output	[7:0] P;
	input	[3:0] A, B;
	//Code
	wire	[39:0] w;
	and a1(w[0], A[0], B[0]);
    and a2(w[1], A[1], B[0]);
    and a3(w[2], A[2], B[0]);
    and a4(w[3], A[3], B[0]);
    and a5(w[4], A[0], B[1]);
    and a6(w[5], A[1], B[1]);
    and a7(w[6], A[2], B[1]);
    and a8(w[7], A[3], B[1]);
    and a9(w[8], A[0], B[2]);
    and a10(w[9], A[1], B[2]);
    and a11(w[10], A[2], B[2]);
    and a12(w[11], A[3], B[2]);
    and a13(w[12], A[0], B[3]);
    and a14(w[13], A[1], B[3]);
    and a15(w[14], A[2], B[3]);
    and a16(w[15], A[3], B[3]);
//FullAdder(Sum, C_out, C_in, A, B);
    FullAdder Fa1(w[16], w[17], w[4], 1'b0, w[1]);
    FullAdder Fa2(w[18], w[19], w[5], 1'b0, w[2]);
    FullAdder Fa3(w[20], w[21], w[6], 1'b0, w[3]);
    FullAdder Fa4(w[22], w[23], w[18], w[8], w[17]);
    FullAdder Fa5(w[24], w[25], w[20], w[9], w[19]);
    FullAdder Fa6(w[26], w[27], w[21], w[10], w[7]);
    FullAdder Fa7(w[28], w[29], w[24], w[12], w[23]);
    FullAdder Fa8(w[30], w[31], w[26], w[13], w[25]);
    FullAdder Fa9(w[32], w[33], w[27], w[14], w[11]);
    FullAdder Fa10(w[34], w[35], w[30], 1'b0, w[29]);
    FullAdder Fa11(w[36], w[37], w[35], w[31], w[32]);
    FullAdder Fa12(w[38], w[39], w[37], w[15], w[33]);
    assign P[0] = w[0];
    assign P[1] = w[16];
    assign P[2] = w[22];
    assign P[3] = w[28];
    assign P[4] = w[34];
    assign P[5] = w[36];
    assign P[6] = w[38];
    assign P[7] = w[39];

endmodule
