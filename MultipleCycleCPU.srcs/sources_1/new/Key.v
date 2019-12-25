`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2019 9:43:28 AM
// Design Name: 
// Module Name: Key
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

module Key(
    input CLK,
    input KeyWre,
    output reg CLKOut
    );

    always @(posedge CLK) begin
        CLKOut <= KeyWre ? 0 : 1;
    end
endmodule