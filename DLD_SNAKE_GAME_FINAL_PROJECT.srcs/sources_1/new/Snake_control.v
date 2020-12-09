`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2020 11:50:31 PM
// Design Name: 
// Module Name: Snake_control
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


module Snake_control(
                input       CLK,
                input       RESET,
                input [1:0] MSM_STATE,
                input [1:0] NAV_STATE,
                input [7:0] TARGET_ADDR_H,
                input [6:0] TARGET_ADDR_V,
                input [9:0] ADDRH,
                input [9:0] ADDRY,
                input       GAME_IN,
                input       LOST,
                input       WIN,
                output reg [11:0] COLOUR_OUT,
                output reg TARGET_REACHED,
                output reg Timed_Mode
    );
     
      parameter SnakeLength = 20;
      parameter SmallSnake = 2;
      parameter MaxX = 159;
      parameter MaxY = 119;
      
      parameter RED = 12'b000000001111;
      parameter BLUE = 12'b111100000000;
      parameter YELLOW = 12'b000011111111;
      parameter BLACK = 12'b000000000000;
    
      // registers to store the snake addresses
      reg [7:0] SnakeState_X [0 : SnakeLength - 1];
      reg [6:0] SnakeState_Y [0 : SnakeLength - 1];
      reg [4:0] SnakeVar;
      reg [15:0] FrameCount;
      
      wire TRIG_1;
      wire TRIGC;
      wire [11:0] ColourCount;
      wire [7:0] ADDRH_S;
      wire [6:0] ADDRV_S;
      
      integer i;
      
      initial begin
        TARGET_REACHED <= 0;
        Timed_Mode <= 0;
        SnakeVar <= SmallSnake;
      end
     
     
      // This is the counter that reduces the clock frequency and thus determines the snake speed
      Generic_counter # (.COUNTER_WIDTH(23),
                         .COUNTER_MAX(3999999)
                         )
                         FreqCounter (
                         .CLK(CLK),
                         .ENABLE_IN(1'b1),
                         .RESET(1'b0),
                         .TRIG_OUT(TRIG_1)
                         );
      
//      // This counter determines the frequency of the colours to change on the main screen during the idle state                   
      Generic_counter # (.COUNTER_WIDTH(23),
                         .COUNTER_MAX(2999999)
                         )
                         ColourFreqCounter (
                         .CLK(CLK),
                         .ENABLE_IN(1'b1),
                         .RESET(1'b0),
                         .TRIG_OUT(TRIGC)
                         );                   
      
      // This counter goes through all of the possible colours in the range, being triggerd by the ColourFreqCounter
      Generic_counter # (.COUNTER_WIDTH(12),
                         .COUNTER_MAX(4094)
                         )
                         ColCounter (
                         .CLK(TRIGC),
                         .ENABLE_IN(1'b1),
                         .RESET(1'b0),
                         .COUNT(ColourCount)
                         );
      
      // This is the main part of the code. Here the screen behaviour is described for easch state
                         
      always@(posedge CLK) begin
            case (MSM_STATE)
                  2'b00:  begin
                         //P
                     if((ADDRH >= 100 && ADDRH <= 110 && ADDRY >= 120 && ADDRY <= 360) ||
                        (ADDRH >= 110 && ADDRH <= 190 && ADDRY >= 120 && ADDRY <= 130) ||
                        (ADDRH >= 180 && ADDRH <= 190 && ADDRY >= 130 && ADDRY <= 200) ||
                        (ADDRH >= 110 && ADDRH <= 190 && ADDRY >= 200 && ADDRY <= 210) ||
                         //L            
                        (ADDRH >= 220 && ADDRH <= 230 && ADDRY >= 120 && ADDRY <= 360) ||
                        (ADDRH >= 230 && ADDRH <= 320 && ADDRY >= 350 && ADDRY <= 360) ||
                         //A               
                        (ADDRH >= 350 && ADDRH <= 360 && ADDRY >= 130 && ADDRY <= 360) ||
                        (ADDRH >= 360 && ADDRH <= 420 && ADDRY >= 120 && ADDRY <= 130) ||
                        (ADDRH >= 360 && ADDRH <= 420 && ADDRY >= 200 && ADDRY <= 210) ||
                        (ADDRH >= 420 && ADDRH <= 430 && ADDRY >= 130 && ADDRY <= 360) ||
                         //Y                 
                        (ADDRH >= 460 && ADDRH <= 470 && ADDRY >= 120 && ADDRY <= 200) ||
                        (ADDRH >= 470 && ADDRH <= 530 && ADDRY >= 200 && ADDRY <= 210) ||
                        (ADDRH >= 530 && ADDRH <= 540 && ADDRY >= 120 && ADDRY <= 350) ||
                        (ADDRH >= 470 && ADDRH <= 530 && ADDRY >= 350 && ADDRY <= 360))
                                            
                        COLOUR_OUT <= ColourCount;
                        else
                        COLOUR_OUT <= BLACK;
                        
                        SnakeVar <= SmallSnake;
                        Timed_Mode <= 0;
                     end
                                        
                  2'b01: begin   
                            
                     if(ADDRH[9:2] == SnakeState_X[0] && ADDRY[8:2] == SnakeState_Y[0])
                     COLOUR_OUT <= YELLOW;           
                     else if(ADDRH[9:2] == TARGET_ADDR_H && ADDRY[8:2] == TARGET_ADDR_V)
                     COLOUR_OUT <= RED;

                     else 
                     COLOUR_OUT <= BLUE;
                     for (i = 0; i < SnakeVar; i = i + 1) begin
                        if (ADDRH[9:2] == SnakeState_X[i] && ADDRY[8:2] == SnakeState_Y[i])
                        COLOUR_OUT <= YELLOW;
                     end
         
                     if (SnakeState_X[1] == TARGET_ADDR_H && SnakeState_Y[1] == TARGET_ADDR_V) begin
                          TARGET_REACHED <= 1; 
                          if(SnakeVar < SnakeLength)
                          SnakeVar <= SnakeVar + 1; 
                     end 
                    
                     else
                          TARGET_REACHED <= 0;
                           
                     if (MSM_STATE == 2'd1) begin     
                        if (GAME_IN)
                           Timed_Mode <= 1;
                        else if (LOST && GAME_IN)
                           Timed_Mode <= 0;
                        else if (WIN && GAME_IN)
                            Timed_Mode <= 0;
                     end
                     else if (GAME_IN == 0)
                        Timed_Mode <= 0;
                                              
                     end 
                                         
                   // Following is the code to make a colourful WIN screen                  
                                     
                   2'b10: begin

                       SnakeVar <= SmallSnake;
                       Timed_Mode <= 0;                 
                      if(ADDRY == 479) begin
                          FrameCount <= FrameCount + 1;  
                      end
                                        
                      if(ADDRY[8:0] > 240) begin
                          if(ADDRH > 320)
                              COLOUR_OUT <= FrameCount[15:8] + ADDRY[7:0] + ADDRH[7:0] -240 - 320;
                          else
                              COLOUR_OUT <= FrameCount[15:8] + ADDRY[7:0] - ADDRH[7:0] -240 + 320;
                      end
                      else begin
                          if(ADDRH > 320)
                              COLOUR_OUT <= FrameCount[15:8] - ADDRY[7:0] + ADDRH[7:0] + 240 - 320;
                          else
                              COLOUR_OUT <= FrameCount[15:8] - ADDRY[7:0] - ADDRH[7:0] + 240 + 320;
                      end
                    end
                    
                    //Red screen is displayed if the player lost
                    
                   2'b11:   begin
                    //COLOUR_OUT <= RED;
                    SnakeVar <= SmallSnake;
                    Timed_Mode <= 0;
                    end
                    
                endcase     
              end    
              
      // At this point the snake itself is generated 
      // and its initial position is determined.
      
      genvar PixNo;
      generate 
        for (PixNo = 0; PixNo < SnakeLength - 1; PixNo = PixNo + 1)
            begin: PixShift
                always@(posedge CLK) begin
                    if(RESET) begin
                        SnakeState_X[PixNo+1] <= 80;
                        SnakeState_Y[PixNo+1] <= 100;
                    end
                    
                    else if (TRIG_1 == 1) begin
                        SnakeState_X[PixNo+1] <= SnakeState_X[PixNo];
                        SnakeState_Y[PixNo+1] <= SnakeState_Y[PixNo];
                    end
                end
           end
      endgenerate
      
      // Here the position of the snake head is determined after RESET signal was received
      // After that the direction of the snake is identified by checking the state of the
      // Navigation_state_machine
      
      always@(posedge CLK) begin
        if(RESET) begin
            SnakeState_X[0] <= 80;
            SnakeState_Y[0] <= 100;
        end
        
        else if (TRIG_1 == 1) begin
            case (NAV_STATE)
                // UP
                2'b00 :begin
                    if(SnakeState_Y[0] == 0)
                        SnakeState_Y[0] <= MaxY;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] - 1;
                 end
                //RIGHT 
                2'b10 : begin
                    if(SnakeState_X[0] == MaxX)
                        SnakeState_X[0] <= 0;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] + 1;
                    end 
                //LEFT 
                2'b01 : begin
                    if(SnakeState_X[0] == 0)
                        SnakeState_X[0] <= MaxX;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] - 1;
                end
                //DOWN
                2'b11 :begin
                    if(SnakeState_Y[0] == MaxY)
                        SnakeState_Y[0] <= 0;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] + 1;
                    end
                
             endcase
        end
       end 
       
endmodule