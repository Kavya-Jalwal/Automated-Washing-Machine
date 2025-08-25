`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2025 18:49:24
// Design Name: 
// Module Name: Washing_Machine_tb
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
module Washing_Machine_tb;

    reg clk, reset, door_close, start, filled, detergent_added, cycle_timeout, drained, spin_timeout;
    wire door_lock, motor_on, fill_value_on, drain_value_on, done, soap_wash, water_wash;

    // DUT instance
    Washing_Machine uut (
        .clk(clk), .reset(reset), .door_close(door_close), .start(start), 
        .filled(filled), .detergent_added(detergent_added), 
        .cycle_timeout(cycle_timeout), .drained(drained), .spin_timeout(spin_timeout),
        .door_lock(door_lock), .motor_on(motor_on), .fill_value_on(fill_value_on), 
        .drain_value_on(drain_value_on), .done(done), .soap_wash(soap_wash), .water_wash(water_wash)
    );

    // clock
    always #5 clk = ~clk;

    initial begin
        // init
        clk = 0;
        reset = 0; door_close = 0; start = 0; filled = 0;
        detergent_added = 0; cycle_timeout = 0; drained = 0; spin_timeout = 0;

        #10 reset = 1; 

        // Step1: close door & start
        #10 door_close = 1;#10 start = 1;

        // Step2: water filled
        #20 filled = 1; #10 filled = 0;

        // Step3: detergent added
        #20 detergent_added = 1; #10 detergent_added = 0;

        // Step4: cycle running, then timeout
        #50 cycle_timeout = 1; #10 cycle_timeout = 0;

        // Step5: drained
        #20 drained = 1; #10 drained = 0;

        // Step6: rinse water fill
        #20 filled = 1; #10 filled = 0;

        // Step7: rinse cycle, then timeout
        #50 cycle_timeout = 1; #10 cycle_timeout = 0;

        // Step8: drained after rinse
        #20 drained = 1; #10 drained = 0;

        // Step9: spin
        #50 spin_timeout = 1; #5 spin_timeout = 0;

         $stop;
    end
endmodule











