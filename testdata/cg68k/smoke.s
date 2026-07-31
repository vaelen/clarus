LBL_254:
        ; startup (JT slot 0)
        ; globals (below A5, 298 bytes total):
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
        LEA -298(A5),A0
        MOVE.W #148,D0
LBL_256:
        CLR.W (A0)+
        DBRA D0,LBL_256
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_255
        BSR.W LBL_55
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR 730(A5)
        BSR.W LBL_253
        CLR.L -(A7)
        BSR.W LBL_58
        RTS
LBL_255:
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
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-32(A5)
        MOVE.L #0,D0
        MOVE.L D0,-36(A5)
        LEA -292(A5),A0
        MOVE.W #127,D0
LBL_257:
        CLR.W (A0)+
        DBRA D0,LBL_257
        MOVE.L #0,D0
        MOVE.L D0,-296(A5)
        MOVE.L #0,D0
        MOVE.B D0,-298(A5)
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
LBL_259:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_259
        BSR.W LBL_60
        ADDA.W #260,A7
LBL_258:
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
LBL_261:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_261
        BSR.W LBL_59
        ADDA.W #256,A7
LBL_260:
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
        BEQ.W LBL_263
        LEA LBL_86(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_264:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_264
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_263:
        MOVE.L 266(A6),D0
        BRA.W LBL_262
LBL_262:
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
        BEQ.W LBL_266
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_267
LBL_266:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_267:
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
        BEQ.W LBL_268
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_88(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_269:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_269
        BSR.W LBL_0
        ADDA.W #260,A7
LBL_268:
LBL_265:
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
        BEQ.W LBL_271
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_272
LBL_271:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_272:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_273
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_274
LBL_273:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_274:
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
        BEQ.W LBL_275
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_88(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_276:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_276
        BSR.W LBL_0
        ADDA.W #260,A7
LBL_275:
LBL_270:
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
        LINK A6,#-616
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
        BEQ.W LBL_278
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_279
LBL_278:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_279:
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_280:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
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
        BEQ.W LBL_282
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_277
LBL_282:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_283
        MOVE.L #1,D0
        BRA.W LBL_277
LBL_283:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_280
LBL_281:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_284
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_277
LBL_284:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        MOVE.L #1,D0
        BRA.W LBL_277
LBL_285:
        MOVE.L #0,D0
        BRA.W LBL_277
LBL_277:
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
        LINK A6,#-608
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
        BEQ.W LBL_287
        BRA.W LBL_286
LBL_287:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_288
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_289
LBL_288:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_289:
LBL_290:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_291
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        BRA.W LBL_290
LBL_291:
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
        BEQ.W LBL_292
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_293:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_293
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_292:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_286:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 8)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_7:
        LINK A6,#-600
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
        BEQ.W LBL_295
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_296:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_296
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_295:
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
        BEQ.W LBL_297
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_298:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_298
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_297:
        MOVE.L -4(A6),D0
        BRA.W LBL_294
LBL_294:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 9)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_8:
        LINK A6,#-596
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_300
        BRA.W LBL_299
LBL_300:
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
LBL_299:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 10)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_9:
        LINK A6,#-596
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        BRA.W LBL_301
LBL_302:
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
        BEQ.W LBL_303
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_303:
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
        BEQ.W LBL_304
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
LBL_304:
LBL_301:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 11)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_10:
        LINK A6,#-604
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
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
LBL_305:
        UNLK A6
        RTS
        ; func rtTextConcat  (JT slot 12)
        ;   param dst : 20(A6)  size 4
        ;   param a : 16(A6)  size 4
        ;   param bstr : 12(A6)  size 4
        ;   param btext : 8(A6)  size 4
        ;   local ra : -4(A6)  size 4
        ;   local rb : -8(A6)  size 4
        ;   local rd : -12(A6)  size 4
        ;   local alen : -16(A6)  size 4
        ;   local blen : -20(A6)  size 4
        ;   local total : -24(A6)  size 4
        ;   local scratchSz : -28(A6)  size 4
        ;   local scratch : -32(A6)  size 4
        ;   local amp : -36(A6)  size 4
        ;   local bmp : -40(A6)  size 4
        ;   local dstmp : -44(A6)  size 4
LBL_11:
        LINK A6,#-636
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_307
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_308
LBL_307:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
LBL_308:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_309
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_310
LBL_309:
        MOVE.L #1,D0
        MOVE.L D0,-28(A6)
LBL_310:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; TextNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_311
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_312:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_312
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_311:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_313
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        BRA.W LBL_314
LBL_313:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
LBL_314:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
        ADDQ.L #8,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
LBL_306:
        UNLK A6
        RTS
        ; func rtTextCmp  (JT slot 13)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local ra : -4(A6)  size 4
        ;   local rb : -8(A6)  size 4
        ;   local alen : -12(A6)  size 4
        ;   local blen : -16(A6)  size 4
        ;   local n : -20(A6)  size 4
        ;   local i : -24(A6)  size 4
        ;   local amp : -28(A6)  size 4
        ;   local bmp : -32(A6)  size 4
        ;   local ca : -36(A6)  size 4
        ;   local cb : -40(A6)  size 4
LBL_12:
        LINK A6,#-632
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_316
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_317
LBL_316:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_317:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
LBL_318:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_319
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-36(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_320
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_315
LBL_320:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_321
        MOVE.L #1,D0
        BRA.W LBL_315
LBL_321:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-24(A6)
        BRA.W LBL_318
LBL_319:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_322
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_315
LBL_322:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
        MOVE.L #1,D0
        BRA.W LBL_315
LBL_323:
        MOVE.L #0,D0
        BRA.W LBL_315
LBL_315:
        UNLK A6
        RTS
        ; func rtTextCmpStr  (JT slot 14)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local tlen : -8(A6)  size 4
        ;   local slen : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local i : -20(A6)  size 4
        ;   local mp : -24(A6)  size 4
        ;   local ca : -28(A6)  size 4
        ;   local cb : -32(A6)  size 4
LBL_13:
        LINK A6,#-624
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_326
LBL_325:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_326:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
LBL_327:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_328
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_329
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_324
LBL_329:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_330
        MOVE.L #1,D0
        BRA.W LBL_324
LBL_330:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_327
LBL_328:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_331
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_324
LBL_331:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_332
        MOVE.L #1,D0
        BRA.W LBL_324
LBL_332:
        MOVE.L #0,D0
        BRA.W LBL_324
LBL_324:
        UNLK A6
        RTS
        ; func rtTextLen  (JT slot 15)
        ;   param t : 8(A6)  size 4
LBL_14:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_333
LBL_333:
        UNLK A6
        RTS
        ; func rtTextIndex  (JT slot 16)
        ;   param t : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_15:
        LINK A6,#-600
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
        BNE.W LBL_335
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_336
LBL_335:
        MOVE.L #1,D0
LBL_336:
        TST.L D0
        BEQ.W LBL_337
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_338:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_338
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_337:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_334
LBL_334:
        UNLK A6
        RTS
        ; func rtTextAppendStr  (JT slot 17)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local len0 : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_16:
        LINK A6,#-608
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_339:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 18)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_17:
        LINK A6,#-604
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
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
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_340:
        UNLK A6
        RTS
        ; func rtListGrow  (JT slot 19)
        ;   param l : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local elemsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
