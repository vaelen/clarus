        ; func natWriteRes  (JT slot 200)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local ref : -16(A6)  size 4
        ;   local wrote : -20(A6)  size 4
        ;   local failed : -22(A6)  size 2
        ;   local packedType : -26(A6)  size 4
        ;   local packedCreator : -30(A6)  size 4
LBL_0:
        LINK A6,#-82
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.B D0,-22(A6)
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
        MOVEQ #0,D0
        MOVE.L D0,-30(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 66(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_49
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_32(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_48
LBL_49:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 66(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-30(A6)
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_50
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_48
LBL_50:
        JSR 1514(A5)
        MOVE.L -7394(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7394(A5),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_51
        MOVE.L -7394(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_51:
        MOVE.L -7394(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -7394(A5),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_52
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_48
LBL_52:
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.B D0,-22(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_53
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; NatHLock
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7394(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; NatHUnlock
        MOVE.L -7394(A5),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_54
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_54:
LBL_53:
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        JSR 1522(A5)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_55
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_56
LBL_55:
        MOVEQ #1,D0
LBL_56:
        TST.L D0
        BEQ.W LBL_57
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_30(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_48
LBL_57:
        MOVEQ #1,D0
        BRA.W LBL_48
LBL_48:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 201)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_1:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #84,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_59
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_59:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
        MOVEQ #86,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_58:
        UNLK A6
        RTS
        ; func narrowRet  (JT slot 202)
LBL_2:
        LINK A6,#-52
        MOVE.L #65535,D0
        BRA.W LBL_60
LBL_60:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 203)
        ;   local a : -2(A6)  size 2
        ;   local s : -4(A6)  size 2
        ;   local u : -6(A6)  size 2
        ;   local r : -16(A6)  size 10
        ;   local arr : -22(A6)  size 6
        ;   local l : -26(A6)  size 4
        ;   local m : -30(A6)  size 4
        ;   local i : -34(A6)  size 4
LBL_3:
        LINK A6,#-102
        MOVEQ #0,D0
        MOVE.B D0,-2(A6)
        MOVEQ #0,D0
        MOVE.W D0,-4(A6)
        MOVEQ #0,D0
        MOVE.W D0,-6(A6)
        MOVEQ #0,D0
        MOVE.B D0,-16(A6)
        MOVEQ #0,D0
        MOVE.W D0,-14(A6)
        MOVEQ #0,D0
        MOVE.W D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.W D0,-22(A6)
        MOVEQ #0,D0
        MOVE.W D0,-20(A6)
        MOVEQ #0,D0
        MOVE.W D0,-18(A6)
        LEA -26(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #2,-(A7)
        JSR 202(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -30(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #2,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        MOVE.L #200,D0
        MOVE.B D0,-2(A6)
        MOVE.L #32768,D0
        NEG.L D0
        MOVE.W D0,-4(A6)
        MOVE.L #65535,D0
        MOVE.W D0,-6(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        MOVE.B D0,-7416(A5)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.W D0,-7418(A5)
        CLR.L D0
        MOVE.B -2(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 2(A0),A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        CLR.L D0
        MOVE.W -6(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -22(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_44
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.W -6(A6),D0
        MOVE.W D0,-38(A6)
        LEA -38(A6),A0
        MOVE.L A0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -30(A6),D0
        MOVE.L D0,-38(A6)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.W D0,-42(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        LEA -42(A6),A0
        MOVE.L A0,-(A7)
        JSR 458(A5)
        ADDA.W #12,A7
        MOVE.L -30(A6),D0
        MOVE.L D0,-38(A6)
        MOVEQ #7,D0
        MOVE.W D0,-42(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        LEA -42(A6),A0
        MOVE.L A0,-(A7)
        JSR 458(A5)
        ADDA.W #12,A7
        MOVEQ #9,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_62
        BRA.W LBL_63
LBL_62:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_63:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_44
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        CLR.L D0
        MOVE.B -2(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.W -6(A6),D0
        MOVE.L D0,-(A7)
        JSR 1626(A5)
        ADDA.W #12,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-34(A6)
        MOVE.L -34(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 0(A0),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 2(A0),A0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -22(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_44
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_64
        BRA.W LBL_65
LBL_64:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_65:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_44
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVE.L D0,-38(A6)
        LEA LBL_34(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-42(A6)
        MOVEQ #0,D0
        MOVE.W D0,-46(A6)
        MOVE.W -46(A6),D0
        MOVE.W D0,-50(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -42(A6),D0
        MOVE.L D0,-(A7)
        LEA -50(A6),A0
        MOVE.L A0,-(A7)
        JSR 474(A5)
        ADDA.W #12,A7
        MOVE.W -50(A6),D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-34(A6)
        MOVE.L -34(A6),D0
        ANDI.L #255,D0
        MOVE.B D0,-2(A6)
        MOVE.L -34(A6),D0
        EXT.L D0
        MOVE.W D0,-4(A6)
        MOVE.L -34(A6),D0
        ANDI.L #65535,D0
        MOVE.W D0,-6(A6)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        LEA -26(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-58(A6)
LBL_66:
        MOVE.L A1,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -30(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-58(A6)
LBL_67:
        MOVE.L A1,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 442(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_61:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 204)
        ;   param slot : 8(A6)  size 4
LBL_4:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_69
        BRA.W LBL_70
LBL_69:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_71
        BRA.W LBL_72
LBL_71:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_73
        BRA.W LBL_74
LBL_73:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_75
        BRA.W LBL_76
LBL_75:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_77
        BRA.W LBL_78
LBL_77:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_79
        BRA.W LBL_80
LBL_79:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_81
        BRA.W LBL_82
LBL_81:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_83
LBL_83:
LBL_82:
LBL_80:
LBL_78:
LBL_76:
LBL_74:
LBL_72:
LBL_70:
LBL_68:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 205)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_5:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_85
        BRA.W LBL_86
LBL_85:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_87
        BRA.W LBL_88
LBL_87:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_89
        BRA.W LBL_90
LBL_89:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_91
        BRA.W LBL_92
LBL_91:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_93
        BRA.W LBL_94
LBL_93:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_95
        BRA.W LBL_96
LBL_95:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_97
        BRA.W LBL_98
LBL_97:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_99
LBL_99:
LBL_98:
LBL_96:
LBL_94:
LBL_92:
LBL_90:
LBL_88:
LBL_86:
LBL_84:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 206)
        ;   param slot : 8(A6)  size 4
LBL_6:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_101
        BRA.W LBL_102
LBL_101:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_103
        BRA.W LBL_104
LBL_103:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_105
        BRA.W LBL_106
LBL_105:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        BRA.W LBL_108
LBL_107:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_109
        BRA.W LBL_110
LBL_109:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_111
        BRA.W LBL_112
LBL_111:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_113
        BRA.W LBL_114
LBL_113:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_115
LBL_115:
LBL_114:
LBL_112:
LBL_110:
LBL_108:
LBL_106:
LBL_104:
LBL_102:
LBL_100:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 207)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_7:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_117
        BRA.W LBL_118
LBL_117:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_119
        BRA.W LBL_120
LBL_119:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
        BRA.W LBL_122
LBL_121:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_123
        BRA.W LBL_124
LBL_123:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_125
        BRA.W LBL_126
LBL_125:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_127
        BRA.W LBL_128
LBL_127:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_129
        BRA.W LBL_130
LBL_129:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
LBL_131:
LBL_130:
LBL_128:
LBL_126:
LBL_124:
LBL_122:
LBL_120:
LBL_118:
LBL_116:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 208)
LBL_8:
        LINK A6,#-52
LBL_132:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 209)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_134
        BRA.W LBL_135
LBL_134:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_136
LBL_136:
LBL_135:
LBL_133:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 210)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_10:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_138
        BRA.W LBL_139
LBL_138:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_140
LBL_140:
LBL_139:
LBL_137:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 211)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_11:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_142
        BRA.W LBL_143
LBL_142:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_144
LBL_144:
LBL_143:
LBL_141:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 212)
        ;   param slot : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_146
        BRA.W LBL_147
LBL_146:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
LBL_148:
LBL_147:
LBL_145:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 213)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_13:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_150
        BRA.W LBL_151
LBL_150:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_152
LBL_152:
LBL_151:
LBL_149:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 214)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_14:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        BRA.W LBL_155
LBL_154:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_156
LBL_156:
LBL_155:
LBL_153:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 215)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_15:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_158
        BRA.W LBL_159
LBL_158:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_160
LBL_160:
LBL_159:
LBL_157:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 216)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_16:
        LINK A6,#-52
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDQ.L #4,A7
        BSR.W LBL_47
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #4,A7
LBL_161:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 217)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_17:
        LINK A6,#-52
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDQ.L #4,A7
        BSR.W LBL_47
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #4,A7
LBL_162:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 218)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_18:
        LINK A6,#-52
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDQ.L #4,A7
        BSR.W LBL_47
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #4,A7
LBL_163:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 219)
        ;   param idx : 8(A6)  size 4
LBL_19:
        LINK A6,#-52
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDQ.L #4,A7
        BSR.W LBL_47
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #4,A7
LBL_164:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 220)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDQ.L #4,A7
        BSR.W LBL_47
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #4,A7
LBL_165:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 221)
        ;   param rowsIdx : 8(A6)  size 4
LBL_21:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #153,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_167
        LEA -7096(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_166
        BRA.W LBL_168
LBL_167:
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDQ.L #4,A7
        BSR.W LBL_47
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_166
LBL_168:
LBL_166:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 222)
        ;   param path : 8(A6)  size 4
LBL_22:
        LINK A6,#-52
LBL_169:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 223)
LBL_23:
        LINK A6,#-52
LBL_170:
        UNLK A6
        RTS
        ; func clar_ui_fire_logop  (JT slot 224)
        ;   param op : 24(A6)  size 4
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_24:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_171
LBL_171:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 225)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_25:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_172
LBL_172:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 226) -- pascal callback glue for aeQuitHandler
LBL_26:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 898(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 227) -- pascal callback glue for aeOappHandler
LBL_27:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 906(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 228) -- pascal callback glue for rtUiScrollbarAction
LBL_28:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1082(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 229) -- pascal callback glue for rtUiLdefDraw
LBL_29:
        LINK A6,#0
        ;   msg : 26(A6)  pascal size 2
        MOVE.W 26(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        ;   select : 24(A6)  pascal size 2
        CLR.L D0
        MOVE.B 24(A6),D0
        MOVE.B D0,-(A7)
        ;   rectPtr : 20(A6)  pascal size 4
        MOVE.L 20(A6),-(A7)
        ;   cellPacked : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   dataOffset : 14(A6)  pascal size 2
        MOVE.W 14(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        ;   dataLen : 12(A6)  pascal size 2
        MOVE.W 12(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        ;   lh : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1154(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_44:
        ; cg_mul32: D1=left * D0=right -> D0 (32x32->32, MULU partial products)
        MOVE.L D2,-(A7)
        MOVE.L D3,-(A7)
        MOVE.L D4,-(A7)
        MOVE.L D1,D2
        MOVE.L D0,D3
        MULU.W D3,D2
        MOVE.L D1,D4
        SWAP D4
        MULU.W D3,D4
        SWAP D4
        CLR.W D4
        ADD.L D4,D2
        MOVE.L D3,D4
        SWAP D4
        MULU.W D1,D4
        SWAP D4
        CLR.W D4
        ADD.L D4,D2
        MOVE.L D2,D0
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_45:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_173
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_173:
        MOVE.L D2,-(A7)
        MOVE.L D3,-(A7)
        MOVE.L D4,-(A7)
        MOVE.L D5,-(A7)
        MOVE.L D6,-(A7)
        MOVE.L D7,-(A7)
        MOVE.L D1,D2
        MOVE.L D0,D3
        CLR.L D4
        TST.L D2
        BPL.W LBL_174
        NEG.L D2
        MOVE.L #1,D4
LBL_174:
        CLR.L D5
        TST.L D3
        BPL.W LBL_175
        NEG.L D3
        MOVE.L #1,D5
LBL_175:
        CLR.L D6
        MOVE.W #31,D7
LBL_176:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_177
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_177:
        DBRA D7,LBL_176
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_178
        NEG.L D2
LBL_178:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_46:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_179
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_179:
        MOVE.L D2,-(A7)
        MOVE.L D3,-(A7)
        MOVE.L D4,-(A7)
        MOVE.L D5,-(A7)
        MOVE.L D6,-(A7)
        MOVE.L D7,-(A7)
        MOVE.L D1,D2
        MOVE.L D0,D3
        CLR.L D4
        TST.L D2
        BPL.W LBL_180
        NEG.L D2
        MOVE.L #1,D4
LBL_180:
        CLR.L D5
        TST.L D3
        BPL.W LBL_181
        NEG.L D3
        MOVE.L #1,D5
LBL_181:
        CLR.L D6
        MOVE.W #31,D7
LBL_182:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_183
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_183:
        DBRA D7,LBL_182
        TST.L D4
        BEQ.W LBL_184
        NEG.L D6
LBL_184:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_47:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_185(PC),A0
        MOVE.L A0,-4(A6)
LBL_186:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_187
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_188
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_186
LBL_188:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_189:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_186
LBL_187:
        UNLK A6
        RTS
LBL_185:
        DC.W $E606
        DC.W $0000
        DC.W $E60A
        DC.W $0000
        DC.W $E60E
        DC.W $0000
        DC.W $E612
        DC.W $0000
        DC.W $E616
        DC.W $0000
        DC.W $E61A
        DC.W $0000
        DC.W $E61E
        DC.W $0000
        DC.W $E622
        DC.W $0000
        DC.W $E448
        DC.W $0001
        DC.W $0000
        DC.W $0000
        ; constant pool: string literals
LBL_43:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_32:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_33:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_31:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_30:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_34:
        DC.B $01
        DC.B $6B
LBL_35:
        DC.B $01
        DC.B $6A
LBL_42:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_36:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_37:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_38:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_39:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_40:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_41:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
