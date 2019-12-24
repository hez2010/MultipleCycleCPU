`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2019 9:43:28 AM
// Design Name: 
// Module Name: DivClock
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

module DivClock(
  input CLK,
  output CLKOut
  );

  reg [16:0] counter;

  always @(posedge CLK) counter <= counter + 1;

  assign CLKOut = counter[16];
endmodule