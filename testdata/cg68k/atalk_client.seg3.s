        ; func rtUiTeRelayout  (JT slot 319)
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
LBL_0:
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
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_196
        BRA.W LBL_195
LBL_196:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 994(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 970(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-26(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 986(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-28(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2162(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_197
        MOVEQ #0,D0
        MOVE.B D0,-26(A6)
        MOVEQ #0,D0
        MOVE.B D0,-28(A6)
LBL_197:
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_200
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_201
LBL_200:
        MOVEQ #0,D0
LBL_201:
        TST.L D0
        BEQ.W LBL_198
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BNE.W LBL_202
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_203
LBL_202:
        MOVEQ #1,D0
LBL_203:
        BRA.W LBL_199
LBL_198:
        MOVEQ #0,D0
LBL_199:
        TST.L D0
        BEQ.W LBL_204
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_204:
        MOVEQ #0,D0
        MOVE.B D0,-32(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_207
        MOVE.L -16(A6),D1
        MOVEQ #16,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_208
LBL_207:
        MOVEQ #0,D0
LBL_208:
        TST.L D0
        BEQ.W LBL_205
        CLR.L D0
        MOVE.B -28(A6),D0
        BRA.W LBL_206
LBL_205:
        MOVEQ #0,D0
LBL_206:
        TST.L D0
        BEQ.W LBL_209
        MOVEQ #1,D0
        MOVE.B D0,-32(A6)
LBL_209:
        MOVEQ #15,D0
        MOVE.L D0,-36(A6)
        CLR.L D0
        MOVE.B -30(A6),D0
        TST.L D0
        BEQ.W LBL_210
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_210:
        MOVEQ #15,D0
        MOVE.L D0,-40(A6)
        CLR.L D0
        MOVE.B -32(A6),D0
        TST.L D0
        BEQ.W LBL_211
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
LBL_211:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
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
        JSR 2098(A5)
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
        BEQ.W LBL_212
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2106(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_213
LBL_212:
        MOVEQ #0,D0
LBL_213:
        TST.L D0
        BEQ.W LBL_214
        MOVE.L -52(A6),D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
LBL_214:
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
        BEQ.W LBL_215
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-104(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2146(A5)
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
        BEQ.W LBL_216
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_217
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_218
LBL_217:
        MOVE.L -56(A6),D0
        MOVE.L D0,-88(A6)
LBL_218:
        MOVE.L -64(A6),D0
        MOVE.L D0,-96(A6)
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_219
        MOVE.L -64(A6),D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-96(A6)
LBL_219:
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
LBL_216:
        CLR.L D0
        MOVE.B -84(A6),D0
        TST.L D0
        BEQ.W LBL_220
        MOVE.L -52(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_221
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-92(A6)
        BRA.W LBL_222
LBL_221:
        MOVE.L -52(A6),D0
        MOVE.L D0,-92(A6)
LBL_222:
        MOVE.L -60(A6),D0
        MOVE.L D0,-100(A6)
        CLR.L D0
        MOVE.B -82(A6),D0
        TST.L D0
        BEQ.W LBL_223
        MOVE.L -60(A6),D1
        MOVE.L -36(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-100(A6)
LBL_223:
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
LBL_220:
LBL_215:
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
        BEQ.W LBL_224
        MOVE.L -68(A6),D0
        MOVE.L D0,-76(A6)
LBL_224:
        MOVE.L -80(A6),D1
        MOVE.L -72(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_225
        MOVE.L -72(A6),D0
        MOVE.L D0,-80(A6)
LBL_225:
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
        BEQ.W LBL_226
        MOVE.L -108(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_227
LBL_226:
        MOVEQ #0,D0
LBL_227:
        TST.L D0
        BEQ.W LBL_228
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
LBL_228:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2530(A5)
        ADDQ.L #8,A7
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
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
LBL_195:
        UNLK A6
        RTS
        ; func rtUiTeSetFocus  (JT slot 320)
        ;   param inst : 12(A6)  size 4
        ;   param newIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local te : -8(A6)  size 4
LBL_1:
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
        BEQ.W LBL_230
        BRA.W LBL_229
LBL_230:
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
        BEQ.W LBL_231
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_232
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D9  ; UiTEDeactivate
LBL_232:
LBL_231:
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
        BEQ.W LBL_233
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_234
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D8  ; UiTEActivate
LBL_234:
LBL_233:
        JSR 1850(A5)
LBL_229:
        UNLK A6
        RTS
        ; func rtUiTeHit  (JT slot 321)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
        ;   local te : -20(A6)  size 4
LBL_2:
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
        JSR 850(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_236:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_237
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_238
        MOVE.L -16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_239
LBL_238:
        MOVEQ #1,D0
LBL_239:
        TST.L D0
        BEQ.W LBL_240
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_241
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
        BRA.W LBL_242
LBL_241:
        MOVEQ #0,D0
LBL_242:
        TST.L D0
        BEQ.W LBL_243
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_235
LBL_243:
LBL_240:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_236
LBL_237:
        MOVEQ #0,D0
        BRA.W LBL_235
LBL_235:
        UNLK A6
        RTS
        ; func rtUiScrollbarAction  (JT slot 322)
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
LBL_3:
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
        BEQ.W LBL_245
        BRA.W LBL_244
LBL_245:
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
        JSR 1602(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_246
        BRA.W LBL_244
LBL_246:
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
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_247
        BRA.W LBL_244
LBL_247:
        MOVE.L -26(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_248
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
        BEQ.W LBL_250
        MOVEQ #0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_251
LBL_250:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_252
        MOVEQ #8,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_253
LBL_252:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_254
        MOVEQ #0,D1
        MOVE.L -38(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_255
LBL_254:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_256
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_257
LBL_256:
        BRA.W LBL_244
LBL_257:
LBL_255:
LBL_253:
LBL_251:
        BRA.W LBL_249
LBL_248:
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
        BEQ.W LBL_258
        MOVEQ #1,D0
        MOVE.L D0,-42(A6)
LBL_258:
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
        BEQ.W LBL_259
        MOVEQ #0,D1
        MOVE.L -42(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_260
LBL_259:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
        MOVE.L -42(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_262
LBL_261:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_263
        MOVEQ #0,D1
        MOVE.L -46(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_264
LBL_263:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_265
        MOVE.L -46(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_266
LBL_265:
        BRA.W LBL_244
LBL_266:
LBL_264:
LBL_262:
LBL_260:
LBL_249:
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
        BEQ.W LBL_267
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
LBL_267:
        MOVE.L -54(A6),D1
        MOVE.L -58(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        MOVE.L -58(A6),D0
        MOVE.L D0,-54(A6)
LBL_268:
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
        BEQ.W LBL_269
        BRA.W LBL_244
LBL_269:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_270
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_271
LBL_270:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_271:
LBL_244:
        UNLK A6
        RTS
        ; func rtUiHandleScrollbarClick  (JT slot 323)
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
LBL_4:
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
        MOVE.B -60(A5),D0
        TST.L D0
        BEQ.W LBL_273
        MOVE.L 12(A6),D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_278
        MOVE.L 12(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_279
LBL_278:
        MOVEQ #1,D0
LBL_279:
        TST.L D0
        BNE.W LBL_276
        MOVE.L 12(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_277
LBL_276:
        MOVEQ #1,D0
LBL_277:
        TST.L D0
        BNE.W LBL_274
        MOVE.L 12(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_275
LBL_274:
        MOVEQ #1,D0
LBL_275:
        TST.L D0
        BEQ.W LBL_280
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #8,A7
LBL_280:
        BRA.W LBL_272
LBL_273:
        MOVE.L 12(A6),D1
        MOVE.L #129,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
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
        BEQ.W LBL_283
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
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D1
        MOVE.L -10(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_284
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_285
LBL_284:
        MOVEQ #0,D0
LBL_285:
        TST.L D0
        BEQ.W LBL_286
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_287
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
        BRA.W LBL_288
LBL_287:
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
LBL_288:
LBL_286:
LBL_283:
        BRA.W LBL_282
LBL_281:
        CLR.W -(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA 5306(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        DC.W $A968  ; UiTrackControl
        MOVE.W (A7)+,D0
        EXT.L D0
LBL_282:
LBL_272:
        UNLK A6
        RTS
        ; func rtUiTeIdleFront  (JT slot 324)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local te : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
LBL_5:
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
        JSR 1602(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_290
        BRA.W LBL_289
LBL_290:
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
        BEQ.W LBL_291
        BRA.W LBL_289
LBL_291:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_292
        BRA.W LBL_289
LBL_292:
        JSR 2194(A5)
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
LBL_289:
        UNLK A6
        RTS
        ; func rtUiStdEditPaste  (JT slot 325)
        ;   param inst : 12(A6)  size 4
        ;   param te : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local teMp : -8(A6)  size 4
        ;   local newLen : -12(A6)  size 4
        ;   local kind : -16(A6)  size 4
LBL_6:
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
        MOVE.L D0,-4(A6)
        JSR 2498(A5)
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
        JSR 2514(A5)
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
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_294
        MOVE.L -12(A6),D1
        MOVE.L #32000,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_295
LBL_294:
        MOVEQ #0,D0
LBL_295:
        TST.L D0
        BEQ.W LBL_296
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        BRA.W LBL_297
LBL_296:
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
        JSR 2554(A5)
        ADDA.W #10,A7
LBL_297:
LBL_293:
        UNLK A6
        RTS
        ; func rtUiIntToPStr  (JT slot 326)
        ;   param n : 12(A6)  size 4
        ;   param out255 : 8(A6)  size 4
        ;   local u : -4(A6)  size 4
        ;   local d : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local len : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
        ;   local t : -26(A6)  size 4
LBL_7:
        LINK A6,#-78
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-10(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_299
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_299:
LBL_300:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_301
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_193
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        MOVEQ #0,D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
LBL_302:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-14(A6)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_192
        MOVE.L D0,-4(A6)
        BRA.W LBL_300
LBL_301:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_303
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-14(A6)
LBL_303:
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_304:
        MOVE.L -18(A6),D1
        MOVE.L -22(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_305
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -18(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-26(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -18(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -22(A6),D0
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
        MOVE.L -22(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
        BRA.W LBL_304
LBL_305:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_298:
        UNLK A6
        RTS
        ; func rtUiPopupAt  (JT slot 327)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_8:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_306
LBL_306:
        UNLK A6
        RTS
        ; func rtUiSetPopupAt  (JT slot 328)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_307:
        UNLK A6
        RTS
        ; func rtUiPopupSelAt  (JT slot 329)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_10:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 104(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_308
LBL_308:
        UNLK A6
        RTS
        ; func rtUiSetPopupSelAt  (JT slot 330)
        ;   param w : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
LBL_11:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 104(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_309:
        UNLK A6
        RTS
        ; func rtUiPopupBoxInto  (JT slot 331)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_12:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2098(A5)
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
        JSR 2106(A5)
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
        BEQ.W LBL_311
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
        BEQ.W LBL_312
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
LBL_312:
LBL_311:
LBL_310:
        UNLK A6
        RTS
        ; func rtUiTableFillWidth  (JT slot 332)
        ;   param colsOff : 16(A6)  size 4
        ;   param nCols : 12(A6)  size 4
        ;   param totalW : 8(A6)  size 4
        ;   local fixedSum : -4(A6)  size 4
        ;   local k : -8(A6)  size 4
        ;   local fillW : -12(A6)  size 4
LBL_13:
        LINK A6,#-64
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
LBL_314:
        MOVE.L -8(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_315
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #8,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_316
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_316:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_314
LBL_315:
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
        BEQ.W LBL_317
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_317:
        MOVE.L -12(A6),D0
        BRA.W LBL_313
LBL_313:
        UNLK A6
        RTS
        ; func rtUiFixedToStr  (JT slot 333)
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
        LINK A6,#-82
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
        BEQ.W LBL_319
        MOVEQ #0,D1
        MOVE.L 12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_320
LBL_319:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6(A6)
LBL_320:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-10(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-14(A6)
        MOVE.L -6(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L -6(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #10000,D0
        BSR.W LBL_191
        MOVE.L D0,D1
        MOVE.L #65536,D0
        BSR.W LBL_192
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_321
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
LBL_321:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_322:
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
        BEQ.W LBL_323
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
        BRA.W LBL_322
LBL_323:
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
LBL_324:
        MOVE.L -26(A6),D1
        MOVE.L -30(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
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
        BRA.W LBL_324
LBL_325:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_326:
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
        BEQ.W LBL_327
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
        BRA.W LBL_326
LBL_327:
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
LBL_318:
        UNLK A6
        RTS
        ; func rtUiIntFieldLoad  (JT slot 334)
        ;   param base : 12(A6)  size 4
        ;   param ftype : 8(A6)  size 4
        ;   local v : -4(A6)  size 4
LBL_15:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_329
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_328
LBL_329:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_330
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_328
LBL_330:
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_331
        MOVE.L -4(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_332
LBL_331:
        MOVEQ #0,D0
LBL_332:
        TST.L D0
        BEQ.W LBL_333
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_333:
        MOVE.L -4(A6),D0
        BRA.W LBL_328
LBL_328:
        UNLK A6
        RTS
        ; func rtUiTableTextX  (JT slot 335)
        ;   param left : 24(A6)  size 4
        ;   param colW : 20(A6)  size 4
        ;   param txt : 16(A6)  size 4
        ;   param n : 12(A6)  size 4
        ;   param align : 8(A6)  size 4
        ;   local tw : -4(A6)  size 4
LBL_16:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_335
        MOVE.L 24(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        BRA.W LBL_334
LBL_335:
        CLR.W -(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A886  ; UiTextWidth
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_336
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D1
        MOVE.L -4(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_192
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_334
LBL_336:
        MOVE.L 24(A6),D1
        MOVE.L 20(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_334
LBL_334:
        UNLK A6
        RTS
        ; func rtUiTableDrawField  (JT slot 336)
        ;   param rec : 24(A6)  size 4
        ;   param layoutOff : 20(A6)  size 4
        ;   param fieldIdx : 16(A6)  size 4
        ;   param colRect : 12(A6)  size 4
        ;   param align : 8(A6)  size 4
        ;   local base : -4(A6)  size 4
        ;   local ftype : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local buf : -16(A6)  size 4
        ;   local txt : -20(A6)  size 4
        ;   local n : -24(A6)  size 4
        ;   local enumCount : -28(A6)  size 4
        ;   local enumLabelsOff : -32(A6)  size 4
        ;   local enumValuesOff : -36(A6)  size 4
        ;   local k : -40(A6)  size 4
LBL_17:
        LINK A6,#-92
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
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_338
        BRA.W LBL_337
LBL_338:
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1450(A5)
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_339
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        BRA.W LBL_340
LBL_339:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_341
        MOVE.L -8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_342
LBL_341:
        MOVEQ #1,D0
LBL_342:
        TST.L D0
        BEQ.W LBL_343
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        BRA.W LBL_344
LBL_343:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_345
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        BRA.W LBL_346
LBL_345:
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_347
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_349
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #195,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_349:
        BRA.W LBL_348
LBL_347:
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_350
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_351
LBL_350:
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_352
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1482(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        LEA LBL_121(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-40(A6)
LBL_353:
        MOVE.L -40(A6),D1
        MOVE.L -28(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_354
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_355
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1498(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_356
LBL_355:
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
LBL_356:
        BRA.W LBL_353
LBL_354:
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
LBL_352:
LBL_351:
LBL_348:
LBL_346:
LBL_344:
LBL_340:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_357
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
LBL_357:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
        BSR.W LBL_41
        MOVE.L D0,-(A7)
        DC.W $A88B  ; UiGetFontInfo
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDA.W #20,A7
        MOVE.W D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -58(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
LBL_358:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_359
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_359:
LBL_337:
        UNLK A6
        RTS
        ; func rtUiTableRowH  (JT slot 337)
        ;   local fi : -4(A6)  size 4
LBL_18:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_41
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A88B  ; UiGetFontInfo
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        BRA.W LBL_360
LBL_360:
        UNLK A6
        RTS
        ; func rtUiTableHeaderH  (JT slot 338)
LBL_19:
        LINK A6,#-52
        BSR.W LBL_18
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        BRA.W LBL_361
LBL_361:
        UNLK A6
        RTS
        ; func rtUiMakeLdefStub  (JT slot 339)
        ;   local h : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local addr : -12(A6)  size 4
LBL_20:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #6,D0
        MOVE.L D0,-(A7)
        JSR 1538(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_363
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_363:
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
        LEA 5314(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 1970(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1706(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1714(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_362
LBL_362:
        UNLK A6
        RTS
        ; func rtUiLdefDraw  (JT slot 340)
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
        ;   local recH : -48(A6)  size 4
        ;   local hstate : -52(A6)  size 4
        ;   local fillW : -56(A6)  size 4
        ;   local x : -60(A6)  size 4
        ;   local k : -64(A6)  size 4
        ;   local w : -68(A6)  size 4
        ;   local colRect : -72(A6)  size 4
        ;   local saveClip : -76(A6)  size 4
        ;   local stP : -80(A6)  size 4
        ;   local fmtId : -84(A6)  size 4
        ;   local locked : -86(A6)  size 2
        ;   local inst : -90(A6)  size 4
LBL_21:
        LINK A6,#-142
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
        MOVE.B D0,-86(A6)
        MOVEQ #0,D0
        MOVE.L D0,-90(A6)
        MOVE.L 30(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_365
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D1
        MOVEQ #68,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-80(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1330(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1354(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVEQ #0,D0
        MOVE.L D0,-90(A6)
        MOVE.L -80(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_367
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1602(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-90(A6)
LBL_367:
        MOVE.L -90(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_368
        MOVE.L -90(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #8,A7
LBL_368:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 5226(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        JSR 1706(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_369
        MOVE.L -40(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_370
LBL_369:
        MOVEQ #0,D0
LBL_370:
        TST.L D0
        BEQ.W LBL_371
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D1
        MOVEQ #2,D0
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
        MOVE.L D0,-56(A6)
        MOVE.L 24(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-60(A6)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-52(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVEQ #1,D0
        MOVE.B D0,-86(A6)
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
LBL_372:
        MOVE.L -64(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_373
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_374
        MOVE.L -56(A6),D0
        MOVE.L D0,-68(A6)
        BRA.W LBL_375
LBL_374:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
LBL_375:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 24(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        JSR 1962(A5)
        MOVE.L D0,-76(A6)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87A  ; UiGetClip
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87B  ; UiClipRect
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -84(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 314(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 1402(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 1410(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDA.W #20,A7
        BRA.W LBL_377
LBL_376:
        MOVE.L -80(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_378
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 314(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        JSR 5050(A5)
        ADDA.W #32,A7
        MOVEQ #0,D0
        MOVE.B D0,-86(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_379
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-48(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-52(A6)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVEQ #1,D0
        MOVE.B D0,-86(A6)
        BRA.W LBL_380
LBL_379:
        MOVE.L -20(A6),D0
        MOVE.L D0,-64(A6)
LBL_380:
LBL_378:
LBL_377:
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A879  ; UiSetClip
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8D9  ; UiDisposeRgn
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -60(A6),D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        MOVE.L -64(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_372
LBL_373:
        CLR.L D0
        MOVE.B -86(A6),D0
        TST.L D0
        BEQ.W LBL_381
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
LBL_381:
LBL_371:
        MOVE.L -90(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_382
        BSR.W LBL_44
LBL_382:
        CLR.L D0
        MOVE.B 28(A6),D0
        TST.L D0
        BEQ.W LBL_383
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_383:
        BRA.W LBL_366
LBL_365:
        MOVE.L 30(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_384
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_384:
LBL_366:
LBL_364:
        UNLK A6
        RTS
        ; func rtUiTableRelayout  (JT slot 341)
        ;   param inst : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local lh : -8(A6)  size 4
        ;   local lhMp : -12(A6)  size 4
        ;   local box : -16(A6)  size 4
        ;   local listRect : -20(A6)  size 4
        ;   local headerH : -24(A6)  size 4
        ;   local cellW : -28(A6)  size 4
LBL_22:
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_386
        BRA.W LBL_385
LBL_386:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2098(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #8,A7
        BSR.W LBL_19
        MOVE.L D0,-24(A6)
        BSR.W LBL_44
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_387
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_387:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A8A9  ; UiInsetRect
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #15,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_388
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_388:
        MOVE.L -20(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_389
        MOVE.L -20(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_389:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        MOVEQ #1,D0
        MOVE.L D0,-28(A6)
LBL_390:
        MOVE.L -12(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -28(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
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
LBL_385:
        UNLK A6
        RTS
        ; func rtUiTableGetSelected  (JT slot 342)
        ;   param lh : 8(A6)  size 4
        ;   local lhMp : -4(A6)  size 4
        ;   local count : -8(A6)  size 4
        ;   local row : -12(A6)  size 4
        ;   local cell : -16(A6)  size 4
        ;   local found : -20(A6)  size 4
LBL_23:
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
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_392:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_393
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
        BEQ.W LBL_394
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_395
LBL_394:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
LBL_395:
        BRA.W LBL_392
LBL_393:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A6),D0
        BRA.W LBL_391
LBL_391:
        UNLK A6
        RTS
        ; func rtUiTableSelectExclusive  (JT slot 343)
        ;   param lh : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local cur : -4(A6)  size 4
LBL_24:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_397
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
LBL_397:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_398
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
LBL_398:
LBL_396:
        UNLK A6
        RTS
        ; func rtUiTableHit  (JT slot 344)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local lh : -16(A6)  size 4
LBL_25:
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
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_400:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_402
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_404
LBL_403:
        MOVEQ #0,D0
LBL_404:
        TST.L D0
        BEQ.W LBL_405
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_399
LBL_405:
LBL_402:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_400
LBL_401:
        MOVEQ #0,D0
        BRA.W LBL_399
LBL_399:
        UNLK A6
        RTS
        ; func rtUiTableFireSelect  (JT slot 345)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_26:
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
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_63
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 5194(A5)
        ADDA.W #24,A7
LBL_406:
        UNLK A6
        RTS
        ; func rtUiTableFireDblclick  (JT slot 346)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_27:
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
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_63
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 5194(A5)
        ADDA.W #24,A7
LBL_407:
        UNLK A6
        RTS
        ; func rtUiTableClick  (JT slot 347)
        ;   param inst : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param mods : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local lh : -8(A6)  size 4
        ;   local lhMp : -12(A6)  size 4
        ;   local row : -16(A6)  size 4
        ;   local dbl : -18(A6)  size 2
LBL_28:
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
        MOVE.L 20(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B -60(A5),D0
        TST.L D0
        BEQ.W LBL_409
        MOVE.L -12(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1706(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
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
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_192
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_410
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_410:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDA.W #12,A7
        CLR.L D0
        MOVE.B -62(A5),D0
        TST.L D0
        BEQ.W LBL_411
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
LBL_411:
        BRA.W LBL_408
LBL_409:
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
        BSR.W LBL_23
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDA.W #12,A7
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_412
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
LBL_412:
LBL_408:
        UNLK A6
        RTS
        ; func rtUiTableStOf  (JT slot 348)
        ;   param lh : 8(A6)  size 4
LBL_29:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #68,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_413
LBL_413:
        UNLK A6
        RTS
        ; func rtUiTableInitState  (JT slot 349)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param lh : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local tableOff : -8(A6)  size 4
        ;   local stP : -12(A6)  size 4
        ;   local st : -16(A6)  size 4
LBL_30:
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
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1002(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVEQ #48,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_415:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_416
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_416:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1330(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 5226(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 354(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #68,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_414:
        UNLK A6
        RTS
        ; func rtUiTableFreeState  (JT slot 350)
        ;   param lh : 8(A6)  size 4
        ;   local stP : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
LBL_31:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_418
        BRA.W LBL_417
LBL_418:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #68,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_419:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_417:
        UNLK A6
        RTS
        ; func rtUiTableSetMark  (JT slot 351)
        ;   param lh : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local stP : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
        ;   local m : -12(A6)  size 4
LBL_32:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        BRA.W LBL_420
LBL_421:
        MOVE.L 8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_422
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #76,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_423
LBL_422:
        MOVEQ #1,D0
LBL_423:
        TST.L D0
        BEQ.W LBL_424
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-12(A6)
LBL_424:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 370(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_420:
        UNLK A6
        RTS
        ; func rtUiTableSyncOne  (JT slot 352)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local lh : -8(A6)  size 4
        ;   local lhMp : -12(A6)  size 4
        ;   local tableOff : -16(A6)  size 4
        ;   local rows : -20(A6)  size 4
        ;   local stP : -24(A6)  size 4
        ;   local st : -28(A6)  size 4
        ;   local gen : -32(A6)  size 4
        ;   local dataCount : -36(A6)  size 4
        ;   local lmCount : -40(A6)  size 4
        ;   local hstate : -44(A6)  size 4
        ;   local savedPort : -48(A6)  size 4
LBL_33:
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        BRA.W LBL_425
LBL_426:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_427
        BRA.W LBL_425
LBL_427:
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1002(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1330(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 5226(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 354(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_428:
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 354(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #76,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
        MOVE.L -36(A6),D1
        MOVE.L -40(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_430
LBL_429:
        MOVEQ #0,D0
LBL_430:
        TST.L D0
        BEQ.W LBL_431
        BRA.W LBL_425
LBL_431:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        JSR 2194(A5)
        MOVE.L D0,-48(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -36(A6),D1
        MOVE.L -40(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        CLR.W -(A7)
        MOVE.L -36(A6),D1
        MOVE.L -40(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #8,-(A7)
        DC.W $A9E7  ; UiLAddRow
        MOVE.W (A7)+,D0
        EXT.L D0
        BRA.W LBL_433
LBL_432:
        MOVE.L -36(A6),D1
        MOVE.L -40(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
        MOVE.L -40(A6),D1
        MOVE.L -36(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #36,-(A7)
        DC.W $A9E7  ; UiLDelRow
LBL_434:
LBL_433:
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 362(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 362(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
LBL_435:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-44(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_425:
        UNLK A6
        RTS
        ; func rtUiTablesSync  (JT slot 353)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local i : -20(A6)  size 4
LBL_34:
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
LBL_437:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_438
        MOVE.L -4(A6),D1
        MOVEQ #108,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVE.L #2001,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
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
        JSR 850(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_440:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_442
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
LBL_442:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_440
LBL_441:
LBL_439:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_437
LBL_438:
LBL_436:
        UNLK A6
        RTS
        ; func rtUiPopupHit  (JT slot 354)
        ;   param inst : 16(A6)  size 4
        ;   param localPt : 12(A6)  size 4
        ;   param outIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_35:
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
        JSR 850(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_444:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_448
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_449
LBL_448:
        MOVEQ #0,D0
LBL_449:
        TST.L D0
        BEQ.W LBL_446
        CLR.W -(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2098(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A8AD  ; UiPtInRect
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        BRA.W LBL_447
LBL_446:
        MOVEQ #0,D0
LBL_447:
        TST.L D0
        BEQ.W LBL_450
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_443
LBL_450:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_444
LBL_445:
        MOVEQ #0,D0
        BRA.W LBL_443
LBL_443:
        UNLK A6
        RTS
        ; func rtUiPopupAssertAlive  (JT slot 355)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local mh : -8(A6)  size 4
        ;   local formOff : -12(A6)  size 4
        ;   local fieldIndex : -16(A6)  size 4
        ;   local expect : -20(A6)  size 4
LBL_36:
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
        MOVE.L D0,-4(A6)
        CLR.L -(A7)
        MOVE.L #1000,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A949  ; UiGetMenuHandle
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_452
        LEA LBL_124(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_452:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_453
        LEA LBL_125(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_453:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 874(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1322(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_455
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
LBL_455:
LBL_454:
        CLR.W -(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A950  ; UiCountMItems
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_456
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_456:
LBL_451:
        UNLK A6
        RTS
        ; func rtUiPopupPick  (JT slot 356)
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param newIndex : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_37:
        LINK A6,#-56
        MOVEQ #0,D0
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
        BEQ.W LBL_458
        BRA.W LBL_457
LBL_458:
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
        JSR 2098(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_117(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_63
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 5194(A5)
        ADDA.W #24,A7
LBL_457:
        UNLK A6
        RTS
        ; func rtUiPopupClick  (JT slot 357)
        ;   param inst : 12(A6)  size 4
        ;   param pIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local box : -8(A6)  size 4
        ;   local anchor : -12(A6)  size 4
        ;   local result : -16(A6)  size 4
        ;   local newItem : -20(A6)  size 4
        ;   local kindSlot : -24(A6)  size 4
        ;   local valSlot : -28(A6)  size 4
LBL_38:
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
        CLR.L D0
        MOVE.B -60(A5),D0
        TST.L D0
        BEQ.W LBL_460
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_461:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDA.W #12,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_459
LBL_460:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDA.W #12,A7
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
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
        BSR.W LBL_8
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
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
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A80B  ; UiPopUpMenuSelect
        MOVE.L (A7)+,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1714(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_462
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDA.W #12,A7
LBL_462:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_459:
        UNLK A6
        RTS
        ; func rtUiTableScrollTo  (JT slot 358)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param row : 8(A6)  size 4
        ;   local lh : -4(A6)  size 4
        ;   local count : -8(A6)  size 4
        ;   local r : -12(A6)  size 4
LBL_39:
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
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_464
        BRA.W LBL_463
LBL_464:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #76,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        BRA.W LBL_463
LBL_465:
        MOVE.L 8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_466
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
LBL_466:
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_467:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #80,-(A7)
        DC.W $A9E7  ; UiLScroll
LBL_463:
        UNLK A6
        RTS
        ; func rtUiTableSetSel  (JT slot 359)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local count : -12(A6)  size 4
        ;   local lh : -16(A6)  size 4
        ;   local hstate : -20(A6)  size 4
        ;   local tableOff : -24(A6)  size 4
        ;   local rowsIdx : -28(A6)  size 4
        ;   local rowsAddr : -32(A6)  size 4
        ;   local rows : -36(A6)  size 4
        ;   local row : -40(A6)  size 4
LBL_40:
        LINK A6,#-92
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2570(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1002(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 1330(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 5226(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_469
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-40(A6)
LBL_469:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A069  ; UiHGetState
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -16(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDA.W #16,A7
LBL_468:
        UNLK A6
        RTS
        ; func rtUiFontScratchGet  (JT slot 360)
        ;   local rgn : -4(A6)  size 4
LBL_41:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -58(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        JSR 1962(A5)
        MOVE.L D0,-4(A6)
        MOVEQ #24,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-58(A5)
        MOVE.L -58(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_471:
        MOVE.L -58(A5),D0
        BRA.W LBL_470
LBL_470:
        UNLK A6
        RTS
        ; func rtUiFontSave  (JT slot 361)
        ;   local sc : -4(A6)  size 4
        ;   local port : -8(A6)  size 4
LBL_42:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_41
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A874  ; UiGetPort
        MOVE.L -4(A6),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #68,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #74,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_472:
        UNLK A6
        RTS
        ; func rtUiFontApply  (JT slot 362)
        ;   param instV : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local p : -8(A6)  size 4
LBL_43:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_42
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 132(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_474
        BRA.W LBL_473
LBL_474:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 132(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A887  ; UiTextFont
LBL_475:
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_476
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A88A  ; UiTextSize
LBL_476:
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A888  ; UiTextFace
LBL_473:
        UNLK A6
        RTS
        ; func rtUiFontRestore  (JT slot 363)
        ;   local sc : -4(A6)  size 4
LBL_44:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -58(A5),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A887  ; UiTextFont
        MOVE.L -4(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A888  ; UiTextFace
        MOVE.L -4(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A88A  ; UiTextSize
LBL_477:
        UNLK A6
        RTS
        ; func rtUiFontLineH  (JT slot 364)
        ;   param fi : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
LBL_45:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
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
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_479
        MOVEQ #1,D0
        BRA.W LBL_478
LBL_479:
        MOVE.L -4(A6),D0
        BRA.W LBL_478
LBL_478:
        UNLK A6
        RTS
        ; func rtUiJiggleTick  (JT slot 365)
LBL_46:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -64(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_481
        CLR.L D0
        MOVE.B -66(A5),D0
        BRA.W LBL_482
LBL_481:
        MOVEQ #1,D0
LBL_482:
        TST.L D0
        BEQ.W LBL_483
        BRA.W LBL_480
LBL_483:
        MOVEQ #1,D0
        MOVE.B D0,-66(A5)
        MOVE.L #2147483632,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A04C  ; UiCompactMem
        MOVEQ #0,D0
        MOVE.B D0,-66(A5)
LBL_480:
        UNLK A6
        RTS
        ; func rtUiScriptJiggle  (JT slot 366)
LBL_47:
        LINK A6,#-52
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_485
        MOVEQ #1,D0
        MOVE.B D0,-64(A5)
        BRA.W LBL_486
LBL_485:
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_487
        MOVEQ #0,D0
        MOVE.B D0,-64(A5)
        BRA.W LBL_488
LBL_487:
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_488:
LBL_486:
LBL_484:
        UNLK A6
        RTS
        ; func rtUiAnswerInit  (JT slot 367)
LBL_48:
        LINK A6,#-52
        MOVE.L -70(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
        MOVEQ #32,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-70(A5)
        MOVEQ #32,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-74(A5)
        MOVE.L #2048,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-78(A5)
LBL_490:
LBL_489:
        UNLK A6
        RTS
        ; func rtUiAnswerCheckRoom  (JT slot 368)
LBL_49:
        LINK A6,#-52
        BSR.W LBL_48
        MOVE.L -86(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        BSR.W LBL_193
        MOVE.L D0,D1
        MOVE.L -82(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_492
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_492:
LBL_491:
        UNLK A6
        RTS
        ; func rtUiAnswerPushVal  (JT slot 369)
        ;   param kind : 12(A6)  size 4
        ;   param val : 8(A6)  size 4
LBL_50:
        LINK A6,#-52
        BSR.W LBL_49
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A5),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A5),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -86(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        BSR.W LBL_193
        MOVE.L D0,-86(A5)
LBL_493:
        UNLK A6
        RTS
        ; func rtUiAnswerPushPath  (JT slot 370)
        ;   param kind : 12(A6)  size 4
        ;   param srcC : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local dst : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_51:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        BSR.W LBL_49
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_495:
        MOVE.L 8(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_496
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_495
LBL_496:
        MOVE.L -4(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_497
        MOVE.L #255,D0
        MOVE.L D0,-4(A6)
LBL_497:
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A5),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -78(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A5),D1
        MOVE.L #256,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_498:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_499
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
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
        BRA.W LBL_498
LBL_499:
        MOVE.L -86(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        BSR.W LBL_193
        MOVE.L D0,-86(A5)
LBL_494:
        UNLK A6
        RTS
        ; func rtUiAnswerPopIdx  (JT slot 371)
        ;   local idx : -4(A6)  size 4
LBL_52:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_48
        MOVE.L -82(A5),D1
        MOVE.L -86(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_501
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_501:
        MOVE.L -82(A5),D0
        MOVE.L D0,-4(A6)
        MOVE.L -82(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        BSR.W LBL_193
        MOVE.L D0,-82(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_500
LBL_500:
        UNLK A6
        RTS
        ; func rtUiAnswerPop  (JT slot 372)
        ;   param outKind : 12(A6)  size 4
        ;   param outVal : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_53:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_52
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_502:
        UNLK A6
        RTS
        ; func rtUiTextAppendStrSafe  (JT slot 373)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_54:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_504
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
LBL_504:
LBL_503:
        UNLK A6
        RTS
        ; func rtUiIntToText  (JT slot 374)
        ;   param v : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local digits : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local d : -22(A6)  size 4
LBL_55:
        LINK A6,#-74
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_506
        MOVE.L -8(A6),D0
        NEG.L D0
        MOVE.L D0,-8(A6)
LBL_506:
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_507
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_508
LBL_507:
LBL_509:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_510
        MOVE.L -8(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_193
        MOVE.L D0,-22(A6)
        MOVE.L -14(A6),D1
        MOVE.L -18(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D1
        MOVE.L -22(A6),D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_192
        MOVE.L D0,-8(A6)
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_509
LBL_510:
LBL_508:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_511
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
LBL_511:
LBL_512:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_513
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D1
        MOVE.L -18(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        BRA.W LBL_512
LBL_513:
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        BRA.W LBL_505
LBL_505:
        UNLK A6
        RTS
        ; func rtUiTextAppendInt  (JT slot 375)
        ;   param t : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local nt : -4(A6)  size 4
LBL_56:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
LBL_514:
        UNLK A6
        RTS
        ; func rtUiEmitLine  (JT slot 376)
        ;   param t : 8(A6)  size 4
LBL_57:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -88(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_516
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4946(A5)
        ADDQ.L #4,A7
LBL_516:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
LBL_515:
        UNLK A6
        RTS
        ; func rtUiTraceInit  (JT slot 377)
        ;   local nWins : -4(A6)  size 4
        ;   local nMh : -8(A6)  size 4
LBL_58:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        JSR 698(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_518
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-92(A5)
        BRA.W LBL_519
LBL_518:
        MOVEQ #0,D0
        MOVE.L D0,-92(A5)
LBL_519:
        JSR 730(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-100(A5)
        BRA.W LBL_521
LBL_520:
        MOVEQ #0,D0
        MOVE.L D0,-100(A5)
LBL_521:
        MOVEQ #1,D0
        MOVE.B D0,-102(A5)
        MOVEQ #0,D0
        MOVE.B D0,-104(A5)
        MOVEQ #0,D0
        MOVE.L D0,-96(A5)
LBL_517:
        UNLK A6
        RTS
        ; func rtUiTraceNextId  (JT slot 378)
        ;   param winIdx : 8(A6)  size 4
        ;   local v : -4(A6)  size 4
LBL_59:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -92(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_523
        MOVEQ #0,D0
        BRA.W LBL_522
LBL_523:
        MOVE.L -92(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -92(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_522
LBL_522:
        UNLK A6
        RTS
        ; func rtUiTraceOpen  (JT slot 379)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
        ;   local id : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
LBL_60:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
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
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_525
        BRA.W LBL_524
LBL_525:
        JSR 178(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_133(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_524:
        UNLK A6
        RTS
        ; func rtUiTraceClose  (JT slot 380)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_61:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_527
        BRA.W LBL_526
LBL_527:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_526:
        UNLK A6
        RTS
        ; func rtUiTraceFire1  (JT slot 381)
        ;   param namePtr : 12(A6)  size 4
        ;   param event : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_62:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_529
        BRA.W LBL_528
LBL_529:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_528:
        UNLK A6
        RTS
        ; func rtUiTraceFire2  (JT slot 382)
        ;   param namePtr : 16(A6)  size 4
        ;   param wnamePtr : 12(A6)  size 4
        ;   param event : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_63:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_531
        BRA.W LBL_530
LBL_531:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_530:
        UNLK A6
        RTS
        ; func rtUiTraceMenuSelectFor  (JT slot 383)
        ;   param k : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_64:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        BRA.W LBL_532
LBL_533:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_532:
        UNLK A6
        RTS
        ; func rtUiTraceEveryFire  (JT slot 384)
        ;   param n : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_65:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_535
        BRA.W LBL_534
LBL_535:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_534:
        UNLK A6
        RTS
        ; func rtUiTraceDimCheck  (JT slot 385)
        ;   param k : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local prev : -4(A6)  size 4
        ;   local enableInt : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_66:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_537
        MOVEQ #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_538
LBL_537:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_538:
        MOVE.L -100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_539
        BRA.W LBL_536
LBL_539:
        MOVE.L -100(A5),D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -102(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_542
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_543
LBL_542:
        MOVEQ #0,D0
LBL_543:
        TST.L D0
        BEQ.W LBL_540
        JSR 4746(A5)
        BRA.W LBL_541
LBL_540:
        MOVEQ #0,D0
LBL_541:
        TST.L D0
        BEQ.W LBL_544
        JSR 178(A5)
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_544:
        MOVE.L -100(A5),D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_536:
        UNLK A6
        RTS
        ; func rtUiTraceStdEditDim  (JT slot 386)
        ;   param mask : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local j : -8(A6)  size 4
LBL_67:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -102(A5),D0
        TST.L D0
        BNE.W LBL_548
        CLR.L D0
        MOVE.B -104(A5),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_549
LBL_548:
        MOVEQ #1,D0
LBL_549:
        TST.L D0
        BNE.W LBL_546
        JSR 4746(A5)
        EORI.L #1,D0
        BRA.W LBL_547
LBL_546:
        MOVEQ #1,D0
LBL_547:
        TST.L D0
        BEQ.W LBL_550
        MOVE.L 8(A6),D0
        ANDI.L #255,D0
        MOVE.B D0,-104(A5)
        BRA.W LBL_545
LBL_550:
        MOVEQ #3,D0
        MOVE.L D0,-8(A6)
LBL_551:
        MOVE.L -8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_552
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A5),D0
        MOVE.L D0,-(A7)
        JSR 1042(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_553
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_141(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        BRA.W LBL_554
LBL_553:
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_555
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_142(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        BRA.W LBL_556
LBL_555:
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_557
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        BRA.W LBL_558
LBL_557:
        MOVE.L -8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_559
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        BRA.W LBL_560
LBL_559:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
LBL_560:
LBL_558:
LBL_556:
LBL_554:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVE.L -8(A6),D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_551
LBL_552:
        MOVE.L 8(A6),D0
        ANDI.L #255,D0
        MOVE.B D0,-104(A5)
LBL_545:
        UNLK A6
        RTS
        ; func rtUiTraceDimFirstDone  (JT slot 387)
LBL_68:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.B D0,-102(A5)
LBL_561:
        UNLK A6
        RTS
        ; func rtUiTraceFrontCheck  (JT slot 388)
        ;   local wp : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_69:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1594(A5)
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_563
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_564
LBL_563:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_564:
        MOVE.L -8(A6),D1
        MOVE.L -96(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_565
        BRA.W LBL_562
LBL_565:
        MOVE.L -8(A6),D0
        MOVE.L D0,-96(A5)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_566
        JSR 4746(A5)
        BRA.W LBL_567
LBL_566:
        MOVEQ #0,D0
LBL_567:
        TST.L D0
        BEQ.W LBL_568
        JSR 178(A5)
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_146(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_568:
LBL_562:
        UNLK A6
        RTS
        ; func rtUiTraceAbout  (JT slot 389)
        ;   local t : -4(A6)  size 4
LBL_70:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_570
        BRA.W LBL_569
LBL_570:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1218(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1234(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1250(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1266(A5)
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_569:
        UNLK A6
        RTS
        ; func rtUiPropNamePtr  (JT slot 390)
        ;   param prop : 8(A6)  size 4
LBL_71:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_572
        LEA LBL_149(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_572:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_573
        LEA LBL_150(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_573:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_574
        LEA LBL_151(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_574:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_575
        LEA LBL_152(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_575:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_576
        LEA LBL_153(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_576:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
        LEA LBL_154(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_577:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_578
        LEA LBL_155(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_578:
        LEA LBL_121(PC),A0
        MOVE.L A0,D0
        BRA.W LBL_571
LBL_571:
        UNLK A6
        RTS
        ; func rtUiTraceSetStr  (JT slot 391)
        ;   param namePtr : 20(A6)  size 4
        ;   param wnamePtr : 16(A6)  size 4
        ;   param prop : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_72:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_580
        BRA.W LBL_579
LBL_580:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_579:
        UNLK A6
        RTS
        ; func rtUiTraceSetBool  (JT slot 392)
        ;   param namePtr : 18(A6)  size 4
        ;   param wnamePtr : 14(A6)  size 4
        ;   param prop : 10(A6)  size 4
        ;   param v : 8(A6)  size 2
        ;   local t : -4(A6)  size 4
        ;   local vi : -8(A6)  size 4
LBL_73:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_582
        BRA.W LBL_581
LBL_582:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_583
        MOVEQ #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_584
LBL_583:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_584:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 18(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_581:
        UNLK A6
        RTS
        ; func rtUiTraceSetInt  (JT slot 393)
        ;   param namePtr : 20(A6)  size 4
        ;   param wnamePtr : 16(A6)  size 4
        ;   param prop : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_74:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_586
        BRA.W LBL_585
LBL_586:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_585:
        UNLK A6
        RTS
        ; func rtUiTraceInvalid  (JT slot 394)
        ;   param namePtr : 12(A6)  size 4
        ;   param wnamePtr : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_75:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_588
        BRA.W LBL_587
LBL_588:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_587:
        UNLK A6
        RTS
        ; func rtUiTraceAskPath  (JT slot 395)
        ;   param verb : 12(A6)  size 4
        ;   param pathPStr : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_76:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_590
        BRA.W LBL_589
LBL_590:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_158(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_589:
        UNLK A6
        RTS
        ; func rtUiTraceOpenDoc  (JT slot 396)
        ;   param pathPtr : 12(A6)  size 4
        ;   param pathLen : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local pathText : -8(A6)  size 4
LBL_77:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        JSR 4746(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_592
        BRA.W LBL_591
LBL_592:
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        JSR 178(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDA.W #16,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_591:
        UNLK A6
        RTS
        ; func rtUiStrEq  (JT slot 397)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_78:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_594:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_595
        MOVE.L 12(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_596
        MOVEQ #0,D0
        BRA.W LBL_593
LBL_596:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_594
LBL_595:
        MOVE.L 12(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_593
LBL_593:
        UNLK A6
        RTS
        ; func rtUiAtoi  (JT slot 398)
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local neg : -6(A6)  size 2
        ;   local v : -10(A6)  size 4
        ;   local c : -14(A6)  size 4
LBL_79:
        LINK A6,#-66
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #45,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_598
        MOVEQ #1,D0
        MOVE.B D0,-6(A6)
        MOVEQ #1,D0
        MOVE.L D0,-4(A6)
LBL_598:
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
LBL_599:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_600
        MOVE.L 8(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-14(A6)
        MOVE.L -14(A6),D1
        MOVEQ #48,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_601
        MOVE.L -14(A6),D1
        MOVEQ #57,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_602
LBL_601:
        MOVEQ #1,D0
LBL_602:
        TST.L D0
        BEQ.W LBL_603
        BRA.W LBL_600
LBL_603:
        MOVE.L -10(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_191
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D1
        MOVEQ #48,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-10(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_599
LBL_600:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_604
        MOVE.L -10(A6),D0
        NEG.L D0
        MOVE.L D0,-10(A6)
LBL_604:
        MOVE.L -10(A6),D0
        BRA.W LBL_597
LBL_597:
        UNLK A6
        RTS
        ; func rtUiScriptKeyArg  (JT slot 399)
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local allDigits : -6(A6)  size 2
        ;   local c : -10(A6)  size 4
LBL_80:
        LINK A6,#-62
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_606
        MOVEQ #0,D0
        BRA.W LBL_605
LBL_606:
        MOVEQ #1,D0
        MOVE.B D0,-6(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_607:
        MOVE.L 8(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_608
        MOVE.L 8(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-10(A6)
        MOVE.L -10(A6),D1
        MOVEQ #48,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_609
        MOVE.L -10(A6),D1
        MOVEQ #57,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_610
LBL_609:
        MOVEQ #1,D0
LBL_610:
        TST.L D0
        BEQ.W LBL_611
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
LBL_611:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_607
LBL_608:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_612
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        BRA.W LBL_605
LBL_612:
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_605
LBL_605:
        UNLK A6
        RTS
        ; func rtUiTextAppendCStr  (JT slot 400)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local scratch : -8(A6)  size 4
LBL_81:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_614:
        MOVE.L 8(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_615
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_614
LBL_615:
        JSR 178(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDA.W #16,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
LBL_613:
        UNLK A6
        RTS
        ; func rtUiScriptNextLine  (JT slot 401)
        ;   local n : -4(A6)  size 4
LBL_82:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_617
        LEA LBL_190(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-108(A5)
        MOVEQ #1,D0
        MOVE.B D0,-110(A5)
LBL_617:
        MOVE.L -114(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-114(A5)
LBL_618:
LBL_619:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_620
        MOVE.L -108(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_621
        MOVEQ #0,D0
        BRA.W LBL_616
LBL_621:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_622:
        MOVE.L -108(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        MOVE.L -108(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_625
LBL_624:
        MOVEQ #0,D0
LBL_625:
        TST.L D0
        BEQ.W LBL_623
        MOVE.L -4(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_626
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -108(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_626:
        MOVE.L -108(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-108(A5)
        BRA.W LBL_622
LBL_623:
        MOVE.L -108(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        MOVE.L -108(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-108(A5)
LBL_627:
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-118(A5)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_628
        MOVEQ #1,D0
        BRA.W LBL_616
LBL_628:
        BRA.W LBL_619
LBL_620:
        MOVEQ #0,D0
        BRA.W LBL_616
LBL_616:
        UNLK A6
        RTS
        ; func rtUiSkipSpaces  (JT slot 402)
        ;   param p : 8(A6)  size 4
        ;   local q : -4(A6)  size 4
LBL_83:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
LBL_630:
        MOVE.L -4(A6),D1
        MOVE.L -118(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_632
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_633
LBL_632:
        MOVEQ #0,D0
LBL_633:
        TST.L D0
        BEQ.W LBL_631
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_630
LBL_631:
        MOVE.L -4(A6),D0
        BRA.W LBL_629
LBL_629:
        UNLK A6
        RTS
        ; func rtUiCopyToken  (JT slot 403)
        ;   param p : 16(A6)  size 4
        ;   param dst : 12(A6)  size 4
        ;   param maxLen : 8(A6)  size 4
        ;   local q : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_84:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_635:
        MOVE.L -4(A6),D1
        MOVE.L -118(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_637
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_638
LBL_637:
        MOVEQ #0,D0
LBL_638:
        TST.L D0
        BEQ.W LBL_636
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_639
        MOVE.L 12(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_639:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_635
LBL_636:
        MOVE.L 12(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_634
LBL_634:
        UNLK A6
        RTS
        ; func rtUiScriptTokenize  (JT slot 404)
        ;   local p : -4(A6)  size 4
LBL_85:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -122(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_641
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-122(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-126(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-130(A5)
LBL_641:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #63,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #63,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -130(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #63,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
LBL_640:
        UNLK A6
        RTS
        ; func rtUiScriptClick  (JT slot 405)
        ;   param x : 14(A6)  size 4
        ;   param y : 10(A6)  size 4
        ;   param dbl : 8(A6)  size 2
        ;   local ev : -4(A6)  size 4
LBL_86:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.B 8(A6),D0
        MOVE.B D0,-62(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2042(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.B D0,-62(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_642:
        UNLK A6
        RTS
        ; func rtUiScriptDrag  (JT slot 406)
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
LBL_87:
        LINK A6,#-92
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
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-4(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
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
        MOVE.L -12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_644
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_645
LBL_644:
        MOVEQ #1,D0
LBL_645:
        TST.L D0
        BEQ.W LBL_646
        BRA.W LBL_643
LBL_646:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1602(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        BRA.W LBL_643
LBL_647:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1690(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 2018(A5)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_648
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
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2026(A5)
        ADDA.W #16,A7
        BRA.W LBL_643
LBL_648:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_649
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
        BEQ.W LBL_650
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_651
LBL_650:
        MOVEQ #0,D0
LBL_651:
        TST.L D0
        BEQ.W LBL_652
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D4  ; UiTEClick
LBL_652:
        BRA.W LBL_643
LBL_649:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_643:
        UNLK A6
        RTS
        ; func rtUiScriptKey  (JT slot 407)
        ;   param ch : 8(A6)  size 4
        ;   local ev : -4(A6)  size 4
LBL_88:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2050(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_653:
        UNLK A6
        RTS
        ; func rtUiScriptType  (JT slot 408)
        ;   local p : -4(A6)  size 4
LBL_89:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #4,D0
        MOVE.L D0,-4(A6)
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_655
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_655:
LBL_656:
        MOVE.L -4(A6),D1
        MOVE.L -118(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_657
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_656
LBL_657:
LBL_654:
        UNLK A6
        RTS
        ; func rtUiScriptRestOfLine  (JT slot 409)
        ;   param verbLen : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
LBL_90:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_659
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_659:
        MOVE.L -114(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        BRA.W LBL_658
LBL_658:
        UNLK A6
        RTS
        ; func rtUiScriptAnswerChanges  (JT slot 410)
        ;   local v : -4(A6)  size 4
LBL_91:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_661
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_662
LBL_661:
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_663
        MOVEQ #1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_664
LBL_663:
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_665
        MOVEQ #2,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_666
LBL_665:
        LEA LBL_163(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_666:
LBL_664:
LBL_662:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #8,A7
LBL_660:
        UNLK A6
        RTS
        ; func rtUiScriptClose  (JT slot 411)
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
LBL_92:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_668
        BRA.W LBL_667
LBL_668:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1602(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_669
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1674(A5)
        ADDQ.L #4,A7
LBL_669:
LBL_667:
        UNLK A6
        RTS
        ; func rtUiScriptResize  (JT slot 412)
        ;   param w : 12(A6)  size 4
        ;   param h : 8(A6)  size 4
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
LBL_93:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_671
        BRA.W LBL_670
LBL_671:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1602(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_672
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #4,A7
        BRA.W LBL_673
LBL_672:
        MOVEQ #0,D0
LBL_673:
        TST.L D0
        BEQ.W LBL_674
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1938(A5)
        ADDA.W #16,A7
LBL_674:
LBL_670:
        UNLK A6
        RTS
        ; func rtUiScriptZoom  (JT slot 413)
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
LBL_94:
        LINK A6,#-94
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
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_676
        BRA.W LBL_675
LBL_676:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1602(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_677
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 826(A5)
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_678
LBL_677:
        MOVEQ #1,D0
LBL_678:
        TST.L D0
        BEQ.W LBL_679
        BRA.W LBL_675
LBL_679:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 4978(A5)
        ADDQ.L #4,A7
        MOVE.L -12(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
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
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.W D0,-(A7)
        MOVEQ #20,D1
        MOVEQ #19,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -4(A6),D1
        MOVEQ #118,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L -32(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
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
        BEQ.W LBL_680
        MOVEQ #7,D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_681
LBL_680:
        MOVEQ #8,D0
        MOVE.L D0,-40(A6)
LBL_681:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1994(A5)
        ADDA.W #12,A7
LBL_675:
        UNLK A6
        RTS
        ; func rtUiScriptEveryPump  (JT slot 414)
        ;   local i : -4(A6)  size 4
        ;   local due : -8(A6)  size 4
LBL_95:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -38(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_683
        BRA.W LBL_682
LBL_683:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_684:
        MOVE.L -4(A6),D1
        MOVE.L -42(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_685
        MOVE.L -38(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -134(A5),D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_686
        MOVE.L -38(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_191
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -134(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 5210(A5)
        ADDQ.L #4,A7
LBL_686:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_684
LBL_685:
LBL_682:
        UNLK A6
        RTS
        ; func rtUiScriptTick  (JT slot 415)
        ;   param n : 8(A6)  size 4
LBL_96:
        LINK A6,#-52
        MOVE.L -134(A5),D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-134(A5)
        BSR.W LBL_95
        BSR.W LBL_5
        JSR 1914(A5)
LBL_687:
        UNLK A6
        RTS
        ; func rtUiScriptDelay  (JT slot 416)
        ;   param n : 8(A6)  size 4
        ;   local until : -4(A6)  size 4
LBL_97:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L -(A7)
        DC.W $A975  ; UiTickCount
        MOVE.L (A7)+,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_689:
        CLR.L -(A7)
        DC.W $A975  ; UiTickCount
        MOVE.L (A7)+,D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_690
        BSR.W LBL_99
        JSR 4994(A5)
        BRA.W LBL_689
LBL_690:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #4,A7
LBL_688:
        UNLK A6
        RTS
        ; func rtUiScriptMenu  (JT slot 417)
        ;   param m : 12(A6)  size 4
        ;   param itemNum : 8(A6)  size 4
LBL_98:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1874(A5)
        ADDQ.L #4,A7
LBL_691:
        UNLK A6
        RTS
        ; func rtUiPumpPassive  (JT slot 418)
        ;   local ev : -4(A6)  size 4
        ;   local what : -8(A6)  size 4
        ;   local gotEvent : -10(A6)  size 2
LBL_99:
        LINK A6,#-62
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        JSR 5250(A5)
        BSR.W LBL_34
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        CLR.W -(A7)
        MOVE.L #448,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A970  ; UiGetNextEvent
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-10(A6)
LBL_693:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_694
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_695
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1978(A5)
        ADDQ.L #4,A7
        BRA.W LBL_696
LBL_695:
        MOVE.L -8(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_697
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
        JSR 1930(A5)
        ADDQ.L #6,A7
LBL_697:
LBL_696:
        CLR.W -(A7)
        MOVE.L #448,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A970  ; UiGetNextEvent
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        MOVE.B D0,-10(A6)
        BRA.W LBL_693
LBL_694:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_692:
        UNLK A6
        RTS
        ; func rtUiHexDigit  (JT slot 419)
        ;   param d : 8(A6)  size 4
LBL_100:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_699
        MOVEQ #48,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_698
LBL_699:
        MOVEQ #65,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #10,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_698
LBL_698:
        UNLK A6
        RTS
        ; func rtUiHexLineText  (JT slot 420)
        ;   param src : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local b : -12(A6)  size 4
LBL_101:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_701:
        MOVE.L -8(A6),D1
        MOVEQ #64,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_702
        MOVE.L 8(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #15,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #15,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_701
LBL_702:
        MOVE.L -4(A6),D0
        BRA.W LBL_700
LBL_700:
        UNLK A6
        RTS
        ; func rtUiTestSnap  (JT slot 421)
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
LBL_102:
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
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 4986(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #64,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_704
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_704:
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
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
        MOVE.L -24(A6),D1
        MOVE.L -20(A6),D0
        BSR.W LBL_191
        MOVE.L D0,-28(A6)
        JSR 178(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_165(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_705:
        MOVE.L -32(A6),D1
        MOVE.L -28(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_706
        MOVE.L -16(A6),D1
        MOVE.L -32(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_101
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L -32(A6),D1
        MOVEQ #64,D0
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_705
LBL_706:
        LEA LBL_166(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_103
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
LBL_703:
        UNLK A6
        RTS
        ; func rtUiLitLine  (JT slot 422)
        ;   param s : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_103:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 178(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_707
LBL_707:
        UNLK A6
        RTS
        ; func rtUiRunScripted  (JT slot 423)
LBL_104:
        LINK A6,#-52
        MOVEQ #1,D0
        MOVE.B D0,-60(A5)
        DC.W $A852  ; UiHideCursor
LBL_709:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_710
        BSR.W LBL_82
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_711
        JSR 1682(A5)
        BRA.W LBL_708
LBL_711:
        BSR.W LBL_85
        BSR.W LBL_46
        BSR.W LBL_105
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_712
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        JSR 4818(A5)
        ADDQ.L #4,A7
        BSR.W LBL_194
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4826(A5)
        ADDQ.L #4,A7
LBL_712:
        BSR.W LBL_99
        JSR 4994(A5)
        BRA.W LBL_709
LBL_710:
LBL_708:
        UNLK A6
        RTS
        ; func rtUiScriptDispatchLine  (JT slot 424)
LBL_105:
        LINK A6,#-52
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_118(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_714
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -130(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_86
        ADDA.W #10,A7
        BRA.W LBL_715
LBL_714:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_168(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_716
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -130(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        BSR.W LBL_86
        ADDA.W #10,A7
        BRA.W LBL_717
LBL_716:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_718
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -130(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #8,A7
        BRA.W LBL_719
LBL_718:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_720
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
        BRA.W LBL_721
LBL_720:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_722
        BSR.W LBL_89
        BRA.W LBL_723
LBL_722:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_170(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_724
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -130(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        BRA.W LBL_725
LBL_724:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_726
        BSR.W LBL_92
        BRA.W LBL_727
LBL_726:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_728
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -130(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_93
        ADDQ.L #8,A7
        BRA.W LBL_729
LBL_728:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_730
        BSR.W LBL_94
        BRA.W LBL_731
LBL_730:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_174(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_732
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_97
        ADDQ.L #4,A7
        BRA.W LBL_733
LBL_732:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_175(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_734
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #4,A7
        BRA.W LBL_735
LBL_734:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_176(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_736
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_102
        ADDQ.L #4,A7
        BRA.W LBL_737
LBL_736:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_177(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_738
        BSR.W LBL_47
        BRA.W LBL_739
LBL_738:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_178(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_740
        JSR 1682(A5)
        BRA.W LBL_741
LBL_740:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_179(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_742
        BRA.W LBL_743
LBL_742:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_744
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -126(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #8,A7
        BRA.W LBL_745
LBL_744:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_181(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_746
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        BRA.W LBL_747
LBL_746:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_748
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        BRA.W LBL_749
LBL_748:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_750
        BSR.W LBL_91
        BRA.W LBL_751
LBL_750:
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_184(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_752
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #8,A7
        BRA.W LBL_753
LBL_752:
        MOVE.L -122(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_754
        BRA.W LBL_755
LBL_754:
        MOVEQ #0,D0
        BRA.W LBL_713
LBL_755:
LBL_753:
LBL_751:
LBL_749:
LBL_747:
LBL_745:
LBL_743:
LBL_741:
LBL_739:
LBL_737:
LBL_735:
LBL_733:
LBL_731:
LBL_729:
LBL_727:
LBL_725:
LBL_723:
LBL_721:
LBL_719:
LBL_717:
LBL_715:
        MOVEQ #1,D0
        BRA.W LBL_713
LBL_713:
        UNLK A6
        RTS
        ; func nat_UiSFGetFile  (JT slot 425)
        ;   param path255Out : 12(A6)  size 4
        ;   param filter : 8(A6)  size 4
        ;   local rep : -74(A6)  size 74
        ;   local types : -90(A6)  size 16
        ;   local vp : -154(A6)  size 64
        ;   local s : -410(A6)  size 256
        ;   local junk : -414(A6)  size 4
        ;   local flen : -418(A6)  size 4
        ;   local numTypes : -422(A6)  size 4
        ;   local segStart : -426(A6)  size 4
        ;   local i : -430(A6)  size 4
        ;   local segLen : -434(A6)  size 4
        ;   local packed : -438(A6)  size 4
        ;   local codes : -442(A6)  size 4
        ;   local __ret1 : -444(A6)  size 2
LBL_106:
        LINK A6,#-500
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_757:
        CLR.L (A0)+
        DBRA D0,LBL_757
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.B D0,-90(A6)
        MOVEQ #0,D0
        MOVE.B D0,-89(A6)
        MOVEQ #0,D0
        MOVE.B D0,-88(A6)
        MOVEQ #0,D0
        MOVE.B D0,-87(A6)
        MOVEQ #0,D0
        MOVE.B D0,-86(A6)
        MOVEQ #0,D0
        MOVE.B D0,-85(A6)
        MOVEQ #0,D0
        MOVE.B D0,-84(A6)
        MOVEQ #0,D0
        MOVE.B D0,-83(A6)
        MOVEQ #0,D0
        MOVE.B D0,-82(A6)
        MOVEQ #0,D0
        MOVE.B D0,-81(A6)
        MOVEQ #0,D0
        MOVE.B D0,-80(A6)
        MOVEQ #0,D0
        MOVE.B D0,-79(A6)
        MOVEQ #0,D0
        MOVE.B D0,-78(A6)
        MOVEQ #0,D0
        MOVE.B D0,-77(A6)
        MOVEQ #0,D0
        MOVE.B D0,-76(A6)
        MOVEQ #0,D0
        MOVE.B D0,-75(A6)
        LEA -154(A6),A0
        MOVE.W #15,D0
LBL_758:
        CLR.L (A0)+
        DBRA D0,LBL_758
        LEA -410(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-414(A6)
        MOVEQ #0,D0
        MOVE.L D0,-418(A6)
        MOVEQ #0,D0
        MOVE.L D0,-422(A6)
        MOVEQ #0,D0
        MOVE.L D0,-426(A6)
        MOVEQ #0,D0
        MOVE.L D0,-430(A6)
        MOVEQ #0,D0
        MOVE.L D0,-434(A6)
        MOVEQ #0,D0
        MOVE.L D0,-438(A6)
        LEA -442(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 282(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-418(A6)
        MOVE.L -418(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_759
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #42,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_760
LBL_759:
        MOVEQ #0,D0
LBL_760:
        TST.L D0
        BEQ.W LBL_761
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-422(A6)
        BRA.W LBL_762
LBL_761:
        MOVEQ #0,D0
        MOVE.L D0,-426(A6)
        MOVEQ #0,D0
        MOVE.L D0,-430(A6)
LBL_763:
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_764
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_765
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -430(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #44,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_766
LBL_765:
        MOVEQ #1,D0
LBL_766:
        TST.L D0
        BEQ.W LBL_767
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_768
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_769:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_756
LBL_768:
        MOVE.L -430(A6),D1
        MOVE.L -426(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-434(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D1
        MOVE.L -426(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -434(A6),D0
        MOVE.L D0,-(A7)
        JSR 58(A5)
        ADDA.W #12,A7
        MOVE.L D0,-438(A6)
        MOVE.L -438(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_770
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_771:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_756
LBL_770:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -438(A6),D0
        MOVE.L D0,-448(A6)
        LEA -448(A6),A0
        MOVE.L A0,-(A7)
        JSR 386(A5)
        ADDQ.L #8,A7
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-426(A6)
LBL_767:
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-430(A6)
        BRA.W LBL_763
LBL_764:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-422(A6)
        MOVE.L -422(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_772
        LEA -90(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_773
        BRA.W LBL_774
LBL_773:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_774:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_191
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_772:
        MOVE.L -422(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_775
        LEA -86(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_776
        BRA.W LBL_777
LBL_776:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_777:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_191
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_775:
        MOVE.L -422(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_778
        LEA -82(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #2,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_779
        BRA.W LBL_780
LBL_779:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_780:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_191
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_778:
        MOVE.L -422(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_781
        LEA -78(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #3,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_782
        BRA.W LBL_783
LBL_782:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_783:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_191
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_781:
LBL_762:
        MOVEQ #100,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #100,D0
        OR.L D1,D0
        MOVE.L D0,-(A7)
        LEA LBL_115(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -422(A6),D0
        MOVE.W D0,-(A7)
        LEA -90(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -74(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.W #2,-(A7)
        DC.W $A9EA  ; SFGetFile
        LEA -74(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        SNE D0
        ANDI.L #1,D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_784
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_785:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_756
LBL_784:
        LEA -136(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -132(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -68(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -154(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A015  ; PBSetVolSync
        MOVE.L D0,-414(A6)
        LEA -410(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA -64(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -410(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2234(A5)
        ADDQ.L #8,A7
        MOVEQ #1,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_786:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_756
LBL_756:
        UNLK A6
        RTS
        ; func nat_UiSFPutFile  (JT slot 426)
        ;   param suggested255 : 12(A6)  size 4
        ;   param path255Out : 8(A6)  size 4
        ;   local rep : -74(A6)  size 74
        ;   local vp : -138(A6)  size 64
        ;   local s : -394(A6)  size 256
        ;   local junk : -398(A6)  size 4
LBL_107:
        LINK A6,#-450
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_788:
        CLR.L (A0)+
        DBRA D0,LBL_788
        CLR.W (A0)+
        LEA -138(A6),A0
        MOVE.W #15,D0
LBL_789:
        CLR.L (A0)+
        DBRA D0,LBL_789
        LEA -394(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-398(A6)
        MOVEQ #100,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #100,D0
        OR.L D1,D0
        MOVE.L D0,-(A7)
        LEA LBL_187(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -74(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.W #1,-(A7)
        DC.W $A9EA  ; SFPutFile
        LEA -74(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        SNE D0
        ANDI.L #1,D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_790
        MOVEQ #0,D0
        BRA.W LBL_787
LBL_790:
        LEA -120(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -116(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -68(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -138(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A015  ; PBSetVolSync
        MOVE.L D0,-398(A6)
        LEA -394(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA -64(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -394(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2234(A5)
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_787
LBL_787:
        UNLK A6
        RTS
        ; func rtUiParseInt  (JT slot 427)
        ;   param p : 16(A6)  size 4
        ;   param len : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local neg : -6(A6)  size 2
        ;   local v : -10(A6)  size 4
        ;   local anyDigit : -12(A6)  size 2
        ;   local c : -16(A6)  size 4
LBL_108:
        LINK A6,#-68
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_792
        MOVEQ #0,D0
        BRA.W LBL_791
LBL_792:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #45,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_793
        MOVEQ #1,D0
        MOVE.B D0,-6(A6)
        MOVEQ #1,D0
        MOVE.L D0,-4(A6)
LBL_793:
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_794
        MOVEQ #0,D0
        BRA.W LBL_791
LBL_794:
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_795:
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_796
        MOVE.L 16(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #48,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_797
        MOVE.L -16(A6),D1
        MOVEQ #57,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_798
LBL_797:
        MOVEQ #1,D0
LBL_798:
        TST.L D0
        BEQ.W LBL_799
        MOVEQ #0,D0
        BRA.W LBL_791
LBL_799:
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2147483647,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #48,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        BSR.W LBL_192
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_800
        MOVEQ #0,D0
        BRA.W LBL_791
LBL_800:
        MOVE.L -10(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_191
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #48,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-10(A6)
        MOVEQ #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_795
LBL_796:
        CLR.L D0
        MOVE.B -12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_801
        MOVEQ #0,D0
        BRA.W LBL_791
LBL_801:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_802
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D1
        MOVE.L -10(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_803
LBL_802:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_803:
        MOVEQ #1,D0
        BRA.W LBL_791
LBL_791:
        UNLK A6
        RTS
        ; func rtUiParseNarrow  (JT slot 428)
        ;   param text : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local v : -4(A6)  size 4
LBL_109:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_807
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_808
LBL_807:
        MOVEQ #0,D0
LBL_808:
        TST.L D0
        BEQ.W LBL_805
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #45,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_806
LBL_805:
        MOVEQ #0,D0
LBL_806:
        TST.L D0
        BEQ.W LBL_809
        MOVEQ #0,D0
        BRA.W LBL_804
LBL_809:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_108
        ADDA.W #12,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_810
        MOVEQ #0,D0
        BRA.W LBL_804
LBL_810:
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_811
        MOVE.L -4(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_812
        MOVEQ #0,D0
        BRA.W LBL_804
LBL_812:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_804
LBL_811:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_813
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_815
        MOVE.L -4(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_816
LBL_815:
        MOVEQ #1,D0
LBL_816:
        TST.L D0
        BEQ.W LBL_817
        MOVEQ #0,D0
        BRA.W LBL_804
LBL_817:
        BRA.W LBL_814
LBL_813:
        MOVE.L -4(A6),D1
        MOVE.L #65535,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_818
        MOVEQ #0,D0
        BRA.W LBL_804
LBL_818:
LBL_814:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_804
LBL_804:
        UNLK A6
        RTS
        ; func rtUiFormInvalid  (JT slot 429)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_110:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D1  ; UiTESetSelect
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #8,A7
LBL_819:
        UNLK A6
        RTS
        ; func rtUiFormCharOk  (JT slot 430)
        ;   param te : 16(A6)  size 4
        ;   param ch : 12(A6)  size 4
        ;   param ftype : 8(A6)  size 4
        ;   local teMp : -4(A6)  size 4
        ;   local th : -8(A6)  size 4
        ;   local thMp : -12(A6)  size 4
        ;   local len : -16(A6)  size 4
        ;   local i : -20(A6)  size 4
        ;   local first : -24(A6)  size 4
LBL_111:
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
        MOVEQ #48,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_821
        MOVE.L 12(A6),D1
        MOVEQ #57,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_822
LBL_821:
        MOVEQ #0,D0
LBL_822:
        TST.L D0
        BEQ.W LBL_823
        MOVEQ #1,D0
        BRA.W LBL_820
LBL_823:
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #45,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_824
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
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
        BEQ.W LBL_825
        MOVEQ #0,D0
        BRA.W LBL_820
LBL_825:
        MOVE.L -4(A6),D1
        MOVEQ #60,D0
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
        BEQ.W LBL_826
        MOVEQ #1,D0
        BRA.W LBL_820
LBL_826:
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
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVE.L -24(A6),D1
        MOVEQ #45,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_820
LBL_824:
        MOVE.L 12(A6),D1
        MOVEQ #46,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_827
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_828
LBL_827:
        MOVEQ #0,D0
LBL_828:
        TST.L D0
        BEQ.W LBL_829
        MOVE.L -4(A6),D1
        MOVEQ #62,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D1
        MOVEQ #60,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_830:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_831
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #46,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_832
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVEQ #0,D0
        BRA.W LBL_820
LBL_832:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_830
LBL_831:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVEQ #1,D0
        BRA.W LBL_820
LBL_829:
        MOVEQ #0,D0
        BRA.W LBL_820
LBL_820:
        UNLK A6
        RTS
        ; func rtUiFormTeardown  (JT slot 431)
        ;   param inst : 8(A6)  size 4
        ;   local bufH : -4(A6)  size 4
LBL_112:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -144(A5),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-136(A5)
        MOVEQ #0,D0
        MOVE.L D0,-140(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1658(A5)
        ADDQ.L #4,A7
LBL_833:
        UNLK A6
        RTS
        ; func rtAtDevPoll  (JT slot 432)
LBL_113:
        LINK A6,#-52
LBL_834:
        UNLK A6
        RTS
LBL_191:
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
LBL_192:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_835
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_835:
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
        BPL.W LBL_836
        NEG.L D2
        MOVE.L #1,D4
LBL_836:
        CLR.L D5
        TST.L D3
        BPL.W LBL_837
        NEG.L D3
        MOVE.L #1,D5
LBL_837:
        CLR.L D6
        MOVE.W #31,D7
LBL_838:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_839
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_839:
        DBRA D7,LBL_838
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_840
        NEG.L D2
LBL_840:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_193:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_841
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_841:
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
        BPL.W LBL_842
        NEG.L D2
        MOVE.L #1,D4
LBL_842:
        CLR.L D5
        TST.L D3
        BPL.W LBL_843
        NEG.L D3
        MOVE.L #1,D5
LBL_843:
        CLR.L D6
        MOVE.W #31,D7
LBL_844:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_845
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_845:
        DBRA D7,LBL_844
        TST.L D4
        BEQ.W LBL_846
        NEG.L D6
LBL_846:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_194:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_847(PC),A0
        MOVE.L A0,-4(A6)
LBL_848:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_849
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_850
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_848
LBL_850:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_851:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_848
LBL_849:
        UNLK A6
        RTS
LBL_847:
        DC.W $E5FA
        DC.W $0000
        DC.W $E5FE
        DC.W $0000
        DC.W $E602
        DC.W $0000
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
        DC.W $E43C
        DC.W $0001
        DC.W $E2E6
        DC.W $0001
        DC.W $E2E2
        DC.W $0000
        DC.W $E2DE
        DC.W $0000
        DC.W $0000
        DC.W $0000
        ; constant pool: string literals
LBL_189:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_114:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_121:
        DC.B $01
        DC.B $3F
LBL_116:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_122:
        DC.B $06
        DC.B $73,$65,$6C,$65,$63,$74
        DC.B $00
LBL_123:
        DC.B $0B
        DC.B $64,$6F,$75,$62,$6C,$65,$43,$6C,$69,$63,$6B
LBL_124:
        DC.B $78
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$66,$6F,$75,$6E,$64,$20,$6E,$6F,$20,$6D,$65,$6E,$75,$20,$69,$6E,$20,$74,$68,$65,$20,$6D,$65,$6E,$75,$20,$6C,$69,$73,$74,$20,$66,$6F,$72,$20,$74,$68,$69,$73,$20,$77,$69,$64,$67,$65,$74,$20,$28,$63,$6C,$6F,$73,$65,$2F,$72,$65,$6F,$70,$65,$6E,$20,$6C,$65,$66,$74,$20,$69,$74,$20,$75,$6E,$64,$65,$6C,$65,$74,$65,$64,$20,$6F,$72,$20,$6E,$65,$76,$65,$72,$20,$72,$65,$69,$6E,$73,$65,$72,$74,$65,$64,$29
        DC.B $00
LBL_125:
        DC.B $71
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$72,$65,$74,$75,$72,$6E,$65,$64,$20,$61,$20,$6D,$65,$6E,$75,$20,$68,$61,$6E,$64,$6C,$65,$20,$74,$68,$61,$74,$20,$69,$73,$6E,$27,$74,$20,$74,$68,$69,$73,$20,$69,$6E,$73,$74,$61,$6E,$63,$65,$27,$73,$20,$6F,$77,$6E,$20,$28,$73,$74,$61,$6C,$65,$2F,$6C,$65,$61,$6B,$65,$64,$20,$65,$6E,$74,$72,$79,$20,$75,$6E,$64,$65,$72,$20,$74,$68,$65,$20,$73,$61,$6D,$65,$20,$49,$44,$29
LBL_126:
        DC.B $57
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$6D,$65,$6E,$75,$20,$69,$74,$65,$6D,$20,$63,$6F,$75,$6E,$74,$20,$64,$6F,$65,$73,$6E,$27,$74,$20,$6D,$61,$74,$63,$68,$20,$74,$68,$65,$20,$62,$6F,$75,$6E,$64,$20,$65,$6E,$75,$6D,$20,$28,$72,$65,$62,$75,$69,$6C,$74,$20,$77,$69,$74,$68,$20,$73,$74,$61,$6C,$65,$2F,$6C,$65,$66,$74,$6F,$76,$65,$72,$20,$69,$74,$65,$6D,$73,$29
LBL_117:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_127:
        DC.B $24
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_128:
        DC.B $02
        DC.B $6F,$6E
        DC.B $00
LBL_129:
        DC.B $03
        DC.B $6F,$66,$66
LBL_130:
        DC.B $22
        DC.B $6A,$69,$67,$67,$6C,$65,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$6F,$6E,$7C,$6F,$66,$66,$29
        DC.B $00
LBL_131:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$61,$6E,$73,$77,$65,$72,$20,$71,$75,$65,$75,$65,$20,$6F,$76,$65,$72,$66,$6C,$6F,$77
LBL_132:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$77,$69,$74,$68,$20,$6E,$6F,$20,$71,$75,$65,$75,$65,$64,$20,$61,$6E,$73,$77,$65,$72
LBL_133:
        DC.B $07
        DC.B $54,$20,$4F,$50,$45,$4E,$20
LBL_134:
        DC.B $01
        DC.B $20
LBL_135:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_136:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_137:
        DC.B $01
        DC.B $2E
LBL_138:
        DC.B $07
        DC.B $2E,$73,$65,$6C,$65,$63,$74
LBL_139:
        DC.B $0D
        DC.B $54,$20,$46,$49,$52,$45,$20,$65,$76,$65,$72,$79,$2E
LBL_140:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_141:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_142:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_143:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_144:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_145:
        DC.B $0B
        DC.B $2E,$53,$65,$6C,$65,$63,$74,$41,$6C,$6C,$20
LBL_146:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_147:
        DC.B $08
        DC.B $54,$20,$41,$42,$4F,$55,$54,$20
        DC.B $00
LBL_148:
        DC.B $01
        DC.B $7C
LBL_149:
        DC.B $07
        DC.B $63,$61,$70,$74,$69,$6F,$6E
LBL_150:
        DC.B $04
        DC.B $74,$65,$78,$74
        DC.B $00
LBL_151:
        DC.B $07
        DC.B $65,$6E,$61,$62,$6C,$65,$64
LBL_152:
        DC.B $07
        DC.B $63,$68,$65,$63,$6B,$65,$64
LBL_153:
        DC.B $08
        DC.B $73,$65,$6C,$65,$63,$74,$65,$64
        DC.B $00
LBL_154:
        DC.B $05
        DC.B $77,$69,$64,$74,$68
LBL_155:
        DC.B $06
        DC.B $68,$65,$69,$67,$68,$74
        DC.B $00
LBL_156:
        DC.B $06
        DC.B $54,$20,$53,$45,$54,$20
        DC.B $00
LBL_157:
        DC.B $09
        DC.B $2E,$69,$6E,$76,$61,$6C,$69,$64,$2E
LBL_158:
        DC.B $02
        DC.B $54,$20
        DC.B $00
LBL_159:
        DC.B $0A
        DC.B $54,$20,$4F,$50,$45,$4E,$44,$4F,$43,$20
        DC.B $00
LBL_160:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_161:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_162:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_163:
        DC.B $37
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$73,$61,$76,$65,$7C,$64,$69,$73,$63,$61,$72,$64,$7C,$63,$61,$6E,$63,$65,$6C,$29
LBL_164:
        DC.B $23
        DC.B $73,$6E,$61,$70,$3A,$20,$73,$63,$72,$65,$65,$6E,$42,$69,$74,$73,$2E,$72,$6F,$77,$42,$79,$74,$65,$73,$20,$69,$73,$20,$6E,$6F,$74,$20,$36,$34
LBL_165:
        DC.B $10
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$23,$23,$20
        DC.B $00
LBL_166:
        DC.B $13
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$2D,$45,$4E,$44,$23,$23
LBL_167:
        DC.B $2C
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$6B,$6E,$6F,$77,$6E,$20,$6F,$72,$20,$75,$6E,$73,$75,$70,$70,$6F,$72,$74,$65,$64,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$76,$65,$72,$62
        DC.B $00
LBL_118:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_168:
        DC.B $08
        DC.B $64,$62,$6C,$63,$6C,$69,$63,$6B
        DC.B $00
LBL_119:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_120:
        DC.B $03
        DC.B $6B,$65,$79
LBL_169:
        DC.B $04
        DC.B $74,$79,$70,$65
        DC.B $00
LBL_170:
        DC.B $04
        DC.B $6D,$65,$6E,$75
        DC.B $00
LBL_171:
        DC.B $05
        DC.B $63,$6C,$6F,$73,$65
LBL_172:
        DC.B $06
        DC.B $72,$65,$73,$69,$7A,$65
        DC.B $00
LBL_173:
        DC.B $04
        DC.B $7A,$6F,$6F,$6D
        DC.B $00
LBL_174:
        DC.B $05
        DC.B $64,$65,$6C,$61,$79
LBL_175:
        DC.B $04
        DC.B $74,$69,$63,$6B
        DC.B $00
LBL_176:
        DC.B $04
        DC.B $73,$6E,$61,$70
        DC.B $00
LBL_177:
        DC.B $06
        DC.B $6A,$69,$67,$67,$6C,$65
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
        DC.B $2A
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$6D,$75,$73,$74,$20,$68,$61,$76,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$65,$6E,$74,$72,$69,$65,$73
        DC.B $00
LBL_186:
        DC.B $31
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$65,$6E,$74,$72,$79,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_188:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_115:
        DC.B $00
        DC.B $00
LBL_187:
        DC.B $08
        DC.B $53,$61,$76,$65,$20,$61,$73,$3A
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_190:
        DC.B $00
        DC.B $00
