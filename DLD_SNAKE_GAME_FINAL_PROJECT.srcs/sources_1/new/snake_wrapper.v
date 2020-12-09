`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2020 11:55:20 PM
// Design Name: 
// Module Name: snake_wrapper
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

module snake_wrapper(
            input CLK,
            input RESET,
            input BTNU,
            input BTND,
            input BTNL,
            input BTNR,
            input GAME_IN,
            output [11:0] COLOUR_OUT,
            output HS,
            output VS,
            output [3:0] SEG_SELECT_OUT,
            output [7:0] DEC_OUT
             
    );
    // Connections between the modules
    wire [1:0] MSM_STATE;
    wire SCORE_WIN;
    
    wire [1:0] NAV_STATE;
    
    wire [7:0] TARGET_ADDR_H;
    wire [6:0] TARGET_ADDR_V;
    
    wire TARGET_REACHED;
    
    wire [11:0] COLOUR_OUTS;
    
    wire [9:0] ADDRH;
    wire [8:0] ADDRV;
    
    wire Timed_Mode;
    
    wire LOST;
    
    wire WIN;
    
    
    //Instantiating Master state machine
    Master_state_machine Master(
                            .BTNU(BTNU),
                            .BTND(BTND),
                            .BTNR(BTNR),
                            .BTNL(BTNL),
                            .CLK(CLK),
                            .RESET(RESET),
                            .SCORE_WIN(SCORE_WIN),
                            .LOST(LOST),
                            .WIN(WIN),
                            .MSM_STATE(MSM_STATE)
                            );
                            
    // Instantiating navigation system                        
    Navigation_state_machine Navigation(
                            .BTNU(BTNU),
                            .BTND(BTND),
                            .BTNR(BTNR),
                            .BTNL(BTNL),
                            .CLK(CLK),
                            .RESET(RESET),
                            .NAV_STATE(NAV_STATE)
                            );
    
    // Instantiating random number generator
    random_num_gen Target(
                            .RESET(RESET),
                            .CLK(CLK),
                            .TARGET_REACHED(TARGET_REACHED),
                            .TARGET_ADDR_H(TARGET_ADDR_H),
                            .TARGET_ADDR_V(TARGET_ADDR_V)
                            );
    
    // Instantiating Score counter                        
    Score_counter Score(
                            .RESET(RESET),
                            .CLK(CLK),
                            .TARGET_REACHED(TARGET_REACHED),
                            .SEG_SELECT_OUT(SEG_SELECT_OUT),
                            .DEC_OUT(DEC_OUT),
                            .SCORE_WIN(SCORE_WIN),
                            .Timed_Mode(Timed_Mode),
                            .MSM_STATE(MSM_STATE),
                            .LOST(LOST),
                            .WIN(WIN)
                            );
    
    // Instantiating VGA_control                        
    VGA_module VGA(
                            .COLOUR_IN(COLOUR_OUTS),
                            .CLK(CLK),
                            .HS(HS),
                            .VS(VS),
                            .ADDRH(ADDRH),
                            .ADDRY(ADDRV),
                            .COLOUR_OUT(COLOUR_OUT)
                            );
    
    // Instantiating Snake control                        
    Snake_control Control(
                            .MSM_STATE(MSM_STATE),
                            .NAV_STATE(NAV_STATE),
                            .TARGET_ADDR_H(TARGET_ADDR_H),
                            .TARGET_ADDR_V(TARGET_ADDR_V),
                            .ADDRH(ADDRH),
                            .ADDRY(ADDRV),
                            .COLOUR_OUT(COLOUR_OUTS),
                            .TARGET_REACHED(TARGET_REACHED),
                            .CLK(CLK),
                            .GAME_IN(GAME_IN),
                            .Timed_Mode(Timed_Mode),
                            .LOST(LOST),
                            .WIN(WIN),
                            .RESET(RESET)
                            );
                            
endmodule


