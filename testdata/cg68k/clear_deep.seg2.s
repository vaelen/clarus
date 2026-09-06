        ; func natFileReadText  (JT slot 203)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local ref : -12(A6)  size 4
        ;   local got : -16(A6)  size 4
        ;   local code : -20(A6)  size 4
        ;   local bounce : -24(A6)  size 4
        ;   local total : -28(A6)  size 4
        ;   local done : -30(A6)  size 2
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
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
        JSR 1602(A5)
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_64
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_63
LBL_64:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #32768,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_65
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_65:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_66:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_67
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -6890(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -6890(A5),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_68
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_69
LBL_68:
        MOVEQ #0,D0
LBL_69:
        TST.L D0
        BEQ.W LBL_70
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_63
LBL_70:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_71
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVE.L -28(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
LBL_71:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_72
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_73
LBL_72:
        MOVEQ #1,D0
LBL_73:
        TST.L D0
        BEQ.W LBL_74
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_74:
        BRA.W LBL_66
LBL_67:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_63
LBL_63:
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
        BEQ.W LBL_76
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_75
LBL_76:
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
        BEQ.W LBL_77
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
LBL_77:
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
        BRA.W LBL_75
LBL_75:
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
LBL_2:
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
        BEQ.W LBL_79
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_78
LBL_79:
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
        BEQ.W LBL_80
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_78
LBL_80:
        JSR 1602(A5)
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_81
        MOVE.L -6890(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_81:
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_82
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_78
LBL_82:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D0
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
        BEQ.W LBL_83
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
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -6890(A5),D1
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
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_84
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_84:
LBL_83:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        JSR 1610(A5)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_85
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_86
LBL_85:
        MOVEQ #1,D0
LBL_86:
        TST.L D0
        BEQ.W LBL_87
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_78
LBL_87:
        MOVEQ #1,D0
        BRA.W LBL_78
LBL_78:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 206)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_3:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 1530(A5)
        MOVE.L -6896(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_89
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6896(A5)
LBL_89:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6896(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -6896(A5),D1
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
        MOVE.L -6896(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
        ADDQ.L #8,A7
        JSR 1522(A5)
LBL_88:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 207)
        ;   param code : 8(A6)  size 4
LBL_4:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_90:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 208)
LBL_5:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6898(A5),D0
        TST.L D0
        BEQ.W LBL_92
        BRA.W LBL_91
LBL_92:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6902(A5)
        MOVE.L -6902(A5),D1
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
        MOVE.B D0,-6898(A5)
        DC.W $A850  ; NatInitCursor
LBL_91:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 209)
        ;   param out : 8(A6)  size 4
LBL_6:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
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
        MOVE.L -6902(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_93:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 210)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_7:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6902(A5),D1
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
        BEQ.W LBL_95
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_95:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
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
        MOVE.L -6902(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_94:
        UNLK A6
        RTS
        ; func clearDeepRun  (JT slot 211)
        ;   local l : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local sm : -12(A6)  size 4
        ;   local im : -16(A6)  size 4
LBL_8:
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
        LEA LBL_42(PC),A0
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
        LEA LBL_43(PC),A0
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
LBL_98:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_97
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
        BRA.W LBL_98
LBL_97:
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
        LEA LBL_44(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
        ADDQ.L #6,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_45(PC),A0
        MOVE.L A0,-(A7)
        JSR 482(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_99
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_45(PC),A0
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
LBL_99:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_45(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_46(PC),A0
        MOVE.L A0,-(A7)
        JSR 482(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_100
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_46(PC),A0
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
LBL_100:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_46(PC),A0
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
LBL_102:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_101
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
        BRA.W LBL_102
LBL_101:
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
        LEA LBL_47(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
        ADDQ.L #6,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_45(PC),A0
        MOVE.L A0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_103
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_45(PC),A0
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
LBL_103:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_45(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 1450(A5)
        ADDA.W #12,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_46(PC),A0
        MOVE.L A0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_104
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_46(PC),A0
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
LBL_104:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_46(PC),A0
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
LBL_106:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_105
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
        BRA.W LBL_106
LBL_105:
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
        LEA LBL_48(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
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
        BEQ.W LBL_107
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
LBL_107:
        JSR 130(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_42(PC),A0
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
        BEQ.W LBL_108
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
LBL_108:
        JSR 130(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_43(PC),A0
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
LBL_110:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_109
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
        BRA.W LBL_110
LBL_109:
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
        LEA LBL_49(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
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
        BEQ.W LBL_111
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_112:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_111
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
        BRA.W LBL_112
LBL_111:
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
        BEQ.W LBL_113
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_114:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_113
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
        BRA.W LBL_114
LBL_113:
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
        BEQ.W LBL_115
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_116:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_115
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
        BRA.W LBL_116
LBL_115:
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
        BEQ.W LBL_117
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2096(A6)
        CLR.L -2100(A6)
LBL_118:
        MOVE.L -2100(A6),D0
        MOVE.L -2096(A6),D1
        CMP.L D1,D0
        BGE.W LBL_117
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
        BRA.W LBL_118
LBL_117:
        MOVE.L A1,-(A7)
        MOVE.L -2092(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_96:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 212)
        ;   param cond : 12(A6)  size 2
        ;   param label : 8(A6)  size 4
        ;   local msg : -256(A6)  size 256
LBL_9:
        LINK A6,#-2356
        LEA -256(A6),A0
        CLR.B (A0)
        CLR.L D0
        MOVE.B 12(A6),D0
        TST.L D0
        BEQ.W LBL_120
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_50(PC),A0
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
        BRA.W LBL_121
LBL_120:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_51(PC),A0
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
LBL_121:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 1538(A5)
        ADDQ.L #4,A7
LBL_119:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 213)
LBL_10:
        LINK A6,#-2100
        BSR.W LBL_8
        BSR.W LBL_62
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_122:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 214)
        ;   param slot : 8(A6)  size 4
LBL_11:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_124
        BRA.W LBL_125
LBL_124:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_126
        BRA.W LBL_127
LBL_126:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_128
        BRA.W LBL_129
LBL_128:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_130
        BRA.W LBL_131
LBL_130:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_132
        BRA.W LBL_133
LBL_132:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_134
        BRA.W LBL_135
LBL_134:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_136
        BRA.W LBL_137
LBL_136:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_138
LBL_138:
LBL_137:
LBL_135:
LBL_133:
LBL_131:
LBL_129:
LBL_127:
LBL_125:
LBL_123:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 215)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_12:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_140
        BRA.W LBL_141
LBL_140:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_142
        BRA.W LBL_143
LBL_142:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_144
        BRA.W LBL_145
LBL_144:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_146
        BRA.W LBL_147
LBL_146:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
        BRA.W LBL_149
LBL_148:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_150
        BRA.W LBL_151
LBL_150:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_152
        BRA.W LBL_153
LBL_152:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
LBL_154:
LBL_153:
LBL_151:
LBL_149:
LBL_147:
LBL_145:
LBL_143:
LBL_141:
LBL_139:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 216)
        ;   param slot : 8(A6)  size 4
LBL_13:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_156
        BRA.W LBL_157
LBL_156:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_158
        BRA.W LBL_159
LBL_158:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_160
        BRA.W LBL_161
LBL_160:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_162
        BRA.W LBL_163
LBL_162:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_164
        BRA.W LBL_165
LBL_164:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_166
        BRA.W LBL_167
LBL_166:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_168
        BRA.W LBL_169
LBL_168:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_170
LBL_170:
LBL_169:
LBL_167:
LBL_165:
LBL_163:
LBL_161:
LBL_159:
LBL_157:
LBL_155:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 217)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_14:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_172
        BRA.W LBL_173
LBL_172:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_174
        BRA.W LBL_175
LBL_174:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_176
        BRA.W LBL_177
LBL_176:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_178
        BRA.W LBL_179
LBL_178:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_180
        BRA.W LBL_181
LBL_180:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_182
        BRA.W LBL_183
LBL_182:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_184
        BRA.W LBL_185
LBL_184:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_186
LBL_186:
LBL_185:
LBL_183:
LBL_181:
LBL_179:
LBL_177:
LBL_175:
LBL_173:
LBL_171:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 218)
LBL_15:
        LINK A6,#-2100
LBL_187:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 219)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_16:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
        BRA.W LBL_190
LBL_189:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_191
LBL_191:
LBL_190:
LBL_188:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 220)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_17:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_193
        BRA.W LBL_194
LBL_193:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_195
LBL_195:
LBL_194:
LBL_192:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 221)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_18:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_197
        BRA.W LBL_198
LBL_197:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_199
LBL_199:
LBL_198:
LBL_196:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 222)
        ;   param slot : 8(A6)  size 4
LBL_19:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_201
        BRA.W LBL_202
LBL_201:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_203
LBL_203:
LBL_202:
LBL_200:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 223)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_20:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_205
        BRA.W LBL_206
LBL_205:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_207
LBL_207:
LBL_206:
LBL_204:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 224)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_21:
        LINK A6,#-2100
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_209
        BRA.W LBL_210
LBL_209:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_211
LBL_211:
LBL_210:
LBL_208:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 225)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_22:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_213
        BRA.W LBL_214
