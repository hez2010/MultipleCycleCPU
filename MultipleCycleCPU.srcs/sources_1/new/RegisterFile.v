`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input CLK,
    input RST,
    input WE,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
    );
    
    reg [31:0] register[1:31];
    integer i;

    assign ReadData1 = ReadReg1 == 0 ? 0 : register[ReadReg1];
    assign ReadData2 = ReadReg2 == 0 ? 0 : register[ReadReg2];

    always @(negedge CLK or negedge RST) begin
        if (!RST) begin
            for (i = 1; i < 32; i = i + 1) begin
                register[i] = 0;
            end
        end
        else if (WE && WriteReg) begin
            register[WriteReg] <= WriteData;
        end
    end
endmodule
