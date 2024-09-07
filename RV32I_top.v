`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 06:44:57 PM
// Design Name: 
// Module Name: RV32I_top
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


module RV32I_top(clk,rst);
input clk,rst;


wire [31:0] Instr;
wire Zero;
wire lt;
wire ltu;
wire RegFileWE;
wire ALUSrcB;
wire RS2MaskSrc;
wire StoreMemSrc;
wire ImmLoadSrc;
wire MemWE;
wire [3:0] ALUOp;
wire [1:0] RegFileWriteSrc;
wire RdMemMaskSrc;
wire [1:0] LoadSrc;
wire ExtendHW;
wire ExtendB;
wire PCAddSrc;
wire PCLoad;
wire [1:0] ExtendSrc;
wire [31:0] RS1;
wire [31:0] RS2;
wire [31:0] Result;

wire [4:0] A1;
wire [4:0] A2;
wire [4:0] A3;
wire [31:0] Regfile_WD;
wire [29:0] Data_Mem_addr = Result[31:2];
wire [31:0] Data_Mem_RD;
wire [31:0] Data_Mem_WD;
wire [29:0] IMEM_addr;
wire [31:0] IMEM_RD;
wire PC_next;
wire [31:0] Adder_result;
wire [31:0] Imm_ext;
wire [31:0] addr_op1;
wire [31:0] addr_op2;
reg [31:0] PC;
wire [31:0] SrcB ;
wire [1:0] byte_en = Result[1:0];
wire halfword_en = Result[1]; 
wire [31:0] RS2_Mask;
wire [31:0] RS2_Mask_shifted;
wire [31:0] RS2_shifted;
wire [31:0] RS2_Masked;
wire [31:0] RDMem_Mask;
wire [31:0] RDMem_Mask_shifted;
wire [31:0] RDMem_Masked;
wire [15:0] halfword;
wire [7:0] byte;
wire [31:0] Load_data;
wire [31:0] rd_hw_extend;
wire [31:0] rd_byte_extend;
wire [31:0] ImmediateLoad;
instructions_decoder  INSTRUCTION_DECODER(Instr,
                                          Zero,
                                          lt,
                                          ltu,
                                          RegFileWE,
                                          ALUSrcB,
                                          RS2MaskSrc,
                                          StoreMemSrc,
                                          ImmLoadSrc,
                                          MemWE,
                                          ALUOp,
                                          RegFileWriteSrc,
                                          RdMemMaskSrc,
                                          LoadSrc,
                                          ExtendHW,
                                          ExtendB,
                                          PCAddSrc,
                                          PCLoad,
                                          ExtendSrc
                                           );
                                           
 
ALU ALU_unit(.SrcA(RS1),.SrcB(RS2),.Result(Result),.ALUOp(ALUOp),.zero(Zero),.Lt(lt),.Ltu(ltu));

instruction_rom IMEM_unit(.addr(IMEM_addr),.RD(IMEM_RD));

Regfile Regfile_unit(
     .clk(clk),
     .A1(A1),
     .A2(A2),
     .A3(A3),
     .WE(RegFileWE),
     .RS1(RS1),
     .RS2(RS2),
     .WD(Regfile_WD)
    );
    
  Data_mem Memory_unit(
                    .clk(clk),
                    .WE(MemWE),
                    .addr(Data_Mem_addr),
                    .RD(Data_Mem_RD),
                    .WD(Data_Mem_WD)
                    );
                    
Sign_extend ImmEXTEND(.in(IMEM_RD[31:7]),.out(Imm_ext),.ExtendSrc(ExtendSrc));
assign IMEM_addr = PC[31:2];
assign RS2_Mask = !RS2MaskSrc ? 32'h00_00_00_ff : 32'h00_00_ff_ff;
assign RS2_Mask_shifted = byte_en == 2'b00 ? RS2_Mask :
                        byte_en == 2'b01 ? RS2_Mask << 8 :
                        byte_en == 2'b10 ? RS2_Mask << 16 :
                        RS2_Mask << 24 ;
assign RS2_shifted =    byte_en == 2'b00 ? RS2 :
                        byte_en == 2'b01 ? RS2 << 8 :
                        byte_en == 2'b10 ? RS2 << 16 :
                        RS2 << 24 ;
assign RDMem_Mask = !RdMemMaskSrc ? 32'hff_ff_ff_00 : 32'hff_ff_00_00;  
                     
assign RdMem_Mask_shifted =     byte_en == 2'b00 ? RDMem_Mask :
                                byte_en == 2'b01 ? RDMem_Mask << 8 :
                                byte_en == 2'b10 ? RDMem_Mask << 16 :
                                RDMem_Mask << 24 ;
assign RDMem_Masked = Data_Mem_RD & RDMem_Mask_shifted;
assign RS2_Masked = RS2_shifted & RS2_Mask_shifted;
assign Data_Mem_WD = !StoreMemSrc ? RS2 :  (RS2_Masked | RDMem_Masked);                                             
assign SrcB = !ALUSrcB ? RS2 : Imm_ext;
assign addr_op2 = Imm_ext;
assign addr_op1 = !PCAddSrc ? PC+4 : RS1 ;
assign Adder_Result = addr_op1 + addr_op2 ; 
assign PC_next = !PCLoad ? PC+4 : Adder_Result ;
assign halfword = !halfword_en ? Data_Mem_RD[15:0] : Data_Mem_RD[31:16];
assign byte = !byte_en[0] ? halfword[7:0] : halfword[15:8]; 
assign rd_byte_extend = ExtendB ? {{24{byte[7]}}, byte} : {24'b0 , byte};
assign rd_hw_extend = ExtendHW ? {{16{halfword[15]}},halfword} : {16'b0 , halfword};
assign Load_data = !LoadSrc ? Data_Mem_RD :
                   LoadSrc ==2'b01 ? rd_hw_extend :
                   LoadSrc == 2'b10 ?  rd_byte_extend : 32'b0;
assign ImmediateLoad = !ImmLoadSrc ? Imm_ext : Adder_Result ;
assign Regfile_WD = RegFileWriteSrc == 2'b00 ? Result :
                     RegFileWriteSrc == 2'b01 ? Load_data :
                     RegFileWriteSrc == 2'b10 ? PC + 4 : ImmediateLoad ;
         

 always@(posedge clk,posedge rst)
 if(rst) PC <= 32'h0000_0000;
 else 
    PC <= PC_next;

 
 
 


endmodule
