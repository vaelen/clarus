LBL_246:
        ; startup (JT slot 0)
        ; globals (below A5, 6910 bytes total):
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
        ;   rtConnState : -200(A5)  size 32  type arr
        ;   rtConnPendOpened : -208(A5)  size 8  type arr
        ;   rtConnPendFailedCode : -240(A5)  size 32  type arr
        ;   rtConnPendFailedMsg : -2288(A5)  size 2048  type arr
        ;   rtConnParsePortIdx : -2292(A5)  size 4  type int
        ;   rtConnParseBaud : -2296(A5)  size 4  type int
        ;   rtConnOutRef : -2328(A5)  size 32  type arr
        ;   rtConnInRef : -2360(A5)  size 32  type arr
        ;   rtConnReadBuf : -2364(A5)  size 4  type ptr
        ;   rtAtUp : -2366(A5)  size 1  type bool
        ;   rtLsnState : -2374(A5)  size 8  type arr
        ;   rtLsnPendFailedCode : -2382(A5)  size 8  type arr
        ;   rtLsnPendFailedMsg : -2894(A5)  size 512  type arr
        ;   rtBrsState : -2902(A5)  size 8  type arr
        ;   rtBrsPendFailedCode : -2910(A5)  size 8  type arr
        ;   rtBrsPendFailedMsg : -3422(A5)  size 512  type arr
        ;   rtSvcState : -3430(A5)  size 8  type arr
        ;   rtSvcSock : -3438(A5)  size 8  type arr
        ;   rtSvcArmed : -3440(A5)  size 2  type arr
        ;   rtSvcInHandler : -3442(A5)  size 2  type arr
        ;   rtSvcReplied : -3444(A5)  size 2  type arr
        ;   rtSvcPendFailedCode : -3452(A5)  size 8  type arr
        ;   rtSvcPendFailedMsg : -3964(A5)  size 512  type arr
        ;   rtSvcName : -4476(A5)  size 512  type arr
        ;   rtSvcType : -4988(A5)  size 512  type arr
        ;   rtLsnName : -5500(A5)  size 512  type arr
        ;   rtLsnType : -6012(A5)  size 512  type arr
        ;   rtAdspPhase : -6044(A5)  size 32  type arr
        ;   rtConnSlotTransport : -6076(A5)  size 32  type arr
        ;   rtAtLastErr : -6080(A5)  size 4  type int
        ;   rtAt68MppRef : -6084(A5)  size 4  type int
        ;   rtAt68AtpRef : -6088(A5)  size 4  type int
        ;   rtAt68XppRef : -6092(A5)  size 4  type int
        ;   rtAt68DspRef : -6096(A5)  size 4  type int
        ;   rtAt68Up : -6098(A5)  size 1  type bool
        ;   rtAt68LastErr : -6102(A5)  size 4  type int
        ;   rtAt68LkPb : -6146(A5)  size 44  type arr
        ;   rtAt68LkEntity : -6190(A5)  size 44  type arr
        ;   rtAt68LkBuf : -6234(A5)  size 44  type arr
        ;   rtAt68Nte : -6250(A5)  size 16  type arr
        ;   rtAt68NteUsed : -6254(A5)  size 4  type arr
        ;   rtAt68SvcGetPb : -6262(A5)  size 8  type arr
        ;   rtAt68SvcReqBuf : -6270(A5)  size 8  type arr
        ;   rtAt68SvcRespPb : -6278(A5)  size 8  type arr
        ;   rtAt68SvcRespBuf : -6286(A5)  size 8  type arr
        ;   rtAt68SvcBds : -6294(A5)  size 8  type arr
        ;   rtAt68SvcSock : -6302(A5)  size 8  type arr
        ;   rtAt68SvcGetLive : -6304(A5)  size 2  type arr
        ;   rtAt68SvcReqOp : -6312(A5)  size 8  type arr
        ;   rtAt68SvcReqFrom : -6320(A5)  size 8  type arr
        ;   rtAt68SvcReqLen : -6328(A5)  size 8  type arr
        ;   rtAt68SvcTransID : -6336(A5)  size 8  type arr
        ;   rtAt68SvcXO : -6344(A5)  size 8  type arr
        ;   rtAt68CallBuf : -6348(A5)  size 4  type ptr
        ;   rtAt68CallBds : -6352(A5)  size 4  type ptr
        ;   rtAt68CallCode : -6356(A5)  size 4  type int
        ;   rtAt68LsnCcb : -6364(A5)  size 8  type arr
        ;   rtAt68LsnPb : -6372(A5)  size 8  type arr
        ;   rtAt68LsnRef : -6380(A5)  size 8  type arr
        ;   rtAt68LsnLive : -6382(A5)  size 2  type arr
        ;   rtAt68Ccb : -6414(A5)  size 32  type arr
        ;   rtAt68Pb : -6446(A5)  size 32  type arr
        ;   rtAt68SendQ : -6478(A5)  size 32  type arr
        ;   rtAt68RecvQ : -6510(A5)  size 32  type arr
        ;   rtAt68Attn : -6542(A5)  size 32  type arr
        ;   rtAt68CcbRef : -6574(A5)  size 32  type arr
        ;   rtAt68OpenLive : -6582(A5)  size 8  type arr
        ;   rtAt68DspAux : -6586(A5)  size 4  type ptr
        ;   natPb : -6590(A5)  size 4  type ptr
        ;   natBuf : -6594(A5)  size 4  type ptr
        ;   natDigits : -6598(A5)  size 4  type ptr
        ;   natLogBuf : -6602(A5)  size 4  type ptr
        ;   natLogLen : -6606(A5)  size 4  type int
        ;   natRef : -6610(A5)  size 4  type int
        ;   natOpened : -6612(A5)  size 1  type bool
        ;   natDone : -6614(A5)  size 1  type bool
        ;   natArgs : -6618(A5)  size 4  type list
        ;   natPanicBuf : -6622(A5)  size 4  type ptr
        ;   natEmptyStr : -6626(A5)  size 4  type ptr
        ;   natErrCode : -6630(A5)  size 4  type int
        ;   natErrMsg : -6886(A5)  size 256  type str
        ;   natFilePb : -6890(A5)  size 4  type ptr
        ;   natFileReady : -6892(A5)  size 1  type bool
        ;   natUiEmitBuf : -6896(A5)  size 4  type ptr
        ;   natQdInited : -6898(A5)  size 1  type bool
        ;   natQdGlobals : -6902(A5)  size 4  type ptr
        ;   rtFh68kLastErr : -6906(A5)  size 4  type int
        ;   rtFh68kState : -6910(A5)  size 4  type ptr
        LEA -6910(A5),A0
        MOVE.W #3454,D0
LBL_248:
        CLR.W (A0)+
        DBRA D0,LBL_248
        MOVEA.L $0130.W,A0
        ADDA.L #-103498,A0
        DC.W $A02D  ; _SetApplLimit
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_247
        BSR.W LBL_137
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        BSR.W LBL_163
        BSR.W LBL_245
        CLR.L -(A7)
        BSR.W LBL_140
        RTS
LBL_247:
        ; cg_init_globals
        LINK A6,#-48
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        MOVE.L #1,D0
        MOVE.B D0,-90(A5)
        LEA -6618(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_19
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
        BSR.W LBL_142
        ADDQ.L #8,A7
LBL_249:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-2100
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_141
        ADDQ.L #4,A7
LBL_250:
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
        BEQ.W LBL_252
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_251
LBL_252:
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
        BEQ.W LBL_253
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
LBL_253:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_254
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
LBL_254:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
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
LBL_255:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_256
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
LBL_256:
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
        BRA.W LBL_251
LBL_251:
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
        BRA.W LBL_257
LBL_257:
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
        BEQ.W LBL_259
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_259:
        MOVE.L 14(A6),D0
        BRA.W LBL_258
LBL_258:
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
        BEQ.W LBL_261
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_262
LBL_261:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_262:
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
        BEQ.W LBL_263
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_263:
LBL_260:
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
        BEQ.W LBL_265
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_266
LBL_265:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_266:
        MOVE.L -4(A6),D1
        MOVE.L -16(A6),D0
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
        BEQ.W LBL_269
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_269:
LBL_264:
        UNLK A6
        RTS
        ; func rtStrLen  (JT slot 8)
        ;   param s : 8(A6)  size 4
LBL_7:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_270
LBL_270:
        UNLK A6
        RTS
        ; func rtStrIndex  (JT slot 9)
        ;   param s : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_8:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_272
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
        BRA.W LBL_273
LBL_272:
        MOVEQ #1,D0
LBL_273:
        TST.L D0
        BEQ.W LBL_274
        LEA LBL_190(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_274:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_271
LBL_271:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 10)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_9:
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
        BSR.W LBL_242
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
        LEA LBL_192(PC),A0
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
        ; func rtTextNew  (JT slot 11)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_10:
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
        LEA LBL_192(PC),A0
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
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_284:
        MOVE.L -4(A6),D0
        BRA.W LBL_282
LBL_282:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 12)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_11:
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
        ; func rtTextRelease  (JT slot 13)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_12:
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
        ; func rtTextStore  (JT slot 14)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_13:
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
        BSR.W LBL_9
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
        ; func rtTextToBytes  (JT slot 15)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_14:
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
        BEQ.W LBL_293
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_294
LBL_293:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_294:
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
        BEQ.W LBL_295
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_295:
        MOVE.L -8(A6),D0
        BRA.W LBL_292
