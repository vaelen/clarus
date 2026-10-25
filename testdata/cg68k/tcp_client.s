LBL_228:
        ; startup (JT slot 0)
        ; globals (below A5, 7418 bytes total):
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
        ;   natCapture : -7098(A5)  size 1  type bool
        ;   natWlPb : -7102(A5)  size 4  type ptr
        ;   natWlBuf : -7106(A5)  size 4  type ptr
        ;   natWlName : -7110(A5)  size 4  type ptr
        ;   natWlVRef : -7114(A5)  size 4  type int
        ;   natWlLen : -7118(A5)  size 4  type int
        ;   natWlOpen : -7120(A5)  size 1  type bool
        ;   natTraceOn : -7122(A5)  size 1  type bool
        ;   natPanicBuf : -7126(A5)  size 4  type ptr
        ;   natEmptyStr : -7130(A5)  size 4  type ptr
        ;   natErrCode : -7134(A5)  size 4  type int
        ;   natErrMsg : -7390(A5)  size 256  type str
        ;   natFilePb : -7394(A5)  size 4  type ptr
        ;   natFileReady : -7396(A5)  size 1  type bool
        ;   natUiEmitBuf : -7400(A5)  size 4  type ptr
        ;   natQdInited : -7402(A5)  size 1  type bool
        ;   natQdGlobals : -7406(A5)  size 4  type ptr
        ;   rtFh68kLastErr : -7410(A5)  size 4  type int
        ;   rtFh68kState : -7414(A5)  size 4  type ptr
        ;   conn : -7418(A5)  size 4  type int
        LEA -7418(A5),A0
        MOVE.W #3708,D0
LBL_230:
        CLR.W (A0)+
        DBRA D0,LBL_230
        MOVEA.L $0130.W,A0
        ADDA.L #-128760,A0
        DC.W $A02D  ; _SetApplLimit
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_229
        JSR 1986(A5)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR 2258(A5)
        BSR.W LBL_227
        CLR.L -(A7)
        JSR 2082(A5)
        RTS
LBL_229:
        ; cg_init_globals
        LINK A6,#-48
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-24(A5)
        MOVE.L #1,D0
        MOVE.B D0,-90(A5)
        LEA -6650(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6646(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6642(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6638(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6634(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6630(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6626(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6622(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -7096(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-7418(A5)
        UNLK A6
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_0:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 2098(A5)
        ADDQ.L #8,A7
LBL_231:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-52
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 2090(A5)
        ADDQ.L #4,A7
LBL_232:
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
        LINK A6,#-68
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
        BEQ.W LBL_234
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_233
LBL_234:
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
        BEQ.W LBL_235
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
LBL_235:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_236
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
LBL_236:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_237
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
LBL_237:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_238
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
LBL_238:
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
        BRA.W LBL_233
LBL_233:
        UNLK A6
        RTS
        ; func rtFourCC  (JT slot 4)
        ;   param p : 8(A6)  size 4
LBL_3:
        LINK A6,#-52
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
        BRA.W LBL_239
LBL_239:
        UNLK A6
        RTS
        ; func rtArrCheck  (JT slot 5)
        ;   param i : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_4:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_241
        MOVE.L 12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_242
LBL_241:
        MOVEQ #1,D0
LBL_242:
        TST.L D0
        BEQ.W LBL_243
        LEA LBL_178(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_243:
        MOVE.L 12(A6),D0
        BRA.W LBL_240
LBL_240:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 6)
        ;   param v : 14(A6)  size 4
        ;   param found : 12(A6)  size 2
        ;   param name : 8(A6)  size 4
LBL_5:
        LINK A6,#-52
        CLR.L D0
        MOVE.B 12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_245
        LEA LBL_179(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_245:
        MOVE.L 14(A6),D0
        BRA.W LBL_244
LBL_244:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 7)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_6:
        LINK A6,#-60
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
        BEQ.W LBL_247
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_248
LBL_247:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_248:
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
        BEQ.W LBL_249
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_249:
LBL_246:
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
        BEQ.W LBL_251
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_252
LBL_251:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_252:
        MOVE.L -4(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_253
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_254
LBL_253:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_254:
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
        BEQ.W LBL_255
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_255:
LBL_250:
        UNLK A6
        RTS
        ; func rtStrPrependChar  (JT slot 9)
        ;   param out : 16(A6)  size 4
        ;   param c : 12(A6)  size 4
        ;   param a : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local total : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_8:
        LINK A6,#-64
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
        BEQ.W LBL_257
        MOVE.L #255,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_258
LBL_257:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_258:
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
        BEQ.W LBL_259
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_259:
LBL_256:
        UNLK A6
        RTS
        ; func rtStrCmp  (JT slot 10)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local ca : -20(A6)  size 4
        ;   local cb : -24(A6)  size 4
LBL_9:
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
        BEQ.W LBL_261
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_262
LBL_261:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_262:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_263:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_264
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
        BEQ.W LBL_265
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_260
LBL_265:
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_266
        MOVEQ #1,D0
        BRA.W LBL_260
LBL_266:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_263
LBL_264:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_260
LBL_267:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        MOVEQ #1,D0
        BRA.W LBL_260
LBL_268:
        MOVEQ #0,D0
        BRA.W LBL_260
LBL_260:
        UNLK A6
        RTS
        ; func rtStrLen  (JT slot 11)
        ;   param s : 8(A6)  size 4
LBL_10:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_269
LBL_269:
        UNLK A6
        RTS
        ; func rtStrIndex  (JT slot 12)
        ;   param s : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_11:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_271
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
        BRA.W LBL_272
LBL_271:
        MOVEQ #1,D0
LBL_272:
        TST.L D0
        BEQ.W LBL_273
        LEA LBL_181(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_273:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_270
LBL_270:
        UNLK A6
        RTS
        ; func rtIntToStr  (JT slot 13)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param n : 12(A6)  size 4
        ;   local s : -256(A6)  size 256
        ;   local d : -260(A6)  size 4
        ;   local neg : -262(A6)  size 2
        ;   local cur : -266(A6)  size 4
LBL_12:
        LINK A6,#-318
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
        BEQ.W LBL_275
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        BRA.W LBL_274
LBL_275:
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
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
LBL_276:
        MOVE.L -266(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        MOVE.L -266(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_226
        MOVE.L D0,-260(A6)
        MOVE.L -260(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_278
        MOVEQ #0,D1
        MOVE.L -260(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-260(A6)
LBL_278:
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
        BSR.W LBL_8
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
        BSR.W LBL_225
        MOVE.L D0,-266(A6)
        BRA.W LBL_276
LBL_277:
        CLR.L D0
        MOVE.B -262(A6),D0
        TST.L D0
        BEQ.W LBL_279
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_184(PC),A0
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
LBL_279:
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        BRA.W LBL_274
LBL_274:
        UNLK A6
        RTS
        ; func rtStrSlice  (JT slot 14)
        ;   param out : 20(A6)  size 4
        ;   param s : 16(A6)  size 4
        ;   param start : 12(A6)  size 4
        ;   param len : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
LBL_13:
        LINK A6,#-56
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
        BNE.W LBL_281
        MOVE.L 8(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_282
LBL_281:
        MOVEQ #1,D0
LBL_282:
        TST.L D0
        BEQ.W LBL_283
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_283:
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_284
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
        BRA.W LBL_285
LBL_284:
        MOVEQ #1,D0
LBL_285:
        TST.L D0
        BEQ.W LBL_286
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_286:
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
LBL_280:
        UNLK A6
        RTS
        ; func rtStrIndexOfChar  (JT slot 15)
        ;   param s : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local slen : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_14:
        LINK A6,#-60
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
LBL_288:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_289
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
        BEQ.W LBL_290
        MOVE.L -8(A6),D0
        BRA.W LBL_287
LBL_290:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_288
LBL_289:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_287
LBL_287:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 16)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_15:
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
        BEQ.W LBL_292
        BRA.W LBL_291
LBL_292:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_293
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_294
LBL_293:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_294:
LBL_295:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_296
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_224
        MOVE.L D0,-12(A6)
        BRA.W LBL_295
LBL_296:
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
        BEQ.W LBL_297
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_297:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_291:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 17)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_16:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #16,D0
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
        BEQ.W LBL_299
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_299:
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
        BEQ.W LBL_300
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_300:
        MOVE.L -4(A6),D0
        BRA.W LBL_298
LBL_298:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 18)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_17:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
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
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_301:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 19)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_18:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_304
        BRA.W LBL_303
LBL_304:
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
        BEQ.W LBL_305
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_305:
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
        BEQ.W LBL_306
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
LBL_306:
LBL_303:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 20)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_19:
        LINK A6,#-64
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
        BSR.W LBL_15
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
LBL_307:
        UNLK A6
        RTS
        ; func rtTextLen  (JT slot 21)
        ;   param t : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_308
LBL_308:
        UNLK A6
        RTS
        ; func rtTextIndex  (JT slot 22)
        ;   param t : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_21:
        LINK A6,#-60
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
        BNE.W LBL_310
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
        BRA.W LBL_311
LBL_310:
        MOVEQ #1,D0
LBL_311:
        TST.L D0
        BEQ.W LBL_312
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_312:
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
        BRA.W LBL_309
LBL_309:
        UNLK A6
        RTS
        ; func rtTextToBytes  (JT slot 23)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_22:
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
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_315
LBL_314:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_315:
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
        BEQ.W LBL_316
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_316:
        MOVE.L -8(A6),D0
        BRA.W LBL_313
LBL_313:
        UNLK A6
        RTS
        ; func rtTextIndexOfStr  (JT slot 24)
        ;   param t : 12(A6)  size 4
        ;   param needle : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local tlen : -8(A6)  size 4
        ;   local nlen : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local j : -20(A6)  size 4
        ;   local match : -22(A6)  size 2
        ;   local mp : -26(A6)  size 4
LBL_23:
        LINK A6,#-78
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
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        MOVEQ #0,D0
        BRA.W LBL_317
LBL_318:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_319
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_317
LBL_319:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-26(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_320:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_321
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_322:
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
        MOVE.L -26(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_324
        MOVEQ #0,D0
        MOVE.B D0,-22(A6)
        BRA.W LBL_323
LBL_324:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_322
LBL_323:
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_325
        MOVE.L -16(A6),D0
        BRA.W LBL_317
LBL_325:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_320
LBL_321:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_317
LBL_317:
        UNLK A6
        RTS
        ; func rtTextAppendStr  (JT slot 25)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local len0 : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_24:
        LINK A6,#-68
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
        BSR.W LBL_15
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
LBL_326:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 26)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_25:
        LINK A6,#-64
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
        BSR.W LBL_15
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
LBL_327:
        UNLK A6
        RTS
        ; func rtTextClear  (JT slot 27)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_26:
        LINK A6,#-56
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
LBL_328:
        UNLK A6
        RTS
        ; func rtTextAppendText  (JT slot 28)
        ;   param t : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local rs : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local len0 : -16(A6)  size 4
        ;   local srcmp : -20(A6)  size 4
        ;   local dstmp : -24(A6)  size 4
LBL_27:
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
        BSR.W LBL_15
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
LBL_329:
        UNLK A6
        RTS
        ; func rtListGrow  (JT slot 29)
        ;   param l : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local elemsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
LBL_28:
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
        BEQ.W LBL_331
        BRA.W LBL_330
LBL_331:
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
        BEQ.W LBL_332
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_333
LBL_332:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_333:
LBL_334:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_335
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_224
        MOVE.L D0,-12(A6)
        BRA.W LBL_334
LBL_335:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_224
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
        BEQ.W LBL_336
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_336:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_330:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 30)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_29:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #20,D0
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
        BEQ.W LBL_338
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_338:
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
        BEQ.W LBL_339
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_339:
        MOVE.L -4(A6),D0
        BRA.W LBL_337
LBL_337:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 31)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_30:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_341
        BRA.W LBL_340
LBL_341:
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
LBL_340:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 32)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_31:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_343
        BRA.W LBL_342
LBL_343:
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
        BEQ.W LBL_344
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_344:
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
        BEQ.W LBL_345
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
LBL_345:
LBL_342:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 33)
        ;   param l : 8(A6)  size 4
LBL_32:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_347
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_348
LBL_347:
        MOVEQ #0,D0
LBL_348:
        BRA.W LBL_346
LBL_346:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 34)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_33:
        LINK A6,#-64
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
        BNE.W LBL_350
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
        BRA.W LBL_351
LBL_350:
        MOVEQ #1,D0
LBL_351:
        TST.L D0
        BEQ.W LBL_352
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_352:
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
        BSR.W LBL_224
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        BRA.W LBL_349
LBL_349:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 35)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_34:
        LINK A6,#-64
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
        BSR.W LBL_28
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
        BSR.W LBL_224
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
LBL_353:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 36)
        ;   param l : 8(A6)  size 4
LBL_35:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_354
LBL_354:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 37)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_36:
        LINK A6,#-52
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
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_355
LBL_355:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 38)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_37:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #52,D0
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
        BEQ.W LBL_357
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_357:
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
        BEQ.W LBL_358
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_358:
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
        BEQ.W LBL_359
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_359:
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
        BEQ.W LBL_360
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_360:
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
        BEQ.W LBL_361
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_361:
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
        BRA.W LBL_356
LBL_356:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 39)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_38:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_363
        BRA.W LBL_362
LBL_363:
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
LBL_362:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 40)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_39:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_365
        BRA.W LBL_364
LBL_365:
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
        BEQ.W LBL_366
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_366:
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
        BEQ.W LBL_367
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
LBL_367:
LBL_364:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 41)
        ;   param m : 8(A6)  size 4
