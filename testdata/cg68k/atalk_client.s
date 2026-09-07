LBL_251:
        ; startup (JT slot 0)
        ; globals (below A5, 7424 bytes total):
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
        ;   rtTcpPhase : -6618(A5)  size 32  type arr
        ;   rtTcpPending : -6650(A5)  size 32  type arr
        ;   rtTcpCloseSent : -6658(A5)  size 8  type arr
        ;   rtTcpCloseTick : -6690(A5)  size 32  type arr
        ;   rtTcpUp : -6692(A5)  size 1  type bool
        ;   rtLsnSlotTransport : -6700(A5)  size 8  type arr
        ;   rtLsnPort : -6708(A5)  size 8  type arr
        ;   rtTcpLastErr : -6712(A5)  size 4  type int
        ;   rtTcpParseIp : -6716(A5)  size 4  type int
        ;   rtTcpParsePort : -6720(A5)  size 4  type int
        ;   rtTcp68Ref : -6724(A5)  size 4  type int
        ;   rtTcp68LastErr : -6728(A5)  size 4  type int
        ;   rtTcp68Aux : -6732(A5)  size 4  type int
        ;   rtTcp68Stream : -6764(A5)  size 32  type arr
        ;   rtTcp68Buf : -6796(A5)  size 32  type arr
        ;   rtTcp68Rcv : -6828(A5)  size 32  type arr
        ;   rtTcp68Snd : -6860(A5)  size 32  type arr
        ;   rtTcp68RcvPb : -6892(A5)  size 32  type arr
        ;   rtTcp68Pb : -6924(A5)  size 32  type arr
        ;   rtTcp68Wds : -6956(A5)  size 32  type arr
        ;   rtTcp68RcvLive : -6964(A5)  size 8  type arr
        ;   rtTcp68PbLive : -6972(A5)  size 8  type arr
        ;   rtTcp68PbOp : -7004(A5)  size 32  type arr
        ;   rtTcp68RcvGot : -7036(A5)  size 32  type arr
        ;   rtTcp68LsnStream : -7044(A5)  size 8  type arr
        ;   rtTcp68LsnBuf : -7052(A5)  size 8  type arr
        ;   rtTcp68LsnPb : -7060(A5)  size 8  type arr
        ;   rtTcp68LsnLive : -7062(A5)  size 2  type arr
        ;   rtTcp68LsnReady : -7064(A5)  size 2  type arr
        ;   natPb : -7068(A5)  size 4  type ptr
        ;   natBuf : -7072(A5)  size 4  type ptr
        ;   natDigits : -7076(A5)  size 4  type ptr
        ;   natLogBuf : -7080(A5)  size 4  type ptr
        ;   natLogLen : -7084(A5)  size 4  type int
        ;   natRef : -7088(A5)  size 4  type int
        ;   natOpened : -7090(A5)  size 1  type bool
        ;   natDone : -7092(A5)  size 1  type bool
        ;   natArgs : -7096(A5)  size 4  type list
        ;   natPanicBuf : -7100(A5)  size 4  type ptr
        ;   natEmptyStr : -7104(A5)  size 4  type ptr
        ;   natErrCode : -7108(A5)  size 4  type int
        ;   natErrMsg : -7364(A5)  size 256  type str
        ;   natFilePb : -7368(A5)  size 4  type ptr
        ;   natFileReady : -7370(A5)  size 1  type bool
        ;   natUiEmitBuf : -7374(A5)  size 4  type ptr
        ;   natQdInited : -7376(A5)  size 1  type bool
        ;   natQdGlobals : -7380(A5)  size 4  type ptr
        ;   rtFh68kLastErr : -7384(A5)  size 4  type int
        ;   rtFh68kState : -7388(A5)  size 4  type ptr
        ;   brs : -7392(A5)  size 4  type int
        ;   svc : -7396(A5)  size 4  type int
        ;   link : -7400(A5)  size 4  type int
        ;   direct : -7404(A5)  size 4  type int
        ;   found : -7408(A5)  size 4  type int
        ;   zones : -7412(A5)  size 4  type list
        ;   reply : -7416(A5)  size 4  type text
        ;   req : -7420(A5)  size 4  type text
        LEA -7424(A5),A0
        MOVE.W #3711,D0
LBL_253:
        CLR.W (A0)+
        DBRA D0,LBL_253
        MOVEA.L $0130.W,A0
        ADDA.L #-129112,A0
        DC.W $A02D  ; _SetApplLimit
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_252
        JSR 4402(A5)
        ; UI startup: rtUiStartup / [App.launch] / rtUiLaunch / rtUiRun
        BSR.W LBL_211
        JSR 4586(A5)
        JSR 1890(A5)
        JSR 1882(A5)
        BSR.W LBL_250
        CLR.L -(A7)
        JSR 4426(A5)
        RTS