LBL_292:
        UNLK A6
        RTS
        ; func rtTextAppendStr  (JT slot 16)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local len0 : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_15:
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
        BSR.W LBL_9
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
LBL_296:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 17)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_16:
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
        BSR.W LBL_9
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
LBL_297:
        UNLK A6
        RTS
        ; func rtTextAppendText  (JT slot 18)
        ;   param t : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local rs : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local len0 : -16(A6)  size 4
        ;   local srcmp : -20(A6)  size 4
        ;   local dstmp : -24(A6)  size 4
LBL_17:
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
        BSR.W LBL_9
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
LBL_298:
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
        BEQ.W LBL_300
        BRA.W LBL_299
LBL_300:
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
        BEQ.W LBL_301
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_302
LBL_301:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_302:
LBL_303:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_304
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_242
        MOVE.L D0,-12(A6)
        BRA.W LBL_303
LBL_304:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_242
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
        BEQ.W LBL_305
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_305:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_299:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 20)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_19:
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
        BEQ.W LBL_307
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_307:
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
        BEQ.W LBL_308
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_308:
        MOVE.L -4(A6),D0
        BRA.W LBL_306
LBL_306:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 21)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_20:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_310
        BRA.W LBL_309
LBL_310:
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
LBL_309:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 22)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_21:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_312
        BRA.W LBL_311
LBL_312:
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
        BEQ.W LBL_313
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_313:
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
        BEQ.W LBL_314
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
LBL_314:
LBL_311:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 23)
        ;   param l : 8(A6)  size 4
LBL_22:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_316
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_317
LBL_316:
        MOVEQ #0,D0
LBL_317:
        BRA.W LBL_315
LBL_315:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 24)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_23:
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
        BNE.W LBL_319
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
        BRA.W LBL_320
LBL_319:
        MOVEQ #1,D0
LBL_320:
        TST.L D0
        BEQ.W LBL_321
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_321:
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
        BSR.W LBL_242
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        BRA.W LBL_318
LBL_318:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 25)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_24:
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
        BSR.W LBL_242
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
LBL_322:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 26)
        ;   param l : 8(A6)  size 4
LBL_25:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_323
LBL_323:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 27)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_26:
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
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_324
LBL_324:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 28)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_27:
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
        BEQ.W LBL_326
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_326:
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
        BEQ.W LBL_327
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_327:
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
        BEQ.W LBL_328
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_328:
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
        BEQ.W LBL_329
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_329:
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
        BEQ.W LBL_330
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_330:
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
        BRA.W LBL_325
LBL_325:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 29)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_28:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_332
        BRA.W LBL_331
LBL_332:
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
LBL_331:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 30)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_29:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_334
        BRA.W LBL_333
LBL_334:
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
        BEQ.W LBL_335
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_335:
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
        BEQ.W LBL_336
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
LBL_336:
LBL_333:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 31)
        ;   param m : 8(A6)  size 4
LBL_30:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_338
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_339
LBL_338:
        MOVEQ #0,D0
LBL_339:
        BRA.W LBL_337
LBL_337:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 32)
        ;   param m : 8(A6)  size 4
LBL_31:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_340
LBL_340:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 33)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_32:
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
        BNE.W LBL_342
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
        BRA.W LBL_343
LBL_342:
        MOVEQ #1,D0
LBL_343:
        TST.L D0
        BEQ.W LBL_344
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_344:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
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
LBL_341:
        UNLK A6
        RTS
        ; func rtIntMapNew  (JT slot 34)
        ;   param valsize : 8(A6)  size 4
LBL_33:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #4,A7
        BRA.W LBL_345
LBL_345:
        UNLK A6
        RTS
        ; func rtIntMapRetain  (JT slot 35)
        ;   param m : 8(A6)  size 4
LBL_34:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #4,A7
LBL_346:
        UNLK A6
        RTS
        ; func rtIntMapRelease  (JT slot 36)
        ;   param m : 8(A6)  size 4
LBL_35:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
LBL_347:
        UNLK A6
        RTS
        ; func rtIntMapLastref  (JT slot 37)
        ;   param m : 8(A6)  size 4
LBL_36:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDQ.L #4,A7
        BRA.W LBL_348
LBL_348:
        UNLK A6
        RTS
        ; func rtIntMapCount  (JT slot 38)
        ;   param m : 8(A6)  size 4
LBL_37:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        BRA.W LBL_349
LBL_349:
        UNLK A6
        RTS
        ; func rtIntMapValAt  (JT slot 39)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_38:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDA.W #12,A7
LBL_350:
        UNLK A6
        RTS
        ; func uidI32  (JT slot 40)
        ;   param p : 8(A6)  size 4
        ;   local b0 : -4(A6)  size 4
        ;   local b1 : -8(A6)  size 4
        ;   local b2 : -12(A6)  size 4
        ;   local b3 : -16(A6)  size 4
LBL_39:
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
        BRA.W LBL_351
LBL_351:
        UNLK A6
        RTS
        ; func uidStrPtr  (JT slot 41)
        ;   param off : 8(A6)  size 4
LBL_40:
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
        BEQ.W LBL_353
        MOVEQ #0,D0
        BRA.W LBL_352
LBL_353:
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_352
LBL_352:
        UNLK A6
        RTS
        ; func uidWinsOff  (JT slot 42)
LBL_41:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_354
LBL_354:
        UNLK A6
        RTS
        ; func uidMenusOff  (JT slot 43)
LBL_42:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_355
LBL_355:
        UNLK A6
        RTS
        ; func uidNMenuHandlers  (JT slot 44)
LBL_43:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_356
LBL_356:
        UNLK A6
        RTS
        ; func uidMhOff  (JT slot 45)
LBL_44:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_357
LBL_357:
        UNLK A6
        RTS
        ; func uidWinBase  (JT slot 46)
        ;   param winIdx : 8(A6)  size 4
LBL_45:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_358
LBL_358:
        UNLK A6
        RTS
        ; func uidWinNameOff  (JT slot 47)
        ;   param winIdx : 8(A6)  size 4
LBL_46:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_359
LBL_359:
        UNLK A6
        RTS
        ; func uidWinName  (JT slot 48)
        ;   param winIdx : 8(A6)  size 4
LBL_47:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        BRA.W LBL_360
LBL_360:
        UNLK A6
        RTS
        ; func uidWinNWidgets  (JT slot 49)
        ;   param winIdx : 8(A6)  size 4
LBL_48:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_361
LBL_361:
        UNLK A6
        RTS
        ; func uidWinMenuMask  (JT slot 50)
        ;   param winIdx : 8(A6)  size 4
LBL_49:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_362
LBL_362:
        UNLK A6
        RTS
        ; func uidMenuBase  (JT slot 51)
        ;   param menuIdx : 8(A6)  size 4
LBL_50:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_363
LBL_363:
        UNLK A6
        RTS
        ; func uidMenuTitleOff  (JT slot 52)
        ;   param menuIdx : 8(A6)  size 4
LBL_51:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_364
LBL_364:
        UNLK A6
        RTS
        ; func uidMenuTitle  (JT slot 53)
        ;   param menuIdx : 8(A6)  size 4
