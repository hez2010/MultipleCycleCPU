`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: 
// Module Name: BDR
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


module BDR(
    input CLK,
    input [31:0] DataIn;
    output reg [31:0] DataOut;
    );

    always @(negedge CLK) DataOut <= DataIn;
endmodule
