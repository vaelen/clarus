LBL_77:
        ; startup (JT slot 0)
        ; globals (below A5, 308 bytes total):
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
        ;   natFilePb : -296(A5)  size 4  type ptr
        ;   natFileReady : -298(A5)  size 1  type bool
        ;   natUiEmitBuf : -302(A5)  size 4  type ptr
        ;   natQdInited : -304(A5)  size 1  type bool
        ;   natQdGlobals : -308(A5)  size 4  type ptr
        LEA -308(A5),A0
        MOVE.W #153,D0
LBL_79:
        CLR.W (A0)+
        DBRA D0,LBL_79
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_78
        BSR.W LBL_28
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        BSR.W LBL_51
        BSR.W LBL_76
        CLR.L -(A7)
        BSR.W LBL_31
        RTS
LBL_78:
        ; cg_init_globals
        LINK A6,#-48
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
        MOVE.L #256,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
        MOVE.L D0,-32(A5)
        MOVE.L #0,D0
        MOVE.L D0,-36(A5)
        LEA -292(A5),A0
        MOVE.W #127,D0
LBL_80:
        CLR.W (A0)+
        DBRA D0,LBL_80
        MOVE.L #0,D0
        MOVE.L D0,-296(A5)
        MOVE.L #0,D0
        MOVE.B D0,-298(A5)
        MOVE.L #0,D0
        MOVE.L D0,-302(A5)
        MOVE.L #0,D0
        MOVE.L D0,-302(A5)
        MOVE.L #0,D0
        MOVE.B D0,-304(A5)
        MOVE.L #0,D0
        MOVE.B D0,-304(A5)
        MOVE.L #0,D0
        MOVE.L D0,-308(A5)
        MOVE.L #0,D0
        MOVE.L D0,-308(A5)
        UNLK A6
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#-592
        MOVE.L 264(A6),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_82:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_82
        BSR.W LBL_33
        ADDA.W #260,A7
LBL_81:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 256
LBL_1:
        LINK A6,#-592
        LEA 8(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_84:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_84
        BSR.W LBL_32
        ADDA.W #256,A7
LBL_83:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 3)
        ;   param v : 266(A6)  size 4
        ;   param found : 264(A6)  size 2
        ;   param name : 8(A6)  size 256
LBL_2:
        LINK A6,#-592
        CLR.L D0
        MOVE.B 264(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_86
        LEA LBL_53(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_87:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_87
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_86:
        MOVE.L 266(A6),D0
        BRA.W LBL_85
LBL_85:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 4)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_3:
        LINK A6,#-600
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
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
        BEQ.W LBL_89
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_90
LBL_89:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_90:
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
        BEQ.W LBL_91
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_55(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_92:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_92
        BSR.W LBL_0
        ADDA.W #260,A7
LBL_91:
LBL_88:
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
        LINK A6,#-616
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
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
        BEQ.W LBL_94
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_95
LBL_94:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_95:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_96
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_97
LBL_96:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_97:
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
        BEQ.W LBL_98
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_55(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_99:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_99
        BSR.W LBL_0
        ADDA.W #260,A7
LBL_98:
LBL_93:
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
        LINK A6,#-608
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
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
        BEQ.W LBL_101
        BRA.W LBL_100
LBL_101:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_102
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_103
LBL_102:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_103:
LBL_104:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_105
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_73
        MOVE.L D0,-12(A6)
        BRA.W LBL_104
LBL_105:
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
        BEQ.W LBL_106
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_107:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_107
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_106:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_100:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 7)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_6:
        LINK A6,#-600
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
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
        BEQ.W LBL_109
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_110:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_110
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_109:
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
        BEQ.W LBL_111
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_112:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_112
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_111:
        MOVE.L -4(A6),D0
        BRA.W LBL_108
LBL_108:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 8)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_7:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_114
        BRA.W LBL_113
LBL_114:
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
LBL_113:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 9)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_8:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        BRA.W LBL_115
LBL_116:
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
        BEQ.W LBL_117
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_117:
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
        BEQ.W LBL_118
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
LBL_118:
LBL_115:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 10)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_9:
        LINK A6,#-604
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
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
LBL_119:
        UNLK A6
        RTS
        ; func rtTextToBytes  (JT slot 11)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_10:
        LINK A6,#-604
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_122
LBL_121:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_122:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
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
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_123
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_55(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_124:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_124
        BSR.W LBL_0
        ADDA.W #260,A7
LBL_123:
        MOVE.L -8(A6),D0
        BRA.W LBL_120
LBL_120:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 12)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_11:
        LINK A6,#-600
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
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
        BEQ.W LBL_126
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_127:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_127
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_126:
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
        BEQ.W LBL_128
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_129:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_129
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_128:
        MOVE.L -4(A6),D0
        BRA.W LBL_125
