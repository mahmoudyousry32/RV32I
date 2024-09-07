
module Sign_extend(in,out,ExtendSrc);
input [24:0] in;
output [31:0] out;
input [2:0] ExtendSrc;

wire sign_bit = in[24];
localparam is_Itype_imm =  3'b000;
localparam is_Stype_imm =  3'b001;
localparam is_Btype_imm =  3'b010;
localparam is_Utype_imm =  3'b011;
localparam is_Jtype_imm =  3'b100;

reg [31:0] out;


always@*begin
    out = 32'b0;
    case(ExtendSrc)
    is_Itype_imm        :       out = {{20{sign_bit}},in[24:13]};
    is_Stype_imm        :       out = {{20{sign_bit}},in[24:18],in[4:0]};
    is_Btype_imm        :       out = {{19{sign_bit}},in[24],in[0],in[23:18],in[4:1]};
    is_Utype_imm        :       out = {in[24:5],12'b0};
    is_Jtype_imm        :       out = {{12{sign_bit}},in[12:5],in[13],in[23:14],1'b0};
    endcase
end



endmodule