LBL_246:
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
LBL_249:
        CLR.W (A0)+
        DBRA D0,LBL_249
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        JSR LBL_247(PC)
        JSR LBL_55(PC)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR LBL_85(PC)
        JSR LBL_248(PC)
        CLR.L -(A7)
        JSR LBL_58(PC)
        RTS
LBL_247:
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
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-32(A5)
        MOVE.L #0,D0
        MOVE.L D0,-36(A5)
        LEA -292(A5),A0
        MOVE.W #127,D0
LBL_250:
        CLR.W (A0)+
        DBRA D0,LBL_250
        MOVE.L #0,D0
        MOVE.L D0,-296(A5)
        MOVE.L #0,D0
        MOVE.B D0,-298(A5)
        UNLK A6
        RTS
LBL_248:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
LBL_251:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#-80
        MOVE.L 264(A6),D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_253:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_253
        JSR LBL_60(PC)
        ADDA.W #260,A7
LBL_252:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 256
LBL_1:
        LINK A6,#-80
        LEA 8(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_255:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_255
        JSR LBL_59(PC)
        ADDA.W #256,A7
LBL_254:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 3)
        ;   param v : 266(A6)  size 4
        ;   param found : 264(A6)  size 2
        ;   param name : 8(A6)  size 256
LBL_2:
        LINK A6,#-80
        CLR.L D0
        MOVE.B 264(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_257
        LEA LBL_87(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_258:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_258
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_257:
        MOVE.L 266(A6),D0
        BRA.W LBL_256
LBL_256:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 4)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_3:
        LINK A6,#-88
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
        BEQ.W LBL_260
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_261
LBL_260:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_261:
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
        BEQ.W LBL_262
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_89(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_263:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_263
        JSR LBL_0(PC)
        ADDA.W #260,A7
LBL_262:
LBL_259:
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
        LINK A6,#-104
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
        BEQ.W LBL_265
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_266
LBL_265:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_266:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_268
LBL_267:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_268:
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
        BEQ.W LBL_269
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_89(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_270:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_270
        JSR LBL_0(PC)
        ADDA.W #260,A7
LBL_269:
LBL_264:
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
        LINK A6,#-104
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
        BEQ.W LBL_272
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_273
LBL_272:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_273:
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_274:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_275
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
        BEQ.W LBL_276
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_271
LBL_276:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        MOVE.L #1,D0
        BRA.W LBL_271
LBL_277:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_274
LBL_275:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_278
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_271
LBL_278:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_279
        MOVE.L #1,D0
        BRA.W LBL_271
LBL_279:
        MOVE.L #0,D0
        BRA.W LBL_271
LBL_271:
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
        LINK A6,#-96
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
        BEQ.W LBL_281
        BRA.W LBL_280
LBL_281:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_282
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_283
LBL_282:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_283:
LBL_284:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_284
LBL_285:
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
        BEQ.W LBL_287
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_288:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_288
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_287:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_280:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 8)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_7:
        LINK A6,#-88
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
        BEQ.W LBL_290
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_291:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_291
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_290:
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
        BEQ.W LBL_292
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_293:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_293
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_292:
        MOVE.L -4(A6),D0
        BRA.W LBL_289
LBL_289:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 9)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_8:
        LINK A6,#-84
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_295
        BRA.W LBL_294
LBL_295:
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
LBL_294:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 10)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_9:
        LINK A6,#-84
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_297
        BRA.W LBL_296
LBL_297:
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
        BEQ.W LBL_298
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_298:
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
        BEQ.W LBL_299
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
LBL_299:
LBL_296:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 11)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_10:
        LINK A6,#-92
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
LBL_300:
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
        LINK A6,#-124
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
        BEQ.W LBL_302
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_303
LBL_302:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
LBL_303:
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
        BEQ.W LBL_304
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_305
LBL_304:
        MOVE.L #1,D0
        MOVE.L D0,-28(A6)
LBL_305:
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
        BEQ.W LBL_306
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_307:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_307
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_306:
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
        BEQ.W LBL_308
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
        BRA.W LBL_309
LBL_308:
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
LBL_309:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_6(PC)
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
LBL_301:
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
        LINK A6,#-120
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
        BEQ.W LBL_311
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_312
LBL_311:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_312:
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
LBL_313:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
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
        BEQ.W LBL_315
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_310
LBL_315:
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_316
        MOVE.L #1,D0
        BRA.W LBL_310
LBL_316:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-24(A6)
        BRA.W LBL_313
LBL_314:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_317
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_310
LBL_317:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        MOVE.L #1,D0
        BRA.W LBL_310
LBL_318:
        MOVE.L #0,D0
        BRA.W LBL_310
LBL_310:
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
        LINK A6,#-112
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
        BEQ.W LBL_320
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_321
LBL_320:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_321:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
LBL_322:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
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
        BEQ.W LBL_324
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_319
LBL_324:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
        MOVE.L #1,D0
        BRA.W LBL_319
LBL_325:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_322
LBL_323:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_326
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_319
LBL_326:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_327
        MOVE.L #1,D0
        BRA.W LBL_319
LBL_327:
        MOVE.L #0,D0
        BRA.W LBL_319
LBL_319:
        UNLK A6
        RTS
        ; func rtTextLen  (JT slot 15)
        ;   param t : 8(A6)  size 4
LBL_14:
        LINK A6,#-80
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_328
LBL_328:
        UNLK A6
        RTS
        ; func rtTextIndex  (JT slot 16)
        ;   param t : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_15:
        LINK A6,#-88
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
        BNE.W LBL_330
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
        BRA.W LBL_331
LBL_330:
        MOVE.L #1,D0
LBL_331:
        TST.L D0
        BEQ.W LBL_332
        LEA LBL_93(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_333:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_333
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_332:
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
        BRA.W LBL_329
LBL_329:
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
        LINK A6,#-96
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
        JSR LBL_6(PC)
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
LBL_334:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 18)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_17:
        LINK A6,#-92
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
LBL_335:
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
        LINK A6,#-100
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
        BEQ.W LBL_337
        BRA.W LBL_336
LBL_337:
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
        BEQ.W LBL_338
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_339
LBL_338:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_339:
LBL_340:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_341
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_340
LBL_341:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
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
        BEQ.W LBL_342
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_343:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_343
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_342:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_336:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 20)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_19:
        LINK A6,#-88
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
        BEQ.W LBL_345
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_346:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_346
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_345:
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
        BEQ.W LBL_347
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_348:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_348
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_347:
        MOVE.L -4(A6),D0
        BRA.W LBL_344
LBL_344:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 21)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_20:
        LINK A6,#-84
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_350
        BRA.W LBL_349
LBL_350:
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
LBL_349:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 22)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_21:
        LINK A6,#-84
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_352
        BRA.W LBL_351
