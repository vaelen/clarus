        ; func natFileWriteText  (JT slot 202)
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
        LINK A6,#-2130
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
        BEQ.W LBL_56
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_30(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_55
LBL_56:
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
        BEQ.W LBL_57
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_55
LBL_57:
        JSR 1602(A5)
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1576(A5),D1
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
        BEQ.W LBL_58
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_58:
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -1576(A5),D1
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
        BEQ.W LBL_59
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_32(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_55
LBL_59:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
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
        BEQ.W LBL_60
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
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -1576(A5),D1
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
        MOVE.L -1576(A5),D1
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
        BEQ.W LBL_61
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_61:
LBL_60:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        JSR 1610(A5)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_62
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_63
LBL_62:
        MOVEQ #1,D0
LBL_63:
        TST.L D0
        BEQ.W LBL_64
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_29(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_55
LBL_64:
        MOVEQ #1,D0
        BRA.W LBL_55
LBL_55:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 203)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_1:
        LINK A6,#-2120
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
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_66:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_67
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #47,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_68
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_68:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_66
LBL_67:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_69:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_70
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_69
LBL_70:
LBL_65:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 204)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_2:
        LINK A6,#-2120
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
        CLR.L -(A7)
        MOVE.L #1129072211,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A820  ; NatGet1NamedResource
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_72
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_71
LBL_72:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A025  ; NatGetHandleSize
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; NatHLock
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_73
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
LBL_73:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; NatHUnlock
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_71
LBL_71:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 205)
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
LBL_3:
        LINK A6,#-2130
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
        BEQ.W LBL_75
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_30(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_74
LBL_75:
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
        BEQ.W LBL_76
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_74
LBL_76:
        JSR 1602(A5)
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1576(A5),D1
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
        BEQ.W LBL_77
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_77:
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -1576(A5),D1
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
        BEQ.W LBL_78
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_32(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_74
LBL_78:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
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
        BEQ.W LBL_79
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
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -1576(A5),D1
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
        MOVE.L -1576(A5),D1
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
        BEQ.W LBL_80
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_80:
LBL_79:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        JSR 1610(A5)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_81
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_82
LBL_81:
        MOVEQ #1,D0
LBL_82:
        TST.L D0
        BEQ.W LBL_83
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_29(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_74
LBL_83:
        MOVEQ #1,D0
        BRA.W LBL_74
LBL_74:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 206)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_4:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1618(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_85
        MOVEQ #1,D0
        BRA.W LBL_84
LBL_85:
        MOVEQ #0,D0
        BRA.W LBL_84
LBL_84:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 207)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_5:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 1530(A5)
        MOVE.L -1582(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_87
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1582(A5)
LBL_87:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1582(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -1582(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -1582(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
        ADDQ.L #8,A7
        JSR 1522(A5)
LBL_86:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 208)
LBL_6:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -1584(A5),D0
        TST.L D0
        BEQ.W LBL_89
        BRA.W LBL_88
LBL_89:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1588(A5)
        MOVE.L -1588(A5),D1
        MOVE.L #202,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A86E  ; NatInitGraf
        DC.W $A8FE  ; NatInitFonts
        DC.W $A036  ; NatMoreMasters
        DC.W $A912  ; NatInitWindows
        DC.W $A036  ; NatMoreMasters
        DC.W $A930  ; NatInitMenus
        DC.W $A036  ; NatMoreMasters
        DC.W $A9CC  ; NatTEInit
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A97B  ; NatInitDialogs
        MOVEQ #1,D0
        MOVE.B D0,-1584(A5)
        DC.W $A850  ; NatInitCursor
LBL_88:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 209)
        ;   param out : 8(A6)  size 4
LBL_7:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
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
        MOVE.L -1588(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_90:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 210)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_8:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1588(A5),D1
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
        BEQ.W LBL_92
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_92:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
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
        MOVE.L -1588(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_91:
        UNLK A6
        RTS
        ; func clearDeepRun  (JT slot 211)
        ;   local l : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local sm : -12(A6)  size 4
        ;   local im : -16(A6)  size 4
LBL_9:
        LINK A6,#-2136
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 202(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 434(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 586(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_95:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_94
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_95
LBL_94:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #6,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 482(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_96
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 474(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_96:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 482(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_97
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 474(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_97:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_99:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_98
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        LEA -2104(A6),A0
        MOVE.L A0,-(A7)
        JSR 506(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2104(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_99
LBL_98:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 498(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #6,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_100
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_100:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 1450(A5)
        ADDA.W #12,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_101
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 1458(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_101:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 1450(A5)
        ADDA.W #12,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_103:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_102
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        LEA -2104(A6),A0
        MOVE.L A0,-(A7)
        JSR 1490(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2104(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_103
LBL_102:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 1482(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #6,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_104
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 626(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_104:
        JSR 130(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA -32(A6),A0
        MOVE.L A0,-(A7)
        JSR 618(A5)
        ADDA.W #12,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #2,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_105
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 626(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_105:
        JSR 130(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA -32(A6),A0
        MOVE.L A0,-(A7)
        JSR 618(A5)
        ADDA.W #12,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_107:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_106
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        LEA -2104(A6),A0
        MOVE.L A0,-(A7)
        JSR 658(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2104(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_107
LBL_106:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 650(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_108
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_109:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_108
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_109
LBL_108:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_110
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_111:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_110
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        LEA -2104(A6),A0
        MOVE.L A0,-(A7)
        JSR 506(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2104(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_111
LBL_110:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 450(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_112
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_113:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_112
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        LEA -2104(A6),A0
        MOVE.L A0,-(A7)
        JSR 1490(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2104(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_113
LBL_112:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -16(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2092(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 610(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_114
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_115:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_114
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        LEA -2104(A6),A0
        MOVE.L A0,-(A7)
        JSR 658(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2104(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2100(A6)
        BRA.W LBL_115
LBL_114:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_93:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 212)
        ;   param cond : 12(A6)  size 2
        ;   param label : 8(A6)  size 4
        ;   local msg : -256(A6)  size 256
LBL_10:
        LINK A6,#-2356
        LEA -256(A6),A0
        CLR.B (A0)
        CLR.L D0
        MOVE.B 12(A6),D0
        TST.L D0
        BEQ.W LBL_117
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        BRA.W LBL_118
LBL_117:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
LBL_118:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 1538(A5)
        ADDQ.L #4,A7
LBL_116:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 213)
LBL_11:
        LINK A6,#-2100
        BSR.W LBL_9
        BSR.W LBL_54
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_119:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 214)
        ;   param slot : 8(A6)  size 4
LBL_12:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
        BRA.W LBL_122
LBL_121:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_123
        BRA.W LBL_124
LBL_123:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_125
        BRA.W LBL_126
LBL_125:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_127
LBL_127:
LBL_126:
LBL_124:
LBL_122:
LBL_120:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 215)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_13:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_129
        BRA.W LBL_130
LBL_129:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
        BRA.W LBL_132
LBL_131:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
        BRA.W LBL_134
LBL_133:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_135
LBL_135:
LBL_134:
LBL_132:
LBL_130:
LBL_128:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 216)
        ;   param slot : 8(A6)  size 4
LBL_14:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_137
        BRA.W LBL_138
LBL_137:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_139
        BRA.W LBL_140
LBL_139:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_141
        BRA.W LBL_142
LBL_141:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_143
LBL_143:
LBL_142:
LBL_140:
LBL_138:
LBL_136:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 217)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_15:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_145
        BRA.W LBL_146
LBL_145:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_147
        BRA.W LBL_148
LBL_147:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_149
        BRA.W LBL_150
LBL_149:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_151
LBL_151:
LBL_150:
LBL_148:
LBL_146:
LBL_144:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 218)
LBL_16:
        LINK A6,#-2100
LBL_152:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 219)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_17:
        LINK A6,#-2100
        LEA LBL_44(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_153:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 220)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_18:
        LINK A6,#-2100
        LEA LBL_45(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_154:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 221)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_19:
        LINK A6,#-2100
        LEA LBL_46(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_155:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 222)
        ;   param idx : 8(A6)  size 4
LBL_20:
        LINK A6,#-2100
        LEA LBL_47(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_156:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 223)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_21:
        LINK A6,#-2100
        LEA LBL_48(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_157:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 224)
        ;   param rowsIdx : 8(A6)  size 4
LBL_22:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #65,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_159
        LEA -1304(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_158
        BRA.W LBL_160
LBL_159:
        LEA LBL_49(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_158
LBL_160:
LBL_158:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 225)
        ;   param path : 8(A6)  size 4
LBL_23:
        LINK A6,#-2100
LBL_161:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 226)
LBL_24:
        LINK A6,#-2100
LBL_162:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 227) -- pascal callback glue for aeQuitHandler
LBL_25:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 986(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 228) -- pascal callback glue for aeOappHandler
LBL_26:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 994(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 229) -- pascal callback glue for rtUiScrollbarAction
LBL_27:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 230) -- pascal callback glue for rtUiLdefDraw
LBL_28:
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
        JSR 1234(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_51:
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
LBL_52:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_163
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_50(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_163:
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
        BPL.W LBL_164
        NEG.L D2
        MOVE.L #1,D4
LBL_164:
        CLR.L D5
        TST.L D3
        BPL.W LBL_165
        NEG.L D3
        MOVE.L #1,D5
LBL_165:
        CLR.L D6
        MOVE.W #31,D7
LBL_166:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_167
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_167:
        DBRA D7,LBL_166
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_168
        NEG.L D2
LBL_168:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_53:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_169
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_50(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_169:
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
        BPL.W LBL_170
        NEG.L D2
        MOVE.L #1,D4
LBL_170:
        CLR.L D5
        TST.L D3
        BPL.W LBL_171
        NEG.L D3
        MOVE.L #1,D5
LBL_171:
        CLR.L D6
        MOVE.W #31,D7
LBL_172:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_173
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_173:
        DBRA D7,LBL_172
        TST.L D4
        BEQ.W LBL_174
        NEG.L D6
LBL_174:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_54:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -1304(A5),D0
        MOVE.L D0,-4(A6)
LBL_175:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_50:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_30:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_31:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_32:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_29:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_33:
        DC.B $12
        DC.B $72,$65,$73,$6F,$75,$72,$63,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_34:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_35:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_36:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
LBL_37:
        DC.B $01
        DC.B $61
LBL_38:
        DC.B $01
        DC.B $62
LBL_39:
        DC.B $14
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_40:
        DC.B $1A
        DC.B $73,$6F,$72,$74,$65,$64,$6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_41:
        DC.B $17
        DC.B $69,$6E,$74,$6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
LBL_42:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_43:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_44:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_45:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_46:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_47:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_48:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_49:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
