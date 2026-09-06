        ; func rtUiHandleContentClick  (JT slot 216)
        ;   param wp : 18(A6)  size 4
        ;   param inst : 14(A6)  size 4
        ;   param wherePt : 10(A6)  size 4
        ;   param shiftDown : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local localPt : -8(A6)  size 4
        ;   local ctrlSlot : -12(A6)  size 4
        ;   local cpart : -16(A6)  size 4
        ;   local ctrl : -20(A6)  size 4
        ;   local rfCon : -24(A6)  size 4
        ;   local wIdx : -28(A6)  size 4
        ;   local trackPart : -32(A6)  size 4
        ;   local cIdxSlot : -36(A6)  size 4
        ;   local cIdx : -40(A6)  size 4
        ;   local tIdxSlot : -44(A6)  size 4
        ;   local tIdx : -48(A6)  size 4
        ;   local extendSel : -50(A6)  size 2
        ;   local n : -54(A6)  size 4
        ;   local ti : -58(A6)  size 4
        ;   local lh : -62(A6)  size 4
        ;   local mods : -66(A6)  size 4
        ;   local pIdxSlot : -70(A6)  size 4
        ;   local pIdx : -74(A6)  size 4
        ;   local tblIdxSlot : -78(A6)  size 4
        ;   local tblIdx : -82(A6)  size 4
