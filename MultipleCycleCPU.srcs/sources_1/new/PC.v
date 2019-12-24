`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: 
// Module Name: PC
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
`include "Defines.v"

module PC(
    input CLK,
    input RST,
    input PCWre,
    input [31:0] PCAddr,
    output reg [31:0] NextPCAddr
    );

    initial NextPCAddr = 0;

    always @(posedge CLK or negedge RST) begin
        if (!RST) NextPCAddr <= 32'hFFFFFFFC;
        else if (PCWre || !PCAddr) NextPCAddr <= PCAddr;
    end
endmodule

module JumpPCHelper(
    input [31:0] PC,
    input [25:0] NextPCAddr,
    output reg [31:0] JumpPC);

    wire [27:0] tmp;
    assign tmp = NextPCAddr << 2; // address * 4

    always @(*) begin
        JumpPC[31:28] = PC[31:28];
        JumpPC[27:2] = tmp[27:2];
        JumpPC[1:0] = 0;
    end
endmodule

module NextPCHelper(
    input RST,
    input [1:0] PCSrc,
    input [31:0] PC,
    input [31:0] Immediate,
    input [31:0] RegPC,
    input [31:0] JumpPC,
    output reg [31:0] NextPC);

    always @(RST or PCSrc or PC or Immediate or RegPC or JumpPC) begin
        if (!RST) NextPC = PC + 4;
        else begin
            case (PCSrc)
                `PC_NEXT: NextPC = PC + 4;
                `PC_REL_JUMP: NextPC = PC + 4 + (Immediate << 2);
                `PC_REG_JUMP: NextPC = RegPC;
                `PC_ABS_JUMP: NextPC = JumpPC;
                default: NextPC = PC + 4;
            endcase
        end
    end
endmodule