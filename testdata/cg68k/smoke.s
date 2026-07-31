LBL_79:
        ; startup (JT slot 0)
        ; globals (below A5, 292 bytes total):
        ;   lasterrCode : -4(A5)  size 4  type int
        ;   lasterrMsg : -260(A5)  size 256  type str
        ;   natPb : -264(A5)  size 4  type ptr
        ;   natBuf : -268(A5)  size 4  type ptr
        ;   natDigits : -272(A5)  size 4  type ptr
        ;   natLogBuf : -276(A5)  size 4  type ptr
        ;   natLogLen : -280(A5)  size 4  type int
        ;   natRef : -284(A5)  size 4  type int
        ;   natOpened : -286(A5)  size 1  type bool
        ;   natDone : -288(A5)  size 1  type bool
        ;   natArgs : -292(A5)  size 4  type list
        LEA -292(A5),A0
        MOVE.W #145,D0
LBL_82:
        CLR.W (A0)+
        DBRA D0,LBL_82
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        JSR LBL_80(PC)
        JSR LBL_28(PC)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR LBL_37(PC)
        JSR LBL_81(PC)
        CLR.L -(A7)
        JSR LBL_31(PC)
        RTS
LBL_80:
        ; cg_init_globals
        MOVE.L #0,D0
        MOVE.L D0,-4(A5)
        LEA -260(A5),A0
        MOVE.W #127,D0
LBL_83:
        CLR.W (A0)+
        DBRA D0,LBL_83
        MOVE.L #0,D0
        MOVE.L D0,-264(A5)
        MOVE.L #0,D0
        MOVE.L D0,-268(A5)
        MOVE.L #0,D0
        MOVE.L D0,-272(A5)
        MOVE.L #0,D0
        MOVE.L D0,-276(A5)
        MOVE.L #0,D0
        MOVE.L D0,-280(A5)
        MOVE.L #0,D0
        MOVE.L D0,-284(A5)
        MOVE.L #0,D0
        MOVE.B D0,-286(A5)
        MOVE.L #0,D0
        MOVE.B D0,-288(A5)
        ; TODO cgDefaultInitAt <kind 7>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-292(A5)
        RTS
LBL_81:
        ; cg_free_globals
        MOVE.L -292(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #4,A7
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#0
        MOVE.L 264(A6),D0
        MOVE.L D0,-4(A5)
        LEA -260(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
LBL_84:
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
LBL_86:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_86
        JSR LBL_32(PC)
        ADDA.W #256,A7
LBL_85:
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
        BEQ.W LBL_88
        LEA LBL_39(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_89:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_89
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_88:
        MOVE.L 266(A6),D0
        BRA.W LBL_87
LBL_87:
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
        BEQ.W LBL_91
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_92
LBL_91:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_92:
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
        BEQ.W LBL_93
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_41(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_94:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_94
        JSR LBL_0(PC)
        ADDA.W #260,A7
LBL_93:
LBL_90:
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
        BEQ.W LBL_96
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_97
LBL_96:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_97:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_99
LBL_98:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_99:
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
        BEQ.W LBL_100
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_41(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_101:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_101
        JSR LBL_0(PC)
        ADDA.W #260,A7
LBL_100:
LBL_95:
        UNLK A6
        RTS
        ; func rtStrCmp  (JT slot 6)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local ca : -20(A6)  size 4
        ;   local cb : -24(A6)  size 4
LBL_5:
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
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_103
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_104
LBL_103:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_104:
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_105:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_102
LBL_107:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_108
        MOVE.L #1,D0
        BRA.W LBL_102
LBL_108:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_105
LBL_106:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_109
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_102
LBL_109:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_110
        MOVE.L #1,D0
        BRA.W LBL_102
LBL_110:
        MOVE.L #0,D0
        BRA.W LBL_102
LBL_102:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 7)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_6:
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
        BEQ.W LBL_112
        BRA.W LBL_111
LBL_112:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_113
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_114
LBL_113:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_114:
LBL_115:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_117(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_115
LBL_116:
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
        BEQ.W LBL_118
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_119:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_119
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_118:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_111:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 8)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_7:
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
        BEQ.W LBL_121
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_122:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_122
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_121:
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
        BEQ.W LBL_123
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_124:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_124
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_123:
        MOVE.L -4(A6),D0
        BRA.W LBL_120
LBL_120:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 9)
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
        BEQ.W LBL_126
        BRA.W LBL_125
LBL_126:
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
LBL_125:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 10)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_9:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_128
        BRA.W LBL_127
LBL_128:
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
        BEQ.W LBL_129
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_129:
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
        BEQ.W LBL_130
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
LBL_130:
LBL_127:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 11)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_10:
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
        JSR LBL_6(PC)
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
LBL_131:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 12)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_11:
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
        BEQ.W LBL_133
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_134:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_134
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_133:
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
        BEQ.W LBL_135
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_136:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_136
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_135:
        MOVE.L -4(A6),D0
        BRA.W LBL_132
