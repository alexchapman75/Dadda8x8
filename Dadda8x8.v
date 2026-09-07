`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ncsu
// Engineer: alex
// 
// Create Date: 09/02/2026 03:12:26 PM
// Design Name: 
// Module Name: Dadda8x8
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module FA( //The autograder required this to be named FA
        input A,B,Cin,
        output Cout, S
    );
    
    wire xor1_out, and1_out, and2_out;
    
    xor x1(xor1_out, A, B);
    xor x2(S, xor1_out, Cin);
    and a1(and1_out, A, B);
    and a2(and2_out, xor1_out, Cin);
    or o1(Cout, and1_out, and2_out);
    
endmodule

module HA( //The autograder required this to be named HA
    input A,B,
    output Cout, S
);

    xor x1(S, A, B);
    and a1(Cout, A,B);

endmodule

module rca_14bit( //We have a 14 bit rca, with pp_a0_b0 going right on through
    input [13:0] A,
    input [13:0] B,
    output [13:0] S,
    output Cout
    );

    wire Cout0, Cout1, Cout2, Cout3, Cout4, Cout5, Cout6, 
         Cout7, Cout8, Cout9, Cout10, Cout11, Cout12;
    
    HA ha_george(A[0], B[0], Cout0, S[0]);

    FA fa1(A[1], B[1], Cout0, Cout1, S[1]);
    FA fa2(A[2], B[2], Cout1, Cout2, S[2]);
    FA fa3(A[3], B[3], Cout2, Cout3, S[3]);
    FA fa4(A[4], B[4], Cout3, Cout4, S[4]);
    FA fa5(A[5], B[5], Cout4, Cout5, S[5]);
    FA fa6(A[6], B[6], Cout5, Cout6, S[6]);
    FA fa7(A[7], B[7], Cout6, Cout7,  S[7]);
    FA fa8(A[8], B[8], Cout7, Cout8,  S[8]);
    FA fa9(A[9], B[9], Cout8, Cout9,  S[9]);
    FA fa10(A[10], B[10], Cout9, Cout10,  S[10]);
    FA fa11(A[11], B[11], Cout10, Cout11, S[11]);
    FA fa12(A[12], B[12], Cout11, Cout12, S[12]);
    FA fa13(A[13], B[13], Cout12, Cout, S[13]);

endmodule

module Dadda8x8(
    input [7:0] a,
    input [7:0] b,
    output [15:0] prod
);
    //2D array to store partial products [Rows][Columns]
    //ROWS: Are top to bottom, 0 on top, 7 on bottom like my design
    //Columns: Are left to right, 7 on left 0 on right
    //Top Left: [0][7]
    //Top Right: [0][0]
    //Bottom Left: [7][7]
    //Bottom Right: [7][0]
    /*
    In the partial product matrix, on the same ROW, b is the same,
    and on the same COLUMN, a is the same.
    I hope this makes sense.
    */

    // If you see "ppFinalA/B" here, that means,
    //the partial product avoids all adders and will be used only by the rca

    wire partialProductMatrix[0:7][7:0];

    //Row 0, alligns with b[0] From [0][0] -> [0][7]
    and a_A0_B0(ppFinalA[0],                a[0], b[0]);
    and a_A1_B0(ppFinalA[1],                a[1], b[0]);
    and a_A2_B0(partialProductMatrix[0][2], a[2], b[0]);
    and a_A3_B0(partialProductMatrix[0][3], a[3], b[0]);
    and a_A4_B0(partialProductMatrix[0][4], a[4], b[0]);
    and a_A5_B0(partialProductMatrix[0][5], a[5], b[0]);
    and a_A6_B0(partialProductMatrix[0][6], a[6], b[0]);
    and a_A7_B0(partialProductMatrix[0][7], a[7], b[0]);

    //Row 1, alligns with b[1] From [1][0] -> [1][7]
    and a_A0_B1(ppFinalB[1],                a[0], b[1]);
    and a_A1_B1(partialProductMatrix[1][1], a[1], b[1]);
    and a_A2_B1(partialProductMatrix[1][2], a[2], b[1]);
    and a_A3_B1(partialProductMatrix[1][3], a[3], b[1]);
    and a_A4_B1(partialProductMatrix[1][4], a[4], b[1]);
    and a_A5_B1(partialProductMatrix[1][5], a[5], b[1]);
    and a_A6_B1(partialProductMatrix[1][6], a[6], b[1]);
    and a_A7_B1(partialProductMatrix[1][7], a[7], b[1]);

    //Row 2, alligns with b[2] From [2][0] -> [2][7]
    and a_A0_B2(ppFinalB[2],                a[0], b[2]);
    and a_A1_B2(partialProductMatrix[2][1], a[1], b[2]);
    and a_A2_B2(partialProductMatrix[2][2], a[2], b[2]);
    and a_A3_B2(partialProductMatrix[2][3], a[3], b[2]);
    and a_A4_B2(partialProductMatrix[2][4], a[4], b[2]);
    and a_A5_B2(partialProductMatrix[2][5], a[5], b[2]);
    and a_A6_B2(partialProductMatrix[2][6], a[6], b[2]);
    and a_A7_B2(partialProductMatrix[2][7], a[7], b[2]);

    //Row 3, alligns with b[3] From [3][0] -> [3][7]
    and a_A0_B3(partialProductMatrix[3][0], a[0], b[3]);
    and a_A1_B3(partialProductMatrix[3][1], a[1], b[3]);
    and a_A2_B3(partialProductMatrix[3][2], a[2], b[3]);
    and a_A3_B3(partialProductMatrix[3][3], a[3], b[3]);
    and a_A4_B3(partialProductMatrix[3][4], a[4], b[3]);
    and a_A5_B3(partialProductMatrix[3][5], a[5], b[3]);
    and a_A6_B3(partialProductMatrix[3][6], a[6], b[3]);
    and a_A7_B3(partialProductMatrix[3][7], a[7], b[3]);

    //Row 4, alligns with b[4] From [4][0] -> [4][7]
    and a_A0_B4(partialProductMatrix[4][0], a[0], b[4]);
    and a_A1_B4(partialProductMatrix[4][1], a[1], b[4]);
    and a_A2_B4(partialProductMatrix[4][2], a[2], b[4]);
    and a_A3_B4(partialProductMatrix[4][3], a[3], b[4]);
    and a_A4_B4(partialProductMatrix[4][4], a[4], b[4]);
    and a_A5_B4(partialProductMatrix[4][5], a[5], b[4]);
    and a_A6_B4(partialProductMatrix[4][6], a[6], b[4]);
    and a_A7_B4(partialProductMatrix[4][7], a[7], b[4]);

    //Row 5, alligns with b[5] From [5][0] -> [5][7]
    and a_A0_B5(partialProductMatrix[5][0], a[0], b[5]);
    and a_A1_B5(partialProductMatrix[5][1], a[1], b[5]);
    and a_A2_B5(partialProductMatrix[5][2], a[2], b[5]);
    and a_A3_B5(partialProductMatrix[5][3], a[3], b[5]);
    and a_A4_B5(partialProductMatrix[5][4], a[4], b[5]);
    and a_A5_B5(partialProductMatrix[5][5], a[5], b[5]);
    and a_A6_B5(partialProductMatrix[5][6], a[6], b[5]);
    and a_A7_B5(partialProductMatrix[5][7], a[7], b[5]);

    //Row 6, alligns with b[6] From [6][0] -> [6][7] (six seven)
    and a_A0_B6(partialProductMatrix[6][0], a[0], b[6]);
    and a_A1_B6(partialProductMatrix[6][1], a[1], b[6]);
    and a_A2_B6(partialProductMatrix[6][2], a[2], b[6]);
    and a_A3_B6(partialProductMatrix[6][3], a[3], b[6]);
    and a_A4_B6(partialProductMatrix[6][4], a[4], b[6]);
    and a_A5_B6(partialProductMatrix[6][5], a[5], b[6]);
    and a_A6_B6(partialProductMatrix[6][6], a[6], b[6]);
    and a_A7_B6(partialProductMatrix[6][7], a[7], b[6]);

    //Row 7, alligns with b[7] From [7][0] -> [7][7]
    and a_A0_B7(partialProductMatrix[7][0], a[0], b[7]);
    and a_A1_B7(partialProductMatrix[7][1], a[1], b[7]);
    and a_A2_B7(partialProductMatrix[7][2], a[2], b[7]);
    and a_A3_B7(partialProductMatrix[7][3], a[3], b[7]);
    and a_A4_B7(partialProductMatrix[7][4], a[4], b[7]);
    and a_A5_B7(partialProductMatrix[7][5], a[5], b[7]);
    and a_A6_B7(partialProductMatrix[7][6], a[6], b[7]);
    and a_A7_B7(ppFinalB[14],               a[7], b[7]);

    ///////////////////////////////////////////////////// Reduction Steps 

    wire [1:0] h1, h2, h3, h4, h5, h6, h7; //All Half Adder Results, bit[1] is the CARRY, bit[0] is the SUM

    wire [1:0] f1,  f2,  f3,  f4,  f5,  f6,  f7; //All Full Adder Results, bit[1] is the CARRY, bit[0] is the SUM
    wire [1:0] f8,  f9,  f10, f11, f12, f13, f14;
    wire [1:0] f15, f16, f17, f18, f19, f20, f21;
    wire [1:0] f22, f23, f24, f25, f26, f27, f28;
    wire [1:0] f29, f30, f31, f32, f33, f34, f35;

    wire[14:0] ppFinalA; //A little convoluted, but all results that are used in the rca at the end will go here
    wire[14:0] ppFinalB;


    //Half Adders
    HA half1(partialProductMatrix[6][0], partialProductMatrix[5][1], h1[1], h1[0]);
    HA half2(partialProductMatrix[4][3], partialProductMatrix[3][4], h2[1], h2[0]);
    HA half3(partialProductMatrix[4][4], partialProductMatrix[3][5], h3[1], h3[0]);
    HA half4(partialProductMatrix[4][0], partialProductMatrix[3][1], h4[1], h4[0]);
    HA half5(partialProductMatrix[2][3], partialProductMatrix[1][4], h5[1], h5[0]);
    HA half6(partialProductMatrix[3][0], partialProductMatrix[2][1], h6[1], h6[0]);
    HA half7(partialProductMatrix[0][2], partialProductMatrix[1][1], ppFinalA[3], ppFinalA[2]);


    //Full Adders
    FA full1(partialProductMatrix[7][0], partialProductMatrix[6][1], partialProductMatrix[5][2], f1[1], f1[0]);
    FA full2(partialProductMatrix[7][1], partialProductMatrix[6][2], partialProductMatrix[5][3], f2[1], f2[0]);
    FA full3(partialProductMatrix[7][2], partialProductMatrix[6][3], partialProductMatrix[5][4], f3[1], f3[0]);

    FA  full4(partialProductMatrix[5][0], partialProductMatrix[4][1], partialProductMatrix[3][2], f4[1], f4[0]);
    FA  full5(h1[0],                      partialProductMatrix[4][2], partialProductMatrix[3][3], f5[1], f5[0]);
    FA  full6(partialProductMatrix[2][4], partialProductMatrix[1][5], partialProductMatrix[0][6], f6[1], f6[0]);
    FA  full7(h1[1],                      f1[0],                      h2[0],                      f7[1], f7[0]);
    FA  full8(partialProductMatrix[2][5], partialProductMatrix[1][6], partialProductMatrix[0][7], f8[1], f8[0]);
    FA  full9(h2[1],                      f1[1],                      f2[0],                      f9[1], f9[0]);
    FA full10(h3[0],                      partialProductMatrix[2][6], partialProductMatrix[1][7], f10[1], f10[0]);
    FA full11(h3[1],                      f2[1],                      f3[0],                      f11[1], f11[0]);
    FA full12(partialProductMatrix[4][5], partialProductMatrix[3][6], partialProductMatrix[2][7], f12[1], f12[0]);
    FA full13(f3[1],                      partialProductMatrix[7][3], partialProductMatrix[6][4], f13[1], f13[0]);
    FA full14(partialProductMatrix[5][5], partialProductMatrix[4][6], partialProductMatrix[3][7], f14[1], f14[0]);
    FA full15(partialProductMatrix[7][4], partialProductMatrix[6][5], partialProductMatrix[5][6], f15[1], f15[0]);

    //bit[1] is the CARRY, bit[0] is the SUM

    FA full16(h4[0],                      partialProductMatrix[2][2], partialProductMatrix[1][3], f16[1], f16[0]);
    FA full17(h4[1],                      f4[0],                      h5[0],                      f17[1], f17[0]);
    FA full18(h5[1],                      f4[1],                      f5[0],                      f18[1], f18[0]);
    FA full19(f5[1],                      f6[1],                      f7[0],                      f19[1], f19[0]);
    FA full20(f7[1],                      f8[1],                      f9[0],                      f20[1], f20[0]);
    FA full21(f9[1],                      f10[1],                     f11[0],                     f21[1], f21[0]);
    FA full22(f11[1],                     f12[1],                     f13[0],                     f22[1], f22[0]);
    FA full23(f13[1],                     f14[1],                     f15[0],                     f23[1], f23[0]);
    FA full24(f15[1],                     partialProductMatrix[7][5], partialProductMatrix[6][6], f24[1], f24[0]);

    FA full25(h6[0],                      partialProductMatrix[1][2], partialProductMatrix[0][3], ppFinalA[4], ppFinalB[3]);
    FA full26(h6[1],                      f16[0],                     partialProductMatrix[0][4], ppFinalA[5], ppFinalB[4]);
    FA full27(f16[1],                     f17[0],                     partialProductMatrix[0][5], ppFinalA[6], ppFinalB[5]);
    FA full28(f17[1],                     f18[0],                     f6[0],                      ppFinalA[7], ppFinalB[6]);
    FA full29(f18[1],                     f19[0],                     f8[0],                      ppFinalA[8], ppFinalB[7]);
    FA full30(f19[1],                     f20[0],                     f10[0],                     ppFinalA[9], ppFinalB[8]);
    FA full31(f20[1],                     f21[0],                     f12[0],                     ppFinalA[10], ppFinalB[9]);
    FA full32(f21[1],                     f22[0],                     f14[0],                     ppFinalA[11], ppFinalB[10]);
    FA full33(f22[1],                     f23[0],                     partialProductMatrix[4][7], ppFinalA[12], ppFinalB[11]);
    FA full34(f23[1],                     f24[0],                     partialProductMatrix[5][7], ppFinalA[13], ppFinalB[12]);
    FA full35(f24[1],                     partialProductMatrix[7][6], partialProductMatrix[6][7], ppFinalA[14], ppFinalB[13]);



    buf(prod[0], ppFinalA[0]); //Tie the LSB of prod to ppFinalA because there's basically no ppFinalB

    rca_14bit ripple1(ppFinalA[14:1], ppFinalB[14:1], prod[14:1], prod[15]);

endmodule