LBL_52:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        BRA.W LBL_365
LBL_365:
        UNLK A6
        RTS
        ; func uidMenuHandlerBase  (JT slot 54)
        ;   param k : 8(A6)  size 4
LBL_53:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_366
LBL_366:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuIdx  (JT slot 55)
        ;   param k : 8(A6)  size 4
LBL_54:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_367
LBL_367:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemIdx  (JT slot 56)
        ;   param k : 8(A6)  size 4
LBL_55:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_368
LBL_368:
        UNLK A6
        RTS
        ; func uidMenuHandlerScopeWinIdx  (JT slot 57)
        ;   param k : 8(A6)  size 4
LBL_56:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_369
LBL_369:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuNameOff  (JT slot 58)
        ;   param k : 8(A6)  size 4
LBL_57:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_370
LBL_370:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuName  (JT slot 59)
        ;   param k : 8(A6)  size 4
LBL_58:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        BRA.W LBL_371
LBL_371:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemNameOff  (JT slot 60)
        ;   param k : 8(A6)  size 4
LBL_59:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_372
LBL_372:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemName  (JT slot 61)
        ;   param k : 8(A6)  size 4
LBL_60:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        BRA.W LBL_373
LBL_373:
        UNLK A6
        RTS
        ; func uidTableRowsIdx  (JT slot 62)
        ;   param off : 8(A6)  size 4
LBL_61:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_374
LBL_374:
        UNLK A6
        RTS
        ; func uidTableLayoutOff  (JT slot 63)
        ;   param off : 8(A6)  size 4
LBL_62:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_375
LBL_375:
        UNLK A6
        RTS
        ; func uidTableNCols  (JT slot 64)
        ;   param off : 8(A6)  size 4
LBL_63:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_376
LBL_376:
        UNLK A6
        RTS
        ; func uidTableColsOff  (JT slot 65)
        ;   param off : 8(A6)  size 4
LBL_64:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_377
LBL_377:
        UNLK A6
        RTS
        ; func uidColBase  (JT slot 66)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_65:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_378
LBL_378:
        UNLK A6
        RTS
        ; func uidColWidthPx  (JT slot 67)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_66:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_379
LBL_379:
        UNLK A6
        RTS
        ; func uidColWidthFill  (JT slot 68)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_67:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_380
LBL_380:
        UNLK A6
        RTS
        ; func uidColFieldIndex  (JT slot 69)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_68:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_381
LBL_381:
        UNLK A6
        RTS
        ; func uidFieldBase  (JT slot 70)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_69:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
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
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_382
LBL_382:
        UNLK A6
        RTS
        ; func uidFieldFtype  (JT slot 71)
        ;   param layoutOff : 12(A6)  size 4
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
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_383
LBL_383:
        UNLK A6
        RTS
        ; func uidFieldOffset  (JT slot 72)
        ;   param layoutOff : 12(A6)  size 4
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
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_384
LBL_384:
        UNLK A6
        RTS
        ; func uidFieldEnumCount  (JT slot 73)
        ;   param layoutOff : 12(A6)  size 4
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
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_385
LBL_385:
        UNLK A6
        RTS
        ; func uidFieldEnumLabelsOff  (JT slot 74)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_73:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func uidFieldEnumValuesOff  (JT slot 75)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_74:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_387
LBL_387:
        UNLK A6
        RTS
        ; func uidEnumLabelOff  (JT slot 76)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_75:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_388
LBL_388:
        UNLK A6
        RTS
        ; func uidEnumLabel  (JT slot 77)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_76:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        BRA.W LBL_389
