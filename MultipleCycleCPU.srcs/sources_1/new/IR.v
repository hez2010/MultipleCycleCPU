`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2019 11:14:45 AM
// Design Name: 
// Module Name: IR
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


module IR(
    input CLK,
    input IRWre,
    input [31:0] DataIn,
    output reg [31:0] DataOut
    );
    always @(negedge CLK) begin
        if (IRWre) begin 
            $display("[IR] data = %h", DataIn);
            DataOut <= DataIn;
        end
    end
endmodule
