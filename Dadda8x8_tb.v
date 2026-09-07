`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ncsu
// Engineer: alex
// 
// Create Date: 09/05/2026
// Design Name: 
// Module Name: Dadda8x8_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Self-checking testbench - compares prod against a golden
//              expected value for each vector and reports PASS/FAIL.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added golden-value self-checking
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Dadda8x8_tb();

    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] prod;
    reg [15:0] expected;
    integer errors = 0;

    Dadda8x8 uut (a,b,prod);

    // Compares prod against the golden value 1ns after each vector settles
    task check;
        begin
            #1;
            if (prod !== expected) begin
                $display("FAIL at time %0t: a=%b b=%b prod=%b expected=%b",
                          $time, a, b, prod, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial
    begin
        $monitor($time, " a: %b b: %b prod: %b ", a,b,prod);

        a = 8'b11111111; b = 8'b11111111; expected = 16'b1111111000000001; //All Ones
        check;
        #10
        a = 8'b10101010; b = 8'b01010101; expected = 16'b0011100001110010; //Alternating bits
        check;
        #10
        a = 8'b00001111; b = 8'b11110000; expected = 16'b0000111000010000; //Nibble aligned
        check;
        #10
        a = 8'b10011100; b = 8'b01101101; expected = 16'b0100001001101100; //Non-trivial values
        check;
        #10
        a = 8'b00000000; b = 8'b11111111; expected = 16'b0000000000000000; //All Zeroes edge case
        check;
        #10
        a = 8'b00000001; b = 8'b00000001; expected = 16'b0000000000000001; //Minimal non-zero case
        check;
        #10

        if (errors == 0)
            $display("All test cases passed.");
        else
            $display("%0d test case(s) FAILED.", errors);

        $finish;
    end

endmodule