LBL_18:
        LINK A6,#-612
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
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
        BEQ.W LBL_342
        BRA.W LBL_341
LBL_342:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_343
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_344
LBL_343:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_344:
LBL_345:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        BRA.W LBL_345
LBL_346:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; ListSetHandleSize
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_347
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_348:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_348
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_347:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_341:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 20)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_19:
        LINK A6,#-600
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
        BEQ.W LBL_350
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_351:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_351
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_350:
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
        BEQ.W LBL_352
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_353:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_353
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_352:
        MOVE.L -4(A6),D0
        BRA.W LBL_349
LBL_349:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 21)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_20:
        LINK A6,#-596
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_355
        BRA.W LBL_354
LBL_355:
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
LBL_354:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 22)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_21:
        LINK A6,#-596
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_357
        BRA.W LBL_356
LBL_357:
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
        BEQ.W LBL_358
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_358:
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
        BEQ.W LBL_359
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
LBL_359:
LBL_356:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 23)
        ;   param l : 8(A6)  size 4
LBL_22:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_361
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
        BRA.W LBL_362
LBL_361:
        MOVE.L #0,D0
LBL_362:
        BRA.W LBL_360
LBL_360:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 24)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_23:
        LINK A6,#-604
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
        BNE.W LBL_364
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
        BRA.W LBL_365
LBL_364:
        MOVE.L #1,D0
LBL_365:
        TST.L D0
        BEQ.W LBL_366
        LEA LBL_93(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_367:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_367
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_366:
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
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_363
LBL_363:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 25)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_24:
        LINK A6,#-604
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_368:
        UNLK A6
        RTS
        ; func rtListPop  (JT slot 26)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_25:
        LINK A6,#-604
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_370
        LEA LBL_94(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_371:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_371
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_370:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
LBL_369:
        UNLK A6
        RTS
        ; func rtListShift  (JT slot 27)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local tailBytes : -12(A6)  size 4
LBL_26:
        LINK A6,#-604
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_373
        LEA LBL_95(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_374:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_374
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_373:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_372:
        UNLK A6
        RTS
        ; func rtListUnshift  (JT slot 28)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local bodyBytes : -12(A6)  size 4
LBL_27:
        LINK A6,#-604
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_375:
        UNLK A6
        RTS
        ; func rtListFirst  (JT slot 29)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_28:
        LINK A6,#-600
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_377
        LEA LBL_96(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_378:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_378
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_377:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
LBL_376:
        UNLK A6
        RTS
        ; func rtListLast  (JT slot 30)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_29:
        LINK A6,#-604
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        LEA LBL_97(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_381:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_381
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_380:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
LBL_379:
        UNLK A6
        RTS
        ; func rtListRemove  (JT slot 31)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local tail : -12(A6)  size 4
LBL_30:
        LINK A6,#-604
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
        BNE.W LBL_383
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
        BRA.W LBL_384
LBL_383:
        MOVE.L #1,D0
LBL_384:
        TST.L D0
        BEQ.W LBL_385
        LEA LBL_93(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_386:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_386
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_385:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_387
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
LBL_387:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_382:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 32)
        ;   param l : 8(A6)  size 4
LBL_31:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_388
LBL_388:
        UNLK A6
        RTS
        ; func mapKeySlot  (JT slot 33)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_32:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_389
LBL_389:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 34)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_33:
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
        BSR.W LBL_250
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_390
LBL_390:
        UNLK A6
        RTS
        ; func mapLowerBound  (JT slot 35)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local count : -4(A6)  size 4
        ;   local lo : -8(A6)  size 4
        ;   local hi : -12(A6)  size 4
        ;   local mid : -16(A6)  size 4
LBL_34:
        LINK A6,#-608
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
LBL_392:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_393
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_251
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_394
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_395
LBL_394:
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
LBL_395:
        BRA.W LBL_392
LBL_393:
        MOVE.L -8(A6),D0
        BRA.W LBL_391
LBL_391:
        UNLK A6
        RTS
        ; func mapKeyEq  (JT slot 36)
        ;   param m : 16(A6)  size 4
        ;   param pos : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
LBL_35:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_397
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_398
LBL_397:
        MOVE.L #0,D0
LBL_398:
        BRA.W LBL_396
LBL_396:
        UNLK A6
        RTS
        ; func mapFind  (JT slot 37)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local pos : -4(A6)  size 4
LBL_36:
        LINK A6,#-596
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_400
        MOVE.L -4(A6),D0
        BRA.W LBL_399
LBL_400:
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_399
LBL_399:
        UNLK A6
        RTS
        ; func rtMapGrowKeys  (JT slot 38)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_37:
        LINK A6,#-608
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
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
        BEQ.W LBL_402
        BRA.W LBL_401
LBL_402:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_404
LBL_403:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_404:
LBL_405:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        BRA.W LBL_405
LBL_406:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; MapSetHandleSize
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_407
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_408:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_408
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_407:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_401:
        UNLK A6
        RTS
        ; func rtMapGrowVals  (JT slot 39)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local valsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
LBL_38:
        LINK A6,#-612
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
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
        BEQ.W LBL_410
        BRA.W LBL_409
LBL_410:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_411
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_412
LBL_411:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_412:
LBL_413:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-12(A6)
        BRA.W LBL_413
LBL_414:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; MapSetHandleSize
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_416:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_416
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_415:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_409:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 40)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_39:
        LINK A6,#-600
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
        BEQ.W LBL_418
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_419:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_419
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_418:
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
        BEQ.W LBL_420
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_421:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_421
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_420:
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
        BEQ.W LBL_422
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_423:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_423
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_422:
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
        BRA.W LBL_417
LBL_417:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 41)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_40:
        LINK A6,#-596
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        BRA.W LBL_424
LBL_425:
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
LBL_424:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 42)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_41:
        LINK A6,#-596
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_427
        BRA.W LBL_426
