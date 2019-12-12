`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sun Yat-sen University
// Engineer: Enze He
// 
// Create Date: 12/12/2019 11:08:58 AM
// Design Name: State
// Module Name: State
// Project Name: MultipleCycleCPU
// Target Devices: Basys3
// Tool Versions: 2019.1.3
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module State (
    input CLK,
    input RST,
    input [2:0] StateIn,
    input [5:0] OpCode,
    output reg [2:0] StateOut
);

    always @(StateIn or OpCode) begin
        if (!RST) StateOut = `STATE_IF;
        else begin
            case (StateIn)
                `STATE_IF: StateOut = `STATE_ID;
                `STATE_ID: begin
                    if (OpCode == `OP_ADD || OpCode == `OP_SUB || OpCode == `OP_ADDIU ||
                        OpCode == `OP_AND || OpCode == `OP_ANDI || OpCode == `OP_ORI ||
                        OpCode == `OP_XORI || OpCode == `OP_SLL || OpCode == `OP_SLT ||
                        OpCode == `OP_SLTI) StateOut = `STATE_EXE_AL;
                    if (OpCode == `OP_BNE || OpCode == `OP_BEQ || OpCode == `OP_BLTZ) StateOut = `STATE_EXE_BR;
                    if (OpCode == `OP_SW || OpCode == `OP_LW) StateOut = STATE_EXE_LS;
                    if (OpCode == `OP_J || OpCode == `OP_JAL || OpCode == `OP_JR || 
                        OpCode == `OP_HALT) StateOut = `STATE_IF;
                end
                `STATE_EXE_AL: StateOut = `STATE_WB_AL;
                `STATE_EXE_BR: StateOut = `STATE_IF;
                `STATE_EXE_LS: StateOut = `STATE_MEM;
                `STATE_WB_AL: StateOut = `STATE_IF;
                `STATE_MEM: begin
                    if (OpCode == `OP_SW) StateOut = `STATE_IF;
                    if (OpCode == `OP_LW) StateOut = `STATE_WB_LD;
                end
                `STATE_WB_LD: StateOut = STATE_IF;
                default: StateOut = `STATE_IF;
            endcase
        end
    end
endmodule