LBL_125:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 13)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_12:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
        BRA.W LBL_130
LBL_131:
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
LBL_130:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 14)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_13:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
        BRA.W LBL_132
LBL_133:
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
        BEQ.W LBL_134
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_134:
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
        BEQ.W LBL_135
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
LBL_135:
LBL_132:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 15)
        ;   param l : 8(A6)  size 4
LBL_14:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_137
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
        BRA.W LBL_138
LBL_137:
        MOVE.L #0,D0
LBL_138:
        BRA.W LBL_136
LBL_136:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 16)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_15:
        LINK A6,#-604
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
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
        BNE.W LBL_140
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
        BRA.W LBL_141
LBL_140:
        MOVE.L #1,D0
LBL_141:
        TST.L D0
        BEQ.W LBL_142
        LEA LBL_60(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_143:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_143
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_142:
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
        BSR.W LBL_73
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_139
LBL_139:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 17)
        ;   param l : 8(A6)  size 4
LBL_16:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_144
LBL_144:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 18)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_17:
        LINK A6,#-592
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
        BSR.W LBL_73
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_145
LBL_145:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 19)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_18:
        LINK A6,#-600
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
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
        BEQ.W LBL_147
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_148:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_148
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_147:
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
        BEQ.W LBL_149
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_150:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_150
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_149:
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
        BEQ.W LBL_151
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_152:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_152
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_151:
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
        BRA.W LBL_146
LBL_146:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 20)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_19:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        BRA.W LBL_153
LBL_154:
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
LBL_153:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 21)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_20:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_156
        BRA.W LBL_155
LBL_156:
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
        BEQ.W LBL_157
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_157:
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
        BEQ.W LBL_158
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
LBL_158:
LBL_155:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 22)
        ;   param m : 8(A6)  size 4
LBL_21:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_160
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
        BRA.W LBL_161
LBL_160:
        MOVE.L #0,D0
LBL_161:
        BRA.W LBL_159
LBL_159:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 23)
        ;   param m : 8(A6)  size 4
LBL_22:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_162
LBL_162:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 24)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_23:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_164
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
        BRA.W LBL_165
LBL_164:
        MOVE.L #1,D0
LBL_165:
        TST.L D0
        BEQ.W LBL_166
        LEA LBL_65(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_167:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_167
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_166:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
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
LBL_163:
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
        LINK A6,#-608
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_169:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_170
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
        BEQ.W LBL_171
        MOVE.L #10,D0
        MOVE.L D0,-12(A6)
LBL_171:
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
        BRA.W LBL_169
LBL_170:
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
        BRA.W LBL_168
LBL_168:
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
        LINK A6,#-610
        MOVE.L #0,D0
        MOVE.B D0,-2(A6)
        MOVE.L #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
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
        BEQ.W LBL_173
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,12(A6)
LBL_173:
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
        BEQ.W LBL_174
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_175
LBL_174:
LBL_176:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_177
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_75
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
        BSR.W LBL_74
        MOVE.L D0,12(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_176
LBL_177:
LBL_175:
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_178
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-14(A6)
LBL_178:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_179:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_180
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
        BRA.W LBL_179
LBL_180:
        MOVE.L -14(A6),D0
        BRA.W LBL_172
LBL_172:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 27)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_26:
        LINK A6,#-592
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_182
        BRA.W LBL_181
LBL_182:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
        BRA.W LBL_181
LBL_183:
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
LBL_181:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 28)
LBL_27:
        LINK A6,#-592
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
LBL_184:
        UNLK A6
        RTS
        ; func natInit  (JT slot 29)
