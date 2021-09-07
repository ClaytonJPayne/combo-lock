`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2021 10:23:14 AM
// Design Name: 
// Module Name: tb_1
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


module tb_1;
    reg clk, enter, rst, clr, hard_rst;
    reg [9:0] keypad;
    wire unlock, incorrect; 
    wire [15:0] try_monitor;
    wire press_monitor;
    combo_lock lock1(clk, enter, rst, clr, hard_rst, keypad, unlock, incorrect, try_monitor, press_monitor);
    always begin #5 clk = !clk; end
    initial 
    begin
    keypad = 0; enter = 0; rst = 0; clr = 0; hard_rst = 1; clk = 0; #100;
    hard_rst = 1; #10; hard_rst = 0; 
    keypad = 10'b0000000001; #10; keypad = 0; #10;  // Unlock with default password (0000)
    keypad = 10'b0000000001; #10; keypad = 0; #10;
    keypad = 10'b0000000001; #10; keypad = 0; #10;
    keypad = 10'b0000000001; #10; keypad = 0; #10;
    enter = 1; #10; enter = 0; #10;
    rst = 1; #10; rst = 0; #10;
    keypad = 10'b0100000000; #10 keypad = 0; #10;   // Reprogram with a new password (8086)
    keypad = 10'b0000000001; #10 keypad = 0; #10;
    keypad = 10'b0100000000; #10 keypad = 0; #10;
    keypad = 10'b0001000000; #10 keypad = 0; #10;
    enter = 1; #10; enter = 0; #10;
    keypad = 10'b0100000000; #10 keypad = 0; #10;   // Unlock with correct password (8086)
    keypad = 10'b0000000001; #10 keypad = 0; #10;
    keypad = 10'b0100000000; #10 keypad = 0; #10;
    keypad = 10'b0001000000; #10 keypad = 0; #10;
    enter = 1; #10; enter = 0; #10;
    enter = 1; #10; enter = 0; #10;
    keypad = 10'b0010000000; #5 keypad = 0; #10;   // Unsuccessfully unlock with incorrect password (7086)
    keypad = 10'b0000000001; #10 keypad = 0; #10;
    keypad = 10'b0100000000; #10 keypad = 0; #10;
    keypad = 10'b0001000000; #10 keypad = 0; #10;
    enter = 1; #10; enter = 0; #10;
    keypad = 10'b0100000000; #10; 
    keypad = 10'b0110000000; #10;                   // Unlock successfully despite delayed double press
    keypad = 0; #10;                                
    keypad = 10'b0000000001; #10 keypad = 0; #10;
    keypad = 10'b0100000000; #10 keypad = 0; #10;
    keypad = 10'b0001000000; #10 keypad = 0; #10;
    enter = 1; #10; enter = 0; #10;
    enter = 1; #10; enter = 0; #10;
    keypad = 10'b0110000000; #10 keypad = 0; #10;   // Unlock unsuccessfully because of simultaneous double press                   
    keypad = 10'b0000000001; #10 keypad = 0; #10;
    keypad = 10'b0100000000; #10 keypad = 0; #10;
    keypad = 10'b0001000000; #10 keypad = 0; #10;
    enter = 1; #10; enter = 0; #10;
    end
endmodule
