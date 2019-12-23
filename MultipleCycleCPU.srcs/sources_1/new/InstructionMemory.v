`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sun Yat-sen University
// Engineer: Enze He
// 
// Create Date: 11/28/2019 10:41:40 AM
// Design Name: InstructionMemory
// Module Name: InstructionMemory
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

module InstructionMemory(
    input RW,
    input [31:0] IAddr,
    output reg [31:0] DataOut
    );
    
    reg [7:0] memory[0:95];
    
    initial begin
        $readmemb(`MEMORY_FILE_PATH, memory);
    end
    
    always @(IAddr or RW) begin
        if (RW) begin
            DataOut[31:24] = memory[IAddr];
            DataOut[23:16] = memory[IAddr + 1];
            DataOut[15:8] = memory[IAddr + 2];
            DataOut[7:0] = memory[IAddr + 3];
            $display("[Ins Mem] addr = %h, data = %h", IAddr, DataOut);
        end
    end
endmodule
