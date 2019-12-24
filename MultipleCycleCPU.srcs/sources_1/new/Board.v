`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2019 11:53:18 AM
// Design Name: 
// Module Name: Board
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


module Board(
    input CLK,
    input KeyCLK,
    input RST,
    input [2:0] Mode,
    output [3:0] LEDNumber,
    output [6:0] LEDCode
);

    wire CLKOut;
    wire DivCLK;
    
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [4:0] Rd;
    wire [31:0] CurrentPC;
    wire [31:0] NextPC;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] ALUout;
    wire [31:0] DBDataOut;
    wire [2:0] State;
    wire [31:0] IDataOut;

    DivClock divc(CLK, DivCLK);
    Key key(DivCLK, KeyCLK, CLKOut);
    Display display(Mode, DivCLK, CurrentPC[7:0], NextPC[7:0], {3'b000, Rs}, ReadData1[7:0], {3'b000, Rt}, ReadData2[7:0], ALUout[7:0], DBDataOut[7:0], {5'b00000, State[2:0]}, LEDNumber, LEDCode);
    CPU cpu(CLKOut, RST, CurrentPC, NextPC, IDataOut, ReadData1, ReadData2, ALUout, DBDataOut, State, Rs, Rt, Rd);
    
endmodule