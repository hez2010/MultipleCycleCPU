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
// Tool Versions: 2019.2
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

module Selector1In3#(
    parameter WIDTH = 5
)(
    input [1:0] Sel,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input [WIDTH-1:0] C,
    output reg [WIDTH-1:0] Y);

    always @(Sel or A or B or C) begin
        case (Sel)
            2'b00: Y <= A;
            2'b01: Y <= B;
            2'b10: Y <= C;
            default: Y <= 0;
        endcase
    end
    
endmodule