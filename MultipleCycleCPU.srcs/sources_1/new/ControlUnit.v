`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input [5:0] OpCode,
    input CLK,
    input RST,
    input Zero,
    input Sign,
    output PCWre,
    output IRWre,
    output InsMemRW,
    output mRD,
    output mWR,
    output WrRegDSrc,
    output RegWre,
    output ALUSrcA,
    output ALUSrcB,
    output [2:0] ALUOp,
    output DBDataSrc,
    output ExtSel,
    output [0:0] PCSrc,
    output [2:0] State
    );
    
endmodule