LBL_352:
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
        BEQ.W LBL_353
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_353:
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
        BEQ.W LBL_354
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
LBL_354:
LBL_351:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 23)
        ;   param l : 8(A6)  size 4
LBL_22:
        LINK A6,#-80
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_356
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
        BRA.W LBL_357
LBL_356:
        MOVE.L #0,D0
LBL_357:
        BRA.W LBL_355
LBL_355:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 24)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_23:
        LINK A6,#-92
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
        BNE.W LBL_359
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
        BRA.W LBL_360
LBL_359:
        MOVE.L #1,D0
LBL_360:
        TST.L D0
        BEQ.W LBL_361
        LEA LBL_94(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_362:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_362
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_361:
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
        JSR LBL_286(PC)
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_358
LBL_358:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 25)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_24:
        LINK A6,#-92
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
        JSR LBL_18(PC)
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
        JSR LBL_286(PC)
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
LBL_363:
        UNLK A6
        RTS
        ; func rtListPop  (JT slot 26)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_25:
        LINK A6,#-92
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
        BEQ.W LBL_365
        LEA LBL_95(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_366:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_366
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_365:
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
        JSR LBL_286(PC)
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
LBL_364:
        UNLK A6
        RTS
        ; func rtListShift  (JT slot 27)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local tailBytes : -12(A6)  size 4
LBL_26:
        LINK A6,#-92
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
        BEQ.W LBL_368
        LEA LBL_96(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_369:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_369
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_368:
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
        JSR LBL_286(PC)
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
LBL_367:
        UNLK A6
        RTS
        ; func rtListUnshift  (JT slot 28)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local bodyBytes : -12(A6)  size 4
LBL_27:
        LINK A6,#-92
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
        JSR LBL_18(PC)
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
        JSR LBL_286(PC)
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
LBL_370:
        UNLK A6
        RTS
        ; func rtListFirst  (JT slot 29)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_28:
        LINK A6,#-88
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
        BEQ.W LBL_372
        LEA LBL_97(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_373:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_373
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_372:
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
LBL_371:
        UNLK A6
        RTS
        ; func rtListLast  (JT slot 30)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_29:
        LINK A6,#-92
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
        BEQ.W LBL_375
        LEA LBL_98(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_376:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_376
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_375:
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
        JSR LBL_286(PC)
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
LBL_374:
        UNLK A6
        RTS
        ; func rtListRemove  (JT slot 31)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local tail : -12(A6)  size 4
LBL_30:
        LINK A6,#-92
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
        BNE.W LBL_378
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
        BRA.W LBL_379
LBL_378:
        MOVE.L #1,D0
LBL_379:
        TST.L D0
        BEQ.W LBL_380
        LEA LBL_94(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_381:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_381
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_380:
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
        BEQ.W LBL_382
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
        JSR LBL_286(PC)
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
        JSR LBL_286(PC)
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
        JSR LBL_286(PC)
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
LBL_382:
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
LBL_377:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 32)
        ;   param l : 8(A6)  size 4
LBL_31:
        LINK A6,#-80
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_383
LBL_383:
        UNLK A6
        RTS
        ; func mapKeySlot  (JT slot 33)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_32:
        LINK A6,#-80
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
        JSR LBL_286(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_384
LBL_384:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 34)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_33:
        LINK A6,#-80
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
        JSR LBL_286(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_385
LBL_385:
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
        LINK A6,#-96
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
LBL_387:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_388
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
        JSR LBL_389(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_32(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_5(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_391
LBL_390:
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
LBL_391:
        BRA.W LBL_387
LBL_388:
        MOVE.L -8(A6),D0
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func mapKeyEq  (JT slot 36)
        ;   param m : 16(A6)  size 4
        ;   param pos : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
LBL_35:
        LINK A6,#-80
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
        BEQ.W LBL_393
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_32(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_5(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_394
LBL_393:
        MOVE.L #0,D0
LBL_394:
        BRA.W LBL_392
LBL_392:
        UNLK A6
        RTS
        ; func mapFind  (JT slot 37)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local pos : -4(A6)  size 4
LBL_36:
        LINK A6,#-84
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_34(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_35(PC)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_396
        MOVE.L -4(A6),D0
        BRA.W LBL_395
LBL_396:
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_395
LBL_395:
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
        LINK A6,#-96
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
        BEQ.W LBL_398
        BRA.W LBL_397
LBL_398:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_399
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_400
LBL_399:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_400:
LBL_401:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_402
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_401
LBL_402:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
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
        BEQ.W LBL_403
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_404:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_404
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_403:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_397:
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
        LINK A6,#-100
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
        BEQ.W LBL_406
        BRA.W LBL_405
LBL_406:
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
        BEQ.W LBL_407
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_408
LBL_407:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_408:
LBL_409:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_410
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_409
LBL_410:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
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
        BEQ.W LBL_411
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_412:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_412
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_411:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_405:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 40)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_39:
        LINK A6,#-88
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
        BEQ.W LBL_414
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_415:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_415
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_414:
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
        BEQ.W LBL_416
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_417:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_417
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_416:
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
        BEQ.W LBL_418
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_419:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_419
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_418:
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
        BRA.W LBL_413
LBL_413:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 41)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_40:
        LINK A6,#-84
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        BRA.W LBL_420
LBL_421:
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
LBL_420:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 42)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_41:
        LINK A6,#-84
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_423
        BRA.W LBL_422
LBL_423:
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
        BEQ.W LBL_424
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_424:
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
        BEQ.W LBL_425
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
LBL_425:
LBL_422:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 43)
        ;   param m : 8(A6)  size 4
LBL_42:
        LINK A6,#-80
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_427
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
        BRA.W LBL_428
LBL_427:
        MOVE.L #0,D0
LBL_428:
        BRA.W LBL_426
LBL_426:
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
        LINK A6,#-100
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_34(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_35(PC)
        ADDA.W #12,A7
        TST.L D0
        BEQ.W LBL_430
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_33(PC)
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
        BRA.W LBL_429
LBL_430:
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
        JSR LBL_37(PC)
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
        JSR LBL_38(PC)
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
        BEQ.W LBL_431
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_32(PC)
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
        JSR LBL_32(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_33(PC)
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
        JSR LBL_33(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_431:
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_32(PC)
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
        JSR LBL_33(PC)
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
LBL_429:
        UNLK A6
        RTS
        ; func rtMapGet  (JT slot 45)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_44:
        LINK A6,#-84
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_36(PC)
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
        BEQ.W LBL_433
        LEA LBL_99(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_434:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_434
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_433:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_33(PC)
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
LBL_432:
        UNLK A6
        RTS
        ; func rtMapGetDv  (JT slot 46)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_45:
        LINK A6,#-84
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_36(PC)
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
        BEQ.W LBL_436
        MOVE.L #0,D0
        BRA.W LBL_435
LBL_436:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_33(PC)
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
        BRA.W LBL_435
LBL_435:
        UNLK A6
        RTS
        ; func rtMapHas  (JT slot 47)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
LBL_46:
        LINK A6,#-80
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_36(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_437
LBL_437:
        UNLK A6
        RTS
        ; func rtMapRemove  (JT slot 48)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local idx : -8(A6)  size 4
        ;   local tail : -12(A6)  size 4
LBL_47:
        LINK A6,#-92
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_36(PC)
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
        BEQ.W LBL_439
        BRA.W LBL_438
LBL_439:
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
        BEQ.W LBL_440
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR LBL_32(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_32(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
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
        JSR LBL_33(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_33(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        JSR LBL_286(PC)
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_440:
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
LBL_438:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 49)
        ;   param m : 8(A6)  size 4
LBL_48:
        LINK A6,#-80
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_441
LBL_441:
        UNLK A6
        RTS
        ; func rtMapKeyAt  (JT slot 50)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param key255 : 8(A6)  size 4
LBL_49:
        LINK A6,#-80
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_443
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
        BRA.W LBL_444
LBL_443:
        MOVE.L #1,D0
LBL_444:
        TST.L D0
        BEQ.W LBL_445
        LEA LBL_99(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_446:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_446
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_445:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_32(PC)
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
LBL_442:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 51)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_50:
        LINK A6,#-80
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_448
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
        BRA.W LBL_449
LBL_448:
        MOVE.L #1,D0
LBL_449:
        TST.L D0
        BEQ.W LBL_450
        LEA LBL_99(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_451:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_451
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_450:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_33(PC)
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
LBL_447:
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
        LINK A6,#-96
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_453:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
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
        BEQ.W LBL_455
        MOVE.L #10,D0
        MOVE.L D0,-12(A6)
LBL_455:
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
        BRA.W LBL_453
LBL_454:
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
        BRA.W LBL_452
LBL_452:
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
        LINK A6,#-98
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
        BEQ.W LBL_457
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,12(A6)
LBL_457:
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
        BEQ.W LBL_458
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_459
LBL_458:
LBL_460:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        JSR LBL_462(PC)
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
        JSR LBL_389(PC)
        MOVE.L D0,12(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_460
LBL_461:
LBL_459:
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_463
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-14(A6)
LBL_463:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_464:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
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
        BRA.W LBL_464
LBL_465:
        MOVE.L -14(A6),D0
        BRA.W LBL_456
LBL_456:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 54)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_53:
        LINK A6,#-80
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
        BRA.W LBL_466
LBL_467:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_468
        BRA.W LBL_466
LBL_468:
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
LBL_466:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 55)
LBL_54:
        LINK A6,#-80
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
LBL_469:
        UNLK A6
        RTS
        ; func natInit  (JT slot 56)
LBL_55:
        LINK A6,#-80
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_471
        BRA.W LBL_470
LBL_471:
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
        BEQ.W LBL_472
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        BRA.W LBL_470
LBL_472:
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
LBL_470:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 57)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_56:
        LINK A6,#-84
        JSR LBL_55(PC)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_51(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_53(PC)
        ADDQ.L #8,A7
        JSR LBL_54(PC)
LBL_473:
        UNLK A6
        RTS
        ; func natLog  (JT slot 58)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_57:
        LINK A6,#-88
        JSR LBL_55(PC)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_51(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_475:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_477
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_478
LBL_477:
        MOVE.L #0,D0
LBL_478:
        TST.L D0
        BEQ.W LBL_476
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
        BRA.W LBL_475
LBL_476:
LBL_474:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 59)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_58:
        LINK A6,#-84
        CLR.L D0
        MOVE.B -28(A5),D0
        TST.L D0
        BEQ.W LBL_480
        BRA.W LBL_479
LBL_480:
        MOVE.L #1,D0
        MOVE.B D0,-28(A5)
        JSR LBL_55(PC)
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
        JSR LBL_53(PC)
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_52(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_53(PC)
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
        JSR LBL_53(PC)
        ADDQ.L #8,A7
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        JSR LBL_53(PC)
        ADDQ.L #8,A7
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
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
LBL_481:
        JSR LBL_54(PC)
        DC.W $A9F4  ; NatExitToShell
LBL_479:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 60)
        ;   param msg : 8(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_59:
        LINK A6,#-336
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_100(PC),A0
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
        JSR LBL_57(PC)
        ADDQ.L #4,A7
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        JSR LBL_58(PC)
        ADDQ.L #4,A7
LBL_482:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 61)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_60:
        LINK A6,#-80
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
LBL_483:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 62)
LBL_61:
        LINK A6,#-80
        MOVE.L -36(A5),D0
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 63)
        ;   hidden result ptr : 8(A6)  size 4
LBL_62:
        LINK A6,#-80
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -292(A5),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        BRA.W LBL_485
LBL_485:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 64)
        ;   local __ret1 : -4(A6)  size 4
LBL_63:
        LINK A6,#-84
        MOVE.L #256,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-40(A6)
LBL_487:
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_20(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_486
LBL_486:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 65)
LBL_64:
        LINK A6,#-80
        CLR.L D0
        MOVE.B -298(A5),D0
        TST.L D0
        BEQ.W LBL_489
        BRA.W LBL_488
LBL_489:
        MOVE.L #1,D0
        MOVE.B D0,-298(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-296(A5)
LBL_488:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 66)
LBL_65:
        LINK A6,#-80
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
LBL_490:
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
        LINK A6,#-102
        JSR LBL_64(PC)
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
        BEQ.W LBL_492
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_101(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_493:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_493
        JSR LBL_0(PC)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_491
LBL_492:
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
        BEQ.W LBL_494
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
        BEQ.W LBL_495
        MOVE.L #1,D0
        MOVE.B D0,-22(A6)
LBL_495:
LBL_494:
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
        JSR LBL_65(PC)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_496
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_497
LBL_496:
        MOVE.L #1,D0
LBL_497:
        TST.L D0
        BEQ.W LBL_498
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_499:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_499
        JSR LBL_0(PC)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_491
LBL_498:
        MOVE.L #1,D0
        BRA.W LBL_491
LBL_491:
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
        LINK A6,#-110
        JSR LBL_64(PC)
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
        JSR LBL_0(PC)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_500
LBL_501:
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
        BEQ.W LBL_503
        LEA LBL_92(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_504:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_504
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_503:
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
LBL_505:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_506
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
        BEQ.W LBL_507
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_508
LBL_507:
        MOVE.L #0,D0
LBL_508:
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
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_103(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_510:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_510
        JSR LBL_0(PC)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_500
LBL_509:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR LBL_6(PC)
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
LBL_511:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_512
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_513
LBL_512:
        MOVE.L #1,D0
LBL_513:
        TST.L D0
        BEQ.W LBL_514
        MOVE.L #1,D0
        MOVE.B D0,-30(A6)
LBL_514:
        BRA.W LBL_505
LBL_506:
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
        BRA.W LBL_500
LBL_500:
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
        LINK A6,#-100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_516:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
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
        BEQ.W LBL_518
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_518:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_516
LBL_517:
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
LBL_519:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
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
        BRA.W LBL_519
LBL_520:
LBL_515:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 70)
        ;   param path : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
LBL_69:
        LINK A6,#-80
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_66(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_522
        MOVE.L #1,D0
        BRA.W LBL_521
LBL_522:
        MOVE.L #0,D0
        BRA.W LBL_521
LBL_521:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 71)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_70:
        LINK A6,#-80
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_67(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_524
        MOVE.L #1,D0
        BRA.W LBL_523
LBL_524:
        MOVE.L #0,D0
        BRA.W LBL_523
LBL_523:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 72)
        ;   param cond : 264(A6)  size 2
        ;   param label : 8(A6)  size 256
        ;   local msg : -256(A6)  size 256
LBL_71:
        LINK A6,#-336
        CLR.L D0
        MOVE.B 264(A6),D0
        TST.L D0
        BEQ.W LBL_526
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_104(PC),A0
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
        BRA.W LBL_527
LBL_526:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_105(PC),A0
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
LBL_527:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_56(PC)
        ADDQ.L #4,A7
LBL_525:
        UNLK A6
        RTS
        ; func smokeMakePoint  (JT slot 73)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -48(A6)  size 48
        ;   local __store1 : -96(A6)  size 48
        ;   local __ret2 : -144(A6)  size 48
LBL_72:
        LINK A6,#-224
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
LBL_529:
        CLR.W (A0)+
        DBRA D0,LBL_529
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
LBL_530:
        CLR.W (A0)+
        DBRA D0,LBL_530
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
LBL_531:
        CLR.W (A0)+
        DBRA D0,LBL_531
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
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
LBL_532:
        CLR.W (A0)+
        DBRA D0,LBL_532
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_242(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_533:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_533
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
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_534:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_534
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_242(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_535:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_535
        BRA.W LBL_528
LBL_528:
        UNLK A6
        RTS
        ; func smokeTakePoint  (JT slot 74)
        ;   param p : 8(A6)  size 48
        ;   local __ret3 : -4(A6)  size 4
LBL_73:
        LINK A6,#-84
        LEA 8(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_242(PC)
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
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_536
LBL_536:
        UNLK A6
        RTS
        ; func smokeListInt  (JT slot 75)
        ;   local l : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local x : -16(A6)  size 4
LBL_74:
        LINK A6,#-96
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #30,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_106(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_538:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_538
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_28(PC)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_107(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_539:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_539
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_29(PC)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #30,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_108(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_540:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_540
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_541
        BRA.W LBL_542
LBL_541:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_543:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_543
        JSR LBL_1(PC)
LBL_542:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        LEA LBL_109(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_544:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_544
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L #25,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_545
        BRA.W LBL_546
LBL_545:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_547:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_547
        JSR LBL_1(PC)
LBL_546:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        BCC.W LBL_548
        BRA.W LBL_549
LBL_548:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_550:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_550
        JSR LBL_1(PC)
LBL_549:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        LEA LBL_110(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_551:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_551
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_27(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_552
        BRA.W LBL_553
LBL_552:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_554:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_554
        JSR LBL_1(PC)
LBL_553:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        LEA LBL_111(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_555:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_555
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_112(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_556:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_556
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_26(PC)
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
        LEA LBL_113(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_557:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_557
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_114(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_558:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_558
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_25(PC)
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
        LEA LBL_115(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_559:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_559
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_116(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_560:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_560
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_30(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_117(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_561:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_561
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_562
        BRA.W LBL_563
LBL_562:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_564:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_564
        JSR LBL_1(PC)
LBL_563:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        LEA LBL_118(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_565:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_565
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #100,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #200,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_566:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_568
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        JSR LBL_23(PC)
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
LBL_567:
        ADDQ.L #1,(A7)
        BRA.W LBL_566
LBL_568:
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
        LEA LBL_119(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_569:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_569
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_120(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_570:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_570
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-52(A6)
LBL_571:
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_537:
        UNLK A6
        RTS
        ; func smokeListText  (JT slot 76)
        ;   local l : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local __store2 : -12(A6)  size 4
        ;   local __store3 : -16(A6)  size 4
LBL_75:
        LINK A6,#-96
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-8(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-12(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_7(PC)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_7(PC)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_7(PC)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_124(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_573:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_573
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_28(PC)
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
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
LBL_574:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_574
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_29(PC)
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
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
LBL_575:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_575
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_576
        BRA.W LBL_577
LBL_576:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_578:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_578
        JSR LBL_1(PC)
LBL_577:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_127(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_579:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_579
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #1,D0
        MOVE.L D0,-24(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_580
        BRA.W LBL_581
LBL_580:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_582:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_582
        JSR LBL_1(PC)
LBL_581:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
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
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_585:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_585
        JSR LBL_1(PC)
LBL_584:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        BCC.W LBL_586
        BRA.W LBL_587
LBL_586:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_588:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_588
        JSR LBL_1(PC)
LBL_587:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
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
LBL_589:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_589
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_26(PC)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_130(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_590:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_590
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_131(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_591:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_591
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_132(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_592:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_592
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_133(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_593:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_593
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_594
        BRA.W LBL_595
LBL_594:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_596:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_596
        JSR LBL_1(PC)
LBL_595:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_30(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_134(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_597:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_597
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_7(PC)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_7(PC)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_137(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_598:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_598
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_599
        BRA.W LBL_600
LBL_599:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_601:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_601
        JSR LBL_1(PC)
LBL_600:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_138(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_602:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_602
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_22(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_603
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-56(A6)
        CLR.L -60(A6)
LBL_604:
        MOVE.L -60(A6),D0
        MOVE.L -56(A6),D1
        CMP.L D1,D0
        BGE.W LBL_603
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_23(PC)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-60(A6)
        BRA.W LBL_604
LBL_603:
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_572:
        UNLK A6
        RTS
        ; func smokeMapInt  (JT slot 77)
        ;   local m : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local k : -264(A6)  size 256
        ;   local v : -268(A6)  size 4
LBL_76:
        LINK A6,#-348
        MOVE.L #4,-(A7)
        JSR LBL_39(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #1,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #2,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #3,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_142(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_606:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_606
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_143(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_607:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_607
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-(A7)
        LEA LBL_144(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_608:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_608
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_146(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_609:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_609
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #99,D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_45(PC)
        ADDA.W #12,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #99,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_147(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_610:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_610
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #99,D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_45(PC)
        ADDA.W #12,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_148(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_611:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_611
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L #22,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_149(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_612:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_612
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_47(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_150(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_613:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_613
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_151(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_614:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_614
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_152(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_47(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_153(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_615:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_615
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_616:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_618
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_49(PC)
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -268(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_617:
        ADDQ.L #1,(A7)
        BRA.W LBL_616
LBL_618:
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
        LEA LBL_154(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_619:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_619
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-304(A6)
LBL_620:
        MOVE.L A1,-(A7)
        MOVE.L -304(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_41(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_605:
        UNLK A6
        RTS
        ; func smokeMapText  (JT slot 78)
        ;   local m : -4(A6)  size 4
        ;   local k : -260(A6)  size 256
        ;   local v : -264(A6)  size 4
        ;   local found : -268(A6)  size 4
LBL_77:
        LINK A6,#-348
        MOVE.L #4,-(A7)
        JSR LBL_39(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-264(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-268(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_622
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_622:
        JSR LBL_7(PC)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_623
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_623:
        JSR LBL_7(PC)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_158(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_159(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_624:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_624
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_160(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_625:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_625
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-284(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,-(A7)
        LEA -284(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_45(PC)
        ADDA.W #12,A7
        MOVE.L -284(A6),D0
        MOVE.L -276(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_626
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_626:
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
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
LBL_627:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_627
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -280(A6),D0
        MOVE.L D0,-276(A6)
        MOVE.L -276(A6),D0
        MOVE.L D0,-284(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        LEA -284(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_45(PC)
        ADDA.W #12,A7
        MOVE.L -284(A6),D0
        MOVE.L -276(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_628
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_628:
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_164(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_629:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_629
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_630
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_630:
        JSR LBL_7(PC)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_165(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_165(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_166(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_631:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_631
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_632
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_632:
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_47(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_167(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_633:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_633
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_634:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_636
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_49(PC)
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -264(A6),D0
        MOVE.L D0,-268(A6)
LBL_635:
        ADDQ.L #1,(A7)
        BRA.W LBL_634
LBL_636:
        ADDA.W #12,A7
        MOVE.L -268(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_165(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_168(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_637:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_637
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-304(A6)
        MOVE.L A1,-(A7)
        MOVE.L -304(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_42(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_638
        MOVE.L A1,-(A7)
        MOVE.L -304(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-308(A6)
        CLR.L -312(A6)
LBL_639:
        MOVE.L -312(A6),D0
        MOVE.L -308(A6),D1
        CMP.L D1,D0
        BGE.W LBL_638
        MOVE.L A1,-(A7)
        MOVE.L -304(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -312(A6),D0
        MOVE.L D0,-(A7)
        LEA -316(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -316(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-312(A6)
        BRA.W LBL_639
LBL_638:
        MOVE.L A1,-(A7)
        MOVE.L -304(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_41(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_621:
        UNLK A6
        RTS
        ; func smokeTextOps  (JT slot 79)
        ;   local t : -4(A6)  size 4
        ;   local __store4 : -8(A6)  size 4
        ;   local u : -12(A6)  size 4
        ;   local __store5 : -16(A6)  size 4
LBL_78:
        LINK A6,#-96
        JSR LBL_7(PC)
        MOVE.L D0,-4(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-8(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-12(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-16(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR LBL_7(PC)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-8(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_170(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_16(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_172(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_641:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_641
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #33,D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_174(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_642:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_642
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR LBL_7(PC)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_175(PC),A0
        MOVE.L A0,-(A7)
        CLR.L -(A7)
        JSR LBL_11(PC)
        ADDA.W #16,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_176(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
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
LBL_643:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_643
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_178(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_644:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_644
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_14(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_179(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_645:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_645
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_180(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_646:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_646
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_181(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_182(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_647:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_647
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_640:
        UNLK A6
        RTS
        ; func smokeNested  (JT slot 80)
        ;   local lm : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local got : -12(A6)  size 4
        ;   local __store6 : -16(A6)  size 4
LBL_79:
        LINK A6,#-96
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L #4,-(A7)
        JSR LBL_39(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #4,-(A7)
        JSR LBL_39(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L #4,-(A7)
        JSR LBL_39(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_649
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_649:
        JSR LBL_7(PC)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_184(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_40(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_185(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_650:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_650
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -16(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_42(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_651
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-56(A6)
        CLR.L -60(A6)
LBL_652:
        MOVE.L -60(A6),D0
        MOVE.L -56(A6),D1
        CMP.L D1,D0
        BGE.W LBL_651
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        LEA -64(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -64(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-60(A6)
        BRA.W LBL_652
LBL_651:
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_41(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_653
        BRA.W LBL_654
LBL_653:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_655:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_655
        JSR LBL_1(PC)
LBL_654:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        JSR LBL_40(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_42(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_656
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-56(A6)
        CLR.L -60(A6)
LBL_657:
        MOVE.L -60(A6),D0
        MOVE.L -56(A6),D1
        CMP.L D1,D0
        BGE.W LBL_656
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        LEA -64(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -64(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-60(A6)
        BRA.W LBL_657
LBL_656:
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_41(PC)
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
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_184(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_186(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_658:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_658
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_46(PC)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_659
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_659:
        JSR LBL_7(PC)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_43(PC)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_660
        BRA.W LBL_661
LBL_660:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_662:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_662
        JSR LBL_1(PC)
LBL_661:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_44(PC)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_8(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_188(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_663:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_663
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_22(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_664
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-56(A6)
        CLR.L -60(A6)
LBL_665:
        MOVE.L -60(A6),D0
        MOVE.L -56(A6),D1
        CMP.L D1,D0
        BGE.W LBL_664
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_23(PC)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-68(A6)
        MOVE.L A1,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_42(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_666
        MOVE.L A1,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-72(A6)
        CLR.L -76(A6)
LBL_667:
        MOVE.L -76(A6),D0
        MOVE.L -72(A6),D1
        CMP.L D1,D0
        BGE.W LBL_666
        MOVE.L A1,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        LEA -80(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -80(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-76(A6)
        BRA.W LBL_667
LBL_666:
        MOVE.L A1,-(A7)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_41(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-60(A6)
        BRA.W LBL_665
LBL_664:
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_42(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_668
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-56(A6)
        CLR.L -60(A6)
LBL_669:
        MOVE.L -60(A6),D0
        MOVE.L -56(A6),D1
        CMP.L D1,D0
        BGE.W LBL_668
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        LEA -64(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -64(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-60(A6)
        BRA.W LBL_669
LBL_668:
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_41(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_42(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_670
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_48(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-56(A6)
        CLR.L -60(A6)
LBL_671:
        MOVE.L -60(A6),D0
        MOVE.L -56(A6),D1
        CMP.L D1,D0
        BGE.W LBL_670
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        LEA -64(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_50(PC)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -64(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-60(A6)
        BRA.W LBL_671
LBL_670:
        MOVE.L A1,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_41(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_648:
        UNLK A6
        RTS
        ; func smokeAliasing  (JT slot 81)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
        ;   local __store7 : -12(A6)  size 4
LBL_80:
        LINK A6,#-92
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_20(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-48(A6)
LBL_673:
        MOVE.L A1,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
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
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
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
LBL_674:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_674
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_675
        BRA.W LBL_676
LBL_675:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_677:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_677
        JSR LBL_1(PC)
LBL_676:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        JSR LBL_286(PC)
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
        LEA LBL_190(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_678:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_678
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-48(A6)
LBL_679:
        MOVE.L A1,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR LBL_81(PC)
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-48(A6)
LBL_680:
        MOVE.L A1,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_191(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_681:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_681
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_31(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_192(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_682:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_682
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-48(A6)
LBL_683:
        MOVE.L A1,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-48(A6)
LBL_684:
        MOVE.L A1,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_672:
        UNLK A6
        RTS
        ; func other  (JT slot 82)
        ;   local l : -4(A6)  size 4
        ;   local __ret4 : -8(A6)  size 4
LBL_81:
        LINK A6,#-88
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L #4,-(A7)
        JSR LBL_19(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #42,D0
        MOVE.L D0,-12(A6)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #8,A7
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-44(A6)
LBL_686:
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_20(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-44(A6)
LBL_687:
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_21(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        BRA.W LBL_685
LBL_685:
        UNLK A6
        RTS
        ; func smokeFileNameOf  (JT slot 83)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param p : 12(A6)  size 256
LBL_82:
        LINK A6,#-80
        MOVE.L 8(A6),-(A7)
        LEA 12(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_68(PC)
        ADDQ.L #8,A7
        BRA.W LBL_688
LBL_688:
        UNLK A6
        RTS
        ; func smokeFiles  (JT slot 84)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local n : -268(A6)  size 256
        ;   local errMsg : -524(A6)  size 256
        ;   local __store8 : -528(A6)  size 4
        ;   local __store9 : -532(A6)  size 4
LBL_83:
        LINK A6,#-612
        JSR LBL_7(PC)
        MOVE.L D0,-4(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-8(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-528(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-532(A6)
        LEA -528(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR LBL_7(PC)
        MOVE.L D0,-536(A6)
        MOVE.L -536(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -536(A6),D0
        MOVE.L D0,-528(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -528(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-528(A6)
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_66(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_195(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_690:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_690
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_67(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_196(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_691:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_691
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_13(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_197(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_692:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_692
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -532(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR LBL_7(PC)
        MOVE.L D0,-536(A6)
        MOVE.L -536(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -536(A6),D0
        MOVE.L D0,-532(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -532(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-532(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #66,D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
        ADDQ.L #8,A7
        LEA LBL_199(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_66(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_200(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_693:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_693
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA LBL_199(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_67(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_201(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_694:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_694
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_14(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_695
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_695:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_696
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_696:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_697
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_697:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_698
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_698:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_699
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_699:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #66,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_700
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_700:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_202(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_701:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_701
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_68(PC)
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_204(PC),A0
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
        LEA LBL_205(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_702:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_702
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_206(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_68(PC)
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_206(PC),A0
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
        LEA LBL_207(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_703:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_703
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_68(PC)
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_198(PC),A0
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
        LEA LBL_209(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_704:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_704
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA LBL_210(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_705:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_705
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_82(PC)
        ADDA.W #260,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_211(PC),A0
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
        LEA LBL_212(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_706:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_706
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_67(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_214(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_707:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_707
        JSR LBL_71(PC)
        ADDA.W #258,A7
        JSR LBL_61(PC)
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_215(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_708:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_708
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_62(PC)
        ADDQ.L #4,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_101(PC),A0
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
        LEA LBL_216(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_709:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_709
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_689:
        UNLK A6
        RTS
        ; func smokeFilesBig  (JT slot 85)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local i : -16(A6)  size 4
        ;   local n : -20(A6)  size 4
        ;   local __store10 : -24(A6)  size 4
LBL_84:
        LINK A6,#-104
        JSR LBL_7(PC)
        MOVE.L D0,-4(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-8(A6)
        JSR LBL_7(PC)
        MOVE.L D0,-24(A6)
        MOVE.L #40000,D0
        MOVE.L D0,-20(A6)
        LEA -24(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR LBL_7(PC)
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_10(PC)
        ADDQ.L #8,A7
        MOVE.L -28(A6),D0
        MOVE.L D0,-24(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_711:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_712
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        JSR LBL_462(PC)
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR LBL_17(PC)
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_711
LBL_712:
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_66(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_218(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_713:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_713
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_67(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_219(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_714:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_714
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_14(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_715
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_715:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_716
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_716:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        JSR LBL_462(PC)
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_717
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_717:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        JSR LBL_462(PC)
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_718
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_718:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L D0,-(A7)
        JSR LBL_15(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        JSR LBL_462(PC)
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_719
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_719:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_220(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_720:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_720
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR LBL_9(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_710:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 86)
        ;   local p : -48(A6)  size 48
        ;   local __store11 : -96(A6)  size 48
        ;   local q : -144(A6)  size 48
        ;   local e : -148(A6)  size 4
        ;   local n : -152(A6)  size 4
        ;   local __store12 : -200(A6)  size 48
        ;   local __store13 : -248(A6)  size 48
LBL_85:
        LINK A6,#-328
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
LBL_722:
        CLR.W (A0)+
        DBRA D0,LBL_722
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
LBL_723:
        CLR.W (A0)+
        DBRA D0,LBL_723
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
LBL_724:
        CLR.W (A0)+
        DBRA D0,LBL_724
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
LBL_725:
        CLR.W (A0)+
        DBRA D0,LBL_725
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
LBL_726:
        CLR.W (A0)+
        DBRA D0,LBL_726
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
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
LBL_727:
        CLR.W (A0)+
        DBRA D0,LBL_727
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_242(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_728:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_728
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
        LEA LBL_221(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_729:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_729
        JSR LBL_71(PC)
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
        LEA LBL_222(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_730:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_730
        JSR LBL_71(PC)
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
        LEA LBL_223(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_731:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_731
        JSR LBL_71(PC)
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
        LEA LBL_224(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_732:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_732
        JSR LBL_71(PC)
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
        LEA LBL_225(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_733:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_733
        JSR LBL_71(PC)
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
        LEA LBL_226(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_734:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_734
        JSR LBL_71(PC)
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
        LEA LBL_227(PC),A0
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
        LEA LBL_228(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_735:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_735
        JSR LBL_71(PC)
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
        LEA LBL_229(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_736:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_736
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_227(PC),A0
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
        LEA LBL_230(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_737:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_737
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -200(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_738:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_738
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_242(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -200(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_739:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_739
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
        LEA LBL_231(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_740:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_740
        JSR LBL_71(PC)
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
        LEA LBL_232(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_741:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_741
        JSR LBL_71(PC)
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
        LEA LBL_233(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_742:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_742
        JSR LBL_71(PC)
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
        LEA LBL_234(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_743:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_743
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -248(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_72(PC)
        ADDQ.L #8,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_744:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_744
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
        LEA LBL_235(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_745:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_745
        JSR LBL_71(PC)
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
        LEA LBL_236(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_746:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_746
        JSR LBL_71(PC)
        ADDA.W #258,A7
        LEA -48(A6),A0
        ADDA.L #-48,A7
        MOVEA.L A7,A1
        MOVE.W #23,D0
LBL_747:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_747
        JSR LBL_73(PC)
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
        LEA LBL_237(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_748:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_748
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L #6,D0
        MOVE.L D0,D1
        LEA LBL_245(PC),A0
        MOVE.W #2,D2
LBL_750:
        CMP.L (A0)+,D1
        BEQ.W LBL_749
        DBRA D2,LBL_750
        ; enum conversion miss -> rtEnumCheck(v, false, <name arg unused>) panics
        MOVE.L D1,-(A7)
        CLR.W -(A7)
        ADDA.L #-256,A7
        JSR LBL_2(PC)
        ADDA.W #262,A7
LBL_749:
        MOVE.L D0,-148(A6)
        MOVE.L -148(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_238(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_751:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_751
        JSR LBL_71(PC)
        ADDA.W #258,A7
        MOVE.L -148(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_239(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_752:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_752
        JSR LBL_71(PC)
        ADDA.W #258,A7
        JSR LBL_74(PC)
        JSR LBL_75(PC)
        JSR LBL_76(PC)
        JSR LBL_77(PC)
        JSR LBL_78(PC)
        JSR LBL_79(PC)
        JSR LBL_80(PC)
        JSR LBL_83(PC)
        JSR LBL_84(PC)
        LEA LBL_240(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_56(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR LBL_248(PC)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR LBL_58(PC)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        JSR LBL_243(PC)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_721:
        UNLK A6
        RTS
LBL_286:
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
LBL_389:
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
LBL_462:
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
        BPL.W LBL_758
        NEG.L D2
        MOVE.L #1,D4
LBL_758:
        CLR.L D5
        TST.L D3
        BPL.W LBL_759
        NEG.L D3
        MOVE.L #1,D5
LBL_759:
        CLR.L D6
        MOVE.W #31,D7
LBL_760:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_761
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_761:
        DBRA D7,LBL_760
        TST.L D4
        BEQ.W LBL_762
        NEG.L D6
LBL_762:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_242:
        ; cg_retain_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_243:
        ; cg_release_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_86:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_87:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_88:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_89:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_90:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_91:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_92:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_93:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_94:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_95:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_96:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_97:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_98:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_99:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_100:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_101:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_102:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_103:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_104:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_105:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_106:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
LBL_107:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$69,$72,$73,$74
        DC.B $00
LBL_108:
        DC.B $0D
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$6C,$61,$73,$74
LBL_109:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
LBL_110:
        DC.B $12
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
        DC.B $00
LBL_111:
        DC.B $10
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_112:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_113:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
LBL_114:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
        DC.B $00
LBL_115:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
LBL_116:
        DC.B $18
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
        DC.B $00
LBL_117:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_118:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_119:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$73,$75,$6D
LBL_120:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_121:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_122:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_123:
        DC.B $05
        DC.B $67,$61,$6D,$6D,$61
LBL_124:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
        DC.B $00
LBL_125:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$66,$69,$72,$73,$74
LBL_126:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$6C,$61,$73,$74
        DC.B $00
LBL_127:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
        DC.B $00
LBL_128:
        DC.B $04
        DC.B $42,$45,$54,$41
        DC.B $00
LBL_129:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
LBL_130:
        DC.B $16
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_131:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
LBL_132:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_133:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
LBL_134:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_135:
        DC.B $04
        DC.B $73,$6F,$6C,$6F
        DC.B $00
LBL_136:
        DC.B $03
        DC.B $64,$75,$6F
LBL_137:
        DC.B $1D
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
LBL_138:
        DC.B $23
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70
LBL_139:
        DC.B $03
        DC.B $6F,$6E,$65
LBL_140:
        DC.B $03
        DC.B $74,$77,$6F
LBL_141:
        DC.B $05
        DC.B $74,$68,$72,$65,$65
LBL_142:
        DC.B $17
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
LBL_143:
        DC.B $15
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
LBL_144:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_145:
        DC.B $04
        DC.B $66,$6F,$75,$72
        DC.B $00
LBL_146:
        DC.B $12
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_147:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_148:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_149:
        DC.B $11
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
LBL_150:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_151:
        DC.B $18
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_152:
        DC.B $0B
        DC.B $6E,$6F,$6E,$65,$78,$69,$73,$74,$65,$6E,$74
LBL_153:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$72,$65,$6D,$6F,$76,$65,$2D,$61,$62,$73,$65,$6E,$74,$20,$6E,$6F,$2D,$6F,$70
LBL_154:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$73,$75,$6D
LBL_155:
        DC.B $01
        DC.B $61
LBL_156:
        DC.B $05
        DC.B $61,$70,$70,$6C,$65
LBL_157:
        DC.B $01
        DC.B $62
LBL_158:
        DC.B $06
        DC.B $62,$61,$6E,$61,$6E,$61
        DC.B $00
LBL_159:
        DC.B $18
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
        DC.B $00
LBL_160:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
        DC.B $00
LBL_161:
        DC.B $01
        DC.B $7A
LBL_162:
        DC.B $04
        DC.B $6E,$6F,$6E,$65
        DC.B $00
LBL_163:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
LBL_164:
        DC.B $1C
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
        DC.B $00
LBL_165:
        DC.B $07
        DC.B $61,$76,$6F,$63,$61,$64,$6F
LBL_166:
        DC.B $12
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
        DC.B $00
LBL_167:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_168:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$76,$61,$6C,$75,$65
        DC.B $00
LBL_169:
        DC.B $05
        DC.B $68,$65,$6C,$6C,$6F
LBL_170:
        DC.B $07
        DC.B $2C,$20,$77,$6F,$72,$6C,$64
LBL_171:
        DC.B $0C
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64
        DC.B $00
LBL_172:
        DC.B $0F
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$73,$74,$72
LBL_173:
        DC.B $0D
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21
LBL_174:
        DC.B $10
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$63,$68,$61,$72
        DC.B $00
LBL_175:
        DC.B $08
        DC.B $20,$28,$61,$67,$61,$69,$6E,$29
        DC.B $00
LBL_176:
        DC.B $15
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21,$20,$28,$61,$67,$61,$69,$6E,$29
LBL_177:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74
LBL_178:
        DC.B $23
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74,$20,$6C,$65,$61,$76,$65,$73,$20,$73,$6F,$75,$72,$63,$65,$20,$75,$6E,$63,$68,$61,$6E,$67,$65,$64
LBL_179:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$6C,$65,$6E,$67,$74,$68
LBL_180:
        DC.B $0E
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$65,$71,$75,$61,$6C
        DC.B $00
LBL_181:
        DC.B $04
        DC.B $6E,$6F,$70,$65
        DC.B $00
LBL_182:
        DC.B $12
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$6E,$6F,$74,$2D,$65,$71,$75,$61,$6C
        DC.B $00
LBL_183:
        DC.B $01
        DC.B $6B
LBL_184:
        DC.B $02
        DC.B $76,$31
        DC.B $00
LBL_185:
        DC.B $18
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_186:
        DC.B $17
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$72,$65,$61,$64
LBL_187:
        DC.B $02
        DC.B $76,$32
        DC.B $00
LBL_188:
        DC.B $26
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$61,$6C,$69,$61,$73,$69,$6E,$67,$20,$28,$73,$61,$6D,$65,$20,$6D,$61,$70,$29
        DC.B $00
LBL_189:
        DC.B $25
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$6D,$75,$74,$61,$74,$65,$20,$76,$69,$61,$20,$62,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
LBL_190:
        DC.B $1E
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$76,$61,$6C,$75,$65,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
        DC.B $00
LBL_191:
        DC.B $21
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$20,$62,$20,$74,$6F,$20,$61,$20,$66,$72,$65,$73,$68,$20,$6C,$69,$73,$74
LBL_192:
        DC.B $27
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$69,$6E,$67,$20,$62,$20,$6C,$65,$61,$76,$65,$73,$20,$61,$20,$75,$6E,$74,$6F,$75,$63,$68,$65,$64
LBL_193:
        DC.B $0A
        DC.B $68,$65,$6C,$6C,$6F,$20,$66,$69,$6C,$65
        DC.B $00
LBL_194:
        DC.B $0D
        DC.B $73,$6D,$6F,$6B,$65,$66,$69,$6C,$65,$2E,$74,$78,$74
LBL_195:
        DC.B $11
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$6F,$6B
LBL_196:
        DC.B $10
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6F,$6B
        DC.B $00
LBL_197:
        DC.B $1D
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
LBL_198:
        DC.B $00
        DC.B $00
LBL_199:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$6E,$2E,$64,$61,$74
        DC.B $00
LBL_200:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
        DC.B $00
LBL_201:
        DC.B $17
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
LBL_202:
        DC.B $1B
        DC.B $66,$69,$6C,$65,$20,$62,$69,$6E,$61,$72,$79,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70,$20,$62,$79,$74,$65,$73
LBL_203:
        DC.B $09
        DC.B $61,$2F,$62,$2F,$63,$2E,$74,$78,$74
LBL_204:
        DC.B $05
        DC.B $63,$2E,$74,$78,$74
LBL_205:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$62,$61,$73,$65,$6E,$61,$6D,$65
        DC.B $00
LBL_206:
        DC.B $08
        DC.B $73,$6F,$6C,$6F,$2E,$74,$78,$74
        DC.B $00
LBL_207:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$6E,$6F,$2D,$73,$6C,$61,$73,$68
        DC.B $00
LBL_208:
        DC.B $04
        DC.B $64,$69,$72,$2F
        DC.B $00
LBL_209:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$74,$72,$61,$69,$6C,$69,$6E,$67,$20,$73,$6C,$61,$73,$68
        DC.B $00
LBL_210:
        DC.B $09
        DC.B $78,$2F,$79,$2F,$7A,$2E,$74,$78,$74
LBL_211:
        DC.B $05
        DC.B $7A,$2E,$74,$78,$74
LBL_212:
        DC.B $14
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$76,$69,$61,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_213:
        DC.B $18
        DC.B $73,$6D,$6F,$6B,$65,$2D,$64,$6F,$65,$73,$2D,$6E,$6F,$74,$2D,$65,$78,$69,$73,$74,$2E,$74,$78,$74
        DC.B $00
LBL_214:
        DC.B $23
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$72,$65,$74,$75,$72,$6E,$73,$20,$66,$61,$6C,$73,$65
LBL_215:
        DC.B $24
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$63,$6F,$64,$65
        DC.B $00
LBL_216:
        DC.B $27
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$6D,$65,$73,$73,$61,$67,$65
LBL_217:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$67,$2E,$64,$61,$74
        DC.B $00
LBL_218:
        DC.B $16
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
        DC.B $00
LBL_219:
        DC.B $15
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
LBL_220:
        DC.B $22
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
        DC.B $00
LBL_221:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_222:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$79
        DC.B $00
LBL_223:
        DC.B $11
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_224:
        DC.B $17
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
LBL_225:
        DC.B $18
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_226:
        DC.B $1B
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_227:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_228:
        DC.B $0B
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$78
LBL_229:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
        DC.B $00
LBL_230:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$73,$74,$72
        DC.B $00
LBL_231:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$78
LBL_232:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$78
LBL_233:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_234:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_235:
        DC.B $17
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
LBL_236:
        DC.B $13
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$66,$69,$65,$6C,$64
LBL_237:
        DC.B $15
        DC.B $72,$65,$63,$6F,$72,$64,$20,$70,$61,$72,$61,$6D,$20,$62,$79,$20,$76,$61,$6C,$75,$65
LBL_238:
        DC.B $14
        DC.B $65,$6E,$75,$6D,$20,$69,$6E,$74,$2D,$3E,$65,$6E,$75,$6D,$20,$76,$61,$6C,$69,$64
        DC.B $00
LBL_239:
        DC.B $18
        DC.B $65,$6E,$75,$6D,$20,$65,$6E,$75,$6D,$2D,$3E,$69,$6E,$74,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70
        DC.B $00
LBL_240:
        DC.B $0A
        DC.B $73,$6D,$6F,$6B,$65,$20,$64,$6F,$6E,$65
        DC.B $00
LBL_241:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_244:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
LBL_245:
        DC.L $00000005
        DC.L $00000006
        DC.L $00000007
        ; constant pool: serdesc tables (stub -- Task 8+)