LBL_213:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_215
LBL_215:
LBL_214:
LBL_212:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 226)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_23:
        LINK A6,#-2100
        LEA LBL_52(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_62
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_216:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 227)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_24:
        LINK A6,#-2100
        LEA LBL_53(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_62
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_217:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 228)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_25:
        LINK A6,#-2100
        LEA LBL_54(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_62
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_218:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 229)
        ;   param idx : 8(A6)  size 4
LBL_26:
        LINK A6,#-2100
        LEA LBL_55(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_62
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_219:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 230)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_27:
        LINK A6,#-2100
        LEA LBL_56(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_62
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
LBL_220:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 231)
        ;   param rowsIdx : 8(A6)  size 4
LBL_28:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #124,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_222
        LEA -6618(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_221
        BRA.W LBL_223
LBL_222:
        LEA LBL_57(PC),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        BSR.W LBL_62
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_221
LBL_223:
LBL_221:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 232)
        ;   param path : 8(A6)  size 4
LBL_29:
        LINK A6,#-2100
LBL_224:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 233)
LBL_30:
        LINK A6,#-2100
LBL_225:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 234) -- pascal callback glue for aeQuitHandler
LBL_31:
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
        ; func clar_cb_aeOappHandler (JT slot 235) -- pascal callback glue for aeOappHandler
