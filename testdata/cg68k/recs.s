LBL_64:
        ; startup (JT slot 0)
        ; globals (below A5, 292 bytes total):
        ;   natPb : -4(A5)  size 4  type ptr
        ;   natBuf : -8(A5)  size 4  type ptr
        ;   natDigits : -12(A5)  size 4  type ptr
        ;   natLogBuf : -16(A5)  size 4  type ptr
        ;   natLogLen : -20(A5)  size 4  type int
        ;   natRef : -24(A5)  size 4  type int
        ;   natOpened : -26(A5)  size 1  type bool
        ;   natDone : -28(A5)  size 1  type bool
        ;   natArgs : -32(A5)  size 4  type list
        ;   natErrCode : -36(A5)  size 4  type int
        ;   natErrMsg : -292(A5)  size 256  type str
        LEA -292(A5),A0
        MOVE.W #145,D0
LBL_67:
        CLR.W (A0)+
        DBRA D0,LBL_67
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        JSR LBL_65(PC)
        JSR LBL_27(PC)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR LBL_39(PC)
        JSR LBL_66(PC)
        CLR.L -(A7)
        JSR LBL_30(PC)
        RTS
LBL_65:
        ; cg_init_globals
        MOVE.L #0,D0
        MOVE.L D0,-4(A5)
        MOVE.L #0,D0
        MOVE.L D0,-8(A5)
        MOVE.L #0,D0
        MOVE.L D0,-12(A5)
        MOVE.L #0,D0
        MOVE.L D0,-16(A5)
        MOVE.L #0,D0
        MOVE.L D0,-20(A5)
        MOVE.L #0,D0
        MOVE.L D0,-24(A5)
        MOVE.L #0,D0
        MOVE.B D0,-26(A5)
        MOVE.L #0,D0
        MOVE.B D0,-28(A5)
        ; TODO cgDefaultInitAt <kind 7>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-32(A5)
        MOVE.L #0,D0
        MOVE.L D0,-36(A5)
        LEA -292(A5),A0
        MOVE.W #127,D0
LBL_68:
        CLR.W (A0)+
        DBRA D0,LBL_68
        RTS
LBL_66:
        ; cg_free_globals
        MOVE.L -32(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_12(PC)
        ADDQ.L #4,A7
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#0
        MOVE.L 264(A6),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_70:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_70
        JSR LBL_32(PC)
        ADDA.W #260,A7
LBL_69:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 256
LBL_1:
        LINK A6,#0
        LEA 8(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_72:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_72
        JSR LBL_31(PC)
        ADDA.W #256,A7
LBL_71:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 3)
        ;   param v : 266(A6)  size 4
        ;   param found : 264(A6)  size 2
        ;   param name : 8(A6)  size 256
LBL_2:
        LINK A6,#0
        CLR.L D0
        MOVE.B 264(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_74
        LEA LBL_41(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_75:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_75
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_74:
        MOVE.L 266(A6),D0
        BRA.W LBL_73
LBL_73:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 4)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_3:
        LINK A6,#-8
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_77
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_78
LBL_77:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_78:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_79
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_43(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_80:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_80
        JSR LBL_0(PC)
        ADDA.W #260,A7
LBL_79:
LBL_76:
        UNLK A6
        RTS
        ; func rtStrConcat  (JT slot 5)
        ;   param out : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local total : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local fromA : -20(A6)  size 4
        ;   local fromB : -24(A6)  size 4
LBL_4:
        LINK A6,#-24
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_82
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_83
LBL_82:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_83:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_84
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_85
LBL_84:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_85:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_86
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_43(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_87:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_87
        JSR LBL_0(PC)
        ADDA.W #260,A7
LBL_86:
LBL_81:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 6)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_5:
        LINK A6,#-16
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_89
        BRA.W LBL_88
LBL_89:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_90
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_91
LBL_90:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_91:
LBL_92:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_93
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_94(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_92
LBL_93:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; TextSetHandleSize
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_95
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_96:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_96
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_95:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_88:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 7)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_6:
        LINK A6,#-8
        MOVE.L #32,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; TextNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_99:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_99
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_98:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; TextNewHandle
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_100
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_101:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_101
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_100:
        MOVE.L -4(A6),D0
        BRA.W LBL_97
LBL_97:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 8)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_7:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_103
        BRA.W LBL_102
LBL_103:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_102:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 9)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_8:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_105
        BRA.W LBL_104
LBL_105:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_106:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; TextDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
LBL_107:
LBL_104:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 10)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_9:
        LINK A6,#-12
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_5(PC)
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_108:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 11)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_10:
        LINK A6,#-8
        MOVE.L #40,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; ListNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_110
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_111:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_111
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_110:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; ListNewHandle
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_112
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_113:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_113
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_112:
        MOVE.L -4(A6),D0
        BRA.W LBL_109
