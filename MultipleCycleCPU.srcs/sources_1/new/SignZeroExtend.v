`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sun Yat-sen University
// Engineer: Enze He
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: SignZeroExtend
// Module Name: SignZeroExtend
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


module SignZeroExtend(
    input ExtSel, // 0 - 0 extend, 1 - sign extend
    input [15:0] Immediate,
    output [31:0] DataOut
    );
    
    assign DataOut[15:0] = Immediate[15:0];
    assign DataOut[31:16] = (ExtSel && Immediate[15]) ? 16'hFFFF : 16'h0000;
endmodule