LBL_132:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 13)
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
        ; func rtListRelease  (JT slot 14)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_13:
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
        DC.W $A023  ; ListDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; ListDisposePtr
LBL_142:
LBL_139:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 15)
        ;   param l : 8(A6)  size 4
LBL_14:
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
        ; func rtListAt  (JT slot 16)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_15:
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
        BNE.W LBL_147
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
        BRA.W LBL_148
LBL_147:
        MOVE.L #1,D0
LBL_148:
        TST.L D0
        BEQ.W LBL_149
        LEA LBL_46(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_150:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_150
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_149:
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
        JSR LBL_117(PC)
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_146
LBL_146:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 17)
        ;   param l : 8(A6)  size 4
LBL_16:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_151
LBL_151:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 18)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_17:
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
        JSR LBL_117(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_152
LBL_152:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 19)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_18:
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
        BEQ.W LBL_154
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_155:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_155
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_154:
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
        BEQ.W LBL_156
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_157:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_157
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_156:
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
        BEQ.W LBL_158
        LEA LBL_44(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_159:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_159
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_158:
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
        BRA.W LBL_153
LBL_153:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 20)
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
        BEQ.W LBL_161
        BRA.W LBL_160
LBL_161:
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
LBL_160:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 21)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_20:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_163
        BRA.W LBL_162
LBL_163:
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
        BEQ.W LBL_164
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_164:
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
        BEQ.W LBL_165
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
LBL_165:
LBL_162:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 22)
        ;   param m : 8(A6)  size 4
LBL_21:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_167
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
        BRA.W LBL_168
LBL_167:
        MOVE.L #0,D0
LBL_168:
        BRA.W LBL_166
LBL_166:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 23)
        ;   param m : 8(A6)  size 4
LBL_22:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_169
LBL_169:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 24)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_23:
        LINK A6,#0
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_171
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
        BRA.W LBL_172
LBL_171:
        MOVE.L #1,D0
LBL_172:
        TST.L D0
        BEQ.W LBL_173
        LEA LBL_51(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_174:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_174
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_173:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
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
LBL_170:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 25)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_24:
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
LBL_176:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_177
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
        BEQ.W LBL_178
        MOVE.L #10,D0
        MOVE.L D0,-12(A6)
LBL_178:
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
        BRA.W LBL_176
LBL_177:
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
        BRA.W LBL_175