LBL_427:
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
        BEQ.W LBL_428
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_428:
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
        BEQ.W LBL_429
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
LBL_429:
LBL_426:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 43)
        ;   param m : 8(A6)  size 4
LBL_42:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
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
        BRA.W LBL_432
LBL_431:
        MOVE.L #0,D0
LBL_432:
        BRA.W LBL_430
LBL_430:
        UNLK A6
        RTS
        ; func rtMapSet  (JT slot 44)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param val : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local pos : -8(A6)  size 4
        ;   local tail : -12(A6)  size 4
        ;   local klen : -16(A6)  size 4
        ;   local kslot : -20(A6)  size 4
LBL_43:
        LINK A6,#-612
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_434
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        BRA.W LBL_433
LBL_434:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #8,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_435:
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_433:
        UNLK A6
        RTS
        ; func rtMapGet  (JT slot 45)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_44:
        LINK A6,#-596
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_437
        LEA LBL_98(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_438:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_438
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_437:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
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
LBL_436:
        UNLK A6
        RTS
        ; func rtMapGetDv  (JT slot 46)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_45:
        LINK A6,#-596
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_440
        MOVE.L #0,D0
        BRA.W LBL_439
LBL_440:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
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
        MOVE.L #1,D0
        BRA.W LBL_439
LBL_439:
        UNLK A6
        RTS
        ; func rtMapHas  (JT slot 47)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
LBL_46:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_441
LBL_441:
        UNLK A6
        RTS
        ; func rtMapRemove  (JT slot 48)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local idx : -8(A6)  size 4
        ;   local tail : -12(A6)  size 4
LBL_47:
        LINK A6,#-604
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_443
        BRA.W LBL_442
LBL_443:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_444
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_250
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_444:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_442:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 49)
        ;   param m : 8(A6)  size 4
LBL_48:
        LINK A6,#-592
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_445
LBL_445:
        UNLK A6
        RTS
        ; func rtMapKeyAt  (JT slot 50)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param key255 : 8(A6)  size 4
LBL_49:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_447
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
        BRA.W LBL_448
LBL_447:
        MOVE.L #1,D0
LBL_448:
        TST.L D0
        BEQ.W LBL_449
        LEA LBL_98(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_450:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_450
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_449:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_446:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 51)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_50:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_452
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
        BRA.W LBL_453
LBL_452:
        MOVE.L #1,D0
LBL_453:
        TST.L D0
        BEQ.W LBL_454
        LEA LBL_98(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_455:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_455
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_454:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
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
LBL_451:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 52)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_51:
        LINK A6,#-608
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_457:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_458
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
        BEQ.W LBL_459
        MOVE.L #10,D0
        MOVE.L D0,-12(A6)
LBL_459:
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
        BRA.W LBL_457
LBL_458:
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
        BRA.W LBL_456
LBL_456:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 53)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
LBL_52:
        LINK A6,#-610
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
        BEQ.W LBL_461
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,12(A6)
LBL_461:
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
        BEQ.W LBL_462
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_463
LBL_462:
LBL_464:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_252
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
        BSR.W LBL_251
        MOVE.L D0,12(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_464
LBL_465:
LBL_463:
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_466
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-14(A6)
LBL_466:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_467:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_468
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
        BRA.W LBL_467
LBL_468:
        MOVE.L -14(A6),D0
        BRA.W LBL_460
LBL_460:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 54)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_53:
        LINK A6,#-592
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_470
        BRA.W LBL_469
LBL_470:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        BRA.W LBL_469
LBL_471:
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
LBL_469:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 55)
LBL_54:
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
LBL_472:
        UNLK A6
        RTS
        ; func natInit  (JT slot 56)
LBL_55:
        LINK A6,#-592
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_474
        BRA.W LBL_473
LBL_474:
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
        BEQ.W LBL_475
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        BRA.W LBL_473
LBL_475:
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
LBL_473:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 57)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_56:
        LINK A6,#-596
        BSR.W LBL_55
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        BSR.W LBL_54
LBL_476:
        UNLK A6
        RTS
        ; func natLog  (JT slot 58)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_57:
        LINK A6,#-600
        BSR.W LBL_55
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_478:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_480
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_481
LBL_480:
        MOVE.L #0,D0
LBL_481:
        TST.L D0
        BEQ.W LBL_479
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
        BRA.W LBL_478
LBL_479:
LBL_477:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 59)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_58:
        LINK A6,#-596
        CLR.L D0
        MOVE.B -28(A5),D0
        TST.L D0
        BEQ.W LBL_483
        BRA.W LBL_482
LBL_483:
        MOVE.L #1,D0
        MOVE.B D0,-28(A5)
        BSR.W LBL_55
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
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
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
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_484
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
LBL_484:
        BSR.W LBL_54
        DC.W $A9F4  ; NatExitToShell
LBL_482:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 60)
        ;   param msg : 8(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_59:
        LINK A6,#-848
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_99(PC),A0
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
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
LBL_485:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 61)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_60:
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
LBL_486:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 62)
LBL_61:
        LINK A6,#-592
        MOVE.L -36(A5),D0
        BRA.W LBL_487
LBL_487:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 63)
        ;   hidden result ptr : 8(A6)  size 4
LBL_62:
        LINK A6,#-592
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -292(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        BRA.W LBL_488
LBL_488:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 64)
        ;   local __ret1 : -4(A6)  size 4
LBL_63:
        LINK A6,#-596
        MOVE.L #256,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-552(A6)
LBL_490:
        MOVE.L A1,-(A7)
        MOVE.L -552(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_489
LBL_489:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 65)
LBL_64:
        LINK A6,#-592
        CLR.L D0
        MOVE.B -298(A5),D0
        TST.L D0
        BEQ.W LBL_492
        BRA.W LBL_491
LBL_492:
        MOVE.L #1,D0
        MOVE.B D0,-298(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-296(A5)
LBL_491:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 66)
LBL_65:
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
LBL_493:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 67)
        ;   param path : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local ref : -16(A6)  size 4
        ;   local wrote : -20(A6)  size 4
        ;   local failed : -22(A6)  size 2
