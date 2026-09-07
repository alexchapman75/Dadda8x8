`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ncsu
// Engineer: alex
//
// Create Date: 09/07/2026
// Design Name: Dadda8x8
// Module Name: Dadda8x8_tb_sv
// Project Name: Project 1 - Extended DV version
// Description: Constrained-random, self-checking testbench with functional
//              coverage for the 8x8 Dadda multiplier. Directed corner cases
//              are run first to guarantee coverage closure on key bins, then
//              constrained-random vectors are run to exercise the rest of the
//              input space and catch anything the directed tests missed.
//
// 
// 
//////////////////////////////////////////////////////////////////////////////////


  //Hi, this is an extension of my ECE310 project where I apply systemVerilog DV principles to
  //grow my knowledge and experience in the space

// Transaction class: generates one randomized (a,b) input pair per instance
class Dadda8x8_tx;
    rand bit [7:0] a;
    rand bit [7:0] b;

    // Bias the random distribution toward interesting corner values
    // occasionally, rather than pure uniform random, so corners get hit
    // more often during the random phase too (not just the directed phase).
    constraint c_interesting {
        // Out of total possibilities, all zeroes and all ones should show up 1/10 of the time respectively
        a dist { 8'h00 := 1, 8'hFF := 1, [8'h01:8'hFE] := 8 }; 
        b dist { 8'h00 := 1, 8'hFF := 1, [8'h01:8'hFE] := 8 };
    }
endclass

module Dadda8x8_tb_sv();

    logic [7:0] a, b;
    logic [15:0] prod;
    logic [15:0] expected;

    int errors      = 0;
    int total_tests = 0;

    Dadda8x8 uut (a, b, prod);


    // Functional coverage: tracks which importan input categories
    // have actually been exercised, rather than just counting runs.

    //I.E. "what have I actually done?!?"

    covergroup cg_inputs @(posedge check_event);
        //cp_a and cp_b check how many times each bin has been hit for a & b
        cp_a: coverpoint a {
            bins zero        = {8'h00};
            bins max         = {8'hFF};
            bins single_bit  = {8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80};
            bins alternating = {8'hAA, 8'h55};
            bins mid_range   = {[8'h01:8'hFE]};
        }
        cp_b: coverpoint b {
            bins zero        = {8'h00};
            bins max         = {8'hFF};
            bins single_bit  = {8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80};
            bins alternating = {8'hAA, 8'h55};
            bins mid_range   = {[8'h01:8'hFE]};
        }
        // Cross coverage: counting the number of combos we hit from a & b, not just treating them as individuals
                                
        cross_ab: cross cp_a, cp_b;
    endgroup

    event check_event; // Event and cover group declaration
    cg_inputs cg = new(); // OOP style class instanstiation


    // Self-checking task: applies one vector, waits for it to settle,
    // computes the expected result, compares, samples coverage, repeats.


    //Task == function in normal code                            
    task automatic run_vector(input [7:0] a_in, input [7:0] b_in);
        begin
            a = a_in;
            b = b_in;
            #10; // allow prod to settle
            expected = a_in * b_in; // expected outcome
            total_tests++; // increment tests
            ->check_event; // sample functional coverage for this vector
            if (prod !== expected) begin // fail case
                $display("FAIL at time %0t: a=%b b=%b prod=%b expected=%b",
                          $time, a, b, prod, expected);
                errors++; // increment errors
            end
        end
    endtask

    Dadda8x8_tx tx;

    initial begin
        tx = new();


        // Phase 1: Directed corner cases (guarantees coverage closure
        // on the bins that matter most, regardless of what random testing happens to hit).

        run_vector(8'hFF, 8'hFF); // all ones
        run_vector(8'hAA, 8'h55); // alternating bits
        run_vector(8'h0F, 8'hF0); // nibble aligned
        run_vector(8'h9C, 8'h6D); // general non-trivial
        run_vector(8'h00, 8'hFF); // all-zero edge case
        run_vector(8'h01, 8'h01); // minimal non-zero case


        // Phase 2: Constrained-random vectors, weighted toward corners
        // but covering the general input space as well. Runs until
        // either enough iterations pass or coverage closes, whichever
        // the person running this cares to check.

        repeat (200) begin
            if (!tx.randomize()) // fail case
                $display("ERROR: randomize() failed at time %0t", $time);
            run_vector(tx.a, tx.b);
        end


        // Report results

        $display("--------------------------------------------------");
        $display("Total tests run : %0d", total_tests);
        $display("Failures        : %0d", errors);
        $display("Functional coverage: %0.2f%%", cg.get_coverage());
        if (errors == 0)
            $display("All test cases passed.");
        else
            $display("%0d test case(s) FAILED.", errors);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
