`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2024 03:10:07 AM
// Design Name: 
// Module Name: instruction_rom
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


module instruction_rom(
    input [29:0] addr,
    output [31:0] RD
    );
    parameter I_MEMSIZE = 100;
    reg [31:0] I_MEM [0:I_MEMSIZE - 1] ;
    initial 
    $readmemh("instructions.mem", I_MEM);
    
    assign RD = I_MEM[addr];
endmodule
