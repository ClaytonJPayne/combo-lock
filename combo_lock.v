`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Clayton J. Payne 
// 
// Create Date: 09/05/2021 08:48:49 PM
// Module Name: combo_lock
// Description: A simple programmable combination lock
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Shifts user-input digits into registers via an IRQ-like mechanism
// 
//////////////////////////////////////////////////////////////////////////////////


module combo_lock(
input clk,
input enter, rst, clr, hard_rst,        // enter - lets user input combo 
                                        // rst - lets user reprogram password in unlocked state 
                                        // clr - lets user clear an input combo before entering 
                                        // hard_rst - for simulation, resets both password regs
input [9:0] keypad,
output unlock, incorrect,
output [15:0] try_monitor,              // For debugging
output press_monitor                    // For debugging
    );
    parameter width = 4;
    parameter s_locked = 2'b00, s_unlocked = 2'b01, s_rst = 2'b10;
    reg [1:0] state, next_state;        // Controller state regs 
    reg [15:0] pw, try;                 // Datapath regs
    reg ld_pw, clr_pw, ld_try, clr_try; // Control signals
    reg unlock_reg, incorrect_reg;
    assign unlock = unlock_reg, incorrect = incorrect_reg;
    assign try_monitor = try;
  
    // Combinational datapath logic
    
    wire match = (pw == try);
    wire one_press;                     // Cause multi-presses to be ignored
    reg irq;
    
    /* IRQ reg for storing user-input digits to datapath registers 
       On the positive edge of a button press, the IRQ reg is set.
       If the controller is in the locked or reset states, this drives 
       the ld_pw or ld_try control signals. This causes the user-input 
       BCD digit to shift into either the password register or password
       attempt ("try") register on the next clock edge, and clear the IRQ,
       thus keeping the same digit from being stored multiple times during 
       the same press.
    */ 
    
    assign press_monitor = one_press;
    wire [3:0] digit;
    bcd_encoder bcd_enc_1(keypad, digit, one_press);
    
    // CONTROLLER //
    
    always @ (posedge clk, posedge hard_rst)
        if (hard_rst) begin state <= s_locked; try <= 0; pw <= 0; end
        else state <= next_state;
    always @ (state, enter, clr, rst, one_press, match, irq)
    begin
        ld_pw = 0; clr_pw = 0; ld_try = 0; clr_try = 0; incorrect_reg = 0; unlock_reg = 0;
        case(state)
        s_locked:
        begin
            if (irq) ld_try = 1;
            if (clr) begin clr_try = 1; next_state = s_locked; end
            else if (!enter) next_state = s_locked;
            else if (!match) begin clr_try = 1; incorrect_reg = 1; next_state = s_locked; end
            else begin next_state = s_unlocked; end 
        end
        s_unlocked:
        begin
            unlock_reg = 1; 
            if (enter) begin clr_try = 1; next_state = s_locked; end
            else if (!rst) next_state = s_unlocked;
            else begin clr_pw = 1; next_state = s_rst; end 
        end
        s_rst:
        begin
            unlock_reg = 1;
            if (irq) ld_pw = 1;
            if (clr) begin clr_pw = 1; next_state = s_rst; end
            else if (!enter) next_state = s_rst;
            else begin clr_try = 1; next_state = s_locked; end
        end
        default: next_state = s_locked;
        endcase
    end
    
    // DATAPATH //
    
    always @ (posedge one_press) begin irq = 1; end
    always @ (posedge clk)
    begin
        if (ld_pw) 
        begin 
        pw <= pw << 4; 
        pw[3:0] <= digit;
        irq <= 0; 
        end 
        else if (clr_pw) pw <= 0;
        if (ld_try) 
        begin 
        try <= try << 4; 
        try[3:0] <= digit;
        irq <= 0; 
        end
        else if (clr_try) try <= 0;
    end                    
endmodule