LBL_28:
        LINK A6,#-592
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_186
        BRA.W LBL_185
LBL_186:
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
        BEQ.W LBL_187
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        BRA.W LBL_185
LBL_187:
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
LBL_185:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 30)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_29:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_28
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        BSR.W LBL_27
LBL_188:
        UNLK A6
        RTS
        ; func natLog  (JT slot 31)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_30:
        LINK A6,#-600
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_28
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_190:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_192
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_193
LBL_192:
        MOVE.L #0,D0
LBL_193:
        TST.L D0
        BEQ.W LBL_191
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
        BRA.W LBL_190
LBL_191:
LBL_189:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 32)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_31:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -28(A5),D0
        TST.L D0
        BEQ.W LBL_195
        BRA.W LBL_194
LBL_195:
        MOVE.L #1,D0
        MOVE.B D0,-28(A5)
        BSR.W LBL_28
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
        BSR.W LBL_26
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
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
        BSR.W LBL_26
        ADDQ.L #8,A7
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_196
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
LBL_196:
        BSR.W LBL_27
        DC.W $A9F4  ; NatExitToShell
LBL_194:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 33)
        ;   param msg : 8(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_32:
        LINK A6,#-848
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_198:
        CLR.W (A0)+
        DBRA D0,LBL_198
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_4
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        ADDA.L #256,A7
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_30
        ADDQ.L #4,A7
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
LBL_197:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 34)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_33:
        LINK A6,#-592
        MOVE.L 264(A6),D0
        MOVE.L D0,-36(A5)
        LEA -292(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
LBL_199:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 35)
LBL_34:
        LINK A6,#-592
        MOVE.L -36(A5),D0
        BRA.W LBL_200
LBL_200:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 36)
        ;   hidden result ptr : 8(A6)  size 4
LBL_35:
        LINK A6,#-592
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -292(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        BRA.W LBL_201
LBL_201:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 37)
        ;   local __ret1 : -4(A6)  size 4
LBL_36:
        LINK A6,#-596
        MOVE.L #256,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-552(A6)
LBL_203:
        MOVE.L A1,-(A7)
        MOVE.L -552(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_202
LBL_202:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 38)
LBL_37:
        LINK A6,#-592
        CLR.L D0
        MOVE.B -298(A5),D0
        TST.L D0
        BEQ.W LBL_205
        BRA.W LBL_204
LBL_205:
        MOVE.L #1,D0
        MOVE.B D0,-298(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-296(A5)
LBL_204:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 39)
LBL_38:
        LINK A6,#-592
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_206:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 40)
        ;   param path : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local ref : -16(A6)  size 4
        ;   local wrote : -20(A6)  size 4
        ;   local failed : -22(A6)  size 2
