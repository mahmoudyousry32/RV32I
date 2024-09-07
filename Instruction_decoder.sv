module instructions_decoder(Instr,
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


input [31:0] Instr;
input Zero;
input lt;
input ltu;

//ALU OUTPUT Flags Zero , LT,LTU 
output RegFileWE;
output ALUSrcB;
output RS2MaskSrc;
output StoreMemSrc;
output ImmLoadSrc;
output MemWE;
output [2:0] ALUOp;
output [1:0] RegFileWriteSrc;
output RdMemMaskSrc;
output [1:0] LoadSrc;
output ExtendHW;
output ExtendB;
output PCAddSrc;
output PCLoad;
output [1:0] ExtendSrc;

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

wire [6:0] OpCode;
wire [6:0] Func7;
wire [2:0] Func3;
wire GE;
wire GEU;
assign GE = ~lt | Zero ;
assign GEU = ~ltu | Zero;


assign Opcode = Instr[6:0];
assign Func7  = Instr[31:25];
assign Func3  = Instr[14:12];

wire is_Itype;
wire is_Stype;
wire is_Btype;
wire is_Jtype;
wire is_Utype;
wire is_Rtype;

wire isAdd ;
wire isSub ;
wire isXor ;
wire isOr  ;
wire isAnd ;
wire isSll ;
wire isSrl ;
wire isSra ;
wire isSlt ;
wire isAddi ;
wire isXori ;
wire isOri ;
wire isAndi ;
wire isSlli ;
wire isSrli ;
wire isSrai ;
wire isSlti ;
wire isSltiu ;
wire isLB ;
wire isLH;
wire isLW ;
wire isLBU;
wire isLHU;
wire isSB;
wire isSH;
wire isSW;
wire isBeq;
wire isBne;
wire isBge;
wire isBltu;
wire isBgeu;
wire isJal;
wire isJalr;
wire isLui;
wire isAuipc;

assign isAdd = (Func3 == 0 && Func7 == 0 && OpCode == 7'b0110011);
assign isSub = (Func3 == 0 && Func7 == 7'h20 && OpCode == 7'b0110011);
assign isXor = (Func3 == 3'h4 && Func7 == 0 && OpCode == 7'b0110011);
assign isOr = (Func3 == 3'h6 && Func7 == 0 && OpCode == 7'b0110011);
assign isAnd = (Func3 == 3'h7 && Func7 == 0 && OpCode == 7'b0110011);
assign isSll = (Func3 == 3'h1 && Func7 == 0 && OpCode == 7'b0110011);
assign isSrl = (Func3 == 3'h5 && Func7 == 0 && OpCode == 7'b0110011);
assign isSra = (Func3 == 3'h5 && Func7 == 7'h20 && OpCode == 7'b0110011);
assign isSlt = (Func3 == 3'h2 && Func7 == 0 && OpCode == 7'b0110011);
assign isSltu = (Func3 == 3'h3 && Func7 == 0 && OpCode == 7'b0110011);


assign isAddi = (Func3 == 0 && OpCode == 7'b0010011);
assign isXori = (Func3 == 3'h4 && OpCode == 7'b0010011);
assign isOri = (Func3 == 3'h6 && OpCode == 7'b0010011);
assign isAndi = (Func3 == 3'h7 && OpCode == 7'b0010011);
assign isSlli = (Func3 == 3'h1 && Func7 == 7'h00 && OpCode == 7'b0010011);
assign isSrli = (Func3 == 3'h5 && Func7 == 7'h00 && OpCode == 7'b0010011);
assign isSrai = (Func3 == 3'h5 && Func7 == 7'h20 && OpCode == 7'b0010011);
assign isSlti = (Func3 == 3'h2 && OpCode == 7'b0010011);
assign isSltiu = (Func3 == 3'h3 && OpCode == 7'b0010011);
assign isLB = (Func3 == 3'h0 && OpCode == 7'b0000011);
assign isLH = (Func3 == 3'h1 && OpCode == 7'b0000011);
assign isLW = (Func3 == 3'h2 && OpCode == 7'b0000011);
assign isLBU = (Func3 == 3'h4 && OpCode == 7'b0000011);
assign isLHU = (Func3 == 3'h5 && OpCode == 7'b0000011);


assign isAddi = (Func3 == 0 && OpCode == 7'b0010011);
assign isXori = (Func3 == 3'h4 && OpCode == 7'b0010011);
assign isOri = (Func3 == 3'h6 && OpCode == 7'b0010011);
assign isAndi = (Func3 == 3'h7 && OpCode == 7'b0010011);
assign isSlli = (Func3 == 3'h1 && Func7 == 7'h00 && OpCode == 7'b0010011);
assign isSrli = (Func3 == 3'h5 && Func7 == 7'h00 && OpCode == 7'b0010011);
assign isSrai = (Func3 == 3'h5 && Func7 == 7'h20 && OpCode == 7'b0010011);
assign isSlti = (Func3 == 3'h2 && OpCode == 7'b0010011);
assign isSltiu = (Func3 == 3'h3 && OpCode == 7'b0010011);
assign isLB = (Func3 == 3'h0 && OpCode == 7'b0000011);
assign isLH = (Func3 == 3'h1 && OpCode == 7'b0000011);
assign isLW = (Func3 == 3'h2 && OpCode == 7'b0000011);
assign isLBU = (Func3 == 3'h4 && OpCode == 7'b0000011);
assign isLHU = (Func3 == 3'h5 && OpCode == 7'b0000011);

assign isSB = (Func3 == 3'h0 && OpCode == 7'b0100011);
assign isSH = (Func3 == 3'h1 && OpCode == 7'b0100011);
assign isSW = (Func3 == 3'h2 && OpCode == 7'b0100011);

assign isBeq = (Func3 == 3'h0 && OpCode == 7'b1100011); 
assign isBne = (Func3 == 3'h1 && OpCode == 7'b1100011);
assign isBlt = (Func3 == 3'h4 && OpCode == 7'b1100011);
assign isBge = (Func3 == 3'h5 && OpCode == 7'b1100011);
assign isBltu = (Func3 == 3'h6 && OpCode == 7'b1100011);
assign isBgeu = (Func3 == 3'h7 && OpCode == 7'b1100011);

assign isJal = (OpCode == 7'b1101111);
assign isJalr = (OpCode == 7'b1100111);

assign isLui = (OpCode == 7'b0110111); 
assign isAuipc = (OpCode == 7'b0010111);

assign is_Itype = OpCode == 7'b0010011 ||
                  OpCode == 7'b0000011 ;
assign is_Stype = OpCode == 7'b0100011;
assign is_Btype = OpCode == 7'b1100011;
assign is_Jtype = OpCode == 7'b1101111;
assign is_Utype = OpCode == 7'b0110111;
assign is_Rtype = OpCode == 7'b0110011;





assign RegFileWE = isAdd || isSub || isXor || isOr || isAdd || isSll ||
                   isSrl || isSra || isSlt || isSltu || isAddi || isXori||
                   isOri || isAndi || isSlli || isSrli || isSrai || isSlti ||
                   isSltiu || isLB || isLH || isLW || isLBU || isLHU || isJalr ||
                   isJal || isLui || isAuipc;



assign ExtendSrc = is_Itype ? 3'b000 : 
                   is_Stype ? 3'b001 :
                   is_Btype ? 3'b010 :
                   is_Jtype ? 3'b100 :
                   is_Utype ? 3'b011 :
                   3'b000 ;

assign ALUSrcB = is_Itype || is_Stype;

assign RS2MaskSrc = isSH ;
assign StoreMemSrc = isSH || isSB;
assign ImmLoadSrc = isAuipc ;
assign MemWE = is_Stype;
assign RegFileWriteSrc = is_Rtype ? 2'b00 :
                         is_Jtype ? 2'b10 :
                         is_Utype ? 2'b11 :
                         is_Itype && !OpCode[4] ? 2'b01 :
                         2'b00 ;
assign RdMemMaskSrc = isSH ;
assign LoadSrc = isLB || isLBU ? 2'b10 :
                 isLH || isLHU ? 2'b01 :
                 2'b00 ;

assign ExtendHW = isLH ;
assign ExtendB = isLB ;
assign PCAddSrc = isJalr ;
assign PCLoad = is_Jtype || 
               (isBeq && Zero) || (isBne && !Zero) ||
               (isBlt && LT)   || (isBge && GE)  ||
               (isBltu && LTU) || (isBgeu && GEU);


assign ALUOp = isAdd || isAddi ? ADD :
               isSub ? SUB :
               isXor || isXori ? XOR :
               isOr  || isOri  ? OR  :
               isAnd || isAndi ? AND :
               isSll || isSlli ? SLL :
               isSrl || isSrli ? SRL :
               isSra || isSrai ? SRA :
               isSlt || isSlti ? LT  :
               isSltu|| isSltiu? LTU :
               isBeq || isBne  ? SUB :
               isBlt || isBge  ? LT  :
               isBltu|| isBgeu ? LTU :
               NOP; 


endmodule