`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2019 01:08:43 AM
// Design Name: 
// Module Name: CPU
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

module CPU(
    input CLK,
    input RST,
    output [31:0] CurrentPC,
    output [31:0] NextPC,
    output [31:0] IDataOut,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    output [31:0] ALUOut,
    output [31:0] DBDataOut,
    output [2:0] State,
    output [4:0] Rs,
    output [4:0] Rt,
    output [4:0] Rd
);

    // -- CU begin
    wire Zero, Sign, PCWre, IRWre, InsMemRW, mRD, mWR, WrRegDSrc, RegWre, ALUSrcA, ALUSrcB;
    wire [2:0] ALUOp;
    wire DBDataSrc, ExtSel;
    wire [1:0] PCSrc, RegDst;
    wire [2:0] State_T;
    // -- CU end

    wire [31:0] IAddress, IDataOut_T, InsOut, ExtendDataOut;
    wire [31:0] DBDRDataIn, DBDRDataOut;
    wire [4:0] WriteReg;
    wire [31:0] WriteData;
    wire [31:0] JumpPC, NextPC_T;
    wire [31:0] ADROut, BDROut, ExtendSa, ALUoutDROut, A, B, Result, DBDataOut_T;
    wire [31:0] ReadData1_T, ReadData2_T;

    PC pc(CLK, RST, PCWre, NextPC, IAddress);
    InstructionMemory im(InsMemRW, IAddress, IDataOut_T);
    IR ir(CLK, IRWre, IDataOut_T, InsOut);
    ControlUnit cu(InsOut[31:26], CLK, RST, Zero, Sign, PCWre, IRWre, InsMemRW, mRD, mWR, WrRegDSrc, RegWre, ALUSrcA, ALUSrcB, ALUOp, DBDataSrc, ExtSel, PCSrc, RegDst, State_T);
    Selector1In3#(5) wr(RegDst, 5'b11111, InsOut[20:16], InsOut[15:11], WriteReg);
    Selector1In2#(32) wd(WrRegDSrc, IAddress + 4, DBDRDataOut, WriteData);
    RegisterFile regFile(CLK, RST, RegWre, InsOut[25:21], InsOut[20:16], WriteReg, WriteData, ReadData1_T, ReadData2_T);
    SignZeroExtend szExtend(ExtSel, InsOut[15:0], ExtendDataOut);

    JumpPCHelper jPC(IAddress, InsOut[25:0], JumpPC);
    NextPCHelper nPC(RST, PCSrc, IAddress, ExtendDataOut, ReadData1_T, JumpPC, NextPC_T);

    ADR adr(CLK, ReadData1_T, ADROut);
    BDR bdr(CLK, ReadData2_T, BDROut);

    assign ExtendSa = {27'b000000000000000000000000000, InsOut[10:6]};
    Selector1In2#(32) sa(ALUSrcA, ADROut, ExtendSa, A);
    Selector1In2#(32) sb(ALUSrcB, BDROut, ExtendDataOut, B);
    ALU alu(ALUOp, A, B, Sign, Zero, Result);
    ALUoutDR aodr(CLK, Result, ALUoutDROut);
    DataMemory dm(CLK, mRD, mWR, ALUoutDROut, BDROut, DBDataOut_T);
    Selector1In2#(32) sDBData(DBDataSrc, Result, DBDataOut_T, DBDRDataIn);
    DBDR dbdr(CLK, DBDRDataIn, DBDRDataOut);

    assign CurrentPC = IAddress;
    assign NextPC = NextPC_T;
    assign IDataOut = IDataOut_T;
    assign ReadData1 = ReadData1_T;
    assign ReadData2 = ReadData2_T;
    assign Rs = InsOut[25:21];
    assign Rt = InsOut[20:16];
    assign Rd = InsOut[15:11];
    assign ALUOut = Result;
    assign DBDataOut = DBDataOut_T;
    assign State = State_T;
endmodule