LBL_109:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 12)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_11:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_115
        BRA.W LBL_114
LBL_115:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_114:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 13)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_12:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_117
        BRA.W LBL_116
LBL_117:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_118
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_118:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_119
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; ListDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; ListDisposePtr
LBL_119:
LBL_116:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 14)
        ;   param l : 8(A6)  size 4
LBL_13:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_122
LBL_121:
        MOVE.L #0,D0
LBL_122:
        BRA.W LBL_120
LBL_120:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 15)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_14:
        LINK A6,#-12
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_124
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_125
LBL_124:
        MOVE.L #1,D0
LBL_125:
        TST.L D0
        BEQ.W LBL_126
        LEA LBL_48(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_127:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_127
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_126:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        JSR LBL_94(PC)
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_123
LBL_123:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 16)
        ;   param l : 8(A6)  size 4
LBL_15:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_128
LBL_128:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 17)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_16:
        LINK A6,#0
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        JSR LBL_94(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_129
LBL_129:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 18)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_17:
        LINK A6,#-8
        MOVE.L #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; MapNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_132:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_132
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_131:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; MapNewHandle
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_134:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_134
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_133:
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; MapNewHandle
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_135
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_136:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_136
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_135:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_130
LBL_130:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 19)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_18:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_138
        BRA.W LBL_137
LBL_138:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_137:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 20)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_19:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_140
        BRA.W LBL_139
LBL_140:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_141
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_141:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_142
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; MapDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; MapDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; MapDisposePtr
LBL_142:
LBL_139:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 21)
        ;   param m : 8(A6)  size 4
LBL_20:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_144
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_145
LBL_144:
        MOVE.L #0,D0
LBL_145:
        BRA.W LBL_143
LBL_143:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 22)
        ;   param m : 8(A6)  size 4
LBL_21:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_146
LBL_146:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 23)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_22:
        LINK A6,#0
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_148
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_149
LBL_148:
        MOVE.L #1,D0