LBL_252:
        ; cg_init_globals
        LINK A6,#-48
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        MOVE.L #1,D0
        MOVE.B D0,-90(A5)
        LEA -6650(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6646(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6642(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6638(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6634(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6630(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6626(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6622(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -7096(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_30
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-7392(A5)
        MOVE.L #1,D0
        MOVE.L D0,-7396(A5)
        MOVE.L #1,D0
        MOVE.L D0,-7400(A5)
        MOVE.L #2,D0
        MOVE.L D0,-7404(A5)
        LEA -7412(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_30
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -7416(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -7420(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
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
        JSR 4442(A5)
        ADDQ.L #8,A7
LBL_254:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-2100
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 4434(A5)
        ADDQ.L #4,A7
LBL_255:
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
        BEQ.W LBL_257
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_256
LBL_257:
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
        BEQ.W LBL_258
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
LBL_258:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_259
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
LBL_259:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_260
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
LBL_260:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
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
LBL_261:
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
        BRA.W LBL_256
LBL_256:
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
        BRA.W LBL_262
LBL_262:
        UNLK A6
        RTS
        ; func rtArrCheck  (JT slot 5)
        ;   param i : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_4:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_264
        MOVE.L 12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_265
LBL_264:
        MOVEQ #1,D0
LBL_265:
        TST.L D0
        BEQ.W LBL_266
        LEA LBL_222(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_266:
        MOVE.L 12(A6),D0
        BRA.W LBL_263
LBL_263:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 6)
        ;   param v : 14(A6)  size 4
        ;   param found : 12(A6)  size 2
        ;   param name : 8(A6)  size 4
LBL_5:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B 12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        LEA LBL_223(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_268:
        MOVE.L 14(A6),D0
        BRA.W LBL_267
LBL_267:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 7)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_6:
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
        BEQ.W LBL_270
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_271
LBL_270:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_271:
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
        BEQ.W LBL_272
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_272:
LBL_269:
        UNLK A6
        RTS
        ; func rtStrConcat  (JT slot 8)
        ;   param out : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local total : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local fromA : -20(A6)  size 4
        ;   local fromB : -24(A6)  size 4
LBL_7:
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
        BEQ.W LBL_274
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_275
LBL_274:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_275:
        MOVE.L -4(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_276
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_277
LBL_276:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_277:
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
        BEQ.W LBL_278
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_278:
LBL_273:
        UNLK A6
        RTS
        ; func rtStrConcatChar  (JT slot 9)
        ;   param out : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local total : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local copyLen : -16(A6)  size 4
LBL_8:
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
        BEQ.W LBL_280
        MOVE.L #255,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_281
LBL_280:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_281:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_282
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_283
LBL_282:
        MOVE.L -4(A6),D0
        MOVE.L D0,-16(A6)
LBL_283:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_284
        MOVE.L 16(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_284:
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
        BEQ.W LBL_285
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_285:
LBL_279:
        UNLK A6
        RTS
        ; func rtStrPrependChar  (JT slot 10)
        ;   param out : 16(A6)  size 4
        ;   param c : 12(A6)  size 4
        ;   param a : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local total : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_9:
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
        BEQ.W LBL_287
        MOVE.L #255,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_288
LBL_287:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_288:
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
        BEQ.W LBL_289
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_289:
LBL_286:
        UNLK A6
        RTS
        ; func rtStrCmp  (JT slot 11)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local ca : -20(A6)  size 4
        ;   local cb : -24(A6)  size 4
LBL_10:
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
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_291
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_292
LBL_291:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_292:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_293:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_294
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_295
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_290
LBL_295:
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_296
        MOVEQ #1,D0
        BRA.W LBL_290
LBL_296:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_293
LBL_294:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_297
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_290
LBL_297:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_298
        MOVEQ #1,D0
        BRA.W LBL_290
LBL_298:
        MOVEQ #0,D0
        BRA.W LBL_290
LBL_290:
        UNLK A6
        RTS
        ; func rtStrLen  (JT slot 12)
        ;   param s : 8(A6)  size 4
LBL_11:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_299
LBL_299:
        UNLK A6
        RTS
        ; func rtStrIndex  (JT slot 13)
        ;   param s : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_12:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_301
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
        BRA.W LBL_302
LBL_301:
        MOVEQ #1,D0
LBL_302:
        TST.L D0
        BEQ.W LBL_303
        LEA LBL_225(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_303:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_300
LBL_300:
        UNLK A6
        RTS
        ; func rtIntToStr  (JT slot 14)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param n : 12(A6)  size 4
        ;   local s : -256(A6)  size 256
        ;   local d : -260(A6)  size 4
        ;   local neg : -262(A6)  size 2
        ;   local cur : -266(A6)  size 4
LBL_13:
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
        BEQ.W LBL_305
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        BRA.W LBL_304
LBL_305:
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
        LEA LBL_227(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
LBL_306:
        MOVE.L -266(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_307
        MOVE.L -266(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_249
        MOVE.L D0,-260(A6)
        MOVE.L -260(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_308
        MOVEQ #0,D1
        MOVE.L -260(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-260(A6)
LBL_308:
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
        BSR.W LBL_9
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        ADDA.W #256,A7
        MOVE.L -266(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_248
        MOVE.L D0,-266(A6)
        BRA.W LBL_306
LBL_307:
        CLR.L D0
        MOVE.B -262(A6),D0
        TST.L D0
        BEQ.W LBL_309
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_228(PC),A0
        MOVE.L A0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        ADDA.W #256,A7
LBL_309:
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        BRA.W LBL_304
LBL_304:
        UNLK A6
        RTS
        ; func rtStrSlice  (JT slot 15)
        ;   param out : 20(A6)  size 4
        ;   param s : 16(A6)  size 4
        ;   param start : 12(A6)  size 4
        ;   param len : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
LBL_14:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_311
        MOVE.L 8(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_312
LBL_311:
        MOVEQ #1,D0
LBL_312:
        TST.L D0
        BEQ.W LBL_313
        LEA LBL_229(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_313:
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_314
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_315
LBL_314:
        MOVEQ #1,D0
LBL_315:
        TST.L D0
        BEQ.W LBL_316
        LEA LBL_229(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_316:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_310:
        UNLK A6
        RTS
        ; func rtStrIndexOfChar  (JT slot 16)
        ;   param s : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local slen : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_15:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_318:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_319
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_320
        MOVE.L -8(A6),D0
        BRA.W LBL_317
LBL_320:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_318
LBL_319:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_317
LBL_317:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 17)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_16:
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
        BEQ.W LBL_322
        BRA.W LBL_321
LBL_322:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_324
LBL_323:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_324:
LBL_325:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_326
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_247
        MOVE.L D0,-12(A6)
        BRA.W LBL_325
LBL_326:
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
        BEQ.W LBL_327
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_327:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_321:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 18)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_17:
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
        BEQ.W LBL_329
        LEA LBL_230(PC),A0
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
        BEQ.W LBL_330
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_330:
        MOVE.L -4(A6),D0
        BRA.W LBL_328
LBL_328:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 19)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_18:
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
        ; func rtTextRelease  (JT slot 20)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_19:
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
        DC.W $A023  ; TextDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
LBL_336:
LBL_333:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 21)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_20:
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
        BSR.W LBL_16
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
LBL_337:
        UNLK A6
        RTS
        ; func rtTextLen  (JT slot 22)
        ;   param t : 8(A6)  size 4
LBL_21:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_338
LBL_338:
        UNLK A6
        RTS
        ; func rtTextIndex  (JT slot 23)
        ;   param t : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_22:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_340
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
        BRA.W LBL_341
LBL_340:
        MOVEQ #1,D0
LBL_341:
        TST.L D0
        BEQ.W LBL_342
        LEA LBL_231(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_342:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_339
LBL_339:
        UNLK A6
        RTS
        ; func rtTextFromBytes  (JT slot 24)
        ;   param t : 20(A6)  size 4
        ;   param buf : 16(A6)  size 4
        ;   param bufcap : 12(A6)  size 4
        ;   param count : 8(A6)  size 4
        ;   local want : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local rt : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_23:
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
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_344
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_345
LBL_344:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
LBL_345:
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_347
LBL_346:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
LBL_347:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_343:
        UNLK A6
        RTS
        ; func rtTextToBytes  (JT slot 25)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_24:
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
        BEQ.W LBL_349
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_350
LBL_349:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_350:
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
        BEQ.W LBL_351
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_351:
        MOVE.L -8(A6),D0
        BRA.W LBL_348
LBL_348:
        UNLK A6
        RTS
        ; func rtTextAppendStr  (JT slot 26)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local len0 : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_25:
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
        BSR.W LBL_16
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
LBL_352:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 27)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
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
        BSR.W LBL_16
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
LBL_353:
        UNLK A6
        RTS
        ; func rtTextClear  (JT slot 28)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_27:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_354:
        UNLK A6
        RTS
        ; func rtTextAppendText  (JT slot 29)
        ;   param t : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local rs : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local len0 : -16(A6)  size 4
        ;   local srcmp : -20(A6)  size 4
        ;   local dstmp : -24(A6)  size 4
LBL_28:
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
        BSR.W LBL_16
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
LBL_355:
        UNLK A6
        RTS
        ; func rtListGrow  (JT slot 30)
        ;   param l : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local elemsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
LBL_29:
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
        BEQ.W LBL_357
        BRA.W LBL_356
LBL_357:
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
        BEQ.W LBL_358
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_359
LBL_358:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_359:
LBL_360:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_361
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_247
        MOVE.L D0,-12(A6)
        BRA.W LBL_360
LBL_361:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_247
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
        BEQ.W LBL_362
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_362:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_356:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 31)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_30:
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
        BEQ.W LBL_364
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_364:
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
        BEQ.W LBL_365
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_365:
        MOVE.L -4(A6),D0
        BRA.W LBL_363
LBL_363:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 32)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_31:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_367
        BRA.W LBL_366
LBL_367:
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
LBL_366:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 33)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
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
        BEQ.W LBL_369
        BRA.W LBL_368
LBL_369:
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
        BEQ.W LBL_370
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_370:
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
        BEQ.W LBL_371
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
LBL_371:
LBL_368:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 34)
        ;   param l : 8(A6)  size 4
LBL_33:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_373
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_374
LBL_373:
        MOVEQ #0,D0
LBL_374:
        BRA.W LBL_372
LBL_372:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 35)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_34:
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
        BNE.W LBL_376
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
        BRA.W LBL_377
LBL_376:
        MOVEQ #1,D0
LBL_377:
        TST.L D0
        BEQ.W LBL_378
        LEA LBL_232(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_378:
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
        BSR.W LBL_247
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        BRA.W LBL_375
LBL_375:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 36)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_35:
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
        BSR.W LBL_29
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
        BSR.W LBL_247
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
LBL_379:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 37)
        ;   param l : 8(A6)  size 4
LBL_36:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_380
LBL_380:
        UNLK A6
        RTS
        ; func rtListClear  (JT slot 38)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_37:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_381:
        UNLK A6
        RTS
        ; func mapEntrySlot  (JT slot 39)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_38:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_382
LBL_382:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 40)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_39:
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
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_383
LBL_383:
        UNLK A6
        RTS
        ; func mapIndexSlot  (JT slot 41)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_40:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_384
LBL_384:
        UNLK A6
        RTS
        ; func mapEntryHash  (JT slot 42)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_41:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_385
LBL_385:
        UNLK A6
        RTS
        ; func mapEntryKeyOff  (JT slot 43)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_42:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func mapEntryKeyLen  (JT slot 44)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_43:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_387
LBL_387:
        UNLK A6
        RTS
        ; func mapSetEntryMeta  (JT slot 45)
        ;   param m : 24(A6)  size 4
        ;   param i : 20(A6)  size 4
        ;   param hash : 16(A6)  size 4
        ;   param keyOff : 12(A6)  size 4
        ;   param keyLen : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_44:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_388:
        UNLK A6
        RTS
        ; func mapHash  (JT slot 46)
        ;   param key : 8(A6)  size 4
        ;   local klen : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local h : -12(A6)  size 4
        ;   local b : -16(A6)  size 4
LBL_45:
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
        MOVE.L #5381,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_390:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_391
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVE.L #2147483647,D0
        AND.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_390
LBL_391:
        MOVE.L -12(A6),D0
        BRA.W LBL_389
LBL_389:
        UNLK A6
        RTS
        ; func mapPoolKeyEq  (JT slot 47)
        ;   param m : 24(A6)  size 4
        ;   param keyOff : 20(A6)  size 4
        ;   param keyLen : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param klen : 8(A6)  size 4
        ;   local base : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_46:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_393
        MOVEQ #0,D0
        BRA.W LBL_392
LBL_393:
        MOVE.L 24(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 20(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_394:
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_395
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_396
        MOVEQ #0,D0
        BRA.W LBL_392
LBL_396:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_394
LBL_395:
        MOVEQ #1,D0
        BRA.W LBL_392
LBL_392:
        UNLK A6
        RTS
        ; func mapIndexFindSlot  (JT slot 48)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local slot : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
        ;   local steps : -20(A6)  size 4
LBL_47:
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
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_398
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_397
LBL_398:
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_399:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #-1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_397
LBL_401:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_402
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDA.W #20,A7
        BRA.W LBL_404
LBL_403:
        MOVEQ #0,D0
LBL_404:
        TST.L D0
        BEQ.W LBL_405
        MOVE.L -12(A6),D0
        BRA.W LBL_397
LBL_405:
LBL_402:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_406:
        BRA.W LBL_399
LBL_400:
LBL_397:
        UNLK A6
        RTS
        ; func mapIndexLookup  (JT slot 49)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_48:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_408
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_407
LBL_408:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_407
LBL_407:
        UNLK A6
        RTS
        ; func mapIndexSlotFor  (JT slot 50)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local firstTomb : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
        ;   local steps : -20(A6)  size 4
LBL_49:
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
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-8(A6)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_410:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_411
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #-1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_412
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_413
        MOVE.L -12(A6),D0
        BRA.W LBL_409
LBL_413:
        MOVE.L -8(A6),D0
        BRA.W LBL_409
LBL_412:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_415
LBL_414:
        MOVEQ #0,D0
LBL_415:
        TST.L D0
        BEQ.W LBL_416
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_416:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_417
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_417:
        BRA.W LBL_410
LBL_411:
LBL_409:
        UNLK A6
        RTS
        ; func mapIndexInsert  (JT slot 51)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param entryIdx : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local slotPtr : -12(A6)  size 4
        ;   local old : -16(A6)  size 4
LBL_50:
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_419:
LBL_418:
        UNLK A6
        RTS
        ; func mapAllocIndex  (JT slot 52)
        ;   param m : 12(A6)  size 4
        ;   param newcap : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
LBL_51:
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
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; MapSetHandleSize
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_421:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_422:
        MOVE.L -16(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_423
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #-1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_422
LBL_423:
LBL_420:
        UNLK A6
        RTS
        ; func mapRehash  (JT slot 53)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local newcap : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local h : -16(A6)  size 4
LBL_52:
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
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_247
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_425:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_425
LBL_426:
LBL_424:
        UNLK A6
        RTS
        ; func mapEnsureIndexCapacity  (JT slot 54)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_53:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        BRA.W LBL_427
LBL_428:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
LBL_429:
LBL_427:
        UNLK A6
        RTS
        ; func mapGrowHandle  (JT slot 55)
        ;   param h : 20(A6)  size 4
        ;   param cap : 16(A6)  size 4
        ;   param need : 12(A6)  size 4
        ;   param unit : 8(A6)  size 4
        ;   local newcap : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
LBL_54:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_432
LBL_431:
        MOVEQ #4,D0
        MOVE.L D0,-4(A6)
LBL_432:
LBL_433:
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_247
        MOVE.L D0,-4(A6)
        BRA.W LBL_433
LBL_434:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; MapSetHandleSize
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_435:
        MOVE.L -4(A6),D0
        BRA.W LBL_430
LBL_430:
        UNLK A6
        RTS
        ; func mapGrowEntries  (JT slot 56)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_55:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_437
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #12,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_437:
LBL_436:
        UNLK A6
        RTS
        ; func mapGrowVals  (JT slot 57)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_56:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_439:
LBL_438:
        UNLK A6
        RTS
        ; func mapGrowPool  (JT slot 58)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_57:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_441:
LBL_440:
        UNLK A6
        RTS
        ; func mapPoolAppend  (JT slot 59)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_58:
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
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
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
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        BRA.W LBL_442
LBL_442:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 60)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_59:
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
        BEQ.W LBL_444
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_444:
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
        BEQ.W LBL_445
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_445:
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
        BEQ.W LBL_446
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_446:
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
        BEQ.W LBL_447
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_447:
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
        BEQ.W LBL_448
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_448:
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
        BRA.W LBL_443
LBL_443:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 61)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_60:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_450
        BRA.W LBL_449
LBL_450:
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
LBL_449:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 62)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_61:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_452
        BRA.W LBL_451
LBL_452:
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
        BEQ.W LBL_453
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_453:
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
        BEQ.W LBL_454
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
LBL_454:
LBL_451:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 63)
        ;   param m : 8(A6)  size 4
LBL_62:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_456
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_457
LBL_456:
        MOVEQ #0,D0
LBL_457:
        BRA.W LBL_455
LBL_455:
        UNLK A6
        RTS
        ; func rtMapSet  (JT slot 64)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param val : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local h : -8(A6)  size 4
        ;   local idx : -12(A6)  size 4
        ;   local klen : -16(A6)  size 4
        ;   local keyOff : -20(A6)  size 4
LBL_63:
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDA.W #12,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
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
        BRA.W LBL_458
LBL_459:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #8,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_458:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 65)
        ;   param m : 8(A6)  size 4
LBL_64:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_460
LBL_460:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 66)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_65:
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
        BNE.W LBL_462
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
        BRA.W LBL_463
LBL_462:
        MOVEQ #1,D0
LBL_463:
        TST.L D0
        BEQ.W LBL_464
        LEA LBL_234(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_464:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
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
LBL_461:
        UNLK A6
        RTS
        ; func rtIntMapNew  (JT slot 67)
        ;   param valsize : 8(A6)  size 4
LBL_66:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #4,A7
        BRA.W LBL_465
LBL_465:
        UNLK A6
        RTS
        ; func rtIntMapRetain  (JT slot 68)
        ;   param m : 8(A6)  size 4
LBL_67:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDQ.L #4,A7
LBL_466:
        UNLK A6
        RTS
        ; func rtIntMapRelease  (JT slot 69)
        ;   param m : 8(A6)  size 4
LBL_68:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
LBL_467:
        UNLK A6
        RTS
        ; func rtIntMapLastref  (JT slot 70)
        ;   param m : 8(A6)  size 4
LBL_69:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
        BRA.W LBL_468
LBL_468:
        UNLK A6
        RTS
        ; func rtIntMapCount  (JT slot 71)
        ;   param m : 8(A6)  size 4
LBL_70:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_469
LBL_469:
        UNLK A6
        RTS
        ; func rtIntMapValAt  (JT slot 72)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_71:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
LBL_470:
        UNLK A6
        RTS
        ; func uidI32  (JT slot 73)
        ;   param p : 8(A6)  size 4
        ;   local b0 : -4(A6)  size 4
        ;   local b1 : -8(A6)  size 4
        ;   local b2 : -12(A6)  size 4
        ;   local b3 : -16(A6)  size 4
LBL_72:
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
        BRA.W LBL_471
LBL_471:
        UNLK A6
        RTS
        ; func uidStrPtr  (JT slot 74)
        ;   param off : 8(A6)  size 4
LBL_73:
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
        BEQ.W LBL_473
        MOVEQ #0,D0
        BRA.W LBL_472
LBL_473:
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_472
LBL_472:
        UNLK A6
        RTS
        ; func uidNWins  (JT slot 75)
LBL_74:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_474
LBL_474:
        UNLK A6
        RTS
        ; func uidWinsOff  (JT slot 76)
LBL_75:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_475
LBL_475:
        UNLK A6
        RTS
        ; func uidNMenus  (JT slot 77)
LBL_76:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_476
LBL_476:
        UNLK A6
        RTS
        ; func uidMenusOff  (JT slot 78)
LBL_77:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_477
LBL_477:
        UNLK A6
        RTS
        ; func uidNMenuHandlers  (JT slot 79)
LBL_78:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_478
LBL_478:
        UNLK A6
        RTS
        ; func uidMhOff  (JT slot 80)
LBL_79:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_479
LBL_479:
        UNLK A6
        RTS
        ; func uidNEvery  (JT slot 81)
LBL_80:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_480
LBL_480:
        UNLK A6
        RTS
        ; func uidEveryOff  (JT slot 82)
LBL_81:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_481
LBL_481:
        UNLK A6
        RTS
        ; func uidAppOff  (JT slot 83)
LBL_82:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_482
LBL_482:
        UNLK A6
        RTS
        ; func uidWinBase  (JT slot 84)
        ;   param winIdx : 8(A6)  size 4
LBL_83:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_483
LBL_483:
        UNLK A6
        RTS
        ; func uidWinNameOff  (JT slot 85)
        ;   param winIdx : 8(A6)  size 4
LBL_84:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func uidWinName  (JT slot 86)
        ;   param winIdx : 8(A6)  size 4
LBL_85:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_485
LBL_485:
        UNLK A6
        RTS
        ; func uidWinTitleOff  (JT slot 87)
        ;   param winIdx : 8(A6)  size 4
LBL_86:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_486
LBL_486:
        UNLK A6
        RTS
        ; func uidWinTitle  (JT slot 88)
        ;   param winIdx : 8(A6)  size 4
LBL_87:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_487
LBL_487:
        UNLK A6
        RTS
        ; func uidWinW  (JT slot 89)
        ;   param winIdx : 8(A6)  size 4
LBL_88:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_488
LBL_488:
        UNLK A6
        RTS
        ; func uidWinH  (JT slot 90)
        ;   param winIdx : 8(A6)  size 4
LBL_89:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_489
LBL_489:
        UNLK A6
        RTS
        ; func uidWinResizable  (JT slot 91)
        ;   param winIdx : 8(A6)  size 4
LBL_90:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_490
LBL_490:
        UNLK A6
        RTS
        ; func uidWinMinW  (JT slot 92)
        ;   param winIdx : 8(A6)  size 4
LBL_91:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_491
LBL_491:
        UNLK A6
        RTS
        ; func uidWinMinH  (JT slot 93)
        ;   param winIdx : 8(A6)  size 4
LBL_92:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_492
LBL_492:
        UNLK A6
        RTS
        ; func uidWinNWidgets  (JT slot 94)
        ;   param winIdx : 8(A6)  size 4
LBL_93:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_493
LBL_493:
        UNLK A6
        RTS
        ; func uidWinWidgetsOff  (JT slot 95)
        ;   param winIdx : 8(A6)  size 4
LBL_94:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_494
LBL_494:
        UNLK A6
        RTS
        ; func uidWinStateSize  (JT slot 96)
        ;   param winIdx : 8(A6)  size 4
LBL_95:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_495
LBL_495:
        UNLK A6
        RTS
        ; func uidWinFormOff  (JT slot 97)
        ;   param winIdx : 8(A6)  size 4
LBL_96:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_496
LBL_496:
        UNLK A6
        RTS
        ; func uidWinMenuMask  (JT slot 98)
        ;   param winIdx : 8(A6)  size 4
LBL_97:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_497
LBL_497:
        UNLK A6
        RTS
        ; func uidWidgetBase  (JT slot 99)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_98:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_94
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_498
LBL_498:
        UNLK A6
        RTS
        ; func uidWidgetKind  (JT slot 100)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_99:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_499
LBL_499:
        UNLK A6
        RTS
        ; func uidWidgetNameOff  (JT slot 101)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_100:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_500
LBL_500:
        UNLK A6
        RTS
        ; func uidWidgetName  (JT slot 102)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_101:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_501
LBL_501:
        UNLK A6
        RTS
        ; func uidWidgetCaptionOff  (JT slot 103)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_102:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_502
LBL_502:
        UNLK A6
        RTS
        ; func uidWidgetCaption  (JT slot 104)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_103:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_102
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_503
LBL_503:
        UNLK A6
        RTS
        ; func uidWidgetAtKind  (JT slot 105)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_104:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_504
LBL_504:
        UNLK A6
        RTS
        ; func uidWidgetX  (JT slot 106)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_105:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_505
LBL_505:
        UNLK A6
        RTS
        ; func uidWidgetYIsBottom  (JT slot 107)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_106:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_506
LBL_506:
        UNLK A6
        RTS
        ; func uidWidgetY  (JT slot 108)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_107:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_507
LBL_507:
        UNLK A6
        RTS
        ; func uidWidgetWidthIsFill  (JT slot 109)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_108:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_508
LBL_508:
        UNLK A6
        RTS
        ; func uidWidgetWidth  (JT slot 110)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_109:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_509
LBL_509:
        UNLK A6
        RTS
        ; func uidWidgetFillBoth  (JT slot 111)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_110:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_510
LBL_510:
        UNLK A6
        RTS
        ; func uidWidgetFlags  (JT slot 112)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_111:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_511
LBL_511:
        UNLK A6
        RTS
        ; func uidWidgetTableOff  (JT slot 113)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_112:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_512
LBL_512:
        UNLK A6
        RTS
        ; func uidMenuBase  (JT slot 114)
        ;   param menuIdx : 8(A6)  size 4
LBL_113:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_513
LBL_513:
        UNLK A6
        RTS
        ; func uidMenuTitleOff  (JT slot 115)
        ;   param menuIdx : 8(A6)  size 4
LBL_114:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_514
LBL_514:
        UNLK A6
        RTS
        ; func uidMenuTitle  (JT slot 116)
        ;   param menuIdx : 8(A6)  size 4
LBL_115:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_515
LBL_515:
        UNLK A6
        RTS
        ; func uidMenuNItems  (JT slot 117)
        ;   param menuIdx : 8(A6)  size 4
LBL_116:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_516
LBL_516:
        UNLK A6
        RTS
        ; func uidMenuItemsOff  (JT slot 118)
        ;   param menuIdx : 8(A6)  size 4
LBL_117:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_517
LBL_517:
        UNLK A6
        RTS
        ; func uidMenuIsStandardEdit  (JT slot 119)
        ;   param menuIdx : 8(A6)  size 4
LBL_118:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_518
LBL_518:
        UNLK A6
        RTS
        ; func uidItemBase  (JT slot 120)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_119:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_117
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_519
LBL_519:
        UNLK A6
        RTS
        ; func uidItemLabelOff  (JT slot 121)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_120:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_520
LBL_520:
        UNLK A6
        RTS
        ; func uidItemLabel  (JT slot 122)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_121:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_120
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_521
LBL_521:
        UNLK A6
        RTS
        ; func uidItemKey  (JT slot 123)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_122:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_522
LBL_522:
        UNLK A6
        RTS
        ; func uidItemSeparator  (JT slot 124)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_123:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_523
LBL_523:
        UNLK A6
        RTS
        ; func uidMenuHandlerBase  (JT slot 125)
        ;   param k : 8(A6)  size 4
LBL_124:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_524
LBL_524:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuIdx  (JT slot 126)
        ;   param k : 8(A6)  size 4
LBL_125:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_525
LBL_525:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemIdx  (JT slot 127)
        ;   param k : 8(A6)  size 4
LBL_126:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_526
LBL_526:
        UNLK A6
        RTS
        ; func uidMenuHandlerScopeWinIdx  (JT slot 128)
        ;   param k : 8(A6)  size 4
LBL_127:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_527
LBL_527:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuNameOff  (JT slot 129)
        ;   param k : 8(A6)  size 4
LBL_128:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_528
LBL_528:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuName  (JT slot 130)
        ;   param k : 8(A6)  size 4
LBL_129:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_128
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_529
LBL_529:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemNameOff  (JT slot 131)
        ;   param k : 8(A6)  size 4
LBL_130:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_530
LBL_530:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemName  (JT slot 132)
        ;   param k : 8(A6)  size 4
LBL_131:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_130
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_531
LBL_531:
        UNLK A6
        RTS
        ; func uidEveryTicks  (JT slot 133)
        ;   param k : 8(A6)  size 4
LBL_132:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_532
LBL_532:
        UNLK A6
        RTS
        ; func uidHasApp  (JT slot 134)
LBL_133:
        LINK A6,#-2100
        BSR.W LBL_82
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_533
LBL_533:
        UNLK A6
        RTS
        ; func uidAppNameOff  (JT slot 135)
LBL_134:
        LINK A6,#-2100
        BSR.W LBL_133
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_535
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_534
LBL_535:
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_534
LBL_534:
        UNLK A6
        RTS
        ; func uidAppName  (JT slot 136)
LBL_135:
        LINK A6,#-2100
        BSR.W LBL_134
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_536
LBL_536:
        UNLK A6
        RTS
        ; func uidAppVersionOff  (JT slot 137)
LBL_136:
        LINK A6,#-2100
        BSR.W LBL_133
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_538
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_537
LBL_538:
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_537
LBL_537:
        UNLK A6
        RTS
        ; func uidAppVersion  (JT slot 138)
LBL_137:
        LINK A6,#-2100
        BSR.W LBL_136
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_539
LBL_539:
        UNLK A6
        RTS
        ; func uidAppAuthorOff  (JT slot 139)
LBL_138:
        LINK A6,#-2100
        BSR.W LBL_133
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_540
LBL_541:
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_540
LBL_540:
        UNLK A6
        RTS
        ; func uidAppAuthor  (JT slot 140)
LBL_139:
        LINK A6,#-2100
        BSR.W LBL_138
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_542
LBL_542:
        UNLK A6
        RTS
        ; func uidAppAboutOff  (JT slot 141)
LBL_140:
        LINK A6,#-2100
        BSR.W LBL_133
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_544
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_543
LBL_544:
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_543
LBL_543:
        UNLK A6
        RTS
        ; func uidAppAbout  (JT slot 142)
LBL_141:
        LINK A6,#-2100
        BSR.W LBL_140
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_545
LBL_545:
        UNLK A6
        RTS
        ; func uidFormLayoutOff  (JT slot 143)
        ;   param off : 8(A6)  size 4
LBL_142:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_546
LBL_546:
        UNLK A6
        RTS
        ; func uidFormNBinds  (JT slot 144)
        ;   param off : 8(A6)  size 4
LBL_143:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_547
LBL_547:
        UNLK A6
        RTS
        ; func uidFormBindsOff  (JT slot 145)
        ;   param off : 8(A6)  size 4
LBL_144:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_548
LBL_548:
        UNLK A6
        RTS
        ; func uidBindBase  (JT slot 146)
        ;   param bindsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_145:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_549
LBL_549:
        UNLK A6
        RTS
        ; func uidBindWidgetIndex  (JT slot 147)
        ;   param bindsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_146:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_145
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_550
LBL_550:
        UNLK A6
        RTS
        ; func uidBindFieldIndex  (JT slot 148)
        ;   param bindsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_147:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_145
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_551
LBL_551:
        UNLK A6
        RTS
        ; func uidFormFindFieldIndex  (JT slot 149)
        ;   param off : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
        ;   local bindsOff : -4(A6)  size 4
        ;   local nBinds : -8(A6)  size 4
        ;   local b : -12(A6)  size 4
LBL_148:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_553
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_552
LBL_553:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_554:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_555
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_146
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_556
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_147
        ADDQ.L #8,A7
        BRA.W LBL_552
LBL_556:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_554
LBL_555:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_552
LBL_552:
        UNLK A6
        RTS
        ; func uidTableRowsIdx  (JT slot 150)
        ;   param off : 8(A6)  size 4
LBL_149:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_557
LBL_557:
        UNLK A6
        RTS
        ; func uidTableLayoutOff  (JT slot 151)
        ;   param off : 8(A6)  size 4
LBL_150:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_558
LBL_558:
        UNLK A6
        RTS
        ; func uidTableNCols  (JT slot 152)
        ;   param off : 8(A6)  size 4
LBL_151:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_559
LBL_559:
        UNLK A6
        RTS
        ; func uidTableColsOff  (JT slot 153)
        ;   param off : 8(A6)  size 4
LBL_152:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_560
LBL_560:
        UNLK A6
        RTS
        ; func uidColBase  (JT slot 154)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_153:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_561
LBL_561:
        UNLK A6
        RTS
        ; func uidColHeaderOff  (JT slot 155)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_154:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_153
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_562
LBL_562:
        UNLK A6
        RTS
        ; func uidColHeader  (JT slot 156)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_155:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_154
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_563
LBL_563:
        UNLK A6
        RTS
        ; func uidColWidthPx  (JT slot 157)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_156:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_153
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_564
LBL_564:
        UNLK A6
        RTS
        ; func uidColWidthFill  (JT slot 158)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_157:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_153
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_565
LBL_565:
        UNLK A6
        RTS
        ; func uidColFieldIndex  (JT slot 159)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_158:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_153
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_566
LBL_566:
        UNLK A6
        RTS
        ; func uidLayoutRecSize  (JT slot 160)
        ;   param off : 8(A6)  size 4
LBL_159:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_567
LBL_567:
        UNLK A6
        RTS
        ; func uidFieldBase  (JT slot 161)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_160:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
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
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_568
LBL_568:
        UNLK A6
        RTS
        ; func uidFieldFtype  (JT slot 162)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_161:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_160
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_569
LBL_569:
        UNLK A6
        RTS
        ; func uidFieldOffset  (JT slot 163)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_162:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_160
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_570
LBL_570:
        UNLK A6
        RTS
        ; func uidFieldStrCap  (JT slot 164)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_163:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_160
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_571
LBL_571:
        UNLK A6
        RTS
        ; func uidFieldEnumCount  (JT slot 165)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_164:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_160
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_572
LBL_572:
        UNLK A6
        RTS
        ; func uidFieldEnumLabelsOff  (JT slot 166)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_165:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_160
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_573
LBL_573:
        UNLK A6
        RTS
        ; func uidFieldEnumValuesOff  (JT slot 167)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_166:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_160
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_574
LBL_574:
        UNLK A6
        RTS
        ; func uidEnumLabelOff  (JT slot 168)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_167:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_575
LBL_575:
        UNLK A6
        RTS
        ; func uidEnumLabel  (JT slot 169)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_168:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_167
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_576
LBL_576:
        UNLK A6
        RTS
        ; func uidEnumValue  (JT slot 170)
        ;   param enumValuesOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_169:
        LINK A6,#-2100
        LEA LBL_245(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        BRA.W LBL_577
LBL_577:
        UNLK A6
        RTS
        ; func rtUiAllocLocked  (JT slot 171)
        ;   param sz : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
LBL_170:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_173
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_579
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_579:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -4(A6),D0
        BRA.W LBL_578
LBL_578:
        UNLK A6
        RTS
        ; func UiNewPtr  (JT slot 172)
        ;   param size : 8(A6)  size 4
LBL_171:
        LINK A6,#-2100
        JSR 2650(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtrRaw
        MOVE.L A0,D0
        BRA.W LBL_580
LBL_580:
        UNLK A6
        RTS
        ; func UiNewPtrClear  (JT slot 173)
        ;   param size : 8(A6)  size 4
LBL_172:
        LINK A6,#-2100
        JSR 2650(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; UiNewPtrClearRaw
        MOVE.L A0,D0
        BRA.W LBL_581
LBL_581:
        UNLK A6
        RTS
        ; func UiNewHandleClear  (JT slot 174)
        ;   param size : 8(A6)  size 4
LBL_173:
        LINK A6,#-2100
        JSR 2650(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A322  ; UiNewHandleClearRaw
        MOVE.L A0,D0
        BRA.W LBL_582
LBL_582:
        UNLK A6
        RTS
        ; func UiNewWindow  (JT slot 175)
        ;   param wStorage : 32(A6)  size 4
        ;   param boundsRect : 28(A6)  size 4
        ;   param title : 24(A6)  size 4
        ;   param visible : 22(A6)  size 2
        ;   param procId : 18(A6)  size 4
        ;   param behind : 14(A6)  size 4
        ;   param goAwayFlag : 12(A6)  size 2
        ;   param refCon : 8(A6)  size 4
LBL_174:
        LINK A6,#-2100
        JSR 2650(A5)
        CLR.L -(A7)
        MOVE.L 32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 22(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L 18(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 12(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A913  ; UiNewWindowRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_583
LBL_583:
        UNLK A6
        RTS
        ; func UiNewMenu  (JT slot 176)
        ;   param menuId : 12(A6)  size 4
        ;   param menuTitle : 8(A6)  size 4
LBL_175:
        LINK A6,#-2100
        JSR 2650(A5)
        CLR.L -(A7)
        MOVE.L 12(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A931  ; UiNewMenuRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_584
LBL_584:
        UNLK A6
        RTS
        ; func aeQuitHandler  (JT slot 177)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_176:
        LINK A6,#-2100
        BSR.W LBL_191
        MOVEQ #0,D0
        BRA.W LBL_585
LBL_585:
        UNLK A6
        RTS
        ; func aeOappHandler  (JT slot 178)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_177:
        LINK A6,#-2100
        MOVEQ #0,D0
        BRA.W LBL_586
LBL_586:
        UNLK A6
        RTS
        ; func nat_UiLaunchReal  (JT slot 179)
        ;   local junk : -4(A6)  size 4
LBL_178:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_588
        CLR.W -(A7)
        MOVE.L #1634039412,D0
        MOVE.L D0,-(A7)
        MOVE.L #1903520116,D0
        MOVE.L D0,-(A7)
        LEA 4810(A5),A0
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
        LEA 4818(A5),A0
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
LBL_588:
        JSR 4802(A5)
LBL_587:
        UNLK A6
        RTS
        ; func nat_UiAEProcessEvent  (JT slot 180)
        ;   param evBuf : 8(A6)  size 4
        ;   local junk : -4(A6)  size 4
LBL_179:
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
LBL_589:
        UNLK A6
        RTS
        ; func rtUiIsOurs  (JT slot 181)
        ;   param wp : 8(A6)  size 4
LBL_180:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_591
        MOVEQ #0,D0
        BRA.W LBL_590
LBL_591:
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
        BRA.W LBL_590
LBL_590:
        UNLK A6
        RTS
        ; func rtUiWinstOf  (JT slot 182)
        ;   param wp : 8(A6)  size 4
LBL_181:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_180
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_593
        MOVEQ #0,D0
        BRA.W LBL_592
LBL_593:
        CLR.L -(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        BRA.W LBL_592
LBL_592:
        UNLK A6
        RTS
        ; func rtUiFront  (JT slot 183)
        ;   param winIdx : 8(A6)  size 4
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
LBL_182:
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
LBL_595:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_596
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
        BEQ.W LBL_597
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
        BEQ.W LBL_598
        MOVE.L -8(A6),D0
        BRA.W LBL_594
LBL_598:
LBL_597:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_595
LBL_596:
        MOVEQ #0,D0
        BRA.W LBL_594
LBL_594:
        UNLK A6
        RTS
        ; func rtUiState  (JT slot 184)
        ;   param instV : 8(A6)  size 4
LBL_183:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_599
LBL_599:
        UNLK A6
        RTS
        ; func rtUiSetTitle  (JT slot 185)
        ;   param instV : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_184:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91A  ; UiSetWTitle
LBL_600:
        UNLK A6
        RTS
        ; func rtUiGetTitle  (JT slot 186)
        ;   param instV : 12(A6)  size 4
        ;   param dst255 : 8(A6)  size 4
LBL_185:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A919  ; UiGetWTitle
LBL_601:
        UNLK A6
        RTS
        ; func rtUiNaturalSize  (JT slot 187)
        ;   param winIdx : 16(A6)  size 4
        ;   param outW : 12(A6)  size 4
        ;   param outH : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local maxRight : -12(A6)  size 4
        ;   local prevLeft : -16(A6)  size 4
        ;   local prevRight : -20(A6)  size 4
        ;   local prevBottom : -24(A6)  size 4
        ;   local kind : -28(A6)  size 4
        ;   local atKind : -32(A6)  size 4
        ;   local x : -36(A6)  size 4
        ;   local y : -40(A6)  size 4
        ;   local ww : -44(A6)  size 4
        ;   local hh : -48(A6)  size 4
        ;   local right : -52(A6)  size 4
        ;   local __switch1 : -56(A6)  size 4
LBL_186:
        LINK A6,#-2156
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
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_93
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_603:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_604
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_104
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 2018(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-48(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-56(A6)
        MOVE.L -56(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_605
        MOVE.L -20(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_606
LBL_605:
        MOVE.L -56(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_607
        MOVE.L -16(A6),D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_608
LBL_607:
        MOVE.L -56(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_609
        MOVEQ #12,D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_610
LBL_609:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_105
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
LBL_610:
LBL_608:
LBL_606:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_106
        ADDQ.L #8,A7
        TST.L D0
        BNE.W LBL_611
        MOVE.L -32(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_612
LBL_611:
        MOVEQ #1,D0
LBL_612:
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_614
LBL_613:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_107
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
LBL_614:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_108
        ADDQ.L #8,A7
        TST.L D0
        BNE.W LBL_615
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        BRA.W LBL_616
LBL_615:
        MOVEQ #1,D0
LBL_616:
        TST.L D0
        BEQ.W LBL_617
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 2026(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        BRA.W LBL_618
LBL_617:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_109
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_619
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 2026(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        BRA.W LBL_620
LBL_619:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_109
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
LBL_620:
LBL_618:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_621
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 2018(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-48(A6)
LBL_621:
        MOVE.L -36(A6),D1
        MOVE.L -44(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
        MOVE.L -52(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_622
        MOVE.L -52(A6),D0
        MOVE.L D0,-12(A6)
LBL_622:
        MOVE.L -36(A6),D0
        MOVE.L D0,-16(A6)
        MOVE.L -52(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -40(A6),D1
        MOVE.L -48(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_603
LBL_604:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_602:
        UNLK A6
        RTS
        ; func rtUiOpen  (JT slot 188)
        ;   param winIdx : 8(A6)  size 4
        ;   local instH : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local stateSize : -16(A6)  size 4
        ;   local nWidgets : -20(A6)  size 4
        ;   local screenBoundsSlot : -24(A6)  size 4
        ;   local screenLeft : -28(A6)  size 4
        ;   local screenTop : -32(A6)  size 4
        ;   local screenRight : -36(A6)  size 4
        ;   local screenBottom : -40(A6)  size 4
        ;   local screenW : -44(A6)  size 4
        ;   local screenH : -48(A6)  size 4
        ;   local reqW : -52(A6)  size 4
        ;   local reqH : -56(A6)  size 4
        ;   local reqWSlot : -60(A6)  size 4
        ;   local reqHSlot : -64(A6)  size 4
        ;   local left : -68(A6)  size 4
        ;   local top : -72(A6)  size 4
        ;   local ww : -76(A6)  size 4
        ;   local hh : -80(A6)  size 4
        ;   local boundsRect : -84(A6)  size 4
        ;   local procId : -88(A6)  size 4
        ;   local titlePtr : -92(A6)  size 4
        ;   local i : -96(A6)  size 4
        ;   local savedPort : -100(A6)  size 4
        ;   local formOff : -104(A6)  size 4
LBL_187:
        LINK A6,#-2204
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
        MOVEQ #120,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_95
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_625
LBL_624:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_625:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_93
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #8,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #44,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 52(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 52(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 60(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 60(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 64(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 68(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 68(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 72(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 84(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 84(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 88(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 92(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 92(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 100(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 100(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 104(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_626:
        MOVE.L -96(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 1946(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 72(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L -96(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_626
LBL_627:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
        MOVE.L D0,-52(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVE.L -52(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_628
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-60(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_186
        ADDA.W #12,A7
        MOVE.L -60(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-52(A6)
        MOVE.L -64(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-56(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_628:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 4570(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -24(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -24(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-36(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -36(A6),D1
        MOVE.L -28(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-44(A6)
        MOVE.L -40(A6),D1
        MOVE.L -32(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-48(A6)
        MOVE.L -44(A6),D1
        MOVE.L -52(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_248
        MOVE.L D0,-68(A6)
        MOVE.L -68(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_629
        MOVEQ #4,D0
        MOVE.L D0,-68(A6)
LBL_629:
        MOVE.L -52(A6),D0
        MOVE.L D0,-76(A6)
        MOVE.L -76(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D1
        MOVE.L -68(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_630
        MOVE.L -44(A6),D1
        MOVE.L -68(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-76(A6)
        MOVE.L -76(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_631
        MOVEQ #1,D0
        MOVE.L D0,-76(A6)
LBL_631:
LBL_630:
        MOVEQ #44,D0
        MOVE.L D0,-72(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,-80(A6)
        MOVE.L -72(A6),D1
        MOVE.L -80(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -48(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_632
        MOVEQ #20,D1
        MOVEQ #19,D0
        ADD.L D1,D0
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D1
        MOVE.L -80(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -48(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_633
        MOVE.L -48(A6),D1
        MOVE.L -72(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_634
        MOVEQ #1,D0
        MOVE.L D0,-80(A6)
LBL_634:
LBL_633:
LBL_632:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-84(A6)
        MOVE.L -84(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -68(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -68(A6),D1
        MOVE.L -76(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -72(A6),D1
        MOVE.L -80(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #4,A7
        MOVE.L D0,-104(A6)
        MOVE.L -104(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_635
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_637
        MOVEQ #5,D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_638
LBL_637:
        MOVEQ #4,D0
        MOVE.L D0,-88(A6)
LBL_638:
        BRA.W LBL_636
LBL_635:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_639
        MOVEQ #8,D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_640
LBL_639:
        MOVEQ #4,D0
        MOVE.L D0,-88(A6)
LBL_640:
LBL_636:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
        MOVE.L D0,-92(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -84(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_174
        ADDA.W #28,A7
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -84(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_641
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_641:
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #108,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #2001,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A918  ; UiSetWRefCon
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2050(A5)
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2042(A5)
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2170(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_642:
        MOVE.L -96(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_643
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_644
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 2602(A5)
        ADDQ.L #8,A7
LBL_644:
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_642
LBL_643:
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_645:
        MOVE.L -96(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_646
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_647
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_648
LBL_647:
        MOVEQ #1,D0
LBL_648:
        TST.L D0
        BEQ.W LBL_649
        JSR 2010(A5)
        MOVE.L D0,-100(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 2346(A5)
        ADDQ.L #8,A7
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -20(A6),D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_650
LBL_649:
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
LBL_650:
        BRA.W LBL_645
LBL_646:
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A915  ; UiShowWindow
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A91F  ; UiSelectWindow
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2754(A5)
        ADDQ.L #8,A7
        BSR.W LBL_206
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 4754(A5)
        ADDA.W #20,A7
        MOVE.L -8(A6),D0
        BRA.W LBL_623
LBL_623:
        UNLK A6
        RTS
        ; func rtUiTeardownWindow  (JT slot 189)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local lh : -20(A6)  size 4
        ;   local ldefH : -24(A6)  size 4
LBL_188:
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
        BSR.W LBL_93
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_652:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_653
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_654
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
LBL_654:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_652
LBL_653:
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
        JSR 2762(A5)
        ADDQ.L #8,A7
        BSR.W LBL_206
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_235(PC),A0
        MOVE.L A0,-(A7)
        JSR 2770(A5)
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
        JSR 4754(A5)
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
        BEQ.W LBL_655
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4786(A5)
        ADDQ.L #8,A7
LBL_655:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_656:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_657
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1946(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 2154(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1962(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_658
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1962(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9CD  ; UiTEDispose
LBL_658:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2434(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_659
        MOVE.L #1000,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2434(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A932  ; UiDisposeMenu
LBL_659:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_656
LBL_657:
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
        BEQ.W LBL_660
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
LBL_660:
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
LBL_651:
        UNLK A6
        RTS
        ; func rtUiCloseInternal  (JT slot 190)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local cancelSlot : -12(A6)  size 4
        ;   local cancelled : -14(A6)  size 2
LBL_189:
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
        BEQ.W LBL_662
        MOVE.L 8(A6),D1
        MOVE.L -128(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_663
LBL_662:
        MOVEQ #0,D0
LBL_663:
        TST.L D0
        BEQ.W LBL_664
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3194(A5)
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_661
LBL_664:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_236(PC),A0
        MOVE.L A0,-(A7)
        JSR 2770(A5)
        ADDQ.L #8,A7
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
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
        JSR 4754(A5)
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
        BEQ.W LBL_665
        MOVEQ #0,D0
        BRA.W LBL_661
LBL_665:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_188
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_661
LBL_661:
        UNLK A6
        RTS
        ; func rtUiClose  (JT slot 191)
        ;   param instV : 8(A6)  size 4
        ;   local ok : -2(A6)  size 2
LBL_190:
        LINK A6,#-2102
        MOVEQ #0,D0
        MOVE.B D0,-2(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_189
        ADDQ.L #4,A7
        MOVE.B D0,-2(A6)
LBL_666:
        UNLK A6
        RTS
        ; func rtUiQuit  (JT slot 192)
        ;   local wp : -4(A6)  size 4
        ;   local next : -8(A6)  size 4
        ;   local inst : -12(A6)  size 4
LBL_191:
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
LBL_668:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_669
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_180
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_670
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_189
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_671
        BRA.W LBL_667
LBL_671:
LBL_670:
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_668
LBL_669:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 4554(A5)
        ADDQ.L #4,A7
LBL_667:
        UNLK A6
        RTS
        ; func rtUiGlobalToLocalPt  (JT slot 193)
        ;   param pt : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local result : -8(A6)  size 4
LBL_192:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A871  ; UiGlobalToLocal
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        BRA.W LBL_672
LBL_672:
        UNLK A6
        RTS
        ; func rtUiGetMousePt  (JT slot 194)
        ;   local slot : -4(A6)  size 4
        ;   local v : -8(A6)  size 4
LBL_193:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A972  ; UiGetMouse
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        BRA.W LBL_673
LBL_673:
        UNLK A6
        RTS
        ; func rtUiHiWord  (JT slot 195)
        ;   param v : 8(A6)  size 4
LBL_194:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        BRA.W LBL_674
LBL_674:
        UNLK A6
        RTS
        ; func rtUiLoWord  (JT slot 196)
        ;   param v : 8(A6)  size 4
LBL_195:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        BRA.W LBL_675
LBL_675:
        UNLK A6
        RTS
        ; func rtUiAboutPrefixPtr  (JT slot 197)
        ;   local p : -4(A6)  size 4
LBL_196:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #7,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #6,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #98,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        BRA.W LBL_676
LBL_676:
        UNLK A6
        RTS
        ; func rtUiEmptyPStrGet  (JT slot 198)
LBL_197:
        LINK A6,#-2100
        MOVE.L -38(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_678
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-38(A5)
        MOVE.L -38(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_678:
        MOVE.L -38(A5),D0
        BRA.W LBL_677
LBL_677:
        UNLK A6
        RTS
        ; func rtUiBuildAppleMenu  (JT slot 199)
        ;   local titleBuf : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local prefix : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local appName : -20(A6)  size 4
        ;   local appNameLen : -24(A6)  size 4
LBL_198:
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
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #20,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_175
        ADDQ.L #8,A7
        MOVE.L D0,-20(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BSR.W LBL_135
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_680
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_681
LBL_680:
        MOVEQ #0,D0
LBL_681:
        TST.L D0
        BEQ.W LBL_682
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L #264,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        BSR.W LBL_196
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -16(A6),D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #201,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A933  ; UiAppendMenu
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_228(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        BRA.W LBL_683
LBL_682:
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_237(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
LBL_683:
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1146246738,D0
        MOVE.L D0,-(A7)
        DC.W $A94D  ; UiAppendResMenu
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A935  ; UiInsertMenu
LBL_679:
        UNLK A6
        RTS
        ; func rtUiAboutParam  (JT slot 200)
        ;   param p : 8(A6)  size 4
LBL_199:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_685
        BSR.W LBL_197
        BRA.W LBL_684
LBL_685:
        MOVE.L 8(A6),D0
        BRA.W LBL_684
LBL_684:
        UNLK A6
        RTS
        ; func rtUiAboutAlert  (JT slot 201)
LBL_200:
        LINK A6,#-2100
        BSR.W LBL_135
        MOVE.L D0,-(A7)
        BSR.W LBL_199
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_137
        MOVE.L D0,-(A7)
        BSR.W LBL_199
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_139
        MOVE.L D0,-(A7)
        BSR.W LBL_199
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_141
        MOVE.L D0,-(A7)
        BSR.W LBL_199
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        DC.W $A98B  ; UiParamText
        CLR.W -(A7)
        MOVE.L #129,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A987  ; UiNoteAlert
        MOVE.W (A7)+,D0
        EXT.L D0
LBL_686:
        UNLK A6
        RTS
        ; func rtUiAppleSelect  (JT slot 202)
        ;   param itemNum : 8(A6)  size 4
        ;   local empty : -4(A6)  size 4
        ;   local itemNameBuf : -8(A6)  size 4
LBL_201:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_688
        CLR.L D0
        MOVE.B -48(A5),D0
        TST.L D0
        BEQ.W LBL_689
        JSR 2834(A5)
        BRA.W LBL_687
LBL_689:
        BSR.W LBL_133
        TST.L D0
        BEQ.W LBL_692
        BSR.W LBL_135
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_693
LBL_692:
        MOVEQ #0,D0
LBL_693:
        TST.L D0
        BEQ.W LBL_690
        BSR.W LBL_135
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_691
LBL_690:
        MOVEQ #0,D0
LBL_691:
        TST.L D0
        BEQ.W LBL_694
        BSR.W LBL_200
        BRA.W LBL_695
LBL_694:
        BSR.W LBL_197
        MOVE.L D0,-4(A6)
        MOVE.L #2320,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A98B  ; UiParamText
        CLR.W -(A7)
        MOVE.L #128,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A987  ; UiNoteAlert
        MOVE.W (A7)+,D0
        EXT.L D0
LBL_695:
        BRA.W LBL_687
LBL_688:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A946  ; UiGetMenuItemText
        CLR.W -(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9B6  ; UiOpenDeskAcc
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_687:
        UNLK A6
        RTS
        ; func rtUiBuildMenus  (JT slot 203)
        ;   local nMenus : -4(A6)  size 4
        ;   local nWins : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local j : -16(A6)  size 4
        ;   local mh : -20(A6)  size 4
        ;   local nItems : -24(A6)  size 4
        ;   local buf : -28(A6)  size 4
        ;   local n : -32(A6)  size 4
        ;   local key : -36(A6)  size 4
LBL_202:
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
        BSR.W LBL_76
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A5)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_697
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_172
        ADDQ.L #4,A7
        MOVE.L D0,-4(A5)
        BRA.W LBL_698
LBL_697:
        MOVEQ #0,D0
        MOVE.L D0,-4(A5)
LBL_698:
        MOVEQ #0,D0
        MOVE.L D0,-12(A5)
        MOVEQ #0,D0
        MOVE.L D0,-16(A5)
        BSR.W LBL_74
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_699:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_700
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_97
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-12(A5)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_699
LBL_700:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_701:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_702
        MOVEQ #2,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_175
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_703
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_238(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_228(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_239(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_240(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_241(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_242(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A93A  ; UiDisableItem
        MOVE.L -24(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_705
        MOVE.L -12(A6),D0
        MOVE.L D0,-24(A5)
LBL_705:
        BRA.W LBL_704
LBL_703:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_706:
        MOVE.L -16(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_707
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_123
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_708
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_228(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        BRA.W LBL_709
LBL_708:
        MOVE.L #258,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_121
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDQ.L #8,A7
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_122
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_710
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -32(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #47,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -28(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -32(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_710:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A933  ; UiAppendMenu
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_709:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_706
LBL_707:
LBL_704:
        MOVE.L -12(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D1
        MOVE.L -12(A6),D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_711
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A935  ; UiInsertMenu
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D1
        MOVE.L -12(A6),D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-16(A5)
LBL_711:
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_701
LBL_702:
        DC.W $A937  ; UiDrawMenuBar
LBL_696:
        UNLK A6
        RTS
        ; func rtUiSyncMenuBar  (JT slot 204)
        ;   local inst : -4(A6)  size 4
        ;   local target : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local bit : -16(A6)  size 4
        ;   local mh : -20(A6)  size 4
LBL_203:
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
        BNE.W LBL_713
        MOVE.L -12(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_714
LBL_713:
        MOVEQ #1,D0
LBL_714:
        TST.L D0
        BEQ.W LBL_715
        BRA.W LBL_712
LBL_715:
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
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_716
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_97
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-8(A6)
LBL_716:
        MOVE.L -8(A6),D1
        MOVE.L -16(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_717
        BRA.W LBL_712
LBL_717:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_718:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_719
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
        BEQ.W LBL_720
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_721
LBL_720:
        MOVEQ #0,D0
LBL_721:
        TST.L D0
        BEQ.W LBL_722
        MOVEQ #2,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
LBL_722:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_718
LBL_719:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_723:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_724
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
        BEQ.W LBL_725
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_726
LBL_725:
        MOVEQ #0,D0
LBL_726:
        TST.L D0
        BEQ.W LBL_727
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
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
LBL_727:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_723
LBL_724:
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A5)
        DC.W $A937  ; UiDrawMenuBar
LBL_712:
        UNLK A6
        RTS
        ; func rtUiMenuEnable  (JT slot 205)
        ;   param menuIdx : 14(A6)  size 4
        ;   param itemIdx : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local mh : -4(A6)  size 4
LBL_204:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_731
        MOVE.L 14(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_732
LBL_731:
        MOVEQ #1,D0
LBL_732:
        TST.L D0
        BNE.W LBL_729
        MOVE.L 14(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_730
LBL_729:
        MOVEQ #1,D0
LBL_730:
        TST.L D0
        BEQ.W LBL_733
        BRA.W LBL_728
LBL_733:
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
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
        BEQ.W LBL_734
        BRA.W LBL_728
LBL_734:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_735
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A939  ; UiEnableItem
        BRA.W LBL_736
LBL_735:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A93A  ; UiDisableItem
LBL_736:
LBL_728:
        UNLK A6
        RTS
        ; func rtUiMenuRecomputeDim  (JT slot 206)
        ;   local k : -4(A6)  size 4
        ;   local nMh : -8(A6)  size 4
        ;   local scopeWinIdx : -12(A6)  size 4
        ;   local enable : -14(A6)  size 2
        ;   local front : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
LBL_205:
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
        BSR.W LBL_78
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_738:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_739
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_127
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
        BEQ.W LBL_740
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_182
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_125
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_126
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_204
        ADDA.W #10,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        JSR 2802(A5)
        ADDQ.L #6,A7
LBL_740:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_738
LBL_739:
        MOVE.L -24(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_741
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_742
        MOVE.L -18(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_743
LBL_742:
        MOVEQ #0,D0
LBL_743:
        MOVE.B D0,-14(A6)
        MOVEQ #2,D0
        MOVE.L D0,-22(A6)
LBL_744:
        MOVE.L -22(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_745
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_204
        ADDA.W #10,A7
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        BRA.W LBL_744
LBL_745:
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        JSR 2810(A5)
        ADDQ.L #2,A7
LBL_741:
        JSR 2818(A5)
LBL_737:
        UNLK A6
        RTS
        ; func rtUiAfterFrontChange  (JT slot 207)
LBL_206:
        LINK A6,#-2100
        BSR.W LBL_203
        BSR.W LBL_205
        JSR 2826(A5)
LBL_746:
        UNLK A6
        RTS
        ; func rtUiStdEditDispatch  (JT slot 208)
        ;   param itemIdx : 8(A6)  size 4
        ;   local front : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local te : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
LBL_207:
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
        BSR.W LBL_180
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_748
        BRA.W LBL_747
LBL_748:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_749
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_750
LBL_749:
        MOVEQ #1,D0
LBL_750:
        TST.L D0
        BEQ.W LBL_751
        BRA.W LBL_747
LBL_751:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_752
        BRA.W LBL_747
LBL_752:
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
        BEQ.W LBL_753
        BRA.W LBL_747
LBL_753:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1962(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_754
        BRA.W LBL_747
LBL_754:
        JSR 2010(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_755
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D6  ; UiTECut
        CLR.L -(A7)
        DC.W $A9FC  ; UiZeroScrap
        MOVE.L (A7)+,D0
        JSR 2282(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        JSR 2330(A5)
        ADDA.W #10,A7
        BRA.W LBL_756
LBL_755:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_757
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D5  ; UiTECopy
        CLR.L -(A7)
        DC.W $A9FC  ; UiZeroScrap
        MOVE.L (A7)+,D0
        JSR 2282(A5)
        BRA.W LBL_758
LBL_757:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_759
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2386(A5)
        ADDQ.L #8,A7
        BRA.W LBL_760
LBL_759:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_761
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D7  ; UiTEDelete
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        JSR 2330(A5)
        ADDA.W #10,A7
LBL_761:
LBL_760:
LBL_758:
LBL_756:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_747:
        UNLK A6
        RTS
        ; func rtUiMenuDispatch  (JT slot 209)
        ;   param result : 8(A6)  size 4
        ;   local menuID : -4(A6)  size 4
        ;   local itemNum : -8(A6)  size 4
        ;   local menuIdx : -12(A6)  size 4
        ;   local itemIdx : -16(A6)  size 4
        ;   local k : -20(A6)  size 4
        ;   local nMh : -24(A6)  size 4
        ;   local front : -28(A6)  size 4
        ;   local scopeWinIdx : -32(A6)  size 4
        ;   local skip : -34(A6)  size 2
LBL_208:
        LINK A6,#-2134
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
        MOVE.B D0,-34(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_194
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_195
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A938  ; UiHiliteMenu
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_763
        BRA.W LBL_762
LBL_763:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_764
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_201
        ADDQ.L #4,A7
        BRA.W LBL_762
LBL_764:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D1
        MOVE.L -24(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_765
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_207
        ADDQ.L #4,A7
        BRA.W LBL_762
LBL_765:
        BSR.W LBL_78
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_766:
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_767
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_125
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_768
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_126
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_769
LBL_768:
        MOVEQ #0,D0
LBL_769:
        TST.L D0
        BEQ.W LBL_770
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_127
        ADDQ.L #4,A7
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.B D0,-34(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_771
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_182
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_773
        MOVEQ #1,D0
        MOVE.B D0,-34(A6)
LBL_773:
        BRA.W LBL_772
LBL_771:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_772:
        CLR.L D0
        MOVE.B -34(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_774
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 2786(A5)
        ADDQ.L #4,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 4770(A5)
        ADDQ.L #8,A7
LBL_774:
LBL_770:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_766
LBL_767:
LBL_762:
        UNLK A6
        RTS
        ; func rtUiBuildEvery  (JT slot 210)
        ;   local n : -4(A6)  size 4
        ;   local now : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_209:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        BSR.W LBL_80
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-34(A5)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_776
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L D0,-(A7)
        BSR.W LBL_172
        ADDQ.L #4,A7
        MOVE.L D0,-30(A5)
        BRA.W LBL_777
LBL_776:
        MOVEQ #0,D0
        MOVE.L D0,-30(A5)
LBL_777:
        LEA LBL_246(PC),A0
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
        BEQ.W LBL_778
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_779
LBL_778:
        CLR.L -(A7)
        DC.W $A975  ; UiTickCount
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
LBL_779:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_780:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_781
        MOVE.L -30(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_132
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_780
LBL_781:
LBL_775:
        UNLK A6
        RTS
        ; func rtUiEveryPump  (JT slot 211)
        ;   local now : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local due : -12(A6)  size 4
LBL_210:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B -48(A5),D0
        TST.L D0
        BEQ.W LBL_783
        JSR 3034(A5)
        BRA.W LBL_782
LBL_783:
        MOVE.L -30(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_784
        BRA.W LBL_782
LBL_784:
        CLR.L -(A7)
        DC.W $A975  ; UiTickCount
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_785:
        MOVE.L -8(A6),D1
        MOVE.L -34(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_786
        MOVE.L -30(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D1
        MOVE.L -12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_787
        MOVE.L -30(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_247
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_132
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2794(A5)
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4778(A5)
        ADDQ.L #4,A7
LBL_787:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_785
LBL_786:
LBL_782:
        UNLK A6
        RTS
        ; func rtUiStartup  (JT slot 212)
        ;   local resp : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
LBL_211:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        JSR 4562(A5)
        MOVE.L #65535,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A032  ; UiFlushEvents
        MOVE.L #1937339254,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A1AD  ; UiGestaltErr
        EXT.L D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_789
        MOVE.L #1937339254,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A1AD  ; UiGestaltValue
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_790
LBL_789:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_790:
        MOVE.L -4(A6),D1
        MOVE.L #1792,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_791
        MOVE.L -4(A6),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_792
LBL_791:
        MOVEQ #0,D0
LBL_792:
        MOVE.B D0,-26(A5)
        BSR.W LBL_198
        BSR.W LBL_202
        JSR 2738(A5)
        BSR.W LBL_205
        BSR.W LBL_209
LBL_788:
        UNLK A6
        RTS
        ; func rtUiFlushAllBuffered  (JT slot 213)
        ;   local wp : -4(A6)  size 4
LBL_212:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
LBL_794:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_795
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
        BEQ.W LBL_796
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.B D0,-(A7)
        JSR 2178(A5)
        ADDQ.L #6,A7
LBL_796:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_794
LBL_795:
LBL_793:
        UNLK A6
        RTS
        ; func rtUiDrawDefaultOutline  (JT slot 214)
        ;   param box : 8(A6)  size 4
        ;   local r : -4(A6)  size 4
LBL_213:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        NEG.L D0
        MOVE.W D0,-(A7)
        MOVEQ #4,D0
        NEG.L D0
        MOVE.W D0,-(A7)
        DC.W $A8A9  ; UiInsetRect
        MOVEQ #3,D0
        MOVE.W D0,-(A7)
        MOVEQ #3,D0
        MOVE.W D0,-(A7)
        DC.W $A89B  ; UiPenSize
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.W D0,-(A7)
        MOVEQ #16,D0
        MOVE.W D0,-(A7)
        DC.W $A8B0  ; UiFrameRoundRect
        DC.W $A89E  ; UiPenNormal
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_797:
        UNLK A6
        RTS
        ; func rtUiHandleUpdate  (JT slot 215)
        ;   param wp : 8(A6)  size 4
        ;   local inst : -4(A6)  size 4
        ;   local w : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local kind : -20(A6)  size 4
        ;   local flags : -24(A6)  size 4
        ;   local s : -28(A6)  size 4
        ;   local corner : -32(A6)  size 4
        ;   local saveClip : -36(A6)  size 4
        ;   local te : -40(A6)  size 4
        ;   local teMp : -44(A6)  size 4
        ;   local frame : -48(A6)  size 4
        ;   local labelRect : -52(A6)  size 4
        ;   local box : -56(A6)  size 4
        ;   local itemText : -60(A6)  size 4
        ;   local textRect : -64(A6)  size 4
        ;   local popupH : -68(A6)  size 4
        ;   local cx : -72(A6)  size 4
        ;   local cy : -76(A6)  size 4
        ;   local pk : -80(A6)  size 4
        ;   local lh : -84(A6)  size 4
        ;   local lhMp : -88(A6)  size 4
        ;   local tableOff : -92(A6)  size 4
        ;   local colsOff : -96(A6)  size 4
        ;   local nCols : -100(A6)  size 4
        ;   local fillW : -104(A6)  size 4
        ;   local hx : -108(A6)  size 4
        ;   local headerRect : -112(A6)  size 4
        ;   local ck : -116(A6)  size 4
LBL_214:
        LINK A6,#-2216
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A922  ; UiBeginUpdate
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_799
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A969  ; UiDrawControls
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_800
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #15,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #15,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        JSR 1906(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87A  ; UiGetClip
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A87B  ; UiClipRect
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A904  ; UiDrawGrowIcon
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A879  ; UiSetClip
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8D9  ; UiDisposeRgn
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_800:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_93
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_801:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_802
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_803
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1938(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A9CE  ; UiTextBox
        BRA.W LBL_804
LBL_803:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_805
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_111
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_807
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_213
        ADDQ.L #4,A7
LBL_807:
        BRA.W LBL_806
LBL_805:
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_808
        MOVE.L -20(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_809
LBL_808:
        MOVEQ #1,D0
LBL_809:
        TST.L D0
        BEQ.W LBL_810
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1962(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_812
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-48(A6)
        MOVE.L -40(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L -44(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -48(A6),D0
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
        MOVE.L -48(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_813
        MOVE.L -48(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_813:
        MOVE.L -48(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_814
        MOVE.L -48(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_814:
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A1  ; UiFrameRect
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -44(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D3  ; UiTEUpdate
LBL_812:
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_815
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1938(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_816
LBL_815:
        MOVEQ #0,D0
LBL_816:
        TST.L D0
        BEQ.W LBL_817
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-52(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -52(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1938(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A9CE  ; UiTextBox
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_817:
        BRA.W LBL_811
LBL_810:
        MOVE.L -20(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_818
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_819
LBL_818:
        MOVEQ #0,D0
LBL_819:
        TST.L D0
        BEQ.W LBL_820
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1938(A5)
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
        BEQ.W LBL_822
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-52(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -52(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #70,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1938(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A9CE  ; UiTextBox
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_822:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2466(A5)
        ADDA.W #12,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A1  ; UiFrameRect
        MOVE.L -56(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -56(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -56(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -56(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A891  ; UiLineTo
        MOVE.L -56(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A891  ; UiLineTo
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2434(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
        MOVE.L -68(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_823
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-60(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A946  ; UiGetMenuItemText
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.W D0,-(A7)
        MOVEQ #2,D0
        MOVE.W D0,-(A7)
        DC.W $A8A9  ; UiInsetRect
        MOVE.L -64(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D1
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
        MOVE.L -60(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A9CE  ; UiTextBox
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -56(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-72(A6)
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_248
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-76(A6)
        MOVEQ #0,D0
        MOVE.L D0,-80(A6)
LBL_824:
        MOVE.L -80(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_825
        MOVE.L -72(A6),D1
        MOVE.L -80(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -76(A6),D1
        MOVE.L -80(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -72(A6),D1
        MOVE.L -80(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -76(A6),D1
        MOVE.L -80(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A891  ; UiLineTo
        MOVE.L -80(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-80(A6)
        BRA.W LBL_824
LBL_825:
LBL_823:
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_821
LBL_820:
        MOVE.L -20(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_826
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_827
LBL_826:
        MOVEQ #0,D0
LBL_827:
        TST.L D0
        BEQ.W LBL_828
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L D0,-92(A6)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_152
        ADDQ.L #4,A7
        MOVE.L D0,-96(A6)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_151
        ADDQ.L #4,A7
        MOVE.L D0,-100(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1930(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-112(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -112(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -84(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-88(A6)
        MOVE.L -112(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -88(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A1  ; UiFrameRect
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -88(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -88(A6),D1
        MOVEQ #0,D0
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
        MOVE.L D0,-(A7)
        JSR 2474(A5)
        ADDA.W #12,A7
        MOVE.L D0,-104(A6)
        MOVE.L -88(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-108(A6)
        MOVEQ #0,D0
        MOVE.L D0,-116(A6)
LBL_829:
        MOVE.L -116(A6),D1
        MOVE.L -100(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_830
        MOVE.L -108(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -112(A6),D1
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
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_155
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_155
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A885  ; UiDrawText
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_157
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_831
        MOVE.L -108(A6),D1
        MOVE.L -104(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-108(A6)
        BRA.W LBL_832
LBL_831:
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_156
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-108(A6)
LBL_832:
        MOVE.L -116(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-116(A6)
        BRA.W LBL_829
LBL_830:
        MOVE.L -56(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -112(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A893  ; UiMoveTo
        MOVE.L -56(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L -112(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A891  ; UiLineTo
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -84(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #100,-(A7)
        DC.W $A9E7  ; UiLUpdate
        MOVE.L -112(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_828:
LBL_821:
LBL_811:
LBL_806:
LBL_804:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_801
LBL_802:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        JSR 2178(A5)
        ADDQ.L #6,A7
LBL_799:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A923  ; UiEndUpdate
LBL_798:
        UNLK A6
        RTS
        ; func rtUiHandleActivate  (JT slot 216)
        ;   param wp : 10(A6)  size 4
        ;   param activating : 8(A6)  size 2
        ;   local inst : -4(A6)  size 4
        ;   local w : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local ctrl : -20(A6)  size 4
        ;   local hb : -24(A6)  size 4
        ;   local lh : -28(A6)  size 4
        ;   local te : -32(A6)  size 4
        ;   local enable : -34(A6)  size 2
LBL_215:
        LINK A6,#-2134
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
        MOVE.B D0,-34(A6)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_834
        BRA.W LBL_833
LBL_834:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_93
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_835:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_836
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_837
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_838
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1994(A5)
        ADDQ.L #8,A7
        BRA.W LBL_839
LBL_838:
        MOVEQ #0,D0
LBL_839:
        MOVE.B D0,-34(A6)
        CLR.L D0
        MOVE.B -34(A6),D0
        TST.L D0
        BEQ.W LBL_840
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
        BRA.W LBL_841
LBL_840:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
LBL_841:
LBL_837:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1978(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_842
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_843
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
        BRA.W LBL_844
LBL_843:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
LBL_844:
LBL_842:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_845
        CLR.L D0
        MOVE.B 8(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #0,-(A7)
        DC.W $A9E7  ; UiLActivate
LBL_845:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_835
LBL_836:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_846
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1962(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_847
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_848
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D8  ; UiTEActivate
        BRA.W LBL_849
LBL_848:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D9  ; UiTEDeactivate
LBL_849:
LBL_847:
LBL_846:
LBL_833:
        UNLK A6
        RTS
        ; func rtUiInvalGrowCorner  (JT slot 217)
        ;   param wp : 8(A6)  size 4
        ;   local r : -4(A6)  size 4
LBL_216:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #15,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #15,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.W D0,-(A7)
        DC.W $A8A7  ; UiSetRect
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A928  ; UiInvalRect
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_850:
        UNLK A6
        RTS
        ; func rtUiApplyResize  (JT slot 218)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param newW : 12(A6)  size 4
        ;   param newH : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local savedPort : -8(A6)  size 4
LBL_217:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        JSR 2010(A5)
        MOVE.L D0,-8(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_216
        ADDQ.L #4,A7
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        DC.W $A91D  ; UiSizeWindow
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_216
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2042(A5)
        ADDQ.L #4,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2170(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_243(PC),A0
        MOVE.L A0,-(A7)
        JSR 2770(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 4754(A5)
        ADDA.W #20,A7
LBL_851:
        UNLK A6
        RTS
        ; func rtUiHandleGrow  (JT slot 219)
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
LBL_218:
        LINK A6,#-2156
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_853
        BRA.W LBL_852
LBL_853:
        MOVE.L 16(A6),D1
        MOVEQ #118,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 4570(A5)
        ADDQ.L #4,A7
        MOVE.L -24(A6),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -24(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
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
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-36(A6)
        MOVE.L -32(A6),D1
        MOVE.L -20(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-40(A6)
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_854
        MOVEQ #1,D0
        MOVE.L D0,-36(A6)
LBL_854:
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_855
        MOVEQ #1,D0
        MOVE.L D0,-40(A6)
LBL_855:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_91
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_856
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_91
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        BRA.W LBL_857
LBL_856:
        MOVEQ #1,D0
        MOVE.L D0,-44(A6)
LBL_857:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_858
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #4,A7
        MOVE.L D0,-48(A6)
        BRA.W LBL_859
LBL_858:
        MOVEQ #1,D0
        MOVE.L D0,-48(A6)
LBL_859:
        MOVE.L -36(A6),D1
        MOVE.L -44(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_860
        MOVE.L -44(A6),D0
        MOVE.L D0,-36(A6)
LBL_860:
        MOVE.L -40(A6),D1
        MOVE.L -48(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_861
        MOVE.L -48(A6),D0
        MOVE.L D0,-40(A6)
LBL_861:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
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
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_862
        BRA.W LBL_852
LBL_862:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_195
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_194
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_217
        ADDA.W #16,A7
LBL_852:
        UNLK A6
        RTS
        ; func rtUiApplyZoom  (JT slot 220)
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
LBL_219:
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
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_864
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4570(A5)
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
        BSR.W LBL_171
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
        BEQ.W LBL_865
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
LBL_865:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_864:
        JSR 2010(A5)
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
        BSR.W LBL_217
        ADDA.W #16,A7
LBL_863:
        UNLK A6
        RTS
        ; func rtUiHandleZoom  (JT slot 221)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param wherePt : 12(A6)  size 4
        ;   param part : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_220:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_867
        BRA.W LBL_866
LBL_867:
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
        BEQ.W LBL_868
        BRA.W LBL_866
LBL_868:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_219
        ADDA.W #12,A7
LBL_866:
        UNLK A6
        RTS
        ; func rtAtDevPoll  (JT slot 222)
LBL_221:
        LINK A6,#-2100
LBL_869:
        UNLK A6
        RTS
LBL_247:
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
LBL_248:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_870
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_244(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_870:
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
        BPL.W LBL_871
        NEG.L D2
        MOVE.L #1,D4
LBL_871:
        CLR.L D5
        TST.L D3
        BPL.W LBL_872
        NEG.L D3
        MOVE.L #1,D5
LBL_872:
        CLR.L D6
        MOVE.W #31,D7
LBL_873:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_874
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_874:
        DBRA D7,LBL_873
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_875
        NEG.L D2
LBL_875:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_249:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_876
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_244(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_876:
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
        BPL.W LBL_877
        NEG.L D2
        MOVE.L #1,D4
LBL_877:
        CLR.L D5
        TST.L D3
        BPL.W LBL_878
        NEG.L D3
        MOVE.L #1,D5
LBL_878:
        CLR.L D6
        MOVE.W #31,D7
LBL_879:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_880
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_880:
        DBRA D7,LBL_879
        TST.L D4
        BEQ.W LBL_881
        NEG.L D6
LBL_881:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_250:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L A1,-(A7)
        MOVE.L -6650(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6646(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6642(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6638(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6634(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6630(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6626(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -7096(A5),D0
        MOVE.L D0,-4(A6)
LBL_882:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -7412(A5),D0
        MOVE.L D0,-4(A6)
LBL_883:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -7416(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -7420(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_244:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_222:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_223:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_224:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_225:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_226:
        DC.B $01
        DC.B $30
LBL_227:
        DC.B $00
        DC.B $00
LBL_228:
        DC.B $01
        DC.B $2D
LBL_229:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_230:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_231:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_232:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_233:
        DC.B $12
        DC.B $6D,$61,$70,$3A,$20,$69,$6E,$64,$65,$78,$20,$63,$6F,$72,$72,$75,$70,$74
        DC.B $00
LBL_234:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_235:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_236:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_237:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_238:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_239:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_240:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_241:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_242:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_243:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (116 bytes)
LBL_245:
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
        DC.B $60
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $60
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $60
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $60
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $65
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $F0
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
        DC.B $00
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
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $04
        DC.B $4D
        DC.B $61
        DC.B $69
        DC.B $6E
        DC.B $0B
        DC.B $41
        DC.B $74
        DC.B $61
        DC.B $6C
        DC.B $6B
        DC.B $43
        DC.B $6C
        DC.B $69
        DC.B $65
        DC.B $6E
        DC.B $74
        DC.B $00
        DC.B $00
        DC.B $00
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_246:
        DC.B $00
        DC.B $00
