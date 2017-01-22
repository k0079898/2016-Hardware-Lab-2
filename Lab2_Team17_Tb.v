`timescale 1ns/10ps
module Tb_Q1;
  reg [3:0] A, B;
  wire      lt, gt, eq;
  Q1_4_bit_Comparator Q1(lt, gt, eq ,A, B);
  initial begin
    A=4'b1000;
    B=4'b0000;
    repeat (16) begin
      #50
      B=B+4'b0001;
    end
  end
endmodule

module Tb_Q2;
  reg  [3:0]  Din;
  wire [3:0]  Dout;
  Q2_Binary_to_Grey Q2(Dout, Din);
  initial begin
    Din=4'b0000;
    repeat (16) begin
      #50
      Din=Din+4'b0001;
    end
  end
endmodule

module Tb_Q3;
  wire [3:0] Rd;
  reg [2:0] Op_code;
  reg [3:0] Rs, Rt;
  Q3_Decode_and_Execute DaE(Rd, Op_code, Rs, Rt);
  initial begin
    Rs = 4'b0010;
    Rt = 4'b1110;
    //Rt = 4'b0000;
    Op_code = 3'b000;
    repeat (8) begin 
      repeat (16) begin
        #8
        Rs = Rs + 4'b0001;
        Rt = Rt - 4'b0001;
      end
    Op_code = Op_code + 3'b0001;
    end
  end
endmodule

module Tb_Q4;
  reg [2:0] Sel;
  reg       A, B;
  wire      Out;
  Q4_NAND_Implement Q4(Out, A, B, Sel);
  initial begin
    A=1'b0;
    B=1'b1;
    Sel=3'b000;
    repeat (2) begin
      repeat (8) begin
        #50
        Sel=Sel+3'b001;
      end
      A=A+1'b1;
    end
  end
endmodule

module Tb_Q5;
  reg [2:0] Sel;
  reg       A, B;
  wire      Out;
  Q5_NOR_Implement Q5(Out, A, B, Sel);
  initial begin
    A=1'b0;
    B=1'b1;
    Sel=3'b000;
    repeat (2) begin
      repeat (8) begin
        #50
        Sel=Sel+3'b001;
      end
      A=A+1'b1;
    end
  end
endmodule

module Tb_Q6;
  reg  D,clk;
  wire Q;
  Q6_FlipFlop Q6(Q, D, clk);
  initial begin
    D=1'b0;
    clk=1'b0;
    repeat (10) begin
      #80
      D=D+1'b1;
    end
  end
  initial begin   
    repeat (16) begin
      #50
      clk=~clk;
    end
  end
endmodule

module Tb_OQ1;
  reg  [3:0] A, B;
  reg        Cin;
  wire [3:0] Sum;
  wire       Cout;
  OQ1_4_bits_CLA OQ1(Cout, Sum, Cin, A, B);
  initial begin
    A=4'b0000;
    B=4'b0000;
    Cin=1'b0;
    repeat (4) begin
      repeat (2) begin
        #50    
        Cin=Cin+1'b1;
      end
      B=B+4'b0001;
    end
    A=4'b1111;
    B=4'b0000;
    Cin=1'b0;
    repeat (4) begin
      repeat (2) begin
        #50 
        Cin=Cin+1'b1;
      end
    B=B+4'b0001;
  end
end

endmodule

module Tb_OQ2;
  wire [7:0] P;
  reg [3:0] A, B;
  OQ2_4bit_Multiplier Mul1(P, A, B);
  initial begin
    A = 4'b0000;
    B = 4'b1111;
	repeat (16) begin
      #100
      A = A + 4'b0001;
	  B = B - 4'b0001;
    end
  end
endmodule