LBL_149:
        TST.L D0
        BEQ.W LBL_150
        LEA LBL_53(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_151:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_151
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_150:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_16(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_147:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 24)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_23:
        LINK A6,#-16
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_153:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_155
        MOVE.L #10,D0
        MOVE.L D0,-12(A6)
LBL_155:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_153
LBL_154:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        BRA.W LBL_152
LBL_152:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 25)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
LBL_24:
        LINK A6,#-18
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-2(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_157
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,12(A6)
LBL_157:
        MOVE.L #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_158
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_159
LBL_158:
LBL_160:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        JSR LBL_162(PC)
        MOVE.L D0,-10(A6)
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        JSR LBL_163(PC)
        MOVE.L D0,12(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_160
LBL_161:
LBL_159:
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_164
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-14(A6)
LBL_164:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_165:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_166
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -18(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-14(A6)
        BRA.W LBL_165
LBL_166:
        MOVE.L -14(A6),D0
        BRA.W LBL_156
LBL_156:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 26)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_25:
        LINK A6,#0
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_168
        BRA.W LBL_167
LBL_168:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_169
        BRA.W LBL_167
LBL_169:
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_167:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 27)
LBL_26:
        LINK A6,#0
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_170:
        UNLK A6
        RTS
        ; func natInit  (JT slot 28)
LBL_27:
        LINK A6,#0
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_172
        BRA.W LBL_171
LBL_172:
        MOVE.L #1,D0
        MOVE.B D0,-26(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-8(A5)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-12(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-16(A5)
        MOVE.L #0,D0
        MOVE.L D0,-20(A5)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #27,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_173
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        BRA.W LBL_171
LBL_173:
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-24(A5)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_171:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 29)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_28:
        LINK A6,#-4
        JSR LBL_27(PC)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_23(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        JSR LBL_26(PC)
LBL_174:
        UNLK A6
        RTS
        ; func natLog  (JT slot 30)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_29:
        LINK A6,#-8
        JSR LBL_27(PC)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_23(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_176:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_178
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_179
LBL_178:
        MOVE.L #0,D0
LBL_179:
        TST.L D0
        BEQ.W LBL_177
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A5),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-20(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_176
LBL_177:
LBL_175:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 31)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_30:
        LINK A6,#-4
        CLR.L D0
        MOVE.B -28(A5),D0
        TST.L D0
        BEQ.W LBL_181
        BRA.W LBL_180
LBL_181:
        MOVE.L #1,D0
        MOVE.B D0,-28(A5)
        JSR LBL_27(PC)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_182
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_182:
        JSR LBL_26(PC)
        DC.W $A9F4  ; NatExitToShell
LBL_180:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 32)
        ;   param msg : 8(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_31:
        LINK A6,#-256
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_54(PC),A0
        MOVE.L A0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        ADDA.L #256,A7
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_29(PC)
        ADDQ.L #4,A7
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        JSR LBL_30(PC)
        ADDQ.L #4,A7
LBL_183:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 33)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_32:
        LINK A6,#0
        MOVE.L 264(A6),D0
        MOVE.L D0,-36(A5)
        LEA -292(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
LBL_184:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 34)
LBL_33:
        LINK A6,#0
        MOVE.L -36(A5),D0
        BRA.W LBL_185
LBL_185:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 35)
        ;   hidden result ptr : 8(A6)  size 4
LBL_34:
        LINK A6,#0
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -292(A5),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        BRA.W LBL_186
LBL_186:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 36)
        ;   local __ret1 : -4(A6)  size 4
LBL_35:
        LINK A6,#-4
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_12(PC)
        ADDQ.L #4,A7
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_11(PC)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_187
LBL_187:
        UNLK A6
        RTS
        ; func recsMake  (JT slot 37)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -76(A6)  size 76
        ;   local __store1 : -152(A6)  size 76
        ;   local __ret2 : -228(A6)  size 76
LBL_36:
        LINK A6,#-228
        LEA -76(A6),A0
        MOVE.W #15,D0