LBL_66:
        LINK A6,#-614
        BSR.W LBL_64
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
        BEQ.W LBL_495
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_100(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_496:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_496
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_494
LBL_495:
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
        BEQ.W LBL_497
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
        BEQ.W LBL_498
        MOVE.L #1,D0
        MOVE.B D0,-22(A6)
LBL_498:
LBL_497:
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
        BSR.W LBL_65
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_499
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_500
LBL_499:
        MOVE.L #1,D0
LBL_500:
        TST.L D0
        BEQ.W LBL_501
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_101(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_502:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_502
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_494
LBL_501:
        MOVE.L #1,D0
        BRA.W LBL_494
LBL_494:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 68)
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
LBL_67:
        LINK A6,#-622
        BSR.W LBL_64
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
        BEQ.W LBL_504
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_100(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_505:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_505
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_503
LBL_504:
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
        BEQ.W LBL_506
        LEA LBL_91(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_507:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_507
        BSR.W LBL_1
        ADDA.W #256,A7
LBL_506:
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
LBL_508:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_509
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
        BEQ.W LBL_510
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_511
LBL_510:
        MOVE.L #0,D0
LBL_511:
        TST.L D0
        BEQ.W LBL_512
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
        LEA LBL_102(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_513:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_513
        BSR.W LBL_0
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_503
LBL_512:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_514
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
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
LBL_514:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_515
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_516
LBL_515:
        MOVE.L #1,D0
LBL_516:
        TST.L D0
        BEQ.W LBL_517
        MOVE.L #1,D0
        MOVE.B D0,-30(A6)
LBL_517:
        BRA.W LBL_508
LBL_509:
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
        BRA.W LBL_503
LBL_503:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 69)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_68:
        LINK A6,#-612
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_519:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
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
        BEQ.W LBL_521
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_521:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_519
LBL_520:
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
LBL_522:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_523
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
        BRA.W LBL_522
LBL_523:
LBL_518:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 70)
        ;   param path : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
LBL_69:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_525
        MOVE.L #1,D0
        BRA.W LBL_524
LBL_525:
        MOVE.L #0,D0
        BRA.W LBL_524
LBL_524:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 71)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_70:
        LINK A6,#-592
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_527
        MOVE.L #1,D0
        BRA.W LBL_526
LBL_527:
        MOVE.L #0,D0
        BRA.W LBL_526
LBL_526:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 72)
        ;   param cond : 264(A6)  size 2
        ;   param label : 8(A6)  size 256
        ;   local msg : -256(A6)  size 256
LBL_71:
        LINK A6,#-848
        CLR.L D0
        MOVE.B 264(A6),D0
        TST.L D0
        BEQ.W LBL_529
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_103(PC),A0
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
        BRA.W LBL_530
LBL_529:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_104(PC),A0
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
LBL_530:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
LBL_528:
        UNLK A6
        RTS
        ; func smokeMakePoint  (JT slot 73)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -48(A6)  size 48
        ;   local __store1 : -96(A6)  size 48
        ;   local __ret2 : -144(A6)  size 48
