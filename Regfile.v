`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 06:49:00 PM
// Design Name: 
// Module Name: Regfile
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


module Regfile(
    input clk,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input WE,
    output [31:0] RS1,
    output [31:0] RS2,
    input [31:0] WD
    );
    
    reg [31:0] REGFILE [1:31];
    
    always@(posedge clk)begin
    if(WE) REGFILE[A3] <= WD;
    end
    
    assign RS1 = !A1 ? 32'b0 : REGFILE[A1];
    assign RS2 = !A2 ? 32'b0 :REGFILE[A2];
    
endmodule