LBL_389:
        UNLK A6
        RTS
        ; func uidEnumValue  (JT slot 78)
        ;   param enumValuesOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_77:
        LINK A6,#-2100
        LEA LBL_240(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_390
LBL_390:
        UNLK A6
        RTS
        ; func UiNewPtr  (JT slot 79)
        ;   param size : 8(A6)  size 4
LBL_78:
        LINK A6,#-2100
        BSR.W LBL_111
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtrRaw
        MOVE.L A0,D0
        BRA.W LBL_391
LBL_391:
        UNLK A6
        RTS
        ; func aeQuitHandler  (JT slot 80)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_79:
        LINK A6,#-2100
        BSR.W LBL_88
        MOVEQ #0,D0
        BRA.W LBL_392
LBL_392:
        UNLK A6
        RTS
        ; func aeOappHandler  (JT slot 81)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_80:
        LINK A6,#-2100
        MOVEQ #0,D0
        BRA.W LBL_393
LBL_393:
        UNLK A6
        RTS
        ; func nat_UiLaunchReal  (JT slot 82)
        ;   local junk : -4(A6)  size 4
LBL_81:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_395
        CLR.W -(A7)
        MOVE.L #1634039412,D0
        MOVE.L D0,-(A7)
        MOVE.L #1903520116,D0
        MOVE.L D0,-(A7)
        LEA 1514(A5),A0
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
        LEA 1522(A5),A0
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
LBL_395:
        BSR.W LBL_183
LBL_394:
        UNLK A6
        RTS
        ; func nat_UiAEProcessEvent  (JT slot 83)
        ;   param evBuf : 8(A6)  size 4
        ;   local junk : -4(A6)  size 4
LBL_82:
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
LBL_396:
        UNLK A6
        RTS
        ; func rtUiIsOurs  (JT slot 84)
        ;   param wp : 8(A6)  size 4
LBL_83:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_398
        MOVEQ #0,D0
        BRA.W LBL_397
LBL_398:
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
        BRA.W LBL_397
LBL_397:
        UNLK A6
        RTS
        ; func rtUiWinstOf  (JT slot 85)
        ;   param wp : 8(A6)  size 4
LBL_84:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVEQ #0,D0
        BRA.W LBL_399
LBL_400:
        CLR.L -(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        BRA.W LBL_399
LBL_399:
        UNLK A6
        RTS
        ; func rtUiFront  (JT slot 86)
        ;   param winIdx : 8(A6)  size 4
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
LBL_85:
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
LBL_402:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
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
        BEQ.W LBL_404
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
        BEQ.W LBL_405
        MOVE.L -8(A6),D0
        BRA.W LBL_401
LBL_405:
LBL_404:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_402
LBL_403:
        MOVEQ #0,D0
        BRA.W LBL_401
LBL_401:
        UNLK A6
        RTS
        ; func rtUiTeardownWindow  (JT slot 87)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local lh : -20(A6)  size 4
        ;   local ldefH : -24(A6)  size 4
LBL_86:
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
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_407:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_408
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_105
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_409
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
LBL_409:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_407
LBL_408:
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
        BSR.W LBL_116
        ADDQ.L #8,A7
        BSR.W LBL_93
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_195(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
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
        BSR.W LBL_176
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
        BEQ.W LBL_410
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_180
        ADDQ.L #8,A7
LBL_410:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_411:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_412
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_95
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_413
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9CD  ; UiTEDispose
LBL_413:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_106
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
        MOVE.L #1000,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_106
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A932  ; UiDisposeMenu
LBL_414:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_411
LBL_412:
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
        BEQ.W LBL_415
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
LBL_415:
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
LBL_406:
        UNLK A6
        RTS
        ; func rtUiCloseInternal  (JT slot 88)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local cancelSlot : -12(A6)  size 4
        ;   local cancelled : -14(A6)  size 2
LBL_87:
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
        BEQ.W LBL_417
        MOVE.L 8(A6),D1
        MOVE.L -128(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_418
LBL_417:
        MOVEQ #0,D0
LBL_418:
        TST.L D0
        BEQ.W LBL_419
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_125
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_416
LBL_419:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_196(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #8,A7
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
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
        BSR.W LBL_176
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
        BEQ.W LBL_420
        MOVEQ #0,D0
        BRA.W LBL_416
LBL_420:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_416
LBL_416:
        UNLK A6
        RTS
        ; func rtUiQuit  (JT slot 89)
        ;   local wp : -4(A6)  size 4
        ;   local next : -8(A6)  size 4
        ;   local inst : -12(A6)  size 4
LBL_88:
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
LBL_422:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_423
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_424
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        BRA.W LBL_421
LBL_425:
LBL_424:
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_422
LBL_423:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_156
        ADDQ.L #4,A7
LBL_421:
        UNLK A6
        RTS
        ; func rtUiHiWord  (JT slot 90)
        ;   param v : 8(A6)  size 4
LBL_89:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        BRA.W LBL_426
LBL_426:
        UNLK A6
        RTS
        ; func rtUiSyncMenuBar  (JT slot 91)
        ;   local inst : -4(A6)  size 4
        ;   local target : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local bit : -16(A6)  size 4
        ;   local mh : -20(A6)  size 4
LBL_90:
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
        BNE.W LBL_428
        MOVE.L -12(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_429
LBL_428:
        MOVEQ #1,D0
LBL_429:
        TST.L D0
        BEQ.W LBL_430
        BRA.W LBL_427
LBL_430:
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
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-8(A6)
LBL_431:
        MOVE.L -8(A6),D1
        MOVE.L -16(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        BRA.W LBL_427
LBL_432:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_433:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
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
        BEQ.W LBL_435
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_436
LBL_435:
        MOVEQ #0,D0
LBL_436:
        TST.L D0
        BEQ.W LBL_437
        MOVEQ #2,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
LBL_437:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_433
LBL_434:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_438:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
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
        BEQ.W LBL_440
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_441
LBL_440:
        MOVEQ #0,D0
LBL_441:
        TST.L D0
        BEQ.W LBL_442
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_242
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
LBL_442:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_438
LBL_439:
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A5)
        DC.W $A937  ; UiDrawMenuBar
LBL_427:
        UNLK A6
        RTS
        ; func rtUiMenuEnable  (JT slot 92)
        ;   param menuIdx : 14(A6)  size 4
        ;   param itemIdx : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local mh : -4(A6)  size 4
LBL_91:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_446
        MOVE.L 14(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_447
LBL_446:
        MOVEQ #1,D0
LBL_447:
        TST.L D0
        BNE.W LBL_444
        MOVE.L 14(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_445
LBL_444:
        MOVEQ #1,D0
LBL_445:
        TST.L D0
        BEQ.W LBL_448
        BRA.W LBL_443
LBL_448:
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_242
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
        BEQ.W LBL_449
        BRA.W LBL_443
LBL_449:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_450
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A939  ; UiEnableItem
        BRA.W LBL_451
LBL_450:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A93A  ; UiDisableItem
LBL_451:
LBL_443:
        UNLK A6
        RTS
        ; func rtUiMenuRecomputeDim  (JT slot 93)
        ;   local k : -4(A6)  size 4
        ;   local nMh : -8(A6)  size 4
        ;   local scopeWinIdx : -12(A6)  size 4
        ;   local enable : -14(A6)  size 2
        ;   local front : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
LBL_92:
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
        BSR.W LBL_43
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_453:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
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
        BEQ.W LBL_455
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_91
        ADDA.W #10,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #6,A7
LBL_455:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_453
LBL_454:
        MOVE.L -24(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_456
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        MOVE.L -18(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_458
LBL_457:
        MOVEQ #0,D0
LBL_458:
        MOVE.B D0,-14(A6)
        MOVEQ #2,D0
        MOVE.L D0,-22(A6)
LBL_459:
        MOVE.L -22(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_460
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_91
        ADDA.W #10,A7
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        BRA.W LBL_459
LBL_460:
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #2,A7
LBL_456:
        BSR.W LBL_120
LBL_452:
        UNLK A6
        RTS
        ; func rtUiAfterFrontChange  (JT slot 94)
LBL_93:
        LINK A6,#-2100
        BSR.W LBL_90
        BSR.W LBL_92
        BSR.W LBL_121
LBL_461:
        UNLK A6
        RTS
        ; func UiNewRgn  (JT slot 95)
LBL_94:
        LINK A6,#-2100
        BSR.W LBL_111
        CLR.L -(A7)
        DC.W $A8D8  ; UiNewRgnRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_462
LBL_462:
        UNLK A6
        RTS
        ; func rtUiCanvasBufAt  (JT slot 96)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_95:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #44,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_463
LBL_463:
        UNLK A6
        RTS
        ; func rtUiTeAt  (JT slot 97)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_96:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_464
LBL_464:
        UNLK A6
        RTS
        ; func rtUiPstrcpy  (JT slot 98)
        ;   param dst : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_97:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_466
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_465
LBL_466:
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
LBL_465:
        UNLK A6
        RTS
        ; func rtUiCanvasDispose  (JT slot 99)
        ;   param cb : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_98:
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
        BEQ.W LBL_468
        BRA.W LBL_467
LBL_468:
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
LBL_467:
        UNLK A6
        RTS
        ; func nat_UiTEFromScrap  (JT slot 100)
        ;   local th : -4(A6)  size 4
        ;   local offSlot : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_99:
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
        BEQ.W LBL_470
        MOVEQ #102,D0
        NEG.L D0
        BRA.W LBL_469
LBL_470:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
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
        BEQ.W LBL_471
        MOVE.L -12(A6),D0
        BRA.W LBL_469
LBL_471:
        MOVE.L -12(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_472
        MOVE.L #32767,D0
        MOVE.L D0,-12(A6)
LBL_472:
        MOVE.L #2736,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_469
LBL_469:
        UNLK A6
        RTS
        ; func nat_UiTEToScrap  (JT slot 101)
        ;   local th : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
        ;   local err : -12(A6)  size 4
LBL_100:
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
        BEQ.W LBL_474
        MOVEQ #0,D0
        BRA.W LBL_473
LBL_474:
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
        BSR.W LBL_101
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
        BRA.W LBL_473
LBL_473:
        UNLK A6
        RTS
        ; func nat_UiTEGetScrapLength  (JT slot 102)
LBL_101:
        LINK A6,#-2100
        MOVE.L #2736,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_475
LBL_475:
        UNLK A6
        RTS
        ; func rtUiScrollbarAction  (JT slot 103)
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
LBL_102:
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
        BEQ.W LBL_477
        BRA.W LBL_476
LBL_477:
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
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_478
        BRA.W LBL_476
LBL_478:
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
        BSR.W LBL_96
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_479
        BRA.W LBL_476
LBL_479:
        MOVE.L -26(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_480
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
        BEQ.W LBL_482
        MOVEQ #0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_483
LBL_482:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_484
        MOVEQ #8,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_485
LBL_484:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_486
        MOVEQ #0,D1
        MOVE.L -38(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_487
LBL_486:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_488
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_489
LBL_488:
        BRA.W LBL_476
LBL_489:
LBL_487:
LBL_485:
LBL_483:
        BRA.W LBL_481
LBL_480:
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
        BEQ.W LBL_490
        MOVEQ #1,D0
        MOVE.L D0,-42(A6)
LBL_490:
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
        BEQ.W LBL_491
        MOVEQ #0,D1
        MOVE.L -42(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_492
LBL_491:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_493
        MOVE.L -42(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_494
LBL_493:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_495
        MOVEQ #0,D1
        MOVE.L -46(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_496
LBL_495:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_497
        MOVE.L -46(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_498
LBL_497:
        BRA.W LBL_476
LBL_498:
LBL_496:
LBL_494:
LBL_492:
LBL_481:
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
        BEQ.W LBL_499
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
LBL_499:
        MOVE.L -54(A6),D1
        MOVE.L -58(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_500
        MOVE.L -58(A6),D0
        MOVE.L D0,-54(A6)
LBL_500:
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
        BEQ.W LBL_501
        BRA.W LBL_476
LBL_501:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_502
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_503
LBL_502:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_503:
LBL_476:
        UNLK A6
        RTS
        ; func rtUiIntToPStr  (JT slot 104)
        ;   param n : 12(A6)  size 4
        ;   param out255 : 8(A6)  size 4
        ;   local u : -4(A6)  size 4
        ;   local d : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local len : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
        ;   local t : -26(A6)  size 4
LBL_103:
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
        BEQ.W LBL_505
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_505:
LBL_506:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_507
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_244
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_508
        MOVEQ #0,D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
LBL_508:
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
        BSR.W LBL_243
        MOVE.L D0,-4(A6)
        BRA.W LBL_506
LBL_507:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_509
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
LBL_509:
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_510:
        MOVE.L -18(A6),D1
        MOVE.L -22(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
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
        BRA.W LBL_510
LBL_511:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_504:
        UNLK A6
        RTS
        ; func nat_UiCbAddr  (JT slot 105)
        ;   param cb : 8(A6)  size 4
LBL_104:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        BRA.W LBL_512
LBL_512:
        UNLK A6
        RTS
        ; func rtUiListAt  (JT slot 106)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_105:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 88(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_513
LBL_513:
        UNLK A6
        RTS
        ; func rtUiPopupAt  (JT slot 107)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_106:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_514
LBL_514:
        UNLK A6
        RTS
        ; func rtUiTableFillWidth  (JT slot 108)
        ;   param colsOff : 16(A6)  size 4
        ;   param nCols : 12(A6)  size 4
        ;   param totalW : 8(A6)  size 4
        ;   local fixedSum : -4(A6)  size 4
        ;   local k : -8(A6)  size 4
        ;   local fillW : -12(A6)  size 4
LBL_107:
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
LBL_516:
        MOVE.L -8(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #8,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_518
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_518:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_516
LBL_517:
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
        BEQ.W LBL_519
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_519:
        MOVE.L -12(A6),D0
        BRA.W LBL_515
LBL_515:
        UNLK A6
        RTS
        ; func rtUiFixedToStr  (JT slot 109)
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
LBL_108:
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
        BEQ.W LBL_521
        MOVEQ #0,D1
        MOVE.L 12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_522
LBL_521:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6(A6)
LBL_522:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
        MOVE.L D0,-10(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
        MOVE.L D0,-14(A6)
        MOVE.L -6(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_103
        ADDQ.L #8,A7
        MOVE.L -6(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #10000,D0
        BSR.W LBL_242
        MOVE.L D0,D1
        MOVE.L #65536,D0
        BSR.W LBL_243
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_103
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_523
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
LBL_523:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_524:
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
        BEQ.W LBL_525
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
        BRA.W LBL_524
LBL_525:
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
LBL_526:
        MOVE.L -26(A6),D1
        MOVE.L -30(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_527
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
        BRA.W LBL_526
LBL_527:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_528:
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
        BEQ.W LBL_529
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
        BRA.W LBL_528
LBL_529:
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
LBL_520:
        UNLK A6
        RTS
        ; func rtUiTableDrawField  (JT slot 110)
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
LBL_109:
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
        BSR.W LBL_71
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
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
        BEQ.W LBL_531
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
        BRA.W LBL_532
LBL_531:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_103
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
        BRA.W LBL_534
LBL_533:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_535
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_108
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
        BRA.W LBL_536
LBL_535:
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_537
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
        BEQ.W LBL_539
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
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
LBL_539:
        BRA.W LBL_538
LBL_537:
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
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
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
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
        BRA.W LBL_541
LBL_540:
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_542
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.B D0,-42(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
LBL_543:
        MOVE.L -36(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_544
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_545
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
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
        BRA.W LBL_546
LBL_545:
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_546:
        BRA.W LBL_543
LBL_544:
        CLR.L D0
        MOVE.B -42(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_547
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
LBL_547:
LBL_542:
LBL_541:
LBL_538:
LBL_536:
LBL_534:
LBL_532:
LBL_530:
        UNLK A6
        RTS
        ; func rtUiLdefDraw  (JT slot 111)
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
LBL_110:
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
        BEQ.W LBL_549
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
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #4,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_551
        MOVE.L -40(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_552
LBL_551:
        MOVEQ #0,D0
LBL_552:
        TST.L D0
        BEQ.W LBL_553
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
        BSR.W LBL_107
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
LBL_554:
        MOVE.L -64(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_555
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_556
        MOVE.L -56(A6),D0
        MOVE.L D0,-68(A6)
        BRA.W LBL_557
LBL_556:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
LBL_557:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
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
        BSR.W LBL_94
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
        BSR.W LBL_23
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
        BSR.W LBL_68
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_109
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
        BRA.W LBL_554
LBL_555:
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
LBL_553:
        CLR.L D0
        MOVE.B 28(A6),D0
        TST.L D0
        BEQ.W LBL_558
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_558:
        BRA.W LBL_550
LBL_549:
        MOVE.L 30(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_559
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_559:
LBL_550:
LBL_548:
        UNLK A6
        RTS
        ; func rtUiJiggleTick  (JT slot 112)
LBL_111:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -52(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_561
        CLR.L D0
        MOVE.B -54(A5),D0
        BRA.W LBL_562
LBL_561:
        MOVEQ #1,D0
LBL_562:
        TST.L D0
        BEQ.W LBL_563
        BRA.W LBL_560
LBL_563:
        MOVEQ #1,D0
        MOVE.B D0,-54(A5)
        MOVE.L #2147483632,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A04C  ; UiCompactMem
        MOVEQ #0,D0
        MOVE.B D0,-54(A5)
LBL_560:
        UNLK A6
        RTS
        ; func rtUiTextAppendStrSafe  (JT slot 113)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_112:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_565
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
LBL_565:
LBL_564:
        UNLK A6
        RTS
        ; func rtUiIntToText  (JT slot 114)
        ;   param v : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local digits : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local d : -22(A6)  size 4
LBL_113:
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
        BSR.W LBL_10
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
        BEQ.W LBL_567
        MOVE.L -8(A6),D0
        NEG.L D0
        MOVE.L D0,-8(A6)
LBL_567:
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
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
        BEQ.W LBL_568
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_569
LBL_568:
LBL_570:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_571
        MOVE.L -8(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_244
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
        BSR.W LBL_243
        MOVE.L D0,-8(A6)
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_570
LBL_571:
LBL_569:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_572
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
LBL_572:
LBL_573:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_574
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
        BSR.W LBL_16
        ADDQ.L #8,A7
        BRA.W LBL_573
LBL_574:
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        BRA.W LBL_566
LBL_566:
        UNLK A6
        RTS
        ; func rtUiTextAppendInt  (JT slot 115)
        ;   param t : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local nt : -4(A6)  size 4
LBL_114:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
LBL_575:
        UNLK A6
        RTS
        ; func rtUiEmitLine  (JT slot 116)
        ;   param t : 8(A6)  size 4
LBL_115:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -76(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_155
        ADDQ.L #4,A7
LBL_577:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
LBL_576:
        UNLK A6
        RTS
        ; func rtUiTraceClose  (JT slot 117)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_116:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_10
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_199(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
LBL_578:
        UNLK A6
        RTS
        ; func rtUiTraceFire1  (JT slot 118)
        ;   param namePtr : 12(A6)  size 4
        ;   param event : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_117:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_10
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_200(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
LBL_579:
        UNLK A6
        RTS
        ; func rtUiTraceDimCheck  (JT slot 119)
        ;   param k : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local prev : -4(A6)  size 4
        ;   local enableInt : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_118:
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
        BEQ.W LBL_581
        MOVEQ #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_582
LBL_581:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_582:
        MOVE.L -88(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_583
        BRA.W LBL_580
LBL_583:
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
        BEQ.W LBL_584
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_585
LBL_584:
        MOVEQ #0,D0
LBL_585:
        TST.L D0
        BEQ.W LBL_586
        BSR.W LBL_10
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
LBL_586:
        MOVE.L -88(A5),D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_580:
        UNLK A6
        RTS
        ; func rtUiTraceStdEditDim  (JT slot 120)
        ;   param enable : 8(A6)  size 2
        ;   local enableInt : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
LBL_119:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_588
        MOVEQ #1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_589
LBL_588:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_589:
        CLR.L D0
        MOVE.B -90(A5),D0
        TST.L D0
        BNE.W LBL_590
        CLR.L D0
        MOVE.B -92(A5),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_591
LBL_590:
        MOVEQ #1,D0
LBL_591:
        TST.L D0
        BEQ.W LBL_592
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-92(A5)
        BRA.W LBL_587
LBL_592:
        BSR.W LBL_10
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        BSR.W LBL_10
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_204(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        BSR.W LBL_10
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        BSR.W LBL_10
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_206(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-92(A5)
LBL_587:
        UNLK A6
        RTS
        ; func rtUiTraceDimFirstDone  (JT slot 121)
LBL_120:
        LINK A6,#-2100
        MOVEQ #0,D0
        MOVE.B D0,-90(A5)
LBL_593:
        UNLK A6
        RTS
        ; func rtUiTraceFrontCheck  (JT slot 122)
        ;   local wp : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_121:
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
        BSR.W LBL_83
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_595
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_596
LBL_595:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_596:
        MOVE.L -8(A6),D1
        MOVE.L -84(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        BRA.W LBL_594
LBL_597:
        MOVE.L -8(A6),D0
        MOVE.L D0,-84(A5)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_598
        BSR.W LBL_10
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_207(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
LBL_598:
LBL_594:
        UNLK A6
        RTS
        ; func nat_UiSFGetFile  (JT slot 123)
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
LBL_122:
        LINK A6,#-2548
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_600:
        CLR.L (A0)+
        DBRA D0,LBL_600
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
LBL_601:
        CLR.L (A0)+
        DBRA D0,LBL_601
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
        BSR.W LBL_19
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
        BEQ.W LBL_602
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
        BRA.W LBL_603
LBL_602:
        MOVEQ #0,D0
LBL_603:
        TST.L D0
        BEQ.W LBL_604
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-422(A6)
        BRA.W LBL_605
LBL_604:
        MOVEQ #0,D0
        MOVE.L D0,-426(A6)
        MOVEQ #0,D0
        MOVE.L D0,-430(A6)
LBL_606:
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_607
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_608
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
        BRA.W LBL_609
LBL_608:
        MOVEQ #1,D0
LBL_609:
        TST.L D0
        BEQ.W LBL_610
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_611
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
LBL_612:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_599
LBL_611:
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
        BEQ.W LBL_613
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
LBL_614:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_599
LBL_613:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -438(A6),D0
        MOVE.L D0,-448(A6)
        LEA -448(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-426(A6)
LBL_610:
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-430(A6)
        BRA.W LBL_606
LBL_607:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVE.L D0,-422(A6)
        MOVE.L -422(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_615
        LEA -90(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_616
        BRA.W LBL_617
LBL_616:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_238(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_617:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_242
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_615:
        MOVE.L -422(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
        LEA -86(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_619
        BRA.W LBL_620
LBL_619:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_238(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_620:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_242
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_618:
        MOVE.L -422(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_621
        LEA -82(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #2,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_622
        BRA.W LBL_623
LBL_622:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_238(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_623:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_242
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_621:
        MOVE.L -422(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        LEA -78(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #3,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_625
        BRA.W LBL_626
LBL_625:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_238(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_626:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_242
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_624:
LBL_605:
        MOVEQ #100,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #100,D0
        OR.L D1,D0
        MOVE.L D0,-(A7)
        LEA LBL_191(PC),A0
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
        BEQ.W LBL_627
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2504(A6)
LBL_628:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_599
LBL_627:
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
        BSR.W LBL_97
        ADDQ.L #8,A7
        MOVEQ #1,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2504(A6)
LBL_629:
        MOVE.L A1,-(A7)
        MOVE.L -2504(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_599
LBL_599:
        UNLK A6
        RTS
        ; func nat_UiSFPutFile  (JT slot 124)
        ;   param suggested255 : 12(A6)  size 4
        ;   param path255Out : 8(A6)  size 4
        ;   local rep : -74(A6)  size 74
        ;   local vp : -138(A6)  size 64
        ;   local s : -394(A6)  size 256
        ;   local junk : -398(A6)  size 4
LBL_123:
        LINK A6,#-2498
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_631:
        CLR.L (A0)+
        DBRA D0,LBL_631
        CLR.W (A0)+
        LEA -138(A6),A0
        MOVE.W #15,D0
LBL_632:
        CLR.L (A0)+
        DBRA D0,LBL_632
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
        BEQ.W LBL_633
        MOVEQ #0,D0
        BRA.W LBL_630
LBL_633:
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
        BSR.W LBL_97
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_630
LBL_630:
        UNLK A6
        RTS
        ; func rtUiFormTeardown  (JT slot 125)
        ;   param inst : 8(A6)  size 4
        ;   local bufH : -4(A6)  size 4
LBL_124:
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
        BSR.W LBL_86
        ADDQ.L #4,A7
LBL_634:
        UNLK A6
        RTS
        ; func rtUiFormCancel  (JT slot 126)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_125:
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
        BSR.W LBL_47
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
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
        BSR.W LBL_176
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #4,A7
LBL_635:
        UNLK A6
        RTS
        ; func sortedmapValSlot  (JT slot 127)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_126:
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
        BSR.W LBL_242
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_636
LBL_636:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 128)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_127:
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
        BEQ.W LBL_638
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_638:
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
        BEQ.W LBL_639
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_639:
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
        BEQ.W LBL_640
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_640:
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
        BRA.W LBL_637
LBL_637:
        UNLK A6
        RTS
        ; func rtSortedMapRetain  (JT slot 129)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_128:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_642
        BRA.W LBL_641
LBL_642:
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
LBL_641:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 130)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_129:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_644
        BRA.W LBL_643
LBL_644:
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
        BEQ.W LBL_645
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_645:
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
        BEQ.W LBL_646
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
LBL_646:
LBL_643:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 131)
        ;   param m : 8(A6)  size 4
LBL_130:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_648
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_649
LBL_648:
        MOVEQ #0,D0
LBL_649:
        BRA.W LBL_647
LBL_647:
        UNLK A6
        RTS
        ; func rtSortedMapCount  (JT slot 132)
        ;   param m : 8(A6)  size 4
LBL_131:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_650
LBL_650:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 133)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_132:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_652
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
        BRA.W LBL_653
LBL_652:
        MOVEQ #1,D0
LBL_653:
        TST.L D0
        BEQ.W LBL_654
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_654:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_126
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
LBL_651:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 134)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_133:
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
LBL_656:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_657
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
        BEQ.W LBL_658
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_658:
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
        BRA.W LBL_656
LBL_657:
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
        BRA.W LBL_655
LBL_655:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 135)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local v2 : -22(A6)  size 4
LBL_134:
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
        BEQ.W LBL_660
        MOVEQ #0,D1
        MOVE.L -22(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_660:
        MOVEQ #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_661
        MOVE.L -6598(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_662
LBL_661:
LBL_663:
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_664
        MOVE.L -22(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_244
        MOVE.L D0,-10(A6)
        MOVE.L -6598(A5),D1
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
        BSR.W LBL_243
        MOVE.L D0,-22(A6)
        MOVE.L -6(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_663
LBL_664:
LBL_662:
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_665
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_665:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_666:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_667
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L 8(A6),D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6598(A5),D1
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
        BRA.W LBL_666
LBL_667:
        MOVE.L -14(A6),D0
        BRA.W LBL_659
LBL_659:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 136)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_135:
        LINK A6,#-2100
        MOVE.L -6610(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_669
        BRA.W LBL_668
LBL_669:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_670
        BRA.W LBL_668
LBL_670:
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6610(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_668:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 137)
LBL_136:
        LINK A6,#-2100
        MOVE.L -6590(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -6590(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_671:
        UNLK A6
        RTS
        ; func natInit  (JT slot 138)
LBL_137:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6612(A5),D0
        TST.L D0
        BEQ.W LBL_673
        BRA.W LBL_672
LBL_673:
        MOVEQ #1,D0
        MOVE.B D0,-6612(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6590(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6594(A5)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6598(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6602(A5)
        MOVEQ #0,D0
        MOVE.L D0,-6606(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6622(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6626(A5)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -6590(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
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
        MOVE.L -6590(A5),D1
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
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
        MOVE.L -6590(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -6590(A5),D1
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
        BEQ.W LBL_674
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-6610(A5)
        BRA.W LBL_672
LBL_674:
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-6610(A5)
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6610(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_672:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 139)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_138:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_137
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_135
        ADDQ.L #8,A7
        BSR.W LBL_136
LBL_675:
        UNLK A6
        RTS
        ; func natLog  (JT slot 140)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_139:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_137
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_677:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_679
        MOVE.L -6606(A5),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_680
LBL_679:
        MOVEQ #0,D0
LBL_680:
        TST.L D0
        BEQ.W LBL_678
        MOVE.L -6602(A5),D1
        MOVE.L -6606(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6606(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6606(A5)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_677
LBL_678:
LBL_676:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 141)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_140:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -6614(A5),D0
        TST.L D0
        BEQ.W LBL_682
        BRA.W LBL_681
LBL_682:
        MOVEQ #1,D0
        MOVE.B D0,-6614(A5)
        BSR.W LBL_137
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_135
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_135
        ADDQ.L #8,A7
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_135
        ADDQ.L #8,A7
        MOVE.L -6602(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6606(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_135
        ADDQ.L #8,A7
        MOVE.L -6610(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_683
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6610(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_683:
        BSR.W LBL_136
        DC.W $A9F4  ; NatExitToShell
LBL_681:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 142)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_141:
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
        BSR.W LBL_137
        LEA -256(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-260(A6)
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -260(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
LBL_685:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_686
        MOVE.L -6622(A5),D1
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
        BCS.W LBL_687
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_8
        ADDQ.L #8,A7
LBL_687:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_685
LBL_686:
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_138
        ADDQ.L #4,A7
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B -6898(A5),D0
        TST.L D0
        BEQ.W LBL_688
        LEA LBL_241(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_689
LBL_688:
        MOVEQ #0,D0
LBL_689:
        TST.L D0
        BEQ.W LBL_690
        MOVEQ #30,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; NatSysBeep
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6626(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6626(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6626(A5),D0
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
LBL_690:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
LBL_684:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 143)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_142:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-6630(A5)
        LEA -6886(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
LBL_691:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 144)
LBL_143:
        LINK A6,#-2100
        MOVE.L -6630(A5),D0
        BRA.W LBL_692
LBL_692:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 145)
        ;   hidden result ptr : 8(A6)  size 4
LBL_144:
        LINK A6,#-2100
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -6886(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_693
LBL_693:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 146)
        ;   local __ret4 : -4(A6)  size 4
LBL_145:
        LINK A6,#-2104
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2060(A6)
LBL_695:
        MOVE.L A1,-(A7)
        MOVE.L -2060(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -6618(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_694
LBL_694:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 147)
LBL_146:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6892(A5),D0
        TST.L D0
        BEQ.W LBL_697
        BRA.W LBL_696
LBL_697:
        MOVEQ #1,D0
        MOVE.B D0,-6892(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6890(A5)
LBL_696:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 148)
LBL_147:
        LINK A6,#-2100
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_698:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 149)
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
LBL_148:
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
        BEQ.W LBL_700
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_699
LBL_700:
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
        BEQ.W LBL_701
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_699
LBL_701:
        BSR.W LBL_146
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_702
        MOVE.L -6890(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_702:
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_703
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_699
LBL_703:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D0
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
        BEQ.W LBL_704
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
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -6890(A5),D1
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
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_705
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_705:
LBL_704:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_147
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_706
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_707
LBL_706:
        MOVEQ #1,D0
LBL_707:
        TST.L D0
        BEQ.W LBL_708
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_699
LBL_708:
        MOVEQ #1,D0
        BRA.W LBL_699
LBL_699:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 150)
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
LBL_149:
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
        BSR.W LBL_146
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_710
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_709
LBL_710:
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_711
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_711:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_712:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_713
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -6890(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_714
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_715
LBL_714:
        MOVEQ #0,D0
LBL_715:
        TST.L D0
        BEQ.W LBL_716
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
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
        BRA.W LBL_709
LBL_716:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_717
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
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
LBL_717:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_718
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_719
LBL_718:
        MOVEQ #1,D0
LBL_719:
        TST.L D0
        BEQ.W LBL_720
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_720:
        BRA.W LBL_712
LBL_713:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
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
        BRA.W LBL_709
LBL_709:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 151)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_150:
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
LBL_722:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_723
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
        BEQ.W LBL_724
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_724:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_722
LBL_723:
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
LBL_725:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_726
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
        BRA.W LBL_725
LBL_726:
LBL_721:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 152)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_151:
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
        BEQ.W LBL_728
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_727
LBL_728:
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
        BSR.W LBL_9
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
        BEQ.W LBL_729
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
LBL_729:
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
        BRA.W LBL_727
LBL_727:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 153)
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
        BEQ.W LBL_731
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_730
LBL_731:
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
        BEQ.W LBL_732
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_730
LBL_732:
        BSR.W LBL_146
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_733
        MOVE.L -6890(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_733:
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_734
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_730
LBL_734:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D0
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
        BEQ.W LBL_735
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
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -6890(A5),D1
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
        MOVE.L -6890(A5),D1
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
        BEQ.W LBL_736
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_736:
LBL_735:
        MOVE.L -6890(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_147
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_737
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_738
LBL_737:
        MOVEQ #1,D0
LBL_738:
        TST.L D0
        BEQ.W LBL_739
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_730
LBL_739:
        MOVEQ #1,D0
        BRA.W LBL_730
LBL_730:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 154)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_153:
        LINK A6,#-2100
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_148
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_741
        MOVEQ #1,D0
        BRA.W LBL_740
LBL_741:
        MOVEQ #0,D0
        BRA.W LBL_740
LBL_740:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 155)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_154:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_149
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_743
        MOVEQ #1,D0
        BRA.W LBL_742
LBL_743:
        MOVEQ #0,D0
        BRA.W LBL_742
LBL_742:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 156)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_155:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_137
        MOVE.L -6896(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_745
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6896(A5)
LBL_745:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6896(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -6896(A5),D1
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
        MOVE.L -6896(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_135
        ADDQ.L #8,A7
        BSR.W LBL_136
LBL_744:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 157)
        ;   param code : 8(A6)  size 4
LBL_156:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
LBL_746:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 158)
LBL_157:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6898(A5),D0
        TST.L D0
        BEQ.W LBL_748
        BRA.W LBL_747
LBL_748:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6902(A5)
        MOVE.L -6902(A5),D1
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
        MOVE.B D0,-6898(A5)
        DC.W $A850  ; NatInitCursor
LBL_747:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 159)
        ;   param out : 8(A6)  size 4
LBL_158:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
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
        MOVE.L -6902(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_749:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 160)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_159:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6902(A5),D1
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
        BEQ.W LBL_751
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_751:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
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
        MOVE.L -6902(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_750:
        UNLK A6
        RTS
        ; func nat_UiConnPump  (JT slot 161)
LBL_160:
        LINK A6,#-2100
        BSR.W LBL_168
LBL_752:
        UNLK A6
        RTS
        ; func takes  (JT slot 162)
        ;   param s : 8(A6)  size 4
LBL_161:
        LINK A6,#-2100
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_753
LBL_753:
        UNLK A6
        RTS
        ; func two  (JT slot 163)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_162:
        LINK A6,#-2100
        MOVEA.L 12(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_754
LBL_754:
        UNLK A6
        RTS
        ; func handler_App_startCLI  (JT slot 164)
        ;   param args : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local parts : -8(A6)  size 4
LBL_163:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_219(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_220(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -524(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_161
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_756
        LEA LBL_222(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_138
        ADDQ.L #4,A7
        BRA.W LBL_757
LBL_756:
        LEA LBL_223(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_138
        ADDQ.L #4,A7
LBL_757:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_758
        BRA.W LBL_759
LBL_758:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_238(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_759:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_242
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_161
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_760
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_138
        ADDQ.L #4,A7
        BRA.W LBL_761
LBL_760:
        LEA LBL_225(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_138
        ADDQ.L #4,A7
LBL_761:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_227(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -524(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_228(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_229(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -1036(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1036(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_162
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_762
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_138
        ADDQ.L #4,A7
        BRA.W LBL_763
LBL_762:
        LEA LBL_231(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_138
        ADDQ.L #4,A7
LBL_763:
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2064(A6)
LBL_764:
        MOVE.L A1,-(A7)
        MOVE.L -2064(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_245
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2064(A6)
LBL_765:
        MOVE.L A1,-(A7)
        MOVE.L -2064(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_755:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 165)
        ;   param slot : 8(A6)  size 4
LBL_164:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_767
        BRA.W LBL_768
LBL_767:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_769
        BRA.W LBL_770
LBL_769:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_771
        BRA.W LBL_772
LBL_771:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_773
        BRA.W LBL_774
LBL_773:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_775
        BRA.W LBL_776
LBL_775:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_777
        BRA.W LBL_778
LBL_777:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_779
        BRA.W LBL_780
LBL_779:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_781
LBL_781:
LBL_780:
LBL_778:
LBL_776:
LBL_774:
LBL_772:
LBL_770:
LBL_768:
LBL_766:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 166)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_165:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_783
        BRA.W LBL_784
LBL_783:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_785
        BRA.W LBL_786
LBL_785:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_787
        BRA.W LBL_788
LBL_787:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_789
        BRA.W LBL_790
LBL_789:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_791
        BRA.W LBL_792
LBL_791:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_793
        BRA.W LBL_794
LBL_793:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_795
        BRA.W LBL_796
LBL_795:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_797
LBL_797:
LBL_796:
LBL_794:
LBL_792:
LBL_790:
LBL_788:
LBL_786:
LBL_784:
LBL_782:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 167)
        ;   param slot : 8(A6)  size 4
LBL_166:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_799
        BRA.W LBL_800
LBL_799:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_801
        BRA.W LBL_802
LBL_801:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_803
        BRA.W LBL_804
LBL_803:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_805
        BRA.W LBL_806
LBL_805:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_807
        BRA.W LBL_808
LBL_807:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_809
        BRA.W LBL_810
LBL_809:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_811
        BRA.W LBL_812
LBL_811:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_813
LBL_813:
LBL_812:
LBL_810:
LBL_808:
LBL_806:
LBL_804:
LBL_802:
LBL_800:
LBL_798:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 168)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_167:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_815
        BRA.W LBL_816
LBL_815:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_817
        BRA.W LBL_818
LBL_817:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_819
        BRA.W LBL_820
LBL_819:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_821
        BRA.W LBL_822
LBL_821:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_823
        BRA.W LBL_824
LBL_823:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_825
        BRA.W LBL_826
LBL_825:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_827
        BRA.W LBL_828
LBL_827:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_829
LBL_829:
LBL_828:
LBL_826:
LBL_824:
LBL_822:
LBL_820:
LBL_818:
LBL_816:
LBL_814:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 169)
LBL_168:
        LINK A6,#-2100
LBL_830:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 170)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_169:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_832
        BRA.W LBL_833
LBL_832:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_834
LBL_834:
LBL_833:
LBL_831:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 171)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_170:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_836
        BRA.W LBL_837
LBL_836:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_838
LBL_838:
LBL_837:
LBL_835:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 172)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_171:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_840
        BRA.W LBL_841
LBL_840:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_842
LBL_842:
LBL_841:
LBL_839:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 173)
        ;   param slot : 8(A6)  size 4
LBL_172:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_844
        BRA.W LBL_845
LBL_844:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_846
LBL_846:
LBL_845:
LBL_843:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 174)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_173:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_848
        BRA.W LBL_849
LBL_848:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_850
LBL_850:
LBL_849:
LBL_847:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 175)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_174:
        LINK A6,#-2100
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_852
        BRA.W LBL_853
LBL_852:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_854
LBL_854:
LBL_853:
LBL_851:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 176)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_175:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_856
        BRA.W LBL_857
LBL_856:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_858
LBL_858:
LBL_857:
LBL_855:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 177)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_176:
        LINK A6,#-2100
        LEA LBL_232(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_139
        ADDQ.L #4,A7
        BSR.W LBL_245
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
LBL_859:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 178)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_177:
        LINK A6,#-2100
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_139
        ADDQ.L #4,A7
        BSR.W LBL_245
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
LBL_860:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 179)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_178:
        LINK A6,#-2100
        LEA LBL_234(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_139
        ADDQ.L #4,A7
        BSR.W LBL_245
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
LBL_861:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 180)
        ;   param idx : 8(A6)  size 4
LBL_179:
        LINK A6,#-2100
        LEA LBL_235(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_139
        ADDQ.L #4,A7
        BSR.W LBL_245
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
LBL_862:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 181)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_180:
        LINK A6,#-2100
        LEA LBL_236(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_139
        ADDQ.L #4,A7
        BSR.W LBL_245
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
LBL_863:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 182)
        ;   param rowsIdx : 8(A6)  size 4
LBL_181:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #124,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_865
        LEA -6618(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_864
        BRA.W LBL_866
LBL_865:
        LEA LBL_237(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_139
        ADDQ.L #4,A7
        BSR.W LBL_245
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_140
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_864
LBL_866:
LBL_864:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 183)
        ;   param path : 8(A6)  size 4
LBL_182:
        LINK A6,#-2100
LBL_867:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 184)
LBL_183:
        LINK A6,#-2100
LBL_868:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 185) -- pascal callback glue for aeQuitHandler
LBL_184:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        BSR.W LBL_79
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 186) -- pascal callback glue for aeOappHandler
LBL_185:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        BSR.W LBL_80
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 187) -- pascal callback glue for rtUiScrollbarAction
LBL_186:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        BSR.W LBL_102
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 188) -- pascal callback glue for rtUiLdefDraw
LBL_187:
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
        BSR.W LBL_110
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_242:
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
LBL_243:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_869
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_239(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_869:
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
        BPL.W LBL_870
        NEG.L D2
        MOVE.L #1,D4
LBL_870:
        CLR.L D5
        TST.L D3
        BPL.W LBL_871
        NEG.L D3
        MOVE.L #1,D5
LBL_871:
        CLR.L D6
        MOVE.W #31,D7
LBL_872:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_873
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_873:
        DBRA D7,LBL_872
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_874
        NEG.L D2
LBL_874:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_244:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_875
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_239(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_875:
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
        BPL.W LBL_876
        NEG.L D2
        MOVE.L #1,D4
LBL_876:
        CLR.L D5
        TST.L D3
        BPL.W LBL_877
        NEG.L D3
        MOVE.L #1,D5
LBL_877:
        CLR.L D6
        MOVE.W #31,D7
LBL_878:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_879
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_879:
        DBRA D7,LBL_878
        TST.L D4
        BEQ.W LBL_880
        NEG.L D6
LBL_880:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_245:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -6618(A5),D0
        MOVE.L D0,-4(A6)
LBL_881:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_239:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_188:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_189:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_190:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_192:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_193:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
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
LBL_238:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_191:
        DC.B $00
        DC.B $00
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
        DC.B $02
        DC.B $78,$79
        DC.B $00
LBL_220:
        DC.B $01
        DC.B $61
LBL_221:
        DC.B $02
        DC.B $62,$63
        DC.B $00
LBL_222:
        DC.B $14
        DC.B $73,$74,$72,$5F,$63,$6F,$6E,$63,$61,$74,$20,$61,$73,$20,$61,$72,$67,$20,$6F,$6B
        DC.B $00
LBL_223:
        DC.B $16
        DC.B $73,$74,$72,$5F,$63,$6F,$6E,$63,$61,$74,$20,$61,$73,$20,$61,$72,$67,$20,$46,$41,$49,$4C
        DC.B $00
LBL_224:
        DC.B $1B
        DC.B $63,$6F,$6E,$74,$61,$69,$6E,$65,$72,$20,$65,$6C,$65,$6D,$65,$6E,$74,$20,$61,$73,$20,$61,$72,$67,$20,$6F,$6B
LBL_225:
        DC.B $1D
        DC.B $63,$6F,$6E,$74,$61,$69,$6E,$65,$72,$20,$65,$6C,$65,$6D,$65,$6E,$74,$20,$61,$73,$20,$61,$72,$67,$20,$46,$41,$49,$4C
LBL_226:
        DC.B $01
        DC.B $70
LBL_227:
        DC.B $01
        DC.B $71
LBL_228:
        DC.B $01
        DC.B $72
LBL_229:
        DC.B $02
        DC.B $73,$74
        DC.B $00
LBL_230:
        DC.B $22
        DC.B $74,$77,$6F,$20,$73,$74,$72,$5F,$63,$6F,$6E,$63,$61,$74,$20,$68,$6F,$69,$73,$74,$73,$2C,$20,$6F,$6E,$65,$20,$63,$61,$6C,$6C,$20,$6F,$6B
        DC.B $00
LBL_231:
        DC.B $24
        DC.B $74,$77,$6F,$20,$73,$74,$72,$5F,$63,$6F,$6E,$63,$61,$74,$20,$68,$6F,$69,$73,$74,$73,$2C,$20,$6F,$6E,$65,$20,$63,$61,$6C,$6C,$20,$46,$41,$49,$4C
        DC.B $00
LBL_232:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_233:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_234:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_235:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_236:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_237:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (44 bytes)
LBL_240:
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
LBL_241:
        DC.B $00
        DC.B $00
