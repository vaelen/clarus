        ; func rtUiApplyResize  (JT slot 175)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param newW : 12(A6)  size 4
        ;   param newH : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local savedPort : -8(A6)  size 4
LBL_0:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_24
        MOVE.L D0,-8(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        DC.W $A91D  ; UiSizeWindow
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #4,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_83(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_187:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_187
        JSR 2322(A5)
        ADDA.W #260,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDA.W #20,A7
LBL_186:
        UNLK A6
        RTS
        ; func rtUiHandleGrow  (JT slot 176)
        ;   param wp : 16(A6)  size 4
        ;   param inst : 12(A6)  size 4
        ;   param wherePt : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local contRgnH : -8(A6)  size 4
        ;   local contRgnMp : -12(A6)  size 4
        ;   local contLeft : -16(A6)  size 4
        ;   local contTop : -20(A6)  size 4
        ;   local screenBoundsSlot : -24(A6)  size 4
        ;   local screenW : -28(A6)  size 4
        ;   local screenH : -32(A6)  size 4
        ;   local maxW : -36(A6)  size 4
        ;   local maxH : -40(A6)  size 4
        ;   local minW : -44(A6)  size 4
        ;   local minH : -48(A6)  size 4
        ;   local limits : -52(A6)  size 4
        ;   local newSize : -56(A6)  size 4
LBL_1:
        LINK A6,#-2184
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L #0,D0
        MOVE.L D0,-56(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 498(A5)
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
        BRA.W LBL_188
LBL_189:
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #118,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2970(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-40(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_190
        MOVE.L #1,D0
        MOVE.L D0,-36(A6)
LBL_190:
        MOVE.L -40(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_191
        MOVE.L #1,D0
        MOVE.L D0,-40(A6)
LBL_191:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_192
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 506(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        BRA.W LBL_193
LBL_192:
        MOVE.L #1,D0
        MOVE.L D0,-44(A6)
LBL_193:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 514(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_194
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 514(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-48(A6)
        BRA.W LBL_195
LBL_194:
        MOVE.L #1,D0
        MOVE.L D0,-48(A6)
LBL_195:
        MOVE.L -36(A6),D0
        MOVE.L D0,D1
        MOVE.L -44(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_196
        MOVE.L -44(A6),D0
        MOVE.L D0,-36(A6)
LBL_196:
        MOVE.L -40(A6),D0
        MOVE.L D0,D1
        MOVE.L -48(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_197
        MOVE.L -48(A6),D0
        MOVE.L D0,-40(A6)
LBL_197:
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-52(A6)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        CLR.L -(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A92B  ; UiGrowWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-56(A6)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -56(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_198
        BRA.W LBL_188
LBL_198:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1266(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1258(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDA.W #16,A7
LBL_188:
        UNLK A6
        RTS
        ; func rtUiApplyZoom  (JT slot 177)
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
LBL_2:
        LINK A6,#-2158
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
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_200
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2970(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
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
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.W D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,D1
        MOVE.L #19,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #130,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_201
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_201:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_200:
        BSR.W LBL_24
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #16,D0
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
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #16,D0
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
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #18,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,D1
        MOVE.L #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDA.W #16,A7
LBL_199:
        UNLK A6
        RTS
        ; func rtUiHandleZoom  (JT slot 178)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param wherePt : 12(A6)  size 4
        ;   param part : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_3:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 498(A5)
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_203
        BRA.W LBL_202
LBL_203:
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
        BEQ.W LBL_204
        BRA.W LBL_202
LBL_204:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDA.W #12,A7
LBL_202:
        UNLK A6
        RTS
        ; func rtUiFireWidget  (JT slot 179)
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
LBL_4:
        LINK A6,#-2158
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
        MOVE.L #0,D0
        MOVE.L D0,-26(A6)
        MOVE.L #0,D0
        MOVE.L D0,-30(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_24
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
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B -110(A5),D0
        TST.L D0
        BEQ.W LBL_206
        MOVE.L -114(A5),D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_207
LBL_206:
        MOVE.L #0,D0
LBL_207:
        MOVE.B D0,-22(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_208
        CLR.W -(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_210
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_211
LBL_210:
        MOVE.L #1,D0
        MOVE.L D0,-16(A6)
LBL_211:
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
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_84(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_212:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_212
        JSR 2330(A5)
        ADDA.W #264,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 3018(A5)
        ADDA.W #24,A7
        BRA.W LBL_209
LBL_208:
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_213
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_214
        MOVE.L -26(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_215
LBL_214:
        MOVE.L #0,D0
LBL_215:
        TST.L D0
        BEQ.W LBL_216
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2746(A5)
        ADDQ.L #4,A7
        BRA.W LBL_217
LBL_216:
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_218
        MOVE.L -26(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_219
LBL_218:
        MOVE.L #0,D0
LBL_219:
        TST.L D0
        BEQ.W LBL_220
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2754(A5)
        ADDQ.L #4,A7
        BRA.W LBL_221
LBL_220:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_222:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_222
        JSR 2330(A5)
        ADDA.W #264,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 3018(A5)
        ADDA.W #24,A7
LBL_221:
LBL_217:
LBL_213:
LBL_209:
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_223
        CLR.L D0
        MOVE.B -110(A5),D0
        EORI.L #1,D0
        BRA.W LBL_224
LBL_223:
        MOVE.L #0,D0
LBL_224:
        TST.L D0
        BEQ.W LBL_225
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-30(A6)
        MOVE.L -30(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_227
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_227:
        BRA.W LBL_226
LBL_225:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_226:
LBL_205:
        UNLK A6
        RTS
        ; func rtUiFindFlagged  (JT slot 180)
        ;   param inst : 16(A6)  size 4
        ;   param flag : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_5:
        LINK A6,#-2140
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
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_229:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_230
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_231
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_232
LBL_231:
        MOVE.L #0,D0
LBL_232:
        TST.L D0
        BEQ.W LBL_233
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        BRA.W LBL_228
LBL_233:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_229
LBL_230:
        MOVE.L #0,D0
        BRA.W LBL_228
LBL_228:
        UNLK A6
        RTS
        ; func rtUiCanvasHit  (JT slot 181)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_6:
        LINK A6,#-2140
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
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_235:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_236
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_237
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_238
LBL_237:
        MOVE.L #0,D0
LBL_238:
        TST.L D0
        BEQ.W LBL_239
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        BRA.W LBL_234
LBL_239:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_235
LBL_236:
        MOVE.L #0,D0
        BRA.W LBL_234
LBL_234:
        UNLK A6
        RTS
        ; func rtUiFireCanvasXY  (JT slot 182)
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
LBL_7:
        LINK A6,#-2152
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
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1258(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1266(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_241
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_243:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_243
        JSR 2330(A5)
        ADDA.W #264,A7
        BRA.W LBL_242
LBL_241:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_86(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_244:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_244
        JSR 2330(A5)
        ADDA.W #264,A7
LBL_242:
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
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L -24(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 3018(A5)
        ADDA.W #24,A7
LBL_240:
        UNLK A6
        RTS
        ; func rtUiHandleCanvasClick  (JT slot 183)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param wherePt : 8(A6)  size 4
        ;   local last : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
LBL_8:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDA.W #16,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
LBL_246:
        CLR.W -(A7)
        DC.W $A973  ; UiStillDown
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        TST.L D0
        BEQ.W LBL_247
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        JSR 1250(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_248
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDA.W #16,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
LBL_248:
        BRA.W LBL_246
LBL_247:
LBL_245:
        UNLK A6
        RTS
        ; func rtUiHandleContentClick  (JT slot 184)
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
LBL_9:
        LINK A6,#-2210
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L #0,D0
        MOVE.B D0,-50(A6)
        MOVE.L #0,D0
        MOVE.L D0,-54(A6)
        MOVE.L #0,D0
        MOVE.L D0,-58(A6)
        MOVE.L #0,D0
        MOVE.L D0,-62(A6)
        MOVE.L #0,D0
        MOVE.L D0,-66(A6)
        MOVE.L #0,D0
        MOVE.L D0,-70(A6)
        MOVE.L #0,D0
        MOVE.L D0,-74(A6)
        MOVE.L #0,D0
        MOVE.L D0,-78(A6)
        MOVE.L #0,D0
        MOVE.L D0,-82(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_250
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_251
LBL_250:
        MOVE.L #0,D0
LBL_251:
        TST.L D0
        BEQ.W LBL_252
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-54(A6)
        MOVE.L #0,D0
        MOVE.L D0,-58(A6)
LBL_253:
        MOVE.L -58(A6),D0
        MOVE.L D0,D1
        MOVE.L -54(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_254
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 1994(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-62(A6)
        MOVE.L -62(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_256
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #28,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_257
LBL_256:
        MOVE.L #0,D0
LBL_257:
        TST.L D0
        BEQ.W LBL_258
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_259
        BRA.W LBL_249
LBL_259:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_260
        MOVE.L #512,D0
        MOVE.L D0,-66(A6)
        BRA.W LBL_261
LBL_260:
        MOVE.L #0,D0
        MOVE.L D0,-66(A6)
LBL_261:
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
        BRA.W LBL_249
LBL_258:
LBL_255:
        MOVE.L -58(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-58(A6)
        BRA.W LBL_253
LBL_254:
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #32768,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_262
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #16383,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1962(A5)
        ADDA.W #20,A7
        BRA.W LBL_249
LBL_262:
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_263
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        BRA.W LBL_249
LBL_263:
        CLR.W -(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_264
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
LBL_264:
        BRA.W LBL_249
LBL_252:
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-36(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_265
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
        BSR.W LBL_8
        ADDA.W #16,A7
        BRA.W LBL_249
LBL_265:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-44(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 1946(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_266
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
        BEQ.W LBL_267
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
        BRA.W LBL_268
LBL_267:
        MOVE.L #0,D0
LBL_268:
        MOVE.B D0,-50(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR 1938(A5)
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
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D4  ; UiTEClick
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #8,A7
        BRA.W LBL_249
LBL_266:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-70(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        JSR 2178(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_269
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
        JSR 2202(A5)
        ADDQ.L #8,A7
        BRA.W LBL_249
LBL_269:
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-78(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_270
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
        BEQ.W LBL_271
        MOVE.L #512,D0
        MOVE.L D0,-66(A6)
        BRA.W LBL_272
LBL_271:
        MOVE.L #0,D0
        MOVE.L D0,-66(A6)
LBL_272:
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -82(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVE.L D0,-(A7)
        JSR 2154(A5)
        ADDA.W #16,A7
        BRA.W LBL_249
LBL_270:
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_249:
        UNLK A6
        RTS
        ; func rtUiHandleMouseDown  (JT slot 185)
        ;   param ev : 8(A6)  size 4
        ;   local wherePt : -4(A6)  size 4
        ;   local wpSlot : -8(A6)  size 4
        ;   local part : -12(A6)  size 4
        ;   local wp : -16(A6)  size 4
        ;   local inst : -20(A6)  size 4
        ;   local dragBounds : -24(A6)  size 4
        ;   local modifiers : -28(A6)  size 4
        ;   local shiftDown : -30(A6)  size 2
LBL_10:
        LINK A6,#-2158
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
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        MOVE.B -110(A5),D0
        TST.L D0
        BEQ.W LBL_274
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_275
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_273
LBL_275:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_278
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1146(A5)
        ADDQ.L #4,A7
        BRA.W LBL_279
LBL_278:
        MOVE.L #0,D0
LBL_279:
        TST.L D0
        BEQ.W LBL_276
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -114(A5),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_277
LBL_276:
        MOVE.L #0,D0
LBL_277:
        TST.L D0
        BEQ.W LBL_280
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_273
LBL_280:
LBL_274:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_283
        CLR.W -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91E  ; UiTrackGoAway
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_284
LBL_283:
        MOVE.L #0,D0
LBL_284:
        TST.L D0
        BEQ.W LBL_285
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_286
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 1226(A5)
        ADDQ.L #4,A7
LBL_286:
LBL_285:
        BRA.W LBL_282
LBL_281:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_287
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2970(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.W D0,-(A7)
        MOVE.L #4,D0
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
        JSR 1330(A5)
        BRA.W LBL_288
LBL_287:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_289
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_291
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDA.W #12,A7
LBL_291:
        BRA.W LBL_290
LBL_289:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_292
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_293
LBL_292:
        MOVE.L #1,D0
LBL_293:
        TST.L D0
        BEQ.W LBL_294
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_296
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDA.W #16,A7
LBL_296:
        BRA.W LBL_295
LBL_294:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_297
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
        BEQ.W LBL_299
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91F  ; UiSelectWindow
        JSR 1330(A5)
        BRA.W LBL_300
LBL_299:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_301
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #14,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #512,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
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
        BSR.W LBL_9
        ADDA.W #14,A7
LBL_301:
LBL_300:
        BRA.W LBL_298
LBL_297:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A93D  ; UiMenuSelect
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1346(A5)
        ADDQ.L #4,A7
LBL_302:
LBL_298:
LBL_295:
LBL_290:
LBL_288:
LBL_282:
LBL_273:
        UNLK A6
        RTS
        ; func rtUiHandleKey  (JT slot 186)
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
LBL_11:
        LINK A6,#-2172
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #14,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #256,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_304
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A93E  ; UiMenuKey
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1346(A5)
        ADDQ.L #4,A7
        BRA.W LBL_303
LBL_304:
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_305
        BRA.W LBL_303
LBL_305:
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
        MOVE.L #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_306
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_307
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_309
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_310
LBL_309:
        MOVE.L #1,D0
LBL_310:
        BRA.W LBL_308
LBL_307:
        MOVE.L #0,D0
LBL_308:
        TST.L D0
        BEQ.W LBL_311
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_312:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_312
        JSR 2330(A5)
        ADDA.W #264,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 3018(A5)
        ADDA.W #24,A7
        BRA.W LBL_303
LBL_311:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #27,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_313
        CLR.L D0
        MOVE.B -110(A5),D0
        TST.L D0
        BEQ.W LBL_318
        MOVE.L -114(A5),D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_319
LBL_318:
        MOVE.L #0,D0
LBL_319:
        TST.L D0
        BEQ.W LBL_316
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_317
LBL_316:
        MOVE.L #0,D0
LBL_317:
        TST.L D0
        BEQ.W LBL_314
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #28,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_320
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #31,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_321
LBL_320:
        MOVE.L #0,D0
LBL_321:
        EORI.L #1,D0
        BRA.W LBL_315
LBL_314:
        MOVE.L #0,D0
LBL_315:
        TST.L D0
        BEQ.W LBL_322
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 954(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1058(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_326
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_327
LBL_326:
        MOVE.L #1,D0
LBL_327:
        TST.L D0
        BEQ.W LBL_324
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 2682(A5)
        ADDA.W #12,A7
        EORI.L #1,D0
        BRA.W LBL_325
LBL_324:
        MOVE.L #0,D0
LBL_325:
        TST.L D0
        BEQ.W LBL_328
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        BRA.W LBL_303
LBL_328:
LBL_323:
LBL_322:
        BSR.W LBL_24
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
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9DC  ; UiTEKey
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #28,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_329
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #31,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_330
LBL_329:
        MOVE.L #0,D0
LBL_330:
        TST.L D0
        BEQ.W LBL_331
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #8,A7
        BRA.W LBL_332
LBL_331:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.B D0,-(A7)
        JSR 1922(A5)
        ADDA.W #10,A7
LBL_332:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        BRA.W LBL_303
LBL_313:
LBL_306:
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_335
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_336
LBL_335:
        MOVE.L #1,D0
LBL_336:
        TST.L D0
        BEQ.W LBL_333
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_334
LBL_333:
        MOVE.L #0,D0
LBL_334:
        TST.L D0
        BEQ.W LBL_337
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
        BSR.W LBL_4
        ADDQ.L #8,A7
        BRA.W LBL_303
LBL_337:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #27,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_338
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_339
LBL_338:
        MOVE.L #0,D0
LBL_339:
        TST.L D0
        BEQ.W LBL_340
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
        BSR.W LBL_4
        ADDQ.L #8,A7
        BRA.W LBL_303
LBL_340:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_88(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_341:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_341
        JSR 2322(A5)
        ADDA.W #260,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDA.W #20,A7
LBL_303:
        UNLK A6
        RTS
        ; func rtUiRun  (JT slot 187)
        ;   local evBuf : -4(A6)  size 4
        ;   local frontInst : -8(A6)  size 4
        ;   local sleepTicks : -12(A6)  size 4
        ;   local what : -16(A6)  size 4
        ;   local gotEvent : -18(A6)  size 2
LBL_12:
        LINK A6,#-2146
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.B D0,-18(A6)
        LEA LBL_180(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_343
        JSR 2650(A5)
        BRA.W LBL_342
LBL_343:
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
LBL_344:
        MOVE.L #1,D0
        TST.L D0
        BEQ.W LBL_345
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -26(A5),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_346
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_348
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_349
LBL_348:
        MOVE.L #0,D0
LBL_349:
        BRA.W LBL_347
LBL_346:
        MOVE.L #1,D0
LBL_347:
        TST.L D0
        BEQ.W LBL_350
        MOVE.L #1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_351
LBL_350:
        MOVE.L #30,D0
        MOVE.L D0,-12(A6)
LBL_351:
        CLR.W -(A7)
        MOVE.L #65535,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A860  ; UiWaitNextEvent
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-18(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_352
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #4,A7
        BRA.W LBL_353
LBL_352:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_354
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_355
LBL_354:
        MOVE.L #1,D0
LBL_355:
        TST.L D0
        BEQ.W LBL_356
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
        BRA.W LBL_357
LBL_356:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #4,A7
        BRA.W LBL_359
LBL_358:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #14,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #6,A7
LBL_360:
LBL_359:
LBL_357:
LBL_353:
        JSR 1362(A5)
        JSR 1970(A5)
        JSR 1378(A5)
        JSR 2170(A5)
        BRA.W LBL_344
LBL_345:
LBL_342:
        UNLK A6
        RTS
        ; func rtUiLaunch  (JT slot 188)
        ;   local script : -4(A6)  size 4
        ;   local cursor : -8(A6)  size 4
        ;   local lineStart : -12(A6)  size 4
        ;   local lineLen : -16(A6)  size 4
        ;   local isLaunchDoc : -18(A6)  size 2
        ;   local found : -20(A6)  size 2
        ;   local pathBuf : -24(A6)  size 4
        ;   local pathLen : -28(A6)  size 4
LBL_13:
        LINK A6,#-2156
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.B D0,-18(A6)
        MOVE.L #0,D0
        MOVE.B D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        LEA LBL_180(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        JSR 1138(A5)
        BRA.W LBL_361
LBL_362:
        MOVE.L #0,D0
        MOVE.B D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
LBL_363:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_364
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_365:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_367
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_368
LBL_367:
        MOVE.L #0,D0
LBL_368:
        TST.L D0
        BEQ.W LBL_366
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_365
LBL_366:
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.B D0,-18(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_369
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #108,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_386
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #97,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_387
LBL_386:
        MOVE.L #0,D0
LBL_387:
        TST.L D0
        BEQ.W LBL_384
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #117,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_385
LBL_384:
        MOVE.L #0,D0
LBL_385:
        TST.L D0
        BEQ.W LBL_382
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #110,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_383
LBL_382:
        MOVE.L #0,D0
LBL_383:
        TST.L D0
        BEQ.W LBL_380
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_381
LBL_380:
        MOVE.L #0,D0
LBL_381:
        TST.L D0
        BEQ.W LBL_378
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #104,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_379
LBL_378:
        MOVE.L #0,D0
LBL_379:
        TST.L D0
        BEQ.W LBL_376
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #100,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_377
LBL_376:
        MOVE.L #0,D0
LBL_377:
        TST.L D0
        BEQ.W LBL_374
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #111,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_375
LBL_374:
        MOVE.L #0,D0
LBL_375:
        TST.L D0
        BEQ.W LBL_372
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_373
LBL_372:
        MOVE.L #0,D0
LBL_373:
        TST.L D0
        BEQ.W LBL_370
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #9,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #32,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_371
LBL_370:
        MOVE.L #0,D0
LBL_371:
        TST.L D0
        BEQ.W LBL_388
        MOVE.L #1,D0
        MOVE.B D0,-18(A6)
LBL_388:
LBL_369:
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_389
        MOVE.L #1,D0
        MOVE.B D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        MOVE.L #255,D0
        MOVE.L D0,-28(A6)
LBL_390:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
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
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 2442(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_389:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_391
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_391:
        BRA.W LBL_363
LBL_364:
        CLR.L D0
        MOVE.B -20(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_392
        JSR 3058(A5)
LBL_392:
LBL_361:
        UNLK A6
        RTS
        ; func rtUiSetCtrlAt  (JT slot 189)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_14:
        LINK A6,#-2128
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_393:
        UNLK A6
        RTS
        ; func rtUiRectAt  (JT slot 190)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_15:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_394
LBL_394:
        UNLK A6
        RTS
        ; func rtUiLabelAt  (JT slot 191)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_16:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_395
LBL_395:
        UNLK A6
        RTS
        ; func rtUiCanvasBufAt  (JT slot 192)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_17:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #36,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_396
LBL_396:
        UNLK A6
        RTS
        ; func rtUiTeAt  (JT slot 193)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_18:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_397
LBL_397:
        UNLK A6
        RTS
        ; func rtUiSetTeAt  (JT slot 194)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_19:
        LINK A6,#-2128
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_398:
        UNLK A6
        RTS
        ; func rtUiHbarAt  (JT slot 195)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_20:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 64(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_399
LBL_399:
        UNLK A6
        RTS
        ; func rtUiSetHbarAt  (JT slot 196)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_21:
        LINK A6,#-2128
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 64(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_400:
        UNLK A6
        RTS
        ; func rtUiEnabledAt  (JT slot 197)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_22:
        LINK A6,#-2128
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
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_401
LBL_401:
        UNLK A6
        RTS
        ; func rtUiSetEnabledAt  (JT slot 198)
        ;   param w : 14(A6)  size 4
        ;   param i : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
LBL_23:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_403
        MOVE.L 14(A6),D0
        MOVEA.L D0,A0
        LEA 72(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_404
LBL_403:
        MOVE.L 14(A6),D0
        MOVEA.L D0,A0
        LEA 72(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_404:
LBL_402:
        UNLK A6
        RTS
        ; func rtUiGetPortSaved  (JT slot 199)
        ;   local slot : -4(A6)  size 4
        ;   local p : -8(A6)  size 4
LBL_24:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        BRA.W LBL_405
LBL_405:
        UNLK A6
        RTS
        ; func rtUiKindHeight  (JT slot 200)
        ;   param kind : 8(A6)  size 4
        ;   local __switch2 : -4(A6)  size 4
LBL_25:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_407
        MOVE.L #20,D0
        BRA.W LBL_406
        BRA.W LBL_408
LBL_407:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_409
        MOVE.L #16,D0
        BRA.W LBL_406
        BRA.W LBL_410
LBL_409:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_411
        MOVE.L #16,D0
        BRA.W LBL_406
        BRA.W LBL_412
LBL_411:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_413
        MOVE.L #100,D0
        BRA.W LBL_406
        BRA.W LBL_414
LBL_413:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        MOVE.L #20,D0
        BRA.W LBL_406
        BRA.W LBL_416
LBL_415:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_417
        MOVE.L #100,D0
        BRA.W LBL_406
        BRA.W LBL_418
LBL_417:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        MOVE.L #20,D0
        BRA.W LBL_406
        BRA.W LBL_420
LBL_419:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        MOVE.L #120,D0
        BRA.W LBL_406
        BRA.W LBL_422
LBL_421:
        MOVE.L #16,D0
        BRA.W LBL_406
LBL_422:
LBL_420:
LBL_418:
LBL_416:
LBL_414:
LBL_412:
LBL_410:
LBL_408:
        MOVE.L #16,D0
        BRA.W LBL_406
LBL_406:
        UNLK A6
        RTS
        ; func rtUiKindWidth  (JT slot 201)
        ;   param kind : 8(A6)  size 4
        ;   local __switch3 : -4(A6)  size 4
LBL_26:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
        MOVE.L #80,D0
        BRA.W LBL_423
        BRA.W LBL_425
LBL_424:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        MOVE.L #90,D0
        BRA.W LBL_423
        BRA.W LBL_427
LBL_426:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVE.L #150,D0
        BRA.W LBL_423
        BRA.W LBL_429
LBL_428:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
        MOVE.L #200,D0
        BRA.W LBL_423
        BRA.W LBL_431
LBL_430:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        MOVE.L #200,D0
        BRA.W LBL_423
        BRA.W LBL_433
LBL_432:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
        MOVE.L #200,D0
        BRA.W LBL_423
        BRA.W LBL_435
LBL_434:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_436
        MOVE.L #200,D0
        BRA.W LBL_423
        BRA.W LBL_437
LBL_436:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_438
        MOVE.L #300,D0
        BRA.W LBL_423
        BRA.W LBL_439
LBL_438:
        MOVE.L #90,D0
        BRA.W LBL_423
LBL_439:
LBL_437:
LBL_435:
LBL_433:
LBL_431:
LBL_429:
LBL_427:
LBL_425:
        MOVE.L #90,D0
        BRA.W LBL_423
LBL_423:
        UNLK A6
        RTS
        ; func rtUiPstrcpy  (JT slot 202)
        ;   param dst : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_27:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_440
LBL_441:
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
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
LBL_440:
        UNLK A6
        RTS
        ; func rtUiLayout  (JT slot 203)
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
        ;   local ctrlMp : -84(A6)  size 4
        ;   local __switch4 : -88(A6)  size 4
LBL_28:
        LINK A6,#-2216
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L #0,D0
        MOVE.L D0,-56(A6)
        MOVE.L #0,D0
        MOVE.L D0,-60(A6)
        MOVE.L #0,D0
        MOVE.L D0,-64(A6)
        MOVE.L #0,D0
        MOVE.L D0,-68(A6)
        MOVE.L #0,D0
        MOVE.B D0,-70(A6)
        MOVE.L #0,D0
        MOVE.B D0,-72(A6)
        MOVE.L #0,D0
        MOVE.B D0,-74(A6)
        MOVE.L #0,D0
        MOVE.B D0,-76(A6)
        MOVE.L #0,D0
        MOVE.L D0,-80(A6)
        MOVE.L #0,D0
        MOVE.L D0,-84(A6)
        MOVE.L #0,D0
        MOVE.L D0,-88(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_24
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
        MOVE.L #22,D0
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
        MOVE.L #18,D0
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
        MOVE.L #20,D0
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
        MOVE.L #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
LBL_443:
        MOVE.L -40(A6),D0
        MOVE.L D0,D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_444
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVE.L D0,-68(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-88(A6)
        MOVE.L -88(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_446
LBL_445:
        MOVE.L -88(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
        MOVE.L -24(A6),D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_448
LBL_447:
        MOVE.L -88(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        MOVE.L #12,D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_450
LBL_449:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 610(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
LBL_450:
LBL_448:
LBL_446:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 618(A5)
        ADDQ.L #8,A7
        TST.L D0
        BNE.W LBL_451
        MOVE.L -48(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_452
LBL_451:
        MOVE.L #1,D0
LBL_452:
        TST.L D0
        BEQ.W LBL_453
        MOVE.L -32(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_454
LBL_453:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 626(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
LBL_454:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-70(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 650(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-72(A6)
        MOVE.L #0,D0
        MOVE.B D0,-74(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        MOVE.L -52(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_458
LBL_457:
        MOVE.L #0,D0
LBL_458:
        TST.L D0
        BEQ.W LBL_455
        CLR.L D0
        MOVE.B -70(A6),D0
        TST.L D0
        BNE.W LBL_459
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_460
LBL_459:
        MOVE.L #1,D0
LBL_460:
        BRA.W LBL_456
LBL_455:
        MOVE.L #0,D0
LBL_456:
        TST.L D0
        BEQ.W LBL_461
        MOVE.L #1,D0
        MOVE.B D0,-74(A6)
LBL_461:
        MOVE.L #0,D0
        MOVE.B D0,-76(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_464
        MOVE.L -52(A6),D0
        MOVE.L D0,D1
        MOVE.L #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_465
LBL_464:
        MOVE.L #0,D0
LBL_465:
        TST.L D0
        BEQ.W LBL_462
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_463
LBL_462:
        MOVE.L #0,D0
LBL_463:
        TST.L D0
        BEQ.W LBL_466
        MOVE.L #1,D0
        MOVE.B D0,-76(A6)
LBL_466:
        CLR.L D0
        MOVE.B -70(A6),D0
        TST.L D0
        BNE.W LBL_467
        CLR.L D0
        MOVE.B -72(A6),D0
        BRA.W LBL_468
LBL_467:
        MOVE.L #1,D0
LBL_468:
        TST.L D0
        BEQ.W LBL_469
        CLR.L D0
        MOVE.B -74(A6),D0
        TST.L D0
        BEQ.W LBL_471
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L -56(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_472
LBL_471:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L -56(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-64(A6)
LBL_472:
        BRA.W LBL_470
LBL_469:
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_473
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_474
LBL_473:
        MOVE.L #0,D0
LBL_474:
        TST.L D0
        BEQ.W LBL_475
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_477
        MOVE.L #130,D0
        MOVE.L D0,D1
        MOVE.L #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_478
LBL_477:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #70,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
LBL_478:
        BRA.W LBL_476
LBL_475:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_479
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        BRA.W LBL_480
LBL_479:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 642(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-64(A6)
LBL_480:
LBL_476:
LBL_470:
        MOVE.L -64(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        MOVE.L #0,D0
        MOVE.L D0,-64(A6)
LBL_481:
        CLR.L D0
        MOVE.B -72(A6),D0
        TST.L D0
        BEQ.W LBL_482
        CLR.L D0
        MOVE.B -76(A6),D0
        TST.L D0
        BEQ.W LBL_483
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L -60(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-68(A6)
        BRA.W LBL_484
LBL_483:
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L -60(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-68(A6)
LBL_484:
        MOVE.L -68(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_485
        MOVE.L #0,D0
        MOVE.L D0,-68(A6)
LBL_485:
LBL_482:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,D1
        MOVE.L -64(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_486
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_487
LBL_486:
        MOVE.L #1,D0
LBL_487:
        TST.L D0
        BEQ.W LBL_488
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1930(A5)
        ADDQ.L #8,A7
        BRA.W LBL_489
LBL_488:
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 2106(A5)
        ADDQ.L #8,A7
        BRA.W LBL_491
LBL_490:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_492
        MOVE.L -80(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-84(A6)
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
LBL_492:
LBL_491:
LBL_489:
        MOVE.L -56(A6),D0
        MOVE.L D0,-24(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,D1
        MOVE.L -64(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_443
LBL_444:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_442:
        UNLK A6
        RTS
        ; func rtUiMakeWidgets  (JT slot 204)
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
LBL_29:
        LINK A6,#-2248
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L #0,D0
        MOVE.L D0,-56(A6)
        MOVE.L #0,D0
        MOVE.L D0,-60(A6)
        MOVE.L #0,D0
        MOVE.L D0,-64(A6)
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
        MOVE.L #0,D0
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-92(A6)
        MOVE.L #0,D0
        MOVE.L D0,-96(A6)
        MOVE.L #0,D0
        MOVE.L D0,-100(A6)
        MOVE.L #0,D0
        MOVE.L D0,-104(A6)
        MOVE.L #0,D0
        MOVE.L D0,-108(A6)
        MOVE.L #0,D0
        MOVE.L D0,-112(A6)
        MOVE.L #0,D0
        MOVE.L D0,-116(A6)
        MOVE.L #0,D0
        MOVE.L D0,-120(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_24
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
LBL_494:
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_495
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_496
        MOVE.L -20(A6),D0
        MOVE.L D0,-36(A6)
LBL_496:
        MOVE.L -32(A6),D0
        MOVE.L D0,-120(A6)
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_497
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A954  ; UiNewControl
        MOVE.L (A7)+,D0
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_498
LBL_497:
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_499
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A954  ; UiNewControl
        MOVE.L (A7)+,D0
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_500
LBL_499:
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_501
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_502
LBL_501:
        MOVE.L #1,D0
LBL_502:
        TST.L D0
        BEQ.W LBL_503
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        BRA.W LBL_504
LBL_503:
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_505
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        CLR.L -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D2  ; UiTENew
        MOVE.L (A7)+,D0
        MOVE.L D0,-48(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDA.W #12,A7
        BRA.W LBL_506
LBL_505:
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_507
        CLR.L -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D2  ; UiTENew
        MOVE.L (A7)+,D0
        MOVE.L D0,-48(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDA.W #12,A7
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A813  ; UiTEAutoView
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-64(A6)
        MOVE.L -64(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_509
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #16,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A954  ; UiNewControl
        MOVE.L (A7)+,D0
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L D0,D1
        MOVE.L -28(A6),D0
        OR.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_510
LBL_509:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
LBL_510:
        MOVE.L -64(A6),D0
        MOVE.L D0,D1
        MOVE.L #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L -52(A6),D0
        MOVE.L D0,D1
        MOVE.L #72,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #16,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A954  ; UiNewControl
        MOVE.L (A7)+,D0
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDA.W #12,A7
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-60(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,D1
        MOVE.L #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #49152,D0
        MOVE.L D0,D1
        MOVE.L -28(A6),D0
        OR.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_512
LBL_511:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDA.W #12,A7
LBL_512:
        BRA.W LBL_508
LBL_507:
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_513
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDA.W #12,A7
        CLR.L -(A7)
        MOVE.L #1000,D0
        MOVE.L D0,D1
        MOVE.L -28(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        JSR 1282(A5)
        MOVE.L D0,-(A7)
        DC.W $A931  ; UiNewMenu
        MOVE.L (A7)+,D0
        MOVE.L D0,-68(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 954(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-76(A6)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_515
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        JSR 1082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        JSR 1090(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-92(A6)
LBL_516:
        MOVE.L -92(A6),D0
        MOVE.L D0,D1
        MOVE.L -84(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        JSR 1114(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A947  ; UiSetMenuItemText
        MOVE.L -92(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-92(A6)
        BRA.W LBL_516
LBL_517:
LBL_515:
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.W D0,-(A7)
        DC.W $A935  ; UiInsertMenu
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        JSR 2018(A5)
        ADDA.W #12,A7
        BRA.W LBL_514
LBL_513:
        MOVE.L -120(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_518
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        JSR 2074(A5)
        MOVE.L D0,-104(A6)
        MOVE.L -104(A6),D0
        MOVE.L D0,D1
        MOVE.L #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        OR.L D1,D0
        MOVE.L D0,-108(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-100(A6)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        CLR.L -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.W #68,-(A7)
        DC.W $A9E7  ; UiLNew
        MOVE.L (A7)+,D0
        MOVE.L D0,-96(A6)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -96(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
        LEA LBL_66(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_521:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_521
        JSR 50(A5)
        ADDA.W #256,A7
LBL_520:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 2002(A5)
        ADDA.W #12,A7
        MOVE.L -96(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #128,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 666(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-116(A6)
        MOVE.L -96(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #60,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        JSR 2090(A5)
        MOVE.L D0,-112(A6)
        MOVE.L -96(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #64,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -112(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #44,-(A7)
        DC.W $A9E7  ; UiLSetDrawingMode
        BRA.W LBL_519
LBL_518:
        LEA LBL_89(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_185
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
LBL_519:
LBL_514:
LBL_508:
LBL_506:
LBL_504:
LBL_500:
LBL_498:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_522
        MOVE.L -32(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_523
LBL_522:
        MOVE.L #0,D0
LBL_523:
        TST.L D0
        BEQ.W LBL_524
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_524:
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_494
LBL_495:
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
LBL_493:
        UNLK A6
        RTS
        ; func rtUiWidgetSetStr  (JT slot 205)
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
LBL_30:
        LINK A6,#-2156
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
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_24
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
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2402(A5)
        ADDA.W #16,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_526
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_527
LBL_526:
        MOVE.L #0,D0
LBL_527:
        TST.L D0
        BEQ.W LBL_528
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        BRA.W LBL_529
LBL_528:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_532
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_533
LBL_532:
        MOVE.L #0,D0
LBL_533:
        TST.L D0
        BEQ.W LBL_530
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_531
LBL_530:
        MOVE.L #0,D0
LBL_531:
        TST.L D0
        BEQ.W LBL_534
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A95F  ; UiSetControlTitle
        BRA.W LBL_535
LBL_534:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_538
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_539
LBL_538:
        MOVE.L #0,D0
LBL_539:
        TST.L D0
        BEQ.W LBL_536
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_537
LBL_536:
        MOVE.L #0,D0
LBL_537:
        TST.L D0
        BEQ.W LBL_540
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_542
LBL_541:
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
LBL_542:
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
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
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.B D0,-(A7)
        JSR 1922(A5)
        ADDA.W #10,A7
LBL_540:
LBL_535:
LBL_529:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_525:
        UNLK A6
        RTS
        ; func rtUiWidgetGetStr  (JT slot 206)
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
LBL_31:
        LINK A6,#-2152
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
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_544
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_545
LBL_544:
        MOVE.L #0,D0
LBL_545:
        TST.L D0
        BEQ.W LBL_546
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        BRA.W LBL_547
LBL_546:
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_548
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_549
LBL_548:
        MOVE.L #0,D0
LBL_549:
        TST.L D0
        BEQ.W LBL_550
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_551
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_552
        MOVE.L #255,D0
        MOVE.L D0,-20(A6)
LBL_552:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #62,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
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
LBL_551:
LBL_550:
LBL_547:
LBL_543:
        UNLK A6
        RTS
        ; func rtUiWidgetGetText  (JT slot 207)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local teMp : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
        ;   local hText : -24(A6)  size 4
LBL_32:
        LINK A6,#-2152
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_554
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_555
LBL_554:
        MOVE.L #1,D0
LBL_555:
        TST.L D0
        BEQ.W LBL_556
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDA.W #16,A7
        BRA.W LBL_553
LBL_556:
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #62,D0
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
        JSR 146(A5)
        ADDA.W #16,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
LBL_553:
        UNLK A6
        RTS
        ; func rtUiWidgetSetText  (JT slot 208)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local savedPort : -16(A6)  size 4
        ;   local buf : -20(A6)  size 4
        ;   local copied : -24(A6)  size 4
LBL_33:
        LINK A6,#-2152
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_558
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_559
LBL_558:
        MOVE.L #1,D0
LBL_559:
        TST.L D0
        BEQ.W LBL_560
        BRA.W LBL_557
LBL_560:
        BSR.W LBL_24
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #32000,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_561
        LEA LBL_66(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_562:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_562
        JSR 50(A5)
        ADDA.W #256,A7
LBL_561:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32000,D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #12,A7
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9CF  ; UiTESetText
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.B D0,-(A7)
        JSR 1922(A5)
        ADDA.W #10,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_557:
        UNLK A6
        RTS
        ; func rtUiWidgetSetBool  (JT slot 209)
        ;   param instV : 18(A6)  size 4
        ;   param wIdx : 14(A6)  size 4
        ;   param prop : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local savedPort : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local ctrl : -20(A6)  size 4
LBL_34:
        LINK A6,#-2148
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
        MOVE.L 18(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_24
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
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-(A7)
        JSR 2410(A5)
        ADDA.W #14,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_566
        MOVE.L 10(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_567
LBL_566:
        MOVE.L #0,D0
LBL_567:
        TST.L D0
        BEQ.W LBL_564
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_565
LBL_564:
        MOVE.L #0,D0
LBL_565:
        TST.L D0
        BEQ.W LBL_568
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_570
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_571
LBL_570:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_571:
        BRA.W LBL_569
LBL_568:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_574
        MOVE.L 10(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_575
LBL_574:
        MOVE.L #0,D0
LBL_575:
        TST.L D0
        BEQ.W LBL_572
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_573
LBL_572:
        MOVE.L #0,D0
LBL_573:
        TST.L D0
        BEQ.W LBL_576
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_23
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
        BEQ.W LBL_577
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_578
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
        BRA.W LBL_579
LBL_578:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
LBL_579:
LBL_577:
LBL_576:
LBL_569:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_563:
        UNLK A6
        RTS
        ; func rtUiWidgetSetInt  (JT slot 210)
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
        ;   local tableOff : -32(A6)  size 4
        ;   local rowsIdx : -36(A6)  size 4
        ;   local rowsAddr : -40(A6)  size 4
        ;   local rows : -44(A6)  size 4
        ;   local row : -48(A6)  size 4
LBL_35:
        LINK A6,#-2176
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_24
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
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_581
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_582
LBL_581:
        MOVE.L #0,D0
LBL_582:
        TST.L D0
        BEQ.W LBL_583
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2010(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_584
        CLR.W -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2010(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A950  ; UiCountMItems
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_585
LBL_584:
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
LBL_585:
        MOVE.L 8(A6),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_586
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
LBL_586:
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_587
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_588
LBL_587:
        MOVE.L #0,D0
LBL_588:
        TST.L D0
        BEQ.W LBL_589
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
LBL_589:
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_590
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
LBL_590:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2418(A5)
        ADDA.W #16,A7
LBL_583:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_591
        MOVE.L 12(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_592
LBL_591:
        MOVE.L #0,D0
LBL_592:
        TST.L D0
        BEQ.W LBL_593
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1994(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 666(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 962(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3050(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_594
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-48(A6)
LBL_594:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR 2122(A5)
        ADDQ.L #8,A7
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR 2418(A5)
        ADDA.W #16,A7
LBL_593:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_580:
        UNLK A6
        RTS
        ; func rtUiWidgetGetBool  (JT slot 211)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local kind : -12(A6)  size 4
        ;   local ctrl : -16(A6)  size 4
LBL_36:
        LINK A6,#-2144
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
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
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_598
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_599
LBL_598:
        MOVE.L #0,D0
LBL_599:
        TST.L D0
        BEQ.W LBL_596
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_597
LBL_596:
        MOVE.L #0,D0
LBL_597:
        TST.L D0
        BEQ.W LBL_600
        CLR.W -(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_595
LBL_600:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_603
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_604
LBL_603:
        MOVE.L #0,D0
LBL_604:
        TST.L D0
        BEQ.W LBL_601
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_602
LBL_601:
        MOVE.L #0,D0
LBL_602:
        TST.L D0
        BEQ.W LBL_605
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        BRA.W LBL_595
LBL_605:
        MOVE.L #0,D0
        BRA.W LBL_595
LBL_595:
        UNLK A6
        RTS
        ; func rtUiWidgetGetInt  (JT slot 212)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local r : -8(A6)  size 4
        ;   local kind : -12(A6)  size 4
LBL_37:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_607
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_606
LBL_607:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_608
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_609
LBL_608:
        MOVE.L #0,D0
LBL_609:
        TST.L D0
        BEQ.W LBL_610
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2026(A5)
        ADDQ.L #8,A7
        BRA.W LBL_606
LBL_610:
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_611
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_612
LBL_611:
        MOVE.L #0,D0
LBL_612:
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1994(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 2114(A5)
        ADDQ.L #4,A7
        BRA.W LBL_606
LBL_613:
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_606
LBL_606:
        UNLK A6
        RTS
        ; func rtUiScratchBitMapGet  (JT slot 213)
LBL_38:
        LINK A6,#-2128
        MOVE.L -34(A5),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_615
        MOVE.L #14,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-34(A5)
LBL_615:
        MOVE.L -34(A5),D0
        BRA.W LBL_614
LBL_614:
        UNLK A6
        RTS
        ; func rtUiBitMapFill  (JT slot 214)
        ;   param cb : 8(A6)  size 4
        ;   local bm : -4(A6)  size 4
LBL_39:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_38
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_616
LBL_616:
        UNLK A6
        RTS
        ; func rtUiCanvasDispose  (JT slot 215)
        ;   param cb : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_40:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
        BRA.W LBL_617
LBL_618:
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
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_617:
        UNLK A6
        RTS
        ; func rtUiCanvasMake  (JT slot 216)
        ;   param cb : 16(A6)  size 4
        ;   param ww : 12(A6)  size 4
        ;   param hh : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
        ;   local rowBytes : -8(A6)  size 4
        ;   local bm : -12(A6)  size 4
        ;   local w2 : -16(A6)  size 4
        ;   local h2 : -20(A6)  size 4
LBL_41:
        LINK A6,#-2148
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_620
        MOVE.L #1,D0
        MOVE.L D0,-16(A6)
LBL_620:
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_621
        MOVE.L #1,D0
        MOVE.L D0,-20(A6)
LBL_621:
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #108,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; UiNewPtrClear
        MOVE.L A0,D0
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
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_622
        LEA LBL_66(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_623:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_623
        JSR 50(A5)
        ADDA.W #256,A7
LBL_622:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #15,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #16,D0
        BSR.W LBL_183
        MOVE.L D0,D1
        MOVE.L #2,D0
        BSR.W LBL_182
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        BSR.W LBL_182
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; UiNewPtrClear
        MOVE.L A0,D0
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
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        LEA LBL_66(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_625:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_625
        JSR 50(A5)
        ADDA.W #256,A7
LBL_624:
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
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
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
        BSR.W LBL_39
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
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A878  ; UiSetOrigin
LBL_619:
        UNLK A6
        RTS
        ; func rtUiCanvasReallocAll  (JT slot 217)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local kind : -20(A6)  size 4
        ;   local flags : -24(A6)  size 4
        ;   local r : -28(A6)  size 4
LBL_42:
        LINK A6,#-2156
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_627:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_628
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_629
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_630
LBL_629:
        MOVE.L #0,D0
LBL_630:
        TST.L D0
        BEQ.W LBL_631
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
LBL_631:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_627
LBL_628:
LBL_626:
        UNLK A6
        RTS
        ; func rtUiFlushBufferedCanvases  (JT slot 218)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local buf : -20(A6)  size 4
        ;   local bm : -24(A6)  size 4
LBL_43:
        LINK A6,#-2152
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
        MOVE.L 8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_633
        BRA.W LBL_632
LBL_633:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_634:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_635
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_636
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A8EC  ; UiCopyBits
LBL_636:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_634
LBL_635:
LBL_632:
        UNLK A6
        RTS
        ; func rtUiCanvasBegin  (JT slot 219)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local t : -24(A6)  size 16
        ;   local r : -28(A6)  size 4
LBL_44:
        LINK A6,#-2156
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_638
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_639
LBL_638:
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
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -24(A6),A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_639:
        BSR.W LBL_24
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
        BRA.W LBL_637
LBL_637:
        UNLK A6
        RTS
        ; func rtUiCanvasEnd  (JT slot 220)
        ;   param t : 8(A6)  size 16
LBL_45:
        LINK A6,#-2128
        LEA 8(A6),A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_640:
        UNLK A6
        RTS
        ; func rtUiGrayPatsGet  (JT slot 221)
        ;   local p : -4(A6)  size 4
LBL_46:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -38(A5),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_642
        MOVE.L -38(A5),D0
        BRA.W LBL_641
LBL_642:
        MOVE.L #72,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #17,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #19,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #21,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #23,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #25,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #29,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #30,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #31,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #136,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #33,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #35,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #37,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #170,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #39,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #41,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #42,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #43,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #45,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #46,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #47,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #49,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #51,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #52,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #53,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #54,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #55,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #56,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #57,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #58,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #59,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #60,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #119,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #61,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #62,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #221,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #63,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #64,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #65,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #66,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #67,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #68,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #69,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #70,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #71,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-38(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_641
LBL_641:
        UNLK A6
        RTS
        ; func rtUiCanvasPattern  (JT slot 222)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param level : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local lv : -12(A6)  size 4
LBL_47:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_644
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_644:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_645
        MOVE.L #8,D0
        MOVE.L D0,-12(A6)
LBL_645:
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_643:
        UNLK A6
        RTS
        ; func rtUiCanvasClear  (JT slot 223)
        ;   param instV : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
        ;   local w : -20(A6)  size 4
        ;   local buf : -24(A6)  size 4
        ;   local scratch : -28(A6)  size 4
LBL_48:
        LINK A6,#-2156
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        BRA.W LBL_648
LBL_647:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
LBL_648:
        LEA -16(A6),A0
        ADDA.L #-16,A7
        MOVEA.L A7,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BSR.W LBL_45
        ADDA.W #16,A7
LBL_646:
        UNLK A6
        RTS
        ; func rtUiCanvasLine  (JT slot 224)
        ;   param instV : 28(A6)  size 4
        ;   param wIdx : 24(A6)  size 4
        ;   param x0 : 20(A6)  size 4
        ;   param y0 : 16(A6)  size 4
        ;   param x1 : 12(A6)  size 4
        ;   param y1 : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
LBL_49:
        LINK A6,#-2144
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
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
        ADDA.L #-16,A7
        MOVEA.L A7,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BSR.W LBL_45
        ADDA.W #16,A7
LBL_649:
        UNLK A6
        RTS
        ; func rtUiCanvasRect  (JT slot 225)
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
LBL_50:
        LINK A6,#-2160
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L 30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 26(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L 30(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        BEQ.W LBL_651
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 26(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        BSR.W LBL_46
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
        MOVE.L #8,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8A5  ; UiFillRect
        BRA.W LBL_652
LBL_651:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A1  ; UiFrameRect
LBL_652:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        LEA -16(A6),A0
        ADDA.L #-16,A7
        MOVEA.L A7,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BSR.W LBL_45
        ADDA.W #16,A7
LBL_650:
        UNLK A6
        RTS
        ; func rtUiCanvasFillCircle  (JT slot 226)
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
LBL_51:
        LINK A6,#-2160
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L 24(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        BSR.W LBL_46
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
        MOVE.L #8,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8BB  ; UiFillOval
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        LEA -16(A6),A0
        ADDA.L #-16,A7
        MOVEA.L A7,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BSR.W LBL_45
        ADDA.W #16,A7
LBL_653:
        UNLK A6
        RTS
        ; func rtUiCanvasCircle  (JT slot 227)
        ;   param instV : 24(A6)  size 4
        ;   param wIdx : 20(A6)  size 4
        ;   param x : 16(A6)  size 4
        ;   param y : 12(A6)  size 4
        ;   param radius : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
        ;   local box : -20(A6)  size 4
LBL_52:
        LINK A6,#-2148
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        ADDA.L #-16,A7
        MOVEA.L A7,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BSR.W LBL_45
        ADDA.W #16,A7
LBL_654:
        UNLK A6
        RTS
        ; func rtUiCanvasDrawText  (JT slot 228)
        ;   param instV : 24(A6)  size 4
        ;   param wIdx : 20(A6)  size 4
        ;   param x : 16(A6)  size 4
        ;   param y : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local t : -16(A6)  size 16
LBL_53:
        LINK A6,#-2144
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
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
        ADDA.L #-16,A7
        MOVEA.L A7,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BSR.W LBL_45
        ADDA.W #16,A7
LBL_655:
        UNLK A6
        RTS
        ; func nat_UiTEFromScrap  (JT slot 229)
        ;   local th : -4(A6)  size 4
        ;   local offSlot : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_54:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #2740,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_657
        MOVE.L #102,D0
        NEG.L D0
        BRA.W LBL_656
LBL_657:
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_658
        MOVE.L -12(A6),D0
        BRA.W LBL_656
LBL_658:
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_659
        MOVE.L #32767,D0
        MOVE.L D0,-12(A6)
LBL_659:
        MOVE.L #2736,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L #0,D0
        BRA.W LBL_656
LBL_656:
        UNLK A6
        RTS
        ; func nat_UiTEToScrap  (JT slot 230)
        ;   local th : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
        ;   local err : -12(A6)  size 4
LBL_55:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #2740,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_661
        MOVE.L #0,D0
        BRA.W LBL_660
LBL_661:
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
        BSR.W LBL_56
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
        BRA.W LBL_660
LBL_660:
        UNLK A6
        RTS
        ; func nat_UiTEGetScrapLength  (JT slot 231)
LBL_56:
        LINK A6,#-2128
        MOVE.L #2736,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_662
LBL_662:
        UNLK A6
        RTS
        ; func rtUiTeWidestLine  (JT slot 232)
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
LBL_57:
        LINK A6,#-2180
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #94,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-12(A6)
        BSR.W LBL_24
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #82,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #74,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A887  ; UiTextFont
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A88A  ; UiTextSize
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #76,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A888  ; UiTextFace
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #62,D0
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
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_664:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_665
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #96,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #96,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        BSR.W LBL_182
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_666
        MOVE.L -32(A6),D0
        MOVE.L D0,D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_667
LBL_666:
        MOVE.L #0,D0
LBL_667:
        TST.L D0
        BEQ.W LBL_668
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
LBL_668:
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-44(A6)
LBL_669:
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_670
        MOVE.L -24(A6),D0
        MOVE.L D0,D1
        MOVE.L -44(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,D1
        MOVE.L #1024,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_671
        MOVE.L #1024,D0
        MOVE.L D0,-48(A6)
LBL_671:
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
        MOVE.L -40(A6),D0
        MOVE.L D0,D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_672
        MOVE.L #32767,D0
        MOVE.L D0,-40(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-44(A6)
        BRA.W LBL_673
LBL_672:
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L -48(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-44(A6)
LBL_673:
        BRA.W LBL_669
LBL_670:
        MOVE.L -40(A6),D0
        MOVE.L D0,D1
        MOVE.L -52(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_674
        MOVE.L -40(A6),D0
        MOVE.L D0,-52(A6)
LBL_674:
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_664
LBL_665:
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
        BRA.W LBL_663
LBL_663:
        UNLK A6
        RTS
        ; func rtUiTeScrollSync  (JT slot 233)
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
LBL_58:
        LINK A6,#-2172
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
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_676
        BRA.W LBL_675
LBL_676:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_677
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #94,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_182
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,D1
        MOVE.L -24(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_678
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
LBL_678:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A965  ; UiSetControlMaximum
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,D1
        MOVE.L -32(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_679
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,D1
        MOVE.L -32(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        MOVE.L -32(A6),D0
        MOVE.L D0,-36(A6)
LBL_679:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_677:
        MOVE.L -20(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_680
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #2,D0
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
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_681
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
LBL_681:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A965  ; UiSetControlMaximum
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #8,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,D1
        MOVE.L -32(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_682
        MOVE.L -36(A6),D0
        MOVE.L D0,D1
        MOVE.L -32(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        MOVE.L -32(A6),D0
        MOVE.L D0,-36(A6)
LBL_682:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_680:
LBL_675:
        UNLK A6
        RTS
        ; func rtUiTeClamp  (JT slot 234)
        ;   param te : 12(A6)  size 4
        ;   param maxLen : 8(A6)  size 4
        ;   local teMp : -4(A6)  size 4
        ;   local th : -8(A6)  size 4
        ;   local thMp : -12(A6)  size 4
        ;   local sel : -16(A6)  size 4
LBL_59:
        LINK A6,#-2144
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
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #60,D0
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
        BEQ.W LBL_684
        BRA.W LBL_683
LBL_684:
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #62,D0
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
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #32,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_685
        MOVE.L 8(A6),D0
        MOVE.L D0,-16(A6)
LBL_685:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D1  ; UiTESetSelect
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_63(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_686:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_686
        JSR 42(A5)
        ADDA.W #260,A7
LBL_683:
        UNLK A6
        RTS
LBL_182:
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
LBL_183:
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
        BPL.W LBL_687
        NEG.L D2
        MOVE.L #1,D4
LBL_687:
        CLR.L D5
        TST.L D3
        BPL.W LBL_688
        NEG.L D3
        MOVE.L #1,D5
LBL_688:
        CLR.L D6
        MOVE.W #31,D7
LBL_689:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_690
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_690:
        DBRA D7,LBL_689
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_691
        NEG.L D2
LBL_691:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_184:
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
        BPL.W LBL_692
        NEG.L D2
        MOVE.L #1,D4
LBL_692:
        CLR.L D5
        TST.L D3
        BPL.W LBL_693
        NEG.L D3
        MOVE.L #1,D5
LBL_693:
        CLR.L D6
        MOVE.W #31,D7
LBL_694:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_695
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_695:
        DBRA D7,LBL_694
        TST.L D4
        BEQ.W LBL_696
        NEG.L D6
LBL_696:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_185:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
LBL_697:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_60:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_61:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_62:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_63:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_64:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_65:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_66:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_67:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_68:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_69:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_70:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_71:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_72:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_73:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_74:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_75:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_76:
        DC.B $01
        DC.B $2D
LBL_77:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_78:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_79:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_80:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_81:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_82:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_83:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
LBL_84:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_85:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_86:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_87:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_88:
        DC.B $03
        DC.B $6B,$65,$79
LBL_89:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_90:
        DC.B $01
        DC.B $78
LBL_91:
        DC.B $01
        DC.B $3F
LBL_92:
        DC.B $06
        DC.B $73,$65,$6C,$65,$63,$74
        DC.B $00
LBL_93:
        DC.B $0B
        DC.B $64,$6F,$75,$62,$6C,$65,$43,$6C,$69,$63,$6B
LBL_94:
        DC.B $78
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$66,$6F,$75,$6E,$64,$20,$6E,$6F,$20,$6D,$65,$6E,$75,$20,$69,$6E,$20,$74,$68,$65,$20,$6D,$65,$6E,$75,$20,$6C,$69,$73,$74,$20,$66,$6F,$72,$20,$74,$68,$69,$73,$20,$77,$69,$64,$67,$65,$74,$20,$28,$63,$6C,$6F,$73,$65,$2F,$72,$65,$6F,$70,$65,$6E,$20,$6C,$65,$66,$74,$20,$69,$74,$20,$75,$6E,$64,$65,$6C,$65,$74,$65,$64,$20,$6F,$72,$20,$6E,$65,$76,$65,$72,$20,$72,$65,$69,$6E,$73,$65,$72,$74,$65,$64,$29
        DC.B $00
LBL_95:
        DC.B $71
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$72,$65,$74,$75,$72,$6E,$65,$64,$20,$61,$20,$6D,$65,$6E,$75,$20,$68,$61,$6E,$64,$6C,$65,$20,$74,$68,$61,$74,$20,$69,$73,$6E,$27,$74,$20,$74,$68,$69,$73,$20,$69,$6E,$73,$74,$61,$6E,$63,$65,$27,$73,$20,$6F,$77,$6E,$20,$28,$73,$74,$61,$6C,$65,$2F,$6C,$65,$61,$6B,$65,$64,$20,$65,$6E,$74,$72,$79,$20,$75,$6E,$64,$65,$72,$20,$74,$68,$65,$20,$73,$61,$6D,$65,$20,$49,$44,$29
LBL_96:
        DC.B $57
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$6D,$65,$6E,$75,$20,$69,$74,$65,$6D,$20,$63,$6F,$75,$6E,$74,$20,$64,$6F,$65,$73,$6E,$27,$74,$20,$6D,$61,$74,$63,$68,$20,$74,$68,$65,$20,$62,$6F,$75,$6E,$64,$20,$65,$6E,$75,$6D,$20,$28,$72,$65,$62,$75,$69,$6C,$74,$20,$77,$69,$74,$68,$20,$73,$74,$61,$6C,$65,$2F,$6C,$65,$66,$74,$6F,$76,$65,$72,$20,$69,$74,$65,$6D,$73,$29
LBL_97:
        DC.B $24
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_98:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$61,$6E,$73,$77,$65,$72,$20,$71,$75,$65,$75,$65,$20,$6F,$76,$65,$72,$66,$6C,$6F,$77
LBL_99:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$77,$69,$74,$68,$20,$6E,$6F,$20,$71,$75,$65,$75,$65,$64,$20,$61,$6E,$73,$77,$65,$72
LBL_100:
        DC.B $07
        DC.B $54,$20,$4F,$50,$45,$4E,$20
LBL_101:
        DC.B $01
        DC.B $20
LBL_102:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_103:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_104:
        DC.B $01
        DC.B $2E
LBL_105:
        DC.B $07
        DC.B $2E,$73,$65,$6C,$65,$63,$74
LBL_106:
        DC.B $0D
        DC.B $54,$20,$46,$49,$52,$45,$20,$65,$76,$65,$72,$79,$2E
LBL_107:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_108:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_109:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_110:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_111:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_112:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_113:
        DC.B $08
        DC.B $54,$20,$41,$42,$4F,$55,$54,$20
        DC.B $00
LBL_114:
        DC.B $01
        DC.B $7C
LBL_115:
        DC.B $07
        DC.B $63,$61,$70,$74,$69,$6F,$6E
LBL_116:
        DC.B $04
        DC.B $74,$65,$78,$74
        DC.B $00
LBL_117:
        DC.B $07
        DC.B $65,$6E,$61,$62,$6C,$65,$64
LBL_118:
        DC.B $07
        DC.B $63,$68,$65,$63,$6B,$65,$64
LBL_119:
        DC.B $08
        DC.B $73,$65,$6C,$65,$63,$74,$65,$64
        DC.B $00
LBL_120:
        DC.B $05
        DC.B $77,$69,$64,$74,$68
LBL_121:
        DC.B $06
        DC.B $68,$65,$69,$67,$68,$74
        DC.B $00
LBL_122:
        DC.B $06
        DC.B $54,$20,$53,$45,$54,$20
        DC.B $00
LBL_123:
        DC.B $09
        DC.B $2E,$69,$6E,$76,$61,$6C,$69,$64,$2E
LBL_124:
        DC.B $02
        DC.B $54,$20
        DC.B $00
LBL_125:
        DC.B $0A
        DC.B $54,$20,$4F,$50,$45,$4E,$44,$4F,$43,$20
        DC.B $00
LBL_126:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_127:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_128:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_129:
        DC.B $37
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$73,$61,$76,$65,$7C,$64,$69,$73,$63,$61,$72,$64,$7C,$63,$61,$6E,$63,$65,$6C,$29
LBL_130:
        DC.B $23
        DC.B $73,$6E,$61,$70,$3A,$20,$73,$63,$72,$65,$65,$6E,$42,$69,$74,$73,$2E,$72,$6F,$77,$42,$79,$74,$65,$73,$20,$69,$73,$20,$6E,$6F,$74,$20,$36,$34
LBL_131:
        DC.B $10
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$23,$23,$20
        DC.B $00
LBL_132:
        DC.B $13
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$2D,$45,$4E,$44,$23,$23
LBL_133:
        DC.B $2C
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$6B,$6E,$6F,$77,$6E,$20,$6F,$72,$20,$75,$6E,$73,$75,$70,$70,$6F,$72,$74,$65,$64,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$76,$65,$72,$62
        DC.B $00
LBL_134:
        DC.B $08
        DC.B $64,$62,$6C,$63,$6C,$69,$63,$6B
        DC.B $00
LBL_135:
        DC.B $04
        DC.B $74,$79,$70,$65
        DC.B $00
LBL_136:
        DC.B $04
        DC.B $6D,$65,$6E,$75
        DC.B $00
LBL_137:
        DC.B $05
        DC.B $63,$6C,$6F,$73,$65
LBL_138:
        DC.B $06
        DC.B $72,$65,$73,$69,$7A,$65
        DC.B $00
LBL_139:
        DC.B $04
        DC.B $7A,$6F,$6F,$6D
        DC.B $00
LBL_140:
        DC.B $04
        DC.B $74,$69,$63,$6B
        DC.B $00
LBL_141:
        DC.B $04
        DC.B $73,$6E,$61,$70
        DC.B $00
LBL_142:
        DC.B $04
        DC.B $71,$75,$69,$74
        DC.B $00
LBL_143:
        DC.B $09
        DC.B $6C,$61,$75,$6E,$63,$68,$64,$6F,$63
LBL_144:
        DC.B $0C
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$70,$6F,$70,$75,$70
        DC.B $00
LBL_145:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$6F,$70,$65,$6E
LBL_146:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$73,$61,$76,$65
LBL_147:
        DC.B $0E
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73
        DC.B $00
LBL_148:
        DC.B $0D
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$61,$6E,$63,$65,$6C
LBL_149:
        DC.B $2A
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$6D,$75,$73,$74,$20,$68,$61,$76,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$65,$6E,$74,$72,$69,$65,$73
        DC.B $00
LBL_150:
        DC.B $31
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$65,$6E,$74,$72,$79,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_151:
        DC.B $00
        DC.B $00
LBL_152:
        DC.B $08
        DC.B $53,$61,$76,$65,$20,$61,$73,$3A
        DC.B $00
LBL_153:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_154:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_155:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_156:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_157:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_158:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_159:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_160:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_161:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_162:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_163:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_164:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_165:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_166:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_167:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_168:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_169:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_170:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_171:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_172:
        DC.B $2B
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$64,$67,$65,$74,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_173:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_174:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_175:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_176:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_177:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_178:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_181:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (168 bytes)
LBL_179:
        DC.B $43
        DC.B $4C
        DC.B $55
        DC.B $49
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $2C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $90
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $90
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $90
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $9A
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $9F
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $C8
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $C8
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $5C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $08
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $02
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $94
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $04
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $05
        DC.B $42
        DC.B $6F
        DC.B $61
        DC.B $72
        DC.B $64
        DC.B $04
        DC.B $47
        DC.B $61
        DC.B $6D
        DC.B $65
        DC.B $06
        DC.B $42
        DC.B $6F
        DC.B $75
        DC.B $6E
        DC.B $63
        DC.B $65
        DC.B $00
        DC.B $00
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_180:
        DC.B $00
        DC.B $00
