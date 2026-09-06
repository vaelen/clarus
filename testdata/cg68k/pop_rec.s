LBL_236:
        ; startup (JT slot 0)
        ; globals (below A5, 1600 bytes total):
        ;   rtUiMenuHandlesArr : -4(A5)  size 4  type ptr
        ;   rtUiNMenusVal : -8(A5)  size 4  type int
        ;   rtUiClaimedMask : -12(A5)  size 4  type int
        ;   rtUiBarMask : -16(A5)  size 4  type int
        ;   rtUiAppleMenuHandle : -20(A5)  size 4  type ptr
        ;   rtUiStdEditMenuIdx : -24(A5)  size 4  type int
        ;   rtUiSys7 : -26(A5)  size 1  type bool
        ;   rtUiEveryDueArr : -30(A5)  size 4  type ptr
        ;   rtUiNEveryVal : -34(A5)  size 4  type int
        ;   rtUiEmptyPStrCache : -38(A5)  size 4  type ptr
        ;   rtUiScratchBitMap : -42(A5)  size 4  type ptr
        ;   rtUiGrayPats : -46(A5)  size 4  type ptr
        ;   rtUiScripted : -48(A5)  size 1  type bool
        ;   rtUiScriptDbl : -50(A5)  size 1  type bool
        ;   rtUiJiggle : -52(A5)  size 1  type bool
        ;   rtUiJiggleBusy : -54(A5)  size 1  type bool
        ;   rtUiAnswerKinds : -58(A5)  size 4  type ptr
        ;   rtUiAnswerVals : -62(A5)  size 4  type ptr
        ;   rtUiAnswerStrs : -66(A5)  size 4  type ptr
        ;   rtUiAnswerHead : -70(A5)  size 4  type int
        ;   rtUiAnswerTail : -74(A5)  size 4  type int
        ;   rtUiTraceSuppressed : -76(A5)  size 1  type bool
        ;   rtUiTraceWinCounts : -80(A5)  size 4  type ptr
        ;   rtUiTraceLastFront : -84(A5)  size 4  type ptr
        ;   rtUiDimPrevArr : -88(A5)  size 4  type ptr
        ;   rtUiDimFirst : -90(A5)  size 1  type bool
        ;   rtUiStdEditDimPrev : -92(A5)  size 1  type bool
        ;   rtUiScriptCursor : -96(A5)  size 4  type ptr
        ;   rtUiScriptCursorInit : -98(A5)  size 1  type bool
        ;   rtUiScriptLineBuf : -102(A5)  size 4  type ptr
        ;   rtUiScriptLineLen : -106(A5)  size 4  type int
        ;   rtUiVerbBuf : -110(A5)  size 4  type ptr
        ;   rtUiArg1Buf : -114(A5)  size 4  type ptr
        ;   rtUiArg2Buf : -118(A5)  size 4  type ptr
        ;   rtUiVirtualTicks : -122(A5)  size 4  type int
        ;   rtUiModalActive : -124(A5)  size 1  type bool
        ;   rtUiModalInst : -128(A5)  size 4  type ptr
        ;   rtUiModalBufH : -132(A5)  size 4  type ptr
        ;   rtUiModalBuf : -136(A5)  size 4  type ptr
        ;   rtUiModalIsNew : -138(A5)  size 1  type bool
        ;   rtUiModalWbKind : -142(A5)  size 4  type int
        ;   rtUiModalAddr : -146(A5)  size 4  type ptr
        ;   rtUiModalLst : -150(A5)  size 4  type ptr
        ;   rtUiModalIdx : -154(A5)  size 4  type int
        ;   rtUiModalMp : -158(A5)  size 4  type ptr
        ;   rtUiModalKey255 : -162(A5)  size 4  type ptr
        ;   rtSerPos : -166(A5)  size 4  type int
        ;   rtSerBad : -168(A5)  size 1  type bool
        ;   rtConnState : -184(A5)  size 16  type arr
        ;   rtConnPendOpened : -188(A5)  size 4  type arr
        ;   rtConnPendFailedCode : -204(A5)  size 16  type arr
        ;   rtConnPendFailedMsg : -1228(A5)  size 1024  type arr
        ;   rtConnParsePortIdx : -1232(A5)  size 4  type int
        ;   rtConnParseBaud : -1236(A5)  size 4  type int
        ;   rtConnOutRef : -1252(A5)  size 16  type arr
        ;   rtConnInRef : -1268(A5)  size 16  type arr
        ;   rtConnReadBuf : -1272(A5)  size 4  type ptr
        ;   natPb : -1276(A5)  size 4  type ptr
        ;   natBuf : -1280(A5)  size 4  type ptr
        ;   natDigits : -1284(A5)  size 4  type ptr
        ;   natLogBuf : -1288(A5)  size 4  type ptr
        ;   natLogLen : -1292(A5)  size 4  type int
        ;   natRef : -1296(A5)  size 4  type int
        ;   natOpened : -1298(A5)  size 1  type bool
        ;   natDone : -1300(A5)  size 1  type bool
        ;   natArgs : -1304(A5)  size 4  type list
        ;   natPanicBuf : -1308(A5)  size 4  type ptr
        ;   natEmptyStr : -1312(A5)  size 4  type ptr
        ;   natErrCode : -1316(A5)  size 4  type int
        ;   natErrMsg : -1572(A5)  size 256  type str
        ;   natFilePb : -1576(A5)  size 4  type ptr
        ;   natFileReady : -1578(A5)  size 1  type bool
        ;   natUiEmitBuf : -1582(A5)  size 4  type ptr
        ;   natQdInited : -1584(A5)  size 1  type bool
        ;   natQdGlobals : -1588(A5)  size 4  type ptr
        ;   rtFh68kLastErr : -1592(A5)  size 4  type int
        ;   rtFh68kState : -1596(A5)  size 4  type ptr
        ;   lst : -1600(A5)  size 4  type list
        LEA -1600(A5),A0
        MOVE.W #799,D0
LBL_238:
        CLR.W (A0)+
        DBRA D0,LBL_238
        MOVEA.L $0130.W,A0
        ADDA.L #-103498,A0
        DC.W $A02D  ; _SetApplLimit
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_237
        BSR.W LBL_141
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        BSR.W LBL_167
        BSR.W LBL_235
        CLR.L -(A7)
        BSR.W LBL_144
        RTS
LBL_237:
        ; cg_init_globals
        LINK A6,#-48
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        MOVE.L #1,D0
        MOVE.B D0,-90(A5)
        LEA -1304(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -1600(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #8,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        UNLK A6
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_0:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_146
        ADDQ.L #8,A7
LBL_239:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-2100
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_145
        ADDQ.L #4,A7
LBL_240:
        UNLK A6
        RTS
        ; func rtPack4CCRange  (JT slot 3)
        ;   param p : 16(A6)  size 4
        ;   param start : 12(A6)  size 4
        ;   param len : 8(A6)  size 4
        ;   local b0 : -4(A6)  size 4
        ;   local b1 : -8(A6)  size 4
        ;   local b2 : -12(A6)  size 4
        ;   local b3 : -16(A6)  size 4
LBL_2:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_242
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_241
LBL_242:
        MOVEQ #32,D0
        MOVE.L D0,-4(A6)
        MOVEQ #32,D0
        MOVE.L D0,-8(A6)
        MOVEQ #32,D0
        MOVE.L D0,-12(A6)
        MOVEQ #32,D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_243
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
LBL_243:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_244
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
LBL_244:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_245
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
LBL_245:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_246
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
LBL_246:
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        OR.L D1,D0
        BRA.W LBL_241
LBL_241:
        UNLK A6
        RTS
        ; func rtFourCC  (JT slot 4)
        ;   param p : 8(A6)  size 4
LBL_3:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDA.W #12,A7
        BRA.W LBL_247
LBL_247:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 5)
        ;   param v : 14(A6)  size 4
        ;   param found : 12(A6)  size 2
        ;   param name : 8(A6)  size 4
LBL_4:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B 12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_249
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_249:
        MOVE.L 14(A6),D0
        BRA.W LBL_248
LBL_248:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 6)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_5:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_251
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_252
LBL_251:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_252:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
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
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_253
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_253:
LBL_250:
        UNLK A6
        RTS
        ; func rtStrConcat  (JT slot 7)
        ;   param out : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local total : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local fromA : -20(A6)  size 4
        ;   local fromB : -24(A6)  size 4