LBL_40:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_369
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_370
LBL_369:
        MOVEQ #0,D0
LBL_370:
        BRA.W LBL_368
LBL_368:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 42)
        ;   param m : 8(A6)  size 4
LBL_41:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_371
LBL_371:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 43)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_42:
        LINK A6,#-56
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
        BNE.W LBL_373
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
        BRA.W LBL_374
LBL_373:
        MOVEQ #1,D0
LBL_374:
        TST.L D0
        BEQ.W LBL_375
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_375:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
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
LBL_372:
        UNLK A6
        RTS
        ; func rtIntMapNew  (JT slot 44)
        ;   param valsize : 8(A6)  size 4
LBL_43:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        BRA.W LBL_376
LBL_376:
        UNLK A6
        RTS
        ; func rtIntMapRetain  (JT slot 45)
        ;   param m : 8(A6)  size 4
LBL_44:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
LBL_377:
        UNLK A6
        RTS
        ; func rtIntMapRelease  (JT slot 46)
        ;   param m : 8(A6)  size 4
LBL_45:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
LBL_378:
        UNLK A6
        RTS
        ; func rtIntMapLastref  (JT slot 47)
        ;   param m : 8(A6)  size 4
LBL_46:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        BRA.W LBL_379
LBL_379:
        UNLK A6
        RTS
        ; func rtIntMapCount  (JT slot 48)
        ;   param m : 8(A6)  size 4
LBL_47:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
        BRA.W LBL_380
LBL_380:
        UNLK A6
        RTS
        ; func rtIntMapValAt  (JT slot 49)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_48:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDA.W #12,A7
LBL_381:
        UNLK A6
        RTS
        ; func uidI32  (JT slot 50)
        ;   param p : 8(A6)  size 4
        ;   local b0 : -4(A6)  size 4
        ;   local b1 : -8(A6)  size 4
        ;   local b2 : -12(A6)  size 4
        ;   local b3 : -16(A6)  size 4
LBL_49:
        LINK A6,#-68
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
        BRA.W LBL_382
LBL_382:
        UNLK A6
        RTS
        ; func uidStrPtr  (JT slot 51)
        ;   param off : 8(A6)  size 4
LBL_50:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_384
        MOVEQ #0,D0
        BRA.W LBL_383
LBL_384:
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_383
LBL_383:
        UNLK A6
        RTS
        ; func uidWinsOff  (JT slot 52)
LBL_51:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_385
LBL_385:
        UNLK A6
        RTS
        ; func uidMenusOff  (JT slot 53)
LBL_52:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func uidNMenuHandlers  (JT slot 54)
LBL_53:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_387
LBL_387:
        UNLK A6
        RTS
        ; func uidMhOff  (JT slot 55)
LBL_54:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_388
LBL_388:
        UNLK A6
        RTS
        ; func uidWinBase  (JT slot 56)
        ;   param winIdx : 8(A6)  size 4
LBL_55:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_389
LBL_389:
        UNLK A6
        RTS
        ; func uidWinNameOff  (JT slot 57)
        ;   param winIdx : 8(A6)  size 4
LBL_56:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_390
LBL_390:
        UNLK A6
        RTS
        ; func uidWinName  (JT slot 58)
        ;   param winIdx : 8(A6)  size 4
LBL_57:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        BRA.W LBL_391
LBL_391:
        UNLK A6
        RTS
        ; func uidWinNWidgets  (JT slot 59)
        ;   param winIdx : 8(A6)  size 4
LBL_58:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_392
LBL_392:
        UNLK A6
        RTS
        ; func uidWinWidgetsOff  (JT slot 60)
        ;   param winIdx : 8(A6)  size 4
LBL_59:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_393
LBL_393:
        UNLK A6
        RTS
        ; func uidWinMenuMask  (JT slot 61)
        ;   param winIdx : 8(A6)  size 4
LBL_60:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_394
LBL_394:
        UNLK A6
        RTS
        ; func uidWidgetBase  (JT slot 62)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_61:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #80,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_395
LBL_395:
        UNLK A6
        RTS
        ; func uidWidgetKind  (JT slot 63)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_62:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_61
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_396
LBL_396:
        UNLK A6
        RTS
        ; func uidMenuBase  (JT slot 64)
        ;   param menuIdx : 8(A6)  size 4
LBL_63:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_397
LBL_397:
        UNLK A6
        RTS
        ; func uidMenuTitleOff  (JT slot 65)
        ;   param menuIdx : 8(A6)  size 4
LBL_64:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_398
LBL_398:
        UNLK A6
        RTS
        ; func uidMenuTitle  (JT slot 66)
        ;   param menuIdx : 8(A6)  size 4
LBL_65:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        BRA.W LBL_399
LBL_399:
        UNLK A6
        RTS
        ; func uidMenuIsStandardEdit  (JT slot 67)
        ;   param menuIdx : 8(A6)  size 4
LBL_66:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_400
LBL_400:
        UNLK A6
        RTS
        ; func uidMenuHandlerBase  (JT slot 68)
        ;   param k : 8(A6)  size 4
LBL_67:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_401
LBL_401:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuIdx  (JT slot 69)
        ;   param k : 8(A6)  size 4
LBL_68:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_402
LBL_402:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemIdx  (JT slot 70)
        ;   param k : 8(A6)  size 4
LBL_69:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_403
LBL_403:
        UNLK A6
        RTS
        ; func uidMenuHandlerScopeWinIdx  (JT slot 71)
        ;   param k : 8(A6)  size 4
LBL_70:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_404
LBL_404:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuNameOff  (JT slot 72)
        ;   param k : 8(A6)  size 4
