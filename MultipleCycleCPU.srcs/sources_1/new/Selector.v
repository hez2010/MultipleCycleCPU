`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Sun Yat-sen University
// Engineer: Enze He
//
// Create Date: 11/14/2019 9:32:16 PM
// Design Name: Selector
// Module Name: Selector
// Project Name: MultipleCycleCPU
// Target Devices: Basys3
// Tool Versions: 2019.1.3
// Description: Selectors
//
// Dependencies: -
//
// Revision: -
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Selector1In2#(
    parameter WIDTH = 5
)(
    input Sel,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output [WIDTH-1:0] Y);

    assign Y = Sel ? B : A;
endmodule