LBL_189:
        CLR.W (A0)+
        DBRA D0,LBL_189
        MOVE.L #18,D0
        MOVE.L D0,-44(A6)
        MOVE.L #5,D0
        MOVE.L D0,-40(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_190:
        CLR.W (A0)+
        DBRA D0,LBL_190
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        LEA -152(A6),A0
        MOVE.W #15,D0
LBL_191:
        CLR.W (A0)+
        DBRA D0,LBL_191
        MOVE.L #18,D0
        MOVE.L D0,-120(A6)
        MOVE.L #5,D0
        MOVE.L D0,-116(A6)
        LEA -112(A6),A0
        MOVE.W #15,D0
LBL_192:
        CLR.W (A0)+
        DBRA D0,LBL_192
        MOVE.L #0,D0
        MOVE.L D0,-80(A6)
        LEA -228(A6),A0
        MOVE.W #15,D0
LBL_193:
        CLR.W (A0)+
        DBRA D0,LBL_193
        MOVE.L #18,D0
        MOVE.L D0,-196(A6)
        MOVE.L #5,D0
        MOVE.L D0,-192(A6)
        LEA -188(A6),A0
        MOVE.W #15,D0
LBL_194:
        CLR.W (A0)+
        DBRA D0,LBL_194
        MOVE.L #0,D0
        MOVE.L D0,-156(A6)
        LEA -152(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -152(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_195:
        CLR.W (A0)+
        DBRA D0,LBL_195
        MOVEA.L A1,A0
        MOVE.L #18,D0
        MOVE.L D0,32(A0)
        MOVEA.L A1,A0
        MOVE.L #5,D0
        MOVE.L D0,36(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 40(A0),A0
        MOVE.W #15,D0
LBL_196:
        CLR.W (A0)+
        DBRA D0,LBL_196
        MOVEA.L A1,A0
        MOVE.L #0,D0
        MOVE.L D0,72(A0)
        LEA -152(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_58(PC)
        ADDQ.L #4,A7
        LEA -76(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -152(A6),A0
        MOVE.L A0,-(A7)
        LEA -76(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_197:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_197
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -76(A6),A0
        LEA 40(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -228(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -76(A6),A0
        MOVE.L A0,-(A7)
        LEA -228(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_198:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_198
        LEA -228(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_58(PC)
        ADDQ.L #4,A7
        LEA -76(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -228(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_199:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_199
        BRA.W LBL_188
LBL_188:
        UNLK A6
        RTS
        ; func recsSum  (JT slot 38)
        ;   param p : 8(A6)  size 76
        ;   local __ret3 : -4(A6)  size 4
LBL_37:
        LINK A6,#-4
        LEA 8(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_58(PC)
        ADDQ.L #4,A7
        LEA 8(A6),A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        LEA 40(A0),A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        LEA 8(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_200
LBL_200:
        UNLK A6
        RTS
        ; func recsMakeBox  (JT slot 39)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param label : 12(A6)  size 32
        ;   local b : -36(A6)  size 36
        ;   local __store2 : -72(A6)  size 36
        ;   local __ret4 : -108(A6)  size 36
LBL_38:
        LINK A6,#-108
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_202:
        CLR.W (A0)+
        DBRA D0,LBL_202
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        LEA -72(A6),A0
        MOVE.W #15,D0
LBL_203:
        CLR.W (A0)+
        DBRA D0,LBL_203
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        LEA -108(A6),A0
        MOVE.W #15,D0
LBL_204:
        CLR.W (A0)+
        DBRA D0,LBL_204
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-76(A6)
        LEA -72(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -72(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_205:
        CLR.W (A0)+
        DBRA D0,LBL_205
        MOVEA.L A1,A0
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,32(A0)
        LEA -72(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_60(PC)
        ADDQ.L #4,A7
        LEA -36(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -72(A6),A0
        MOVE.L A0,-(A7)
        LEA -36(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_206:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_206
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        LEA -72(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -36(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #31,D0
        MOVE.L D0,-(A7)
        LEA 12(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        LEA -108(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -36(A6),A0
        MOVE.L A0,-(A7)
        LEA -108(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_207:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_207
        LEA -108(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_60(PC)
        ADDQ.L #4,A7
        LEA -36(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -108(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_208:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_208
        BRA.W LBL_201
LBL_201:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 40)
        ;   local p : -76(A6)  size 76
        ;   local __store3 : -152(A6)  size 76
        ;   local q : -228(A6)  size 76
        ;   local b1 : -264(A6)  size 36
        ;   local b2 : -300(A6)  size 36
        ;   local total : -304(A6)  size 4
        ;   local __store4 : -380(A6)  size 76
        ;   local __store5 : -416(A6)  size 36
        ;   local __store6 : -452(A6)  size 36
LBL_39:
        LINK A6,#-452
        LEA -76(A6),A0
        MOVE.W #15,D0
LBL_210:
        CLR.W (A0)+
        DBRA D0,LBL_210
        MOVE.L #18,D0
        MOVE.L D0,-44(A6)
        MOVE.L #5,D0
        MOVE.L D0,-40(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_211:
        CLR.W (A0)+
        DBRA D0,LBL_211
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        LEA -152(A6),A0
        MOVE.W #15,D0
LBL_212:
        CLR.W (A0)+
        DBRA D0,LBL_212
        MOVE.L #18,D0
        MOVE.L D0,-120(A6)
        MOVE.L #5,D0
        MOVE.L D0,-116(A6)
        LEA -112(A6),A0
        MOVE.W #15,D0
LBL_213:
        CLR.W (A0)+
        DBRA D0,LBL_213
        MOVE.L #0,D0
        MOVE.L D0,-80(A6)
        LEA -228(A6),A0
        MOVE.W #15,D0
LBL_214:
        CLR.W (A0)+
        DBRA D0,LBL_214
        MOVE.L #18,D0
        MOVE.L D0,-196(A6)
        MOVE.L #5,D0
        MOVE.L D0,-192(A6)
        LEA -188(A6),A0
        MOVE.W #15,D0
LBL_215:
        CLR.W (A0)+
        DBRA D0,LBL_215
        MOVE.L #0,D0
        MOVE.L D0,-156(A6)
        LEA -264(A6),A0
        MOVE.W #15,D0
LBL_216:
        CLR.W (A0)+
        DBRA D0,LBL_216
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-232(A6)
        LEA -300(A6),A0
        MOVE.W #15,D0
LBL_217:
        CLR.W (A0)+
        DBRA D0,LBL_217
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-268(A6)
        LEA -380(A6),A0
        MOVE.W #15,D0
LBL_218:
        CLR.W (A0)+
        DBRA D0,LBL_218
        MOVE.L #18,D0
        MOVE.L D0,-348(A6)
        MOVE.L #5,D0
        MOVE.L D0,-344(A6)
        LEA -340(A6),A0
        MOVE.W #15,D0
LBL_219:
        CLR.W (A0)+
        DBRA D0,LBL_219
        MOVE.L #0,D0
        MOVE.L D0,-308(A6)
        LEA -416(A6),A0
        MOVE.W #15,D0
LBL_220:
        CLR.W (A0)+
        DBRA D0,LBL_220
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-384(A6)
        LEA -452(A6),A0
        MOVE.W #15,D0
LBL_221:
        CLR.W (A0)+
        DBRA D0,LBL_221
        ; TODO cgDefaultInitAt <kind 6>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-420(A6)
        LEA -152(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -152(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_222:
        CLR.W (A0)+
        DBRA D0,LBL_222
        MOVEA.L A1,A0
        MOVE.L #18,D0
        MOVE.L D0,32(A0)
        MOVEA.L A1,A0
        MOVE.L #5,D0
        MOVE.L D0,36(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 40(A0),A0
        MOVE.W #15,D0
LBL_223:
        CLR.W (A0)+
        DBRA D0,LBL_223
        MOVEA.L A1,A0
        MOVE.L #0,D0
        MOVE.L D0,72(A0)
        LEA -152(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_58(PC)
        ADDQ.L #4,A7
        LEA -76(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -152(A6),A0
        MOVE.L A0,-(A7)
        LEA -76(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_224:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_224
        LEA -76(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_55(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        LEA -76(A6),A0
        LEA 40(A0),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_56(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVE.L #90210,D0
        MOVE.L D0,-(A7)
        LEA -76(A6),A0
        LEA 40(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -380(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -76(A6),A0
        MOVE.L A0,-(A7)
        LEA -380(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_225:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_225
        LEA -380(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_58(PC)
        ADDQ.L #4,A7
        LEA -228(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -380(A6),A0
        MOVE.L A0,-(A7)
        LEA -228(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_226:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_226
        MOVE.L #99,D0
        MOVE.L D0,-(A7)
        LEA -228(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #11111,D0
        MOVE.L D0,-(A7)
        LEA -228(A6),A0
        LEA 40(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        ADDA.L #-76,A7
        MOVEA.L A7,A1
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        MOVE.L A1,-(A7)
        JSR LBL_36(PC)
        ADDQ.L #8,A7
        JSR LBL_37(PC)
        ADDA.W #76,A7
        MOVE.L D0,-304(A6)
        ADDA.L #-76,A7
        MOVEA.L A7,A1
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_227:
        CLR.W (A0)+
        DBRA D0,LBL_227
        MOVEA.L A1,A0
        MOVE.L #18,D0
        MOVE.L D0,32(A0)
        MOVEA.L A1,A0
        MOVE.L #5,D0
        MOVE.L D0,36(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 40(A0),A0
        MOVE.W #15,D0
LBL_228:
        CLR.W (A0)+
        DBRA D0,LBL_228
        MOVEA.L A1,A0
        MOVE.L #0,D0
        MOVE.L D0,72(A0)
        JSR LBL_37(PC)
        ADDA.W #76,A7
        MOVE.L D0,-304(A6)
        LEA -416(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        ADDA.L #-32,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #31,-(A7)
        LEA LBL_57(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        LEA -416(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_38(PC)
        ADDA.W #36,A7
        LEA -264(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -416(A6),A0
        MOVE.L A0,-(A7)
        LEA -264(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_229:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_229
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        LEA -416(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -452(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        LEA -452(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_230:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_230
        LEA -452(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_60(PC)
        ADDQ.L #4,A7
        LEA -300(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -452(A6),A0
        MOVE.L A0,-(A7)
        LEA -300(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_231:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_231
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        LEA -452(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -76(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -228(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_59(PC)
        ADDQ.L #4,A7
        LEA -264(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
        LEA -300(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_61(PC)
        ADDQ.L #4,A7
LBL_209:
        UNLK A6
        RTS
LBL_94:
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
LBL_163:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
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
        BPL.W LBL_232
        NEG.L D2
        MOVE.L #1,D4
LBL_232:
        CLR.L D5
        TST.L D3
        BPL.W LBL_233
        NEG.L D3
        MOVE.L #1,D5
LBL_233:
        CLR.L D6
        MOVE.W #31,D7
LBL_234:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_235
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_235:
        DBRA D7,LBL_234
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_236
        NEG.L D2
LBL_236:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_162:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
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
        BPL.W LBL_237
        NEG.L D2
        MOVE.L #1,D4
LBL_237:
        CLR.L D5
        TST.L D3
        BPL.W LBL_238
        NEG.L D3
        MOVE.L #1,D5
LBL_238:
        CLR.L D6
        MOVE.W #31,D7
LBL_239:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_240
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_240:
        DBRA D7,LBL_239
        TST.L D4
        BEQ.W LBL_241
        NEG.L D6
LBL_241:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_58:
        ; cg_retain_recsPerson(rec ptr at 4(A7))
        MOVEA.L 4(A7),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        RTS
LBL_59:
        ; cg_release_recsPerson(rec ptr at 4(A7))
        MOVEA.L 4(A7),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        RTS
LBL_60:
        ; cg_retain_recsBox(rec ptr at 4(A7))
        MOVEA.L 4(A7),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L 32(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_7(PC)
        ADDQ.L #4,A7
        RTS
LBL_61:
        ; cg_release_recsBox(rec ptr at 4(A7))
        MOVEA.L 4(A7),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L 32(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        RTS
        ; constant pool: string literals
LBL_40:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_41:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_42:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_43:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_44:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_45:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_46:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_47:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_48:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_49:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_50:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_51:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_52:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_53:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_54:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_55:
        DC.B $08
        DC.B $4F,$72,$69,$67,$69,$6E,$61,$6C
        DC.B $00
LBL_56:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_57:
        DC.B $05
        DC.B $66,$69,$72,$73,$74
        ; constant pool: enum value tables
LBL_62:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
LBL_63:
        DC.L $00000005
        DC.L $00000006
        ; constant pool: serdesc tables (stub -- Task 8+)
