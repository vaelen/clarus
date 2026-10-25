        ; func rtUiApplyZoom  (JT slot 225)
        ;   param wp : 16(A6)  size 4
        ;   param inst : 12(A6)  size 4
        ;   param part : 8(A6)  size 4
        ;   local screenBoundsSlot : -4(A6)  size 4
        ;   local screenW : -8(A6)  size 4
        ;   local screenH : -12(A6)  size 4
        ;   local stdRect : -16(A6)  size 4
        ;   local dataH : -20(A6)  size 4
        ;   local dataMp : -24(A6)  size 4
        ;   local savedPort : -28(A6)  size 4
        ;   local isFront : -30(A6)  size 2
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
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_97
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4786(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
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
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.W D0,-(A7)
        MOVEQ #20,D1
        MOVEQ #19,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L 16(A6),D1
        MOVE.L #130,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_98:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_97:
        BSR.W LBL_28
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 16(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-30(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.W D0,-(A7)
        CLR.L D0
        MOVE.B -30(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        DC.W $A83A  ; UiZoomWindow
        MOVE.L 16(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1818(A5)
        ADDA.W #16,A7
LBL_96:
        UNLK A6
        RTS
        ; func rtUiHandleZoom  (JT slot 226)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param wherePt : 12(A6)  size 4
        ;   param part : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_1:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 762(A5)
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_100
        BRA.W LBL_99
LBL_100:
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A83B  ; UiTrackBox
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_101
        BRA.W LBL_99
LBL_101:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDA.W #12,A7
LBL_99:
        UNLK A6
        RTS
        ; func rtUiFireWidget  (JT slot 227)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local ctrl : -12(A6)  size 4
        ;   local newVal : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
        ;   local wasModalInst : -22(A6)  size 2
        ;   local flags : -26(A6)  size 4
        ;   local front : -30(A6)  size 4
LBL_2:
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
        MOVE.L D0,-4(A6)
        BSR.W LBL_28
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B -124(A5),D0
        TST.L D0
        BEQ.W LBL_103
        MOVE.L -128(A5),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_104
LBL_103:
        MOVEQ #0,D0
LBL_104:
        MOVE.B D0,-22(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_105
        CLR.W -(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_108
LBL_107:
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
LBL_108:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_83(PC),A0
        MOVE.L A0,-(A7)
        JSR 2906(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 4986(A5)
        ADDA.W #24,A7
        BRA.W LBL_106
LBL_105:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_109
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_110
        MOVE.L -26(A6),D1
        MOVEQ #1,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_111
LBL_110:
        MOVEQ #0,D0
LBL_111:
        TST.L D0
        BEQ.W LBL_112
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3314(A5)
        ADDQ.L #4,A7
        BRA.W LBL_113
LBL_112:
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_114
        MOVE.L -26(A6),D1
        MOVEQ #2,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_115
LBL_114:
        MOVEQ #0,D0
LBL_115:
        TST.L D0
        BEQ.W LBL_116
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3330(A5)
        ADDQ.L #4,A7
        BRA.W LBL_117
LBL_116:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_84(PC),A0
        MOVE.L A0,-(A7)
        JSR 2906(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 4986(A5)
        ADDA.W #24,A7
LBL_117:
LBL_113:
LBL_109:
LBL_106:
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_118
        CLR.L D0
        MOVE.B -124(A5),D0
        EORI.L #1,D0
        BRA.W LBL_119
LBL_118:
        MOVEQ #0,D0
LBL_119:
        TST.L D0
        BEQ.W LBL_120
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-30(A6)
        MOVE.L -30(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_122
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_122:
        BRA.W LBL_121
LBL_120:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_121:
LBL_102:
        UNLK A6
        RTS
        ; func rtUiFindFlagged  (JT slot 228)
        ;   param inst : 16(A6)  size 4
        ;   param flag : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_3:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_124:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_125
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_126
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_127
LBL_126:
        MOVEQ #0,D0
LBL_127:
        TST.L D0
        BEQ.W LBL_128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_123
LBL_128:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_124
LBL_125:
        MOVEQ #0,D0
        BRA.W LBL_123
LBL_123:
        UNLK A6
        RTS
        ; func rtUiCanvasHit  (JT slot 229)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_4:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_130:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_132
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_133
LBL_132:
        MOVEQ #0,D0
LBL_133:
        TST.L D0
        BEQ.W LBL_134
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_129
LBL_134:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_130
LBL_131:
        MOVEQ #0,D0
        BRA.W LBL_129
LBL_129:
        UNLK A6
        RTS
        ; func rtUiFireCanvasXY  (JT slot 230)
        ;   param inst : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param event : 12(A6)  size 4
        ;   param localPt : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local r : -8(A6)  size 4
        ;   local localH : -12(A6)  size 4
        ;   local localV : -16(A6)  size 4
        ;   local rLeft : -20(A6)  size 4
        ;   local rTop : -24(A6)  size 4
LBL_5:
        LINK A6,#-76
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
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1610(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1618(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_136
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_84(PC),A0
        MOVE.L A0,-(A7)
        JSR 2906(A5)
        ADDA.W #12,A7
        BRA.W LBL_137
LBL_136:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        MOVE.L A0,-(A7)
        JSR 2906(A5)
        ADDA.W #12,A7
LBL_137:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVE.L -24(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 4986(A5)
        ADDA.W #24,A7
LBL_135:
        UNLK A6
        RTS
        ; func rtUiHandleCanvasClick  (JT slot 231)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param wherePt : 8(A6)  size 4
        ;   local last : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
LBL_6:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #16,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
LBL_139:
        CLR.W -(A7)
        DC.W $A973  ; UiStillDown
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        TST.L D0
        BEQ.W LBL_140
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        JSR 1602(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_141
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #16,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
LBL_141:
        BRA.W LBL_139
LBL_140:
LBL_138:
        UNLK A6
        RTS
        ; func rtUiHandleContentClick  (JT slot 232)
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
LBL_7:
        LINK A6,#-134
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
        JSR 1594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BEQ.W LBL_143
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_144
LBL_143:
        MOVEQ #0,D0
LBL_144:
        TST.L D0
        BEQ.W LBL_145
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-54(A6)
        MOVEQ #0,D0
        MOVE.L D0,-58(A6)
LBL_146:
        MOVE.L -58(A6),D1
        MOVE.L -54(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_147
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 2514(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-62(A6)
        MOVE.L -62(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_149
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
        BRA.W LBL_150
LBL_149:
        MOVEQ #0,D0
LBL_150:
        TST.L D0
        BEQ.W LBL_151
        CLR.L D0
        MOVE.B -48(A5),D0
        TST.L D0
        BEQ.W LBL_152
        BRA.W LBL_142
LBL_152:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_153
        MOVE.L #512,D0
        MOVE.L D0,-66(A6)
        BRA.W LBL_154
LBL_153:
        MOVEQ #0,D0
        MOVE.L D0,-66(A6)
LBL_154:
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
        BRA.W LBL_142
LBL_151:
LBL_148:
        MOVE.L -58(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-58(A6)
        BRA.W LBL_146
LBL_147:
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
        BEQ.W LBL_155
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
        BSR.W LBL_78
        ADDA.W #20,A7
        BRA.W LBL_142
LBL_155:
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        CLR.L D0
        MOVE.B -48(A5),D0
        TST.L D0
        BEQ.W LBL_156
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        BRA.W LBL_142
LBL_156:
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
        BEQ.W LBL_157
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
LBL_157:
        BRA.W LBL_142
LBL_145:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_158
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
        BSR.W LBL_6
        ADDA.W #16,A7
        BRA.W LBL_142
LBL_158:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_159
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
        BEQ.W LBL_160
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
        BRA.W LBL_161
LBL_160:
        MOVEQ #0,D0
LBL_161:
        MOVE.B D0,-50(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
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
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D4  ; UiTEClick
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        BRA.W LBL_142
LBL_159:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-70(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        JSR 2706(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_162
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
        JSR 2730(A5)
        ADDQ.L #8,A7
        BRA.W LBL_142
LBL_162:
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-78(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 2658(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_163
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
        BEQ.W LBL_164
        MOVE.L #512,D0
        MOVE.L D0,-66(A6)
        BRA.W LBL_165
LBL_164:
        MOVEQ #0,D0
        MOVE.L D0,-66(A6)
LBL_165:
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -82(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVE.L D0,-(A7)
        JSR 2682(A5)
        ADDA.W #16,A7
        BRA.W LBL_142
LBL_163:
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-54(A6)
        MOVEQ #0,D0
        MOVE.L D0,-58(A6)
LBL_166:
        MOVE.L -58(A6),D1
        MOVE.L -54(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_167
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_168
        CLR.W -(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_169
LBL_168:
        MOVEQ #0,D0
LBL_169:
        TST.L D0
        BEQ.W LBL_170
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_171
        MOVE.L #512,D0
        MOVE.L D0,-66(A6)
        BRA.W LBL_172
LBL_171:
        MOVEQ #0,D0
        MOVE.L D0,-66(A6)
LBL_172:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVE.L D0,-(A7)
        JSR 5042(A5)
        ADDA.W #20,A7
        BRA.W LBL_142
LBL_170:
        MOVE.L -58(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-58(A6)
        BRA.W LBL_166
LBL_167:
LBL_142:
        UNLK A6
        RTS
        ; func rtUiHandleMouseDown  (JT slot 233)
        ;   param ev : 8(A6)  size 4
        ;   local wherePt : -4(A6)  size 4
        ;   local wpSlot : -8(A6)  size 4
        ;   local part : -12(A6)  size 4
        ;   local wp : -16(A6)  size 4
        ;   local inst : -20(A6)  size 4
        ;   local dragBounds : -24(A6)  size 4
        ;   local modifiers : -28(A6)  size 4
        ;   local shiftDown : -30(A6)  size 2
LBL_8:
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
        JSR 1426(A5)
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
        BEQ.W LBL_174
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_175
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_173
LBL_175:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_178
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1498(A5)
        ADDQ.L #4,A7
        BRA.W LBL_179
LBL_178:
        MOVEQ #0,D0
LBL_179:
        TST.L D0
        BEQ.W LBL_176
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
        BRA.W LBL_177
LBL_176:
        MOVEQ #0,D0
LBL_177:
        TST.L D0
        BEQ.W LBL_180
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_173
LBL_180:
LBL_174:
        MOVE.L -12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
        CLR.W -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91E  ; UiTrackGoAway
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_184
LBL_183:
        MOVEQ #0,D0
LBL_184:
        TST.L D0
        BEQ.W LBL_185
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_186
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 1578(A5)
        ADDQ.L #4,A7
LBL_186:
LBL_185:
        BRA.W LBL_182
LBL_181:
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_187
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 4786(A5)
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
        JSR 1730(A5)
        BRA.W LBL_188
LBL_187:
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_191
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1826(A5)
        ADDA.W #12,A7
LBL_191:
        BRA.W LBL_190
LBL_189:
        MOVE.L -12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_192
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_193
LBL_192:
        MOVEQ #1,D0
LBL_193:
        TST.L D0
        BEQ.W LBL_194
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_196
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDA.W #16,A7
LBL_196:
        BRA.W LBL_195
LBL_194:
        MOVE.L -12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_197
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
        BEQ.W LBL_199
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91F  ; UiSelectWindow
        JSR 1730(A5)
        BRA.W LBL_200
LBL_199:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_201
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
        BSR.W LBL_7
        ADDA.W #14,A7
LBL_201:
LBL_200:
        BRA.W LBL_198
LBL_197:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_202
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A93D  ; UiMenuSelect
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1746(A5)
        ADDQ.L #4,A7
LBL_202:
LBL_198:
LBL_195:
LBL_190:
LBL_188:
LBL_182:
LBL_173:
        UNLK A6
        RTS
        ; func rtUiHandleKey  (JT slot 234)
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
LBL_9:
        LINK A6,#-96
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
        BEQ.W LBL_204
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A93E  ; UiMenuKey
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1746(A5)
        ADDQ.L #4,A7
        BRA.W LBL_203
LBL_204:
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_205
        BRA.W LBL_203
LBL_205:
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
        BEQ.W LBL_206
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_207
        MOVE.L -4(A6),D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_209
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_210
LBL_209:
        MOVEQ #1,D0
LBL_210:
        BRA.W LBL_208
LBL_207:
        MOVEQ #0,D0
LBL_208:
        TST.L D0
        BEQ.W LBL_211
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_86(PC),A0
        MOVE.L A0,-(A7)
        JSR 2906(A5)
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
        JSR 4986(A5)
        ADDA.W #24,A7
        BRA.W LBL_203
LBL_211:
        MOVE.L -4(A6),D1
        MOVEQ #27,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_212
        CLR.L D0
        MOVE.B -124(A5),D0
        TST.L D0
        BEQ.W LBL_217
        MOVE.L -128(A5),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_218
LBL_217:
        MOVEQ #0,D0
LBL_218:
        TST.L D0
        BEQ.W LBL_215
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_216
LBL_215:
        MOVEQ #0,D0
LBL_216:
        TST.L D0
        BEQ.W LBL_213
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_219
        MOVE.L -4(A6),D1
        MOVEQ #31,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_220
LBL_219:
        MOVEQ #0,D0
LBL_220:
        EORI.L #1,D0
        BRA.W LBL_214
LBL_213:
        MOVEQ #0,D0
LBL_214:
        TST.L D0
        BEQ.W LBL_221
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 810(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
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
        BEQ.W LBL_222
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 810(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1346(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_227
        MOVE.L -44(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_228
LBL_227:
        MOVEQ #1,D0
LBL_228:
        TST.L D0
        BNE.W LBL_225
        MOVE.L -44(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_226
LBL_225:
        MOVEQ #1,D0
LBL_226:
        TST.L D0
        BEQ.W LBL_223
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 3298(A5)
        ADDA.W #12,A7
        EORI.L #1,D0
        BRA.W LBL_224
LBL_223:
        MOVEQ #0,D0
LBL_224:
        TST.L D0
        BEQ.W LBL_229
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_203
LBL_229:
LBL_222:
LBL_221:
        BSR.W LBL_28
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
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9DC  ; UiTEKey
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_230
        MOVE.L -4(A6),D1
        MOVEQ #31,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_231
LBL_230:
        MOVEQ #0,D0
LBL_231:
        TST.L D0
        BEQ.W LBL_232
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        BRA.W LBL_233
LBL_232:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_73
        ADDA.W #10,A7
LBL_233:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        BRA.W LBL_203
LBL_212:
LBL_206:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -4(A6),D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_236
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_237
LBL_236:
        MOVEQ #1,D0
LBL_237:
        TST.L D0
        BEQ.W LBL_234
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        BRA.W LBL_235
LBL_234:
        MOVEQ #0,D0
LBL_235:
        TST.L D0
        BEQ.W LBL_238
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
        BSR.W LBL_2
        ADDQ.L #8,A7
        BRA.W LBL_203
LBL_238:
        MOVE.L -4(A6),D1
        MOVEQ #27,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_239
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        BRA.W LBL_240
LBL_239:
        MOVEQ #0,D0
LBL_240:
        TST.L D0
        BEQ.W LBL_241
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
        BSR.W LBL_2
        ADDQ.L #8,A7
        BRA.W LBL_203
LBL_241:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 2898(A5)
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
        JSR 4978(A5)
        ADDA.W #20,A7
LBL_203:
        UNLK A6
        RTS
        ; func rtUiRun  (JT slot 235)
        ;   local evBuf : -4(A6)  size 4
        ;   local frontInst : -8(A6)  size 4
        ;   local sleepTicks : -12(A6)  size 4
        ;   local what : -16(A6)  size 4
        ;   local gotEvent : -18(A6)  size 2
LBL_10:
        LINK A6,#-70
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
        LEA LBL_91(PC),A0
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
        BEQ.W LBL_243
        JSR 3234(A5)
        BRA.W LBL_242
LBL_243:
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
LBL_244:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_245
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -34(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_246
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_248
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_249
LBL_248:
        MOVEQ #0,D0
LBL_249:
        BRA.W LBL_247
LBL_246:
        MOVEQ #1,D0
LBL_247:
        TST.L D0
        BEQ.W LBL_250
        MOVEQ #1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_251
LBL_250:
        MOVEQ #30,D0
        MOVE.L D0,-12(A6)
LBL_251:
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
        BEQ.W LBL_252
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        BRA.W LBL_253
LBL_252:
        MOVE.L -16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_254
        MOVE.L -16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_255
LBL_254:
        MOVEQ #1,D0
LBL_255:
        TST.L D0
        BEQ.W LBL_256
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        BRA.W LBL_257
LBL_256:
        MOVE.L -16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_258
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1802(A5)
        ADDQ.L #4,A7
        BRA.W LBL_259
LBL_258:
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_260
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
        JSR 1810(A5)
        ADDQ.L #6,A7
        BRA.W LBL_261
LBL_260:
        MOVE.L -16(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_262
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
LBL_262:
LBL_261:
LBL_259:
LBL_257:
LBL_253:
        JSR 1762(A5)
        JSR 4802(A5)
        BSR.W LBL_79
        JSR 1786(A5)
        JSR 2698(A5)
        BRA.W LBL_244
LBL_245:
LBL_242:
        UNLK A6
        RTS
        ; func rtUiLaunch  (JT slot 236)
        ;   local script : -4(A6)  size 4
        ;   local cursor : -8(A6)  size 4
        ;   local lineStart : -12(A6)  size 4
        ;   local lineLen : -16(A6)  size 4
        ;   local isLaunchDoc : -18(A6)  size 2
        ;   local found : -20(A6)  size 2
        ;   local pathBuf : -24(A6)  size 4
        ;   local pathLen : -28(A6)  size 4
LBL_11:
        LINK A6,#-80
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
        LEA LBL_91(PC),A0
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
        BEQ.W LBL_264
        JSR 1482(A5)
        BRA.W LBL_263
LBL_264:
        MOVEQ #0,D0
        MOVE.B D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
LBL_265:
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
        BEQ.W LBL_266
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_267:
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
        BEQ.W LBL_269
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_270
LBL_269:
        MOVEQ #0,D0
LBL_270:
        TST.L D0
        BEQ.W LBL_268
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_267
LBL_268:
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
        BEQ.W LBL_271
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
        BEQ.W LBL_288
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
        BRA.W LBL_289
LBL_288:
        MOVEQ #0,D0
LBL_289:
        TST.L D0
        BEQ.W LBL_286
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
        BRA.W LBL_287
LBL_286:
        MOVEQ #0,D0
LBL_287:
        TST.L D0
        BEQ.W LBL_284
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
        BRA.W LBL_285
LBL_284:
        MOVEQ #0,D0
LBL_285:
        TST.L D0
        BEQ.W LBL_282
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
        BRA.W LBL_283
LBL_282:
        MOVEQ #0,D0
LBL_283:
        TST.L D0
        BEQ.W LBL_280
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
        BRA.W LBL_281
LBL_280:
        MOVEQ #0,D0
LBL_281:
        TST.L D0
        BEQ.W LBL_278
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
        BRA.W LBL_279
LBL_278:
        MOVEQ #0,D0
LBL_279:
        TST.L D0
        BEQ.W LBL_276
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
        BRA.W LBL_277
LBL_276:
        MOVEQ #0,D0
LBL_277:
        TST.L D0
        BEQ.W LBL_274
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
        BRA.W LBL_275
LBL_274:
        MOVEQ #0,D0
LBL_275:
        TST.L D0
        BEQ.W LBL_272
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
        BRA.W LBL_273
LBL_272:
        MOVEQ #0,D0
LBL_273:
        TST.L D0
        BEQ.W LBL_290
        MOVEQ #1,D0
        MOVE.B D0,-18(A6)
LBL_290:
LBL_271:
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_291
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
        BEQ.W LBL_292
        MOVE.L #255,D0
        MOVE.L D0,-28(A6)
LBL_292:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        JSR 3018(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 5026(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_291:
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
        BEQ.W LBL_293
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_293:
        BRA.W LBL_265
LBL_266:
        CLR.L D0
        MOVE.B -20(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_294
        JSR 5034(A5)
LBL_294:
LBL_263:
        UNLK A6
        RTS
        ; func UiNewControl  (JT slot 237)
        ;   param owningWindow : 38(A6)  size 4
        ;   param boundsRect : 34(A6)  size 4
        ;   param controlTitle : 30(A6)  size 4
        ;   param initiallyVisible : 28(A6)  size 2
        ;   param initialValue : 24(A6)  size 4
        ;   param minimumValue : 20(A6)  size 4
        ;   param maximumValue : 16(A6)  size 4
        ;   param procId : 12(A6)  size 4
        ;   param controlReference : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        JSR 2770(A5)
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
        BRA.W LBL_295
LBL_295:
        UNLK A6
        RTS
        ; func UiNewRgn  (JT slot 238)
LBL_13:
        LINK A6,#-52
        JSR 2770(A5)
        CLR.L -(A7)
        DC.W $A8D8  ; UiNewRgnRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_296
LBL_296:
        UNLK A6
        RTS
        ; func rtUiCtrlAt  (JT slot 239)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_14:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_297
LBL_297:
        UNLK A6
        RTS
        ; func rtUiSetCtrlAt  (JT slot 240)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_15:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_298:
        UNLK A6
        RTS
        ; func rtUiRectAt  (JT slot 241)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_16:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_299
LBL_299:
        UNLK A6
        RTS
        ; func rtUiLabelAt  (JT slot 242)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_17:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_300
LBL_300:
        UNLK A6
        RTS
        ; func rtUiCanvasBufAt  (JT slot 243)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_18:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #44,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_301
LBL_301:
        UNLK A6
        RTS
        ; func rtUiCanvasMarkDirty  (JT slot 244)
        ;   param instV : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_19:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
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
        BEQ.W LBL_303
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_303:
LBL_302:
        UNLK A6
        RTS
        ; func rtUiTeAt  (JT slot 245)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_304
LBL_304:
        UNLK A6
        RTS
        ; func rtUiSetTeAt  (JT slot 246)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_21:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_305:
        UNLK A6
        RTS
        ; func rtUiHbarAt  (JT slot 247)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_22:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 64(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_306
LBL_306:
        UNLK A6
        RTS
        ; func rtUiSetHbarAt  (JT slot 248)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_23:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 64(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_307:
        UNLK A6
        RTS
        ; func rtUiPlacedAt  (JT slot 249)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_24:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 112(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_308
LBL_308:
        UNLK A6
        RTS
        ; func rtUiRectIsEmpty  (JT slot 250)
        ;   param r : 8(A6)  size 4
LBL_25:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_310
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_311
LBL_310:
        MOVEQ #1,D0
LBL_311:
        BRA.W LBL_309
LBL_309:
        UNLK A6
        RTS
        ; func rtUiEnabledAt  (JT slot 251)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_26:
        LINK A6,#-52
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
        BRA.W LBL_312
LBL_312:
        UNLK A6
        RTS
        ; func rtUiSetEnabledAt  (JT slot 252)
        ;   param w : 14(A6)  size 4
        ;   param i : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
LBL_27:
        LINK A6,#-52
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_314
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
        BRA.W LBL_315
LBL_314:
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
LBL_315:
LBL_313:
        UNLK A6
        RTS
        ; func rtUiGetPortSaved  (JT slot 253)
        ;   local slot : -4(A6)  size 4
        ;   local p : -8(A6)  size 4
LBL_28:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BRA.W LBL_316
LBL_316:
        UNLK A6
        RTS
        ; func rtUiKindHeight  (JT slot 254)
        ;   param kind : 8(A6)  size 4
        ;   local __switch2 : -4(A6)  size 4
LBL_29:
        LINK A6,#-56
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
        BEQ.W LBL_318
        MOVEQ #20,D0
        BRA.W LBL_317
        BRA.W LBL_319
LBL_318:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_320
        MOVEQ #16,D0
        BRA.W LBL_317
        BRA.W LBL_321
LBL_320:
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_322
        MOVEQ #16,D0
        BRA.W LBL_317
        BRA.W LBL_323
LBL_322:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_324
        MOVEQ #100,D0
        BRA.W LBL_317
        BRA.W LBL_325
LBL_324:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_326
        MOVEQ #20,D0
        BRA.W LBL_317
        BRA.W LBL_327
LBL_326:
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_328
        MOVEQ #100,D0
        BRA.W LBL_317
        BRA.W LBL_329
LBL_328:
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_330
        MOVEQ #20,D0
        BRA.W LBL_317
        BRA.W LBL_331
LBL_330:
        MOVE.L -4(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_332
        MOVEQ #120,D0
        BRA.W LBL_317
        BRA.W LBL_333
LBL_332:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_334
        MOVEQ #100,D0
        BRA.W LBL_317
        BRA.W LBL_335
LBL_334:
        MOVE.L -4(A6),D1
        MOVEQ #9,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_336
        MOVEQ #1,D0
        BRA.W LBL_317
        BRA.W LBL_337
LBL_336:
        MOVEQ #16,D0
        BRA.W LBL_317
LBL_337:
LBL_335:
LBL_333:
LBL_331:
LBL_329:
LBL_327:
LBL_325:
LBL_323:
LBL_321:
LBL_319:
        MOVEQ #16,D0
        BRA.W LBL_317
LBL_317:
        UNLK A6
        RTS
        ; func rtUiNaturalH  (JT slot 255)
        ;   param kind : 8(A6)  size 4
LBL_30:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_343
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_344
LBL_343:
        MOVEQ #1,D0
LBL_344:
        TST.L D0
        BNE.W LBL_341
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_342
LBL_341:
        MOVEQ #1,D0
LBL_342:
        TST.L D0
        BNE.W LBL_339
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_340
LBL_339:
        MOVEQ #1,D0
LBL_340:
        BRA.W LBL_338
LBL_338:
        UNLK A6
        RTS
        ; func rtUiDeclHeight  (JT slot 256)
        ;   param winIdx : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param kind : 8(A6)  size 4
        ;   local hh : -4(A6)  size 4
LBL_31:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 946(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_347
LBL_346:
        MOVEQ #0,D0
LBL_347:
        TST.L D0
        BEQ.W LBL_348
        MOVE.L -4(A6),D0
        BRA.W LBL_345
LBL_348:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        BRA.W LBL_345
LBL_345:
        UNLK A6
        RTS
        ; func rtUiKindWidth  (JT slot 257)
        ;   param kind : 8(A6)  size 4
        ;   local __switch3 : -4(A6)  size 4
LBL_32:
        LINK A6,#-56
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
        BEQ.W LBL_350
        MOVEQ #80,D0
        BRA.W LBL_349
        BRA.W LBL_351
LBL_350:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_352
        MOVEQ #90,D0
        BRA.W LBL_349
        BRA.W LBL_353
LBL_352:
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_354
        MOVE.L #150,D0
        BRA.W LBL_349
        BRA.W LBL_355
LBL_354:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_356
        MOVE.L #200,D0
        BRA.W LBL_349
        BRA.W LBL_357
LBL_356:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
        MOVE.L #200,D0
        BRA.W LBL_349
        BRA.W LBL_359
LBL_358:
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
        MOVE.L #200,D0
        BRA.W LBL_349
        BRA.W LBL_361
LBL_360:
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        MOVE.L #200,D0
        BRA.W LBL_349
        BRA.W LBL_363
LBL_362:
        MOVE.L -4(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_364
        MOVE.L #300,D0
        BRA.W LBL_349
        BRA.W LBL_365
LBL_364:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_366
        MOVE.L #200,D0
        BRA.W LBL_349
        BRA.W LBL_367
LBL_366:
        MOVE.L -4(A6),D1
        MOVEQ #9,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_368
        MOVEQ #1,D0
        BRA.W LBL_349
        BRA.W LBL_369
LBL_368:
        MOVEQ #90,D0
        BRA.W LBL_349
LBL_369:
LBL_367:
LBL_365:
LBL_363:
LBL_361:
LBL_359:
LBL_357:
LBL_355:
LBL_353:
LBL_351:
        MOVEQ #90,D0
        BRA.W LBL_349
LBL_349:
        UNLK A6
        RTS
        ; func rtUiPstrcpy  (JT slot 258)
        ;   param dst : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_33:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_371
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_370
LBL_371:
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
LBL_370:
        UNLK A6
        RTS
        ; func rtUiLayout  (JT slot 259)
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
        ;   local r : -84(A6)  size 4
        ;   local __switch4 : -88(A6)  size 4
LBL_34:
        LINK A6,#-140
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
        MOVEQ #0,D0
        MOVE.L D0,-88(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_28
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
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
LBL_373:
        MOVE.L -40(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_374
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_375
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -84(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -84(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -84(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_373
LBL_375:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 874(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDA.W #12,A7
        MOVE.L D0,-68(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-88(A6)
        MOVE.L -88(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVE.L -28(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_377
LBL_376:
        MOVE.L -88(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_378
        MOVE.L -24(A6),D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_379
LBL_378:
        MOVE.L -88(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        MOVEQ #12,D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_381
LBL_380:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 882(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
LBL_381:
LBL_379:
LBL_377:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 890(A5)
        ADDQ.L #8,A7
        TST.L D0
        BNE.W LBL_382
        MOVE.L -48(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_383
LBL_382:
        MOVEQ #1,D0
LBL_383:
        TST.L D0
        BEQ.W LBL_384
        MOVE.L -32(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_385
LBL_384:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
LBL_385:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-70(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 922(A5)
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
        BEQ.W LBL_388
        MOVE.L -52(A6),D1
        MOVEQ #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_389
LBL_388:
        MOVEQ #0,D0
LBL_389:
        TST.L D0
        BEQ.W LBL_386
        CLR.L D0
        MOVE.B -70(A6),D0
        TST.L D0
        BNE.W LBL_390
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_391
LBL_390:
        MOVEQ #1,D0
LBL_391:
        BRA.W LBL_387
LBL_386:
        MOVEQ #0,D0
LBL_387:
        TST.L D0
        BEQ.W LBL_392
        MOVEQ #1,D0
        MOVE.B D0,-74(A6)
LBL_392:
        MOVEQ #0,D0
        MOVE.B D0,-76(A6)
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_395
        MOVE.L -52(A6),D1
        MOVEQ #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_396
LBL_395:
        MOVEQ #0,D0
LBL_396:
        TST.L D0
        BEQ.W LBL_393
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_394
LBL_393:
        MOVEQ #0,D0
LBL_394:
        TST.L D0
        BEQ.W LBL_397
        MOVEQ #1,D0
        MOVE.B D0,-76(A6)
LBL_397:
        CLR.L D0
        MOVE.B -70(A6),D0
        TST.L D0
        BNE.W LBL_398
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_399
LBL_398:
        MOVEQ #1,D0
LBL_399:
        TST.L D0
        BEQ.W LBL_400
        CLR.L D0
        MOVE.B -74(A6),D0
        TST.L D0
        BEQ.W LBL_402
        MOVE.L -16(A6),D1
        MOVE.L -56(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_403
LBL_402:
        MOVE.L -16(A6),D1
        MOVE.L -56(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-64(A6)
LBL_403:
        BRA.W LBL_401
LBL_400:
        MOVE.L -44(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_404
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_405
LBL_404:
        MOVEQ #0,D0
LBL_405:
        TST.L D0
        BEQ.W LBL_406
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_408
        MOVE.L #130,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_409
LBL_408:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
LBL_409:
        BRA.W LBL_407
LBL_406:
        MOVE.L -44(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_410
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_411
LBL_410:
        MOVEQ #0,D0
LBL_411:
        TST.L D0
        BEQ.W LBL_412
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        BRA.W LBL_415
LBL_414:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
LBL_415:
        BRA.W LBL_413
LBL_412:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_416
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        BRA.W LBL_417
LBL_416:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-64(A6)
LBL_417:
LBL_413:
LBL_407:
LBL_401:
        MOVE.L -64(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_418
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
LBL_418:
        CLR.L D0
        MOVE.B -72(A6),D0
        TST.L D0
        BEQ.W LBL_419
        CLR.L D0
        MOVE.B -76(A6),D0
        TST.L D0
        BEQ.W LBL_420
        MOVE.L -20(A6),D1
        MOVE.L -60(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-68(A6)
        BRA.W LBL_421
LBL_420:
        MOVE.L -20(A6),D1
        MOVE.L -60(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-68(A6)
LBL_421:
        MOVE.L -68(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_422
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
LBL_422:
LBL_419:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
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
        BNE.W LBL_423
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_424
LBL_423:
        MOVEQ #1,D0
LBL_424:
        TST.L D0
        BEQ.W LBL_425
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        BRA.W LBL_426
LBL_425:
        MOVE.L -44(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_427
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 2634(A5)
        ADDQ.L #8,A7
        BRA.W LBL_428
LBL_427:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
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
LBL_429:
LBL_428:
LBL_426:
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
        BRA.W LBL_373
LBL_374:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_372:
        UNLK A6
        RTS
        ; func rtUiMakeWidgets  (JT slot 260)
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
LBL_35:
        LINK A6,#-172
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
        BSR.W LBL_28
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_431:
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 866(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        MOVE.L -20(A6),D0
        MOVE.L D0,-36(A6)
LBL_433:
        MOVE.L -32(A6),D0
        MOVE.L D0,-120(A6)
        MOVE.L -120(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
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
        BSR.W LBL_12
        ADDA.W #34,A7
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        BRA.W LBL_435
LBL_434:
        MOVE.L -120(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_436
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
        BSR.W LBL_12
        ADDA.W #34,A7
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        BRA.W LBL_437
LBL_436:
        MOVE.L -120(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_438
        MOVE.L -120(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_439
LBL_438:
        MOVEQ #1,D0
LBL_439:
        TST.L D0
        BEQ.W LBL_440
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 866(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        BRA.W LBL_441
LBL_440:
        MOVE.L -120(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_442
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 866(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDA.W #12,A7
        BRA.W LBL_443
LBL_442:
        MOVE.L -120(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_444
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
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
        JSR 930(A5)
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
        BEQ.W LBL_446
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
        BSR.W LBL_12
        ADDA.W #34,A7
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
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
        BRA.W LBL_447
LBL_446:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
LBL_447:
        MOVE.L -64(A6),D1
        MOVEQ #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_448
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
        BSR.W LBL_12
        ADDA.W #34,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
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
        BRA.W LBL_449
LBL_448:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDA.W #12,A7
LBL_449:
        BRA.W LBL_445
LBL_444:
        MOVE.L -120(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_450
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 866(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 2554(A5)
        ADDA.W #12,A7
        MOVE.L #1000,D1
        MOVE.L -28(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1634(A5)
        MOVE.L D0,-(A7)
        JSR 1458(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 810(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
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
        BEQ.W LBL_452
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        JSR 1370(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-92(A6)
LBL_453:
        MOVE.L -92(A6),D1
        MOVE.L -84(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_89(PC),A0
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
        JSR 1402(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A947  ; UiSetMenuItemText
        MOVE.L -92(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-92(A6)
        BRA.W LBL_453
LBL_454:
LBL_452:
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
        JSR 2538(A5)
        ADDA.W #12,A7
        BRA.W LBL_451
LBL_450:
        MOVE.L -120(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_455
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        JSR 2602(A5)
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
        JSR 1426(A5)
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
        JSR 2490(A5)
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
        BEQ.W LBL_457
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_457:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 2522(A5)
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
        JSR 938(A5)
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
        JSR 2618(A5)
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
        BRA.W LBL_456
LBL_455:
        MOVE.L -120(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_458
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 5042(A5)
        ADDA.W #20,A7
        BRA.W LBL_459
LBL_458:
        MOVE.L -120(A6),D1
        MOVEQ #9,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_460
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #12,A7
        BRA.W LBL_461
LBL_460:
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        JSR 4626(A5)
        ADDQ.L #4,A7
        BSR.W LBL_95
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4634(A5)
        ADDQ.L #4,A7
LBL_461:
LBL_459:
LBL_456:
LBL_451:
LBL_445:
LBL_443:
LBL_441:
LBL_437:
LBL_435:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_462
        MOVE.L -32(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_463
LBL_462:
        MOVEQ #0,D0
LBL_463:
        TST.L D0
        BEQ.W LBL_464
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
LBL_464:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_431
LBL_432:
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
LBL_430:
        UNLK A6
        RTS
        ; func rtUiWidgetSetStr  (JT slot 261)
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
LBL_36:
        LINK A6,#-84
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
        BSR.W LBL_28
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2978(A5)
        ADDA.W #16,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_466
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_467
LBL_466:
        MOVEQ #0,D0
LBL_467:
        TST.L D0
        BEQ.W LBL_468
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A9CE  ; UiTextBox
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A92A  ; UiValidRect
        BRA.W LBL_469
LBL_468:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_472
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_473
LBL_472:
        MOVEQ #0,D0
LBL_473:
        TST.L D0
        BEQ.W LBL_470
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_471
LBL_470:
        MOVEQ #0,D0
LBL_471:
        TST.L D0
        BEQ.W LBL_474
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A95F  ; UiSetControlTitle
        BRA.W LBL_475
LBL_474:
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_478
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_479
LBL_478:
        MOVEQ #0,D0
LBL_479:
        TST.L D0
        BEQ.W LBL_476
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_477
LBL_476:
        MOVEQ #0,D0
LBL_477:
        TST.L D0
        BEQ.W LBL_480
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_482
LBL_481:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_482:
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
        BSR.W LBL_73
        ADDA.W #10,A7
LBL_480:
LBL_475:
LBL_469:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_465:
        UNLK A6
        RTS
        ; func rtUiWidgetGetStr  (JT slot 262)
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
LBL_37:
        LINK A6,#-76
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
        JSR 834(A5)
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
        BEQ.W LBL_484
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_485
LBL_484:
        MOVEQ #0,D0
LBL_485:
        TST.L D0
        BEQ.W LBL_486
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        BRA.W LBL_487
LBL_486:
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_488
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_489
LBL_488:
        MOVEQ #0,D0
LBL_489:
        TST.L D0
        BEQ.W LBL_490
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_491
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
        BEQ.W LBL_492
        MOVE.L #255,D0
        MOVE.L D0,-20(A6)
LBL_492:
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
LBL_491:
LBL_490:
LBL_487:
LBL_483:
        UNLK A6
        RTS
        ; func rtUiWidgetGetText  (JT slot 263)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local teMp : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
        ;   local hText : -24(A6)  size 4
LBL_38:
        LINK A6,#-76
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_494
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_495
LBL_494:
        MOVEQ #1,D0
LBL_495:
        TST.L D0
        BEQ.W LBL_496
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDA.W #16,A7
        BRA.W LBL_493
LBL_496:
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
        JSR 226(A5)
        ADDA.W #16,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
LBL_493:
        UNLK A6
        RTS
        ; func rtUiWidgetSetText  (JT slot 264)
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
LBL_39:
        LINK A6,#-100
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_498
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_499
LBL_498:
        MOVEQ #1,D0
LBL_499:
        TST.L D0
        BEQ.W LBL_500
        BRA.W LBL_497
LBL_500:
        BSR.W LBL_28
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #32000,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_501
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_501:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32000,D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
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
        BSR.W LBL_73
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
        BSR.W LBL_40
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
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_502
        MOVE.L -36(A6),D0
        MOVE.L D0,-32(A6)
LBL_502:
        MOVE.L -32(A6),D1
        MOVE.L -40(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_503
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
LBL_503:
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
LBL_497:
        UNLK A6
        RTS
        ; func rtUiPeekSw  (JT slot 265)
        ;   param p : 8(A6)  size 4
        ;   local v : -4(A6)  size 4
LBL_40:
        LINK A6,#-56
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
        BEQ.W LBL_505
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_505:
        MOVE.L -4(A6),D0
        BRA.W LBL_504
LBL_504:
        UNLK A6
        RTS
        ; func rtUiWidgetScrollToEnd  (JT slot 266)
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
LBL_41:
        LINK A6,#-88
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
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_507
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_508
LBL_507:
        MOVEQ #1,D0
LBL_508:
        TST.L D0
        BEQ.W LBL_509
        BRA.W LBL_506
LBL_509:
        BSR.W LBL_28
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
        BSR.W LBL_70
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
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        BSR.W LBL_92
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
        BEQ.W LBL_510
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_510:
        MOVE.L -32(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
        MOVE.L #32767,D0
        MOVE.L D0,-32(A6)
LBL_511:
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        BEQ.W LBL_512
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
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_513
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_513:
LBL_512:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_506:
        UNLK A6
        RTS
        ; func rtUiWidgetSetBool  (JT slot 267)
        ;   param instV : 18(A6)  size 4
        ;   param wIdx : 14(A6)  size 4
        ;   param prop : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local savedPort : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local ctrl : -20(A6)  size 4
LBL_42:
        LINK A6,#-72
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
        BSR.W LBL_28
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-(A7)
        JSR 2986(A5)
        ADDA.W #14,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        MOVE.L 10(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_518
LBL_517:
        MOVEQ #0,D0
LBL_518:
        TST.L D0
        BEQ.W LBL_515
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_516
LBL_515:
        MOVEQ #0,D0
LBL_516:
        TST.L D0
        BEQ.W LBL_519
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_521
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_522
LBL_521:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_522:
        BRA.W LBL_520
LBL_519:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_525
        MOVE.L 10(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_526
LBL_525:
        MOVEQ #0,D0
LBL_526:
        TST.L D0
        BEQ.W LBL_523
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_524
LBL_523:
        MOVEQ #0,D0
LBL_524:
        TST.L D0
        BEQ.W LBL_527
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_27
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
        BEQ.W LBL_528
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_529
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
        BRA.W LBL_530
LBL_529:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
LBL_530:
LBL_528:
LBL_527:
LBL_520:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_514:
        UNLK A6
        RTS
        ; func rtUiWidgetSetInt  (JT slot 268)
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
LBL_43:
        LINK A6,#-76
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
        MOVE.L D0,-8(A6)
        BSR.W LBL_28
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_532
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_533
LBL_532:
        MOVEQ #0,D0
LBL_533:
        TST.L D0
        BEQ.W LBL_534
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_535
        CLR.W -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A950  ; UiCountMItems
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_536
LBL_535:
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_536:
        MOVE.L 8(A6),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_537
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
LBL_537:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_538
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
        BRA.W LBL_539
LBL_538:
        MOVEQ #0,D0
LBL_539:
        TST.L D0
        BEQ.W LBL_540
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
LBL_540:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
LBL_541:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2994(A5)
        ADDA.W #16,A7
LBL_534:
        MOVE.L -16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_542
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_543
LBL_542:
        MOVEQ #0,D0
LBL_543:
        TST.L D0
        BEQ.W LBL_544
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2738(A5)
        ADDA.W #12,A7
LBL_544:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_531:
        UNLK A6
        RTS
        ; func rtUiWidgetGetBool  (JT slot 269)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local kind : -12(A6)  size 4
        ;   local ctrl : -16(A6)  size 4
LBL_44:
        LINK A6,#-68
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_548
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_549
LBL_548:
        MOVEQ #0,D0
LBL_549:
        TST.L D0
        BEQ.W LBL_546
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_547
LBL_546:
        MOVEQ #0,D0
LBL_547:
        TST.L D0
        BEQ.W LBL_550
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
        BRA.W LBL_545
LBL_550:
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_553
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_554
LBL_553:
        MOVEQ #0,D0
LBL_554:
        TST.L D0
        BEQ.W LBL_551
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_552
LBL_551:
        MOVEQ #0,D0
LBL_552:
        TST.L D0
        BEQ.W LBL_555
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        BRA.W LBL_545
LBL_555:
        MOVEQ #0,D0
        BRA.W LBL_545
LBL_545:
        UNLK A6
        RTS
        ; func rtUiWidgetGetInt  (JT slot 270)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local r : -8(A6)  size 4
        ;   local kind : -12(A6)  size 4
LBL_45:
        LINK A6,#-64
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
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_557
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
        BRA.W LBL_556
LBL_557:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_558
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_556
LBL_558:
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_559
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_556
LBL_559:
        MOVE.L 8(A6),D1
        MOVEQ #9,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_560
        MOVE.L 8(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_561
LBL_560:
        MOVEQ #1,D0
LBL_561:
        TST.L D0
        BEQ.W LBL_562
        MOVEQ #0,D0
        BRA.W LBL_556
LBL_562:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_563
        MOVE.L -12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_564
LBL_563:
        MOVEQ #0,D0
LBL_564:
        TST.L D0
        BEQ.W LBL_565
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2546(A5)
        ADDQ.L #8,A7
        BRA.W LBL_556
LBL_565:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_566
        MOVE.L -12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_567
LBL_566:
        MOVEQ #0,D0
LBL_567:
        TST.L D0
        BEQ.W LBL_568
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2514(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 2642(A5)
        ADDQ.L #4,A7
        BRA.W LBL_556
LBL_568:
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
        BRA.W LBL_556
LBL_556:
        UNLK A6
        RTS
        ; func rtUiScratchBitMapGet  (JT slot 271)
LBL_46:
        LINK A6,#-52
        MOVE.L -42(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_570
        MOVEQ #14,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-42(A5)
LBL_570:
        MOVE.L -42(A5),D0
        BRA.W LBL_569
LBL_569:
        UNLK A6
        RTS
        ; func rtUiBitMapFill  (JT slot 272)
        ;   param cb : 8(A6)  size 4
        ;   local bm : -4(A6)  size 4
LBL_47:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_46
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
        BRA.W LBL_571
LBL_571:
        UNLK A6
        RTS
        ; func rtUiCanvasDispose  (JT slot 273)
        ;   param cb : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_48:
        LINK A6,#-56
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
        BEQ.W LBL_573
        BRA.W LBL_572
LBL_573:
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
LBL_572:
        UNLK A6
        RTS
        ; func rtUiCanvasMake  (JT slot 274)
        ;   param cb : 16(A6)  size 4
        ;   param ww : 12(A6)  size 4
        ;   param hh : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
        ;   local rowBytes : -8(A6)  size 4
        ;   local bm : -12(A6)  size 4
        ;   local w2 : -16(A6)  size 4
        ;   local h2 : -20(A6)  size 4
LBL_49:
        LINK A6,#-72
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
        BEQ.W LBL_575
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
LBL_575:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_576
        MOVEQ #1,D0
        MOVE.L D0,-20(A6)
LBL_576:
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #108,D0
        MOVE.L D0,-(A7)
        JSR 1434(A5)
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
        BEQ.W LBL_577
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_577:
        MOVE.L -16(A6),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        BSR.W LBL_93
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_92
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L -20(A6),D0
        BSR.W LBL_92
        MOVE.L D0,-(A7)
        JSR 1434(A5)
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
        BEQ.W LBL_578
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_578:
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
        BSR.W LBL_47
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
LBL_574:
        UNLK A6
        RTS
        ; func rtUiCanvasReallocAll  (JT slot 275)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local kind : -20(A6)  size 4
        ;   local flags : -24(A6)  size 4
        ;   local r : -28(A6)  size 4
LBL_50:
        LINK A6,#-80
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
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_580:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_581
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_584
        MOVE.L -24(A6),D1
        MOVEQ #4,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_585
LBL_584:
        MOVEQ #0,D0
LBL_585:
        TST.L D0
        BEQ.W LBL_582
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        EORI.L #1,D0
        BRA.W LBL_583
LBL_582:
        MOVEQ #0,D0
LBL_583:
        TST.L D0
        BEQ.W LBL_586
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
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
        BSR.W LBL_49
        ADDA.W #12,A7
LBL_586:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_580
LBL_581:
LBL_579:
        UNLK A6
        RTS
        ; func rtUiFlushBufferedCanvases  (JT slot 276)
        ;   param inst : 10(A6)  size 4
        ;   param force : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local buf : -20(A6)  size 4
        ;   local bm : -24(A6)  size 4
LBL_51:
        LINK A6,#-76
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
        BEQ.W LBL_588
        BRA.W LBL_587
LBL_588:
        MOVE.L 10(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_589:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_590
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
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
        BEQ.W LBL_591
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BNE.W LBL_593
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_594
LBL_593:
        MOVEQ #1,D0
LBL_594:
        BRA.W LBL_592
LBL_591:
        MOVEQ #0,D0
LBL_592:
        TST.L D0
        BEQ.W LBL_595
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
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
        BSR.W LBL_16
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
LBL_595:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_589
LBL_590:
LBL_587:
        UNLK A6
        RTS
        ; func rtUiCanvasBegin  (JT slot 277)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local t : -24(A6)  size 16
        ;   local r : -28(A6)  size 4
LBL_52:
        LINK A6,#-80
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
        BSR.W LBL_18
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
        BEQ.W LBL_597
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
        BRA.W LBL_598
LBL_597:
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
        BSR.W LBL_16
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
LBL_598:
        BSR.W LBL_28
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
        BRA.W LBL_596
LBL_596:
        UNLK A6
        RTS
        ; func rtUiCanvasEnd  (JT slot 278)
        ;   param t : 8(A6)  size 4
LBL_53:
        LINK A6,#-52
        MOVEA.L 8(A6),A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_599:
        UNLK A6
        RTS
        ; func rtUiGrayPatsGet  (JT slot 279)
        ;   local p : -4(A6)  size 4
LBL_54:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_601
        MOVE.L -46(A5),D0
        BRA.W LBL_600
LBL_601:
        MOVEQ #72,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BRA.W LBL_600
LBL_600:
        UNLK A6
        RTS
        ; func rtUiCanvasPattern  (JT slot 280)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param level : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local lv : -12(A6)  size 4
LBL_55:
        LINK A6,#-64
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_603
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_603:
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_604
        MOVEQ #8,D0
        MOVE.L D0,-12(A6)
LBL_604:
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_602:
        UNLK A6
        RTS
        ; func rtUiCanvasClear  (JT slot 281)
        ;   param instV : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
        ;   local w : -20(A6)  size 4
        ;   local buf : -24(A6)  size 4
        ;   local scratch : -28(A6)  size 4
LBL_56:
        LINK A6,#-80
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
        ADDA.W #12,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
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
        BEQ.W LBL_606
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BRA.W LBL_607
LBL_606:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
LBL_607:
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
LBL_605:
        UNLK A6
        RTS
        ; func rtUiCanvasLine  (JT slot 282)
        ;   param instV : 28(A6)  size 4
        ;   param wIdx : 24(A6)  size 4
        ;   param x0 : 20(A6)  size 4
        ;   param y0 : 16(A6)  size 4
        ;   param x1 : 12(A6)  size 4
        ;   param y1 : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
LBL_57:
        LINK A6,#-68
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
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
        BSR.W LBL_53
        ADDQ.L #4,A7
LBL_608:
        UNLK A6
        RTS
        ; func rtUiCanvasRect  (JT slot 283)
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
LBL_58:
        LINK A6,#-84
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L 30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 26(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
        ADDA.W #12,A7
        MOVE.L 30(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BEQ.W LBL_610
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 26(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        BSR.W LBL_54
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
        BSR.W LBL_92
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8A5  ; UiFillRect
        BRA.W LBL_611
LBL_610:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A1  ; UiFrameRect
LBL_611:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
LBL_609:
        UNLK A6
        RTS
        ; func rtUiCanvasFillCircle  (JT slot 284)
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
LBL_59:
        LINK A6,#-84
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
        ADDA.W #12,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        BSR.W LBL_54
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
        BSR.W LBL_92
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
        BSR.W LBL_53
        ADDQ.L #4,A7
LBL_612:
        UNLK A6
        RTS
        ; func rtUiCanvasCircle  (JT slot 285)
        ;   param instV : 24(A6)  size 4
        ;   param wIdx : 20(A6)  size 4
        ;   param x : 16(A6)  size 4
        ;   param y : 12(A6)  size 4
        ;   param radius : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
        ;   local box : -20(A6)  size 4
LBL_60:
        LINK A6,#-72
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
        ADDA.W #12,A7
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BSR.W LBL_53
        ADDQ.L #4,A7
LBL_613:
        UNLK A6
        RTS
        ; func rtUiCanvasDrawText  (JT slot 286)
        ;   param instV : 24(A6)  size 4
        ;   param wIdx : 20(A6)  size 4
        ;   param x : 16(A6)  size 4
        ;   param y : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
LBL_61:
        LINK A6,#-68
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
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
        BSR.W LBL_53
        ADDQ.L #4,A7
LBL_614:
        UNLK A6
        RTS
        ; func rtUiClipEmpty  (JT slot 287)
        ;   local saved : -4(A6)  size 4
        ;   local r : -8(A6)  size 4
LBL_62:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_13
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87A  ; UiGetClip
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
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
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87B  ; UiClipRect
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        BRA.W LBL_615
LBL_615:
        UNLK A6
        RTS
        ; func rtUiClipRestore  (JT slot 288)
        ;   param rgn : 8(A6)  size 4
LBL_63:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A879  ; UiSetClip
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8D9  ; UiDisposeRgn
LBL_616:
        UNLK A6
        RTS
        ; func rtUiDrawDivider  (JT slot 289)
        ;   param r : 12(A6)  size 4
        ;   param style : 8(A6)  size 4
        ;   local top : -4(A6)  size 4
        ;   local left : -8(A6)  size 4
        ;   local ww : -12(A6)  size 4
        ;   local hh : -16(A6)  size 4
        ;   local ex : -20(A6)  size 4
        ;   local ey : -24(A6)  size 4
LBL_64:
        LINK A6,#-76
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
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_619
LBL_618:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
LBL_619:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_620
        MOVE.L -8(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -8(A6),D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A891  ; UiLineTo
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_622
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_623
LBL_622:
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_623:
        BRA.W LBL_621
LBL_620:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_93
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_625
LBL_624:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_93
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_625:
LBL_621:
        MOVE.L -8(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -8(A6),D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A891  ; UiLineTo
LBL_617:
        UNLK A6
        RTS
        ; func UiTENew  (JT slot 290)
        ;   param dst : 12(A6)  size 4
        ;   param view : 8(A6)  size 4
LBL_65:
        LINK A6,#-52
        JSR 2770(A5)
        CLR.L -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D2  ; UiTENewRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_626
LBL_626:
        UNLK A6
        RTS
        ; func nat_UiTEFromScrap  (JT slot 291)
        ;   local th : -4(A6)  size 4
        ;   local offSlot : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_66:
        LINK A6,#-64
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
        BEQ.W LBL_628
        MOVEQ #102,D0
        NEG.L D0
        BRA.W LBL_627
LBL_628:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BEQ.W LBL_629
        MOVE.L -12(A6),D0
        BRA.W LBL_627
LBL_629:
        MOVE.L -12(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_630
        MOVE.L #32767,D0
        MOVE.L D0,-12(A6)
LBL_630:
        MOVE.L #2736,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_627
LBL_627:
        UNLK A6
        RTS
        ; func nat_UiTEToScrap  (JT slot 292)
        ;   local th : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
        ;   local err : -12(A6)  size 4
LBL_67:
        LINK A6,#-64
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
        BEQ.W LBL_632
        MOVEQ #0,D0
        BRA.W LBL_631
LBL_632:
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
        BSR.W LBL_68
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
        BRA.W LBL_631
LBL_631:
        UNLK A6
        RTS
        ; func nat_UiTEGetScrapLength  (JT slot 293)
LBL_68:
        LINK A6,#-52
        MOVE.L #2736,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_633
LBL_633:
        UNLK A6
        RTS
        ; func rtUiTeWidestLine  (JT slot 294)
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
LBL_69:
        LINK A6,#-104
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
        BSR.W LBL_28
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
LBL_635:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_636
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
        BSR.W LBL_92
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
        BSR.W LBL_92
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
        BEQ.W LBL_637
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
        BRA.W LBL_638
LBL_637:
        MOVEQ #0,D0
LBL_638:
        TST.L D0
        BEQ.W LBL_639
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
LBL_639:
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-44(A6)
LBL_640:
        MOVE.L -44(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_641
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
        BEQ.W LBL_642
        MOVE.L #1024,D0
        MOVE.L D0,-48(A6)
LBL_642:
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
        BEQ.W LBL_643
        MOVE.L #32767,D0
        MOVE.L D0,-40(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-44(A6)
        BRA.W LBL_644
LBL_643:
        MOVE.L -44(A6),D1
        MOVE.L -48(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-44(A6)
LBL_644:
        BRA.W LBL_640
LBL_641:
        MOVE.L -40(A6),D1
        MOVE.L -52(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_645
        MOVE.L -40(A6),D0
        MOVE.L D0,-52(A6)
LBL_645:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_635
LBL_636:
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
        BRA.W LBL_634
LBL_634:
        UNLK A6
        RTS
        ; func rtUiTeScrollSync  (JT slot 295)
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
LBL_70:
        LINK A6,#-96
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
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        BRA.W LBL_646
LBL_647:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_648
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
        BSR.W LBL_92
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
        BEQ.W LBL_649
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_649:
        MOVE.L -32(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_650
        MOVE.L #32767,D0
        MOVE.L D0,-32(A6)
LBL_650:
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
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        BEQ.W LBL_651
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
LBL_651:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_648:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_652
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
        BSR.W LBL_69
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
        BEQ.W LBL_653
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_653:
        MOVE.L -32(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_654
        MOVE.L #32767,D0
        MOVE.L D0,-32(A6)
LBL_654:
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
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        BEQ.W LBL_655
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
LBL_655:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_652:
LBL_646:
        UNLK A6
        RTS
        ; func rtUiTeClamp  (JT slot 296)
        ;   param te : 12(A6)  size 4
        ;   param maxLen : 8(A6)  size 4
        ;   local teMp : -4(A6)  size 4
        ;   local th : -8(A6)  size 4
        ;   local thMp : -12(A6)  size 4
        ;   local sel : -16(A6)  size 4
LBL_71:
        LINK A6,#-68
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
        BEQ.W LBL_657
        BRA.W LBL_656
LBL_657:
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
        BEQ.W LBL_658
        MOVE.L 8(A6),D0
        MOVE.L D0,-16(A6)
LBL_658:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D1  ; UiTESetSelect
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_81(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
LBL_656:
        UNLK A6
        RTS
        ; func rtUiFieldCap  (JT slot 297)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local formOff : -8(A6)  size 4
        ;   local fieldIdx : -12(A6)  size 4
        ;   local layoutOff : -16(A6)  size 4
        ;   local ftype : -20(A6)  size 4
        ;   local strCap : -24(A6)  size 4
LBL_72:
        LINK A6,#-76
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_660
        MOVE.L #255,D0
        BRA.W LBL_659
LBL_660:
        CLR.L D0
        MOVE.B -124(A5),D0
        TST.L D0
        BEQ.W LBL_661
        MOVE.L -128(A5),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_662
LBL_661:
        MOVEQ #0,D0
LBL_662:
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_663
        MOVE.L #255,D0
        BRA.W LBL_659
LBL_663:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 810(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
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
        BEQ.W LBL_664
        MOVE.L #255,D0
        BRA.W LBL_659
LBL_664:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1346(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_665
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_666
        MOVE.L -24(A6),D0
        BRA.W LBL_659
LBL_666:
LBL_665:
        MOVE.L -20(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_667
        MOVEQ #1,D0
        BRA.W LBL_659
LBL_667:
        MOVE.L #255,D0
        BRA.W LBL_659
LBL_659:
        UNLK A6
        RTS
        ; func rtUiTeMutated  (JT slot 298)
        ;   param inst : 14(A6)  size 4
        ;   param wIdx : 10(A6)  size 4
        ;   param userEdit : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local cap : -16(A6)  size 4
LBL_73:
        LINK A6,#-68
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_669
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_670
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_671
LBL_670:
        MOVE.L #32000,D0
        MOVE.L D0,-16(A6)
LBL_671:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
LBL_669:
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        CLR.L D0
        MOVE.B 8(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_672
        BRA.W LBL_668
LBL_672:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 722(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_83(PC),A0
        MOVE.L A0,-(A7)
        JSR 2906(A5)
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
        JSR 4986(A5)
        ADDA.W #24,A7
LBL_668:
        UNLK A6
        RTS
        ; func rtUiTeRelayout  (JT slot 299)
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
LBL_74:
        LINK A6,#-160
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
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_674
        BRA.W LBL_673
LBL_674:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-26(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 922(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-28(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_675
        MOVEQ #0,D0
        MOVE.B D0,-26(A6)
        MOVEQ #0,D0
        MOVE.B D0,-28(A6)
LBL_675:
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_678
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_679
LBL_678:
        MOVEQ #0,D0
LBL_679:
        TST.L D0
        BEQ.W LBL_676
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BNE.W LBL_680
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_681
LBL_680:
        MOVEQ #1,D0
LBL_681:
        BRA.W LBL_677
LBL_676:
        MOVEQ #0,D0
LBL_677:
        TST.L D0
        BEQ.W LBL_682
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_682:
        MOVEQ #0,D0
        MOVE.B D0,-32(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_685
        MOVE.L -16(A6),D1
        MOVEQ #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_686
LBL_685:
        MOVEQ #0,D0
LBL_686:
        TST.L D0
        BEQ.W LBL_683
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_684
LBL_683:
        MOVEQ #0,D0
LBL_684:
        TST.L D0
        BEQ.W LBL_687
        MOVEQ #1,D0
        MOVE.B D0,-32(A6)
LBL_687:
        MOVEQ #15,D0
        MOVE.L D0,-36(A6)
        CLR.L D0
        MOVE.B -30(A6),D0
        TST.L D0
        BEQ.W LBL_688
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_688:
        MOVEQ #15,D0
        MOVE.L D0,-40(A6)
        CLR.L D0
        MOVE.B -32(A6),D0
        TST.L D0
        BEQ.W LBL_689
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
LBL_689:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
        BSR.W LBL_16
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
        BEQ.W LBL_690
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_691
LBL_690:
        MOVEQ #0,D0
LBL_691:
        TST.L D0
        BEQ.W LBL_692
        MOVE.L -52(A6),D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
LBL_692:
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
        BEQ.W LBL_693
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-104(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
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
        BEQ.W LBL_694
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_695
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_696
LBL_695:
        MOVE.L -56(A6),D0
        MOVE.L D0,-88(A6)
LBL_696:
        MOVE.L -64(A6),D0
        MOVE.L D0,-96(A6)
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_697
        MOVE.L -64(A6),D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-96(A6)
LBL_697:
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
LBL_694:
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_698
        MOVE.L -52(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_699
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-92(A6)
        BRA.W LBL_700
LBL_699:
        MOVE.L -52(A6),D0
        MOVE.L D0,-92(A6)
LBL_700:
        MOVE.L -60(A6),D0
        MOVE.L D0,-100(A6)
        CLR.L D0
        MOVE.B -82(A6),D0
        TST.L D0
        BEQ.W LBL_701
        MOVE.L -60(A6),D1
        MOVE.L -36(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-100(A6)
LBL_701:
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
LBL_698:
LBL_693:
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
        BEQ.W LBL_702
        MOVE.L -68(A6),D0
        MOVE.L D0,-76(A6)
LBL_702:
        MOVE.L -80(A6),D1
        MOVE.L -72(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_703
        MOVE.L -72(A6),D0
        MOVE.L D0,-80(A6)
LBL_703:
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
        BEQ.W LBL_704
        MOVE.L -108(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_705
LBL_704:
        MOVEQ #0,D0
LBL_705:
        TST.L D0
        BEQ.W LBL_706
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
LBL_706:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
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
LBL_673:
        UNLK A6
        RTS
        ; func rtUiTeSetFocus  (JT slot 300)
        ;   param inst : 12(A6)  size 4
        ;   param newIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local te : -8(A6)  size 4
LBL_75:
        LINK A6,#-60
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
        BEQ.W LBL_708
        BRA.W LBL_707
LBL_708:
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
        BEQ.W LBL_709
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_710
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D9  ; UiTEDeactivate
LBL_710:
LBL_709:
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
        BEQ.W LBL_711
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_712
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D8  ; UiTEActivate
LBL_712:
LBL_711:
        JSR 1722(A5)
LBL_707:
        UNLK A6
        RTS
        ; func rtUiTeHit  (JT slot 301)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local te : -20(A6)  size 4
LBL_76:
        LINK A6,#-72
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
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_714:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_715
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_716
        MOVE.L -16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_717
LBL_716:
        MOVEQ #1,D0
LBL_717:
        TST.L D0
        BEQ.W LBL_718
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_719
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
        BRA.W LBL_720
LBL_719:
        MOVEQ #0,D0
LBL_720:
        TST.L D0
        BEQ.W LBL_721
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_713
LBL_721:
LBL_718:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_714
LBL_715:
        MOVEQ #0,D0
        BRA.W LBL_713
LBL_713:
        UNLK A6
        RTS
        ; func rtUiScrollbarAction  (JT slot 302)
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
LBL_77:
        LINK A6,#-114
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
        BEQ.W LBL_723
        BRA.W LBL_722
LBL_723:
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
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_724
        BRA.W LBL_722
LBL_724:
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
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_725
        BRA.W LBL_722
LBL_725:
        MOVE.L -26(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_726
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
        BEQ.W LBL_728
        MOVEQ #0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_729
LBL_728:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_730
        MOVEQ #8,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_731
LBL_730:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_732
        MOVEQ #0,D1
        MOVE.L -38(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_733
LBL_732:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_734
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_735
LBL_734:
        BRA.W LBL_722
LBL_735:
LBL_733:
LBL_731:
LBL_729:
        BRA.W LBL_727
LBL_726:
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
        BEQ.W LBL_736
        MOVEQ #1,D0
        MOVE.L D0,-42(A6)
LBL_736:
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
        BEQ.W LBL_737
        MOVEQ #0,D1
        MOVE.L -42(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_738
LBL_737:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_739
        MOVE.L -42(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_740
LBL_739:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_741
        MOVEQ #0,D1
        MOVE.L -46(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_742
LBL_741:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_743
        MOVE.L -46(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_744
LBL_743:
        BRA.W LBL_722
LBL_744:
LBL_742:
LBL_740:
LBL_738:
LBL_727:
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
        BEQ.W LBL_745
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
LBL_745:
        MOVE.L -54(A6),D1
        MOVE.L -58(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_746
        MOVE.L -58(A6),D0
        MOVE.L D0,-54(A6)
LBL_746:
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
        BEQ.W LBL_747
        BRA.W LBL_722
LBL_747:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_748
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_749
LBL_748:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_749:
LBL_722:
        UNLK A6
        RTS
        ; func rtUiHandleScrollbarClick  (JT slot 303)
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
LBL_78:
        LINK A6,#-70
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
        BEQ.W LBL_751
        MOVE.L 12(A6),D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_756
        MOVE.L 12(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_757
LBL_756:
        MOVEQ #1,D0
LBL_757:
        TST.L D0
        BNE.W LBL_754
        MOVE.L 12(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_755
LBL_754:
        MOVEQ #1,D0
LBL_755:
        TST.L D0
        BNE.W LBL_752
        MOVE.L 12(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_753
LBL_752:
        MOVEQ #1,D0
LBL_753:
        TST.L D0
        BEQ.W LBL_758
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #8,A7
LBL_758:
        BRA.W LBL_750
LBL_751:
        MOVE.L 12(A6),D1
        MOVE.L #129,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_759
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
        BEQ.W LBL_761
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
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D1
        MOVE.L -10(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_762
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_763
LBL_762:
        MOVEQ #0,D0
LBL_763:
        TST.L D0
        BEQ.W LBL_764
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_765
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
        BRA.W LBL_766
LBL_765:
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
LBL_766:
LBL_764:
LBL_761:
        BRA.W LBL_760
LBL_759:
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA 5082(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
LBL_760:
LBL_750:
        UNLK A6
        RTS
        ; func rtUiTeIdleFront  (JT slot 304)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local te : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
LBL_79:
        LINK A6,#-72
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
        JSR 1506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_768
        BRA.W LBL_767
LBL_768:
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
        BEQ.W LBL_769
        BRA.W LBL_767
LBL_769:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_770
        BRA.W LBL_767
LBL_770:
        BSR.W LBL_28
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
LBL_767:
        UNLK A6
        RTS
        ; func rtUiTableScrollTo  (JT slot 305)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
LBL_80:
        LINK A6,#-52
LBL_771:
        UNLK A6
        RTS
LBL_92:
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
LBL_93:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_772
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_772:
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
        BPL.W LBL_773
        NEG.L D2
        MOVE.L #1,D4
LBL_773:
        CLR.L D5
        TST.L D3
        BPL.W LBL_774
        NEG.L D3
        MOVE.L #1,D5
LBL_774:
        CLR.L D6
        MOVE.W #31,D7
LBL_775:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_776
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_776:
        DBRA D7,LBL_775
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_777
        NEG.L D2
LBL_777:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_94:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_778
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_778:
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
        BPL.W LBL_779
        NEG.L D2
        MOVE.L #1,D4
LBL_779:
        CLR.L D5
        TST.L D3
        BPL.W LBL_780
        NEG.L D3
        MOVE.L #1,D5
LBL_780:
        CLR.L D6
        MOVE.W #31,D7
LBL_781:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_782
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_782:
        DBRA D7,LBL_781
        TST.L D4
        BEQ.W LBL_783
        NEG.L D6
LBL_783:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_95:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_784(PC),A0
        MOVE.L A0,-4(A6)
LBL_785:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_786
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_787
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_785
LBL_787:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_788:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_785
LBL_786:
        UNLK A6
        RTS
LBL_784:
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
        DC.W $E2F2
        DC.W $0001
        DC.W $E2EE
        DC.W $0000
        DC.W $E2EA
        DC.W $0000
        DC.W $0000
        DC.W $0000
        ; constant pool: string literals
LBL_90:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_83:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_84:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_85:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_86:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_87:
        DC.B $03
        DC.B $6B,$65,$79
LBL_89:
        DC.B $01
        DC.B $78
LBL_82:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_88:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_81:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_91:
        DC.B $00
        DC.B $00