LBL_72:
        LINK A6,#-736
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
LBL_532:
        CLR.W (A0)+
        DBRA D0,LBL_532
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
LBL_533:
        CLR.W (A0)+
        DBRA D0,LBL_533
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
LBL_534:
        CLR.W (A0)+
        DBRA D0,LBL_534
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_249
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L #3,D0
        MOVE.L D0,0(A0)
        MOVEA.L A1,A0
        MOVE.L #4,D0
        MOVE.L D0,4(A0)
        MOVEA.L A1,A0
        MOVE.L #5,D0
        MOVE.L D0,8(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L #0,D0
        MOVE.L D0,12(A0)
        MOVEA.L A1,A0
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_535:
        CLR.W (A0)+
        DBRA D0,LBL_535
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_248
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_249
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_536:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_536
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_249
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_537:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_537
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_248
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_249
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_538:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_538
        BRA.W LBL_531
LBL_531:
        UNLK A6
        RTS
        ; func smokeTakePoint  (JT slot 74)
        ;   param p : 8(A6)  size 48
        ;   local __ret3 : -4(A6)  size 4
LBL_73:
        LINK A6,#-596
        LEA 8(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_248
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
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
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_249
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_539
LBL_539:
        UNLK A6
        RTS
        ; func smokeListInt  (JT slot 75)
        ;   local l : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local x : -16(A6)  size 4
LBL_74:
        LINK A6,#-608
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #30,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_105(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_541:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_541
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_106(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_542:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_542
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #30,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_107(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_543:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_543
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_544
        BRA.W LBL_545
LBL_544:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_546:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_546
        BSR.W LBL_1
LBL_545:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_108(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_547:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_547
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L #25,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_548
        BRA.W LBL_549
LBL_548:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_550:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_550
        BSR.W LBL_1
LBL_549:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_551
        BRA.W LBL_552
LBL_551:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_553:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_553
        BSR.W LBL_1
LBL_552:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #25,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_109(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_554:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_554
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_555
        BRA.W LBL_556
LBL_555:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_557:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_557
        BSR.W LBL_1
LBL_556:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_110(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_558:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_558
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_111(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_559:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_559
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_112(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_560:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_560
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_113(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_561:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_561
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #30,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_114(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_562:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_562
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_115(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_563:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_563
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_116(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_564:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_564
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_565
        BRA.W LBL_566
LBL_565:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_567:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_567
        BSR.W LBL_1
LBL_566:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #25,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_117(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_568:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_568
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #100,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #200,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_569:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_571
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_23
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        LEA -16(A6),A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_570:
        ADDQ.L #1,(A7)
        BRA.W LBL_569
LBL_571:
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #25,D0
        MOVE.L D0,-(A7)
        MOVE.L #100,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #200,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_118(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_572:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_572
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_119(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_573:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_573
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-564(A6)
LBL_574:
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_540:
        UNLK A6
        RTS
        ; func smokeListText  (JT slot 76)
        ;   local l : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local __store2 : -12(A6)  size 4
        ;   local __store3 : -16(A6)  size 4
LBL_75:
        LINK A6,#-608
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        BSR.W LBL_7
        MOVE.L D0,-8(A6)
        BSR.W LBL_7
        MOVE.L D0,-12(A6)
        BSR.W LBL_7
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_123(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_576:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_576
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_124(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_577:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_577
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_125(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_578:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_578
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_579
        BRA.W LBL_580
LBL_579:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_581:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_581
        BSR.W LBL_1
LBL_580:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_126(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_582:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_582
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #1,D0
        MOVE.L D0,-24(A6)
        BSR.W LBL_7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_583
        BRA.W LBL_584
LBL_583:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_585:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_585
        BSR.W LBL_1
LBL_584:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        LEA -36(A6),A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.L A1,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_586
        BRA.W LBL_587
LBL_586:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_588:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_588
        BSR.W LBL_1
LBL_587:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVEA.L (A7)+,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_589
        BRA.W LBL_590
LBL_589:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_591:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_591
        BSR.W LBL_1
LBL_590:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_128(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_592:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_592
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_129(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_593:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_593
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_130(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_594:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_594
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_131(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_595:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_595
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_132(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_596:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_596
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_597
        BRA.W LBL_598
LBL_597:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_599:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_599
        BSR.W LBL_1
LBL_598:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_133(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_600:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_600
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_136(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_601:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_601
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_602
        BRA.W LBL_603
LBL_602:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_604:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_604
        BSR.W LBL_1
LBL_603:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_137(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_605:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_605
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-564(A6)
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_606
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-568(A6)
        CLR.L -572(A6)
LBL_607:
        MOVE.L -572(A6),D0
        MOVE.L -568(A6),D1
        CMP.L D1,D0
        BGE.W LBL_606
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -572(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-572(A6)
        BRA.W LBL_607
LBL_606:
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_575:
        UNLK A6
        RTS
        ; func smokeMapInt  (JT slot 77)
        ;   local m : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local k : -264(A6)  size 256
        ;   local v : -268(A6)  size 4
LBL_76:
        LINK A6,#-860
        MOVE.L #4,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #1,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #2,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #3,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_141(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_609:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_609
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_142(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_610:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_610
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        MOVE.B D0,-(A7)
        LEA LBL_143(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_611:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_611
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_145(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_612:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_612
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #99,D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_45
        ADDA.W #12,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #99,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_146(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_613:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_613
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #99,D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_45
        ADDA.W #12,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_147(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_614:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_614
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #22,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_148(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_615:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_615
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_47
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_149(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_616:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_616
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_150(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_617:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_617
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_151(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_47
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_152(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_618:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_618
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_619:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_621
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_49
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -268(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_620:
        ADDQ.L #1,(A7)
        BRA.W LBL_619
LBL_621:
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_153(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_622:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_622
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-816(A6)
LBL_623:
        MOVE.L A1,-(A7)
        MOVE.L -816(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_608:
        UNLK A6
        RTS
        ; func smokeMapText  (JT slot 78)
        ;   local m : -4(A6)  size 4
        ;   local k : -260(A6)  size 256
        ;   local v : -264(A6)  size 4
        ;   local found : -268(A6)  size 4
LBL_77:
        LINK A6,#-860
        MOVE.L #4,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        BSR.W LBL_7
        MOVE.L D0,-264(A6)
        BSR.W LBL_7
        MOVE.L D0,-268(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_625
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_625:
        BSR.W LBL_7
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_626
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_626:
        BSR.W LBL_7
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_158(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_627:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_627
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_159(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_628:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_628
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        BSR.W LBL_7
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-284(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,-(A7)
        LEA -284(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_45
        ADDA.W #12,A7
        MOVE.L -284(A6),D0
        MOVE.L -276(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_629
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_629:
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_162(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_630:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_630
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        BSR.W LBL_7
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-284(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        LEA -284(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_45
        ADDA.W #12,A7
        MOVE.L -284(A6),D0
        MOVE.L -276(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_631
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_631:
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_163(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_632:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_632
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_633
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_633:
        BSR.W LBL_7
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_165(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_634:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_634
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_635
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_635:
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_47
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_166(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_636:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_636
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_637:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_639
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_49
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -264(A6),D0
        MOVE.L D0,-268(A6)
LBL_638:
        ADDQ.L #1,(A7)
        BRA.W LBL_637
LBL_639:
        ADDA.W #12,A7
        MOVE.L -268(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_167(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_640:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_640
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-816(A6)
        MOVE.L A1,-(A7)
        MOVE.L -816(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_641
        MOVE.L A1,-(A7)
        MOVE.L -816(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-820(A6)
        CLR.L -824(A6)
LBL_642:
        MOVE.L -824(A6),D0
        MOVE.L -820(A6),D1
        CMP.L D1,D0
        BGE.W LBL_641
        MOVE.L A1,-(A7)
        MOVE.L -816(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -824(A6),D0
        MOVE.L D0,-(A7)
        LEA -828(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -828(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-824(A6)
        BRA.W LBL_642
LBL_641:
        MOVE.L A1,-(A7)
        MOVE.L -816(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_624:
        UNLK A6
        RTS
        ; func smokeTextOps  (JT slot 79)
        ;   local t : -4(A6)  size 4
        ;   local __store4 : -8(A6)  size 4
        ;   local u : -12(A6)  size 4
        ;   local __store5 : -16(A6)  size 4
LBL_78:
        LINK A6,#-608
        BSR.W LBL_7
        MOVE.L D0,-4(A6)
        BSR.W LBL_7
        MOVE.L D0,-8(A6)
        BSR.W LBL_7
        MOVE.L D0,-12(A6)
        BSR.W LBL_7
        MOVE.L D0,-16(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_168(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-8(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_170(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_171(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_644:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_644
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #33,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_173(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_645:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_645
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_174(PC),A0
        MOVE.L A0,-(A7)
        CLR.L -(A7)
        BSR.W LBL_11
        ADDA.W #16,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_175(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_176(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_646:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_646
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_177(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_647:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_647
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_178(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_648:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_648
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_179(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_649:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_649
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_181(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_650:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_650
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_643:
        UNLK A6
        RTS
        ; func smokeNested  (JT slot 80)
        ;   local lm : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local got : -12(A6)  size 4
        ;   local __store6 : -16(A6)  size 4
LBL_79:
        LINK A6,#-608
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L #4,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #4,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L #4,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_652
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_652:
        BSR.W LBL_7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_184(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_653:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_653
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -16(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-564(A6)
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_654
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-568(A6)
        CLR.L -572(A6)
LBL_655:
        MOVE.L -572(A6),D0
        MOVE.L -568(A6),D1
        CMP.L D1,D0
        BGE.W LBL_654
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -572(A6),D0
        MOVE.L D0,-(A7)
        LEA -576(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -576(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-572(A6)
        BRA.W LBL_655
LBL_654:
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_656
        BRA.W LBL_657
LBL_656:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_658:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_658
        BSR.W LBL_1
LBL_657:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-564(A6)
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_659
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-568(A6)
        CLR.L -572(A6)
LBL_660:
        MOVE.L -572(A6),D0
        MOVE.L -568(A6),D1
        CMP.L D1,D0
        BGE.W LBL_659
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -572(A6),D0
        MOVE.L D0,-(A7)
        LEA -576(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -576(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-572(A6)
        BRA.W LBL_660
LBL_659:
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_185(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_661:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_661
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_662
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_662:
        BSR.W LBL_7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_663
        BRA.W LBL_664
LBL_663:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_665:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_665
        BSR.W LBL_1
LBL_664:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_187(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_666:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_666
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-564(A6)
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_667
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-568(A6)
        CLR.L -572(A6)
LBL_668:
        MOVE.L -572(A6),D0
        MOVE.L -568(A6),D1
        CMP.L D1,D0
        BGE.W LBL_667
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -572(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-580(A6)
        MOVE.L A1,-(A7)
        MOVE.L -580(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_669
        MOVE.L A1,-(A7)
        MOVE.L -580(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-584(A6)
        CLR.L -588(A6)
LBL_670:
        MOVE.L -588(A6),D0
        MOVE.L -584(A6),D1
        CMP.L D1,D0
        BGE.W LBL_669
        MOVE.L A1,-(A7)
        MOVE.L -580(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -588(A6),D0
        MOVE.L D0,-(A7)
        LEA -592(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -592(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-588(A6)
        BRA.W LBL_670
LBL_669:
        MOVE.L A1,-(A7)
        MOVE.L -580(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-572(A6)
        BRA.W LBL_668
LBL_667:
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-564(A6)
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_671
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-568(A6)
        CLR.L -572(A6)
LBL_672:
        MOVE.L -572(A6),D0
        MOVE.L -568(A6),D1
        CMP.L D1,D0
        BGE.W LBL_671
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -572(A6),D0
        MOVE.L D0,-(A7)
        LEA -576(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -576(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-572(A6)
        BRA.W LBL_672
LBL_671:
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-564(A6)
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_673
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-568(A6)
        CLR.L -572(A6)
LBL_674:
        MOVE.L -572(A6),D0
        MOVE.L -568(A6),D1
        CMP.L D1,D0
        BGE.W LBL_673
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -572(A6),D0
        MOVE.L D0,-(A7)
        LEA -576(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -576(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-572(A6)
        BRA.W LBL_674
LBL_673:
        MOVE.L A1,-(A7)
        MOVE.L -564(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_651:
        UNLK A6
        RTS
        ; func smokeAliasing  (JT slot 81)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
        ;   local __store7 : -12(A6)  size 4
LBL_80:
        LINK A6,#-604
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-560(A6)
LBL_676:
        MOVE.L A1,-(A7)
        MOVE.L -560(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_188(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_677:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_677
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_678
        BRA.W LBL_679
LBL_678:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_245(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_680:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_680
        BSR.W LBL_1
LBL_679:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_250
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_189(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_681:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_681
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-560(A6)
LBL_682:
        MOVE.L A1,-(A7)
        MOVE.L -560(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_81
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-560(A6)
LBL_683:
        MOVE.L A1,-(A7)
        MOVE.L -560(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_190(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_684:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_684
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_191(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_685:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_685
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-560(A6)
LBL_686:
        MOVE.L A1,-(A7)
        MOVE.L -560(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-560(A6)
LBL_687:
        MOVE.L A1,-(A7)
        MOVE.L -560(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_675:
        UNLK A6
        RTS
        ; func other  (JT slot 82)
        ;   local l : -4(A6)  size 4
        ;   local __ret4 : -8(A6)  size 4
LBL_81:
        LINK A6,#-600
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L #4,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #42,D0
        MOVE.L D0,-12(A6)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-556(A6)
LBL_689:
        MOVE.L A1,-(A7)
        MOVE.L -556(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-556(A6)
LBL_690:
        MOVE.L A1,-(A7)
        MOVE.L -556(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        BRA.W LBL_688
LBL_688:
        UNLK A6
        RTS
        ; func smokeClamp3  (JT slot 83)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param s : 12(A6)  size 256
LBL_82:
        LINK A6,#-592
        MOVE.L 8(A6),-(A7)
        MOVE.L #3,-(A7)
        LEA 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #12,A7
        BRA.W LBL_691
LBL_691:
        UNLK A6
        RTS
        ; func smokeFileNameOf  (JT slot 84)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param p : 12(A6)  size 256
LBL_83:
        LINK A6,#-592
        MOVE.L 8(A6),-(A7)
        LEA 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        BRA.W LBL_692
LBL_692:
        UNLK A6
        RTS
        ; func smokeFiles  (JT slot 85)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local n : -268(A6)  size 256
        ;   local errMsg : -524(A6)  size 256
        ;   local e : -784(A6)  size 260
        ;   local __store8 : -788(A6)  size 4
        ;   local __store9 : -792(A6)  size 4
LBL_84:
        LINK A6,#-1384
        BSR.W LBL_7
        MOVE.L D0,-4(A6)
        BSR.W LBL_7
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-784(A6)
        LEA -780(A6),A0
        MOVE.W #127,D0
LBL_694:
        CLR.W (A0)+
        DBRA D0,LBL_694
        BSR.W LBL_7
        MOVE.L D0,-788(A6)
        BSR.W LBL_7
        MOVE.L D0,-792(A6)
        LEA -788(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_7
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-788(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -788(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-788(A6)
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_194(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_695:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_695
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_195(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_696:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_696
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_13
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_196(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_697:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_697
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -792(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_7
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-792(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -792(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-792(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #66,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        LEA LBL_198(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_199(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_698:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_698
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA LBL_198(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_200(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_699:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_699
        BSR.W LBL_71
        ADDA.W #258,A7
        MOVE.L #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_700
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_700:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_701
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_701:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_702
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_702:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_703
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_703:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_704
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_704:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #66,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_705
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_705:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_201(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_706:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_706
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_204(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_707:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_707
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_206(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_708:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_708
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_207(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_208(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_709:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_709
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA LBL_209(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_710:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_710
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_83
        ADDA.W #260,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_211(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_711:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_711
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_213(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_712:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_712
        BSR.W LBL_71
        ADDA.W #258,A7
        BSR.W LBL_61
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_214(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_713:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_713
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_100(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_215(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_714:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_714
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -784(A6),A0
        MOVEA.L A0,A1
        BSR.W LBL_61
        MOVE.L D0,0(A1)
        LEA 4(A1),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
        LEA -784(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_216(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_715:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_715
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -784(A6),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_100(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_217(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_716:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_716
        BSR.W LBL_71
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_693:
        UNLK A6
        RTS
LBL_250:
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
LBL_251:
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
        BPL.W LBL_717
        NEG.L D2
        MOVE.L #1,D4
LBL_717:
        CLR.L D5
        TST.L D3
        BPL.W LBL_718
        NEG.L D3
        MOVE.L #1,D5
LBL_718:
        CLR.L D6
        MOVE.W #31,D7
LBL_719:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_720
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_720:
        DBRA D7,LBL_719
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_721
        NEG.L D2
LBL_721:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_252:
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
        BPL.W LBL_722
        NEG.L D2
        MOVE.L #1,D4
LBL_722:
        CLR.L D5
        TST.L D3
        BPL.W LBL_723
        NEG.L D3
        MOVE.L #1,D5
LBL_723:
        CLR.L D6
        MOVE.W #31,D7
LBL_724:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_725
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_725:
        DBRA D7,LBL_724
        TST.L D4
        BEQ.W LBL_726
        NEG.L D6
LBL_726:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_253:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
LBL_727:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_248:
        ; cg_retain_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_249:
        ; cg_release_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_85:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_86:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_87:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_88:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_89:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_90:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_91:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_92:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_93:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_94:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_95:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_96:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_97:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_98:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_99:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_100:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_101:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_102:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_103:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_104:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_105:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
LBL_106:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$69,$72,$73,$74
        DC.B $00
LBL_107:
        DC.B $0D
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$6C,$61,$73,$74
LBL_108:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
LBL_109:
        DC.B $12
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
        DC.B $00
LBL_110:
        DC.B $10
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_111:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_112:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
LBL_113:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
        DC.B $00
LBL_114:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
LBL_115:
        DC.B $18
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
        DC.B $00
LBL_116:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_117:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_118:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$73,$75,$6D
LBL_119:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_120:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_121:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_122:
        DC.B $05
        DC.B $67,$61,$6D,$6D,$61
LBL_123:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
        DC.B $00
LBL_124:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$66,$69,$72,$73,$74
LBL_125:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$6C,$61,$73,$74
        DC.B $00
LBL_126:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
        DC.B $00
LBL_127:
        DC.B $04
        DC.B $42,$45,$54,$41
        DC.B $00
LBL_128:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
LBL_129:
        DC.B $16
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_130:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
LBL_131:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_132:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
LBL_133:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_134:
        DC.B $04
        DC.B $73,$6F,$6C,$6F
        DC.B $00
LBL_135:
        DC.B $03
        DC.B $64,$75,$6F
LBL_136:
        DC.B $1D
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
LBL_137:
        DC.B $23
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70
LBL_138:
        DC.B $03
        DC.B $6F,$6E,$65
LBL_139:
        DC.B $03
        DC.B $74,$77,$6F
LBL_140:
        DC.B $05
        DC.B $74,$68,$72,$65,$65
LBL_141:
        DC.B $17
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
LBL_142:
        DC.B $15
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
LBL_143:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_144:
        DC.B $04
        DC.B $66,$6F,$75,$72
        DC.B $00
LBL_145:
        DC.B $12
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_146:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_147:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_148:
        DC.B $11
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
LBL_149:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_150:
        DC.B $18
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_151:
        DC.B $0B
        DC.B $6E,$6F,$6E,$65,$78,$69,$73,$74,$65,$6E,$74
LBL_152:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$72,$65,$6D,$6F,$76,$65,$2D,$61,$62,$73,$65,$6E,$74,$20,$6E,$6F,$2D,$6F,$70
LBL_153:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$73,$75,$6D
LBL_154:
        DC.B $01
        DC.B $61
LBL_155:
        DC.B $05
        DC.B $61,$70,$70,$6C,$65
LBL_156:
        DC.B $01
        DC.B $62
LBL_157:
        DC.B $06
        DC.B $62,$61,$6E,$61,$6E,$61
        DC.B $00
LBL_158:
        DC.B $18
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
        DC.B $00
LBL_159:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
        DC.B $00
LBL_160:
        DC.B $01
        DC.B $7A
LBL_161:
        DC.B $04
        DC.B $6E,$6F,$6E,$65
        DC.B $00
LBL_162:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
LBL_163:
        DC.B $1C
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
        DC.B $00
LBL_164:
        DC.B $07
        DC.B $61,$76,$6F,$63,$61,$64,$6F
LBL_165:
        DC.B $12
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
        DC.B $00
LBL_166:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_167:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$76,$61,$6C,$75,$65
        DC.B $00
LBL_168:
        DC.B $05
        DC.B $68,$65,$6C,$6C,$6F
LBL_169:
        DC.B $07
        DC.B $2C,$20,$77,$6F,$72,$6C,$64
LBL_170:
        DC.B $0C
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64
        DC.B $00
LBL_171:
        DC.B $0F
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$73,$74,$72
LBL_172:
        DC.B $0D
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21
LBL_173:
        DC.B $10
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$63,$68,$61,$72
        DC.B $00
LBL_174:
        DC.B $08
        DC.B $20,$28,$61,$67,$61,$69,$6E,$29
        DC.B $00
LBL_175:
        DC.B $15
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21,$20,$28,$61,$67,$61,$69,$6E,$29
LBL_176:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74
LBL_177:
        DC.B $23
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74,$20,$6C,$65,$61,$76,$65,$73,$20,$73,$6F,$75,$72,$63,$65,$20,$75,$6E,$63,$68,$61,$6E,$67,$65,$64
LBL_178:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$6C,$65,$6E,$67,$74,$68
LBL_179:
        DC.B $0E
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$65,$71,$75,$61,$6C
        DC.B $00
LBL_180:
        DC.B $04
        DC.B $6E,$6F,$70,$65
        DC.B $00
LBL_181:
        DC.B $12
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$6E,$6F,$74,$2D,$65,$71,$75,$61,$6C
        DC.B $00
LBL_182:
        DC.B $01
        DC.B $6B
LBL_183:
        DC.B $02
        DC.B $76,$31
        DC.B $00
LBL_184:
        DC.B $18
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_185:
        DC.B $17
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$72,$65,$61,$64
LBL_186:
        DC.B $02
        DC.B $76,$32
        DC.B $00
LBL_187:
        DC.B $26
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$61,$6C,$69,$61,$73,$69,$6E,$67,$20,$28,$73,$61,$6D,$65,$20,$6D,$61,$70,$29
        DC.B $00
LBL_188:
        DC.B $25
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$6D,$75,$74,$61,$74,$65,$20,$76,$69,$61,$20,$62,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
LBL_189:
        DC.B $1E
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$76,$61,$6C,$75,$65,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
        DC.B $00
LBL_190:
        DC.B $21
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$20,$62,$20,$74,$6F,$20,$61,$20,$66,$72,$65,$73,$68,$20,$6C,$69,$73,$74
LBL_191:
        DC.B $27
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$69,$6E,$67,$20,$62,$20,$6C,$65,$61,$76,$65,$73,$20,$61,$20,$75,$6E,$74,$6F,$75,$63,$68,$65,$64
LBL_192:
        DC.B $0A
        DC.B $68,$65,$6C,$6C,$6F,$20,$66,$69,$6C,$65
        DC.B $00
LBL_193:
        DC.B $0D
        DC.B $73,$6D,$6F,$6B,$65,$66,$69,$6C,$65,$2E,$74,$78,$74
LBL_194:
        DC.B $11
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$6F,$6B
LBL_195:
        DC.B $10
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6F,$6B
        DC.B $00
LBL_196:
        DC.B $1D
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
LBL_197:
        DC.B $00
        DC.B $00
LBL_198:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$6E,$2E,$64,$61,$74
        DC.B $00
LBL_199:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
        DC.B $00
LBL_200:
        DC.B $17
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
LBL_201:
        DC.B $1B
        DC.B $66,$69,$6C,$65,$20,$62,$69,$6E,$61,$72,$79,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70,$20,$62,$79,$74,$65,$73
LBL_202:
        DC.B $09
        DC.B $61,$2F,$62,$2F,$63,$2E,$74,$78,$74
LBL_203:
        DC.B $05
        DC.B $63,$2E,$74,$78,$74
LBL_204:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$62,$61,$73,$65,$6E,$61,$6D,$65
        DC.B $00
LBL_205:
        DC.B $08
        DC.B $73,$6F,$6C,$6F,$2E,$74,$78,$74
        DC.B $00
LBL_206:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$6E,$6F,$2D,$73,$6C,$61,$73,$68
        DC.B $00
LBL_207:
        DC.B $04
        DC.B $64,$69,$72,$2F
        DC.B $00
LBL_208:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$74,$72,$61,$69,$6C,$69,$6E,$67,$20,$73,$6C,$61,$73,$68
        DC.B $00
LBL_209:
        DC.B $09
        DC.B $78,$2F,$79,$2F,$7A,$2E,$74,$78,$74
LBL_210:
        DC.B $05
        DC.B $7A,$2E,$74,$78,$74
LBL_211:
        DC.B $14
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$76,$69,$61,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_212:
        DC.B $18
        DC.B $73,$6D,$6F,$6B,$65,$2D,$64,$6F,$65,$73,$2D,$6E,$6F,$74,$2D,$65,$78,$69,$73,$74,$2E,$74,$78,$74
        DC.B $00
LBL_213:
        DC.B $23
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$72,$65,$74,$75,$72,$6E,$73,$20,$66,$61,$6C,$73,$65
LBL_214:
        DC.B $24
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$63,$6F,$64,$65
        DC.B $00
LBL_215:
        DC.B $27
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$6D,$65,$73,$73,$61,$67,$65
LBL_216:
        DC.B $25
        DC.B $65,$72,$72,$6F,$72,$20,$6C,$6F,$63,$61,$6C,$20,$63,$6F,$70,$79,$20,$28,$65,$20,$3D,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$29,$20,$63,$6F,$64,$65
LBL_217:
        DC.B $28
        DC.B $65,$72,$72,$6F,$72,$20,$6C,$6F,$63,$61,$6C,$20,$63,$6F,$70,$79,$20,$28,$65,$20,$3D,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$29,$20,$6D,$65,$73,$73,$61,$67,$65
        DC.B $00
LBL_218:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$67,$2E,$64,$61,$74
        DC.B $00
LBL_219:
        DC.B $16
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
        DC.B $00
LBL_220:
        DC.B $15
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
LBL_221:
        DC.B $22
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
        DC.B $00
LBL_222:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_223:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$79
        DC.B $00
LBL_224:
        DC.B $11
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_225:
        DC.B $17
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
LBL_226:
        DC.B $18
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_227:
        DC.B $1B
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_228:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_229:
        DC.B $0B
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$78
LBL_230:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
        DC.B $00
LBL_231:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$73,$74,$72
        DC.B $00
LBL_232:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$78
LBL_233:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$78
LBL_234:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_235:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_236:
        DC.B $17
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
LBL_237:
        DC.B $13
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$66,$69,$65,$6C,$64
LBL_238:
        DC.B $15
        DC.B $72,$65,$63,$6F,$72,$64,$20,$70,$61,$72,$61,$6D,$20,$62,$79,$20,$76,$61,$6C,$75,$65
LBL_239:
        DC.B $14
        DC.B $65,$6E,$75,$6D,$20,$69,$6E,$74,$2D,$3E,$65,$6E,$75,$6D,$20,$76,$61,$6C,$69,$64
        DC.B $00
LBL_240:
        DC.B $18
        DC.B $65,$6E,$75,$6D,$20,$65,$6E,$75,$6D,$2D,$3E,$69,$6E,$74,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70
        DC.B $00
LBL_241:
        DC.B $06
        DC.B $61,$62,$63,$64,$65,$66
        DC.B $00
LBL_242:
        DC.B $03
        DC.B $61,$62,$63
LBL_243:
        DC.B $1C
        DC.B $73,$74,$72,$69,$6E,$67,$28,$33,$29,$2D,$72,$65,$74,$75,$72,$6E,$20,$41,$42,$49,$20,$70,$61,$74,$68,$20,$6F,$6B
        DC.B $00
LBL_244:
        DC.B $0A
        DC.B $73,$6D,$6F,$6B,$65,$20,$64,$6F,$6E,$65
        DC.B $00
LBL_245:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_246:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
LBL_247:
        DC.L $00000005
        DC.L $00000006
        DC.L $00000007
        ; constant pool: serdesc tables (stub -- Task 8+)
