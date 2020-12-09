`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2020 10:26:26 PM
// Design Name: 
// Module Name: nsm_tb
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
module nsm_tb(
    );
    reg CLK, RESET, LEFT, UP, DOWN, RIGHT;
    wire [1:0] M_STATE;
    reg [3:0] score;   
    
    Navigation_state_machine uut2(
        .CLK(CLK),
        .RESET(RESET),
        .BTNL(LEFT),
        .BTNR(RIGHT),
        .BTNU(UP),
        .BTND(DOWN),
      .STATE(NAV_STATE)
    );
    
    initial begin
        #100 CLK = 0;
        forever #2 CLK = ~CLK;
        
    end
    
    initial begin
        #100
        RESET = 0;
        LEFT = 0;
        UP = 0;
        DOWN = 0;
        RIGHT = 0;
        #200
        LEFT = 1;
        #200
        LEFT = 0;
    end
    
endmodule