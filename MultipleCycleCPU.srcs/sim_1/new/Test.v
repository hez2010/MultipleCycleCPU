`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/23 14:29:52
// Design Name: 
// Module Name: Test
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


module Test();
    reg CLK;
    reg RST;
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [4:0] Rd;
    wire [31:0] CurrentPC;
    wire [31:0] NextPC;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] ALUout;
    wire [31:0] DataOut;
    wire [2:0] State;
    wire [31:0] IDataOut;
    
    parameter CLK_CYCLE = 100;
    CPU cpu(CLK, RST, CurrentPC, NextPC, IDataOut, ReadData1, ReadData2, ALUout, DataOut, State, Rs, Rt, Rd);

    initial begin
        CLK = 0; RST = 0;
        #(CLK_CYCLE/2) RST = 1;
        forever #(CLK_CYCLE/2) CLK = ~CLK;
    end
endmodule
