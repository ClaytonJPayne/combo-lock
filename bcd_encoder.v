`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2021 08:09:27 AM
// Design Name: 
// Module Name: bcd_encoder
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


module bcd_encoder(
input [9:0] binary_digits,
output [3:0] bcd,
output one_press
    );
    reg [3:0] bcd_reg;
    reg one_press_reg;
    assign bcd = bcd_reg;
    assign one_press = one_press_reg;
    always @ (binary_digits)
    begin
    case (binary_digits) 
    10'b0000000001: begin bcd_reg = 4'b0000; one_press_reg = 1; end
    10'b0000000010: begin bcd_reg = 4'b0001; one_press_reg = 1; end
    10'b0000000100: begin bcd_reg = 4'b0010; one_press_reg = 1; end
    10'b0000001000: begin bcd_reg = 4'b0011; one_press_reg = 1; end
    10'b0000010000: begin bcd_reg = 4'b0100; one_press_reg = 1; end
    10'b0000100000: begin bcd_reg = 4'b0101; one_press_reg = 1; end
    10'b0001000000: begin bcd_reg = 4'b0110; one_press_reg = 1; end
    10'b0010000000: begin bcd_reg = 4'b0111; one_press_reg = 1; end
    10'b0100000000: begin bcd_reg = 4'b1000; one_press_reg = 1; end
    10'b1000000000: begin bcd_reg = 4'b1001; one_press_reg = 1; end
    default: begin bcd_reg = 4'b1111; one_press_reg = 0; end
    endcase
    end
endmodule
