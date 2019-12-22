`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sun Yat-sen University
// Engineer: Enze He
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: MultipleCycleCPU
// Module Name: ControlUnit
// Project Name: MultipleCycleCPU
// Target Devices: Basys3
// Tool Versions: 2019.2
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
    output reg PCWre,
    output reg IRWre,
    output reg InsMemRW,
    output reg mRD,
    output reg mWR,
    output reg WrRegDSrc,
    output reg RegWre,
    output reg ALUSrcA,
    output reg ALUSrcB,
    output reg [2:0] ALUOp,
    output reg DBDataSrc,
    output reg ExtSel,
    output reg [1:0] PCSrc,
    output reg [1:0] RegDst,
    output reg [2:0] State
    );
    
    initial begin
        PCWre = 1;
        IRWre = 0;
        InsMemRW = 1;
        mRD = 1;
        mWR = 1;
        WrRegDSrc = 1;
        RegWre = 1;
        ALUSrcA = 0;
        ALUSrcB = 0;
        ALUOp = 3'b000;
        DBDataSrc = 0;
        ExtSel = 0;
        PCSrc = 2'b00;
        State = 3'b000;
        RegDst = 2'b10;
    end

    // State Reg
    always @(posedge CLK or negedge RST) begin
        if (!RST) State <= `STATE_IF;
        else begin
            case (State)
                `STATE_IF: State <= `STATE_ID;
                `STATE_ID: begin
                    case (OpCode)
                        `OP_ADD, `OP_SUB, `OP_ADDIU, `OP_AND, `OP_ANDI, `OP_ORI, 
                        `OP_XORI, `OP_SLL, `OP_SLTI, `OP_SLT: State <= `STATE_EXE_AL;
                        `OP_BNE, `OP_BEQ, `OP_BLTZ: State <= `STATE_EXE_BR;
                        `OP_SW, `OP_LW: State <= `STATE_EXE_LS;
                        `OP_J, `OP_JAL, `OP_JR, `OP_HALT: State <= `STATE_IF;
                    endcase
                end
                `STATE_EXE_AL: State <= `STATE_WB_AL;
                `STATE_EXE_BR: State <= `STATE_IF;
                `STATE_EXE_LS: State <= `STATE_MEM;
                `STATE_WB_AL: State <= `STATE_IF;
                `STATE_MEM: begin
                    case (OpCode)
                        `OP_SW: State <= `STATE_IF;
                        `OP_LW: State <= `STATE_WB_LD;
                    endcase
                end
                `STATE_WB_LD: State <= `STATE_IF;
                default: State <= `STATE_IF;
            endcase
        end
    end

    // PCWre
    always @(negedge CLK) begin
        case (State)
            `STATE_ID: begin
                if (OpCode == `OP_J || OpCode == `OP_JAL || OpCode == `OP_JR) PCWre <= 1;
            end
            `STATE_EXE_AL, `STATE_EXE_BR, `STATE_EXE_LS: begin
                if (OpCode == `OP_BEQ || OpCode == `OP_BNE || OpCode == `OP_BLTZ) PCWre <= 1;
            end
            `STATE_MEM: begin
                if (OpCode == `OP_SW) PCWre <= 1;
            end
            `STATE_WB_AL, `STATE_WB_LD: PCWre <= 1;
            default: PCWre <= 0;
        endcase
    end

    always @(RST or State or Zero or Sign or OpCode) begin
        ALUSrcA = ((State == `STATE_EXE_AL || State == `STATE_EXE_BR || State == `STATE_EXE_LS) && OpCode == `OP_SLL) ? 1 : 0;
        ALUSrcB = ((State == `STATE_EXE_AL || State == `STATE_EXE_BR || State == `STATE_EXE_LS) && 
            (OpCode == `OP_ADDIU || OpCode == `OP_ANDI || 
            OpCode == `OP_ORI || OpCode == `OP_XORI || 
            OpCode == `OP_SLTI || OpCode == `OP_LW || 
            OpCode == `OP_SW)) ? 1 : 0;

        DBDataSrc = (OpCode == `OP_LW) ? 1 : 0; 
        RegWre = ((State == `STATE_ID && OpCode == `OP_JAL) || (State == `STATE_WB_AL || State == `STATE_WB_LD)) ? 1 : 0;
        WrRegDSrc = (State == `STATE_ID && OpCode == `OP_JAL) ? 0 : 1;

        mRD = (State == `STATE_MEM && OpCode == `OP_LW) ? 1 : 0;
        mWR = (State == `STATE_MEM && OpCode == `OP_SW) ? 1 : 0;

        ExtSel = ((State == `STATE_EXE_AL || State == `STATE_EXE_BR || State == `STATE_EXE_LS) && (OpCode == `OP_ANDI || OpCode == `OP_ORI || OpCode == `OP_XORI)) ? 0 : 1;

        if (State == `STATE_ID && OpCode == `OP_JAL) RegDst = 2'b00;
        else if ((State == `STATE_WB_AL || State == `STATE_WB_LD) && (OpCode == `OP_ADDIU || OpCode == `OP_ANDI || OpCode == `OP_ORI || OpCode == `OP_XORI || OpCode == `OP_SLTI || OpCode == `OP_LW)) RegDst = 2'b01;
        else RegDst = 2'b10;

        if (OpCode == `OP_HALT) PCWre = 0;
        IRWre = (State == `STATE_IF) ? 1 : 0;

        // PCSrc
        if ((State == `STATE_IF || State == STATE_ID) && OpCode == `OP_JR) PCSrc = 2'b10;
        else if ((State == `STATE_IF || State == STATE_ID) && (OpCode == `OP_J || OpCode == `OP_JAL)) PCSrc = 2'b11;
        else if ((State == `STATE_EXE_AL || State == `STATE_EXE_BR || State == `STATE_EXE_LS) && 
            (OpCode == `OP_BEQ && Zero) || (OpCode == `OP_BNE && !Zero) || (OpCode == `OP_BLTZ && Sign)) PCSrc = 2'b01;
        else PCSrc = 2'b00;

        // ALUOp
        case (OpCode)
            `OP_ADD, `OP_ADDIU, `OP_SW, `OP_LW: ALUOp = 3'b000;
            `OP_SUB, `OP_BEQ, `OP_BNE, `OP_BLTZ: ALUOp = 3'b001;
            `OP_SLL: ALUOp = 3'b010;
            `OP_ORI: ALUOp = 3'b011;
            `OP_AND, `OP_ANDI: ALUOp = 3'b100;
            `OP_SLTI, `OP_SLT: ALUOp = 3'b110;
            `OP_XORI: ALUOp = 3'b111;
        endcase
    end
endmodule