LBL_6:
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
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_256
LBL_255:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_256:
        MOVE.L -4(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_257
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_258
LBL_257:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_258:
        MOVE.L -16(A6),D1
        MOVE.L -20(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
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
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_259
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_259:
LBL_254:
        UNLK A6
        RTS
        ; func rtStrPrependChar  (JT slot 8)
        ;   param out : 16(A6)  size 4
        ;   param c : 12(A6)  size 4
        ;   param a : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local total : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_7:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
        MOVE.L #255,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_262
LBL_261:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_262:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_263
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_263:
LBL_260:
        UNLK A6
        RTS
        ; func rtStrLen  (JT slot 9)
        ;   param s : 8(A6)  size 4
LBL_8:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_264
LBL_264:
        UNLK A6
        RTS
        ; func rtStrIndex  (JT slot 10)
        ;   param s : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_9:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_266
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_267
LBL_266:
        MOVEQ #1,D0
LBL_267:
        TST.L D0
        BEQ.W LBL_268
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_268:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_265
LBL_265:
        UNLK A6
        RTS
        ; func rtIntToStr  (JT slot 11)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param n : 12(A6)  size 4
        ;   local s : -256(A6)  size 256
        ;   local d : -260(A6)  size 4
        ;   local neg : -262(A6)  size 2
        ;   local cur : -266(A6)  size 4
LBL_10:
        LINK A6,#-2366
        LEA -256(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        MOVEQ #0,D0
        MOVE.B D0,-262(A6)
        MOVEQ #0,D0
        MOVE.L D0,-266(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-266(A6)
        MOVE.L -266(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_270
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_269
LBL_270:
        MOVE.L -266(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-262(A6)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
LBL_271:
        MOVE.L -266(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_272
        MOVE.L -266(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_234
        MOVE.L D0,-260(A6)
        MOVE.L -260(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_273
        MOVEQ #0,D1
        MOVE.L -260(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-260(A6)
LBL_273:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEQ #48,D1
        MOVE.L -260(A6),D0
        ADD.L D1,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        MOVE.L -266(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_233
        MOVE.L D0,-266(A6)
        BRA.W LBL_271
LBL_272:
        CLR.L D0
        MOVE.B -262(A6),D0
        TST.L D0
        BEQ.W LBL_274
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_190(PC),A0
        MOVE.L A0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
LBL_274:
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_269
LBL_269:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 12)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_11:
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
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_276
        BRA.W LBL_275
LBL_276:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_278
LBL_277:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_278:
LBL_279:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_280
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_232
        MOVE.L D0,-12(A6)
        BRA.W LBL_279
LBL_280:
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
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_281:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_275:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 13)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_12:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #32,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; TextNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_283
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_283:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_284
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_284:
        MOVE.L -4(A6),D0
        BRA.W LBL_282
LBL_282:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 14)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_13:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_286
        BRA.W LBL_285
LBL_286:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_285:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 15)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_14:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_288
        BRA.W LBL_287
LBL_288:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_289
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_289:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_290
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
LBL_290:
LBL_287:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 16)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_15:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
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
        BSR.W LBL_11
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
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
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
LBL_291:
        UNLK A6
        RTS
        ; func rtTextLen  (JT slot 17)
        ;   param t : 8(A6)  size 4
LBL_16:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_292
LBL_292:
        UNLK A6
        RTS
        ; func rtTextToBytes  (JT slot 18)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_17:
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
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_294
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_295
LBL_294:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_295:
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
        BEQ.W LBL_296
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_296:
        MOVE.L -8(A6),D0
        BRA.W LBL_293
LBL_293:
        UNLK A6
        RTS
        ; func rtTextAppendStr  (JT slot 19)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local len0 : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_18:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
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
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
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
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_297:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 20)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_19:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
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
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_298:
        UNLK A6
        RTS
        ; func rtTextAppendText  (JT slot 21)
        ;   param t : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local rs : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local len0 : -16(A6)  size 4
        ;   local srcmp : -20(A6)  size 4
        ;   local dstmp : -24(A6)  size 4
LBL_20:
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_299:
        UNLK A6
        RTS
        ; func rtListGrow  (JT slot 22)
        ;   param l : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local elemsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
LBL_21:
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
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_301
        BRA.W LBL_300
LBL_301:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_303
LBL_302:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_303:
LBL_304:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_305
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_232
        MOVE.L D0,-12(A6)
        BRA.W LBL_304
LBL_305:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_232
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; ListSetHandleSize
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_306
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_306:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_300:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 23)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_22:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #40,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; ListNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_308
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_308:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #1,D0
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
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_309
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_309:
        MOVE.L -4(A6),D0
        BRA.W LBL_307
LBL_307:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 24)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_23:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_311
        BRA.W LBL_310
LBL_311:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_310:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 25)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_24:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_313
        BRA.W LBL_312
LBL_313:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_314:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_315
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
LBL_315:
LBL_312:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 26)
        ;   param l : 8(A6)  size 4
LBL_25:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_317
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_318
LBL_317:
        MOVEQ #0,D0
LBL_318:
        BRA.W LBL_316
LBL_316:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 27)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_26:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_320
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
        BRA.W LBL_321
LBL_320:
        MOVEQ #1,D0
LBL_321:
        TST.L D0
        BEQ.W LBL_322
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_322:
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
        BSR.W LBL_232
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        BRA.W LBL_319
LBL_319:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 28)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_27:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
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
        BSR.W LBL_232
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
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
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_323:
        UNLK A6
        RTS
        ; func rtListPop  (JT slot 29)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_28:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_325:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
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
        BSR.W LBL_232
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
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
LBL_324:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 30)
        ;   param l : 8(A6)  size 4
LBL_29:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_326
LBL_326:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 31)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_30:
        LINK A6,#-2100
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
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_327
LBL_327:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 32)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_31:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #112,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; MapNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_329
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_329:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_330
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_330:
        MOVEQ #0,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_331
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_331:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; MapNewHandle
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_332
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_332:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; MapNewHandle
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_333
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_333:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_328
LBL_328:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 33)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_32:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_335
        BRA.W LBL_334
LBL_335:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_334:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 34)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_33:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_337
        BRA.W LBL_336
LBL_337:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_338
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_338:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_339
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
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; MapDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; MapDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; MapDisposePtr
LBL_339:
LBL_336:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 35)
        ;   param m : 8(A6)  size 4
LBL_34:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_341
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_342
LBL_341:
        MOVEQ #0,D0
LBL_342:
        BRA.W LBL_340
LBL_340:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 36)
        ;   param m : 8(A6)  size 4
LBL_35:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_343
LBL_343:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 37)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_36:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_345
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_346
LBL_345:
        MOVEQ #1,D0
LBL_346:
        TST.L D0
        BEQ.W LBL_347
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_347:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
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
LBL_344:
        UNLK A6
        RTS
        ; func rtIntMapNew  (JT slot 38)
        ;   param valsize : 8(A6)  size 4
LBL_37:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        BRA.W LBL_348
LBL_348:
        UNLK A6
        RTS
        ; func rtIntMapRetain  (JT slot 39)
        ;   param m : 8(A6)  size 4
LBL_38:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #4,A7
LBL_349:
        UNLK A6
        RTS
        ; func rtIntMapRelease  (JT slot 40)
        ;   param m : 8(A6)  size 4
LBL_39:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
LBL_350:
        UNLK A6
        RTS
        ; func rtIntMapLastref  (JT slot 41)
        ;   param m : 8(A6)  size 4
LBL_40:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        BRA.W LBL_351
LBL_351:
        UNLK A6
        RTS
        ; func rtIntMapCount  (JT slot 42)
        ;   param m : 8(A6)  size 4
LBL_41:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        BRA.W LBL_352
LBL_352:
        UNLK A6
        RTS
        ; func rtIntMapValAt  (JT slot 43)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_42:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDA.W #12,A7
LBL_353:
        UNLK A6
        RTS
        ; func uidI32  (JT slot 44)
        ;   param p : 8(A6)  size 4
        ;   local b0 : -4(A6)  size 4
        ;   local b1 : -8(A6)  size 4
        ;   local b2 : -12(A6)  size 4
        ;   local b3 : -16(A6)  size 4
LBL_43:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        OR.L D1,D0
        BRA.W LBL_354
LBL_354:
        UNLK A6
        RTS
        ; func uidStrPtr  (JT slot 45)
        ;   param off : 8(A6)  size 4
LBL_44:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_356
        MOVEQ #0,D0
        BRA.W LBL_355
LBL_356:
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_355
LBL_355:
        UNLK A6
        RTS
        ; func uidWinsOff  (JT slot 46)
LBL_45:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_357
LBL_357:
        UNLK A6
        RTS
        ; func uidMenusOff  (JT slot 47)
LBL_46:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_358
LBL_358:
        UNLK A6
        RTS
        ; func uidNMenuHandlers  (JT slot 48)
