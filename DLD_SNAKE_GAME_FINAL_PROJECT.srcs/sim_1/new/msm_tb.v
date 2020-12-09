`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2018 22:19:17
// Design Name: 
// Module Name: msm_tb
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
module msm_tb(
    );
    reg CLK, RESET, LEFT, UP, DOWN, RIGHT, WIN, LOST;
    wire [1:0] M_STATE;
    reg [3:0] score;   
    
    Master_state_machine uut2(
        .CLK(CLK),
        .RESET(RESET),
        .BTNL(LEFT),
        .BTNR(RIGHT),
        .BTNU(UP),
        .BTND(DOWN),
        .SCORE_WIN(score),
        .MSM_STATE(M_STATE),
      	.WIN(w),
      	.LOST(l)
    );
    
    initial begin
        #100 CLK = 0;
        forever #2 CLK = ~CLK;
        
    end
    
    initial begin
        #100
        RESET = 0;
        score = 0;
        LEFT = 0;
        UP = 0;
        DOWN = 0;
        RIGHT = 0;
        #200
        LEFT = 1;
        #200
        LEFT = 0;
        #100
        score = 10;
    end
    
//initial 
//  begin
//    $dumpfile("dump.vcd");
//    $dumpvars(1,msm_tb);
    //#500 $finish;
//  end
endmodule
