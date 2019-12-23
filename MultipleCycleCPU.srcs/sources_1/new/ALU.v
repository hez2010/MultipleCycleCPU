`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: 
// Module Name: ALU
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
`include "defines.v"

module ALU(
    input [2:0] ALUOp,
    input [31:0] A,
    input [31:0] B,
    output Sign,
    output Zero,
    output reg [31:0] Result
    );

    always @(*) begin
        case (ALUOp)
            `ALU_OP_ADD: Result = (A + B);
            `ALU_OP_SUB: Result = (A - B);
            `ALU_OP_SLL: Result = (B << A);
            `ALU_OP_OR: Result = (A | B);
            `ALU_OP_AND: Result = (A & B);
            `ALU_OP_LT: Result = (A < B) ? 1 : 0;
            `ALU_OP_SLT: Result = (((A < B) && (A[31] == B[31])) || ((A[31] && !B[31]))) ? 1 : 0;
            `ALU_OP_XOR: Result = (A ^ B);
            default: Result = 0;
        endcase
    end
    
    assign Zero = (Result == 0) ? 1 : 0;
    assign Sign = Result[31];
    
endmodule
