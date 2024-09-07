module ALU(SrcA,SrcB,Result,ALUOp,zero,Lt,Ltu);

input signed [31:0] SrcA; //RS1
input signed [31:0] SrcB; //RS2
input [3:0] ALUOp; 


output [31:0] Result;
output zero ;
output Lt ;
output Ltu;

localparam ADD = 4'b0000;
localparam SUB = 4'b0001;
localparam AND = 4'b0010;
localparam OR  = 4'b0011;
localparam XOR = 4'b0100;
localparam SLL = 4'b0101;
localparam SRL = 4'b0110;
localparam SRA = 4'b0111;
localparam LT = 4'b1000;
localparam LTU = 4'b1001;
localparam NOP = 4'b1010;



wire overflow ;
wire Lt;
wire Ltu;
wire Shift_L_R;
wire CompareOp;
wire Arith_Shift;
wire [1:0] LogicOp;
wire [31:0] LogicOp_Result;
wire [31:0] Shift_Result;
wire [31:0] Compare_result;
wire [4:0] Shift_amount;
wire [32:0] Sub_Add_Result;
wire [31:0] and_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire add_sub_en;


wire logicalOp_src = ALUOp == AND || ALUOp == OR || ALUOp == XOR;
wire arithmatic_src    = ALUOp == ADD || ALUOp == SUB;
wire shift_src		= ALUOp == SLL || ALUOp == SRL || ALUOp == SRA;
wire compare_src  = ALUOp == LT || ALUOp == LTU ;

assign add_sub_en = ALUOp == ADD ; //if ALUOp == ADD then A+B else A-B
assign LogicOp = ALUOp[1:0];
assign Shift_L_R = ALUOp == SLL;
assign Arith_Shift = ALUOp == SRA ;
assign CompareOp = ALUOp[0];

wire [31:0] SrcB_Signed = add_sub_en ? SrcB : (~SrcB) + 32'b1 ;
assign Sub_Add_Result = add_sub_en ? SrcA + SrcB : SrcA + SrcB_Signed;
assign overflow = ((SrcA[31] & SrcB_Signed[31] & ~Sub_Add_Result[31]) || (~SrcA[31] & ~SrcB_Signed[31] & Sub_Add_Result[31]));
//Comparator 
assign zero = !Sub_Add_Result;
assign Lt = overflow ^ Sub_Add_Result[31];
assign Ltu = ~Sub_Add_Result[32];


//Shift Control signals "Shift_L_R" , "Arith_Shift"
assign Shift_amount = SrcB[4:0];
assign Shift_Result = Shift_L_R ? SrcA << Shift_amount ://If Left shift then dont check if the shift is arithmatic or not
					  Arith_Shift ? SrcA >>> Shift_amount : 					// IF Arith_Shift = 1 then its an arithmatic shift else its a logical right shift
					  SrcA >> Shift_amount;

//Logical Operations ,Control signal "LogicOp" 
assign LogicOp_Result = LogicOp == 2'b00 ? SrcA ^ SrcB :								
						LogicOp == 2'b10 ? SrcA & SrcB :				
						LogicOp == 2'b11 ? SrcA | SrcB : 32'b0;	

assign Compare_result = CompareOp ? {31'b0,Ltu} : {31'b0,Lt};

assign Result = arithmatic_src ? Sub_Add_Result[31:0] :
				logicalOp_src  ? LogicOp_Result :
				shift_src      ? Shift_Result   :
				compare_src    ? Compare_result : 
				32'b0 ;
																		

endmodule