LBL_71:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_405
LBL_405:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuName  (JT slot 73)
        ;   param k : 8(A6)  size 4
LBL_72:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        BRA.W LBL_406
LBL_406:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemNameOff  (JT slot 74)
        ;   param k : 8(A6)  size 4
LBL_73:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_407
LBL_407:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemName  (JT slot 75)
        ;   param k : 8(A6)  size 4
LBL_74:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        BRA.W LBL_408
LBL_408:
        UNLK A6
        RTS
        ; func uidTableRowsIdx  (JT slot 76)
        ;   param off : 8(A6)  size 4
LBL_75:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_409
LBL_409:
        UNLK A6
        RTS
        ; func uidTableLayoutOff  (JT slot 77)
        ;   param off : 8(A6)  size 4
LBL_76:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_410
LBL_410:
        UNLK A6
        RTS
        ; func uidTableNCols  (JT slot 78)
        ;   param off : 8(A6)  size 4
LBL_77:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_411
LBL_411:
        UNLK A6
        RTS
        ; func uidTableColsOff  (JT slot 79)
        ;   param off : 8(A6)  size 4
LBL_78:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_412
LBL_412:
        UNLK A6
        RTS
        ; func uidColBase  (JT slot 80)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_79:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #28,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_413
LBL_413:
        UNLK A6
        RTS
        ; func uidColWidthPx  (JT slot 81)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_80:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_414
LBL_414:
        UNLK A6
        RTS
        ; func uidColWidthFill  (JT slot 82)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_81:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_415
LBL_415:
        UNLK A6
        RTS
        ; func uidColFieldIndex  (JT slot 83)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_82:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_416
LBL_416:
        UNLK A6
        RTS
        ; func uidFieldBase  (JT slot 84)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_83:
        LINK A6,#-52
        LEA LBL_223(PC),A0
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
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_417
LBL_417:
        UNLK A6
        RTS
        ; func uidFieldFtype  (JT slot 85)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_84:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_418
LBL_418:
        UNLK A6
        RTS
        ; func uidFieldOffset  (JT slot 86)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_85:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_419
LBL_419:
        UNLK A6
        RTS
        ; func uidFieldEnumCount  (JT slot 87)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_86:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_420
LBL_420:
        UNLK A6
        RTS
        ; func uidFieldEnumLabelsOff  (JT slot 88)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_87:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_421
LBL_421:
        UNLK A6
        RTS
        ; func uidFieldEnumValuesOff  (JT slot 89)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_88:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_422
LBL_422:
        UNLK A6
        RTS
        ; func uidEnumLabelOff  (JT slot 90)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_89:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_423
LBL_423:
        UNLK A6
        RTS
        ; func uidEnumLabel  (JT slot 91)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_90:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        BRA.W LBL_424
LBL_424:
        UNLK A6
        RTS
        ; func uidEnumValue  (JT slot 92)
        ;   param enumValuesOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_91:
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_425
LBL_425:
        UNLK A6
        RTS
        ; func UiNewPtr  (JT slot 93)
        ;   param size : 8(A6)  size 4
LBL_92:
        LINK A6,#-52
        BSR.W LBL_130
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtrRaw
        MOVE.L A0,D0
        BRA.W LBL_426
LBL_426:
        UNLK A6
        RTS
        ; func aeQuitHandler  (JT slot 94)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_93:
        LINK A6,#-52
        BSR.W LBL_102
        MOVEQ #0,D0
        BRA.W LBL_427
LBL_427:
        UNLK A6
        RTS
        ; func aeOappHandler  (JT slot 95)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_94:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_428
LBL_428:
        UNLK A6
        RTS
        ; func nat_UiLaunchReal  (JT slot 96)
        ;   local junk : -4(A6)  size 4
LBL_95:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -26(A5),D0
        TST.L D0
        BEQ.W LBL_430
        CLR.W -(A7)
        MOVE.L #1634039412,D0
        MOVE.L D0,-(A7)
        MOVE.L #1903520116,D0
        MOVE.L D0,-(A7)
        LEA 2474(A5),A0
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
        LEA 2482(A5),A0
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
LBL_430:
        JSR 2450(A5)
LBL_429:
        UNLK A6
        RTS
        ; func nat_UiAEProcessEvent  (JT slot 97)
        ;   param evBuf : 8(A6)  size 4
        ;   local junk : -4(A6)  size 4
LBL_96:
        LINK A6,#-56
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
LBL_431:
        UNLK A6
        RTS
        ; func rtUiIsOurs  (JT slot 98)
        ;   param wp : 8(A6)  size 4
LBL_97:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        MOVEQ #0,D0
        BRA.W LBL_432
LBL_433:
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
        BRA.W LBL_432
LBL_432:
        UNLK A6
        RTS
        ; func rtUiWinstOf  (JT slot 99)
        ;   param wp : 8(A6)  size 4
LBL_98:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_97
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        MOVEQ #0,D0
        BRA.W LBL_434
