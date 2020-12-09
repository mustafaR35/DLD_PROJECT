`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2020 11:51:45 PM
// Design Name: 
// Module Name: VGA_module
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

module VGA_module(
    input CLK,
    input [11:0] COLOUR_IN,
    output reg [11:0] COLOUR_OUT,
    output reg HS,
    output reg VS,
    output reg [9:0] ADDRH,
    output reg [8:0] ADDRY
    );
    
    // stating all the wire connections
    wire  TRIG_1;
    wire  HorTriggOut;
    wire  VerticalTriggOut;
    wire  [9:0] HorCount;
    wire  [9:0] VerticalCount;
    //wire  [11:0] COLOUR_IN;
   
    //Time in vertical lines
    parameter VertTimeToPulseWidthEnd   = 10'd2;
    parameter VertTimeToBackPorchEnd    = 10'd31;
    parameter VertTimeToDisplayTimeEnd  = 10'd511;
    parameter VertTimeToFrontPorchEnd   = 10'd521;
    
    //Time in Front Horizontal Lines
    parameter HorzTimeToPulseWidthEnd   = 10'd96;
    parameter HorzTimeToBackPorchEnd    = 10'd144;
    parameter HorzTimeToDisplayTimeEnd  = 10'd784;
    parameter HorzTimeToFrontPorchEnd   = 10'd800;
    
    // This is a counter to reduce the frequency from 100MHz to 25MHz for screen refresh
    
    Generic_counter # (.COUNTER_WIDTH(2),
                       .COUNTER_MAX(3)
                       )
                       FreqCounter (
                       .CLK(CLK),
                       .ENABLE_IN(1'b1),
                       .RESET(1'b0),
                       .TRIG_OUT(TRIG_1)
                       );
    
    // This is a counter to count the horizontal pixel position
    
    Generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(799)
                       )
                       HorizCounter (
                       .CLK(CLK),
                       .ENABLE_IN(TRIG_1),
                       .RESET(1'b0),
                       .TRIG_OUT(HorTriggOut),
                       .COUNT(HorCount)
                       );
                       
     // This is a counter to count the vertical pixel position                  
                       
     Generic_counter # (.COUNTER_WIDTH(10),
                        .COUNTER_MAX(520)
                       )
                       VerticalCounter (
                       .CLK(CLK),
                       .ENABLE_IN(HorTriggOut),
                       .RESET(1'b0),
                       .COUNT(VerticalCount)
                       );
               
     always@( posedge CLK) begin
          if (HorCount < HorzTimeToPulseWidthEnd)
          HS <= 0;
          else 
          HS <= 1;
     end
     
     always@(posedge CLK) begin
          if (VerticalCount < VertTimeToPulseWidthEnd)
          VS <= 0;
          else 
          VS <= 1;
     end
     
     always@( posedge CLK) begin
          if (HorCount < HorzTimeToDisplayTimeEnd && HorCount > HorzTimeToBackPorchEnd 
          && VerticalCount < VertTimeToDisplayTimeEnd && VerticalCount > VertTimeToBackPorchEnd)
          COLOUR_OUT <= COLOUR_IN;    
               
          else 
          COLOUR_OUT <= 0;          
      end        
           
     always@(posedge CLK) begin
          if (HorCount < HorzTimeToDisplayTimeEnd && HorCount > HorzTimeToBackPorchEnd)
                ADDRH <= HorCount - HorzTimeToBackPorchEnd;
          else 
                ADDRH <= 0;      
     end           
     
     
     always@(posedge CLK) begin           
          if ( VerticalCount < VertTimeToDisplayTimeEnd && VerticalCount > VertTimeToBackPorchEnd)
                 ADDRY <= VerticalCount - VertTimeToBackPorchEnd;
          else 
                 ADDRY <= 0;
     end
                
endmodule