LBL_47:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_359
LBL_359:
        UNLK A6
        RTS
        ; func uidMhOff  (JT slot 49)
LBL_48:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_360
LBL_360:
        UNLK A6
        RTS
        ; func uidWinBase  (JT slot 50)
        ;   param winIdx : 8(A6)  size 4
LBL_49:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_361
LBL_361:
        UNLK A6
        RTS
        ; func uidWinNameOff  (JT slot 51)
        ;   param winIdx : 8(A6)  size 4
LBL_50:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_362
LBL_362:
        UNLK A6
        RTS
        ; func uidWinName  (JT slot 52)
        ;   param winIdx : 8(A6)  size 4
LBL_51:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        BRA.W LBL_363
LBL_363:
        UNLK A6
        RTS
        ; func uidWinNWidgets  (JT slot 53)
        ;   param winIdx : 8(A6)  size 4
LBL_52:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_364
LBL_364:
        UNLK A6
        RTS
        ; func uidWinMenuMask  (JT slot 54)
        ;   param winIdx : 8(A6)  size 4
LBL_53:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_365
LBL_365:
        UNLK A6
        RTS
        ; func uidMenuBase  (JT slot 55)
        ;   param menuIdx : 8(A6)  size 4
LBL_54:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_366
LBL_366:
        UNLK A6
        RTS
        ; func uidMenuTitleOff  (JT slot 56)
        ;   param menuIdx : 8(A6)  size 4
LBL_55:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_367
LBL_367:
        UNLK A6
        RTS
        ; func uidMenuTitle  (JT slot 57)
        ;   param menuIdx : 8(A6)  size 4
LBL_56:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        BRA.W LBL_368
LBL_368:
        UNLK A6
        RTS
        ; func uidMenuHandlerBase  (JT slot 58)
        ;   param k : 8(A6)  size 4
LBL_57:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_369
LBL_369:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuIdx  (JT slot 59)
        ;   param k : 8(A6)  size 4
LBL_58:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_370
LBL_370:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemIdx  (JT slot 60)
        ;   param k : 8(A6)  size 4
LBL_59:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_371
LBL_371:
        UNLK A6
        RTS
        ; func uidMenuHandlerScopeWinIdx  (JT slot 61)
        ;   param k : 8(A6)  size 4
LBL_60:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_372
LBL_372:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuNameOff  (JT slot 62)
        ;   param k : 8(A6)  size 4
LBL_61:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_373
LBL_373:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuName  (JT slot 63)
        ;   param k : 8(A6)  size 4
LBL_62:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        BRA.W LBL_374
LBL_374:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemNameOff  (JT slot 64)
        ;   param k : 8(A6)  size 4
LBL_63:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_375
LBL_375:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemName  (JT slot 65)
        ;   param k : 8(A6)  size 4
LBL_64:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        BRA.W LBL_376
LBL_376:
        UNLK A6
        RTS
        ; func uidTableRowsIdx  (JT slot 66)
        ;   param off : 8(A6)  size 4
LBL_65:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_377
LBL_377:
        UNLK A6
        RTS
        ; func uidTableLayoutOff  (JT slot 67)
        ;   param off : 8(A6)  size 4
LBL_66:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_378
LBL_378:
        UNLK A6
        RTS
        ; func uidTableNCols  (JT slot 68)
        ;   param off : 8(A6)  size 4
LBL_67:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_379
LBL_379:
        UNLK A6
        RTS
        ; func uidTableColsOff  (JT slot 69)
        ;   param off : 8(A6)  size 4
LBL_68:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_380
LBL_380:
        UNLK A6
        RTS
        ; func uidColBase  (JT slot 70)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_69:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_381
LBL_381:
        UNLK A6
        RTS
        ; func uidColWidthPx  (JT slot 71)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_70:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_382
LBL_382:
        UNLK A6
        RTS
        ; func uidColWidthFill  (JT slot 72)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_71:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_383
LBL_383:
        UNLK A6
        RTS
        ; func uidColFieldIndex  (JT slot 73)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_72:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_384
LBL_384:
        UNLK A6
        RTS
        ; func uidFieldBase  (JT slot 74)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_73:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_385
LBL_385:
        UNLK A6
        RTS
        ; func uidFieldFtype  (JT slot 75)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_74:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func uidFieldOffset  (JT slot 76)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_75:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_387
LBL_387:
        UNLK A6
        RTS
        ; func uidFieldEnumCount  (JT slot 77)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_76:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_388
LBL_388:
        UNLK A6
        RTS
        ; func uidFieldEnumLabelsOff  (JT slot 78)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_77:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_389
LBL_389:
        UNLK A6
        RTS
        ; func uidFieldEnumValuesOff  (JT slot 79)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_78:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_390
LBL_390:
        UNLK A6
        RTS
        ; func uidEnumLabelOff  (JT slot 80)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_79:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_391
LBL_391:
        UNLK A6
        RTS
        ; func uidEnumLabel  (JT slot 81)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_80:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        BRA.W LBL_392
