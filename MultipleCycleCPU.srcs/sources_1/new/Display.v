`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2019 9:43:28 AM
// Design Name: 
// Module Name: Display
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

module Display(
    input [2:0] Mode,
    input CLK,
    input [7:0] CurrentPC,
    input [7:0] NextPC,
    input [7:0] RsAddr,
    input [7:0] RsData,
    input [7:0] RtAddr,
    input [7:0] RtData,
    input [7:0] ALUResult,
    input [7:0] DBData,
    input [7:0] State,
    output reg [3:0] LEDNumber, // select LED
    output reg [6:0] LEDCode // display content code
    );

    reg [15:0] displayContent;
    reg [3:0] digital;
    integer selector = 0;

    always @(posedge CLK) begin
        case(Mode) 
            3'b000: displayContent <= {CurrentPC, NextPC};
            3'b001: displayContent <= {RsAddr, RsData};
            3'b010: displayContent <= {RtAddr, RtData};
            3'b011: displayContent <= {ALUResult, DBData};
            3'b100: displayContent <= {8'h00, State};
        endcase
      
        selector = (selector + 1) % 4;
        
        case(selector)
            0: digital = displayContent[3:0];
            1: digital = displayContent[7:4];
            2: digital = displayContent[11:8];
            3: digital = displayContent[15:12];
        endcase
    end

    always @(posedge CLK) begin
        case (digital) 
            4'h0: LEDCode <= 7'b0000001; 
            4'h1: LEDCode <= 7'b1001111; 
            4'h2: LEDCode <= 7'b0010010; 
            4'h3: LEDCode <= 7'b0000110; 
            4'h4: LEDCode <= 7'b1001100; 
            4'h5: LEDCode <= 7'b0100100; 
            4'h6: LEDCode <= 7'b0100000; 
            4'h7: LEDCode <= 7'b0001111; 
            4'h8: LEDCode <= 7'b0000000; 
            4'h9: LEDCode <= 7'b0000100; 
            4'hA: LEDCode <= 7'b0001000; 
            4'hB: LEDCode <= 7'b1100000; 
            4'hC: LEDCode <= 7'b0110001; 
            4'hD: LEDCode <= 7'b1000010; 
            4'hE: LEDCode <= 7'b0110000; 
            4'hF: LEDCode <= 7'b0111000; 
        endcase
    end

    always @(posedge CLK) begin
        LEDNumber = 4'b1111; // close all
        LEDNumber[3 - selector] = 0;
    end
endmodule