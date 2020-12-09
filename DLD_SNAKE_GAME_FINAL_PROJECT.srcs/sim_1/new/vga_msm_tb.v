`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2018 20:06:55
// Design Name: 
// Module Name: vga_msm_tb
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
module vga_tb(
    );
    
    reg CLK, RESET, LEFT, UP, DOWN, RIGHT;
    reg [11:0] COLOUR_IN = 12'd0;
    wire [9:0] X_ADDR;
    wire [8:0] Y_ADDR;
    wire HS, VS;
    wire [11:0] COLOUR_OUT;
    
    VGA_module uut(
        .CLK(CLK),
        .M_STATE(M_STATE),
        .COLOUR_IN(COLOUR_IN),
        .ADDRH(X_ADDR),
        .ADDRY(Y_ADDR),
        .HS(HS),
        .VS(VS),
        .COLOUR_OUT(COLOUR_OUT)
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