LBL_39:
        LINK A6,#-614
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.B D0,-22(A6)
        BSR.W LBL_37
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -296(A5),D0
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
        BEQ.W LBL_208
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_67(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_209:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_209
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_207
LBL_208:
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.B D0,-22(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_210
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
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #40,D0
        MOVE.L (A7)+,D1
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
        MOVE.L -296(A5),D0
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
        BEQ.W LBL_211
        MOVE.L #1,D0
        MOVE.B D0,-22(A6)
LBL_211:
LBL_210:
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_38
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_212
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_213
LBL_212:
        MOVE.L #1,D0
LBL_213:
        TST.L D0
        BEQ.W LBL_214
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_68(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_215:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_215
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_207
LBL_214:
        MOVE.L #1,D0
        BRA.W LBL_207
LBL_207:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 41)
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
LBL_40:
        LINK A6,#-622
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
        BSR.W LBL_37
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -296(A5),D0
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
        BEQ.W LBL_217
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_67(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_218:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_218
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_216
LBL_217:
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
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
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_219
        LEA LBL_58(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_220:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_220
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_219:
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
LBL_221:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_222
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #40,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_223
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_224
LBL_223:
        MOVE.L #0,D0
LBL_224:
        TST.L D0
        BEQ.W LBL_225
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_69(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_226:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_226
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_216
LBL_225:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_227
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
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
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
LBL_227:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_228
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_229
LBL_228:
        MOVE.L #1,D0
LBL_229:
        TST.L D0
        BEQ.W LBL_230
        MOVE.L #1,D0
        MOVE.B D0,-30(A6)
LBL_230:
        BRA.W LBL_221
LBL_222:
        MOVE.L -296(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -296(A5),D0
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
        MOVE.L #1,D0
        BRA.W LBL_216
LBL_216:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 42)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_41:
        LINK A6,#-612
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_232:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_233
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #47,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_234
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_234:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_232
LBL_233:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_235:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_236
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_235
LBL_236:
LBL_231:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 43)
        ;   param path : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
LBL_42:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_238
        MOVE.L #1,D0
        BRA.W LBL_237
LBL_238:
        MOVE.L #0,D0
        BRA.W LBL_237
LBL_237:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 44)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_43:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_240
        MOVE.L #1,D0
        BRA.W LBL_239
LBL_240:
        MOVE.L #0,D0
        BRA.W LBL_239
LBL_239:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 45)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_44:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_28
        MOVE.L -302(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_242
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-302(A5)
LBL_242:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -302(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -302(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -302(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        BSR.W LBL_27
LBL_241:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 46)
        ;   param code : 8(A6)  size 4
LBL_45:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
LBL_243:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 47)
LBL_46:
        LINK A6,#-592
        CLR.L D0
        MOVE.B -304(A5),D0
        TST.L D0
        BEQ.W LBL_245
        BRA.W LBL_244
LBL_245:
        MOVE.L #1,D0
        MOVE.B D0,-304(A5)
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-308(A5)
        MOVE.L -308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #202,D0
        MOVE.L (A7)+,D1
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
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A97B  ; NatInitDialogs
        DC.W $A850  ; NatInitCursor
LBL_244:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 48)
        ;   param out : 8(A6)  size 4
LBL_47:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #86,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #90,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_246:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 49)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_48:
        LINK A6,#-596
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #80,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #84,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_248
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65536,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_248:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #86,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #90,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_247:
        UNLK A6
        RTS
        ; func label  (JT slot 50)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param n : 12(A6)  size 4
        ;   local s : -256(A6)  size 256
LBL_49:
        LINK A6,#-848
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_250:
        CLR.W (A0)+
        DBRA D0,LBL_250
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_70(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        BRA.W LBL_249
LBL_249:
        UNLK A6
        RTS
        ; func arithDemo  (JT slot 51)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local sum : -4(A6)  size 4
        ;   local diff : -8(A6)  size 4
        ;   local prod : -12(A6)  size 4
        ;   local q : -16(A6)  size 4
        ;   local r : -20(A6)  size 4
        ;   local negA : -24(A6)  size 4
        ;   local eqFlag : -26(A6)  size 2
        ;   local ltFlag : -28(A6)  size 2
        ;   local notFlag : -30(A6)  size 2
        ;   local bitAnd : -34(A6)  size 4
        ;   local bitOr : -38(A6)  size 4
        ;   local bitXor : -42(A6)  size 4
        ;   local bitNot : -46(A6)  size 4
        ;   local shl : -50(A6)  size 4
        ;   local shr : -54(A6)  size 4
        ;   local f : -58(A6)  size 4
        ;   local backToInt : -62(A6)  size 4
        ;   local c : -64(A6)  size 2
        ;   local backToInt2 : -68(A6)  size 4
        ;   local p : -72(A6)  size 4
        ;   local backToInt3 : -76(A6)  size 4
        ;   local fneg : -80(A6)  size 4
        ;   local backNeg : -84(A6)  size 4
LBL_50:
        LINK A6,#-676
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.B D0,-26(A6)
        MOVE.L #0,D0
        MOVE.B D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L #0,D0
        MOVE.L D0,-34(A6)
        MOVE.L #0,D0
        MOVE.L D0,-38(A6)
        MOVE.L #0,D0
        MOVE.L D0,-42(A6)
        MOVE.L #0,D0
        MOVE.L D0,-46(A6)
        MOVE.L #0,D0
        MOVE.L D0,-50(A6)
        MOVE.L #0,D0
        MOVE.L D0,-54(A6)
        MOVE.L #0,D0
        MOVE.L D0,-58(A6)
        MOVE.L #0,D0
        MOVE.L D0,-62(A6)
        MOVE.L #0,D0
        MOVE.B D0,-64(A6)
        MOVE.L #0,D0
        MOVE.L D0,-68(A6)
        MOVE.L #0,D0
        MOVE.L D0,-72(A6)
        MOVE.L #0,D0
        MOVE.L D0,-76(A6)
        MOVE.L #0,D0
        MOVE.L D0,-80(A6)
        MOVE.L #0,D0
        MOVE.L D0,-84(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_73
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_74
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_75
        MOVE.L D0,-20(A6)
        MOVE.L 12(A6),D0
        NEG.L D0
        MOVE.L D0,-24(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-26(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-28(A6)
        CLR.L D0
        MOVE.B -26(A6),D0
        EORI.L #1,D0
        MOVE.B D0,-30(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-34(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-38(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        EOR.L D1,D0
        MOVE.L D0,-42(A6)
        MOVE.L 12(A6),D0
        NOT.L D0
        MOVE.L D0,-46(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-50(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-54(A6)
        MOVE.L 12(A6),D0
        MOVE.L #16,D1
        ASL.L D1,D0
        MOVE.L D0,-58(A6)
        MOVE.L -58(A6),D0
        TST.L D0
        BMI.W LBL_252
        MOVE.L #16,D1
        ASR.L D1,D0
        BRA.W LBL_253
LBL_252:
        NEG.L D0
        MOVE.L #16,D1
        ASR.L D1,D0
        NEG.L D0
LBL_253:
        MOVE.L D0,-62(A6)
        MOVE.L 12(A6),D0
        ANDI.L #255,D0
        MOVE.B D0,-64(A6)
        CLR.L D0
        MOVE.B -64(A6),D0
        MOVE.L D0,-68(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-76(A6)
        MOVE.L #98304,D0
        NEG.L D0
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D0
        TST.L D0
        BMI.W LBL_254
        MOVE.L #16,D1
        ASR.L D1,D0
        BRA.W LBL_255
LBL_254:
        NEG.L D0
        MOVE.L #16,D1
        ASR.L D1,D0
        NEG.L D0
LBL_255:
        MOVE.L D0,-84(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -34(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -38(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -42(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -46(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -50(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -84(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_251
LBL_251:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 52)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
        ;   local s : -264(A6)  size 256
        ;   local ax : -268(A6)  size 4
LBL_51:
        LINK A6,#-860
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        LEA -264(A6),A0
        MOVE.W #127,D0
LBL_257:
        CLR.W (A0)+
        DBRA D0,LBL_257
        MOVE.L #0,D0
        MOVE.L D0,-268(A6)
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
        MOVE.L #2,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_49
        ADDQ.L #8,A7
        MOVE.L #7,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #8,A7
        MOVE.L D0,-268(A6)
        BRA.W LBL_256
LBL_256:
        UNLK A6
        RTS
LBL_73:
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
LBL_74:
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
        BPL.W LBL_258
        NEG.L D2
        MOVE.L #1,D4
LBL_258:
        CLR.L D5
        TST.L D3
        BPL.W LBL_259
        NEG.L D3
        MOVE.L #1,D5
LBL_259:
        CLR.L D6
        MOVE.W #31,D7
LBL_260:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_261
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_261:
        DBRA D7,LBL_260
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_262
        NEG.L D2
LBL_262:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_75:
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
        BPL.W LBL_263
        NEG.L D2
        MOVE.L #1,D4
LBL_263:
        CLR.L D5
        TST.L D3
        BPL.W LBL_264
        NEG.L D3
        MOVE.L #1,D5
LBL_264:
        CLR.L D6
        MOVE.W #31,D7
LBL_265:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_266
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_266:
        DBRA D7,LBL_265
        TST.L D4
        BEQ.W LBL_267
        NEG.L D6
LBL_267:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_76:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
LBL_268:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_52:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_53:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_54:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_55:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_56:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_57:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_58:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_59:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_60:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_61:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_62:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_63:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_64:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_65:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_66:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_67:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_68:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_69:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_70:
        DC.B $01
        DC.B $78
LBL_71:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_72:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
        ; constant pool: serdesc tables (stub -- Task 8+)