LBL_435:
        CLR.L -(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        BRA.W LBL_434
LBL_434:
        UNLK A6
        RTS
        ; func rtUiFront  (JT slot 100)
        ;   param winIdx : 8(A6)  size 4
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
LBL_99:
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
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_440
        MOVE.L -8(A6),D0
        BRA.W LBL_436
LBL_440:
LBL_439:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_437
LBL_438:
        MOVEQ #0,D0
        BRA.W LBL_436
LBL_436:
        UNLK A6
        RTS
        ; func rtUiTeardownWindow  (JT slot 101)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local lh : -20(A6)  size 4
        ;   local ldefH : -24(A6)  size 4
LBL_100:
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_442:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_443
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_123
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_444
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
LBL_444:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_442
LBL_443:
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
        BSR.W LBL_135
        ADDQ.L #8,A7
        BSR.W LBL_111
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_190(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_136
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
        JSR 2394(A5)
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
        BEQ.W LBL_445
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2426(A5)
        ADDQ.L #8,A7
LBL_445:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_446:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_448
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDA.W #20,A7
LBL_448:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9CD  ; UiTEDispose
LBL_449:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_450
        MOVE.L #1000,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_124
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A932  ; UiDisposeMenu
LBL_450:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_446
LBL_447:
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
        BEQ.W LBL_451
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
LBL_451:
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
LBL_441:
        UNLK A6
        RTS
        ; func rtUiCloseInternal  (JT slot 102)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local cancelSlot : -12(A6)  size 4
        ;   local cancelled : -14(A6)  size 2
LBL_101:
        LINK A6,#-66
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
        BEQ.W LBL_453
        MOVE.L 8(A6),D1
        MOVE.L -128(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_454
LBL_453:
        MOVEQ #0,D0
LBL_454:
        TST.L D0
        BEQ.W LBL_455
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_452
LBL_455:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_136
        ADDQ.L #8,A7
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
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
        JSR 2394(A5)
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
        BEQ.W LBL_456
        MOVEQ #0,D0
        BRA.W LBL_452
LBL_456:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_452
LBL_452:
        UNLK A6
        RTS
        ; func rtUiQuit  (JT slot 103)
        ;   local wp : -4(A6)  size 4
        ;   local next : -8(A6)  size 4
        ;   local inst : -12(A6)  size 4
LBL_102:
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
LBL_458:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_97
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_460
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_101
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        BRA.W LBL_457
LBL_461:
LBL_460:
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_458
LBL_459:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 2218(A5)
        ADDQ.L #4,A7
LBL_457:
        UNLK A6
        RTS
        ; func rtUiHiWord  (JT slot 104)
        ;   param v : 8(A6)  size 4
LBL_103:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        BRA.W LBL_462
LBL_462:
        UNLK A6
        RTS
        ; func rtUiMenuHandleAt  (JT slot 105)
        ;   param menuIdx : 8(A6)  size 4
LBL_104:
        LINK A6,#-52
        MOVE.L -4(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_466
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_467
LBL_466:
        MOVEQ #1,D0
LBL_467:
        TST.L D0
        BNE.W LBL_464
        MOVE.L 8(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_465
LBL_464:
        MOVEQ #1,D0
LBL_465:
        TST.L D0
        BEQ.W LBL_468
        MOVEQ #0,D0
        BRA.W LBL_463
LBL_468:
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_463
LBL_463:
        UNLK A6
        RTS
        ; func rtUiMenuItemNum  (JT slot 106)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_105:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_470
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #7,D0
        ADD.L D1,D0
        BRA.W LBL_469
LBL_470:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        BRA.W LBL_469
LBL_469:
        UNLK A6
        RTS
        ; func rtUiSyncMenuBar  (JT slot 107)
        ;   local inst : -4(A6)  size 4
        ;   local target : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local bit : -16(A6)  size 4
        ;   local mh : -20(A6)  size 4
LBL_106:
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
        MOVE.L -4(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_472
        MOVE.L -12(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_473
LBL_472:
        MOVEQ #1,D0
LBL_473:
        TST.L D0
        BEQ.W LBL_474
        BRA.W LBL_471
LBL_474:
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
        BSR.W LBL_98
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-8(A6)
LBL_475:
        MOVE.L -8(A6),D1
        MOVE.L -16(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_476
        BRA.W LBL_471
LBL_476:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_477:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_478
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
        BEQ.W LBL_479
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_480
LBL_479:
        MOVEQ #0,D0
LBL_480:
        TST.L D0
        BEQ.W LBL_481
        MOVEQ #2,D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
LBL_481:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_477
LBL_478:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_482:
        MOVE.L -12(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_483
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
        BEQ.W LBL_484
        MOVE.L -12(A5),D1
        MOVE.L -16(A6),D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_485
LBL_484:
        MOVEQ #0,D0
LBL_485:
        TST.L D0
        BEQ.W LBL_486
        MOVE.L -4(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_224
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
LBL_486:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_482
LBL_483:
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A5)
        DC.W $A937  ; UiDrawMenuBar
LBL_471:
        UNLK A6
        RTS
        ; func rtUiMenuEnableNum  (JT slot 108)
        ;   param mh : 14(A6)  size 4
        ;   param itemNum : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
LBL_107:
        LINK A6,#-52
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_488
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A939  ; UiEnableItem
        BRA.W LBL_489
LBL_488:
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A93A  ; UiDisableItem
LBL_489:
LBL_487:
        UNLK A6
        RTS
        ; func rtUiMenuEnable  (JT slot 109)
        ;   param menuIdx : 14(A6)  size 4
        ;   param itemIdx : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local mh : -4(A6)  size 4
LBL_108:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_104
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_491
        BRA.W LBL_490
LBL_491:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_105
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_107
        ADDA.W #10,A7
LBL_490:
        UNLK A6
        RTS
        ; func rtUiFocusKind  (JT slot 110)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_109:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_493
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_492
LBL_493:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_494
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_492
LBL_494:
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
        BSR.W LBL_62
        ADDQ.L #8,A7
        BRA.W LBL_492
LBL_492:
        UNLK A6
        RTS
        ; func rtUiMenuRecomputeDim  (JT slot 111)
        ;   local k : -4(A6)  size 4
        ;   local nMh : -8(A6)  size 4
        ;   local scopeWinIdx : -12(A6)  size 4
        ;   local enable : -14(A6)  size 2
        ;   local kind : -18(A6)  size 4
        ;   local mh : -22(A6)  size 4
        ;   local i : -26(A6)  size 4
        ;   local j : -30(A6)  size 4
LBL_110:
        LINK A6,#-82
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
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
        MOVEQ #0,D0
        MOVE.L D0,-30(A6)
        BSR.W LBL_53
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_496:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_497
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
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
        BEQ.W LBL_498
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_108
        ADDA.W #10,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_137
        ADDQ.L #6,A7
LBL_498:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_496
LBL_497:
        MOVE.L -24(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_499
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_109
        ADDQ.L #4,A7
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_500
        MOVE.L -18(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_501
LBL_500:
        MOVEQ #1,D0
LBL_501:
        MOVE.B D0,-14(A6)
        MOVE.L -24(A5),D0
        MOVE.L D0,-26(A6)
LBL_502:
        MOVE.L -26(A6),D1
        MOVE.L -8(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_503
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_504
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_104
        ADDQ.L #4,A7
        MOVE.L D0,-22(A6)
        MOVEQ #3,D0
        MOVE.L D0,-30(A6)
LBL_505:
        MOVE.L -30(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_506
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_107
        ADDA.W #10,A7
        MOVE.L -30(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-30(A6)
        BRA.W LBL_505
LBL_506:
LBL_504:
        MOVE.L -26(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-26(A6)
        BRA.W LBL_502
LBL_503:
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_138
        ADDQ.L #2,A7
LBL_499:
        BSR.W LBL_139
LBL_495:
        UNLK A6
        RTS
        ; func rtUiAfterFrontChange  (JT slot 112)
LBL_111:
        LINK A6,#-52
        BSR.W LBL_106
        BSR.W LBL_110
        BSR.W LBL_140
LBL_507:
        UNLK A6
        RTS
        ; func UiNewRgn  (JT slot 113)
LBL_112:
        LINK A6,#-52
        BSR.W LBL_130
        CLR.L -(A7)
        DC.W $A8D8  ; UiNewRgnRaw
        MOVE.L (A7)+,D0
        BRA.W LBL_508
LBL_508:
        UNLK A6
        RTS
        ; func rtUiCanvasBufAt  (JT slot 114)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_113:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #44,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_509
LBL_509:
        UNLK A6
        RTS
        ; func rtUiTeAt  (JT slot 115)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_114:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 56(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_510
LBL_510:
        UNLK A6
        RTS
        ; func rtUiPstrcpy  (JT slot 116)
        ;   param dst : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_115:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_512
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_511
LBL_512:
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
LBL_511:
        UNLK A6
        RTS
        ; func rtUiCanvasDispose  (JT slot 117)
        ;   param cb : 8(A6)  size 4
        ;   local buf : -4(A6)  size 4
LBL_116:
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
        BEQ.W LBL_514
        BRA.W LBL_513
LBL_514:
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
LBL_513:
        UNLK A6
        RTS
        ; func nat_UiTEFromScrap  (JT slot 118)
        ;   local th : -4(A6)  size 4
        ;   local offSlot : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_117:
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
        BEQ.W LBL_516
        MOVEQ #102,D0
        NEG.L D0
        BRA.W LBL_515
LBL_516:
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
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
        BEQ.W LBL_517
        MOVE.L -12(A6),D0
        BRA.W LBL_515
LBL_517:
        MOVE.L -12(A6),D1
        MOVE.L #32767,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_518
        MOVE.L #32767,D0
        MOVE.L D0,-12(A6)
LBL_518:
        MOVE.L #2736,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_515
LBL_515:
        UNLK A6
        RTS
        ; func nat_UiTEToScrap  (JT slot 119)
        ;   local th : -4(A6)  size 4
        ;   local st : -8(A6)  size 4
        ;   local err : -12(A6)  size 4
LBL_118:
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
        BEQ.W LBL_520
        MOVEQ #0,D0
        BRA.W LBL_519
LBL_520:
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
        BSR.W LBL_119
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
        BRA.W LBL_519
LBL_519:
        UNLK A6
        RTS
        ; func nat_UiTEGetScrapLength  (JT slot 120)
LBL_119:
        LINK A6,#-52
        MOVE.L #2736,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_521
LBL_521:
        UNLK A6
        RTS
        ; func rtUiScrollbarAction  (JT slot 121)
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
LBL_120:
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
        BEQ.W LBL_523
        BRA.W LBL_522
LBL_523:
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
        BSR.W LBL_98
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_524
        BRA.W LBL_522
LBL_524:
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
        BSR.W LBL_114
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_525
        BRA.W LBL_522
LBL_525:
        MOVE.L -26(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-30(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_526
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
        BEQ.W LBL_528
        MOVEQ #0,D1
        MOVEQ #8,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_529
LBL_528:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_530
        MOVEQ #8,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_531
LBL_530:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_532
        MOVEQ #0,D1
        MOVE.L -38(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_533
LBL_532:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_534
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_535
LBL_534:
        BRA.W LBL_522
LBL_535:
LBL_533:
LBL_531:
LBL_529:
        BRA.W LBL_527
LBL_526:
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
        BEQ.W LBL_536
        MOVEQ #1,D0
        MOVE.L D0,-42(A6)
LBL_536:
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
        BEQ.W LBL_537
        MOVEQ #0,D1
        MOVE.L -42(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_538
LBL_537:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_539
        MOVE.L -42(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_540
LBL_539:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        MOVEQ #0,D1
        MOVE.L -46(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_542
LBL_541:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_543
        MOVE.L -46(A6),D0
        MOVE.L D0,-34(A6)
        BRA.W LBL_544
LBL_543:
        BRA.W LBL_522
LBL_544:
LBL_542:
LBL_540:
LBL_538:
LBL_527:
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
        BEQ.W LBL_545
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
LBL_545:
        MOVE.L -54(A6),D1
        MOVE.L -58(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_546
        MOVE.L -58(A6),D0
        MOVE.L D0,-54(A6)
LBL_546:
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
        BEQ.W LBL_547
        BRA.W LBL_522
LBL_547:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        CLR.L D0
        MOVE.B -18(A6),D0
        TST.L D0
        BEQ.W LBL_548
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
        BRA.W LBL_549
LBL_548:
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.W D0,-(A7)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9DD  ; UiTEScroll
LBL_549:
LBL_522:
        UNLK A6
        RTS
        ; func rtUiIntToPStr  (JT slot 122)
        ;   param n : 12(A6)  size 4
        ;   param out255 : 8(A6)  size 4
        ;   local u : -4(A6)  size 4
        ;   local d : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local len : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
        ;   local t : -26(A6)  size 4
LBL_121:
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
        BEQ.W LBL_551
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_551:
LBL_552:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_553
        MOVE.L -4(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_226
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_554
        MOVEQ #0,D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
LBL_554:
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
        BSR.W LBL_225
        MOVE.L D0,-4(A6)
        BRA.W LBL_552
LBL_553:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_555
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
LBL_555:
        MOVEQ #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L -14(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_556:
        MOVE.L -18(A6),D1
        MOVE.L -22(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_557
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
        BRA.W LBL_556
LBL_557:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_550:
        UNLK A6
        RTS
        ; func nat_UiCbAddr  (JT slot 123)
        ;   param cb : 8(A6)  size 4
LBL_122:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        BRA.W LBL_558
LBL_558:
        UNLK A6
        RTS
        ; func rtUiListAt  (JT slot 124)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_123:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 88(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_559
LBL_559:
        UNLK A6
        RTS
        ; func rtUiPopupAt  (JT slot 125)
        ;   param w : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_124:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 96(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_560
LBL_560:
        UNLK A6
        RTS
        ; func rtUiTableFillWidth  (JT slot 126)
        ;   param colsOff : 16(A6)  size 4
        ;   param nCols : 12(A6)  size 4
        ;   param totalW : 8(A6)  size 4
        ;   local fixedSum : -4(A6)  size 4
        ;   local k : -8(A6)  size 4
        ;   local fillW : -12(A6)  size 4
LBL_125:
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
LBL_562:
        MOVE.L -8(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_563
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #8,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_564
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
LBL_564:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_562
LBL_563:
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
        BEQ.W LBL_565
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_565:
        MOVE.L -12(A6),D0
        BRA.W LBL_561
LBL_561:
        UNLK A6
        RTS
        ; func rtUiFixedToStr  (JT slot 127)
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
LBL_126:
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
        BEQ.W LBL_567
        MOVEQ #0,D1
        MOVE.L 12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_568
LBL_567:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6(A6)
LBL_568:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #4,A7
        MOVE.L D0,-10(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #4,A7
        MOVE.L D0,-14(A6)
        MOVE.L -6(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_121
        ADDQ.L #8,A7
        MOVE.L -6(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVE.L #10000,D0
        BSR.W LBL_224
        MOVE.L D0,D1
        MOVE.L #65536,D0
        BSR.W LBL_225
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_121
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-22(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_569
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
LBL_569:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_570:
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
        BEQ.W LBL_571
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
        BRA.W LBL_570
LBL_571:
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
LBL_572:
        MOVE.L -26(A6),D1
        MOVE.L -30(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_573
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
        BRA.W LBL_572
LBL_573:
        MOVEQ #0,D0
        MOVE.L D0,-26(A6)
LBL_574:
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
        BEQ.W LBL_575
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
        BRA.W LBL_574
LBL_575:
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
LBL_566:
        UNLK A6
        RTS
        ; func rtUiIntFieldLoad  (JT slot 128)
        ;   param base : 12(A6)  size 4
        ;   param ftype : 8(A6)  size 4
        ;   local v : -4(A6)  size 4
LBL_127:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_576
LBL_577:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_578
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_576
LBL_578:
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
        BEQ.W LBL_579
        MOVE.L -4(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_580
LBL_579:
        MOVEQ #0,D0
LBL_580:
        TST.L D0
        BEQ.W LBL_581
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_581:
        MOVE.L -4(A6),D0
        BRA.W LBL_576
LBL_576:
        UNLK A6
        RTS
        ; func rtUiTableDrawField  (JT slot 129)
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
LBL_128:
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
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_583
        BRA.W LBL_582
LBL_583:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
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
        BEQ.W LBL_584
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
        BRA.W LBL_585
LBL_584:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_586
        MOVE.L -8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_587
LBL_586:
        MOVEQ #1,D0
LBL_587:
        TST.L D0
        BEQ.W LBL_588
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_127
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_121
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
        BRA.W LBL_589
LBL_588:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_590
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_126
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
        BRA.W LBL_591
LBL_590:
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_592
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
        BEQ.W LBL_594
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
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
LBL_594:
        BRA.W LBL_593
LBL_592:
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_595
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
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
        BRA.W LBL_596
LBL_595:
        MOVE.L -8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVEQ #0,D0
        MOVE.B D0,-42(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
LBL_598:
        MOVE.L -36(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_599
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_91
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_600
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
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
        BRA.W LBL_601
LBL_600:
        MOVE.L -36(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
LBL_601:
        BRA.W LBL_598
LBL_599:
        CLR.L D0
        MOVE.B -42(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_602
        LEA LBL_192(PC),A0
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
LBL_602:
LBL_597:
LBL_596:
LBL_593:
LBL_591:
LBL_589:
LBL_585:
LBL_582:
        UNLK A6
        RTS
        ; func rtUiLdefDraw  (JT slot 130)
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
LBL_129:
        LINK A6,#-128
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
        BEQ.W LBL_604
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
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A3  ; UiEraseRect
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2434(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVE.L D0,-36(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_103
        ADDQ.L #4,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_606
        MOVE.L -40(A6),D1
        MOVE.L -36(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_607
LBL_606:
        MOVEQ #0,D0
LBL_607:
        TST.L D0
        BEQ.W LBL_608
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
        BSR.W LBL_125
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
LBL_609:
        MOVE.L -64(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_610
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_611
        MOVE.L -56(A6),D0
        MOVE.L D0,-68(A6)
        BRA.W LBL_612
LBL_611:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
LBL_612:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
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
        BSR.W LBL_112
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
        BSR.W LBL_33
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
        BSR.W LBL_82
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_128
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
        BRA.W LBL_609
LBL_610:
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A06A  ; UiHSetState
LBL_608:
        CLR.L D0
        MOVE.B 28(A6),D0
        TST.L D0
        BEQ.W LBL_613
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_613:
        BRA.W LBL_605
LBL_604:
        MOVE.L 30(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_614
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A8A4  ; UiInvertRect
LBL_614:
LBL_605:
LBL_603:
        UNLK A6
        RTS
        ; func rtUiJiggleTick  (JT slot 131)
LBL_130:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -52(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_616
        CLR.L D0
        MOVE.B -54(A5),D0
        BRA.W LBL_617
LBL_616:
        MOVEQ #1,D0
LBL_617:
        TST.L D0
        BEQ.W LBL_618
        BRA.W LBL_615
LBL_618:
        MOVEQ #1,D0
        MOVE.B D0,-54(A5)
        MOVE.L #2147483632,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A04C  ; UiCompactMem
        MOVEQ #0,D0
        MOVE.B D0,-54(A5)
LBL_615:
        UNLK A6
        RTS
        ; func rtUiTextAppendStrSafe  (JT slot 132)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_131:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_620
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
LBL_620:
LBL_619:
        UNLK A6
        RTS
        ; func rtUiIntToText  (JT slot 133)
        ;   param v : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local neg : -10(A6)  size 2
        ;   local digits : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local d : -22(A6)  size 4
LBL_132:
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
        BSR.W LBL_16
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
        BEQ.W LBL_622
        MOVE.L -8(A6),D0
        NEG.L D0
        MOVE.L D0,-8(A6)
LBL_622:
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
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
        BEQ.W LBL_623
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_624
LBL_623:
LBL_625:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_626
        MOVE.L -8(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_226
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
        BSR.W LBL_225
        MOVE.L D0,-8(A6)
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-18(A6)
        BRA.W LBL_625
LBL_626:
LBL_624:
        CLR.L D0
        MOVE.B -10(A6),D0
        TST.L D0
        BEQ.W LBL_627
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
LBL_627:
LBL_628:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_629
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
        BSR.W LBL_25
        ADDQ.L #8,A7
        BRA.W LBL_628
LBL_629:
        MOVE.L -14(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -4(A6),D0
        BRA.W LBL_621
LBL_621:
        UNLK A6
        RTS
        ; func rtUiTextAppendInt  (JT slot 134)
        ;   param t : 12(A6)  size 4
        ;   param v : 8(A6)  size 4
        ;   local nt : -4(A6)  size 4
LBL_133:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_132
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
LBL_630:
        UNLK A6
        RTS
        ; func rtUiEmitLine  (JT slot 135)
        ;   param t : 8(A6)  size 4
LBL_134:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -76(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_632
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2202(A5)
        ADDQ.L #4,A7
LBL_632:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
LBL_631:
        UNLK A6
        RTS
        ; func rtUiTraceClose  (JT slot 136)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_135:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 2002(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_634
        BRA.W LBL_633
LBL_634:
        BSR.W LBL_16
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_194(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
LBL_633:
        UNLK A6
        RTS
        ; func rtUiTraceFire1  (JT slot 137)
        ;   param namePtr : 12(A6)  size 4
        ;   param event : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_136:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 2002(A5)
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_636
        BRA.W LBL_635
LBL_636:
        BSR.W LBL_16
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_195(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_196(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
LBL_635:
        UNLK A6
        RTS
        ; func rtUiTraceDimCheck  (JT slot 138)
        ;   param k : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local prev : -4(A6)  size 4
        ;   local enableInt : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_137:
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
        BEQ.W LBL_638
        MOVEQ #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_639
LBL_638:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_639:
        MOVE.L -88(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_640
        BRA.W LBL_637
LBL_640:
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
        BEQ.W LBL_643
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_644
LBL_643:
        MOVEQ #0,D0
LBL_644:
        TST.L D0
        BEQ.W LBL_641
        JSR 2002(A5)
        BRA.W LBL_642
LBL_641:
        MOVEQ #0,D0
LBL_642:
        TST.L D0
        BEQ.W LBL_645
        BSR.W LBL_16
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_196(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
LBL_645:
        MOVE.L -88(A5),D1
        MOVE.L 10(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_637:
        UNLK A6
        RTS
        ; func rtUiTraceStdEditDim  (JT slot 139)
        ;   param enable : 8(A6)  size 2
        ;   local enableInt : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
LBL_138:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_647
        MOVEQ #1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_648
LBL_647:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_648:
        CLR.L D0
        MOVE.B -90(A5),D0
        TST.L D0
        BNE.W LBL_651
        CLR.L D0
        MOVE.B -92(A5),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_652
LBL_651:
        MOVEQ #1,D0
LBL_652:
        TST.L D0
        BNE.W LBL_649
        JSR 2002(A5)
        EORI.L #1,D0
        BRA.W LBL_650
LBL_649:
        MOVEQ #1,D0
LBL_650:
        TST.L D0
        BEQ.W LBL_653
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-92(A5)
        BRA.W LBL_646
LBL_653:
        BSR.W LBL_16
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
        BSR.W LBL_16
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_199(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
        BSR.W LBL_16
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_200(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
        BSR.W LBL_16
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
        BSR.W LBL_16
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B 8(A6),D0
        MOVE.B D0,-92(A5)
LBL_646:
        UNLK A6
        RTS
        ; func rtUiTraceDimFirstDone  (JT slot 140)
LBL_139:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.B D0,-90(A5)
LBL_654:
        UNLK A6
        RTS
        ; func rtUiTraceFrontCheck  (JT slot 141)
        ;   local wp : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_140:
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
        BSR.W LBL_97
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_656
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_657
LBL_656:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_657:
        MOVE.L -8(A6),D1
        MOVE.L -84(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_658
        BRA.W LBL_655
LBL_658:
        MOVE.L -8(A6),D0
        MOVE.L D0,-84(A5)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_659
        JSR 2002(A5)
        BRA.W LBL_660
LBL_659:
        MOVEQ #0,D0
LBL_660:
        TST.L D0
        BEQ.W LBL_661
        BSR.W LBL_16
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_131
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 80(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_133
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
LBL_661:
LBL_655:
        UNLK A6
        RTS
        ; func nat_UiSFGetFile  (JT slot 142)
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
LBL_141:
        LINK A6,#-500
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_663:
        CLR.L (A0)+
        DBRA D0,LBL_663
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
LBL_664:
        CLR.L (A0)+
        DBRA D0,LBL_664
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
        BSR.W LBL_29
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
        BEQ.W LBL_665
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
        BRA.W LBL_666
LBL_665:
        MOVEQ #0,D0
LBL_666:
        TST.L D0
        BEQ.W LBL_667
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-422(A6)
        BRA.W LBL_668
LBL_667:
        MOVEQ #0,D0
        MOVE.L D0,-426(A6)
        MOVEQ #0,D0
        MOVE.L D0,-430(A6)
LBL_669:
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_670
        MOVE.L -430(A6),D1
        MOVE.L -418(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_671
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
        BRA.W LBL_672
LBL_671:
        MOVEQ #1,D0
LBL_672:
        TST.L D0
        BEQ.W LBL_673
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_674
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_204(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_675:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_662
LBL_674:
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
        BEQ.W LBL_676
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_677:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_662
LBL_676:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -438(A6),D0
        MOVE.L D0,-448(A6)
        LEA -448(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-426(A6)
LBL_673:
        MOVE.L -430(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-430(A6)
        BRA.W LBL_669
LBL_670:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVE.L D0,-422(A6)
        MOVE.L -422(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_678
        LEA -90(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_679
        BRA.W LBL_680
LBL_679:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_680:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_224
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_678:
        MOVE.L -422(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_681
        LEA -86(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_682
        BRA.W LBL_683
LBL_682:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_683:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_224
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_681:
        MOVE.L -422(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_684
        LEA -82(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #2,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_685
        BRA.W LBL_686
LBL_685:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_686:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_224
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_684:
        MOVE.L -422(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_687
        LEA -78(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D1
        MOVEQ #3,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_688
        BRA.W LBL_689
LBL_688:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_689:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_224
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_687:
LBL_668:
        MOVEQ #100,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #100,D0
        OR.L D1,D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
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
        BEQ.W LBL_690
        MOVEQ #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_691:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_662
LBL_690:
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
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -410(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #8,A7
        MOVEQ #1,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-456(A6)
LBL_692:
        MOVE.L A1,-(A7)
        MOVE.L -456(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_662
LBL_662:
        UNLK A6
        RTS
        ; func nat_UiSFPutFile  (JT slot 143)
        ;   param suggested255 : 12(A6)  size 4
        ;   param path255Out : 8(A6)  size 4
        ;   local rep : -74(A6)  size 74
        ;   local vp : -138(A6)  size 64
        ;   local s : -394(A6)  size 256
        ;   local junk : -398(A6)  size 4
LBL_142:
        LINK A6,#-450
        LEA -74(A6),A0
        MOVE.W #17,D0
LBL_694:
        CLR.L (A0)+
        DBRA D0,LBL_694
        CLR.W (A0)+
        LEA -138(A6),A0
        MOVE.W #15,D0
LBL_695:
        CLR.L (A0)+
        DBRA D0,LBL_695
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
        LEA LBL_206(PC),A0
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
        BEQ.W LBL_696
        MOVEQ #0,D0
        BRA.W LBL_693
LBL_696:
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
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -394(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_693
LBL_693:
        UNLK A6
        RTS
        ; func rtUiFormTeardown  (JT slot 144)
        ;   param inst : 8(A6)  size 4
        ;   local bufH : -4(A6)  size 4
LBL_143:
        LINK A6,#-56
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
        BSR.W LBL_100
        ADDQ.L #4,A7
LBL_697:
        UNLK A6
        RTS
        ; func rtUiFormCancel  (JT slot 145)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_144:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_207(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_136
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
        JSR 2394(A5)
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
LBL_698:
        UNLK A6
        RTS
        ; func sortedmapValSlot  (JT slot 146)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_145:
        LINK A6,#-52
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
        BSR.W LBL_224
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_699
LBL_699:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 147)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_146:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #28,D0
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
        BEQ.W LBL_701
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_701:
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
        BEQ.W LBL_702
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_702:
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
        BEQ.W LBL_703
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_703:
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
        BRA.W LBL_700
LBL_700:
        UNLK A6
        RTS
        ; func rtSortedMapRetain  (JT slot 148)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_147:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_705
        BRA.W LBL_704
LBL_705:
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
LBL_704:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 149)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_148:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_707
        BRA.W LBL_706
LBL_707:
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
        BEQ.W LBL_708
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_708:
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
        BEQ.W LBL_709
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
LBL_709:
LBL_706:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 150)
        ;   param m : 8(A6)  size 4
LBL_149:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_711
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_712
LBL_711:
        MOVEQ #0,D0
LBL_712:
        BRA.W LBL_710
LBL_710:
        UNLK A6
        RTS
        ; func rtSortedMapCount  (JT slot 151)
        ;   param m : 8(A6)  size 4
LBL_150:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_713
LBL_713:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 152)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_151:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_715
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
        BRA.W LBL_716
LBL_715:
        MOVEQ #1,D0
LBL_716:
        TST.L D0
        BEQ.W LBL_717
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_717:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_145
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
LBL_714:
        UNLK A6
        RTS
        ; func rtConnParseSpec  (JT slot 153)
        ;   param spec : 8(A6)  size 4
        ;   local colonIdx : -4(A6)  size 4
        ;   local name : -260(A6)  size 256
        ;   local baudStr : -516(A6)  size 256
        ;   local baud : -520(A6)  size 4
LBL_152:
        LINK A6,#-572
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -260(A6),A0
        CLR.B (A0)
        LEA -516(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-520(A6)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #58,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_719
        MOVEQ #0,D0
        BRA.W LBL_718
LBL_719:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #16,A7
        LEA -260(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        ADDA.W #256,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #16,A7
        LEA -516(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_720
        MOVEQ #0,D0
        MOVE.L D0,-2292(A5)
        BRA.W LBL_721
LBL_720:
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_209(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_722
        MOVEQ #1,D0
        MOVE.L D0,-2292(A5)
        BRA.W LBL_723
LBL_722:
        MOVEQ #0,D0
        BRA.W LBL_718
LBL_723:
LBL_721:
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_153
        ADDQ.L #4,A7
        MOVE.L D0,-520(A6)
        MOVE.L -520(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_154
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_724
        MOVEQ #0,D0
        BRA.W LBL_718
LBL_724:
        MOVE.L -520(A6),D0
        MOVE.L D0,-2296(A5)
        MOVEQ #1,D0
        BRA.W LBL_718
LBL_718:
        UNLK A6
        RTS
        ; func rtConnParseInt  (JT slot 154)
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local v : -8(A6)  size 4
        ;   local c : -10(A6)  size 2
LBL_153:
        LINK A6,#-62
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_726
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_725
LBL_726:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_727:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_728
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVEA.L (A7)+,A0
        CLR.L D0
        MOVE.B (A0),D0
        CMP.L D0,D1
        BCS.W LBL_729
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
LBL_729:
        ADDA.L D1,A0
        MOVE.B 1(A0),D0
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.L D0,D1
        MOVEQ #48,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_730
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.L D0,D1
        MOVEQ #57,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_731
LBL_730:
        MOVEQ #1,D0
LBL_731:
        TST.L D0
        BEQ.W LBL_732
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_725
LBL_732:
        MOVE.L -8(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_224
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.L D0,D1
        MOVEQ #48,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_727
LBL_728:
        MOVE.L -8(A6),D0
        BRA.W LBL_725
LBL_725:
        UNLK A6
        RTS
        ; func rtConnValidBaud  (JT slot 155)
        ;   param b : 8(A6)  size 4
LBL_154:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #300,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_752
        MOVE.L 8(A6),D1
        MOVE.L #600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_753
LBL_752:
        MOVEQ #1,D0
LBL_753:
        TST.L D0
        BNE.W LBL_750
        MOVE.L 8(A6),D1
        MOVE.L #1200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_751
LBL_750:
        MOVEQ #1,D0
LBL_751:
        TST.L D0
        BNE.W LBL_748
        MOVE.L 8(A6),D1
        MOVE.L #1800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_749
LBL_748:
        MOVEQ #1,D0
LBL_749:
        TST.L D0
        BNE.W LBL_746
        MOVE.L 8(A6),D1
        MOVE.L #2400,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_747
LBL_746:
        MOVEQ #1,D0
LBL_747:
        TST.L D0
        BNE.W LBL_744
        MOVE.L 8(A6),D1
        MOVE.L #3600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_745
LBL_744:
        MOVEQ #1,D0
LBL_745:
        TST.L D0
        BNE.W LBL_742
        MOVE.L 8(A6),D1
        MOVE.L #4800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_743
LBL_742:
        MOVEQ #1,D0
LBL_743:
        TST.L D0
        BNE.W LBL_740
        MOVE.L 8(A6),D1
        MOVE.L #7200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_741
LBL_740:
        MOVEQ #1,D0
LBL_741:
        TST.L D0
        BNE.W LBL_738
        MOVE.L 8(A6),D1
        MOVE.L #9600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_739
LBL_738:
        MOVEQ #1,D0
LBL_739:
        TST.L D0
        BNE.W LBL_736
        MOVE.L 8(A6),D1
        MOVE.L #19200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_737
LBL_736:
        MOVEQ #1,D0
LBL_737:
        TST.L D0
        BNE.W LBL_734
        MOVE.L 8(A6),D1
        MOVE.L #57600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_735
LBL_734:
        MOVEQ #1,D0
LBL_735:
        BRA.W LBL_733
LBL_733:
        UNLK A6
        RTS
        ; func rtConnSetFailed  (JT slot 156)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_155:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2288(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
LBL_754:
        UNLK A6
        RTS
        ; func rtConnOpen  (JT slot 157)
        ;   param h : 16(A6)  size 4
        ;   param transport : 12(A6)  size 4
        ;   param spec : 8(A6)  size 4
        ;   local devErr : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
LBL_156:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_756
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_756:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_757
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-1,D0
        MOVE.L D0,-(A7)
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_155
        ADDA.W #12,A7
        BRA.W LBL_755
LBL_757:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_758
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_174
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_759
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_155
        ADDA.W #12,A7
        BRA.W LBL_755
LBL_759:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_755
LBL_758:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_760
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 1738(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_761
        MOVE.L -4(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_762
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_155
        ADDA.W #12,A7
        BRA.W LBL_763
LBL_762:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_155
        ADDA.W #12,A7
LBL_763:
        BRA.W LBL_755
LBL_761:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_755
LBL_760:
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_152
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_764
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-2,D0
        MOVE.L D0,-(A7)
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_155
        ADDA.W #12,A7
        BRA.W LBL_755
LBL_764:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2292(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -2296(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_164
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_765
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_155
        ADDA.W #12,A7
        BRA.W LBL_755
LBL_765:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_755:
        UNLK A6
        RTS
        ; func rtConnSendText  (JT slot 158)
        ;   param h : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local scratch : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local wErr : -16(A6)  size 4
        ;   local slot : -20(A6)  size 4
LBL_157:
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
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_767
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_767:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_768
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_768:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_769
        BRA.W LBL_766
LBL_769:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_770
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_771
        MOVEQ #108,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2288(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
LBL_771:
        BRA.W LBL_766
LBL_770:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_772:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_773
        MOVE.L -4(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_772
LBL_773:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_774
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_775
LBL_774:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_776
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1762(A5)
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_777
LBL_776:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_167
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
LBL_777:
LBL_775:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_778
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_779
LBL_778:
        MOVEQ #0,D0
LBL_779:
        TST.L D0
        BEQ.W LBL_780
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2288(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
LBL_780:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
LBL_766:
        UNLK A6
        RTS
        ; func rtConnSendStr  (JT slot 159)
        ;   param h : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_158:
        LINK A6,#-56
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_157
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_781:
        UNLK A6
        RTS
        ; func rtConnClose  (JT slot 160)
        ;   param h : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_159:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_783
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_783:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_784
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1786(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_782
LBL_784:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_785
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_177
        ADDQ.L #4,A7
        BRA.W LBL_786
LBL_785:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_168
        ADDQ.L #4,A7
LBL_786:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_782:
        UNLK A6
        RTS
        ; func rtConnPump  (JT slot 161)
        ;   local i : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local code : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local j : -20(A6)  size 4
        ;   local e : -24(A6)  size 4
        ;   local gone : -26(A6)  size 2
        ;   local __store1 : -30(A6)  size 4
        ;   local __store2 : -34(A6)  size 4
LBL_160:
        LINK A6,#-90
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
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
        LEA -30(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -34(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_788:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_789
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_790
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2298(A5)
        ADDQ.L #4,A7
        BRA.W LBL_791
LBL_790:
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_792
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2288(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 2322(A5)
        ADDA.W #12,A7
        LEA -2288(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
LBL_792:
LBL_791:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_793
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_794
LBL_793:
        MOVEQ #0,D0
LBL_794:
        TST.L D0
        BEQ.W LBL_795
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_175
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_796
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2298(A5)
        ADDQ.L #4,A7
        BRA.W LBL_797
LBL_796:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_798
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_155
        ADDA.W #12,A7
LBL_798:
LBL_797:
LBL_795:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_799
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1794(A5)
        ADDQ.L #4,A7
        BRA.W LBL_800
LBL_799:
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_801
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_802
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1482(A5)
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
        BRA.W LBL_803
LBL_802:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_169
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
LBL_803:
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BEQ.W LBL_804
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_806
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_177
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_807
LBL_806:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_168
        ADDQ.L #4,A7
LBL_807:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2314(A5)
        ADDQ.L #4,A7
        BRA.W LBL_805
LBL_804:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_808
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_176
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_810
        LEA -30(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_16
        MOVE.L D0,-38(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L -38(A6),D0
        MOVE.L D0,-30(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -30(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-30(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_811
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2306(A5)
        ADDQ.L #8,A7
LBL_811:
LBL_810:
        BRA.W LBL_809
LBL_808:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_165
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_812
        LEA -34(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_16
        MOVE.L D0,-38(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -34(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_165
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_813:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_814
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_166
        ADDQ.L #4,A7
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_813
LBL_814:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2306(A5)
        ADDQ.L #8,A7
LBL_812:
LBL_809:
LBL_805:
LBL_801:
LBL_800:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_788
LBL_789:
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_787:
        UNLK A6
        RTS
        ; func rtConnAlive  (JT slot 162)
        ;   local i : -4(A6)  size 4
LBL_161:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_816:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_817
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_820
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_821
LBL_820:
        MOVEQ #1,D0
LBL_821:
        TST.L D0
        BNE.W LBL_818
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_819
LBL_818:
        MOVEQ #1,D0
LBL_819:
        TST.L D0
        BEQ.W LBL_822
        MOVEQ #1,D0
        BRA.W LBL_815
LBL_822:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_816
LBL_817:
        JSR 1802(A5)
        BRA.W LBL_815
LBL_815:
        UNLK A6
        RTS
        ; func rtConn68kName  (JT slot 163)
        ;   param s : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_162:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_824:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_825
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVEA.L (A7)+,A0
        CLR.L D0
        MOVE.B (A0),D0
        CMP.L D0,D1
        BCS.W LBL_826
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
LBL_826:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_824
LBL_825:
        MOVE.L -4(A6),D0
        BRA.W LBL_823
LBL_823:
        UNLK A6
        RTS
        ; func rtConn68kBaudWord  (JT slot 164)
        ;   param baud : 8(A6)  size 4
LBL_163:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #300,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_828
        MOVE.L #380,D0
        BRA.W LBL_827
LBL_828:
        MOVE.L 8(A6),D1
        MOVE.L #600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_829
        MOVE.L #189,D0
        BRA.W LBL_827
LBL_829:
        MOVE.L 8(A6),D1
        MOVE.L #1200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_830
        MOVEQ #94,D0
        BRA.W LBL_827
LBL_830:
        MOVE.L 8(A6),D1
        MOVE.L #1800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_831
        MOVEQ #62,D0
        BRA.W LBL_827
LBL_831:
        MOVE.L 8(A6),D1
        MOVE.L #2400,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_832
        MOVEQ #46,D0
        BRA.W LBL_827
LBL_832:
        MOVE.L 8(A6),D1
        MOVE.L #3600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_833
        MOVEQ #30,D0
        BRA.W LBL_827
LBL_833:
        MOVE.L 8(A6),D1
        MOVE.L #4800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_834
        MOVEQ #22,D0
        BRA.W LBL_827
LBL_834:
        MOVE.L 8(A6),D1
        MOVE.L #7200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_835
        MOVEQ #14,D0
        BRA.W LBL_827
LBL_835:
        MOVE.L 8(A6),D1
        MOVE.L #9600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_836
        MOVEQ #10,D0
        BRA.W LBL_827
LBL_836:
        MOVE.L 8(A6),D1
        MOVE.L #19200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_837
        MOVEQ #4,D0
        BRA.W LBL_827
LBL_837:
        MOVEQ #0,D0
        BRA.W LBL_827
LBL_827:
        UNLK A6
        RTS
        ; func rtConnDevOpen  (JT slot 165)
        ;   param slot : 16(A6)  size 4
        ;   param portIdx : 12(A6)  size 4
        ;   param baud : 8(A6)  size 4
        ;   local outName : -256(A6)  size 256
        ;   local inName : -512(A6)  size 256
        ;   local outPb : -562(A6)  size 50
        ;   local inPb : -612(A6)  size 50
        ;   local setBufPb : -662(A6)  size 50
        ;   local resetPb : -712(A6)  size 50
        ;   local err : -716(A6)  size 4
LBL_164:
        LINK A6,#-768
        LEA -256(A6),A0
        CLR.B (A0)
        LEA -512(A6),A0
        CLR.B (A0)
        LEA -562(A6),A0
        MOVE.W #11,D0
LBL_839:
        CLR.L (A0)+
        DBRA D0,LBL_839
        CLR.W (A0)+
        LEA -612(A6),A0
        MOVE.W #11,D0
LBL_840:
        CLR.L (A0)+
        DBRA D0,LBL_840
        CLR.W (A0)+
        LEA -662(A6),A0
        MOVE.W #11,D0
LBL_841:
        CLR.L (A0)+
        DBRA D0,LBL_841
        CLR.W (A0)+
        LEA -712(A6),A0
        MOVE.W #11,D0
LBL_842:
        CLR.L (A0)+
        DBRA D0,LBL_842
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-716(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_843
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        BRA.W LBL_844
LBL_843:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_219(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
LBL_844:
        LEA -544(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -562(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; PBOpenSync
        MOVE.L D0,-716(A6)
        MOVE.L -716(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_845
        MOVE.L -716(A6),D0
        BRA.W LBL_838
LBL_845:
        LEA -538(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -2328(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -594(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -612(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; PBOpenSync
        MOVE.L D0,-716(A6)
        MOVE.L -716(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_846
        MOVE.L -716(A6),D0
        BRA.W LBL_838
LBL_846:
        LEA -588(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -2360(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -638(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -588(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -636(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #9,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -634(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #8192,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -634(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_847
        MOVEQ #108,D0
        NEG.L D0
        BRA.W LBL_838
LBL_847:
        LEA -630(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #8192,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -662(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-716(A6)
        MOVE.L -716(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_848
        MOVE.L -716(A6),D0
        BRA.W LBL_838
LBL_848:
        LEA -688(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -538(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -686(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -684(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_163
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L #3072,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #16384,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -712(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        BRA.W LBL_838
LBL_838:
        UNLK A6
        RTS
        ; func rtConnDevAvail  (JT slot 166)
        ;   param slot : 8(A6)  size 4
        ;   local countPb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_165:
        LINK A6,#-106
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_850:
        CLR.L (A0)+
        DBRA D0,LBL_850
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2360(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -24(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -50(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A005  ; PBStatusSync
        MOVE.L D0,-54(A6)
        MOVE.L -54(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_851
        MOVEQ #0,D0
        BRA.W LBL_849
LBL_851:
        LEA -22(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_849
LBL_849:
        UNLK A6
        RTS
        ; func rtConnDevReadByte  (JT slot 167)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_166:
        LINK A6,#-106
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_853:
        CLR.L (A0)+
        DBRA D0,LBL_853
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        MOVE.L -2364(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_854
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-2364(A5)
LBL_854:
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2360(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -18(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -2364(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -14(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -50(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; PBReadSync
        MOVE.L D0,-54(A6)
        MOVE.L -54(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_855
        MOVEQ #0,D0
        BRA.W LBL_852
LBL_855:
        MOVE.L -2364(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_852
LBL_852:
        UNLK A6
        RTS
        ; func rtConnDevWrite  (JT slot 168)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_167:
        LINK A6,#-102
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_857:
        CLR.L (A0)+
        DBRA D0,LBL_857
        CLR.W (A0)+
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2328(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -18(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -14(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -50(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; PBWriteSync
        BRA.W LBL_856
LBL_856:
        UNLK A6
        RTS
        ; func rtConnDevClose  (JT slot 169)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_168:
        LINK A6,#-102
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_859:
        CLR.L (A0)+
        DBRA D0,LBL_859
        CLR.W (A0)+
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2360(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -50(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; PBCloseSync
LBL_858:
        UNLK A6
        RTS
        ; func rtConnDevGone  (JT slot 170)
        ;   param slot : 8(A6)  size 4
LBL_169:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_860
LBL_860:
        UNLK A6
        RTS
        ; func rtAtEnsureUp  (JT slot 171)
        ;   local e : -4(A6)  size 4
LBL_170:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 1562(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_862
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_861
LBL_862:
        MOVEQ #1,D0
        MOVE.B D0,-2366(A5)
        MOVEQ #0,D0
        BRA.W LBL_861
LBL_861:
        UNLK A6
        RTS
        ; func rtAdspFailed  (JT slot 172)
        ;   param slot : 8(A6)  size 4
LBL_171:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_863:
        UNLK A6
        RTS
        ; func rtAtTextToPtr  (JT slot 173)
        ;   param t : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_172:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_865
        MOVEQ #0,D0
        BRA.W LBL_864
LBL_865:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_866
        MOVEQ #0,D0
        BRA.W LBL_864
LBL_866:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_867:
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_868
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_867
LBL_868:
        MOVE.L -4(A6),D0
        BRA.W LBL_864
LBL_864:
        UNLK A6
        RTS
        ; func rtAtAppendBytes  (JT slot 174)
        ;   param t : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
LBL_173:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_870
        BRA.W LBL_869
LBL_870:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_871:
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_872
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_871
LBL_872:
LBL_869:
        UNLK A6
        RTS
        ; func rtAdspOpenName  (JT slot 175)
        ;   param slot : 12(A6)  size 4
        ;   param spec : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local idx : -8(A6)  size 4
LBL_174:
        LINK A6,#-1084
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #58,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_874
        MOVE.L #-1025,D0
        BRA.W LBL_873
LBL_874:
        BSR.W LBL_170
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_875
        MOVE.L -4(A6),D0
        BRA.W LBL_873
LBL_875:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #16,A7
        LEA -524(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #16,A7
        LEA -1036(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1036(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_220(PC),A0
        MOVE.L A0,-(A7)
        JSR 1578(A5)
        ADDA.W #16,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_876
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_873
LBL_876:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_873
LBL_873:
        UNLK A6
        RTS
        ; func rtAdspPoll  (JT slot 176)
        ;   param slot : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local addr : -8(A6)  size 4
LBL_175:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_878
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1586(A5)
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_879
        MOVEQ #0,D0
        BRA.W LBL_877
LBL_879:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_880
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L #-1025,D0
        BRA.W LBL_877
LBL_880:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 1610(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1658(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_881
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_877
LBL_881:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_877
LBL_878:
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_882
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1666(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_883
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_224
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_877
LBL_883:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_884
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_877
LBL_884:
        MOVEQ #0,D0
        BRA.W LBL_877
LBL_882:
        MOVEQ #0,D0
        BRA.W LBL_877
LBL_877:
        UNLK A6
        RTS
        ; func rtAdspAvail  (JT slot 177)
        ;   param slot : 8(A6)  size 4
LBL_176:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1674(A5)
        ADDQ.L #4,A7
        BRA.W LBL_885
LBL_885:
        UNLK A6
        RTS
        ; func rtAdspClose  (JT slot 178)
        ;   param slot : 8(A6)  size 4
LBL_177:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1706(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
LBL_886:
        UNLK A6
        RTS
LBL_224:
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
LBL_225:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_887
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_222(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_887:
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
        BPL.W LBL_888
        NEG.L D2
        MOVE.L #1,D4
LBL_888:
        CLR.L D5
        TST.L D3
        BPL.W LBL_889
        NEG.L D3
        MOVE.L #1,D5
LBL_889:
        CLR.L D6
        MOVE.W #31,D7
LBL_890:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_891
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_891:
        DBRA D7,LBL_890
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_892
        NEG.L D2
LBL_892:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_226:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_893
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_222(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_893:
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
        BPL.W LBL_894
        NEG.L D2
        MOVE.L #1,D4
LBL_894:
        CLR.L D5
        TST.L D3
        BPL.W LBL_895
        NEG.L D3
        MOVE.L #1,D5
LBL_895:
        CLR.L D6
        MOVE.W #31,D7
LBL_896:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_897
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_897:
        DBRA D7,LBL_896
        TST.L D4
        BEQ.W LBL_898
        NEG.L D6
LBL_898:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_227:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_899(PC),A0
        MOVE.L A0,-4(A6)
LBL_900:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_901
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_902
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_900
LBL_902:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_903:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_900
LBL_901:
        UNLK A6
        RTS
LBL_899:
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
        DC.W $0000
        DC.W $0000
        ; constant pool: string literals
LBL_222:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_178:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_179:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_180:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_181:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_182:
        DC.B $01
        DC.B $30
LBL_183:
        DC.B $00
        DC.B $00
LBL_184:
        DC.B $01
        DC.B $2D
LBL_185:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_186:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_187:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_188:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_189:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_190:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_191:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_192:
        DC.B $01
        DC.B $3F
LBL_194:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_193:
        DC.B $01
        DC.B $20
LBL_195:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_196:
        DC.B $01
        DC.B $2E
LBL_197:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_198:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_199:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_200:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_201:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_202:
        DC.B $0B
        DC.B $2E,$53,$65,$6C,$65,$63,$74,$41,$6C,$6C,$20
LBL_203:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_204:
        DC.B $2A
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$6D,$75,$73,$74,$20,$68,$61,$76,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$65,$6E,$74,$72,$69,$65,$73
        DC.B $00
LBL_205:
        DC.B $31
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$65,$6E,$74,$72,$79,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_221:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_206:
        DC.B $08
        DC.B $53,$61,$76,$65,$20,$61,$73,$3A
        DC.B $00
LBL_207:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_208:
        DC.B $05
        DC.B $6D,$6F,$64,$65,$6D
LBL_209:
        DC.B $07
        DC.B $70,$72,$69,$6E,$74,$65,$72
LBL_210:
        DC.B $15
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_211:
        DC.B $17
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_212:
        DC.B $19
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_213:
        DC.B $17
        DC.B $69,$6E,$76,$61,$6C,$69,$64,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$73,$70,$65,$63
LBL_214:
        DC.B $13
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E
LBL_215:
        DC.B $0C
        DC.B $77,$72,$69,$74,$65,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_216:
        DC.B $05
        DC.B $2E,$41,$4F,$75,$74
LBL_217:
        DC.B $04
        DC.B $2E,$41,$49,$6E
        DC.B $00
LBL_218:
        DC.B $05
        DC.B $2E,$42,$4F,$75,$74
LBL_219:
        DC.B $04
        DC.B $2E,$42,$49,$6E
        DC.B $00
LBL_220:
        DC.B $01
        DC.B $2A
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (44 bytes)
LBL_223:
        DC.B $43
        DC.B $4C
        DC.B $55
        DC.B $49
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $02
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
