`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 07:06:45 PM
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(
    input clk,
    input WE,
    input [31:0] addr,
    output [31:0] RD,
    input [31:0] WD
    );
    parameter DEPTH = 8192; //32KB
    localparam ADDR_W = $clog2(DEPTH);
    reg [31:0] Mem [0:DEPTH - 1] ;
    
   wire [ADDR_W - 1 :0]mem_addr = addr[ADDR_W-1:0];
    always@(posedge clk) begin
    if(WE) Mem[mem_addr] <= WD;
    end
   
   assign RD = Mem[mem_addr] ;
    
    
endmodule