LBL_0:
        LINK A6,#-2182
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVEQ #0,D0
        MOVE.L D0,-48(A6)
        MOVEQ #0,D0
        MOVE.B D0,-50(A6)
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        MOVEQ #0,D0
        MOVE.L D0,-58(A6)
        MOVEQ #0,D0
        MOVE.L D0,-62(A6)
        MOVEQ #0,D0
        MOVE.L D0,-66(A6)
        MOVEQ #0,D0
        MOVE.L D0,-70(A6)
        MOVEQ #0,D0
        MOVE.L D0,-74(A6)
        MOVEQ #0,D0
        MOVE.L D0,-78(A6)
        MOVEQ #0,D0
        MOVE.L D0,-82(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        CLR.W -(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A96C  ; UiFindControl
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_102
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_103
LBL_102:
        MOVEQ #0,D0
LBL_103:
        TST.L D0
        BEQ.W LBL_104
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 698(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-54(A6)
        MOVEQ #0,D0
        MOVE.L D0,-58(A6)
LBL_105:
        MOVE.L -58(A6),D1
        MOVE.L -54(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,-62(A6)
        MOVE.L -62(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_108
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_109
LBL_108:
        MOVEQ #0,D0
LBL_109:
        TST.L D0
        BEQ.W LBL_110
        CLR.L D0
        MOVE.B -48(A5),D0
        TST.L D0
        BEQ.W LBL_111
        BRA.W LBL_101
LBL_111:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_112
        MOVE.L #512,D0
        MOVE.L D0,-66(A6)
        BRA.W LBL_113
LBL_112:
        MOVEQ #0,D0
        MOVE.L D0,-66(A6)
LBL_113:
        CLR.W -(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #24,-(A7)
        DC.W $A9E7  ; UiLClick
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_101
LBL_110:
LBL_107:
        MOVE.L -58(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-58(A6)
        BRA.W LBL_105
LBL_106:
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVE.L #32768,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_114
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVE.L #16383,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDA.W #20,A7
        BRA.W LBL_101
LBL_114:
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        CLR.L D0
        MOVE.B -48(A5),D0
        TST.L D0
        BEQ.W LBL_115
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1722(A5)
        ADDQ.L #8,A7
        BRA.W LBL_101
LBL_115:
        CLR.W -(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1722(A5)
        ADDQ.L #8,A7
LBL_116:
        BRA.W LBL_101
LBL_104:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1738(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_117
        MOVE.L -36(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1754(A5)
        ADDA.W #16,A7
        BRA.W LBL_101
LBL_117:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_118
        MOVE.L -44(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-48(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_119
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_120
LBL_119:
        MOVEQ #0,D0
LBL_120:
        MOVE.B D0,-50(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_61
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -50(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D4  ; UiTEClick
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        BRA.W LBL_101
LBL_118:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-70(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        JSR 2522(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_121
        MOVE.L -70(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-74(A6)
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -74(A6),D0
        MOVE.L D0,-(A7)
        JSR 2546(A5)
        ADDQ.L #8,A7
        BRA.W LBL_101
LBL_121:
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-78(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 2474(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_122
        MOVE.L -78(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-82(A6)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_123
        MOVE.L #512,D0
        MOVE.L D0,-66(A6)
        BRA.W LBL_124
LBL_123:
        MOVEQ #0,D0
        MOVE.L D0,-66(A6)
LBL_124:
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -82(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVE.L D0,-(A7)
        JSR 2498(A5)
        ADDA.W #16,A7
        BRA.W LBL_101
LBL_122:
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_101:
        UNLK A6
        RTS
        ; func rtUiHandleMouseDown  (JT slot 217)
        ;   param ev : 8(A6)  size 4
        ;   local wherePt : -4(A6)  size 4
        ;   local wpSlot : -8(A6)  size 4
        ;   local part : -12(A6)  size 4
        ;   local wp : -16(A6)  size 4
        ;   local inst : -20(A6)  size 4
        ;   local dragBounds : -24(A6)  size 4
        ;   local modifiers : -28(A6)  size 4
        ;   local shiftDown : -30(A6)  size 2
LBL_1:
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
        MOVE.L 8(A6),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        CLR.W -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A92C  ; UiFindWindow
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        CLR.L D0
        MOVE.B -124(A5),D0
        TST.L D0
        BEQ.W LBL_126
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_127
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_125
LBL_127:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_130
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #4,A7
        BRA.W LBL_131
LBL_130:
        MOVEQ #0,D0
LBL_131:
        TST.L D0
        BEQ.W LBL_128
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -128(A5),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_129
LBL_128:
        MOVEQ #0,D0
LBL_129:
        TST.L D0
        BEQ.W LBL_132
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_125
LBL_132:
LBL_126:
        MOVE.L -12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_135
        CLR.W -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91E  ; UiTrackGoAway
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_136
LBL_135:
        MOVEQ #0,D0
LBL_136:
        TST.L D0
        BEQ.W LBL_137
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_138
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #4,A7
LBL_138:
LBL_137:
        BRA.W LBL_134
LBL_133:
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_139
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 3426(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.W D0,-(A7)
        MOVEQ #4,D0
        MOVE.W D0,-(A7)
        DC.W $A8A9  ; UiInsetRect
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A925  ; UiDragWindow
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        JSR 1602(A5)
        BRA.W LBL_140
LBL_139:
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_141
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_143
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1698(A5)
        ADDA.W #12,A7
LBL_143:
        BRA.W LBL_142
LBL_141:
        MOVE.L -12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_144
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_145
LBL_144:
        MOVEQ #1,D0
LBL_145:
        TST.L D0
        BEQ.W LBL_146
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1714(A5)
        ADDA.W #16,A7
LBL_148:
        BRA.W LBL_147
LBL_146:
        MOVE.L -12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_149
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_151
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91F  ; UiSelectWindow
        JSR 1602(A5)
        BRA.W LBL_152
LBL_151:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_153
        MOVE.L 8(A6),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVE.L #512,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-30(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -30(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_0
        ADDA.W #14,A7
LBL_153:
LBL_152:
        BRA.W LBL_150
LBL_149:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A93D  ; UiMenuSelect
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1618(A5)
        ADDQ.L #4,A7
LBL_154:
LBL_150:
LBL_147:
LBL_142:
LBL_140:
LBL_134:
LBL_125:
        UNLK A6
        RTS
        ; func rtUiHandleKey  (JT slot 218)
        ;   param ev : 8(A6)  size 4
        ;   local ch : -4(A6)  size 4
        ;   local modifiers : -8(A6)  size 4
        ;   local wp : -12(A6)  size 4
        ;   local inst : -16(A6)  size 4
        ;   local winIdx : -20(A6)  size 4
        ;   local wIdxSlot : -24(A6)  size 4
        ;   local wIdx : -28(A6)  size 4
        ;   local w : -32(A6)  size 4
        ;   local savedPort : -36(A6)  size 4
        ;   local fieldIdx : -40(A6)  size 4
        ;   local ftype : -44(A6)  size 4
LBL_2:
        LINK A6,#-2144
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L #256,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_156
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A93E  ; UiMenuKey
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1618(A5)
        ADDQ.L #4,A7
        BRA.W LBL_155
LBL_156:
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_157
        BRA.W LBL_155
LBL_157:
        MOVE.L -16(A6),D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_158
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_159
        MOVE.L -4(A6),D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_161
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_162
LBL_161:
        MOVEQ #1,D0
LBL_162:
        BRA.W LBL_160
LBL_159:
        MOVEQ #0,D0
LBL_160:
        TST.L D0
        BEQ.W LBL_163
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 762(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 2674(A5)
        ADDA.W #12,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 3498(A5)
        ADDA.W #24,A7
        BRA.W LBL_155
LBL_163:
        MOVE.L -4(A6),D1
        MOVEQ #27,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_164
        CLR.L D0
        MOVE.B -124(A5),D0
        TST.L D0
        BEQ.W LBL_169
        MOVE.L -128(A5),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_170
LBL_169:
        MOVEQ #0,D0
LBL_170:
        TST.L D0
        BEQ.W LBL_167
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_168
LBL_167:
        MOVEQ #0,D0
LBL_168:
        TST.L D0
        BEQ.W LBL_165
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_171
        MOVE.L -4(A6),D1
        MOVEQ #31,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_172
LBL_171:
        MOVEQ #0,D0
LBL_172:
        EORI.L #1,D0
        BRA.W LBL_166
LBL_165:
        MOVEQ #0,D0
LBL_166:
        TST.L D0
        BEQ.W LBL_173
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1138(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_174
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 1090(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_177
        MOVE.L -44(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_178
LBL_177:
        MOVEQ #1,D0
LBL_178:
        TST.L D0
        BEQ.W LBL_175
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 3050(A5)
        ADDA.W #12,A7
        EORI.L #1,D0
        BRA.W LBL_176
LBL_175:
        MOVEQ #0,D0
LBL_176:
        TST.L D0
        BEQ.W LBL_179
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_155
LBL_179:
LBL_174:
LBL_173:
        BSR.W LBL_19
        MOVE.L D0,-36(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9DC  ; UiTEKey
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_180
        MOVE.L -4(A6),D1
        MOVEQ #31,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_181
LBL_180:
        MOVEQ #0,D0
LBL_181:
        TST.L D0
        BEQ.W LBL_182
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        BRA.W LBL_183
LBL_182:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_59
        ADDA.W #10,A7
LBL_183:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        BRA.W LBL_155
LBL_164:
LBL_158:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -4(A6),D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_186
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_187
LBL_186:
        MOVEQ #1,D0
LBL_187:
        TST.L D0
        BEQ.W LBL_184
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 1730(A5)
        ADDA.W #12,A7
        BRA.W LBL_185
LBL_184:
        MOVEQ #0,D0
LBL_185:
        TST.L D0
        BEQ.W LBL_188
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1722(A5)
        ADDQ.L #8,A7
        BRA.W LBL_155
LBL_188:
        MOVE.L -4(A6),D1
        MOVEQ #27,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 1730(A5)
        ADDA.W #12,A7
        BRA.W LBL_190
LBL_189:
        MOVEQ #0,D0
LBL_190:
        TST.L D0
        BEQ.W LBL_191
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1722(A5)
        ADDQ.L #8,A7
        BRA.W LBL_155
LBL_191:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        JSR 2666(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 3490(A5)
        ADDA.W #20,A7
LBL_155:
        UNLK A6
        RTS
        ; func rtUiRun  (JT slot 219)
        ;   local evBuf : -4(A6)  size 4
        ;   local frontInst : -8(A6)  size 4
        ;   local sleepTicks : -12(A6)  size 4
        ;   local what : -16(A6)  size 4
        ;   local gotEvent : -18(A6)  size 2
LBL_3:
        LINK A6,#-2118
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.B D0,-18(A6)
        LEA LBL_96(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_193
        JSR 2994(A5)
        BRA.W LBL_192
LBL_193:
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
LBL_194:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_195
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -34(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_196
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_198
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_199
LBL_198:
        MOVEQ #0,D0
LBL_199:
        BRA.W LBL_197
LBL_196:
        MOVEQ #1,D0
LBL_197:
        TST.L D0
        BEQ.W LBL_200
        MOVEQ #1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_201
LBL_200:
        MOVEQ #30,D0
        MOVE.L D0,-12(A6)
LBL_201:
        CLR.W -(A7)
        MOVE.L #65535,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A860  ; UiWaitNextEvent
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-18(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_202
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
        BRA.W LBL_203
LBL_202:
        MOVE.L -16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_204
        MOVE.L -16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_205
LBL_204:
        MOVEQ #1,D0
LBL_205:
        TST.L D0
        BEQ.W LBL_206
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #4,A7
        BRA.W LBL_207
LBL_206:
        MOVE.L -16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_208
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1666(A5)
        ADDQ.L #4,A7
        BRA.W LBL_209
LBL_208:
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_210
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        JSR 1674(A5)
        ADDQ.L #6,A7
        BRA.W LBL_211
LBL_210:
        MOVE.L -16(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_212
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #4,A7
LBL_212:
LBL_211:
LBL_209:
LBL_207:
LBL_203:
        JSR 1634(A5)
        JSR 3378(A5)
        BSR.W LBL_65
        JSR 1650(A5)
        JSR 2514(A5)
        BRA.W LBL_194
LBL_195:
LBL_192:
        UNLK A6
        RTS
        ; func rtUiLaunch  (JT slot 220)
        ;   local script : -4(A6)  size 4
        ;   local cursor : -8(A6)  size 4
        ;   local lineStart : -12(A6)  size 4
        ;   local lineLen : -16(A6)  size 4
        ;   local isLaunchDoc : -18(A6)  size 2
        ;   local found : -20(A6)  size 2
        ;   local pathBuf : -24(A6)  size 4
        ;   local pathLen : -28(A6)  size 4
LBL_4:
        LINK A6,#-2128
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.B D0,-18(A6)
        MOVEQ #0,D0
        MOVE.B D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        LEA LBL_96(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_214
        JSR 1378(A5)
        BRA.W LBL_213
LBL_214:
        MOVEQ #0,D0
        MOVE.B D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
LBL_215:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_216
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_217:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_219
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_220
LBL_219:
        MOVEQ #0,D0
LBL_220:
        TST.L D0
        BEQ.W LBL_218
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_217
LBL_218:
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.B D0,-18(A6)
        MOVE.L -16(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_221
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #108,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_238
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #97,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_239
LBL_238:
        MOVEQ #0,D0
LBL_239:
        TST.L D0
        BEQ.W LBL_236
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #117,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_237
LBL_236:
        MOVEQ #0,D0
LBL_237:
        TST.L D0
        BEQ.W LBL_234
        MOVE.L -12(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #110,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_235
LBL_234:
        MOVEQ #0,D0
LBL_235:
        TST.L D0
        BEQ.W LBL_232
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_233
LBL_232:
        MOVEQ #0,D0
LBL_233:
        TST.L D0
        BEQ.W LBL_230
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #104,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_231
LBL_230:
        MOVEQ #0,D0
LBL_231:
        TST.L D0
        BEQ.W LBL_228
        MOVE.L -12(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #100,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_229
LBL_228:
        MOVEQ #0,D0
LBL_229:
        TST.L D0
        BEQ.W LBL_226
        MOVE.L -12(A6),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #111,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_227
LBL_226:
        MOVEQ #0,D0
LBL_227:
        TST.L D0
        BEQ.W LBL_224
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_225
LBL_224:
        MOVEQ #0,D0
LBL_225:
        TST.L D0
        BEQ.W LBL_222
        MOVE.L -12(A6),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_223
LBL_222:
        MOVEQ #0,D0
LBL_223:
        TST.L D0
        BEQ.W LBL_240
        MOVEQ #1,D0
        MOVE.B D0,-18(A6)
LBL_240:
LBL_221:
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_241
        MOVEQ #1,D0
        MOVE.B D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVEQ #10,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_242
        MOVE.L #255,D0
        MOVE.L D0,-28(A6)
LBL_242:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -12(A6),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 2786(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 3402(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_241:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_243
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_243:
        BRA.W LBL_215
LBL_216:
        CLR.L D0
        MOVE.B -20(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_244
        JSR 3538(A5)
LBL_244:
LBL_213:
        UNLK A6
        RTS
        ; func UiNewControl  (JT slot 221)
        ;   param owningWindow : 38(A6)  size 4
        ;   param boundsRect : 34(A6)  size 4
        ;   param controlTitle : 30(A6)  size 4
        ;   param initiallyVisible : 28(A6)  size 2
        ;   param initialValue : 24(A6)  size 4
        ;   param minimumValue : 20(A6)  size 4
        ;   param maximumValue : 16(A6)  size 4
        ;   param procId : 12(A6)  size 4
        ;   param controlReference : 8(A6)  size 4
LBL_5:
        LINK A6,#-2100
        BSR.W LBL_85
        CLR.L -(A7)
        MOVE.L 38(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 34(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 30(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 28(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A954  ; UiNewControlRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_245
LBL_245:
        UNLK A6
        RTS
        ; func UiNewRgn  (JT slot 222)
LBL_6:
        LINK A6,#-2100
        BSR.W LBL_85
        CLR.L -(A7)
        DC.W $A8D8  ; UiNewRgnRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_246
LBL_246:
        UNLK A6
        RTS
        ; func rtUiCtrlAt  (JT slot 223)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_7:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_247
LBL_247:
        UNLK A6
        RTS
        ; func rtUiSetCtrlAt  (JT slot 224)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_8:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_248:
        UNLK A6
        RTS
        ; func rtUiRectAt  (JT slot 225)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_9:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_249
LBL_249:
        UNLK A6
        RTS
        ; func rtUiLabelAt  (JT slot 226)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_10:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_250
LBL_250:
        UNLK A6
        RTS
        ; func rtUiCanvasBufAt  (JT slot 227)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_11:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #44,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_251
LBL_251:
        UNLK A6
        RTS
        ; func rtUiCanvasMarkDirty  (JT slot 228)
        ;   param instV : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_12:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_253
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_253:
LBL_252:
        UNLK A6
        RTS
        ; func rtUiTeAt  (JT slot 229)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_13:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_254
LBL_254:
        UNLK A6
        RTS
        ; func rtUiSetTeAt  (JT slot 230)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_14:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_255:
        UNLK A6
        RTS
        ; func rtUiHbarAt  (JT slot 231)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_15:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 64(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_256
LBL_256:
        UNLK A6
        RTS
        ; func rtUiSetHbarAt  (JT slot 232)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_16:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 64(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_257:
        UNLK A6
        RTS
        ; func rtUiEnabledAt  (JT slot 233)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_17:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 72(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_258
LBL_258:
        UNLK A6
        RTS
        ; func rtUiSetEnabledAt  (JT slot 234)
        ;   param w : 14(A6)  size 4
        ;   param i : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
LBL_18:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_260
        MOVE.L 14(A6),D0
        MOVEA.L D0,A0
        LEA 72(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_261
LBL_260:
        MOVE.L 14(A6),D0
        MOVEA.L D0,A0
        LEA 72(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_261:
LBL_259:
        UNLK A6
        RTS
        ; func rtUiGetPortSaved  (JT slot 235)
        ;   local slot : -4(A6)  size 4
        ;   local p : -8(A6)  size 4
LBL_19:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A874  ; UiGetPort
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        BRA.W LBL_262
LBL_262:
        UNLK A6
        RTS
        ; func rtUiKindHeight  (JT slot 236)
        ;   param kind : 8(A6)  size 4
        ;   local __switch2 : -4(A6)  size 4
LBL_20:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_264
        MOVEQ #20,D0
        BRA.W LBL_263
        BRA.W LBL_265
LBL_264:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_266
        MOVEQ #16,D0
        BRA.W LBL_263
        BRA.W LBL_267
LBL_266:
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        MOVEQ #16,D0
        BRA.W LBL_263
        BRA.W LBL_269
LBL_268:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_270
        MOVEQ #100,D0
        BRA.W LBL_263
        BRA.W LBL_271
LBL_270:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_272
        MOVEQ #20,D0
        BRA.W LBL_263
        BRA.W LBL_273
LBL_272:
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_274
        MOVEQ #100,D0
        BRA.W LBL_263
        BRA.W LBL_275
LBL_274:
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_276
        MOVEQ #20,D0
        BRA.W LBL_263
        BRA.W LBL_277
LBL_276:
        MOVE.L -4(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_278
        MOVEQ #120,D0
        BRA.W LBL_263
        BRA.W LBL_279
LBL_278:
        MOVEQ #16,D0
        BRA.W LBL_263
LBL_279:
LBL_277:
LBL_275:
LBL_273:
LBL_271:
LBL_269:
LBL_267:
LBL_265:
        MOVEQ #16,D0
        BRA.W LBL_263
LBL_263:
        UNLK A6
        RTS
        ; func rtUiKindWidth  (JT slot 237)
        ;   param kind : 8(A6)  size 4
        ;   local __switch3 : -4(A6)  size 4
LBL_21:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        MOVEQ #80,D0
        BRA.W LBL_280
        BRA.W LBL_282
LBL_281:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_283
        MOVEQ #90,D0
        BRA.W LBL_280
        BRA.W LBL_284
LBL_283:
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        MOVE.L #150,D0
        BRA.W LBL_280
        BRA.W LBL_286
LBL_285:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_287
        MOVE.L #200,D0
        BRA.W LBL_280
        BRA.W LBL_288
LBL_287:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_289
        MOVE.L #200,D0
        BRA.W LBL_280
        BRA.W LBL_290
LBL_289:
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_291
        MOVE.L #200,D0
        BRA.W LBL_280
        BRA.W LBL_292
LBL_291:
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_293
        MOVE.L #200,D0
        BRA.W LBL_280
        BRA.W LBL_294
LBL_293:
        MOVE.L -4(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_295
        MOVE.L #300,D0
        BRA.W LBL_280
        BRA.W LBL_296
LBL_295:
        MOVEQ #90,D0
        BRA.W LBL_280
LBL_296:
LBL_294:
LBL_292:
LBL_290:
LBL_288:
LBL_286:
LBL_284:
LBL_282:
        MOVEQ #90,D0
        BRA.W LBL_280
LBL_280:
        UNLK A6
        RTS
        ; func rtUiPstrcpy  (JT slot 238)
        ;   param dst : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_22:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_298
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_297
LBL_298:
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_297:
        UNLK A6
        RTS
        ; func rtUiLayout  (JT slot 239)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local savedPort : -12(A6)  size 4
        ;   local contentW : -16(A6)  size 4
        ;   local contentH : -20(A6)  size 4
        ;   local prevLeft : -24(A6)  size 4
        ;   local prevRight : -28(A6)  size 4
        ;   local prevBottom : -32(A6)  size 4
        ;   local n : -36(A6)  size 4
        ;   local i : -40(A6)  size 4
        ;   local kind : -44(A6)  size 4
        ;   local atKind : -48(A6)  size 4
        ;   local flags : -52(A6)  size 4
        ;   local x : -56(A6)  size 4
        ;   local y : -60(A6)  size 4
        ;   local ww : -64(A6)  size 4
        ;   local hh : -68(A6)  size 4
        ;   local widthIsFill : -70(A6)  size 2
        ;   local fillBoth : -72(A6)  size 2
        ;   local flushR : -74(A6)  size 2
        ;   local flushB : -76(A6)  size 2
        ;   local ctrl : -80(A6)  size 4
        ;   local __switch4 : -84(A6)  size 4
LBL_23:
        LINK A6,#-2184
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVEQ #0,D0
        MOVE.L D0,-48(A6)
        MOVEQ #0,D0
        MOVE.L D0,-52(A6)
        MOVEQ #0,D0
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
        MOVEQ #0,D0
        MOVE.B D0,-70(A6)
        MOVEQ #0,D0
        MOVE.B D0,-72(A6)
        MOVEQ #0,D0
        MOVE.B D0,-74(A6)
        MOVEQ #0,D0
        MOVE.B D0,-76(A6)
        MOVEQ #0,D0
        MOVE.L D0,-80(A6)
        MOVEQ #0,D0
        MOVE.L D0,-84(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_19
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 698(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
LBL_300:
        MOVE.L -40(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_301
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVE.L D0,-68(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-84(A6)
        MOVE.L -84(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        MOVE.L -28(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_303
LBL_302:
        MOVE.L -84(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_304
        MOVE.L -24(A6),D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_305
LBL_304:
        MOVE.L -84(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_306
        MOVEQ #12,D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_307
LBL_306:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 794(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
LBL_307:
LBL_305:
LBL_303:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 802(A5)
        ADDQ.L #8,A7
        TST.L D0
        BNE.W LBL_308
        MOVE.L -48(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_309
LBL_308:
        MOVEQ #1,D0
LBL_309:
        TST.L D0
        BEQ.W LBL_310
        MOVE.L -32(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_311
LBL_310:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 810(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
LBL_311:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 842(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 818(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-70(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-72(A6)
        MOVEQ #0,D0
        MOVE.B D0,-74(A6)
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
        MOVE.L -52(A6),D1
        MOVEQ #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_315
LBL_314:
        MOVEQ #0,D0
LBL_315:
        TST.L D0
        BEQ.W LBL_312
        CLR.L D0
        MOVE.B -70(A6),D0
        TST.L D0
        BNE.W LBL_316
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_317
LBL_316:
        MOVEQ #1,D0
LBL_317:
        BRA.W LBL_313
LBL_312:
        MOVEQ #0,D0
LBL_313:
        TST.L D0
        BEQ.W LBL_318
        MOVEQ #1,D0
        MOVE.B D0,-74(A6)
LBL_318:
        MOVEQ #0,D0
        MOVE.B D0,-76(A6)
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_321
        MOVE.L -52(A6),D1
        MOVEQ #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_322
LBL_321:
        MOVEQ #0,D0
LBL_322:
        TST.L D0
        BEQ.W LBL_319
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_320
LBL_319:
        MOVEQ #0,D0
LBL_320:
        TST.L D0
        BEQ.W LBL_323
        MOVEQ #1,D0
        MOVE.B D0,-76(A6)
LBL_323:
        CLR.L D0
        MOVE.B -70(A6),D0
        TST.L D0
        BNE.W LBL_324
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_325
LBL_324:
        MOVEQ #1,D0
LBL_325:
        TST.L D0
        BEQ.W LBL_326
        CLR.L D0
        MOVE.B -74(A6),D0
        TST.L D0
        BEQ.W LBL_328
        MOVE.L -16(A6),D1
        MOVE.L -56(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_329
LBL_328:
        MOVE.L -16(A6),D1
        MOVE.L -56(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-64(A6)
LBL_329:
        BRA.W LBL_327
LBL_326:
        MOVE.L -44(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_330
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_331
LBL_330:
        MOVEQ #0,D0
LBL_331:
        TST.L D0
        BEQ.W LBL_332
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_334
        MOVE.L #130,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_335
LBL_334:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
LBL_335:
        BRA.W LBL_333
LBL_332:
        MOVE.L -44(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_336
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_337
LBL_336:
        MOVEQ #0,D0
LBL_337:
        TST.L D0
        BEQ.W LBL_338
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_340
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        BRA.W LBL_341
LBL_340:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
LBL_341:
        BRA.W LBL_339
LBL_338:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_342
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        BRA.W LBL_343
LBL_342:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-64(A6)
LBL_343:
LBL_339:
LBL_333:
LBL_327:
        MOVE.L -64(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_344
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
LBL_344:
        CLR.L D0
        MOVE.B -72(A6),D0
        TST.L D0
        BEQ.W LBL_345
        CLR.L D0
        MOVE.B -76(A6),D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L -20(A6),D1
        MOVE.L -60(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-68(A6)
        BRA.W LBL_347
LBL_346:
        MOVE.L -20(A6),D1
        MOVE.L -60(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-68(A6)
LBL_347:
        MOVE.L -68(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_348
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
LBL_348:
LBL_345:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -56(A6),D1
        MOVE.L -64(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -44(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_349
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_350
LBL_349:
        MOVEQ #1,D0
LBL_350:
        TST.L D0
        BEQ.W LBL_351
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDQ.L #8,A7
        BRA.W LBL_352
LBL_351:
        MOVE.L -44(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_353
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 2466(A5)
        ADDQ.L #8,A7
        BRA.W LBL_354
LBL_353:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_355
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A959  ; UiMoveControl
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A95C  ; UiSizeControl
LBL_355:
LBL_354:
LBL_352:
        MOVE.L -56(A6),D0
        MOVE.L D0,-24(A6)
        MOVE.L -56(A6),D1
        MOVE.L -64(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -60(A6),D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_300
LBL_301:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_299:
        UNLK A6
        RTS
        ; func rtUiMakeWidgets  (JT slot 240)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local savedPort : -12(A6)  size 4
        ;   local placeholder : -16(A6)  size 4
        ;   local emptyStr : -20(A6)  size 4
        ;   local n : -24(A6)  size 4
        ;   local i : -28(A6)  size 4
        ;   local kind : -32(A6)  size 4
        ;   local cap : -36(A6)  size 4
        ;   local ctrl : -40(A6)  size 4
        ;   local ctrlMp : -44(A6)  size 4
        ;   local teH : -48(A6)  size 4
        ;   local teMp : -52(A6)  size 4
        ;   local hb : -56(A6)  size 4
        ;   local hbMp : -60(A6)  size 4
        ;   local flags : -64(A6)  size 4
        ;   local mh : -68(A6)  size 4
        ;   local formOff : -72(A6)  size 4
        ;   local fieldIndex : -76(A6)  size 4
        ;   local layoutOff : -80(A6)  size 4
        ;   local enumCount : -84(A6)  size 4
        ;   local enumLabelsOff : -88(A6)  size 4
        ;   local b : -92(A6)  size 4
        ;   local lh : -96(A6)  size 4
        ;   local dataBoundsRect : -100(A6)  size 4
        ;   local rowH : -104(A6)  size 4
        ;   local cellSizePacked : -108(A6)  size 4
        ;   local stubH : -112(A6)  size 4
        ;   local tableOff : -116(A6)  size 4
        ;   local __switch5 : -120(A6)  size 4
LBL_24:
        LINK A6,#-2220
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVEQ #0,D0
        MOVE.L D0,-48(A6)
        MOVEQ #0,D0
        MOVE.L D0,-52(A6)
        MOVEQ #0,D0
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
        MOVEQ #0,D0
        MOVE.L D0,-72(A6)
        MOVEQ #0,D0
        MOVE.L D0,-76(A6)
        MOVEQ #0,D0
        MOVE.L D0,-80(A6)
        MOVEQ #0,D0
        MOVE.L D0,-84(A6)
        MOVEQ #0,D0
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-92(A6)
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
        MOVEQ #0,D0
        MOVE.L D0,-100(A6)
        MOVEQ #0,D0
        MOVE.L D0,-104(A6)
        MOVEQ #0,D0
        MOVE.L D0,-108(A6)
        MOVEQ #0,D0
        MOVE.L D0,-112(A6)
        MOVEQ #0,D0
        MOVE.L D0,-116(A6)
        MOVEQ #0,D0
        MOVE.L D0,-120(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_19
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 698(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_357:
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 778(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_359
        MOVE.L -20(A6),D0
        MOVE.L D0,-36(A6)
LBL_359:
        MOVE.L -32(A6),D0
        MOVE.L D0,-120(A6)
        MOVE.L -120(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #34,A7
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        BRA.W LBL_361
LBL_360:
        MOVE.L -120(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #34,A7
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        BRA.W LBL_363
LBL_362:
        MOVE.L -120(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_364
        MOVE.L -120(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_365
LBL_364:
        MOVEQ #1,D0
LBL_365:
        TST.L D0
        BEQ.W LBL_366
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 778(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        BRA.W LBL_367
LBL_366:
        MOVE.L -120(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_368
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 778(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_369
LBL_368:
        MOVE.L -120(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_370
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        MOVEQ #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A813  ; UiTEAutoView
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 842(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-64(A6)
        MOVE.L -64(A6),D1
        MOVEQ #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_372
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #34,A7
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D1
        MOVE.L -28(A6),D0
        OR.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_373
LBL_372:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
LBL_373:
        MOVE.L -64(A6),D1
        MOVEQ #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_374
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L -52(A6),D1
        MOVEQ #72,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #34,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDA.W #12,A7
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-60(A6)
        MOVE.L -60(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #49152,D1
        MOVE.L -28(A6),D0
        OR.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_375
LBL_374:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDA.W #12,A7
LBL_375:
        BRA.W LBL_371
LBL_370:
        MOVE.L -120(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 778(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDA.W #12,A7
        MOVE.L #1000,D1
        MOVE.L -28(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        MOVE.L D0,-(A7)
        JSR 1354(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1138(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-76(A6)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_378
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        JSR 1090(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        JSR 1266(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-92(A6)
LBL_379:
        MOVE.L -92(A6),D1
        MOVE.L -84(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_93(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        JSR 1298(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A947  ; UiSetMenuItemText
        MOVE.L -92(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-92(A6)
        BRA.W LBL_379
LBL_380:
LBL_378:
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.W D0,-(A7)
        DC.W $A935  ; UiInsertMenu
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDA.W #12,A7
        BRA.W LBL_377
LBL_376:
        MOVE.L -120(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_381
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        BSR.W LBL_80
        MOVE.L D0,-104(A6)
        MOVE.L -104(A6),D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        OR.L D1,D0
        MOVE.L D0,-108(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-100(A6)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_67
        ADDA.W #28,A7
        MOVE.L D0,-96(A6)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -96(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_383
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_383:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDA.W #12,A7
        MOVE.L -96(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #128,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-116(A6)
        MOVE.L -96(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BSR.W LBL_82
        MOVE.L D0,-112(A6)
        MOVE.L -96(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #64,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -112(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #44,-(A7)
        DC.W $A9E7  ; UiLSetDrawingMode
        BRA.W LBL_382
LBL_381:
        LEA LBL_92(PC),A0
        MOVE.L A0,-(A7)
        JSR 3242(A5)
        ADDQ.L #4,A7
        BSR.W LBL_100
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
LBL_382:
LBL_377:
LBL_371:
LBL_369:
LBL_367:
LBL_363:
LBL_361:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_384
        MOVE.L -32(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_385
LBL_384:
        MOVEQ #0,D0
LBL_385:
        TST.L D0
        BEQ.W LBL_386
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_386:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_357
LBL_358:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_356:
        UNLK A6
        RTS
        ; func rtUiWidgetSetStr  (JT slot 241)
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param prop : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local savedPort : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local ctrl : -20(A6)  size 4
        ;   local te : -24(A6)  size 4
        ;   local len : -28(A6)  size 4
        ;   local hstate : -32(A6)  size 4
LBL_25:
        LINK A6,#-2132
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
        MOVE.L D0,-32(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_19
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 762(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2746(A5)
        ADDA.W #16,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_388
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_389
LBL_388:
        MOVEQ #0,D0
LBL_389:
        TST.L D0
        BEQ.W LBL_390
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A9CE  ; UiTextBox
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A92A  ; UiValidRect
        BRA.W LBL_391
LBL_390:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_394
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_395
LBL_394:
        MOVEQ #0,D0
LBL_395:
        TST.L D0
        BEQ.W LBL_392
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_393
LBL_392:
        MOVEQ #0,D0
LBL_393:
        TST.L D0
        BEQ.W LBL_396
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A95F  ; UiSetControlTitle
        BRA.W LBL_397
LBL_396:
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_401
LBL_400:
        MOVEQ #0,D0
LBL_401:
        TST.L D0
        BEQ.W LBL_398
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_399
LBL_398:
        MOVEQ #0,D0
LBL_399:
        TST.L D0
        BEQ.W LBL_402
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_404
LBL_403:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_404:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9CF  ; UiTESetText
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-32(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_59
        ADDA.W #10,A7
LBL_402:
LBL_397:
LBL_391:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_387:
        UNLK A6
        RTS
        ; func rtUiWidgetGetStr  (JT slot 242)
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param prop : 12(A6)  size 4
        ;   param dst255 : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local teMp : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
        ;   local hText : -24(A6)  size 4
LBL_26:
        LINK A6,#-2124
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
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_407
LBL_406:
        MOVEQ #0,D0
LBL_407:
        TST.L D0
        BEQ.W LBL_408
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        BRA.W LBL_409
LBL_408:
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_410
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_411
LBL_410:
        MOVEQ #0,D0
LBL_411:
        TST.L D0
        BEQ.W LBL_412
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_413
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
        MOVE.L #255,D0
        MOVE.L D0,-20(A6)
LBL_414:
        MOVE.L -16(A6),D1
        MOVEQ #62,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_413:
LBL_412:
LBL_409:
LBL_405:
        UNLK A6
        RTS
        ; func rtUiWidgetGetText  (JT slot 243)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local teMp : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
        ;   local hText : -24(A6)  size 4
LBL_27:
        LINK A6,#-2124
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_416
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_417
LBL_416:
        MOVEQ #1,D0
LBL_417:
        TST.L D0
        BEQ.W LBL_418
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #16,A7
        BRA.W LBL_415
LBL_418:
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVEQ #62,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #16,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
LBL_415:
        UNLK A6
        RTS
        ; func rtUiWidgetSetText  (JT slot 244)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local teMp : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
        ;   local buf : -24(A6)  size 4
        ;   local copied : -28(A6)  size 4
        ;   local contentBottom : -32(A6)  size 4
        ;   local viewTop : -36(A6)  size 4
        ;   local viewBottom : -40(A6)  size 4
        ;   local eraseRect : -44(A6)  size 4
        ;   local hstate : -48(A6)  size 4
LBL_28:
        LINK A6,#-2148
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVEQ #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_420
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_421
LBL_420:
        MOVEQ #1,D0
LBL_421:
        TST.L D0
        BEQ.W LBL_422
        BRA.W LBL_419
LBL_422:
        BSR.W LBL_19
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #32000,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_423
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_423:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32000,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9CF  ; UiTESetText
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-48(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_59
        ADDA.W #10,A7
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-36(A6)
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #94,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
        MOVE.L -36(A6),D0
        MOVE.L D0,-32(A6)
LBL_424:
        MOVE.L -32(A6),D1
        MOVE.L -40(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_425:
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D3  ; UiTEUpdate
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A92A  ; UiValidRect
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_419:
        UNLK A6
        RTS
        ; func rtUiPeekSw  (JT slot 245)
        ;   param p : 8(A6)  size 4
        ;   local v : -4(A6)  size 4
LBL_29:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
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
        BEQ.W LBL_427
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_427:
        MOVE.L -4(A6),D0
        BRA.W LBL_426
LBL_426:
        UNLK A6
        RTS
        ; func rtUiWidgetScrollToEnd  (JT slot 246)
        ;   param instV : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local te : -8(A6)  size 4
        ;   local teMp : -12(A6)  size 4
        ;   local sb : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
        ;   local viewH : -24(A6)  size 4
        ;   local contentH : -28(A6)  size 4
        ;   local maxScroll : -32(A6)  size 4
        ;   local offset : -36(A6)  size 4
LBL_30:
        LINK A6,#-2136
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_429
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_430
LBL_429:
        MOVEQ #1,D0
LBL_430:
        TST.L D0
        BEQ.W LBL_431
        BRA.W LBL_428
LBL_431:
        BSR.W LBL_19
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -12(A6),D1
        MOVEQ #94,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_97
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_432:
        MOVE.L -32(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        MOVE.L #32767,D0
        MOVE.L D0,-32(A6)
LBL_433:
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D1
        MOVE.L -32(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -36(A6),D1
        MOVE.L -32(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_435:
LBL_434:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_428:
        UNLK A6
        RTS
        ; func rtUiWidgetSetBool  (JT slot 247)
        ;   param instV : 18(A6)  size 4
        ;   param wIdx : 14(A6)  size 4
        ;   param prop : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local savedPort : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local ctrl : -20(A6)  size 4
LBL_31:
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
        MOVE.L 18(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_19
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        JSR 762(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-(A7)
        JSR 2754(A5)
        ADDA.W #14,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
        MOVE.L 10(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_440
LBL_439:
        MOVEQ #0,D0
LBL_440:
        TST.L D0
        BEQ.W LBL_437
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_438
LBL_437:
        MOVEQ #0,D0
LBL_438:
        TST.L D0
        BEQ.W LBL_441
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_443
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_444
LBL_443:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_444:
        BRA.W LBL_442
LBL_441:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
        MOVE.L 10(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_448
LBL_447:
        MOVEQ #0,D0
LBL_448:
        TST.L D0
        BEQ.W LBL_445
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_446
LBL_445:
        MOVEQ #0,D0
LBL_446:
        TST.L D0
        BEQ.W LBL_449
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_18
        ADDA.W #10,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_450
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_451
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
        BRA.W LBL_452
LBL_451:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
LBL_452:
LBL_450:
LBL_449:
LBL_442:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_436:
        UNLK A6
        RTS
        ; func rtUiWidgetSetInt  (JT slot 248)
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param prop : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local savedPort : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local count : -20(A6)  size 4
        ;   local sel : -24(A6)  size 4
        ;   local lh : -28(A6)  size 4
        ;   local hstate : -32(A6)  size 4
        ;   local tableOff : -36(A6)  size 4
        ;   local rowsIdx : -40(A6)  size 4
        ;   local rowsAddr : -44(A6)  size 4
        ;   local rows : -48(A6)  size 4
        ;   local row : -52(A6)  size 4
LBL_32:
        LINK A6,#-2152
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVEQ #0,D0
        MOVE.L D0,-48(A6)
        MOVEQ #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_19
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_455
LBL_454:
        MOVEQ #0,D0
LBL_455:
        TST.L D0
        BEQ.W LBL_456
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        CLR.W -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A950  ; UiCountMItems
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_458
LBL_457:
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_458:
        MOVE.L 8(A6),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
LBL_459:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_460
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_461
LBL_460:
        MOVEQ #0,D0
LBL_461:
        TST.L D0
        BEQ.W LBL_462
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
LBL_462:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
LBL_463:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 762(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2762(A5)
        ADDA.W #16,A7
LBL_456:
        MOVE.L -16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_464
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_465
LBL_464:
        MOVEQ #0,D0
LBL_465:
        TST.L D0
        BEQ.W LBL_466
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1146(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 3530(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-52(A6)
        MOVE.L -52(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-52(A6)
LBL_467:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #8,A7
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 762(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR 2762(A5)
        ADDA.W #16,A7
LBL_466:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_453:
        UNLK A6
        RTS
        ; func rtUiWidgetGetBool  (JT slot 249)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local kind : -12(A6)  size 4
        ;   local ctrl : -16(A6)  size 4
LBL_33:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_472
LBL_471:
        MOVEQ #0,D0
LBL_472:
        TST.L D0
        BEQ.W LBL_469
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_470
LBL_469:
        MOVEQ #0,D0
LBL_470:
        TST.L D0
        BEQ.W LBL_473
        CLR.W -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_468
LBL_473:
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_476
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_477
LBL_476:
        MOVEQ #0,D0
LBL_477:
        TST.L D0
        BEQ.W LBL_474
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_475
LBL_474:
        MOVEQ #0,D0
LBL_475:
        TST.L D0
        BEQ.W LBL_478
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        BRA.W LBL_468
LBL_478:
        MOVEQ #0,D0
        BRA.W LBL_468
LBL_468:
        UNLK A6
        RTS
        ; func rtUiWidgetGetInt  (JT slot 250)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local r : -8(A6)  size 4
        ;   local kind : -12(A6)  size 4
LBL_34:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_480
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_479
LBL_480:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        MOVE.L -12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_482
LBL_481:
        MOVEQ #0,D0
LBL_482:
        TST.L D0
        BEQ.W LBL_483
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        BRA.W LBL_479
LBL_483:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_484
        MOVE.L -12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_485
LBL_484:
        MOVEQ #0,D0
LBL_485:
        TST.L D0
        BEQ.W LBL_486
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        BRA.W LBL_479
LBL_486:
        MOVE.L -8(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_479
LBL_479:
        UNLK A6
        RTS
        ; func rtUiScratchBitMapGet  (JT slot 251)
LBL_35:
        LINK A6,#-2100
        MOVE.L -42(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_488
        MOVEQ #14,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-42(A5)
LBL_488:
        MOVE.L -42(A5),D0
        BRA.W LBL_487
LBL_487:
        UNLK A6
        RTS
        ; func rtUiBitMapFill  (JT slot 252)
        ;   param cb : 8(A6)  size 4
        ;   local bm : -4(A6)  size 4
LBL_36:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_35
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_489
LBL_489:
        UNLK A6
        RTS
        ; func rtUiCanvasDispose  (JT slot 253)
        ;   param cb : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_37:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_491
        BRA.W LBL_490
LBL_491:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A87D  ; UiClosePort
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_490:
        UNLK A6
        RTS
        ; func rtUiCanvasMake  (JT slot 254)
        ;   param cb : 16(A6)  size 4
        ;   param ww : 12(A6)  size 4
        ;   param hh : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
        ;   local rowBytes : -8(A6)  size 4
        ;   local bm : -12(A6)  size 4
        ;   local w2 : -16(A6)  size 4
        ;   local h2 : -20(A6)  size 4
LBL_38:
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_493
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
LBL_493:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_494
        MOVEQ #1,D0
        MOVE.L D0,-20(A6)
LBL_494:
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #108,D0
        MOVE.L D0,-(A7)
        JSR 1330(A5)
        ADDQ.L #4,A7
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_495
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_495:
        MOVE.L -16(A6),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        BSR.W LBL_98
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_97
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L -20(A6),D0
        BSR.W LBL_97
        MOVE.L D0,-(A7)
        JSR 1330(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_496
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_496:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A86F  ; UiOpenPort
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A875  ; UiSetPortBits
        MOVE.L -16(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A876  ; UiPortSize
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A878  ; UiSetOrigin
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_492:
        UNLK A6
        RTS
        ; func rtUiCanvasReallocAll  (JT slot 255)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local kind : -20(A6)  size 4
        ;   local flags : -24(A6)  size 4
        ;   local r : -28(A6)  size 4
LBL_39:
        LINK A6,#-2128
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 698(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_498:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_499
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 842(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_500
        MOVE.L -24(A6),D1
        MOVEQ #4,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_501
LBL_500:
        MOVEQ #0,D0
LBL_501:
        TST.L D0
        BEQ.W LBL_502
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDA.W #12,A7
LBL_502:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_498
LBL_499:
LBL_497:
        UNLK A6
        RTS
        ; func rtUiFlushBufferedCanvases  (JT slot 256)
        ;   param inst : 10(A6)  size 4
        ;   param force : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local buf : -20(A6)  size 4
        ;   local bm : -24(A6)  size 4
LBL_40:
        LINK A6,#-2124
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
        MOVE.L 10(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_504
        BRA.W LBL_503
LBL_504:
        MOVE.L 10(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 698(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_505:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_506
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_507
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BNE.W LBL_509
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_510
LBL_509:
        MOVEQ #1,D0
LBL_510:
        BRA.W LBL_508
LBL_507:
        MOVEQ #0,D0
LBL_508:
        TST.L D0
        BEQ.W LBL_511
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A8EC  ; UiCopyBits
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_511:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_505
LBL_506:
LBL_503:
        UNLK A6
        RTS
        ; func rtUiCanvasBegin  (JT slot 257)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local t : -24(A6)  size 16
        ;   local r : -28(A6)  size 4
LBL_41:
        LINK A6,#-2128
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_513
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_514
LBL_513:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_514:
        BSR.W LBL_19
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -24(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BRA.W LBL_512
LBL_512:
        UNLK A6
        RTS
        ; func rtUiCanvasEnd  (JT slot 258)
        ;   param t : 8(A6)  size 4
LBL_42:
        LINK A6,#-2100
        MOVEA.L 8(A6),A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_515:
        UNLK A6
        RTS
        ; func rtUiGrayPatsGet  (JT slot 259)
        ;   local p : -4(A6)  size 4
LBL_43:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        MOVE.L -46(A5),D0
        BRA.W LBL_516
LBL_517:
        MOVEQ #72,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #17,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #19,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #21,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #23,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #25,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #29,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #30,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #31,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #33,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #35,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #37,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #39,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #41,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #43,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #45,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #46,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #47,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #49,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #51,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #52,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #53,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #54,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #55,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #56,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #57,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #58,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #59,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #61,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #62,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #63,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #64,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #65,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #66,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #67,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #68,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #69,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #71,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-46(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_516
LBL_516:
        UNLK A6
        RTS
        ; func rtUiCanvasPattern  (JT slot 260)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param level : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local lv : -12(A6)  size 4
LBL_44:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_519
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_519:
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
        MOVEQ #8,D0
        MOVE.L D0,-12(A6)
LBL_520:
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_518:
        UNLK A6
        RTS
        ; func rtUiCanvasClear  (JT slot 261)
        ;   param instV : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
        ;   local w : -20(A6)  size 4
        ;   local buf : -24(A6)  size 4
        ;   local scratch : -28(A6)  size 4
LBL_45:
        LINK A6,#-2128
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_522
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_523
LBL_522:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
LBL_523:
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
LBL_521:
        UNLK A6
        RTS
        ; func rtUiCanvasLine  (JT slot 262)
        ;   param instV : 28(A6)  size 4
        ;   param wIdx : 24(A6)  size 4
        ;   param x0 : 20(A6)  size 4
        ;   param y0 : 16(A6)  size 4
        ;   param x1 : 12(A6)  size 4
        ;   param y1 : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
LBL_46:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A891  ; UiLineTo
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
LBL_524:
        UNLK A6
        RTS
        ; func rtUiCanvasRect  (JT slot 263)
        ;   param instV : 30(A6)  size 4
        ;   param wIdx : 26(A6)  size 4
        ;   param x : 22(A6)  size 4
        ;   param y : 18(A6)  size 4
        ;   param ww : 14(A6)  size 4
        ;   param hh : 10(A6)  size 4
        ;   param fill : 8(A6)  size 2
        ;   local t : -16(A6)  size 16
        ;   local w : -20(A6)  size 4
        ;   local buf : -24(A6)  size 4
        ;   local r : -28(A6)  size 4
        ;   local pats : -32(A6)  size 4
LBL_47:
        LINK A6,#-2132
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L 30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 26(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 26(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L 30(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 22(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 22(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 14(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_526
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 26(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        BSR.W LBL_43
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8A5  ; UiFillRect
        BRA.W LBL_527
LBL_526:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A1  ; UiFrameRect
LBL_527:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
LBL_525:
        UNLK A6
        RTS
        ; func rtUiCanvasFillCircle  (JT slot 264)
        ;   param instV : 24(A6)  size 4
        ;   param wIdx : 20(A6)  size 4
        ;   param x : 16(A6)  size 4
        ;   param y : 12(A6)  size 4
        ;   param radius : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
        ;   local w : -20(A6)  size 4
        ;   local buf : -24(A6)  size 4
        ;   local box : -28(A6)  size 4
        ;   local pats : -32(A6)  size 4
LBL_48:
        LINK A6,#-2132
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        BSR.W LBL_43
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8BB  ; UiFillOval
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
LBL_528:
        UNLK A6
        RTS
        ; func rtUiCanvasCircle  (JT slot 265)
        ;   param instV : 24(A6)  size 4
        ;   param wIdx : 20(A6)  size 4
        ;   param x : 16(A6)  size 4
        ;   param y : 12(A6)  size 4
        ;   param radius : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
        ;   local box : -20(A6)  size 4
LBL_49:
        LINK A6,#-2120
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8B7  ; UiFrameOval
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
LBL_529:
        UNLK A6
        RTS
        ; func rtUiCanvasDrawText  (JT slot 266)
        ;   param instV : 24(A6)  size 4
        ;   param wIdx : 20(A6)  size 4
        ;   param x : 16(A6)  size 4
        ;   param y : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
LBL_50:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A884  ; UiDrawString
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
LBL_530:
        UNLK A6
        RTS
        ; func UiTENew  (JT slot 267)
        ;   param dst : 12(A6)  size 4
        ;   param view : 8(A6)  size 4
LBL_51:
        LINK A6,#-2100
        BSR.W LBL_85
        CLR.L -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D2  ; UiTENewRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_531
LBL_531:
        UNLK A6
        RTS
        ; func nat_UiTEFromScrap  (JT slot 268)
        ;   local th : -4(A6)  size 4
        ;   local offSlot : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_52:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #2740,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        MOVEQ #102,D0
        NEG.L D0
        BRA.W LBL_532
LBL_533:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1413830740,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9FD  ; UiGetScrap
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_534
        MOVE.L -12(A6),D0
        BRA.W LBL_532
LBL_534:
        MOVE.L -12(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_535
        MOVE.L #32767,D0
        MOVE.L D0,-12(A6)
LBL_535:
        MOVE.L #2736,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_532
LBL_532:
        UNLK A6
        RTS
        ; func nat_UiTEToScrap  (JT slot 269)
        ;   local th : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
        ;   local err : -12(A6)  size 4
LBL_53:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #2740,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_537
        MOVEQ #0,D0
        BRA.W LBL_536
LBL_537:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        CLR.L -(A7)
        BSR.W LBL_54
        MOVE.L D0,-(A7)
        MOVE.L #1413830740,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A9FE  ; UiPutScrap
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
        MOVE.L -12(A6),D0
        BRA.W LBL_536
LBL_536:
        UNLK A6
        RTS
        ; func nat_UiTEGetScrapLength  (JT slot 270)
LBL_54:
        LINK A6,#-2100
        MOVE.L #2736,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_538
LBL_538:
        UNLK A6
        RTS
        ; func rtUiTeWidestLine  (JT slot 271)
        ;   param te : 8(A6)  size 4
        ;   local teMp : -4(A6)  size 4
        ;   local savedPort : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local a : -20(A6)  size 4
        ;   local b : -24(A6)  size 4
        ;   local hText : -28(A6)  size 4
        ;   local hTextMp : -32(A6)  size 4
        ;   local state : -36(A6)  size 4
        ;   local lineW : -40(A6)  size 4
        ;   local pos : -44(A6)  size 4
        ;   local chunkLen : -48(A6)  size 4
        ;   local widest : -52(A6)  size 4
LBL_55:
        LINK A6,#-2152
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVEQ #0,D0
        MOVE.L D0,-48(A6)
        MOVEQ #0,D0
        MOVE.L D0,-52(A6)
        MOVEQ #0,D0
        MOVE.L D0,-52(A6)
        BSR.W LBL_19
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #94,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D1
        MOVEQ #82,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D1
        MOVEQ #74,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A887  ; UiTextFont
        MOVE.L -4(A6),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A88A  ; UiTextSize
        MOVE.L -4(A6),D1
        MOVEQ #76,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A888  ; UiTextFace
        MOVE.L -4(A6),D1
        MOVEQ #62,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-36(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_540:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #96,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D1
        MOVEQ #96,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_542
        MOVE.L -32(A6),D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_543
LBL_542:
        MOVEQ #0,D0
LBL_543:
        TST.L D0
        BEQ.W LBL_544
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
LBL_544:
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-44(A6)
LBL_545:
        MOVE.L -44(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_546
        MOVE.L -24(A6),D1
        MOVE.L -44(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D1
        MOVE.L #1024,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_547
        MOVE.L #1024,D0
        MOVE.L D0,-48(A6)
LBL_547:
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        CLR.W -(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A886  ; UiTextWidth
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_548
        MOVE.L #32767,D0
        MOVE.L D0,-40(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-44(A6)
        BRA.W LBL_549
LBL_548:
        MOVE.L -44(A6),D1
        MOVE.L -48(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-44(A6)
LBL_549:
        BRA.W LBL_545
LBL_546:
        MOVE.L -40(A6),D1
        MOVE.L -52(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_550
        MOVE.L -40(A6),D0
        MOVE.L D0,-52(A6)
LBL_550:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_540
LBL_541:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -52(A6),D0
        BRA.W LBL_539
LBL_539:
        UNLK A6
        RTS
        ; func rtUiTeScrollSync  (JT slot 272)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local te : -8(A6)  size 4
        ;   local teMp : -12(A6)  size 4
        ;   local sb : -16(A6)  size 4
        ;   local hb : -20(A6)  size 4
        ;   local viewH : -24(A6)  size 4
        ;   local contentH : -28(A6)  size 4
        ;   local maxScroll : -32(A6)  size 4
        ;   local offset : -36(A6)  size 4
        ;   local viewW : -40(A6)  size 4
        ;   local widest : -44(A6)  size 4
LBL_56:
        LINK A6,#-2144
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_552
        BRA.W LBL_551
LBL_552:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_553
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -12(A6),D1
        MOVEQ #94,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_97
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_554
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_554:
        MOVE.L -32(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_555
        MOVE.L #32767,D0
        MOVE.L D0,-32(A6)
LBL_555:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A965  ; UiSetControlMaximum
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D1
        MOVE.L -32(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_556
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -36(A6),D1
        MOVE.L -32(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        MOVE.L -32(A6),D0
        MOVE.L D0,-36(A6)
LBL_556:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_553:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_557
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-40(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_558
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_558:
        MOVE.L -32(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_559
        MOVE.L #32767,D0
        MOVE.L D0,-32(A6)
LBL_559:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A965  ; UiSetControlMaximum
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D1
        MOVE.L -32(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_560
        MOVE.L -36(A6),D1
        MOVE.L -32(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        MOVE.L -32(A6),D0
        MOVE.L D0,-36(A6)
LBL_560:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_557:
LBL_551:
        UNLK A6
        RTS
        ; func rtUiTeClamp  (JT slot 273)
        ;   param te : 12(A6)  size 4
        ;   param maxLen : 8(A6)  size 4
        ;   local teMp : -4(A6)  size 4
        ;   local th : -8(A6)  size 4
        ;   local thMp : -12(A6)  size 4
        ;   local sel : -16(A6)  size 4
LBL_57:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_562
        BRA.W LBL_561
LBL_562:
        MOVE.L -4(A6),D1
        MOVEQ #62,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9CF  ; UiTESetText
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_563
        MOVE.L 8(A6),D0
        MOVE.L D0,-16(A6)
LBL_563:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D1  ; UiTESetSelect
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
LBL_561:
        UNLK A6
        RTS
        ; func rtUiFieldCap  (JT slot 274)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local formOff : -8(A6)  size 4
        ;   local fieldIdx : -12(A6)  size 4
        ;   local layoutOff : -16(A6)  size 4
        ;   local ftype : -20(A6)  size 4
        ;   local strCap : -24(A6)  size 4
LBL_58:
        LINK A6,#-2124
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
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_565
        MOVE.L #255,D0
        BRA.W LBL_564
LBL_565:
        CLR.L D0
        MOVE.B -124(A5),D0
        TST.L D0
        BEQ.W LBL_566
        MOVE.L -128(A5),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_567
LBL_566:
        MOVEQ #0,D0
LBL_567:
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_568
        MOVE.L #255,D0
        BRA.W LBL_564
LBL_568:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1138(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_569
        MOVE.L #255,D0
        BRA.W LBL_564
LBL_569:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1090(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_570
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1258(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_571
        MOVE.L -24(A6),D0
        BRA.W LBL_564
LBL_571:
LBL_570:
        MOVE.L -20(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_572
        MOVEQ #1,D0
        BRA.W LBL_564
LBL_572:
        MOVE.L #255,D0
        BRA.W LBL_564
LBL_564:
        UNLK A6
        RTS
        ; func rtUiTeMutated  (JT slot 275)
        ;   param inst : 14(A6)  size 4
        ;   param wIdx : 10(A6)  size 4
        ;   param userEdit : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local cap : -16(A6)  size 4
LBL_59:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_574
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_575
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_576
LBL_575:
        MOVE.L #32000,D0
        MOVE.L D0,-16(A6)
LBL_576:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #8,A7
LBL_574:
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        CLR.L D0
        MOVE.B 8(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
        BRA.W LBL_573
LBL_577:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 762(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_89(PC),A0
        MOVE.L A0,-(A7)
        JSR 2674(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 3498(A5)
        ADDA.W #24,A7
LBL_573:
        UNLK A6
        RTS
        ; func rtUiTeRelayout  (JT slot 276)
        ;   param inst : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local kind : -12(A6)  size 4
        ;   local flags : -16(A6)  size 4
        ;   local te : -20(A6)  size 4
        ;   local teMp : -24(A6)  size 4
        ;   local widthIsFill : -26(A6)  size 2
        ;   local fillBoth : -28(A6)  size 2
        ;   local flushR : -30(A6)  size 2
        ;   local flushB : -32(A6)  size 2
        ;   local vW : -36(A6)  size 4
        ;   local hH : -40(A6)  size 4
        ;   local frame : -44(A6)  size 4
        ;   local r : -48(A6)  size 4
        ;   local boxLeft : -52(A6)  size 4
        ;   local boxTop : -56(A6)  size 4
        ;   local boxRight : -60(A6)  size 4
        ;   local boxBottom : -64(A6)  size 4
        ;   local teLeft : -68(A6)  size 4
        ;   local teTop : -72(A6)  size 4
        ;   local teRight : -76(A6)  size 4
        ;   local teBottom : -80(A6)  size 4
        ;   local hasV : -82(A6)  size 2
        ;   local hasH : -84(A6)  size 2
        ;   local vTop : -88(A6)  size 4
        ;   local hLeft : -92(A6)  size 4
        ;   local sbBottom : -96(A6)  size 4
        ;   local sbRight : -100(A6)  size 4
        ;   local ctrl : -104(A6)  size 4
        ;   local hb : -108(A6)  size 4
LBL_60:
        LINK A6,#-2208
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
        MOVE.B D0,-26(A6)
        MOVEQ #0,D0
        MOVE.B D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
        MOVEQ #0,D0
        MOVE.B D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-44(A6)
        MOVEQ #0,D0
        MOVE.L D0,-48(A6)
        MOVEQ #0,D0
        MOVE.L D0,-52(A6)
        MOVEQ #0,D0
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
        MOVEQ #0,D0
        MOVE.L D0,-72(A6)
        MOVEQ #0,D0
        MOVE.L D0,-76(A6)
        MOVEQ #0,D0
        MOVE.L D0,-80(A6)
        MOVEQ #0,D0
        MOVE.B D0,-82(A6)
        MOVEQ #0,D0
        MOVE.B D0,-84(A6)
        MOVEQ #0,D0
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-92(A6)
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
        MOVEQ #0,D0
        MOVE.L D0,-100(A6)
        MOVEQ #0,D0
        MOVE.L D0,-104(A6)
        MOVEQ #0,D0
        MOVE.L D0,-108(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_579
        BRA.W LBL_578
LBL_579:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 842(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 818(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-26(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_582
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_583
LBL_582:
        MOVEQ #0,D0
LBL_583:
        TST.L D0
        BEQ.W LBL_580
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BNE.W LBL_584
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_585
LBL_584:
        MOVEQ #1,D0
LBL_585:
        BRA.W LBL_581
LBL_580:
        MOVEQ #0,D0
LBL_581:
        TST.L D0
        BEQ.W LBL_586
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_586:
        MOVEQ #0,D0
        MOVE.B D0,-32(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_589
        MOVE.L -16(A6),D1
        MOVEQ #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_590
LBL_589:
        MOVEQ #0,D0
LBL_590:
        TST.L D0
        BEQ.W LBL_587
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_588
LBL_587:
        MOVEQ #0,D0
LBL_588:
        TST.L D0
        BEQ.W LBL_591
        MOVEQ #1,D0
        MOVE.B D0,-32(A6)
LBL_591:
        MOVEQ #15,D0
        MOVE.L D0,-36(A6)
        CLR.L D0
        MOVE.B -30(A6),D0
        TST.L D0
        BEQ.W LBL_592
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_592:
        MOVEQ #15,D0
        MOVE.L D0,-40(A6)
        CLR.L D0
        MOVE.B -32(A6),D0
        TST.L D0
        BEQ.W LBL_593
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
LBL_593:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D1
        MOVEQ #3,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D1
        MOVEQ #3,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A9  ; UiInsetRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-56(A6)
        MOVE.L -48(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L -48(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-64(A6)
        MOVE.L -48(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-60(A6)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_594
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_595
LBL_594:
        MOVEQ #0,D0
LBL_595:
        TST.L D0
        BEQ.W LBL_596
        MOVE.L -52(A6),D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
LBL_596:
        MOVE.L -52(A6),D0
        MOVE.L D0,-68(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,-72(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,-76(A6)
        MOVE.L -64(A6),D0
        MOVE.L D0,-80(A6)
        MOVEQ #0,D0
        MOVE.L D0,-108(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,-104(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-108(A6)
        MOVE.L -104(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-82(A6)
        MOVE.L -108(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-84(A6)
        CLR.L D0
        MOVE.B -82(A6),D0
        TST.L D0
        BEQ.W LBL_598
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_599
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_600
LBL_599:
        MOVE.L -56(A6),D0
        MOVE.L D0,-88(A6)
LBL_600:
        MOVE.L -64(A6),D0
        MOVE.L D0,-96(A6)
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_601
        MOVE.L -64(A6),D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-96(A6)
LBL_601:
        MOVE.L -104(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L -36(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -88(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A959  ; UiMoveControl
        MOVE.L -104(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -96(A6),D1
        MOVE.L -88(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A95C  ; UiSizeControl
        MOVE.L -76(A6),D1
        MOVE.L -36(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-76(A6)
LBL_598:
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_602
        MOVE.L -52(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_603
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-92(A6)
        BRA.W LBL_604
LBL_603:
        MOVE.L -52(A6),D0
        MOVE.L D0,-92(A6)
LBL_604:
        MOVE.L -60(A6),D0
        MOVE.L D0,-100(A6)
        CLR.L D0
        MOVE.B -82(A6),D0
        TST.L D0
        BEQ.W LBL_605
        MOVE.L -60(A6),D1
        MOVE.L -36(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-100(A6)
LBL_605:
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -64(A6),D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A959  ; UiMoveControl
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A6),D1
        MOVE.L -92(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A95C  ; UiSizeControl
        MOVE.L -80(A6),D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-80(A6)
LBL_602:
LBL_597:
        MOVE.L -68(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-68(A6)
        MOVE.L -72(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-72(A6)
        MOVE.L -76(A6),D1
        MOVEQ #3,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-76(A6)
        MOVE.L -80(A6),D1
        MOVEQ #3,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-80(A6)
        MOVE.L -76(A6),D1
        MOVE.L -68(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_606
        MOVE.L -68(A6),D0
        MOVE.L D0,-76(A6)
LBL_606:
        MOVE.L -80(A6),D1
        MOVE.L -72(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_607
        MOVE.L -72(A6),D0
        MOVE.L D0,-80(A6)
LBL_607:
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_608
        MOVE.L -108(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_609
LBL_608:
        MOVEQ #0,D0
LBL_609:
        TST.L D0
        BEQ.W LBL_610
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D1
        MOVE.L #2000,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_610:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -80(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D1
        MOVEQ #3,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D1
        MOVEQ #3,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A9  ; UiInsetRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_578:
        UNLK A6
        RTS
        ; func rtUiTeSetFocus  (JT slot 277)
        ;   param inst : 12(A6)  size 4
        ;   param newIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local te : -8(A6)  size 4
LBL_61:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_612
        BRA.W LBL_611
LBL_612:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_614
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D9  ; UiTEDeactivate
LBL_614:
LBL_613:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_615
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_616
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D8  ; UiTEActivate
LBL_616:
LBL_615:
        JSR 1594(A5)
LBL_611:
        UNLK A6
        RTS
        ; func rtUiTeHit  (JT slot 278)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local te : -20(A6)  size 4
LBL_62:
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 698(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_618:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_619
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_620
        MOVE.L -16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_621
LBL_620:
        MOVEQ #1,D0
LBL_621:
        TST.L D0
        BEQ.W LBL_622
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_623
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_624
LBL_623:
        MOVEQ #0,D0
LBL_624:
        TST.L D0
        BEQ.W LBL_625
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_617
LBL_625:
LBL_622:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_618
LBL_619:
        MOVEQ #0,D0
        BRA.W LBL_617
LBL_617:
        UNLK A6
        RTS
        ; func rtUiScrollbarAction  (JT slot 279)
        ;   param ctrl : 12(A6)  size 4
        ;   param part : 8(A6)  size 4
        ;   local ctrlMp : -4(A6)  size 4
        ;   local wp : -8(A6)  size 4
        ;   local inst : -12(A6)  size 4
        ;   local rfCon : -16(A6)  size 4
        ;   local horiz : -18(A6)  size 2
        ;   local wIdx : -22(A6)  size 4
        ;   local te : -26(A6)  size 4
        ;   local teMp : -30(A6)  size 4
        ;   local step : -34(A6)  size 4
        ;   local viewW : -38(A6)  size 4
        ;   local lineH : -42(A6)  size 4
        ;   local viewH : -46(A6)  size 4
        ;   local oldVal : -50(A6)  size 4
        ;   local newVal : -54(A6)  size 4
        ;   local maxVal : -58(A6)  size 4
        ;   local applied : -62(A6)  size 4
LBL_63:
        LINK A6,#-2162
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.B D0,-18(A6)
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
        MOVEQ #0,D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        MOVEQ #0,D0
        MOVE.L D0,-38(A6)
        MOVEQ #0,D0
        MOVE.L D0,-42(A6)
        MOVEQ #0,D0
        MOVE.L D0,-46(A6)
        MOVEQ #0,D0
        MOVE.L D0,-50(A6)
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        MOVEQ #0,D0
        MOVE.L D0,-58(A6)
        MOVEQ #0,D0
        MOVE.L D0,-62(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        BRA.W LBL_626
LBL_627:
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_628
        BRA.W LBL_626
LBL_628:
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVE.L #16384,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-18(A6)
        MOVE.L -16(A6),D1
        MOVE.L #16383,D0
        AND.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_629
        BRA.W LBL_626
LBL_629:
        MOVE.L -26(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_630
        MOVE.L -30(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-38(A6)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_632
        MOVEQ #0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_633
LBL_632:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_634
        MOVEQ #8,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_635
LBL_634:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_636
        MOVEQ #0,D1
        MOVE.L -38(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_637
LBL_636:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_638
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_639
LBL_638:
        BRA.W LBL_626
LBL_639:
LBL_637:
LBL_635:
LBL_633:
        BRA.W LBL_631
LBL_630:
        MOVE.L -30(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-42(A6)
        MOVE.L -42(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_640
        MOVEQ #1,D0
        MOVE.L D0,-42(A6)
LBL_640:
        MOVE.L -30(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-46(A6)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_641
        MOVEQ #0,D1
        MOVE.L -42(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_642
LBL_641:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_643
        MOVE.L -42(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_644
LBL_643:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_645
        MOVEQ #0,D1
        MOVE.L -46(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_646
LBL_645:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        MOVE.L -46(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_648
LBL_647:
        BRA.W LBL_626
LBL_648:
LBL_646:
LBL_644:
LBL_642:
LBL_631:
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-50(A6)
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A962  ; UiGetControlMaximum
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-58(A6)
        MOVE.L -50(A6),D1
        MOVE.L -34(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-54(A6)
        MOVE.L -54(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_649
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
LBL_649:
        MOVE.L -54(A6),D1
        MOVE.L -58(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_650
        MOVE.L -58(A6),D0
        MOVE.L D0,-54(A6)
LBL_650:
        MOVE.L -50(A6),D1
        MOVE.L -54(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-62(A6)
        MOVE.L -62(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_651
        BRA.W LBL_626
LBL_651:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_652
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_653
LBL_652:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_653:
LBL_626:
        UNLK A6
        RTS
        ; func rtUiHandleScrollbarClick  (JT slot 280)
        ;   param inst : 24(A6)  size 4
        ;   param ctrl : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param cpart : 12(A6)  size 4
        ;   param wherePt : 8(A6)  size 4
        ;   local ctrlMp : -4(A6)  size 4
        ;   local horiz : -6(A6)  size 2
        ;   local oldVal : -10(A6)  size 4
        ;   local newVal : -14(A6)  size 4
        ;   local te : -18(A6)  size 4
LBL_64:
        LINK A6,#-2118
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        CLR.L D0
        MOVE.B -48(A5),D0
        TST.L D0
        BEQ.W LBL_655
        MOVE.L 12(A6),D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_660
        MOVE.L 12(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_661
LBL_660:
        MOVEQ #1,D0
LBL_661:
        TST.L D0
        BNE.W LBL_658
        MOVE.L 12(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_659
LBL_658:
        MOVEQ #1,D0
LBL_659:
        TST.L D0
        BNE.W LBL_656
        MOVE.L 12(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_657
LBL_656:
        MOVEQ #1,D0
LBL_657:
        TST.L D0
        BEQ.W LBL_662
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #8,A7
LBL_662:
        BRA.W LBL_654
LBL_655:
        MOVE.L 12(A6),D1
        MOVE.L #129,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_663
        MOVE.L 20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #16384,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-6(A6)
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-10(A6)
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_665
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-14(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D1
        MOVE.L -10(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_666
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_667
LBL_666:
        MOVEQ #0,D0
LBL_667:
        TST.L D0
        BEQ.W LBL_668
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_669
        MOVE.L -10(A6),D1
        MOVE.L -14(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_670
LBL_669:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -10(A6),D1
        MOVE.L -14(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_670:
LBL_668:
LBL_665:
        BRA.W LBL_664
LBL_663:
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA 3562(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
LBL_664:
LBL_654:
        UNLK A6
        RTS
        ; func rtUiTeIdleFront  (JT slot 281)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local te : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
LBL_65:
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
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_672
        BRA.W LBL_671
LBL_672:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_673
        BRA.W LBL_671
LBL_673:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_674
        BRA.W LBL_671
LBL_674:
        BSR.W LBL_19
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DA  ; UiTEIdle
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_671:
        UNLK A6
        RTS
        ; func rtUiStdEditPaste  (JT slot 282)
        ;   param inst : 12(A6)  size 4
        ;   param te : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local teMp : -8(A6)  size 4
        ;   local newLen : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
LBL_66:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 746(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_676
        MOVE.L -12(A6),D1
        MOVE.L #32000,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_677
LBL_676:
        MOVEQ #0,D0
LBL_677:
        TST.L D0
        BEQ.W LBL_678
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        BRA.W LBL_679
LBL_678:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DB  ; UiTEPaste
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_59
        ADDA.W #10,A7
LBL_679:
LBL_675:
        UNLK A6
        RTS
        ; func UiLNew  (JT slot 283)
        ;   param rView : 32(A6)  size 4
        ;   param dataBounds : 28(A6)  size 4
        ;   param cSize : 24(A6)  size 4
        ;   param theProc : 20(A6)  size 4
        ;   param theWindow : 16(A6)  size 4
        ;   param drawIt : 14(A6)  size 2
        ;   param hasGrow : 12(A6)  size 2
        ;   param scrollHoriz : 10(A6)  size 2
        ;   param scrollVert : 8(A6)  size 2
LBL_67:
        LINK A6,#-2100
        BSR.W LBL_85
        CLR.L -(A7)
        MOVE.L 32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 14(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        CLR.L D0
        MOVE.B 12(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        CLR.L D0
        MOVE.B 10(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.W #68,-(A7)
        DC.W $A9E7  ; UiLNewRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_680
LBL_680:
        UNLK A6
        RTS
        ; func rtUiIntToPStr  (JT slot 284)
        ;   param n : 12(A6)  size 4
        ;   param out255 : 8(A6)  size 4
        ;   local u : -4(A6)  size 4
        ;   local neg : -6(A6)  size 2
        ;   local len : -10(A6)  size 4
        ;   local i : -14(A6)  size 4
        ;   local j : -18(A6)  size 4
        ;   local t : -22(A6)  size 4
LBL_68:
        LINK A6,#-2122
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-6(A6)
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_682
        MOVEQ #0,D1
        MOVE.L 12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_683
LBL_682:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
LBL_683:
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_684
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-10(A6)
LBL_684:
LBL_685:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_686
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_99
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-10(A6)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_98
        MOVE.L D0,-4(A6)
        BRA.W LBL_685
LBL_686:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_687
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-10(A6)
LBL_687:
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVE.L -10(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
LBL_688:
        MOVE.L -14(A6),D1
        MOVE.L -18(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_689
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -18(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -18(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-14(A6)
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_688
LBL_689:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_681:
        UNLK A6
        RTS
        ; func nat_UiCbAddr  (JT slot 285)
        ;   param cb : 8(A6)  size 4
LBL_69:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        BRA.W LBL_690
LBL_690:
        UNLK A6
        RTS
        ; func rtUiListAt  (JT slot 286)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_70:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 88(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_691
LBL_691:
        UNLK A6
        RTS
        ; func rtUiSetListAt  (JT slot 287)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_71:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 88(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_692:
        UNLK A6
        RTS
        ; func rtUiPopupAt  (JT slot 288)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_72:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_693
LBL_693:
        UNLK A6
        RTS
        ; func rtUiSetPopupAt  (JT slot 289)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_73:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_694:
        UNLK A6
        RTS
        ; func rtUiPopupSelAt  (JT slot 290)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_74:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 104(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_695
LBL_695:
        UNLK A6
        RTS
        ; func rtUiSetPopupSelAt  (JT slot 291)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_75:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 104(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_97
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_696:
        UNLK A6
        RTS
        ; func rtUiPopupBoxInto  (JT slot 292)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_76:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_698
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_699
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_699:
LBL_698:
LBL_697:
        UNLK A6
        RTS
        ; func rtUiTableFillWidth  (JT slot 293)
        ;   param colsOff : 16(A6)  size 4
        ;   param nCols : 12(A6)  size 4
        ;   param totalW : 8(A6)  size 4
        ;   local fixedSum : -4(A6)  size 4
        ;   local k : -8(A6)  size 4
        ;   local fillW : -12(A6)  size 4
LBL_77:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_701:
        MOVE.L -8(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_702
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1210(A5)
        ADDQ.L #8,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_703
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1202(A5)
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_703:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_701
LBL_702:
        MOVE.L 8(A6),D1
        MOVE.L -4(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_704
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_704:
        MOVE.L -12(A6),D0
        BRA.W LBL_700
LBL_700:
        UNLK A6
        RTS
        ; func rtUiFixedToStr  (JT slot 294)
        ;   param v : 12(A6)  size 4
        ;   param out255 : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local uv : -6(A6)  size 4
        ;   local ibuf : -10(A6)  size 4
        ;   local fbuf : -14(A6)  size 4
        ;   local frac : -18(A6)  size 4
        ;   local n : -22(A6)  size 4
        ;   local i : -26(A6)  size 4
        ;   local pad : -30(A6)  size 4
LBL_78:
        LINK A6,#-2130
        MOVEQ #0,D0
        MOVE.B D0,-2(A6)
        MOVEQ #0,D0
        MOVE.L D0,-6(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
        MOVEQ #0,D0
        MOVE.L D0,-30(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-2(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_706
        MOVEQ #0,D1
        MOVE.L 12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_707
LBL_706:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6(A6)
LBL_707:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-10(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-14(A6)
        MOVE.L -6(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        MOVE.L -6(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #10000,D0
        BSR.W LBL_97
        MOVE.L D0,D1
        MOVE.L #65536,D0
        BSR.W LBL_98
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_708
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D1
        MOVE.L -22(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_708:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_709:
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_710
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D1
        MOVE.L -22(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -26(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -26(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-26(A6)
        BRA.W LBL_709
LBL_710:
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D1
        MOVE.L -22(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #46,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_711:
        MOVE.L -26(A6),D1
        MOVE.L -30(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_712
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D1
        MOVE.L -22(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -26(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-26(A6)
        BRA.W LBL_711
LBL_712:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_713:
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_714
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D1
        MOVE.L -22(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -26(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -26(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-26(A6)
        BRA.W LBL_713
LBL_714:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_705:
        UNLK A6
        RTS
        ; func rtUiTableDrawField  (JT slot 295)
        ;   param rec : 20(A6)  size 4
        ;   param layoutOff : 16(A6)  size 4
        ;   param fieldIdx : 12(A6)  size 4
        ;   param colRect : 8(A6)  size 4
        ;   local base : -4(A6)  size 4
        ;   local ftype : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local numbuf : -16(A6)  size 4
        ;   local chBuf : -20(A6)  size 4
        ;   local enumCount : -24(A6)  size 4
        ;   local enumLabelsOff : -28(A6)  size 4
        ;   local enumValuesOff : -32(A6)  size 4
        ;   local k : -36(A6)  size 4
        ;   local lbl : -40(A6)  size 4
        ;   local found : -42(A6)  size 2
LBL_79:
        LINK A6,#-2142
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
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.B D0,-42(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1250(A5)
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_716
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        BRA.W LBL_717
LBL_716:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_718
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_719
LBL_718:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_720
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_721
LBL_720:
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_722
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_724
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #195,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_724:
        BRA.W LBL_723
LBL_722:
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_725
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_726
LBL_725:
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_727
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1266(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1282(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.B D0,-42(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
LBL_728:
        MOVE.L -36(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_729
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_730
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1298(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVEQ #1,D0
        MOVE.B D0,-42(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_731
LBL_730:
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_731:
        BRA.W LBL_728
LBL_729:
        CLR.L D0
        MOVE.B -42(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_732
        LEA LBL_94(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
LBL_732:
LBL_727:
LBL_726:
LBL_723:
LBL_721:
LBL_719:
LBL_717:
LBL_715:
        UNLK A6
        RTS
        ; func rtUiTableRowH  (JT slot 296)
        ;   local fi : -4(A6)  size 4
        ;   local h : -8(A6)  size 4
LBL_80:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A88B  ; UiGetFontInfo
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_734
        MOVE.L -8(A6),D0
        BRA.W LBL_733
LBL_734:
        MOVEQ #1,D0
        BRA.W LBL_733
LBL_733:
        UNLK A6
        RTS
        ; func rtUiTableHeaderH  (JT slot 297)
LBL_81:
        LINK A6,#-2100
        BSR.W LBL_80
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        BRA.W LBL_735
LBL_735:
        UNLK A6
        RTS
        ; func rtUiMakeLdefStub  (JT slot 298)
        ;   local h : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local addr : -12(A6)  size 4
LBL_82:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #6,D0
        MOVE.L D0,-(A7)
        JSR 1338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_737
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_737:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #20217,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA 3570(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_736
LBL_736:
        UNLK A6
        RTS
        ; func rtUiTableGetSelected  (JT slot 299)
        ;   param lh : 8(A6)  size 4
        ;   local lhMp : -4(A6)  size 4
        ;   local count : -8(A6)  size 4
        ;   local row : -12(A6)  size 4
        ;   local cell : -16(A6)  size 4
        ;   local found : -20(A6)  size 4
LBL_83:
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
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #76,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_739:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_740
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -16(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        CLR.W -(A7)
        MOVEQ #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #60,-(A7)
        DC.W $A9E7  ; UiLGetSelect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        TST.L D0
        BEQ.W LBL_741
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_742
LBL_741:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
LBL_742:
        BRA.W LBL_739
LBL_740:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        BRA.W LBL_738
LBL_738:
        UNLK A6
        RTS
        ; func rtUiTableSelectExclusive  (JT slot 300)
        ;   param lh : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local cur : -4(A6)  size 4
LBL_84:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_744
        MOVEQ #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #92,-(A7)
        DC.W $A9E7  ; UiLSetSelect
LBL_744:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_745
        MOVEQ #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #92,-(A7)
        DC.W $A9E7  ; UiLSetSelect
LBL_745:
LBL_743:
        UNLK A6
        RTS
        ; func rtUiJiggleTick  (JT slot 301)
LBL_85:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -52(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_747
        CLR.L D0
        MOVE.B -54(A5),D0
        BRA.W LBL_748
LBL_747:
        MOVEQ #1,D0
LBL_748:
        TST.L D0
        BEQ.W LBL_749
        BRA.W LBL_746
LBL_749:
        MOVEQ #1,D0
        MOVE.B D0,-54(A5)
        MOVE.L #2147483632,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A04C  ; UiCompactMem
        MOVEQ #0,D0
        MOVE.B D0,-54(A5)
LBL_746:
        UNLK A6
        RTS
        ; func rtUiTextAppendStrSafe  (JT slot 302)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_86:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_751
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #8,A7
LBL_751:
LBL_750:
        UNLK A6
        RTS
LBL_97:
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
LBL_98:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_752
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_752:
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
        BPL.W LBL_753
        NEG.L D2
        MOVE.L #1,D4
LBL_753:
        CLR.L D5
        TST.L D3
        BPL.W LBL_754
        NEG.L D3
        MOVE.L #1,D5
LBL_754:
        CLR.L D6
        MOVE.W #31,D7
LBL_755:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_756
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_756:
        DBRA D7,LBL_755
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_757
        NEG.L D2
LBL_757:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_99:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_758
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_758:
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
        BPL.W LBL_759
        NEG.L D2
        MOVE.L #1,D4
LBL_759:
        CLR.L D5
        TST.L D3
        BPL.W LBL_760
        NEG.L D3
        MOVE.L #1,D5
LBL_760:
        CLR.L D6
        MOVE.W #31,D7
LBL_761:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_762
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_762:
        DBRA D7,LBL_761
        TST.L D4
        BEQ.W LBL_763
        NEG.L D6
LBL_763:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_100:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -1304(A5),D0
        MOVE.L D0,-4(A6)
LBL_764:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_95:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_90:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_91:
        DC.B $03
        DC.B $6B,$65,$79
LBL_93:
        DC.B $01
        DC.B $78
LBL_88:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_92:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_87:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_89:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_94:
        DC.B $01
        DC.B $3F
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_96:
        DC.B $00
        DC.B $00