LBL_32:
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
        ; func clar_cb_rtUiScrollbarAction (JT slot 236) -- pascal callback glue for rtUiScrollbarAction
LBL_33:
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
        ; func clar_cb_rtUiLdefDraw (JT slot 237) -- pascal callback glue for rtUiLdefDraw
LBL_34:
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
LBL_59:
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
LBL_60:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_226
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_58(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_226:
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
        BPL.W LBL_227
        NEG.L D2
        MOVE.L #1,D4
LBL_227:
        CLR.L D5
        TST.L D3
        BPL.W LBL_228
        NEG.L D3
        MOVE.L #1,D5
LBL_228:
        CLR.L D6
        MOVE.W #31,D7
LBL_229:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_230
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_230:
        DBRA D7,LBL_229
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_231
        NEG.L D2
LBL_231:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_61:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_232
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_58(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_232:
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
        BPL.W LBL_233
        NEG.L D2
        MOVE.L #1,D4
LBL_233:
        CLR.L D5
        TST.L D3
        BPL.W LBL_234
        NEG.L D3
        MOVE.L #1,D5
LBL_234:
        CLR.L D6
        MOVE.W #31,D7
LBL_235:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_236
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_236:
        DBRA D7,LBL_235
        TST.L D4
        BEQ.W LBL_237
        NEG.L D6
LBL_237:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_62:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -6618(A5),D0
        MOVE.L D0,-4(A6)
LBL_238:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_58:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_40:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_35:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_37:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_41:
        DC.B $12
        DC.B $72,$65,$73,$6F,$75,$72,$63,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_38:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_39:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_36:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_42:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_43:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_44:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
LBL_45:
        DC.B $01
        DC.B $61
LBL_46:
        DC.B $01
        DC.B $62
LBL_47:
        DC.B $14
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_48:
        DC.B $1A
        DC.B $73,$6F,$72,$74,$65,$64,$6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_49:
        DC.B $17
        DC.B $69,$6E,$74,$6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6C,$65,$61,$72,$20,$63,$6F,$75,$6E,$74
LBL_50:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_51:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_52:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_53:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_54:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_55:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_56:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_57:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