LBL_175:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 26)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
LBL_25:
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
        BEQ.W LBL_180
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,12(A6)
LBL_180:
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
        BEQ.W LBL_181
        MOVE.L -272(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_182
LBL_181:
LBL_183:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_184
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        JSR LBL_185(PC)
        MOVE.L D0,-10(A6)
        MOVE.L -272(A5),D0
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
        JSR LBL_186(PC)
        MOVE.L D0,12(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_183
LBL_184:
LBL_182:
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_187
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-14(A6)
LBL_187:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_188:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
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
        MOVE.L -272(A5),D0
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
        BRA.W LBL_188
LBL_189:
        MOVE.L -14(A6),D0
        BRA.W LBL_179
LBL_179:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 27)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_26:
        LINK A6,#0
        MOVE.L -284(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_191
        BRA.W LBL_190
LBL_191:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_192
        BRA.W LBL_190
LBL_192:
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -284(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_190:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 28)
LBL_27:
        LINK A6,#0
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_193:
        UNLK A6
        RTS
        ; func natInit  (JT slot 29)
LBL_28:
        LINK A6,#0
        CLR.L D0
        MOVE.B -286(A5),D0
        TST.L D0
        BEQ.W LBL_195
        BRA.W LBL_194
LBL_195:
        MOVE.L #1,D0
        MOVE.B D0,-286(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-264(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-268(A5)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-272(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-276(A5)
        MOVE.L #0,D0
        MOVE.L D0,-280(A5)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A5),D0
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
        MOVE.L -264(A5),D0
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
        MOVE.L -264(A5),D0
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
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #27,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -264(A5),D0
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
        BEQ.W LBL_196
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-284(A5)
        BRA.W LBL_194
LBL_196:
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-284(A5)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -284(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_194:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 30)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_29:
        LINK A6,#-4
        JSR LBL_28(PC)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_26(PC)
        ADDQ.L #8,A7
        JSR LBL_27(PC)
LBL_197:
        UNLK A6
        RTS
        ; func natLog  (JT slot 31)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_30:
        LINK A6,#-8
        JSR LBL_28(PC)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_199:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_201
        MOVE.L -280(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_202
LBL_201:
        MOVE.L #0,D0
LBL_202:
        TST.L D0
        BEQ.W LBL_200
        MOVE.L -276(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -280(A5),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -280(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-280(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_199
LBL_200:
LBL_198:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 32)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_31:
        LINK A6,#-4
        CLR.L D0
        MOVE.B -288(A5),D0
        TST.L D0
        BEQ.W LBL_204
        BRA.W LBL_203
LBL_204:
        MOVE.L #1,D0
        MOVE.B D0,-288(A5)
        JSR LBL_28(PC)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        JSR LBL_26(PC)
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_26(PC)
        ADDQ.L #8,A7
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -268(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        JSR LBL_26(PC)
        ADDQ.L #8,A7
        MOVE.L -276(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -280(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_26(PC)
        ADDQ.L #8,A7
        MOVE.L -284(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_205
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -284(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -264(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_205:
        JSR LBL_27(PC)
        DC.W $A9F4  ; NatExitToShell
LBL_203:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 33)
        ;   param msg : 8(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_32:
        LINK A6,#-256
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_52(PC),A0
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
        JSR LBL_30(PC)
        ADDQ.L #4,A7
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
LBL_206:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 34)
        ;   local __ret1 : -4(A6)  size 4
LBL_33:
        LINK A6,#-4
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #4,A7
        MOVE.L -292(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_12(PC)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_207
LBL_207:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 35)
        ;   param cond : 264(A6)  size 2
        ;   param label : 8(A6)  size 256
        ;   local msg : -256(A6)  size 256
LBL_34:
        LINK A6,#-256
        CLR.L D0
        MOVE.B 264(A6),D0
        TST.L D0
        BEQ.W LBL_209
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_53(PC),A0
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
        BRA.W LBL_210
LBL_209:
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
LBL_210:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_29(PC)
        ADDQ.L #4,A7
LBL_208:
        UNLK A6
        RTS
        ; func smokeMakePoint  (JT slot 36)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -48(A6)  size 48
        ;   local __store1 : -96(A6)  size 48
        ;   local __ret2 : -144(A6)  size 48
LBL_35:
        LINK A6,#-144
        MOVE.L #3,D0
        MOVE.L D0,-48(A6)
        MOVE.L #4,D0
        MOVE.L D0,-44(A6)
        MOVE.L #5,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_212:
        CLR.W (A0)+
        DBRA D0,LBL_212
        MOVE.L #3,D0
        MOVE.L D0,-96(A6)
        MOVE.L #4,D0
        MOVE.L D0,-92(A6)
        MOVE.L #5,D0
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-84(A6)
        LEA -80(A6),A0
        MOVE.W #15,D0
LBL_213:
        CLR.W (A0)+
        DBRA D0,LBL_213
        MOVE.L #3,D0
        MOVE.L D0,-144(A6)
        MOVE.L #4,D0
        MOVE.L D0,-140(A6)
        MOVE.L #5,D0
        MOVE.L D0,-136(A6)
        MOVE.L #0,D0
        MOVE.L D0,-132(A6)
        LEA -128(A6),A0
        MOVE.W #15,D0
LBL_214:
        CLR.W (A0)+
        DBRA D0,LBL_214
        LEA -96(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -96(A6),A0
        MOVE.L #3,D0
        MOVE.L D0,0(A0)
        MOVE.L #4,D0
        MOVE.L D0,4(A0)
        MOVE.L #5,D0
        MOVE.L D0,8(A0)
        MOVE.L #0,D0
        MOVE.L D0,12(A0)
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_215:
        CLR.W (A0)+
        DBRA D0,LBL_215
        LEA -96(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_75(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_216:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_216
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_217:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_217
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_75(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -144(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_218:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_218
        BRA.W LBL_211
LBL_211:
        UNLK A6
        RTS
        ; func smokeTakePoint  (JT slot 37)
        ;   param p : 8(A6)  size 48
        ;   local __ret3 : -4(A6)  size 4
LBL_36:
        LINK A6,#-4
        LEA 8(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_75(PC)
        ADDQ.L #4,A7
        LEA 8(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        LEA 8(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_219
LBL_219:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 38)
        ;   local p : -48(A6)  size 48
        ;   local __store2 : -96(A6)  size 48
        ;   local q : -144(A6)  size 48
        ;   local e : -148(A6)  size 4
        ;   local n : -152(A6)  size 4
        ;   local __store3 : -200(A6)  size 48
        ;   local __store4 : -248(A6)  size 48
LBL_37:
        LINK A6,#-248
        MOVE.L #3,D0
        MOVE.L D0,-48(A6)
        MOVE.L #4,D0
        MOVE.L D0,-44(A6)
        MOVE.L #5,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_221:
        CLR.W (A0)+
        DBRA D0,LBL_221
        MOVE.L #3,D0
        MOVE.L D0,-96(A6)
        MOVE.L #4,D0
        MOVE.L D0,-92(A6)
        MOVE.L #5,D0
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-84(A6)
        LEA -80(A6),A0
        MOVE.W #15,D0
LBL_222:
        CLR.W (A0)+
        DBRA D0,LBL_222
        MOVE.L #3,D0
        MOVE.L D0,-144(A6)
        MOVE.L #4,D0
        MOVE.L D0,-140(A6)
        MOVE.L #5,D0
        MOVE.L D0,-136(A6)
        MOVE.L #0,D0
        MOVE.L D0,-132(A6)
        LEA -128(A6),A0
        MOVE.W #15,D0
LBL_223:
        CLR.W (A0)+
        DBRA D0,LBL_223
        MOVE.L #3,D0
        MOVE.L D0,-200(A6)
        MOVE.L #4,D0
        MOVE.L D0,-196(A6)
        MOVE.L #5,D0
        MOVE.L D0,-192(A6)
        MOVE.L #0,D0
        MOVE.L D0,-188(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_224:
        CLR.W (A0)+
        DBRA D0,LBL_224
        MOVE.L #3,D0
        MOVE.L D0,-248(A6)
        MOVE.L #4,D0
        MOVE.L D0,-244(A6)
        MOVE.L #5,D0
        MOVE.L D0,-240(A6)
        MOVE.L #0,D0
        MOVE.L D0,-236(A6)
        LEA -232(A6),A0
        MOVE.W #15,D0
LBL_225:
        CLR.W (A0)+
        DBRA D0,LBL_225
        LEA -96(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -96(A6),A0
        MOVE.L #3,D0
        MOVE.L D0,0(A0)
        MOVE.L #4,D0
        MOVE.L D0,4(A0)
        MOVE.L #5,D0
        MOVE.L D0,8(A0)
        MOVE.L #0,D0
        MOVE.L D0,12(A0)
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_226:
        CLR.W (A0)+
        DBRA D0,LBL_226
        LEA -96(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_75(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_227:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_227
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_55(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_228:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_228
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_56(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_229:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_229
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_57(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_230:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_230
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_231:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_231
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_59(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_232:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_232
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_60(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_233:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_233
        JSR LBL_34(PC)
        ADDA.W #258,A7
        MOVE.L #10,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_61(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVE.L #90210,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_62(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_234:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_234
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #90210,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_63(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_235:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_235
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_61(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_5(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_64(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_236:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_236
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -200(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -200(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_237:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_237
        LEA -200(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_75(PC)
        ADDQ.L #4,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -200(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_238:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_238
        MOVE.L #99,D0
        MOVE.L D0,-(A7)
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #11111,D0
        MOVE.L D0,-(A7)
        LEA -144(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_65(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_239:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_239
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #99,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_66(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_240:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_240
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #90210,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_67(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_241:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_241
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #11111,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_68(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_242:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_242
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -248(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_35(PC)
        ADDQ.L #8,A7
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_243:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_243
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_69(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_244:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_244
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #555,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_70(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_245:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_245
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        ADDA.L #-48,A7
        MOVEA.L A7,A1
        MOVE.W #23,D0
LBL_246:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_246
        JSR LBL_36(PC)
        ADDA.W #48,A7
        MOVE.L D0,-152(A6)
        MOVE.L -152(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #555,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_71(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_247:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_247
        JSR LBL_34(PC)
        ADDA.W #258,A7
        MOVE.L #6,D0
        MOVE.L D0,D1
        LEA LBL_78(PC),A0
        MOVE.W #2,D2
LBL_249:
        CMP.L (A0)+,D1
        BEQ.W LBL_248
        DBRA D2,LBL_249
        ; enum conversion miss -> rtEnumCheck(v, false, <name arg unused>) panics
        MOVE.L D1,-(A7)
        CLR.W -(A7)
        ADDA.L #-256,A7
        JSR LBL_2(PC)
        ADDA.W #262,A7
LBL_248:
        MOVE.L D0,-148(A6)
        MOVE.L -148(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_72(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_250:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_250
        JSR LBL_34(PC)
        ADDA.W #258,A7
        MOVE.L -148(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_73(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_251:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_251
        JSR LBL_34(PC)
        ADDA.W #258,A7
        LEA LBL_74(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_29(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        JSR LBL_81(PC)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_76(PC)
        ADDQ.L #4,A7
LBL_220:
        UNLK A6
        RTS
LBL_117:
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
LBL_186:
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
        BPL.W LBL_252
        NEG.L D2
        MOVE.L #1,D4
LBL_252:
        CLR.L D5
        TST.L D3
        BPL.W LBL_253
        NEG.L D3
        MOVE.L #1,D5
LBL_253:
        CLR.L D6
        MOVE.W #31,D7
LBL_254:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_255
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_255:
        DBRA D7,LBL_254
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_256
        NEG.L D2
LBL_256:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_185:
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
        BPL.W LBL_257
        NEG.L D2
        MOVE.L #1,D4
LBL_257:
        CLR.L D5
        TST.L D3
        BPL.W LBL_258
        NEG.L D3
        MOVE.L #1,D5
LBL_258:
        CLR.L D6
        MOVE.W #31,D7
LBL_259:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_260
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_260:
        DBRA D7,LBL_259
        TST.L D4
        BEQ.W LBL_261
        NEG.L D6
LBL_261:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_75:
        ; cg_retain_smokePoint(rec ptr at 4(A7))
        MOVEA.L 4(A7),A0
        RTS
LBL_76:
        ; cg_release_smokePoint(rec ptr at 4(A7))
        MOVEA.L 4(A7),A0
        RTS
        ; constant pool: string literals
LBL_38:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_39:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_40:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_41:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_42:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_43:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_44:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_45:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_46:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_47:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_48:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_49:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_50:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_51:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_52:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_53:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_54:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_55:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_56:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$79
        DC.B $00
LBL_57:
        DC.B $11
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_58:
        DC.B $17
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
LBL_59:
        DC.B $18
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_60:
        DC.B $1B
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_61:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_62:
        DC.B $0B
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$78
LBL_63:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
        DC.B $00
LBL_64:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$73,$74,$72
        DC.B $00
LBL_65:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$78
LBL_66:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$78
LBL_67:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_68:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_69:
        DC.B $17
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
LBL_70:
        DC.B $13
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$66,$69,$65,$6C,$64
LBL_71:
        DC.B $15
        DC.B $72,$65,$63,$6F,$72,$64,$20,$70,$61,$72,$61,$6D,$20,$62,$79,$20,$76,$61,$6C,$75,$65
LBL_72:
        DC.B $14
        DC.B $65,$6E,$75,$6D,$20,$69,$6E,$74,$2D,$3E,$65,$6E,$75,$6D,$20,$76,$61,$6C,$69,$64
        DC.B $00
LBL_73:
        DC.B $18
        DC.B $65,$6E,$75,$6D,$20,$65,$6E,$75,$6D,$2D,$3E,$69,$6E,$74,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70
        DC.B $00
LBL_74:
        DC.B $0A
        DC.B $73,$6D,$6F,$6B,$65,$20,$64,$6F,$6E,$65
        DC.B $00
        ; constant pool: enum value tables
LBL_77:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
LBL_78:
        DC.L $00000005
        DC.L $00000006
        DC.L $00000007
        ; constant pool: serdesc tables (stub -- Task 8+)
