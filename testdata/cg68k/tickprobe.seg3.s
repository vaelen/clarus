        ; func rtUiTeScrollSync  (JT slot 237)
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
LBL_0:
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
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_217
        BRA.W LBL_216
LBL_217:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_218
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #94,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_219
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
LBL_219:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A965  ; UiSetControlMaximum
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_220
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        MOVE.L -32(A6),D0
        MOVE.L D0,-36(A6)
LBL_220:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_218:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_221
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
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
        JSR 1858(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_222
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
LBL_222:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A965  ; UiSetControlMaximum
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_223
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
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
LBL_223:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_221:
LBL_216:
        UNLK A6
        RTS
        ; func rtUiTeMutated  (JT slot 238)
        ;   param inst : 14(A6)  size 4
        ;   param wIdx : 10(A6)  size 4
        ;   param userEdit : 8(A6)  size 2
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local te : -12(A6)  size 4
        ;   local cap : -16(A6)  size 4
LBL_1:
        LINK A6,#-2144
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
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
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_225
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_226
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 1874(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_227
LBL_226:
        MOVE.L #32000,D0
        MOVE.L D0,-16(A6)
LBL_227:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1866(A5)
        ADDQ.L #8,A7
LBL_225:
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        CLR.L D0
        MOVE.B 8(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_228
        BRA.W LBL_224
LBL_228:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_229:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_229
        BSR.W LBL_47
        ADDA.W #264,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 2994(A5)
        ADDA.W #24,A7
LBL_224:
        UNLK A6
        RTS
        ; func rtUiTeRelayout  (JT slot 239)
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
LBL_2:
        LINK A6,#-2236
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
        MOVE.B D0,-32(A6)
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
        MOVE.B D0,-82(A6)
        MOVE.L #0,D0
        MOVE.B D0,-84(A6)
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
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_231
        BRA.W LBL_230
LBL_231:
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 626(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-26(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 618(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_234
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_235
LBL_234:
        MOVE.L #0,D0
LBL_235:
        TST.L D0
        BEQ.W LBL_232
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BNE.W LBL_236
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_237
LBL_236:
        MOVE.L #1,D0
LBL_237:
        BRA.W LBL_233
LBL_232:
        MOVE.L #0,D0
LBL_233:
        TST.L D0
        BEQ.W LBL_238
        MOVE.L #1,D0
        MOVE.B D0,-30(A6)
LBL_238:
        MOVE.L #0,D0
        MOVE.B D0,-32(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_241
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_242
LBL_241:
        MOVE.L #0,D0
LBL_242:
        TST.L D0
        BEQ.W LBL_239
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_240
LBL_239:
        MOVE.L #0,D0
LBL_240:
        TST.L D0
        BEQ.W LBL_243
        MOVE.L #1,D0
        MOVE.B D0,-32(A6)
LBL_243:
        MOVE.L #15,D0
        MOVE.L D0,-36(A6)
        CLR.L D0
        MOVE.B -30(A6),D0
        TST.L D0
        BEQ.W LBL_244
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_244:
        MOVE.L #15,D0
        MOVE.L D0,-40(A6)
        CLR.L D0
        MOVE.B -32(A6),D0
        TST.L D0
        BEQ.W LBL_245
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
LBL_245:
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-44(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
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
        JSR 1530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-56(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-64(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-60(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_246
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1538(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_247
LBL_246:
        MOVE.L #0,D0
LBL_247:
        TST.L D0
        BEQ.W LBL_248
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #70,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
LBL_248:
        MOVE.L -52(A6),D0
        MOVE.L D0,-68(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,-72(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,-76(A6)
        MOVE.L -64(A6),D0
        MOVE.L D0,-80(A6)
        MOVE.L #0,D0
        MOVE.L D0,-108(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_249
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-104(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-108(A6)
        MOVE.L -104(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-82(A6)
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-84(A6)
        CLR.L D0
        MOVE.B -82(A6),D0
        TST.L D0
        BEQ.W LBL_250
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_251
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_252
LBL_251:
        MOVE.L -56(A6),D0
        MOVE.L D0,-88(A6)
LBL_252:
        MOVE.L -64(A6),D0
        MOVE.L D0,-96(A6)
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_253
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-96(A6)
LBL_253:
        MOVE.L -104(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
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
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -88(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A95C  ; UiSizeControl
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-76(A6)
LBL_250:
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_254
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-92(A6)
        BRA.W LBL_256
LBL_255:
        MOVE.L -52(A6),D0
        MOVE.L D0,-92(A6)
LBL_256:
        MOVE.L -60(A6),D0
        MOVE.L D0,-100(A6)
        CLR.L D0
        MOVE.B -82(A6),D0
        TST.L D0
        BEQ.W LBL_257
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-100(A6)
LBL_257:
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A959  ; UiMoveControl
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A95C  ; UiSizeControl
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-80(A6)
LBL_254:
LBL_249:
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-68(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-72(A6)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-76(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-80(A6)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_258
        MOVE.L -68(A6),D0
        MOVE.L D0,-76(A6)
LBL_258:
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_259
        MOVE.L -72(A6),D0
        MOVE.L D0,-80(A6)
LBL_259:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_260
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_261
LBL_260:
        MOVE.L #0,D0
LBL_261:
        TST.L D0
        BEQ.W LBL_262
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2000,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_262:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
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
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
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
LBL_230:
        UNLK A6
        RTS
        ; func rtUiTeSetFocus  (JT slot 240)
        ;   param inst : 12(A6)  size 4
        ;   param newIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local te : -8(A6)  size 4
LBL_3:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_264
        BRA.W LBL_263
LBL_264:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_265
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_266
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D9  ; UiTEDeactivate
LBL_266:
LBL_265:
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
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D8  ; UiTEActivate
LBL_268:
LBL_267:
        JSR 1290(A5)
LBL_263:
        UNLK A6
        RTS
        ; func rtUiTeHit  (JT slot 241)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local te : -20(A6)  size 4
LBL_4:
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_270:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_271
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_272
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_273
LBL_272:
        MOVE.L #1,D0
LBL_273:
        TST.L D0
        BEQ.W LBL_274
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_275
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_276
LBL_275:
        MOVE.L #0,D0
LBL_276:
        TST.L D0
        BEQ.W LBL_277
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        BRA.W LBL_269
LBL_277:
LBL_274:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_270
LBL_271:
        MOVE.L #0,D0
        BRA.W LBL_269
LBL_269:
        UNLK A6
        RTS
        ; func rtUiScrollbarAction  (JT slot 242)
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
LBL_5:
        LINK A6,#-2190
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
        MOVE.L D0,-22(A6)
        MOVE.L #0,D0
        MOVE.L D0,-26(A6)
        MOVE.L #0,D0
        MOVE.L D0,-30(A6)
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_279
        BRA.W LBL_278
LBL_279:
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_280
        BRA.W LBL_278
LBL_280:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16384,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-18(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16383,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        BRA.W LBL_278
LBL_281:
        MOVE.L -26(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-30(A6)
        MOVE.L #0,D0
        MOVE.L D0,-34(A6)
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_282
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-38(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_284
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_285
LBL_284:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #21,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_286
        MOVE.L #8,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_287
LBL_286:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_288
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -38(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_289
LBL_288:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #23,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_290
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_291
LBL_290:
        BRA.W LBL_278
LBL_291:
LBL_289:
LBL_287:
LBL_285:
        BRA.W LBL_283
LBL_282:
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-42(A6)
        MOVE.L -42(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_292
        MOVE.L #1,D0
        MOVE.L D0,-42(A6)
LBL_292:
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-46(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_293
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -42(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_294
LBL_293:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #21,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_295
        MOVE.L -42(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_296
LBL_295:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_297
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -46(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_298
LBL_297:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #23,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_299
        MOVE.L -46(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_300
LBL_299:
        BRA.W LBL_278
LBL_300:
LBL_298:
LBL_296:
LBL_294:
LBL_283:
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
        MOVE.L -50(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -34(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-54(A6)
        MOVE.L -54(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_301
        MOVE.L #0,D0
        MOVE.L D0,-54(A6)
LBL_301:
        MOVE.L -54(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        MOVE.L -58(A6),D0
        MOVE.L D0,-54(A6)
LBL_302:
        MOVE.L -50(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-62(A6)
        MOVE.L -62(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_303
        BRA.W LBL_278
LBL_303:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_304
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_305
LBL_304:
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_305:
LBL_278:
        UNLK A6
        RTS
        ; func rtUiHandleScrollbarClick  (JT slot 243)
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
LBL_6:
        LINK A6,#-2146
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_307
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_312
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #21,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_313
LBL_312:
        MOVE.L #1,D0
LBL_313:
        TST.L D0
        BNE.W LBL_310
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_311
LBL_310:
        MOVE.L #1,D0
LBL_311:
        TST.L D0
        BNE.W LBL_308
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #23,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_309
LBL_308:
        MOVE.L #1,D0
LBL_309:
        TST.L D0
        BEQ.W LBL_314
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
LBL_314:
        BRA.W LBL_306
LBL_307:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #129,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_315
        MOVE.L 20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #16384,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
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
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_317
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
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_319
LBL_318:
        MOVE.L #0,D0
LBL_319:
        TST.L D0
        BEQ.W LBL_320
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_321
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_322
LBL_321:
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_322:
LBL_320:
LBL_317:
        BRA.W LBL_316
LBL_315:
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA 3034(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
LBL_316:
LBL_306:
        UNLK A6
        RTS
        ; func rtUiTeIdleFront  (JT slot 244)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local te : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
LBL_7:
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
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_324
        BRA.W LBL_323
LBL_324:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
        BRA.W LBL_323
LBL_325:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_326
        BRA.W LBL_323
LBL_326:
        JSR 1602(A5)
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
LBL_323:
        UNLK A6
        RTS
        ; func rtUiStdEditPaste  (JT slot 245)
        ;   param inst : 12(A6)  size 4
        ;   param te : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local teMp : -8(A6)  size 4
        ;   local newLen : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
LBL_8:
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
        MOVE.L D0,-4(A6)
        JSR 1834(A5)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #60,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
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
        JSR 1850(A5)
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
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_328
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32000,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_329
LBL_328:
        MOVE.L #0,D0
LBL_329:
        TST.L D0
        BEQ.W LBL_330
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_99(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_332:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_332
        JSR 42(A5)
        ADDA.W #260,A7
        BRA.W LBL_331
LBL_330:
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
        MOVE.L #1,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_1
        ADDA.W #10,A7
LBL_331:
LBL_327:
        UNLK A6
        RTS
        ; func rtUiSetPopupAt  (JT slot 246)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_9:
        LINK A6,#-2128
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_333:
        UNLK A6
        RTS
        ; func rtUiPopupSelAt  (JT slot 247)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_10:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 104(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_334
LBL_334:
        UNLK A6
        RTS
        ; func rtUiSetPopupSelAt  (JT slot 248)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_11:
        LINK A6,#-2128
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 104(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_335:
        UNLK A6
        RTS
        ; func rtUiPopupBoxInto  (JT slot 249)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_12:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1538(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_337
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #70,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_337:
LBL_336:
        UNLK A6
        RTS
        ; func rtUiTableFillWidth  (JT slot 250)
        ;   param colsOff : 16(A6)  size 4
        ;   param nCols : 12(A6)  size 4
        ;   param totalW : 8(A6)  size 4
        ;   local fixedSum : -4(A6)  size 4
        ;   local k : -8(A6)  size 4
        ;   local fillW : -12(A6)  size 4
LBL_13:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_339:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_340
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 994(A5)
        ADDQ.L #8,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_341
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 986(A5)
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_341:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_339
LBL_340:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_342
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_342:
        MOVE.L -12(A6),D0
        BRA.W LBL_338
LBL_338:
        UNLK A6
        RTS
        ; func rtUiFixedToStr  (JT slot 251)
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
LBL_14:
        LINK A6,#-2158
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
        MOVE.L #0,D0
        MOVE.L D0,-22(A6)
        MOVE.L #0,D0
        MOVE.L D0,-26(A6)
        MOVE.L #0,D0
        MOVE.L D0,-30(A6)
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
        BEQ.W LBL_344
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_345
LBL_344:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6(A6)
LBL_345:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-14(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        MOVE.L (A7)+,D0
        DC.W $A9EE  ; UiNumToString
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65535,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10000,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L D0,-(A7)
        MOVE.L #65536,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_213
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        MOVE.L (A7)+,D0
        DC.W $A9EE  ; UiNumToString
        MOVE.L #0,D0
        MOVE.L D0,-22(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_346:
        MOVE.L #0,D0
        MOVE.L D0,-26(A6)
LBL_347:
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
        BEQ.W LBL_348
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-26(A6)
        BRA.W LBL_347
LBL_348:
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #46,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-30(A6)
        MOVE.L #0,D0
        MOVE.L D0,-26(A6)
LBL_349:
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_350
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-26(A6)
        BRA.W LBL_349
LBL_350:
        MOVE.L #0,D0
        MOVE.L D0,-26(A6)
LBL_351:
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
        BEQ.W LBL_352
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-26(A6)
        BRA.W LBL_351
LBL_352:
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
LBL_343:
        UNLK A6
        RTS
        ; func rtUiTableDrawField  (JT slot 252)
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
LBL_15:
        LINK A6,#-2170
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
        MOVE.B D0,-42(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1034(A5)
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1026(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_354
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        BRA.W LBL_355
LBL_354:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_356
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        MOVE.L (A7)+,D0
        DC.W $A9EE  ; UiNumToString
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
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
        BRA.W LBL_357
LBL_356:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
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
        BRA.W LBL_359
LBL_358:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #195,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_362:
        BRA.W LBL_361
LBL_360:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_363
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_364
LBL_363:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_365
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1050(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1058(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1066(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.B D0,-42(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
LBL_366:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_367
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1090(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_368
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L #1,D0
        MOVE.B D0,-42(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_369
LBL_368:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_369:
        BRA.W LBL_366
LBL_367:
        CLR.L D0
        MOVE.B -42(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_370
        LEA LBL_127(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
LBL_370:
LBL_365:
LBL_364:
LBL_361:
LBL_359:
LBL_357:
LBL_355:
LBL_353:
        UNLK A6
        RTS
        ; func rtUiTableRowH  (JT slot 253)
        ;   local fi : -4(A6)  size 4
        ;   local h : -8(A6)  size 4
LBL_16:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A88B  ; UiGetFontInfo
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
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
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_372
        MOVE.L -8(A6),D0
        BRA.W LBL_371
LBL_372:
        MOVE.L #1,D0
        BRA.W LBL_371
LBL_371:
        UNLK A6
        RTS
        ; func rtUiMakeLdefStub  (JT slot 254)
        ;   local h : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local addr : -12(A6)  size 4
LBL_17:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #6,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A322  ; UiNewHandleClear
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
        BEQ.W LBL_374
        LEA LBL_102(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_375:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_375
        JSR 50(A5)
        ADDA.W #256,A7
LBL_374:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #20217,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA 3042(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 1882(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1226(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1234(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_373
LBL_373:
        UNLK A6
        RTS
        ; func rtUiLdefDraw  (JT slot 255)
        ;   param msg : 30(A6)  size 4
        ;   param select : 28(A6)  size 2
        ;   param rectPtr : 24(A6)  size 4
        ;   param cellPacked : 20(A6)  size 4
        ;   param dataOffset : 16(A6)  size 4
        ;   param dataLen : 12(A6)  size 4
        ;   param lh : 8(A6)  size 4
        ;   local lhMp : -4(A6)  size 4
        ;   local tableOff : -8(A6)  size 4
        ;   local rowsIdx : -12(A6)  size 4
        ;   local layoutOff : -16(A6)  size 4
        ;   local nCols : -20(A6)  size 4
        ;   local colsOff : -24(A6)  size 4
        ;   local rowsAddr : -28(A6)  size 4
        ;   local rows : -32(A6)  size 4
        ;   local count : -36(A6)  size 4
        ;   local row : -40(A6)  size 4
        ;   local rec : -44(A6)  size 4
        ;   local fillW : -48(A6)  size 4
        ;   local x : -52(A6)  size 4
        ;   local k : -56(A6)  size 4
        ;   local w : -60(A6)  size 4
        ;   local colRect : -64(A6)  size 4
        ;   local saveClip : -68(A6)  size 4
LBL_18:
        LINK A6,#-2196
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
        MOVE.L 30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_377
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #60,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 930(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 938(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 946(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 954(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3026(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        JSR 1226(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_379
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_380
LBL_379:
        MOVE.L #0,D0
LBL_380:
        TST.L D0
        BEQ.W LBL_381
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #12,A7
        MOVE.L D0,-48(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L #0,D0
        MOVE.L D0,-56(A6)
LBL_382:
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_383
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 994(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_384
        MOVE.L -48(A6),D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_385
LBL_384:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 986(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
LBL_385:
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-64(A6)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        CLR.L -(A7)
        DC.W $A8D8  ; UiNewRgn
        MOVE.L (A7)+,D0
        MOVE.L D0,-68(A6)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87A  ; UiGetClip
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87B  ; UiClipRect
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1002(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #16,A7
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A879  ; UiSetClip
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8D9  ; UiDisposeRgn
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-56(A6)
        BRA.W LBL_382
LBL_383:
LBL_381:
        CLR.L D0
        MOVE.B 28(A6),D0
        TST.L D0
        BEQ.W LBL_386
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_386:
        BRA.W LBL_378
LBL_377:
        MOVE.L 30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_387
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_387:
LBL_378:
LBL_376:
        UNLK A6
        RTS
        ; func rtUiTableRelayout  (JT slot 256)
        ;   param inst : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local lh : -8(A6)  size 4
        ;   local lhMp : -12(A6)  size 4
        ;   local box : -16(A6)  size 4
        ;   local listRect : -20(A6)  size 4
        ;   local headerH : -24(A6)  size 4
        ;   local cellW : -28(A6)  size 4
LBL_19:
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1890(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_389
        BRA.W LBL_388
LBL_389:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        JSR 1914(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_390:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A8A9  ; UiInsetRect
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_391
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_391:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_392
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_392:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_393
        MOVE.L #1,D0
        MOVE.L D0,-28(A6)
LBL_393:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -28(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #96,-(A7)
        DC.W $A9E7  ; UiLSize
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_388:
        UNLK A6
        RTS
        ; func rtUiTableGetSelected  (JT slot 257)
        ;   param lh : 8(A6)  size 4
        ;   local lhMp : -4(A6)  size 4
        ;   local count : -8(A6)  size 4
        ;   local row : -12(A6)  size 4
        ;   local cell : -16(A6)  size 4
        ;   local found : -20(A6)  size 4
LBL_20:
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
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_395:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_396
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        CLR.W -(A7)
        MOVE.L #0,D0
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
        BEQ.W LBL_397
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_398
LBL_397:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
LBL_398:
        BRA.W LBL_395
LBL_396:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        BRA.W LBL_394
LBL_394:
        UNLK A6
        RTS
        ; func rtUiTableSelectExclusive  (JT slot 258)
        ;   param lh : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local cur : -4(A6)  size 4
LBL_21:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVE.L #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #92,-(A7)
        DC.W $A9E7  ; UiLSetSelect
LBL_400:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #92,-(A7)
        DC.W $A9E7  ; UiLSetSelect
LBL_401:
LBL_399:
        UNLK A6
        RTS
        ; func rtUiTableHit  (JT slot 259)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local lh : -16(A6)  size 4
LBL_22:
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
        MOVE.L D0,-(A7)
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_403:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_404
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_405
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1890(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_407
LBL_406:
        MOVE.L #0,D0
LBL_407:
        TST.L D0
        BEQ.W LBL_408
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        BRA.W LBL_402
LBL_408:
LBL_405:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_403
LBL_404:
        MOVE.L #0,D0
        BRA.W LBL_402
LBL_402:
        UNLK A6
        RTS
        ; func rtUiTableFireSelect  (JT slot 260)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_23:
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
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_128(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_410:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_410
        BSR.W LBL_47
        ADDA.W #264,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 2994(A5)
        ADDA.W #24,A7
LBL_409:
        UNLK A6
        RTS
        ; func rtUiTableFireDblclick  (JT slot 261)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_24:
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
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_412:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_412
        BSR.W LBL_47
        ADDA.W #264,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 2994(A5)
        ADDA.W #24,A7
LBL_411:
        UNLK A6
        RTS
        ; func rtUiTableClick  (JT slot 262)
        ;   param inst : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param mods : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local lh : -8(A6)  size 4
        ;   local lhMp : -12(A6)  size 4
        ;   local row : -16(A6)  size 4
        ;   local dbl : -18(A6)  size 2
LBL_25:
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
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1890(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_414
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1226(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_213
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_415:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #8,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDA.W #12,A7
        CLR.L D0
        MOVE.B -42(A5),D0
        TST.L D0
        BEQ.W LBL_416
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDA.W #12,A7
LBL_416:
        BRA.W LBL_413
LBL_414:
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #24,-(A7)
        DC.W $A9E7  ; UiLClick
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-18(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDA.W #12,A7
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_417
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDA.W #12,A7
LBL_417:
LBL_413:
        UNLK A6
        RTS
        ; func rtUiTableSyncOne  (JT slot 263)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local lh : -8(A6)  size 4
        ;   local lhMp : -12(A6)  size 4
        ;   local tableOff : -16(A6)  size 4
        ;   local rowsIdx : -20(A6)  size 4
        ;   local rowsAddr : -24(A6)  size 4
        ;   local rows : -28(A6)  size 4
        ;   local dataCount : -32(A6)  size 4
        ;   local lmCount : -36(A6)  size 4
        ;   local savedPort : -40(A6)  size 4
LBL_26:
        LINK A6,#-2168
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1890(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        BRA.W LBL_418
LBL_419:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 634(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 930(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 3026(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-32(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-36(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_420
        BRA.W LBL_418
LBL_420:
        JSR 1602(A5)
        MOVE.L D0,-40(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        CLR.W -(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #8,-(A7)
        DC.W $A9E7  ; UiLAddRow
        MOVE.W (A7)+,D0
        EXT.L D0
        BRA.W LBL_422
LBL_421:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #36,-(A7)
        DC.W $A9E7  ; UiLDelRow
LBL_422:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_418:
        UNLK A6
        RTS
        ; func rtUiTablesSync  (JT slot 264)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local i : -20(A6)  size 4
LBL_27:
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
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
LBL_424:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #108,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #2001,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
LBL_427:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
LBL_429:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_427
LBL_428:
LBL_426:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #144,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_424
LBL_425:
LBL_423:
        UNLK A6
        RTS
        ; func rtUiPopupHit  (JT slot 265)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_28:
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
        JSR 490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_431:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_436
LBL_435:
        MOVE.L #0,D0
LBL_436:
        TST.L D0
        BEQ.W LBL_433
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_434
LBL_433:
        MOVE.L #0,D0
LBL_434:
        TST.L D0
        BEQ.W LBL_437
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        BRA.W LBL_430
LBL_437:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_431
LBL_432:
        MOVE.L #0,D0
        BRA.W LBL_430
LBL_430:
        UNLK A6
        RTS
        ; func rtUiPopupAssertAlive  (JT slot 266)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local mh : -8(A6)  size 4
        ;   local formOff : -12(A6)  size 4
        ;   local fieldIndex : -16(A6)  size 4
        ;   local expect : -20(A6)  size 4
LBL_29:
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
        MOVE.L D0,-4(A6)
        CLR.L -(A7)
        MOVE.L #1000,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A949  ; UiGetMenuHandle
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
        LEA LBL_130(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_440:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_440
        JSR 50(A5)
        ADDA.W #256,A7
LBL_439:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1906(A5)
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        LEA LBL_131(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_442:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_442
        JSR 50(A5)
        ADDA.W #256,A7
LBL_441:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 514(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_443
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 922(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_444
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 874(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1050(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
LBL_444:
LBL_443:
        CLR.W -(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A950  ; UiCountMItems
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        LEA LBL_132(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_446:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_446
        JSR 50(A5)
        ADDA.W #256,A7
LBL_445:
LBL_438:
        UNLK A6
        RTS
        ; func rtUiPopupPick  (JT slot 267)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param newIndex : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_30:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_448
        BRA.W LBL_447
LBL_448:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_449:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_449
        BSR.W LBL_47
        ADDA.W #264,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 2994(A5)
        ADDA.W #24,A7
LBL_447:
        UNLK A6
        RTS
        ; func rtUiPopupClick  (JT slot 268)
        ;   param inst : 12(A6)  size 4
        ;   param pIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local box : -8(A6)  size 4
        ;   local anchor : -12(A6)  size 4
        ;   local result : -16(A6)  size 4
        ;   local newItem : -20(A6)  size 4
        ;   local kindSlot : -24(A6)  size 4
        ;   local valSlot : -28(A6)  size 4
LBL_31:
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
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_451
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #8,A7
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_452
        LEA LBL_133(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_453:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_453
        JSR 50(A5)
        ADDA.W #256,A7
LBL_452:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_450
LBL_451:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDA.W #12,A7
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A870  ; UiLocalToGlobal
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1906(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A80B  ; UiPopUpMenuSelect
        MOVE.L (A7)+,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1234(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
LBL_454:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_450:
        UNLK A6
        RTS
        ; func rtUiAnswerInit  (JT slot 269)
LBL_32:
        LINK A6,#-2128
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_456
        MOVE.L #32,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-46(A5)
        MOVE.L #32,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-50(A5)
        MOVE.L #2048,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-54(A5)
LBL_456:
LBL_455:
        UNLK A6
        RTS
        ; func rtUiAnswerCheckRoom  (JT slot 270)
LBL_33:
        LINK A6,#-2128
        BSR.W LBL_32
        MOVE.L -62(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_214
        MOVE.L D0,-(A7)
        MOVE.L -58(A5),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_458
        LEA LBL_134(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_459:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_459
        JSR 50(A5)
        ADDA.W #256,A7
LBL_458:
LBL_457:
        UNLK A6
        RTS
        ; func rtUiAnswerPushVal  (JT slot 271)
        ;   param kind : 12(A6)  size 4
        ;   param val : 8(A6)  size 4
LBL_34:
        LINK A6,#-2128
        BSR.W LBL_33
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -50(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -62(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_214
        MOVE.L D0,-62(A5)
LBL_460:
        UNLK A6
        RTS
        ; func rtUiAnswerPushPath  (JT slot 272)
        ;   param kind : 12(A6)  size 4
        ;   param srcC : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local dst : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_35:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        BSR.W LBL_33
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_462:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_462
LBL_463:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_464
        MOVE.L #255,D0
        MOVE.L D0,-4(A6)
LBL_464:
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -54(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_465:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_466
        MOVE.L -8(A6),D0
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
        BRA.W LBL_465
LBL_466:
        MOVE.L -62(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_214
        MOVE.L D0,-62(A5)
LBL_461:
        UNLK A6
        RTS
        ; func rtUiAnswerPopIdx  (JT slot 273)
        ;   local idx : -4(A6)  size 4
LBL_36:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_32
        MOVE.L -58(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A5),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_468
        LEA LBL_135(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_469:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_469
        JSR 50(A5)
        ADDA.W #256,A7
LBL_468:
        MOVE.L -58(A5),D0
        MOVE.L D0,-4(A6)
        MOVE.L -58(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_214
        MOVE.L D0,-58(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_467
LBL_467:
        UNLK A6
        RTS
        ; func rtUiAnswerPop  (JT slot 274)
        ;   param outKind : 12(A6)  size 4
        ;   param outVal : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_37:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_36
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -50(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_470:
        UNLK A6
        RTS
        ; func rtUiTextAppendStrSafe  (JT slot 275)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_38:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_472
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
LBL_472:
LBL_471:
        UNLK A6
        RTS
        ; func rtUiIntToText  (JT slot 276)
        ;   param v : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local digits : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local d : -22(A6)  size 4
LBL_39:
        LINK A6,#-2150
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.B D0,-10(A6)
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L #0,D0
        MOVE.L D0,-22(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_474
        MOVE.L -8(A6),D0
        NEG.L D0
        MOVE.L D0,-8(A6)
LBL_474:
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-14(A6)
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_476
LBL_475:
LBL_477:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_478
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_214
        MOVE.L D0,-22(A6)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -18(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_213
        MOVE.L D0,-8(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_477
LBL_478:
LBL_476:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_479
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
LBL_479:
LBL_480:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -18(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        BRA.W LBL_480
LBL_481:
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        BRA.W LBL_473
LBL_473:
        UNLK A6
        RTS
        ; func rtUiTextAppendInt  (JT slot 277)
        ;   param t : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local nt : -4(A6)  size 4
LBL_40:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 114(A5)
        ADDQ.L #4,A7
LBL_482:
        UNLK A6
        RTS
        ; func rtUiEmitLine  (JT slot 278)
        ;   param t : 8(A6)  size 4
LBL_41:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2922(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 114(A5)
        ADDQ.L #4,A7
LBL_483:
        UNLK A6
        RTS
        ; func rtUiTraceInit  (JT slot 279)
        ;   local nWins : -4(A6)  size 4
        ;   local nMh : -8(A6)  size 4
LBL_42:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        JSR 338(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_485
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; UiNewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-66(A5)
        BRA.W LBL_486
LBL_485:
        MOVE.L #0,D0
        MOVE.L D0,-66(A5)
LBL_486:
        JSR 370(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_487
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; UiNewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-74(A5)
        BRA.W LBL_488
LBL_487:
        MOVE.L #0,D0
        MOVE.L D0,-74(A5)
LBL_488:
        MOVE.L #1,D0
        MOVE.B D0,-76(A5)
        MOVE.L #0,D0
        MOVE.B D0,-78(A5)
        MOVE.L #0,D0
        MOVE.L D0,-70(A5)
LBL_484:
        UNLK A6
        RTS
        ; func rtUiTraceNextId  (JT slot 280)
        ;   param winIdx : 8(A6)  size 4
        ;   local v : -4(A6)  size 4
LBL_43:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -66(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
        MOVE.L #0,D0
        BRA.W LBL_489
LBL_490:
        MOVE.L -66(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -66(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_489
LBL_489:
        UNLK A6
        RTS
        ; func rtUiTraceOpen  (JT slot 281)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
        ;   local id : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
LBL_44:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        JSR 98(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_491:
        UNLK A6
        RTS
        ; func rtUiTraceClose  (JT slot 282)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_45:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_492:
        UNLK A6
        RTS
        ; func rtUiTraceFire1  (JT slot 283)
        ;   param namePtr : 264(A6)  size 4
        ;   param event : 8(A6)  size 256
        ;   local t : -4(A6)  size 4
LBL_46:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 264(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_493:
        UNLK A6
        RTS
        ; func rtUiTraceFire2  (JT slot 284)
        ;   param namePtr : 268(A6)  size 4
        ;   param wnamePtr : 264(A6)  size 4
        ;   param event : 8(A6)  size 256
        ;   local t : -4(A6)  size 4
LBL_47:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 268(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 264(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_494:
        UNLK A6
        RTS
        ; func rtUiTraceMenuSelectFor  (JT slot 285)
        ;   param k : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_48:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 770(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_141(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_495:
        UNLK A6
        RTS
        ; func rtUiTraceEveryFire  (JT slot 286)
        ;   param n : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_49:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_142(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_496:
        UNLK A6
        RTS
        ; func rtUiTraceDimCheck  (JT slot 287)
        ;   param k : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local prev : -4(A6)  size 4
        ;   local enableInt : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_50:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_498
        MOVE.L #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_499
LBL_498:
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_499:
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_500
        BRA.W LBL_497
LBL_500:
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -76(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_501
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_502
LBL_501:
        MOVE.L #0,D0
LBL_502:
        TST.L D0
        BEQ.W LBL_503
        JSR 98(A5)
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 770(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_503:
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_497:
        UNLK A6
        RTS
        ; func rtUiTraceStdEditDim  (JT slot 288)
        ;   param enable : 8(A6)  size 2
        ;   local enableInt : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
LBL_51:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_505
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_506
LBL_505:
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_506:
        CLR.L D0
        MOVE.B -76(A5),D0
        TST.L D0
        BNE.W LBL_507
        CLR.L D0
        MOVE.B -78(A5),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_508
LBL_507:
        MOVE.L #1,D0
LBL_508:
        TST.L D0
        BEQ.W LBL_509
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-78(A5)
        BRA.W LBL_504
LBL_509:
        JSR 98(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        JSR 98(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        JSR 98(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_146(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        JSR 98(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        JSR 658(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-78(A5)
LBL_504:
        UNLK A6
        RTS
        ; func rtUiTraceDimFirstDone  (JT slot 289)
LBL_52:
        LINK A6,#-2128
        MOVE.L #0,D0
        MOVE.B D0,-76(A5)
LBL_510:
        UNLK A6
        RTS
        ; func rtUiTraceFrontCheck  (JT slot 290)
        ;   local wp : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_53:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1114(A5)
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_512
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_513
LBL_512:
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_513:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -70(A5),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_514
        BRA.W LBL_511
LBL_514:
        MOVE.L -8(A6),D0
        MOVE.L D0,-70(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_515
        JSR 98(A5)
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_515:
LBL_511:
        UNLK A6
        RTS
        ; func rtUiTraceAbout  (JT slot 291)
        ;   local t : -4(A6)  size 4
LBL_54:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_149(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 818(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_150(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_150(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_150(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 866(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_516:
        UNLK A6
        RTS
        ; func rtUiPropNamePtr  (JT slot 292)
        ;   param prop : 8(A6)  size 4
LBL_55:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_518
        LEA LBL_151(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_518:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_519
        LEA LBL_152(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_519:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
        LEA LBL_153(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_520:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_521
        LEA LBL_154(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_521:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_522
        LEA LBL_155(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_522:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_523
        LEA LBL_156(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_523:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_524
        LEA LBL_157(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_524:
        LEA LBL_127(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_517
LBL_517:
        UNLK A6
        RTS
        ; func rtUiTraceSetStr  (JT slot 293)
        ;   param namePtr : 20(A6)  size 4
        ;   param wnamePtr : 16(A6)  size 4
        ;   param prop : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_56:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_158(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_525:
        UNLK A6
        RTS
        ; func rtUiTraceSetBool  (JT slot 294)
        ;   param namePtr : 18(A6)  size 4
        ;   param wnamePtr : 14(A6)  size 4
        ;   param prop : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
        ;   local t : -4(A6)  size 4
        ;   local vi : -8(A6)  size 4
LBL_57:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_527
        MOVE.L #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_528
LBL_527:
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_528:
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_158(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_526:
        UNLK A6
        RTS
        ; func rtUiTraceSetInt  (JT slot 295)
        ;   param namePtr : 20(A6)  size 4
        ;   param wnamePtr : 16(A6)  size 4
        ;   param prop : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_58:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_158(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_529:
        UNLK A6
        RTS
        ; func rtUiTraceInvalid  (JT slot 296)
        ;   param namePtr : 12(A6)  size 4
        ;   param wnamePtr : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_59:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_530:
        UNLK A6
        RTS
        ; func rtUiTraceAskPath  (JT slot 297)
        ;   param verb : 12(A6)  size 256
        ;   param pathPStr : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_60:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA 12(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_531:
        UNLK A6
        RTS
        ; func rtUiTraceOpenDoc  (JT slot 298)
        ;   param pathPtr : 12(A6)  size 4
        ;   param pathLen : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local pathText : -8(A6)  size 4
LBL_61:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        JSR 98(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDA.W #16,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 114(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_532:
        UNLK A6
        RTS
        ; func rtUiStrEq  (JT slot 299)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_62:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_534:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_535
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_536
        MOVE.L #0,D0
        BRA.W LBL_533
LBL_536:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_534
LBL_535:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_533
LBL_533:
        UNLK A6
        RTS
        ; func rtUiAtoi  (JT slot 300)
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local neg : -6(A6)  size 2
        ;   local v : -10(A6)  size 4
        ;   local c : -14(A6)  size 4
LBL_63:
        LINK A6,#-2142
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_538
        MOVE.L #1,D0
        MOVE.B D0,-6(A6)
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
LBL_538:
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
LBL_539:
        MOVE.L #1,D0
        TST.L D0
        BEQ.W LBL_540
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-14(A6)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_541
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_542
LBL_541:
        MOVE.L #1,D0
LBL_542:
        TST.L D0
        BEQ.W LBL_543
        BRA.W LBL_540
LBL_543:
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-10(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_539
LBL_540:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_544
        MOVE.L -10(A6),D0
        NEG.L D0
        MOVE.L D0,-10(A6)
LBL_544:
        MOVE.L -10(A6),D0
        BRA.W LBL_537
LBL_537:
        UNLK A6
        RTS
        ; func rtUiScriptKeyArg  (JT slot 301)
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local allDigits : -6(A6)  size 2
        ;   local c : -10(A6)  size 4
LBL_64:
        LINK A6,#-2138
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_546
        MOVE.L #0,D0
        BRA.W LBL_545
LBL_546:
        MOVE.L #1,D0
        MOVE.B D0,-6(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_547:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_548
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-10(A6)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_549
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_550
LBL_549:
        MOVE.L #1,D0
LBL_550:
        TST.L D0
        BEQ.W LBL_551
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
LBL_551:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_547
LBL_548:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_552
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        BRA.W LBL_545
LBL_552:
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_545
LBL_545:
        UNLK A6
        RTS
        ; func rtUiTextAppendCStr  (JT slot 302)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local scratch : -8(A6)  size 4
LBL_65:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_554:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_555
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_554
LBL_555:
        JSR 98(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDA.W #16,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 114(A5)
        ADDQ.L #4,A7
LBL_553:
        UNLK A6
        RTS
        ; func rtUiScriptNextLine  (JT slot 303)
        ;   local n : -4(A6)  size 4
LBL_66:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -84(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_557
        LEA LBL_210(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-82(A5)
        MOVE.L #1,D0
        MOVE.B D0,-84(A5)
LBL_557:
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_558
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-88(A5)
LBL_558:
LBL_559:
        MOVE.L #1,D0
        TST.L D0
        BEQ.W LBL_560
        MOVE.L -82(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_561
        MOVE.L #0,D0
        BRA.W LBL_556
LBL_561:
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_562:
        MOVE.L -82(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_564
        MOVE.L -82(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_565
LBL_564:
        MOVE.L #0,D0
LBL_565:
        TST.L D0
        BEQ.W LBL_563
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_566
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -82(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_566:
        MOVE.L -82(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-82(A5)
        BRA.W LBL_562
LBL_563:
        MOVE.L -82(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_567
        MOVE.L -82(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-82(A5)
LBL_567:
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-92(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_568
        MOVE.L #1,D0
        BRA.W LBL_556
LBL_568:
        BRA.W LBL_559
LBL_560:
        MOVE.L #0,D0
        BRA.W LBL_556
LBL_556:
        UNLK A6
        RTS
        ; func rtUiSkipSpaces  (JT slot 304)
        ;   param p : 8(A6)  size 4
        ;   local q : -4(A6)  size 4
LBL_67:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
LBL_570:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A5),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_572
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_573
LBL_572:
        MOVE.L #0,D0
LBL_573:
        TST.L D0
        BEQ.W LBL_571
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_570
LBL_571:
        MOVE.L -4(A6),D0
        BRA.W LBL_569
LBL_569:
        UNLK A6
        RTS
        ; func rtUiCopyToken  (JT slot 305)
        ;   param p : 16(A6)  size 4
        ;   param dst : 12(A6)  size 4
        ;   param maxLen : 8(A6)  size 4
        ;   local q : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_68:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_575:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A5),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_578
LBL_577:
        MOVE.L #0,D0
LBL_578:
        TST.L D0
        BEQ.W LBL_576
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_579
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_579:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_575
LBL_576:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_574
LBL_574:
        UNLK A6
        RTS
        ; func rtUiScriptTokenize  (JT slot 306)
        ;   local p : -4(A6)  size 4
LBL_69:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_581
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-96(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-100(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-104(A5)
LBL_581:
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #63,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #63,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #63,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
LBL_580:
        UNLK A6
        RTS
        ; func rtUiScriptClick  (JT slot 307)
        ;   param x : 14(A6)  size 4
        ;   param y : 10(A6)  size 4
        ;   param dbl : 8(A6)  size 2
        ;   local ev : -4(A6)  size 4
LBL_70:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-42(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1482(A5)
        ADDQ.L #4,A7
        MOVE.L #0,D0
        MOVE.B D0,-42(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_582:
        UNLK A6
        RTS
        ; func rtUiScriptDrag  (JT slot 308)
        ;   param x : 12(A6)  size 4
        ;   param y : 8(A6)  size 4
        ;   local wherePt : -4(A6)  size 4
        ;   local wpSlot : -8(A6)  size 4
        ;   local part : -12(A6)  size 4
        ;   local wp : -16(A6)  size 4
        ;   local inst : -20(A6)  size 4
        ;   local localPt : -24(A6)  size 4
        ;   local cIdxSlot : -28(A6)  size 4
        ;   local cIdx : -32(A6)  size 4
        ;   local tIdxSlot : -36(A6)  size 4
        ;   local tIdx : -40(A6)  size 4
LBL_71:
        LINK A6,#-2168
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65535,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
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
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_584
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_585
LBL_584:
        MOVE.L #1,D0
LBL_585:
        TST.L D0
        BEQ.W LBL_586
        BRA.W LBL_583
LBL_586:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_587
        BRA.W LBL_583
LBL_587:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1450(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_588
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 1458(A5)
        ADDA.W #16,A7
        BRA.W LBL_583
LBL_588:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_589
        MOVE.L -36(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_590
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_591
LBL_590:
        MOVE.L #0,D0
LBL_591:
        TST.L D0
        BEQ.W LBL_592
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D4  ; UiTEClick
LBL_592:
        BRA.W LBL_583
LBL_589:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_583:
        UNLK A6
        RTS
        ; func rtUiScriptKey  (JT slot 309)
        ;   param ch : 8(A6)  size 4
        ;   local ev : -4(A6)  size 4
LBL_72:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_593:
        UNLK A6
        RTS
        ; func rtUiScriptType  (JT slot 310)
        ;   local p : -4(A6)  size 4
LBL_73:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #4,D0
        MOVE.L D0,-4(A6)
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_595
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_595:
LBL_596:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A5),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_596
LBL_597:
LBL_594:
        UNLK A6
        RTS
        ; func rtUiScriptRestOfLine  (JT slot 311)
        ;   param verbLen : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
LBL_74:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_599
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_599:
        MOVE.L -88(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_598
LBL_598:
        UNLK A6
        RTS
        ; func rtUiScriptAnswerChanges  (JT slot 312)
        ;   local v : -4(A6)  size 4
LBL_75:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_601
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_602
LBL_601:
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_163(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_603
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_604
LBL_603:
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_164(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_605
        MOVE.L #2,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_606
LBL_605:
        LEA LBL_165(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_607:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_607
        JSR 50(A5)
        ADDA.W #256,A7
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_606:
LBL_604:
LBL_602:
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
LBL_600:
        UNLK A6
        RTS
        ; func rtUiScriptClose  (JT slot 313)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
LBL_76:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_609
        BRA.W LBL_608
LBL_609:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_610
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #4,A7
LBL_610:
LBL_608:
        UNLK A6
        RTS
        ; func rtUiScriptResize  (JT slot 314)
        ;   param w : 12(A6)  size 4
        ;   param h : 8(A6)  size 4
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
LBL_77:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_612
        BRA.W LBL_611
LBL_612:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 466(A5)
        ADDQ.L #4,A7
        BRA.W LBL_614
LBL_613:
        MOVE.L #0,D0
LBL_614:
        TST.L D0
        BEQ.W LBL_615
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1410(A5)
        ADDA.W #16,A7
LBL_615:
LBL_611:
        UNLK A6
        RTS
        ; func rtUiScriptZoom  (JT slot 315)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local screenBoundsSlot : -12(A6)  size 4
        ;   local screenW : -16(A6)  size 4
        ;   local screenH : -20(A6)  size 4
        ;   local std : -24(A6)  size 4
        ;   local contRgnH : -28(A6)  size 4
        ;   local contRgnMp : -32(A6)  size 4
        ;   local content : -36(A6)  size 4
        ;   local part : -40(A6)  size 4
        ;   local eq : -42(A6)  size 2
LBL_78:
        LINK A6,#-2170
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
        MOVE.B D0,-42(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_617
        BRA.W LBL_616
LBL_617:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_618
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 466(A5)
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_619
LBL_618:
        MOVE.L #1,D0
LBL_619:
        TST.L D0
        BEQ.W LBL_620
        BRA.W LBL_616
LBL_620:
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2946(A5)
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.W D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,-(A7)
        MOVE.L #19,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #118,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-36(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        CLR.W -(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A6  ; UiEqualRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-42(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        CLR.L D0
        MOVE.B -42(A6),D0
        TST.L D0
        BEQ.W LBL_621
        MOVE.L #7,D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_622
LBL_621:
        MOVE.L #8,D0
        MOVE.L D0,-40(A6)
LBL_622:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDA.W #12,A7
LBL_616:
        UNLK A6
        RTS
        ; func rtUiScriptEveryPump  (JT slot 316)
        ;   local i : -4(A6)  size 4
        ;   local due : -8(A6)  size 4
LBL_79:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -22(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        BRA.W LBL_623
LBL_624:
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_625:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A5),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_626
        MOVE.L -22(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -108(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        MOVE.L -22(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -108(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 794(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
LBL_627:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_625
LBL_626:
LBL_623:
        UNLK A6
        RTS
        ; func rtUiScriptTick  (JT slot 317)
        ;   param n : 8(A6)  size 4
LBL_80:
        LINK A6,#-2128
        MOVE.L -108(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-108(A5)
        BSR.W LBL_79
        BSR.W LBL_7
        JSR 1346(A5)
LBL_628:
        UNLK A6
        RTS
        ; func rtUiScriptMenu  (JT slot 318)
        ;   param m : 12(A6)  size 4
        ;   param itemNum : 8(A6)  size 4
LBL_81:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65535,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1314(A5)
        ADDQ.L #4,A7
LBL_629:
        UNLK A6
        RTS
        ; func rtUiPumpPassive  (JT slot 319)
        ;   local ev : -4(A6)  size 4
        ;   local what : -8(A6)  size 4
        ;   local gotEvent : -10(A6)  size 2
LBL_82:
        LINK A6,#-2138
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.B D0,-10(A6)
        BSR.W LBL_27
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        CLR.W -(A7)
        MOVE.L #320,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A970  ; UiGetNextEvent
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-10(A6)
LBL_631:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_632
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_633
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #4,A7
        BRA.W LBL_634
LBL_633:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_635
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        JSR 1370(A5)
        ADDQ.L #6,A7
LBL_635:
LBL_634:
        CLR.W -(A7)
        MOVE.L #320,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A970  ; UiGetNextEvent
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-10(A6)
        BRA.W LBL_631
LBL_632:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_630:
        UNLK A6
        RTS
        ; func rtUiHexDigit  (JT slot 320)
        ;   param d : 8(A6)  size 4
LBL_83:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_637
        MOVE.L #48,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_636
LBL_637:
        MOVE.L #65,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_636
LBL_636:
        UNLK A6
        RTS
        ; func rtUiHexLineText  (JT slot 321)
        ;   param src : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local b : -12(A6)  size 4
LBL_84:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_639:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #64,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_640
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_639
LBL_640:
        MOVE.L -4(A6),D0
        BRA.W LBL_638
LBL_638:
        UNLK A6
        RTS
        ; func rtUiTestSnap  (JT slot 322)
        ;   param namePtr : 8(A6)  size 4
        ;   local baseAddrSlot : -4(A6)  size 4
        ;   local rowBytesSlot : -8(A6)  size 4
        ;   local boundsSlot : -12(A6)  size 4
        ;   local baseAddr : -16(A6)  size 4
        ;   local rowBytes : -20(A6)  size 4
        ;   local rows : -24(A6)  size 4
        ;   local total : -28(A6)  size 4
        ;   local off : -32(A6)  size 4
        ;   local hdr : -36(A6)  size 4
LBL_85:
        LINK A6,#-2164
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
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2954(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #64,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_642
        LEA LBL_166(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_643:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_643
        JSR 50(A5)
        ADDA.W #256,A7
LBL_642:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_212
        MOVE.L D0,-28(A6)
        JSR 98(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
LBL_644:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_645
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #64,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_644
LBL_645:
        LEA LBL_168(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_646:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_646
        BSR.W LBL_86
        ADDA.W #256,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_641:
        UNLK A6
        RTS
        ; func rtUiLitLine  (JT slot 323)
        ;   param s : 8(A6)  size 256
        ;   local t : -4(A6)  size 4
LBL_86:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 98(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_647
LBL_647:
        UNLK A6
        RTS
        ; func rtUiRunScripted  (JT slot 324)
LBL_87:
        LINK A6,#-2128
        MOVE.L #1,D0
        MOVE.B D0,-40(A5)
        DC.W $A852  ; UiHideCursor
LBL_649:
        MOVE.L #1,D0
        TST.L D0
        BEQ.W LBL_650
        BSR.W LBL_66
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_651
        JSR 1202(A5)
        BRA.W LBL_648
LBL_651:
        BSR.W LBL_69
        BSR.W LBL_88
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_652
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        JSR 2818(A5)
        ADDQ.L #4,A7
        BSR.W LBL_215
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        JSR 2826(A5)
        ADDQ.L #4,A7
LBL_652:
        BSR.W LBL_82
        BRA.W LBL_649
LBL_650:
LBL_648:
        UNLK A6
        RTS
        ; func rtUiScriptDispatchLine  (JT slot 325)
LBL_88:
        LINK A6,#-2128
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_654
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_70
        ADDA.W #10,A7
        BRA.W LBL_655
LBL_654:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_170(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_656
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_70
        ADDA.W #10,A7
        BRA.W LBL_657
LBL_656:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_658
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
        BRA.W LBL_659
LBL_658:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_124(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_660
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_661
LBL_660:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_662
        BSR.W LBL_73
        BRA.W LBL_663
LBL_662:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_664
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #8,A7
        BRA.W LBL_665
LBL_664:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_666
        BSR.W LBL_76
        BRA.W LBL_667
LBL_666:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_174(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_668
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #8,A7
        BRA.W LBL_669
LBL_668:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_175(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_670
        BSR.W LBL_78
        BRA.W LBL_671
LBL_670:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_176(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_672
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #4,A7
        BRA.W LBL_673
LBL_672:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_177(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_674
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        BRA.W LBL_675
LBL_674:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_178(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_676
        JSR 1202(A5)
        BRA.W LBL_677
LBL_676:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_179(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_678
        BRA.W LBL_679
LBL_678:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_680
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        BRA.W LBL_681
LBL_680:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_181(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_682
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        BRA.W LBL_683
LBL_682:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_684
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        BRA.W LBL_685
LBL_684:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_686
        BSR.W LBL_75
        BRA.W LBL_687
LBL_686:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_184(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_688
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        BRA.W LBL_689
LBL_688:
        MOVE.L -96(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_690
        BRA.W LBL_691
LBL_690:
        MOVE.L #0,D0
        BRA.W LBL_653
LBL_691:
LBL_689:
LBL_687:
LBL_685:
LBL_683:
LBL_681:
LBL_679:
LBL_677:
LBL_675:
LBL_673:
LBL_671:
LBL_669:
LBL_667:
LBL_665:
LBL_663:
LBL_661:
LBL_659:
LBL_657:
LBL_655:
        MOVE.L #1,D0
        BRA.W LBL_653
LBL_653:
        UNLK A6
        RTS
        ; func nat_UiSFGetFile  (JT slot 326)
        ;   param path255Out : 8(A6)  size 4
LBL_89:
        LINK A6,#-2128
        MOVE.L #0,D0
        BRA.W LBL_692
LBL_692:
        UNLK A6
        RTS
        ; func nat_UiSFPutFile  (JT slot 327)
        ;   param suggested255 : 12(A6)  size 4
        ;   param path255Out : 8(A6)  size 4
LBL_90:
        LINK A6,#-2128
        MOVE.L #0,D0
        BRA.W LBL_693
LBL_693:
        UNLK A6
        RTS
        ; func rtUiFormInvalid  (JT slot 328)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_91:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #8,A7
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D1  ; UiTESetSelect
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #8,A7
LBL_694:
        UNLK A6
        RTS
        ; func rtUiFormTeardown  (JT slot 329)
        ;   param inst : 8(A6)  size 4
        ;   local bufH : -4(A6)  size 4
LBL_92:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -118(A5),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-110(A5)
        MOVE.L #0,D0
        MOVE.L D0,-114(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1178(A5)
        ADDQ.L #4,A7
LBL_695:
        UNLK A6
        RTS
        ; func rtUiFormIsNew  (JT slot 330)
LBL_93:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -110(A5),D0
        TST.L D0
        BEQ.W LBL_697
        CLR.L D0
        MOVE.B -124(A5),D0
        BRA.W LBL_696
LBL_697:
        MOVE.L #0,D0
        BRA.W LBL_696
LBL_696:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 331)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_94:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        JSR 2810(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        JSR 2778(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2794(A5)
        ADDQ.L #8,A7
        JSR 2802(A5)
LBL_698:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 332)
LBL_95:
        LINK A6,#-2128
        MOVE.L -184(A5),D0
        BRA.W LBL_699
LBL_699:
        UNLK A6
        RTS
LBL_212:
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
LBL_213:
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
        BPL.W LBL_700
        NEG.L D2
        MOVE.L #1,D4
LBL_700:
        CLR.L D5
        TST.L D3
        BPL.W LBL_701
        NEG.L D3
        MOVE.L #1,D5
LBL_701:
        CLR.L D6
        MOVE.W #31,D7
LBL_702:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_703
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_703:
        DBRA D7,LBL_702
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_704
        NEG.L D2
LBL_704:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_214:
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
        BPL.W LBL_705
        NEG.L D2
        MOVE.L #1,D4
LBL_705:
        CLR.L D5
        TST.L D3
        BPL.W LBL_706
        NEG.L D3
        MOVE.L #1,D5
LBL_706:
        CLR.L D6
        MOVE.W #31,D7
LBL_707:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_708
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_708:
        DBRA D7,LBL_707
        TST.L D4
        BEQ.W LBL_709
        NEG.L D6
LBL_709:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_215:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
LBL_710:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_96:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_97:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_98:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_99:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_100:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_101:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_102:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_103:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_104:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_105:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_106:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_107:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_108:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_109:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_110:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_111:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_112:
        DC.B $01
        DC.B $2D
LBL_113:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_114:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_115:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_116:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_117:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_118:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_119:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
LBL_120:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_121:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_122:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_123:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_124:
        DC.B $03
        DC.B $6B,$65,$79
LBL_125:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_126:
        DC.B $01
        DC.B $78
LBL_127:
        DC.B $01
        DC.B $3F
LBL_128:
        DC.B $06
        DC.B $73,$65,$6C,$65,$63,$74
        DC.B $00
LBL_129:
        DC.B $0B
        DC.B $64,$6F,$75,$62,$6C,$65,$43,$6C,$69,$63,$6B
LBL_130:
        DC.B $78
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$66,$6F,$75,$6E,$64,$20,$6E,$6F,$20,$6D,$65,$6E,$75,$20,$69,$6E,$20,$74,$68,$65,$20,$6D,$65,$6E,$75,$20,$6C,$69,$73,$74,$20,$66,$6F,$72,$20,$74,$68,$69,$73,$20,$77,$69,$64,$67,$65,$74,$20,$28,$63,$6C,$6F,$73,$65,$2F,$72,$65,$6F,$70,$65,$6E,$20,$6C,$65,$66,$74,$20,$69,$74,$20,$75,$6E,$64,$65,$6C,$65,$74,$65,$64,$20,$6F,$72,$20,$6E,$65,$76,$65,$72,$20,$72,$65,$69,$6E,$73,$65,$72,$74,$65,$64,$29
        DC.B $00
LBL_131:
        DC.B $71
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$72,$65,$74,$75,$72,$6E,$65,$64,$20,$61,$20,$6D,$65,$6E,$75,$20,$68,$61,$6E,$64,$6C,$65,$20,$74,$68,$61,$74,$20,$69,$73,$6E,$27,$74,$20,$74,$68,$69,$73,$20,$69,$6E,$73,$74,$61,$6E,$63,$65,$27,$73,$20,$6F,$77,$6E,$20,$28,$73,$74,$61,$6C,$65,$2F,$6C,$65,$61,$6B,$65,$64,$20,$65,$6E,$74,$72,$79,$20,$75,$6E,$64,$65,$72,$20,$74,$68,$65,$20,$73,$61,$6D,$65,$20,$49,$44,$29
LBL_132:
        DC.B $57
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$6D,$65,$6E,$75,$20,$69,$74,$65,$6D,$20,$63,$6F,$75,$6E,$74,$20,$64,$6F,$65,$73,$6E,$27,$74,$20,$6D,$61,$74,$63,$68,$20,$74,$68,$65,$20,$62,$6F,$75,$6E,$64,$20,$65,$6E,$75,$6D,$20,$28,$72,$65,$62,$75,$69,$6C,$74,$20,$77,$69,$74,$68,$20,$73,$74,$61,$6C,$65,$2F,$6C,$65,$66,$74,$6F,$76,$65,$72,$20,$69,$74,$65,$6D,$73,$29
LBL_133:
        DC.B $24
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_134:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$61,$6E,$73,$77,$65,$72,$20,$71,$75,$65,$75,$65,$20,$6F,$76,$65,$72,$66,$6C,$6F,$77
LBL_135:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$77,$69,$74,$68,$20,$6E,$6F,$20,$71,$75,$65,$75,$65,$64,$20,$61,$6E,$73,$77,$65,$72
LBL_136:
        DC.B $07
        DC.B $54,$20,$4F,$50,$45,$4E,$20
LBL_137:
        DC.B $01
        DC.B $20
LBL_138:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_139:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_140:
        DC.B $01
        DC.B $2E
LBL_141:
        DC.B $07
        DC.B $2E,$73,$65,$6C,$65,$63,$74
LBL_142:
        DC.B $0D
        DC.B $54,$20,$46,$49,$52,$45,$20,$65,$76,$65,$72,$79,$2E
LBL_143:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_144:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_145:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_146:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_147:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_148:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_149:
        DC.B $08
        DC.B $54,$20,$41,$42,$4F,$55,$54,$20
        DC.B $00
LBL_150:
        DC.B $01
        DC.B $7C
LBL_151:
        DC.B $07
        DC.B $63,$61,$70,$74,$69,$6F,$6E
LBL_152:
        DC.B $04
        DC.B $74,$65,$78,$74
        DC.B $00
LBL_153:
        DC.B $07
        DC.B $65,$6E,$61,$62,$6C,$65,$64
LBL_154:
        DC.B $07
        DC.B $63,$68,$65,$63,$6B,$65,$64
LBL_155:
        DC.B $08
        DC.B $73,$65,$6C,$65,$63,$74,$65,$64
        DC.B $00
LBL_156:
        DC.B $05
        DC.B $77,$69,$64,$74,$68
LBL_157:
        DC.B $06
        DC.B $68,$65,$69,$67,$68,$74
        DC.B $00
LBL_158:
        DC.B $06
        DC.B $54,$20,$53,$45,$54,$20
        DC.B $00
LBL_159:
        DC.B $09
        DC.B $2E,$69,$6E,$76,$61,$6C,$69,$64,$2E
LBL_160:
        DC.B $02
        DC.B $54,$20
        DC.B $00
LBL_161:
        DC.B $0A
        DC.B $54,$20,$4F,$50,$45,$4E,$44,$4F,$43,$20
        DC.B $00
LBL_162:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_163:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_164:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_165:
        DC.B $37
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$73,$61,$76,$65,$7C,$64,$69,$73,$63,$61,$72,$64,$7C,$63,$61,$6E,$63,$65,$6C,$29
LBL_166:
        DC.B $23
        DC.B $73,$6E,$61,$70,$3A,$20,$73,$63,$72,$65,$65,$6E,$42,$69,$74,$73,$2E,$72,$6F,$77,$42,$79,$74,$65,$73,$20,$69,$73,$20,$6E,$6F,$74,$20,$36,$34
LBL_167:
        DC.B $10
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$23,$23,$20
        DC.B $00
LBL_168:
        DC.B $13
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$2D,$45,$4E,$44,$23,$23
LBL_169:
        DC.B $2C
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$6B,$6E,$6F,$77,$6E,$20,$6F,$72,$20,$75,$6E,$73,$75,$70,$70,$6F,$72,$74,$65,$64,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$76,$65,$72,$62
        DC.B $00
LBL_170:
        DC.B $08
        DC.B $64,$62,$6C,$63,$6C,$69,$63,$6B
        DC.B $00
LBL_171:
        DC.B $04
        DC.B $74,$79,$70,$65
        DC.B $00
LBL_172:
        DC.B $04
        DC.B $6D,$65,$6E,$75
        DC.B $00
LBL_173:
        DC.B $05
        DC.B $63,$6C,$6F,$73,$65
LBL_174:
        DC.B $06
        DC.B $72,$65,$73,$69,$7A,$65
        DC.B $00
LBL_175:
        DC.B $04
        DC.B $7A,$6F,$6F,$6D
        DC.B $00
LBL_176:
        DC.B $04
        DC.B $74,$69,$63,$6B
        DC.B $00
LBL_177:
        DC.B $04
        DC.B $73,$6E,$61,$70
        DC.B $00
LBL_178:
        DC.B $04
        DC.B $71,$75,$69,$74
        DC.B $00
LBL_179:
        DC.B $09
        DC.B $6C,$61,$75,$6E,$63,$68,$64,$6F,$63
LBL_180:
        DC.B $0C
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$70,$6F,$70,$75,$70
        DC.B $00
LBL_181:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$6F,$70,$65,$6E
LBL_182:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$73,$61,$76,$65
LBL_183:
        DC.B $0E
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73
        DC.B $00
LBL_184:
        DC.B $0D
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$61,$6E,$63,$65,$6C
LBL_185:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_186:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_187:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_188:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_189:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_190:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_191:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_192:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_193:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_194:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_195:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_196:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_197:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_198:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_199:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_200:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_201:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_202:
        DC.B $2B
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$64,$67,$65,$74,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_203:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_204:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_205:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_206:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_207:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_208:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_211:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (264 bytes)
LBL_209:
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
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $94
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $A8
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $AE
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $2C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $78
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
        DC.B $04
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
        DC.B $A4
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
        DC.B $00
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
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $AE
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $B8
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $BC
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $E0
        DC.B $03
        DC.B $50
        DC.B $61
        DC.B $64
        DC.B $05
        DC.B $50
        DC.B $72
        DC.B $6F
        DC.B $62
        DC.B $65
        DC.B $09
        DC.B $54
        DC.B $69
        DC.B $63
        DC.B $6B
        DC.B $50
        DC.B $72
        DC.B $6F
        DC.B $62
        DC.B $65
        DC.B $03
        DC.B $31
        DC.B $2E
        DC.B $30
        DC.B $23
        DC.B $41
        DC.B $6E
        DC.B $64
        DC.B $72
        DC.B $65
        DC.B $77
        DC.B $20
        DC.B $43
        DC.B $2E
        DC.B $20
        DC.B $59
        DC.B $6F
        DC.B $75
        DC.B $6E
        DC.B $67
        DC.B $20
        DC.B $3C
        DC.B $61
        DC.B $6E
        DC.B $64
        DC.B $72
        DC.B $65
        DC.B $77
        DC.B $40
        DC.B $76
        DC.B $61
        DC.B $65
        DC.B $6C
        DC.B $65
        DC.B $6E
        DC.B $2E
        DC.B $6F
        DC.B $72
        DC.B $67
        DC.B $3E
        DC.B $27
        DC.B $52
        DC.B $65
        DC.B $61
        DC.B $6C
        DC.B $2D
        DC.B $65
        DC.B $76
        DC.B $65
        DC.B $6E
        DC.B $74
        DC.B $2D
        DC.B $6C
        DC.B $6F
        DC.B $6F
        DC.B $70
        DC.B $20
        DC.B $74
        DC.B $69
        DC.B $6D
        DC.B $65
        DC.B $72
        DC.B $20
        DC.B $72
        DC.B $65
        DC.B $67
        DC.B $72
        DC.B $65
        DC.B $73
        DC.B $73
        DC.B $69
        DC.B $6F
        DC.B $6E
        DC.B $20
        DC.B $70
        DC.B $72
        DC.B $6F
        DC.B $62
        DC.B $65
        DC.B $2E
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_210:
        DC.B $00
        DC.B $00