LBL_392:
        UNLK A6
        RTS
        ; func uidEnumValue  (JT slot 82)
        ;   param enumValuesOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_81:
        LINK A6,#-2100
        LEA LBL_228(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        BRA.W LBL_393
LBL_393:
        UNLK A6
        RTS
        ; func UiNewPtr  (JT slot 83)
        ;   param size : 8(A6)  size 4
LBL_82:
        LINK A6,#-2100
        BSR.W LBL_115
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtrRaw
        MOVE.L A0,D0
        BRA.W LBL_394
LBL_394:
        UNLK A6
        RTS
        ; func aeQuitHandler  (JT slot 84)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_83:
        LINK A6,#-2100
        BSR.W LBL_92
        MOVEQ #0,D0
        BRA.W LBL_395
LBL_395:
        UNLK A6
        RTS
        ; func aeOappHandler  (JT slot 85)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_84:
        LINK A6,#-2100
        MOVEQ #0,D0
        BRA.W LBL_396
LBL_396:
        UNLK A6
        RTS
        ; func nat_UiLaunchReal  (JT slot 86)
        ;   local junk : -4(A6)  size 4
LBL_85:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_398
        CLR.W -(A7)
        MOVE.L #1634039412,D0
        MOVE.L D0,-(A7)
        MOVE.L #1903520116,D0
        MOVE.L D0,-(A7)
        LEA 1490(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.W #2335,D0
        DC.W $A816  ; AEInstallEventHandler
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-4(A6)
        CLR.W -(A7)
        MOVE.L #1634039412,D0
        MOVE.L D0,-(A7)
        MOVE.L #1868656752,D0
        MOVE.L D0,-(A7)
        LEA 1498(A5),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.W #2335,D0
        DC.W $A816  ; AEInstallEventHandler
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-4(A6)
LBL_398:
        BSR.W LBL_180
LBL_397:
        UNLK A6
        RTS
        ; func nat_UiAEProcessEvent  (JT slot 87)
        ;   param evBuf : 8(A6)  size 4
        ;   local junk : -4(A6)  size 4
LBL_86:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.W -(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #539,D0
        DC.W $A816  ; AEProcessAppleEvent
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-4(A6)
LBL_399:
        UNLK A6
        RTS
        ; func rtUiIsOurs  (JT slot 88)
        ;   param wp : 8(A6)  size 4
LBL_87:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        MOVEQ #0,D0
        BRA.W LBL_400
LBL_401:
        MOVE.L 8(A6),D1
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
        BRA.W LBL_400
LBL_400:
        UNLK A6
        RTS
        ; func rtUiWinstOf  (JT slot 89)
        ;   param wp : 8(A6)  size 4
LBL_88:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        MOVEQ #0,D0
        BRA.W LBL_402
LBL_403:
        CLR.L -(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        BRA.W LBL_402
LBL_402:
        UNLK A6
        RTS
        ; func rtUiFront  (JT slot 90)
        ;   param winIdx : 8(A6)  size 4
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
LBL_89:
        LINK A6,#-2112
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
LBL_405:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
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
        BEQ.W LBL_407
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
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_408
        MOVE.L -8(A6),D0
        BRA.W LBL_404
LBL_408:
LBL_407:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_405
LBL_406:
        MOVEQ #0,D0
        BRA.W LBL_404
LBL_404:
        UNLK A6
        RTS
        ; func rtUiTeardownWindow  (JT slot 91)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local lh : -20(A6)  size 4
        ;   local ldefH : -24(A6)  size 4
LBL_90:
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_410:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_411
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_109
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_412
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #64,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #40,-(A7)
        DC.W $A9E7  ; UiLDispose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
LBL_412:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_410
LBL_411:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A914  ; UiDisposeWindow
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_120
        ADDQ.L #8,A7
        BSR.W LBL_97
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_195(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_121
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_173
        ADDA.W #20,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_413
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_177
        ADDQ.L #8,A7
LBL_413:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_414:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_102
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_416
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9CD  ; UiTEDispose
LBL_416:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_417
        MOVE.L #1000,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A932  ; UiDisposeMenu
LBL_417:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_414
LBL_415:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_418
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
LBL_418:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 52(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 60(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 68(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 84(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 92(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 100(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
LBL_409:
        UNLK A6
        RTS
        ; func rtUiCloseInternal  (JT slot 92)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local cancelSlot : -12(A6)  size 4
        ;   local cancelled : -14(A6)  size 2
LBL_91:
        LINK A6,#-2114
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.B D0,-14(A6)
        CLR.L D0
        MOVE.B -124(A5),D0
        TST.L D0
        BEQ.W LBL_420
        MOVE.L 8(A6),D1
        MOVE.L -128(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_421
LBL_420:
        MOVEQ #0,D0
LBL_421:
        TST.L D0
        BEQ.W LBL_422
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_129
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_419
LBL_422:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_196(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_121
        ADDQ.L #8,A7
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_173
        ADDA.W #20,A7
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        CLR.L D0
        MOVE.B -14(A6),D0
        TST.L D0
        BEQ.W LBL_423
        MOVEQ #0,D0
        BRA.W LBL_419
LBL_423:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_419
LBL_419:
        UNLK A6
        RTS
        ; func rtUiQuit  (JT slot 93)
        ;   local wp : -4(A6)  size 4
        ;   local next : -8(A6)  size 4
        ;   local inst : -12(A6)  size 4
LBL_92:
        LINK A6,#-2112
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
LBL_425:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_427
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_91
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        BRA.W LBL_424
LBL_428:
LBL_427:
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_425
LBL_426:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_160
        ADDQ.L #4,A7
LBL_424:
        UNLK A6
        RTS
        ; func rtUiHiWord  (JT slot 94)
        ;   param v : 8(A6)  size 4
LBL_93:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        BRA.W LBL_429
LBL_429:
        UNLK A6
        RTS
        ; func rtUiSyncMenuBar  (JT slot 95)
        ;   local inst : -4(A6)  size 4
        ;   local target : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local bit : -16(A6)  size 4
        ;   local mh : -20(A6)  size 4
LBL_94:
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
        MOVE.L -4(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_431
        MOVE.L -12(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_432
LBL_431:
        MOVEQ #1,D0
LBL_432:
        TST.L D0
        BEQ.W LBL_433
        BRA.W LBL_430
LBL_433:
        MOVEQ #1,D1
        MOVE.L -8(A5),D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2147483647,D1
        MOVE.L -12(A5),D0
        EOR.L D1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-8(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-8(A6)
LBL_434:
        MOVE.L -8(A6),D1
        MOVE.L -16(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        BRA.W LBL_430
LBL_435:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_436:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_437
        MOVEQ #1,D1
        MOVE.L -12(A6),D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_438
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_439
LBL_438:
        MOVEQ #0,D0
LBL_439:
        TST.L D0
        BEQ.W LBL_440
        MOVEQ #2,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
LBL_440:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_436
LBL_437:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_441:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_442
        MOVEQ #1,D1
        MOVE.L -12(A6),D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_443
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_444
LBL_443:
        MOVEQ #0,D0
LBL_444:
        TST.L D0
        BEQ.W LBL_445
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A935  ; UiInsertMenu
LBL_445:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_441
LBL_442:
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A5)
        DC.W $A937  ; UiDrawMenuBar
LBL_430:
        UNLK A6
        RTS
        ; func rtUiMenuEnable  (JT slot 96)
        ;   param menuIdx : 14(A6)  size 4
        ;   param itemIdx : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local mh : -4(A6)  size 4
LBL_95:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_449
        MOVE.L 14(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_450
LBL_449:
        MOVEQ #1,D0
LBL_450:
        TST.L D0
        BNE.W LBL_447
        MOVE.L 14(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_448
LBL_447:
        MOVEQ #1,D0
LBL_448:
        TST.L D0
        BEQ.W LBL_451
        BRA.W LBL_446
LBL_451:
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_452
        BRA.W LBL_446
LBL_452:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_453
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A939  ; UiEnableItem
        BRA.W LBL_454
LBL_453:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A93A  ; UiDisableItem
LBL_454:
LBL_446:
        UNLK A6
        RTS
        ; func rtUiMenuRecomputeDim  (JT slot 97)
        ;   local k : -4(A6)  size 4
        ;   local nMh : -8(A6)  size 4
        ;   local scopeWinIdx : -12(A6)  size 4
        ;   local enable : -14(A6)  size 2
        ;   local front : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
LBL_96:
        LINK A6,#-2122
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.B D0,-14(A6)
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        BSR.W LBL_47
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_456:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_458
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_95
        ADDA.W #10,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_122
        ADDQ.L #6,A7
LBL_458:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_456
LBL_457:
        MOVE.L -24(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_460
        MOVE.L -18(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_461
LBL_460:
        MOVEQ #0,D0
LBL_461:
        MOVE.B D0,-14(A6)
        MOVEQ #2,D0
        MOVE.L D0,-22(A6)
LBL_462:
        MOVE.L -22(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_95
        ADDA.W #10,A7
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        BRA.W LBL_462
LBL_463:
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_123
        ADDQ.L #2,A7
LBL_459:
        BSR.W LBL_124
LBL_455:
        UNLK A6
        RTS
        ; func rtUiAfterFrontChange  (JT slot 98)
LBL_97:
        LINK A6,#-2100
        BSR.W LBL_94
        BSR.W LBL_96
        BSR.W LBL_125
LBL_464:
        UNLK A6
        RTS
        ; func UiNewRgn  (JT slot 99)
LBL_98:
        LINK A6,#-2100
        BSR.W LBL_115
        CLR.L -(A7)
        DC.W $A8D8  ; UiNewRgnRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_465
LBL_465:
        UNLK A6
        RTS
        ; func rtUiCanvasBufAt  (JT slot 100)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_99:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #44,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_466
LBL_466:
        UNLK A6
        RTS
        ; func rtUiTeAt  (JT slot 101)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_100:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_467
LBL_467:
        UNLK A6
        RTS
        ; func rtUiPstrcpy  (JT slot 102)
        ;   param dst : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_101:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_469
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_468
LBL_469:
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
LBL_468:
        UNLK A6
        RTS
        ; func rtUiCanvasDispose  (JT slot 103)
        ;   param cb : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_102:
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
        BEQ.W LBL_471
        BRA.W LBL_470
LBL_471:
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
LBL_470:
        UNLK A6
        RTS
        ; func nat_UiTEFromScrap  (JT slot 104)
        ;   local th : -4(A6)  size 4
        ;   local offSlot : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_103:
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
        BEQ.W LBL_473
        MOVEQ #102,D0
        NEG.L D0
        BRA.W LBL_472
LBL_473:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
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
        BEQ.W LBL_474
        MOVE.L -12(A6),D0
        BRA.W LBL_472
LBL_474:
        MOVE.L -12(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        MOVE.L #32767,D0
        MOVE.L D0,-12(A6)
LBL_475:
        MOVE.L #2736,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_472
LBL_472:
        UNLK A6
        RTS
        ; func nat_UiTEToScrap  (JT slot 105)
        ;   local th : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
        ;   local err : -12(A6)  size 4
LBL_104:
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
        BEQ.W LBL_477
        MOVEQ #0,D0
        BRA.W LBL_476
LBL_477:
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
        BSR.W LBL_105
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
        BRA.W LBL_476
LBL_476:
        UNLK A6
        RTS
        ; func nat_UiTEGetScrapLength  (JT slot 106)
LBL_105:
        LINK A6,#-2100
        MOVE.L #2736,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_478
LBL_478:
        UNLK A6
        RTS
        ; func rtUiScrollbarAction  (JT slot 107)
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
LBL_106:
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
        BEQ.W LBL_480
        BRA.W LBL_479
LBL_480:
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
        BSR.W LBL_88
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        BRA.W LBL_479
LBL_481:
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
        BSR.W LBL_100
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_482
        BRA.W LBL_479
LBL_482:
        MOVE.L -26(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_483
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
        BEQ.W LBL_485
        MOVEQ #0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_486
LBL_485:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_487
        MOVEQ #8,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_488
LBL_487:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_489
        MOVEQ #0,D1
        MOVE.L -38(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_490
LBL_489:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_491
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_492
LBL_491:
        BRA.W LBL_479
LBL_492:
LBL_490:
LBL_488:
LBL_486:
        BRA.W LBL_484
LBL_483:
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
        BEQ.W LBL_493
        MOVEQ #1,D0
        MOVE.L D0,-42(A6)
LBL_493:
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
        BEQ.W LBL_494
        MOVEQ #0,D1
        MOVE.L -42(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_495
LBL_494:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_496
        MOVE.L -42(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_497
LBL_496:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_498
        MOVEQ #0,D1
        MOVE.L -46(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_499
LBL_498:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_500
        MOVE.L -46(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_501
LBL_500:
        BRA.W LBL_479
LBL_501:
LBL_499:
LBL_497:
LBL_495:
LBL_484:
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
        BEQ.W LBL_502
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
LBL_502:
        MOVE.L -54(A6),D1
        MOVE.L -58(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_503
        MOVE.L -58(A6),D0
        MOVE.L D0,-54(A6)
LBL_503:
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
        BEQ.W LBL_504
        BRA.W LBL_479
LBL_504:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_505
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_506
LBL_505:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_506:
LBL_479:
        UNLK A6
        RTS
        ; func rtUiIntToPStr  (JT slot 108)
        ;   param n : 12(A6)  size 4
        ;   param out255 : 8(A6)  size 4
        ;   local u : -4(A6)  size 4
        ;   local d : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local len : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
        ;   local t : -26(A6)  size 4
LBL_107:
        LINK A6,#-2126
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
        BEQ.W LBL_508
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_508:
LBL_509:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_510
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_234
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
        MOVEQ #0,D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
LBL_511:
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
        BSR.W LBL_233
        MOVE.L D0,-4(A6)
        BRA.W LBL_509
LBL_510:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_512
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
LBL_512:
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_513:
        MOVE.L -18(A6),D1
        MOVE.L -22(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_514
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
        BRA.W LBL_513
LBL_514:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_507:
        UNLK A6
        RTS
        ; func nat_UiCbAddr  (JT slot 109)
        ;   param cb : 8(A6)  size 4
LBL_108:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        BRA.W LBL_515
LBL_515:
        UNLK A6
        RTS
        ; func rtUiListAt  (JT slot 110)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_109:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 88(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_516
LBL_516:
        UNLK A6
        RTS
        ; func rtUiPopupAt  (JT slot 111)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_110:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_517
LBL_517:
        UNLK A6
        RTS
        ; func rtUiTableFillWidth  (JT slot 112)
        ;   param colsOff : 16(A6)  size 4
        ;   param nCols : 12(A6)  size 4
        ;   param totalW : 8(A6)  size 4
        ;   local fixedSum : -4(A6)  size 4
        ;   local k : -8(A6)  size 4
        ;   local fillW : -12(A6)  size 4
LBL_111:
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
LBL_519:
        MOVE.L -8(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_521
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_521:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_519
LBL_520:
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
        BEQ.W LBL_522
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_522:
        MOVE.L -12(A6),D0
        BRA.W LBL_518
LBL_518:
        UNLK A6
        RTS
        ; func rtUiFixedToStr  (JT slot 113)
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
LBL_112:
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
        BEQ.W LBL_524
        MOVEQ #0,D1
        MOVE.L 12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_525
LBL_524:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6(A6)
LBL_525:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVE.L D0,-10(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVE.L D0,-14(A6)
        MOVE.L -6(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_107
        ADDQ.L #8,A7
        MOVE.L -6(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #10000,D0
        BSR.W LBL_232
        MOVE.L D0,D1
        MOVE.L #65536,D0
        BSR.W LBL_233
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_107
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_526
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
LBL_526:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_527:
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
        BEQ.W LBL_528
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
        BRA.W LBL_527
LBL_528:
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
LBL_529:
        MOVE.L -26(A6),D1
        MOVE.L -30(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_530
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
        BRA.W LBL_529
LBL_530:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_531:
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
        BEQ.W LBL_532
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
        BRA.W LBL_531
LBL_532:
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
LBL_523:
        UNLK A6
        RTS
        ; func rtUiTableDrawField  (JT slot 114)
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
LBL_113:
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
        BSR.W LBL_75
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
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
        BEQ.W LBL_534
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
        BRA.W LBL_535
LBL_534:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_536
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_107
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
        BRA.W LBL_537
LBL_536:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_538
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_112
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
        BRA.W LBL_539
LBL_538:
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_540
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
        BEQ.W LBL_542
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
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
LBL_542:
        BRA.W LBL_541
LBL_540:
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_543
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
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
        BRA.W LBL_544
LBL_543:
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_545
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.B D0,-42(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
LBL_546:
        MOVE.L -36(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_547
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_548
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
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
        BRA.W LBL_549
LBL_548:
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_549:
        BRA.W LBL_546
LBL_547:
        CLR.L D0
        MOVE.B -42(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_550
        LEA LBL_197(PC),A0
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
LBL_550:
LBL_545:
LBL_544:
LBL_541:
LBL_539:
LBL_537:
LBL_535:
LBL_533:
        UNLK A6
        RTS
        ; func rtUiLdefDraw  (JT slot 115)
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
LBL_114:
        LINK A6,#-2176
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
        MOVE.L 30(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_552
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
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_178
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_93
        ADDQ.L #4,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_554
        MOVE.L -40(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_555
LBL_554:
        MOVEQ #0,D0
LBL_555:
        TST.L D0
        BEQ.W LBL_556
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
        BSR.W LBL_111
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
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
LBL_557:
        MOVE.L -64(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_558
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_559
        MOVE.L -56(A6),D0
        MOVE.L D0,-68(A6)
        BRA.W LBL_560
LBL_559:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
LBL_560:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
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
        BSR.W LBL_98
        MOVE.L D0,-76(A6)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87A  ; UiGetClip
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87B  ; UiClipRect
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
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
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDA.W #16,A7
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
        BRA.W LBL_557
LBL_558:
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
LBL_556:
        CLR.L D0
        MOVE.B 28(A6),D0
        TST.L D0
        BEQ.W LBL_561
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_561:
        BRA.W LBL_553
LBL_552:
        MOVE.L 30(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_562
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_562:
LBL_553:
LBL_551:
        UNLK A6
        RTS
        ; func rtUiJiggleTick  (JT slot 116)
LBL_115:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -52(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_564
        CLR.L D0
        MOVE.B -54(A5),D0
        BRA.W LBL_565
LBL_564:
        MOVEQ #1,D0
LBL_565:
        TST.L D0
        BEQ.W LBL_566
        BRA.W LBL_563
LBL_566:
        MOVEQ #1,D0
        MOVE.B D0,-54(A5)
        MOVE.L #2147483632,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A04C  ; UiCompactMem
        MOVEQ #0,D0
        MOVE.B D0,-54(A5)
LBL_563:
        UNLK A6
        RTS
        ; func rtUiTextAppendStrSafe  (JT slot 117)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_116:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_568
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
LBL_568:
LBL_567:
        UNLK A6
        RTS
        ; func rtUiIntToText  (JT slot 118)
        ;   param v : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local digits : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local d : -22(A6)  size 4
LBL_117:
        LINK A6,#-2122
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
        BSR.W LBL_12
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
        BEQ.W LBL_570
        MOVE.L -8(A6),D0
        NEG.L D0
        MOVE.L D0,-8(A6)
LBL_570:
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
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
        BEQ.W LBL_571
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_572
LBL_571:
LBL_573:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_574
        MOVE.L -8(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_234
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
        BSR.W LBL_233
        MOVE.L D0,-8(A6)
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_573
LBL_574:
LBL_572:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_575
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #8,A7
LBL_575:
LBL_576:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
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
        BSR.W LBL_19
        ADDQ.L #8,A7
        BRA.W LBL_576
LBL_577:
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        BRA.W LBL_569
LBL_569:
        UNLK A6
        RTS
        ; func rtUiTextAppendInt  (JT slot 119)
        ;   param t : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local nt : -4(A6)  size 4
LBL_118:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_117
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #4,A7
LBL_578:
        UNLK A6
        RTS
        ; func rtUiEmitLine  (JT slot 120)
        ;   param t : 8(A6)  size 4
LBL_119:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -76(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_580
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_159
        ADDQ.L #4,A7
LBL_580:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #4,A7
LBL_579:
        UNLK A6
        RTS
        ; func rtUiTraceClose  (JT slot 121)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_120:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_12
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_199(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
LBL_581:
        UNLK A6
        RTS
        ; func rtUiTraceFire1  (JT slot 122)
        ;   param namePtr : 12(A6)  size 4
        ;   param event : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_121:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_12
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_200(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
LBL_582:
        UNLK A6
        RTS
        ; func rtUiTraceDimCheck  (JT slot 123)
        ;   param k : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local prev : -4(A6)  size 4
        ;   local enableInt : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_122:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_584
        MOVEQ #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_585
LBL_584:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_585:
        MOVE.L -88(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_586
        BRA.W LBL_583
LBL_586:
        MOVE.L -88(A5),D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -90(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_587
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_588
LBL_587:
        MOVEQ #0,D0
LBL_588:
        TST.L D0
        BEQ.W LBL_589
        BSR.W LBL_12
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
LBL_589:
        MOVE.L -88(A5),D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_583:
        UNLK A6
        RTS
        ; func rtUiTraceStdEditDim  (JT slot 124)
        ;   param enable : 8(A6)  size 2
        ;   local enableInt : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
LBL_123:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_591
        MOVEQ #1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_592
LBL_591:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_592:
        CLR.L D0
        MOVE.B -90(A5),D0
        TST.L D0
        BNE.W LBL_593
        CLR.L D0
        MOVE.B -92(A5),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_594
LBL_593:
        MOVEQ #1,D0
LBL_594:
        TST.L D0
        BEQ.W LBL_595
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-92(A5)
        BRA.W LBL_590
LBL_595:
        BSR.W LBL_12
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
        BSR.W LBL_12
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_204(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
        BSR.W LBL_12
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
        BSR.W LBL_12
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_206(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-92(A5)
LBL_590:
        UNLK A6
        RTS
        ; func rtUiTraceDimFirstDone  (JT slot 125)
LBL_124:
        LINK A6,#-2100
        MOVEQ #0,D0
        MOVE.B D0,-90(A5)
LBL_596:
        UNLK A6
        RTS
        ; func rtUiTraceFrontCheck  (JT slot 126)
        ;   local wp : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_125:
        LINK A6,#-2112
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
        BSR.W LBL_87
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_598
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_599
LBL_598:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_599:
        MOVE.L -8(A6),D1
        MOVE.L -84(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_600
        BRA.W LBL_597
LBL_600:
        MOVE.L -8(A6),D0
        MOVE.L D0,-84(A5)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_601
        BSR.W LBL_12
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_207(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
LBL_601:
LBL_597:
        UNLK A6
        RTS
        ; func nat_UiSFGetFile  (JT slot 127)
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
LBL_126:
        LINK A6,#-2548
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_603:
        CLR.L (A0)+
        DBRA D0,LBL_603
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
LBL_604:
        CLR.L (A0)+
        DBRA D0,LBL_604
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
        BSR.W LBL_22
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
        BEQ.W LBL_605
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
        BRA.W LBL_606
LBL_605:
        MOVEQ #0,D0
LBL_606:
        TST.L D0
        BEQ.W LBL_607
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-422(A6)
        BRA.W LBL_608
LBL_607:
        MOVEQ #0,D0
        MOVE.L D0,-426(A6)
        MOVEQ #0,D0
        MOVE.L D0,-430(A6)
LBL_609:
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_610
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_611
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
        BRA.W LBL_612
LBL_611:
        MOVEQ #1,D0
LBL_612:
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_614
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2504(A6)
LBL_615:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_602
LBL_614:
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
        BSR.W LBL_2
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
        BEQ.W LBL_616
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_209(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2504(A6)
LBL_617:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_602
LBL_616:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -438(A6),D0
        MOVE.L D0,-448(A6)
        LEA -448(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-426(A6)
LBL_613:
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-430(A6)
        BRA.W LBL_609
LBL_610:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-422(A6)
        MOVE.L -422(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
        LEA -90(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_619
        BRA.W LBL_620
LBL_619:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_620:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_232
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_618:
        MOVE.L -422(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_621
        LEA -86(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_622
        BRA.W LBL_623
LBL_622:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_623:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_232
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_621:
        MOVE.L -422(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        LEA -82(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #2,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_625
        BRA.W LBL_626
LBL_625:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_626:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_232
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_624:
        MOVE.L -422(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        LEA -78(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #3,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_628
        BRA.W LBL_629
LBL_628:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_629:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_232
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_627:
LBL_608:
        MOVEQ #100,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #100,D0
        OR.L D1,D0
        MOVE.L D0,-(A7)
        LEA LBL_189(PC),A0
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
        BEQ.W LBL_630
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2504(A6)
LBL_631:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_602
LBL_630:
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
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -410(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_101
        ADDQ.L #8,A7
        MOVEQ #1,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2504(A6)
LBL_632:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_602
LBL_602:
        UNLK A6
        RTS
        ; func nat_UiSFPutFile  (JT slot 128)
        ;   param suggested255 : 12(A6)  size 4
        ;   param path255Out : 8(A6)  size 4
        ;   local rep : -74(A6)  size 74
        ;   local vp : -138(A6)  size 64
        ;   local s : -394(A6)  size 256
        ;   local junk : -398(A6)  size 4
LBL_127:
        LINK A6,#-2498
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_634:
        CLR.L (A0)+
        DBRA D0,LBL_634
        CLR.W (A0)+
        LEA -138(A6),A0
        MOVE.W #15,D0
LBL_635:
        CLR.L (A0)+
        DBRA D0,LBL_635
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
        LEA LBL_210(PC),A0
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
        BEQ.W LBL_636
        MOVEQ #0,D0
        BRA.W LBL_633
LBL_636:
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
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -394(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_101
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_633
LBL_633:
        UNLK A6
        RTS
        ; func rtUiFormTeardown  (JT slot 129)
        ;   param inst : 8(A6)  size 4
        ;   local bufH : -4(A6)  size 4
LBL_128:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -132(A5),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-124(A5)
        MOVEQ #0,D0
        MOVE.L D0,-128(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
LBL_637:
        UNLK A6
        RTS
        ; func rtUiFormCancel  (JT slot 130)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_129:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_121
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #6,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_173
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_128
        ADDQ.L #4,A7
LBL_638:
        UNLK A6
        RTS
        ; func sortedmapValSlot  (JT slot 131)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_130:
        LINK A6,#-2100
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
        BSR.W LBL_232
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_639
LBL_639:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 132)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_131:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SortedMapNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_641
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_641:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; SortedMapNewHandle
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_642
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_642:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A122  ; SortedMapNewHandle
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_643
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_643:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_640
LBL_640:
        UNLK A6
        RTS
        ; func rtSortedMapRetain  (JT slot 133)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_132:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_645
        BRA.W LBL_644
LBL_645:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_644:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 134)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_133:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        BRA.W LBL_646
LBL_647:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_648
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_648:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
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
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_649
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; SortedMapDisposeHandle
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; SortedMapDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SortedMapDisposePtr
LBL_649:
LBL_646:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 135)
        ;   param m : 8(A6)  size 4
LBL_134:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_651
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_652
LBL_651:
        MOVEQ #0,D0
LBL_652:
        BRA.W LBL_650
LBL_650:
        UNLK A6
        RTS
        ; func rtSortedMapCount  (JT slot 136)
        ;   param m : 8(A6)  size 4
LBL_135:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_653
LBL_653:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 137)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_136:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_655
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
        BRA.W LBL_656
LBL_655:
        MOVEQ #1,D0
LBL_656:
        TST.L D0
        BEQ.W LBL_657
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_657:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_130
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
        DC.W $A22E  ; SortedMapBlockMoveData
LBL_654:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 138)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_137:
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
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_659:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_660
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_661
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_661:
        MOVE.L 8(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_659
LBL_660:
        MOVE.L 8(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        BRA.W LBL_658
LBL_658:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 139)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local v2 : -22(A6)  size 4
LBL_138:
        LINK A6,#-2122
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-22(A6)
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        MOVE.B D0,-2(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_663
        MOVEQ #0,D1
        MOVE.L -22(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_663:
        MOVEQ #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_664
        MOVE.L -1284(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_665
LBL_664:
LBL_666:
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_667
        MOVE.L -22(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_234
        MOVE.L D0,-10(A6)
        MOVE.L -1284(A5),D1
        MOVE.L -6(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D1
        MOVE.L -10(A6),D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -22(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_233
        MOVE.L D0,-22(A6)
        MOVE.L -6(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_666
LBL_667:
LBL_665:
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_668
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_668:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_669:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_670
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L 8(A6),D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1284(A5),D1
        MOVE.L -18(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-14(A6)
        BRA.W LBL_669
LBL_670:
        MOVE.L -14(A6),D0
        BRA.W LBL_662
LBL_662:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 140)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_139:
        LINK A6,#-2100
        MOVE.L -1296(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_672
        BRA.W LBL_671
LBL_672:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_673
        BRA.W LBL_671
LBL_673:
        MOVE.L -1276(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1296(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_671:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 141)
LBL_140:
        LINK A6,#-2100
        MOVE.L -1276(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -1276(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1276(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_674:
        UNLK A6
        RTS
        ; func natInit  (JT slot 142)
LBL_141:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -1298(A5),D0
        TST.L D0
        BEQ.W LBL_676
        BRA.W LBL_675
LBL_676:
        MOVEQ #1,D0
        MOVE.B D0,-1298(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1276(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1280(A5)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1284(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1288(A5)
        MOVEQ #0,D0
        MOVE.L D0,-1292(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1308(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1312(A5)
        MOVE.L -1276(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1276(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1276(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D1
        MOVEQ #24,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D1
        MOVEQ #8,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,D1
        MOVEQ #84,D0
        OR.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D1
        MOVEQ #24,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #120,D1
        MOVEQ #8,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,D1
        MOVEQ #116,D0
        OR.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
        MOVE.L -1276(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -1276(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_677
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-1296(A5)
        BRA.W LBL_675
LBL_677:
        MOVE.L -1276(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-1296(A5)
        MOVE.L -1276(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1296(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_675:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 143)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_142:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_141
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_137
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        ADDQ.L #8,A7
        BSR.W LBL_140
LBL_678:
        UNLK A6
        RTS
        ; func natLog  (JT slot 144)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_143:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_141
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_137
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_680:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_682
        MOVE.L -1292(A5),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_683
LBL_682:
        MOVEQ #0,D0
LBL_683:
        TST.L D0
        BEQ.W LBL_681
        MOVE.L -1288(A5),D1
        MOVE.L -1292(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1280(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1292(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-1292(A5)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_680
LBL_681:
LBL_679:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 145)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_144:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -1300(A5),D0
        TST.L D0
        BEQ.W LBL_685
        BRA.W LBL_684
LBL_685:
        MOVEQ #1,D0
        MOVE.B D0,-1300(A5)
        BSR.W LBL_141
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_138
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        ADDQ.L #8,A7
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        ADDQ.L #8,A7
        MOVE.L -1288(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1292(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        ADDQ.L #8,A7
        MOVE.L -1296(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_686
        MOVE.L -1276(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1296(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_686:
        BSR.W LBL_140
        DC.W $A9F4  ; NatExitToShell
LBL_684:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 146)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_145:
        LINK A6,#-2364
        LEA -256(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        BSR.W LBL_141
        LEA -256(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-260(A6)
        MOVE.L -1308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -260(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
LBL_688:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_689
        MOVE.L -1308(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -264(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -264(A6),D0
        MOVE.L D0,D1
        MOVEA.L (A7)+,A0
        CLR.L D0
        MOVE.B (A0),D0
        CMP.L D0,D1
        BCS.W LBL_690
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
LBL_690:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_688
LBL_689:
        MOVE.L -1308(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_142
        ADDQ.L #4,A7
        MOVE.L -1308(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B -1584(A5),D0
        TST.L D0
        BEQ.W LBL_691
        LEA LBL_229(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_692
LBL_691:
        MOVEQ #0,D0
LBL_692:
        TST.L D0
        BEQ.W LBL_693
        MOVEQ #30,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; NatSysBeep
        MOVE.L -1308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1312(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1312(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1312(A5),D0
        MOVE.L D0,-(A7)
        DC.W $A98B  ; UiParamText
        CLR.W -(A7)
        MOVE.L #128,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A985  ; UiAlert
        MOVE.W (A7)+,D0
        EXT.L D0
LBL_693:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
LBL_687:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 147)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_146:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-1316(A5)
        LEA -1572(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
LBL_694:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 148)
LBL_147:
        LINK A6,#-2100
        MOVE.L -1316(A5),D0
        BRA.W LBL_695
LBL_695:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 149)
        ;   hidden result ptr : 8(A6)  size 4
LBL_148:
        LINK A6,#-2100
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -1572(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_696
LBL_696:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 150)
        ;   local __ret4 : -4(A6)  size 4
LBL_149:
        LINK A6,#-2104
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2060(A6)
LBL_698:
        MOVE.L A1,-(A7)
        MOVE.L -2060(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -1304(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_697
LBL_697:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 151)
LBL_150:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -1578(A5),D0
        TST.L D0
        BEQ.W LBL_700
        BRA.W LBL_699
LBL_700:
        MOVEQ #1,D0
        MOVE.B D0,-1578(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1576(A5)
LBL_699:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 152)
LBL_151:
        LINK A6,#-2100
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_701:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 153)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local ref : -16(A6)  size 4
        ;   local wrote : -20(A6)  size 4
        ;   local failed : -22(A6)  size 2
        ;   local packedType : -26(A6)  size 4
        ;   local packedCreator : -30(A6)  size 4
LBL_152:
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
        MOVE.B D0,-22(A6)
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
        MOVEQ #0,D0
        MOVE.L D0,-30(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #4,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_703
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_702
LBL_703:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #4,A7
        MOVE.L D0,-30(A6)
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_704
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_702
LBL_704:
        BSR.W LBL_150
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_705
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_705:
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_706
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_702
LBL_706:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.B D0,-22(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_707
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
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -1576(A5),D1
        MOVEQ #40,D0
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
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_708
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_708:
LBL_707:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_151
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_709
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_710
LBL_709:
        MOVEQ #1,D0
LBL_710:
        TST.L D0
        BEQ.W LBL_711
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_702
LBL_711:
        MOVEQ #1,D0
        BRA.W LBL_702
LBL_702:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 154)
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
LBL_153:
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
        BSR.W LBL_150
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_713
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_712
LBL_713:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
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
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_714
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_714:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_715:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_716
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -1576(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_717
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_718
LBL_717:
        MOVEQ #0,D0
LBL_718:
        TST.L D0
        BEQ.W LBL_719
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_712
LBL_719:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_720
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
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
        MOVE.L -8(A6),D1
        MOVE.L -28(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
LBL_720:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_721
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_722
LBL_721:
        MOVEQ #1,D0
LBL_722:
        TST.L D0
        BEQ.W LBL_723
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_723:
        BRA.W LBL_715
LBL_716:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
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
        MOVEQ #1,D0
        BRA.W LBL_712
LBL_712:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 155)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_154:
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
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_725:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_726
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #47,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_727
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_727:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_725
LBL_726:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_728:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_729
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
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
        BRA.W LBL_728
LBL_729:
LBL_724:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 156)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_155:
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
        MOVE.L #1129072211,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A820  ; NatGet1NamedResource
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_731
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_730
LBL_731:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A025  ; NatGetHandleSize
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; NatHLock
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_732
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
LBL_732:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; NatHUnlock
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_730
LBL_730:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 157)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local ref : -16(A6)  size 4
        ;   local wrote : -20(A6)  size 4
        ;   local failed : -22(A6)  size 2
        ;   local packedType : -26(A6)  size 4
        ;   local packedCreator : -30(A6)  size 4
LBL_156:
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
        MOVE.B D0,-22(A6)
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
        MOVEQ #0,D0
        MOVE.L D0,-30(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #4,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_734
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_733
LBL_734:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #4,A7
        MOVE.L D0,-30(A6)
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_735
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_733
LBL_735:
        BSR.W LBL_150
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_736
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_736:
        MOVE.L -1576(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_737
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_733
LBL_737:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.B D0,-22(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_738
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
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1576(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -1576(A5),D1
        MOVEQ #40,D0
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
        MOVE.L -1576(A5),D1
        MOVEQ #16,D0
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
        BEQ.W LBL_739
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_739:
LBL_738:
        MOVE.L -1576(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1576(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_151
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_740
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_741
LBL_740:
        MOVEQ #1,D0
LBL_741:
        TST.L D0
        BEQ.W LBL_742
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_733
LBL_742:
        MOVEQ #1,D0
        BRA.W LBL_733
LBL_733:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 158)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_157:
        LINK A6,#-2100
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_152
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_744
        MOVEQ #1,D0
        BRA.W LBL_743
LBL_744:
        MOVEQ #0,D0
        BRA.W LBL_743
LBL_743:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 159)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_158:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_153
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_746
        MOVEQ #1,D0
        BRA.W LBL_745
LBL_746:
        MOVEQ #0,D0
        BRA.W LBL_745
LBL_745:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 160)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_159:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_141
        MOVE.L -1582(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_748
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1582(A5)
LBL_748:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1582(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -1582(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -1582(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        ADDQ.L #8,A7
        BSR.W LBL_140
LBL_747:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 161)
        ;   param code : 8(A6)  size 4
LBL_160:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
LBL_749:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 162)
LBL_161:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -1584(A5),D0
        TST.L D0
        BEQ.W LBL_751
        BRA.W LBL_750
LBL_751:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1588(A5)
        MOVE.L -1588(A5),D1
        MOVE.L #202,D0
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
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A97B  ; NatInitDialogs
        MOVEQ #1,D0
        MOVE.B D0,-1584(A5)
        DC.W $A850  ; NatInitCursor
LBL_750:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 163)
        ;   param out : 8(A6)  size 4
LBL_162:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
        MOVEQ #86,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_752:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 164)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_163:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1588(A5),D1
        MOVEQ #84,D0
        ADD.L D1,D0
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
        BEQ.W LBL_754
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_754:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
        MOVEQ #86,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1588(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_753:
        UNLK A6
        RTS
        ; func nat_UiConnPump  (JT slot 165)
LBL_164:
        LINK A6,#-2100
        BSR.W LBL_172
LBL_755:
        UNLK A6
        RTS
        ; func popMk  (JT slot 166)
        ;   hidden result ptr : 8(A6)  size 4
        ;   local r : -8(A6)  size 8
        ;   local __ret5 : -16(A6)  size 8
LBL_165:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -8(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_219(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_231
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        LEA -16(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_230
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_231
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        BRA.W LBL_756
LBL_756:
        UNLK A6
        RTS
        ; func popTake  (JT slot 167)
        ;   param r : 8(A6)  size 4
LBL_166:
        LINK A6,#-2100
        MOVEA.L 8(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BRA.W LBL_757
LBL_757:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 168)
        ;   local k : -4(A6)  size 4
LBL_167:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -1600(A5),D0
        MOVE.L D0,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_165
        ADDQ.L #4,A7
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -1600(A5),D0
        MOVE.L D0,-(A7)
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        LEA -520(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        LEA -520(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L A1,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_231
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -1600(A5),D0
        MOVE.L D0,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_165
        ADDQ.L #4,A7
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1600(A5),D0
        MOVE.L D0,-(A7)
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        LEA -520(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        LEA -520(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L A1,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_231
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -1600(A5),D0
        MOVE.L D0,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_165
        ADDQ.L #4,A7
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1600(A5),D0
        MOVE.L D0,-(A7)
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        LEA -520(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_166
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L A1,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_231
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_142
        ADDQ.L #4,A7
LBL_758:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 169)
        ;   param slot : 8(A6)  size 4
LBL_168:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_760
        BRA.W LBL_761
LBL_760:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_762
        BRA.W LBL_763
LBL_762:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_764
        BRA.W LBL_765
LBL_764:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_766
LBL_766:
LBL_765:
LBL_763:
LBL_761:
LBL_759:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 170)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_169:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_768
        BRA.W LBL_769
LBL_768:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_770
        BRA.W LBL_771
LBL_770:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_772
        BRA.W LBL_773
LBL_772:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_774
LBL_774:
LBL_773:
LBL_771:
LBL_769:
LBL_767:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 171)
        ;   param slot : 8(A6)  size 4
LBL_170:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_776
        BRA.W LBL_777
LBL_776:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_778
        BRA.W LBL_779
LBL_778:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_780
        BRA.W LBL_781
LBL_780:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_782
LBL_782:
LBL_781:
LBL_779:
LBL_777:
LBL_775:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 172)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_171:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_784
        BRA.W LBL_785
LBL_784:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_786
        BRA.W LBL_787
LBL_786:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_788
        BRA.W LBL_789
LBL_788:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_790
LBL_790:
LBL_789:
LBL_787:
LBL_785:
LBL_783:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 173)
LBL_172:
        LINK A6,#-2100
LBL_791:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 174)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_173:
        LINK A6,#-2100
        LEA LBL_220(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        BSR.W LBL_235
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
LBL_792:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 175)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_174:
        LINK A6,#-2100
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        BSR.W LBL_235
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
LBL_793:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 176)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_175:
        LINK A6,#-2100
        LEA LBL_222(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        BSR.W LBL_235
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
LBL_794:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 177)
        ;   param idx : 8(A6)  size 4
LBL_176:
        LINK A6,#-2100
        LEA LBL_223(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        BSR.W LBL_235
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
LBL_795:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 178)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_177:
        LINK A6,#-2100
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        BSR.W LBL_235
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
LBL_796:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 179)
        ;   param rowsIdx : 8(A6)  size 4
LBL_178:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #65,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_798
        LEA -1304(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_797
        BRA.W LBL_799
LBL_798:
        MOVE.L 8(A6),D1
        MOVEQ #77,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_800
        LEA -1600(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_797
        BRA.W LBL_801
LBL_800:
        LEA LBL_225(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        BSR.W LBL_235
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_797
LBL_801:
LBL_799:
LBL_797:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 180)
        ;   param path : 8(A6)  size 4
LBL_179:
        LINK A6,#-2100
LBL_802:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 181)
LBL_180:
        LINK A6,#-2100
LBL_803:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 182) -- pascal callback glue for aeQuitHandler
LBL_181:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        BSR.W LBL_83
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 183) -- pascal callback glue for aeOappHandler
LBL_182:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        BSR.W LBL_84
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 184) -- pascal callback glue for rtUiScrollbarAction
LBL_183:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        BSR.W LBL_106
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 185) -- pascal callback glue for rtUiLdefDraw
LBL_184:
        LINK A6,#0
        ;   msg : 26(A6)  pascal size 2
        MOVE.W 26(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        ;   select : 24(A6)  pascal size 2
        CLR.L D0
        MOVE.B 24(A6),D0
        MOVE.B D0,-(A7)
        ;   rectPtr : 20(A6)  pascal size 4
        MOVE.L 20(A6),-(A7)
        ;   cellPacked : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   dataOffset : 14(A6)  pascal size 2
        MOVE.W 14(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        ;   dataLen : 12(A6)  pascal size 2
        MOVE.W 12(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        ;   lh : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        BSR.W LBL_114
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_232:
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
LBL_233:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_804
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_227(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_804:
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
        BPL.W LBL_805
        NEG.L D2
        MOVE.L #1,D4
LBL_805:
        CLR.L D5
        TST.L D3
        BPL.W LBL_806
        NEG.L D3
        MOVE.L #1,D5
LBL_806:
        CLR.L D6
        MOVE.W #31,D7
LBL_807:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_808
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_808:
        DBRA D7,LBL_807
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_809
        NEG.L D2
LBL_809:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_234:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_810
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_227(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_810:
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
        BPL.W LBL_811
        NEG.L D2
        MOVE.L #1,D4
LBL_811:
        CLR.L D5
        TST.L D3
        BPL.W LBL_812
        NEG.L D3
        MOVE.L #1,D5
LBL_812:
        CLR.L D6
        MOVE.W #31,D7
LBL_813:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_814
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_814:
        DBRA D7,LBL_813
        TST.L D4
        BEQ.W LBL_815
        NEG.L D6
LBL_815:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_235:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -1304(A5),D0
        MOVE.L D0,-4(A6)
LBL_816:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -1600(A5),D0
        MOVE.L D0,-4(A6)
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_817
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-8(A6)
        CLR.L -12(A6)
LBL_818:
        MOVE.L -12(A6),D0
        MOVE.L -8(A6),D1
        CMP.L D1,D0
        BGE.W LBL_817
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_231
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-12(A6)
        BRA.W LBL_818
LBL_817:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_230:
        ; cg_retain_PopRec(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 4(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_231:
        ; cg_release_PopRec(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 4(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_227:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_185:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_186:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_187:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_188:
        DC.B $01
        DC.B $30
LBL_189:
        DC.B $00
        DC.B $00
LBL_190:
        DC.B $01
        DC.B $2D
LBL_191:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_192:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_193:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_194:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_195:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_196:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_197:
        DC.B $01
        DC.B $3F
LBL_199:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_198:
        DC.B $01
        DC.B $20
LBL_200:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_201:
        DC.B $01
        DC.B $2E
LBL_202:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_203:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_204:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_205:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_206:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_207:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_208:
        DC.B $2A
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$6D,$75,$73,$74,$20,$68,$61,$76,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$65,$6E,$74,$72,$69,$65,$73
        DC.B $00
LBL_209:
        DC.B $31
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$65,$6E,$74,$72,$79,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_226:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_210:
        DC.B $08
        DC.B $53,$61,$76,$65,$20,$61,$73,$3A
        DC.B $00
LBL_211:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_214:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_215:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_216:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_217:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_212:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_213:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_218:
        DC.B $12
        DC.B $72,$65,$73,$6F,$75,$72,$63,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_219:
        DC.B $03
        DC.B $61,$62,$63
LBL_220:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_221:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_222:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_223:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_224:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_225:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (44 bytes)
LBL_228:
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
        DC.B $00
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
        DC.B $2C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
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
        DC.B $2C
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_229:
        DC.B $00
        DC.B $00
