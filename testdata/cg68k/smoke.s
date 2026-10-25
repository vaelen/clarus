LBL_242:
        ; startup (JT slot 0)
        ; globals (below A5, 7422 bytes total):
        ;   rtListObsBlk : -4(A5)  size 4  type ptr
        ;   rtListObsCount : -8(A5)  size 4  type int
        ;   rtUiMenuHandlesArr : -12(A5)  size 4  type ptr
        ;   rtUiNMenusVal : -16(A5)  size 4  type int
        ;   rtUiClaimedMask : -20(A5)  size 4  type int
        ;   rtUiBarMask : -24(A5)  size 4  type int
        ;   rtUiAppleMenuHandle : -28(A5)  size 4  type ptr
        ;   rtUiStdEditMenuIdx : -32(A5)  size 4  type int
        ;   rtUiSys7 : -34(A5)  size 1  type bool
        ;   rtUiEveryDueArr : -38(A5)  size 4  type ptr
        ;   rtUiNEveryVal : -42(A5)  size 4  type int
        ;   rtUiEmptyPStrCache : -46(A5)  size 4  type ptr
        ;   rtUiScratchBitMap : -50(A5)  size 4  type ptr
        ;   rtUiGrayPats : -54(A5)  size 4  type ptr
        ;   rtUiScripted : -56(A5)  size 1  type bool
        ;   rtUiScriptDbl : -58(A5)  size 1  type bool
        ;   rtUiJiggle : -60(A5)  size 1  type bool
        ;   rtUiJiggleBusy : -62(A5)  size 1  type bool
        ;   rtUiAnswerKinds : -66(A5)  size 4  type ptr
        ;   rtUiAnswerVals : -70(A5)  size 4  type ptr
        ;   rtUiAnswerStrs : -74(A5)  size 4  type ptr
        ;   rtUiAnswerHead : -78(A5)  size 4  type int
        ;   rtUiAnswerTail : -82(A5)  size 4  type int
        ;   rtUiTraceSuppressed : -84(A5)  size 1  type bool
        ;   rtUiTraceWinCounts : -88(A5)  size 4  type ptr
        ;   rtUiTraceLastFront : -92(A5)  size 4  type ptr
        ;   rtUiDimPrevArr : -96(A5)  size 4  type ptr
        ;   rtUiDimFirst : -98(A5)  size 1  type bool
        ;   rtUiStdEditDimPrev : -100(A5)  size 1  type bool
        ;   rtUiScriptCursor : -104(A5)  size 4  type ptr
        ;   rtUiScriptCursorInit : -106(A5)  size 1  type bool
        ;   rtUiScriptLineBuf : -110(A5)  size 4  type ptr
        ;   rtUiScriptLineLen : -114(A5)  size 4  type int
        ;   rtUiVerbBuf : -118(A5)  size 4  type ptr
        ;   rtUiArg1Buf : -122(A5)  size 4  type ptr
        ;   rtUiArg2Buf : -126(A5)  size 4  type ptr
        ;   rtUiVirtualTicks : -130(A5)  size 4  type int
        ;   rtUiModalActive : -132(A5)  size 1  type bool
        ;   rtUiModalInst : -136(A5)  size 4  type ptr
        ;   rtUiModalBufH : -140(A5)  size 4  type ptr
        ;   rtUiModalBuf : -144(A5)  size 4  type ptr
        ;   rtUiModalIsNew : -146(A5)  size 1  type bool
        ;   rtUiModalWbKind : -150(A5)  size 4  type int
        ;   rtUiModalAddr : -154(A5)  size 4  type ptr
        ;   rtUiModalLst : -158(A5)  size 4  type ptr
        ;   rtUiModalIdx : -162(A5)  size 4  type int
        ;   rtUiModalMp : -166(A5)  size 4  type ptr
        ;   rtUiModalKey255 : -170(A5)  size 4  type ptr
        ;   rtSerPos : -174(A5)  size 4  type int
        ;   rtSerBad : -176(A5)  size 1  type bool
        ;   rtConnState : -208(A5)  size 32  type arr
        ;   rtConnPendOpened : -216(A5)  size 8  type arr
        ;   rtConnPendFailedCode : -248(A5)  size 32  type arr
        ;   rtConnPendFailedMsg : -2296(A5)  size 2048  type arr
        ;   rtConnParsePortIdx : -2300(A5)  size 4  type int
        ;   rtConnParseBaud : -2304(A5)  size 4  type int
        ;   rtConnOutRef : -2336(A5)  size 32  type arr
        ;   rtConnInRef : -2368(A5)  size 32  type arr
        ;   rtConnReadBuf : -2372(A5)  size 4  type ptr
        ;   rtAtUp : -2374(A5)  size 1  type bool
        ;   rtLsnState : -2382(A5)  size 8  type arr
        ;   rtLsnPendFailedCode : -2390(A5)  size 8  type arr
        ;   rtLsnPendFailedMsg : -2902(A5)  size 512  type arr
        ;   rtBrsState : -2910(A5)  size 8  type arr
        ;   rtBrsPendFailedCode : -2918(A5)  size 8  type arr
        ;   rtBrsPendFailedMsg : -3430(A5)  size 512  type arr
        ;   rtSvcState : -3438(A5)  size 8  type arr
        ;   rtSvcSock : -3446(A5)  size 8  type arr
        ;   rtSvcArmed : -3448(A5)  size 2  type arr
        ;   rtSvcInHandler : -3450(A5)  size 2  type arr
        ;   rtSvcReplied : -3452(A5)  size 2  type arr
        ;   rtSvcPendFailedCode : -3460(A5)  size 8  type arr
        ;   rtSvcPendFailedMsg : -3972(A5)  size 512  type arr
        ;   rtSvcName : -4484(A5)  size 512  type arr
        ;   rtSvcType : -4996(A5)  size 512  type arr
        ;   rtLsnName : -5508(A5)  size 512  type arr
        ;   rtLsnType : -6020(A5)  size 512  type arr
        ;   rtAdspPhase : -6052(A5)  size 32  type arr
        ;   rtConnSlotTransport : -6084(A5)  size 32  type arr
        ;   rtAtLastErr : -6088(A5)  size 4  type int
        ;   rtAt68MppRef : -6092(A5)  size 4  type int
        ;   rtAt68AtpRef : -6096(A5)  size 4  type int
        ;   rtAt68XppRef : -6100(A5)  size 4  type int
        ;   rtAt68DspRef : -6104(A5)  size 4  type int
        ;   rtAt68Up : -6106(A5)  size 1  type bool
        ;   rtAt68LastErr : -6110(A5)  size 4  type int
        ;   rtAt68LkPb : -6154(A5)  size 44  type arr
        ;   rtAt68LkEntity : -6198(A5)  size 44  type arr
        ;   rtAt68LkBuf : -6242(A5)  size 44  type arr
        ;   rtAt68Nte : -6258(A5)  size 16  type arr
        ;   rtAt68NteUsed : -6262(A5)  size 4  type arr
        ;   rtAt68SvcGetPb : -6270(A5)  size 8  type arr
        ;   rtAt68SvcReqBuf : -6278(A5)  size 8  type arr
        ;   rtAt68SvcRespPb : -6286(A5)  size 8  type arr
        ;   rtAt68SvcRespBuf : -6294(A5)  size 8  type arr
        ;   rtAt68SvcBds : -6302(A5)  size 8  type arr
        ;   rtAt68SvcSock : -6310(A5)  size 8  type arr
        ;   rtAt68SvcGetLive : -6312(A5)  size 2  type arr
        ;   rtAt68SvcReqOp : -6320(A5)  size 8  type arr
        ;   rtAt68SvcReqFrom : -6328(A5)  size 8  type arr
        ;   rtAt68SvcReqLen : -6336(A5)  size 8  type arr
        ;   rtAt68SvcTransID : -6344(A5)  size 8  type arr
        ;   rtAt68SvcXO : -6352(A5)  size 8  type arr
        ;   rtAt68CallBuf : -6356(A5)  size 4  type ptr
        ;   rtAt68CallBds : -6360(A5)  size 4  type ptr
        ;   rtAt68CallCode : -6364(A5)  size 4  type int
        ;   rtAt68LsnCcb : -6372(A5)  size 8  type arr
        ;   rtAt68LsnPb : -6380(A5)  size 8  type arr
        ;   rtAt68LsnRef : -6388(A5)  size 8  type arr
        ;   rtAt68LsnLive : -6390(A5)  size 2  type arr
        ;   rtAt68Ccb : -6422(A5)  size 32  type arr
        ;   rtAt68Pb : -6454(A5)  size 32  type arr
        ;   rtAt68SendQ : -6486(A5)  size 32  type arr
        ;   rtAt68RecvQ : -6518(A5)  size 32  type arr
        ;   rtAt68Attn : -6550(A5)  size 32  type arr
        ;   rtAt68CcbRef : -6582(A5)  size 32  type arr
        ;   rtAt68OpenLive : -6590(A5)  size 8  type arr
        ;   rtAt68DspAux : -6594(A5)  size 4  type ptr
        ;   rtTcpPhase : -6626(A5)  size 32  type arr
        ;   rtTcpPending : -6658(A5)  size 32  type arr
        ;   rtTcpCloseSent : -6666(A5)  size 8  type arr
        ;   rtTcpCloseTick : -6698(A5)  size 32  type arr
        ;   rtTcpUp : -6700(A5)  size 1  type bool
        ;   rtLsnSlotTransport : -6708(A5)  size 8  type arr
        ;   rtLsnPort : -6716(A5)  size 8  type arr
        ;   rtTcpLastErr : -6720(A5)  size 4  type int
        ;   rtTcpParseIp : -6724(A5)  size 4  type int
        ;   rtTcpParsePort : -6728(A5)  size 4  type int
        ;   rtTcp68Ref : -6732(A5)  size 4  type int
        ;   rtTcp68LastErr : -6736(A5)  size 4  type int
        ;   rtTcp68Aux : -6740(A5)  size 4  type int
        ;   rtTcp68Stream : -6772(A5)  size 32  type arr
        ;   rtTcp68Buf : -6804(A5)  size 32  type arr
        ;   rtTcp68Rcv : -6836(A5)  size 32  type arr
        ;   rtTcp68Snd : -6868(A5)  size 32  type arr
        ;   rtTcp68RcvPb : -6900(A5)  size 32  type arr
        ;   rtTcp68Pb : -6932(A5)  size 32  type arr
        ;   rtTcp68Wds : -6964(A5)  size 32  type arr
        ;   rtTcp68RcvLive : -6972(A5)  size 8  type arr
        ;   rtTcp68PbLive : -6980(A5)  size 8  type arr
        ;   rtTcp68PbOp : -7012(A5)  size 32  type arr
        ;   rtTcp68RcvGot : -7044(A5)  size 32  type arr
        ;   rtTcp68LsnStream : -7052(A5)  size 8  type arr
        ;   rtTcp68LsnBuf : -7060(A5)  size 8  type arr
        ;   rtTcp68LsnPb : -7068(A5)  size 8  type arr
        ;   rtTcp68LsnLive : -7070(A5)  size 2  type arr
        ;   rtTcp68LsnReady : -7072(A5)  size 2  type arr
        ;   natPb : -7076(A5)  size 4  type ptr
        ;   natBuf : -7080(A5)  size 4  type ptr
        ;   natDigits : -7084(A5)  size 4  type ptr
        ;   natLogBuf : -7088(A5)  size 4  type ptr
        ;   natLogLen : -7092(A5)  size 4  type int
        ;   natRef : -7096(A5)  size 4  type int
        ;   natOpened : -7098(A5)  size 1  type bool
        ;   natDone : -7100(A5)  size 1  type bool
        ;   natArgs : -7104(A5)  size 4  type list
        ;   natCapture : -7106(A5)  size 1  type bool
        ;   natWlPb : -7110(A5)  size 4  type ptr
        ;   natWlBuf : -7114(A5)  size 4  type ptr
        ;   natWlName : -7118(A5)  size 4  type ptr
        ;   natWlVRef : -7122(A5)  size 4  type int
        ;   natWlLen : -7126(A5)  size 4  type int
        ;   natWlOpen : -7128(A5)  size 1  type bool
        ;   natTraceOn : -7130(A5)  size 1  type bool
        ;   natPanicBuf : -7134(A5)  size 4  type ptr
        ;   natEmptyStr : -7138(A5)  size 4  type ptr
        ;   natErrCode : -7142(A5)  size 4  type int
        ;   natErrMsg : -7398(A5)  size 256  type str
        ;   natFilePb : -7402(A5)  size 4  type ptr
        ;   natFileReady : -7404(A5)  size 1  type bool
        ;   natUiEmitBuf : -7408(A5)  size 4  type ptr
        ;   natQdInited : -7410(A5)  size 1  type bool
        ;   natQdGlobals : -7414(A5)  size 4  type ptr
        ;   rtFh68kLastErr : -7418(A5)  size 4  type int
        ;   rtFh68kState : -7422(A5)  size 4  type ptr
        LEA -7422(A5),A0
        MOVE.W #3710,D0
LBL_244:
        CLR.W (A0)+
        DBRA D0,LBL_244
        MOVEA.L $0130.W,A0
        ADDA.L #-38564,A0
        DC.W $A02D  ; _SetApplLimit
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_243
        BSR.W LBL_90
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR 1122(A5)
        BSR.W LBL_241
        CLR.L -(A7)
        BSR.W LBL_101
        RTS
LBL_243:
        ; cg_init_globals
        LINK A6,#-48
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-32(A5)
        MOVE.L #1,D0
        MOVE.B D0,-98(A5)
        LEA -6658(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6654(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6650(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6646(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6642(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6638(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6634(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6630(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -7104(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
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
        BSR.W LBL_103
        ADDQ.L #8,A7
LBL_245:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-52
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_102
        ADDQ.L #4,A7
LBL_246:
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
        BEQ.W LBL_248
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_247
LBL_248:
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
        BEQ.W LBL_249
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
LBL_249:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_250
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
LBL_250:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_251
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
LBL_251:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_252
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
LBL_252:
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
        BRA.W LBL_247
LBL_247:
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
        BRA.W LBL_253
LBL_253:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 5)
        ;   param v : 14(A6)  size 4
        ;   param found : 12(A6)  size 2
        ;   param name : 8(A6)  size 4
LBL_4:
        LINK A6,#-52
        CLR.L D0
        MOVE.B 12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_255:
        MOVE.L 14(A6),D0
        BRA.W LBL_254
LBL_254:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 6)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_5:
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
        BEQ.W LBL_257
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_258
LBL_257:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_258:
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
        BEQ.W LBL_259
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_259:
LBL_256:
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
        BEQ.W LBL_261
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_262
LBL_261:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_262:
        MOVE.L -4(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_263
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_264
LBL_263:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_264:
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
        BEQ.W LBL_265
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_265:
LBL_260:
        UNLK A6
        RTS
        ; func rtStrCmp  (JT slot 8)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local ca : -20(A6)  size 4
        ;   local cb : -24(A6)  size 4
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
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_268
LBL_267:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_268:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_269:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_270
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
        BEQ.W LBL_271
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_266
LBL_271:
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_272
        MOVEQ #1,D0
        BRA.W LBL_266
LBL_272:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_269
LBL_270:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_273
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_266
LBL_273:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_274
        MOVEQ #1,D0
        BRA.W LBL_266
LBL_274:
        MOVEQ #0,D0
        BRA.W LBL_266
LBL_266:
        UNLK A6
        RTS
        ; func rtStrLen  (JT slot 9)
        ;   param s : 8(A6)  size 4
LBL_8:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_275
LBL_275:
        UNLK A6
        RTS
        ; func rtStrIndex  (JT slot 10)
        ;   param s : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_277
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
        BRA.W LBL_278
LBL_277:
        MOVEQ #1,D0
LBL_278:
        TST.L D0
        BEQ.W LBL_279
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_279:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_276
LBL_276:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 11)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_10:
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
        BEQ.W LBL_281
        BRA.W LBL_280
LBL_281:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_282
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_283
LBL_282:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_283:
LBL_284:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_238
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
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_286
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_286:
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
        ; func rtTextNew  (JT slot 12)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_11:
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
        BEQ.W LBL_288
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_288:
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
        BEQ.W LBL_289
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_289:
        MOVE.L -4(A6),D0
        BRA.W LBL_287
LBL_287:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 13)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_12:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_291
        BRA.W LBL_290
LBL_291:
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
LBL_290:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 14)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_13:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_293
        BRA.W LBL_292
LBL_293:
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
        BEQ.W LBL_294
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_294:
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
        BEQ.W LBL_295
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
LBL_295:
LBL_292:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 15)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_14:
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
        BSR.W LBL_10
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
LBL_296:
        UNLK A6
        RTS
        ; func rtTextConcat  (JT slot 16)
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
LBL_15:
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_298
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_299
LBL_298:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
LBL_299:
        MOVE.L -16(A6),D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_300
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_301
LBL_300:
        MOVEQ #1,D0
        MOVE.L D0,-28(A6)
LBL_301:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; TextNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_302:
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
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_303
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        BRA.W LBL_304
LBL_303:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
LBL_304:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
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
LBL_297:
        UNLK A6
        RTS
        ; func rtTextCmp  (JT slot 17)
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
LBL_16:
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
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_306
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_307
LBL_306:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_307:
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
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
LBL_308:
        MOVE.L -24(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_309
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-36(A6)
        MOVE.L -32(A6),D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L -36(A6),D1
        MOVE.L -40(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_310
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_305
LBL_310:
        MOVE.L -36(A6),D1
        MOVE.L -40(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_311
        MOVEQ #1,D0
        BRA.W LBL_305
LBL_311:
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-24(A6)
        BRA.W LBL_308
LBL_309:
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_312
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_305
LBL_312:
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_313
        MOVEQ #1,D0
        BRA.W LBL_305
LBL_313:
        MOVEQ #0,D0
        BRA.W LBL_305
LBL_305:
        UNLK A6
        RTS
        ; func rtTextCmpStr  (JT slot 18)
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
LBL_17:
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
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_315
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_316
LBL_315:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_316:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_317:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        MOVE.L -24(A6),D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D1
        MOVE.L -32(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_319
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_314
LBL_319:
        MOVE.L -28(A6),D1
        MOVE.L -32(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_320
        MOVEQ #1,D0
        BRA.W LBL_314
LBL_320:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_317
LBL_318:
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_321
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_314
LBL_321:
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_322
        MOVEQ #1,D0
        BRA.W LBL_314
LBL_322:
        MOVEQ #0,D0
        BRA.W LBL_314
LBL_314:
        UNLK A6
        RTS
        ; func rtTextLen  (JT slot 19)
        ;   param t : 8(A6)  size 4
LBL_18:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_323
LBL_323:
        UNLK A6
        RTS
        ; func rtTextIndex  (JT slot 20)
        ;   param t : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_19:
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
        BNE.W LBL_325
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
        BRA.W LBL_326
LBL_325:
        MOVEQ #1,D0
LBL_326:
        TST.L D0
        BEQ.W LBL_327
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_327:
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
        BRA.W LBL_324
LBL_324:
        UNLK A6
        RTS
        ; func rtTextToBytes  (JT slot 21)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_20:
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
        BEQ.W LBL_329
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_330
LBL_329:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_330:
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
        BEQ.W LBL_331
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_331:
        MOVE.L -8(A6),D0
        BRA.W LBL_328
LBL_328:
        UNLK A6
        RTS
        ; func rtTextAppendStr  (JT slot 22)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local len0 : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_21:
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
        BSR.W LBL_10
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
LBL_332:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 23)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_22:
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
        BSR.W LBL_10
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
LBL_333:
        UNLK A6
        RTS
        ; func rtListGrow  (JT slot 24)
        ;   param l : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local elemsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
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
        BEQ.W LBL_335
        BRA.W LBL_334
LBL_335:
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
        BEQ.W LBL_336
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_337
LBL_336:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_337:
LBL_338:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_339
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_238
        MOVE.L D0,-12(A6)
        BRA.W LBL_338
LBL_339:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_238
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
        BEQ.W LBL_340
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_340:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_334:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 25)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_24:
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
        BEQ.W LBL_342
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_342:
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
        BEQ.W LBL_343
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_343:
        MOVE.L -4(A6),D0
        BRA.W LBL_341
LBL_341:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 26)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_25:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_345
        BRA.W LBL_344
LBL_345:
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
LBL_344:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 27)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_26:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_347
        BRA.W LBL_346
LBL_347:
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
        BEQ.W LBL_348
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_348:
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
        BEQ.W LBL_349
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
LBL_349:
LBL_346:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 28)
        ;   param l : 8(A6)  size 4
LBL_27:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_351
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_352
LBL_351:
        MOVEQ #0,D0
LBL_352:
        BRA.W LBL_350
LBL_350:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 29)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_28:
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
        BNE.W LBL_354
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
        BRA.W LBL_355
LBL_354:
        MOVEQ #1,D0
LBL_355:
        TST.L D0
        BEQ.W LBL_356
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_356:
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
        BSR.W LBL_238
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        BRA.W LBL_353
LBL_353:
        UNLK A6
        RTS
        ; func rtListObsEnt  (JT slot 30)
        ;   param e : 8(A6)  size 4
LBL_29:
        LINK A6,#-52
        MOVE.L -4(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_238
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_357
LBL_357:
        UNLK A6
        RTS
        ; func rtListObsNote  (JT slot 31)
        ;   param l : 16(A6)  size 4
        ;   param op : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local cap : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
        ;   local o : -12(A6)  size 4
        ;   local m : -16(A6)  size 4
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
        MOVE.L -4(A5),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_359:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_361
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_362
LBL_361:
        MOVEQ #0,D0
LBL_362:
        TST.L D0
        BEQ.W LBL_363
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_364
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_365
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_366
LBL_365:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_367
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_368
LBL_367:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_369
        MOVE.L 8(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_371
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_372
LBL_371:
        MOVE.L 8(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_373
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_373:
LBL_372:
        BRA.W LBL_370
LBL_369:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_374
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_376:
        BRA.W LBL_375
LBL_374:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_377
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_377:
LBL_375:
LBL_370:
LBL_368:
LBL_366:
LBL_364:
LBL_363:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_359
LBL_360:
LBL_358:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 32)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_31:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_379
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
LBL_379:
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
        BSR.W LBL_23
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
        BSR.W LBL_238
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
LBL_378:
        UNLK A6
        RTS
        ; func rtListPop  (JT slot 33)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_32:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_381
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
LBL_381:
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
        BEQ.W LBL_382
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_382:
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
        BSR.W LBL_238
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
LBL_380:
        UNLK A6
        RTS
        ; func rtListShift  (JT slot 34)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local tailBytes : -12(A6)  size 4
LBL_33:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_384
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
LBL_384:
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
        BEQ.W LBL_385
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_385:
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
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_238
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
LBL_383:
        UNLK A6
        RTS
        ; func rtListUnshift  (JT slot 35)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local bodyBytes : -12(A6)  size 4
LBL_34:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_387
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
LBL_387:
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
        BSR.W LBL_23
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
        BSR.W LBL_238
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
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_386:
        UNLK A6
        RTS
        ; func rtListFirst  (JT slot 36)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
LBL_35:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
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
        BEQ.W LBL_389
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_389:
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
LBL_388:
        UNLK A6
        RTS
        ; func rtListLast  (JT slot 37)
        ;   param l : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_36:
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
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_391
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_391:
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
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_238
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
LBL_390:
        UNLK A6
        RTS
        ; func rtListRemove  (JT slot 38)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local tail : -12(A6)  size 4
LBL_37:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_393
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
LBL_393:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_394
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
        BRA.W LBL_395
LBL_394:
        MOVEQ #1,D0
LBL_395:
        TST.L D0
        BEQ.W LBL_396
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_396:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_397
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_238
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
        BSR.W LBL_238
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
        BSR.W LBL_238
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
LBL_397:
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
LBL_392:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 39)
        ;   param l : 8(A6)  size 4
LBL_38:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_398
LBL_398:
        UNLK A6
        RTS
        ; func mapEntrySlot  (JT slot 40)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_39:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_238
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_399
LBL_399:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 41)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_40:
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
        BSR.W LBL_238
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_400
LBL_400:
        UNLK A6
        RTS
        ; func mapIndexSlot  (JT slot 42)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_41:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_238
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_401
LBL_401:
        UNLK A6
        RTS
        ; func mapEntryHash  (JT slot 43)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_42:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_402
LBL_402:
        UNLK A6
        RTS
        ; func mapEntryKeyOff  (JT slot 44)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_43:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_403
LBL_403:
        UNLK A6
        RTS
        ; func mapEntryKeyLen  (JT slot 45)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_44:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_404
LBL_404:
        UNLK A6
        RTS
        ; func mapSetEntryMeta  (JT slot 46)
        ;   param m : 24(A6)  size 4
        ;   param i : 20(A6)  size 4
        ;   param hash : 16(A6)  size 4
        ;   param keyOff : 12(A6)  size 4
        ;   param keyLen : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_45:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
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
LBL_405:
        UNLK A6
        RTS
        ; func mapHash  (JT slot 47)
        ;   param key : 8(A6)  size 4
        ;   local klen : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local h : -12(A6)  size 4
        ;   local b : -16(A6)  size 4
LBL_46:
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
        MOVE.L #5381,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_407:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_408
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
        BRA.W LBL_407
LBL_408:
        MOVE.L -12(A6),D0
        BRA.W LBL_406
LBL_406:
        UNLK A6
        RTS
        ; func mapPoolKeyEq  (JT slot 48)
        ;   param m : 24(A6)  size 4
        ;   param keyOff : 20(A6)  size 4
        ;   param keyLen : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param klen : 8(A6)  size 4
        ;   local base : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_47:
        LINK A6,#-60
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
        BEQ.W LBL_410
        MOVEQ #0,D0
        BRA.W LBL_409
LBL_410:
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
LBL_411:
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_412
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
        BEQ.W LBL_413
        MOVEQ #0,D0
        BRA.W LBL_409
LBL_413:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_411
LBL_412:
        MOVEQ #1,D0
        BRA.W LBL_409
LBL_409:
        UNLK A6
        RTS
        ; func mapIndexFindSlot  (JT slot 49)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local slot : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
        ;   local steps : -20(A6)  size 4
LBL_48:
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
        BEQ.W LBL_415
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_414
LBL_415:
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
LBL_416:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_417
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
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
        BEQ.W LBL_418
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_414
LBL_418:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_420
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDA.W #20,A7
        BRA.W LBL_421
LBL_420:
        MOVEQ #0,D0
LBL_421:
        TST.L D0
        BEQ.W LBL_422
        MOVE.L -12(A6),D0
        BRA.W LBL_414
LBL_422:
LBL_419:
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
        BEQ.W LBL_423
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_423:
        BRA.W LBL_416
LBL_417:
LBL_414:
        UNLK A6
        RTS
        ; func mapIndexLookup  (JT slot 50)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_49:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_424
LBL_425:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_424
LBL_424:
        UNLK A6
        RTS
        ; func mapIndexSlotFor  (JT slot 51)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local firstTomb : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
        ;   local steps : -20(A6)  size 4
LBL_50:
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
LBL_427:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
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
        BEQ.W LBL_429
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
        MOVE.L -12(A6),D0
        BRA.W LBL_426
LBL_430:
        MOVE.L -8(A6),D0
        BRA.W LBL_426
LBL_429:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_432
LBL_431:
        MOVEQ #0,D0
LBL_432:
        TST.L D0
        BEQ.W LBL_433
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_433:
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
        BEQ.W LBL_434
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_434:
        BRA.W LBL_427
LBL_428:
LBL_426:
        UNLK A6
        RTS
        ; func mapIndexInsert  (JT slot 52)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param entryIdx : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local slotPtr : -12(A6)  size 4
        ;   local old : -16(A6)  size 4
LBL_51:
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
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
        BEQ.W LBL_436
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
LBL_436:
LBL_435:
        UNLK A6
        RTS
        ; func mapIndexRepoint  (JT slot 53)
        ;   param m : 20(A6)  size 4
        ;   param hash : 16(A6)  size 4
        ;   param oldIdx : 12(A6)  size 4
        ;   param newIdx : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local steps : -16(A6)  size 4
LBL_52:
        LINK A6,#-68
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 20(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_438:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_439
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_440
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_437
LBL_440:
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
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_441:
        BRA.W LBL_438
LBL_439:
LBL_437:
        UNLK A6
        RTS
        ; func mapAllocIndex  (JT slot 54)
        ;   param m : 12(A6)  size 4
        ;   param newcap : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
LBL_53:
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
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_238
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
        BEQ.W LBL_443
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_443:
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
LBL_444:
        MOVE.L -16(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_238
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
        BRA.W LBL_444
LBL_445:
LBL_442:
        UNLK A6
        RTS
        ; func mapRehash  (JT slot 55)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local newcap : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local h : -16(A6)  size 4
LBL_54:
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
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_238
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
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
LBL_447:
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
        BEQ.W LBL_448
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDA.W #12,A7
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_447
LBL_448:
LBL_446:
        UNLK A6
        RTS
        ; func mapEnsureIndexCapacity  (JT slot 56)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_55:
        LINK A6,#-56
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
        BEQ.W LBL_450
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        BRA.W LBL_449
LBL_450:
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
        BSR.W LBL_238
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        BSR.W LBL_238
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_451
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
LBL_451:
LBL_449:
        UNLK A6
        RTS
        ; func mapGrowHandle  (JT slot 57)
        ;   param h : 20(A6)  size 4
        ;   param cap : 16(A6)  size 4
        ;   param need : 12(A6)  size 4
        ;   param unit : 8(A6)  size 4
        ;   local newcap : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
LBL_56:
        LINK A6,#-60
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
        BEQ.W LBL_453
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_454
LBL_453:
        MOVEQ #4,D0
        MOVE.L D0,-4(A6)
LBL_454:
LBL_455:
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_456
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_238
        MOVE.L D0,-4(A6)
        BRA.W LBL_455
LBL_456:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        BSR.W LBL_238
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
        BEQ.W LBL_457
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_457:
        MOVE.L -4(A6),D0
        BRA.W LBL_452
LBL_452:
        UNLK A6
        RTS
        ; func mapGrowEntries  (JT slot 58)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_57:
        LINK A6,#-56
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
        BEQ.W LBL_459
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
        BSR.W LBL_56
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_459:
LBL_458:
        UNLK A6
        RTS
        ; func mapGrowVals  (JT slot 59)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_58:
        LINK A6,#-56
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
        BEQ.W LBL_461
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
        BSR.W LBL_56
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_461:
LBL_460:
        UNLK A6
        RTS
        ; func mapGrowPool  (JT slot 60)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_59:
        LINK A6,#-56
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
        BEQ.W LBL_463
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
        BSR.W LBL_56
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_463:
LBL_462:
        UNLK A6
        RTS
        ; func mapPoolAppend  (JT slot 61)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_60:
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
        BSR.W LBL_59
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
        BRA.W LBL_464
LBL_464:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 62)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_61:
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
        BEQ.W LBL_466
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_466:
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
        BEQ.W LBL_467
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_467:
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
        BEQ.W LBL_468
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_468:
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
        BEQ.W LBL_469
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_469:
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
        BEQ.W LBL_470
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_470:
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
        BRA.W LBL_465
LBL_465:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 63)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_62:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_472
        BRA.W LBL_471
LBL_472:
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
LBL_471:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 64)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_63:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_474
        BRA.W LBL_473
LBL_474:
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
        BEQ.W LBL_475
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_475:
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
        BEQ.W LBL_476
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
LBL_476:
LBL_473:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 65)
        ;   param m : 8(A6)  size 4
LBL_64:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_478
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_479
LBL_478:
        MOVEQ #0,D0
LBL_479:
        BRA.W LBL_477
LBL_477:
        UNLK A6
        RTS
        ; func rtMapSet  (JT slot 66)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param val : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local h : -8(A6)  size 4
        ;   local idx : -12(A6)  size 4
        ;   local klen : -16(A6)  size 4
        ;   local keyOff : -20(A6)  size 4
LBL_65:
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDA.W #12,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        BRA.W LBL_480
LBL_481:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
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
        BSR.W LBL_57
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
        BSR.W LBL_58
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
        BSR.W LBL_60
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
        BSR.W LBL_45
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        BSR.W LBL_51
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
LBL_480:
        UNLK A6
        RTS
        ; func rtMapGet  (JT slot 67)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_66:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_483
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_483:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
LBL_482:
        UNLK A6
        RTS
        ; func rtMapGetDv  (JT slot 68)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_67:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_485
        MOVEQ #0,D0
        BRA.W LBL_484
LBL_485:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        MOVEQ #1,D0
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func rtMapHas  (JT slot 69)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
LBL_68:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDA.W #12,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_486
LBL_486:
        UNLK A6
        RTS
        ; func rtMapRemove  (JT slot 70)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local h : -8(A6)  size 4
        ;   local slot : -12(A6)  size 4
        ;   local idx : -16(A6)  size 4
        ;   local lastIdx : -20(A6)  size 4
        ;   local lastHash : -24(A6)  size 4
LBL_69:
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
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDA.W #12,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_488
        BRA.W LBL_487
LBL_488:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #-2,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 48(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_489
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #12,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDA.W #16,A7
LBL_489:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_487:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 71)
        ;   param m : 8(A6)  size 4
LBL_70:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_490
LBL_490:
        UNLK A6
        RTS
        ; func rtMapKeyAt  (JT slot 72)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param key255 : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local keyLen : -8(A6)  size 4
        ;   local keyOff : -12(A6)  size 4
        ;   local poolBase : -16(A6)  size 4
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_492
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
        BRA.W LBL_493
LBL_492:
        MOVEQ #1,D0
LBL_493:
        TST.L D0
        BEQ.W LBL_494
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_494:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_491:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 73)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_72:
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
        BNE.W LBL_496
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
        BRA.W LBL_497
LBL_496:
        MOVEQ #1,D0
LBL_497:
        TST.L D0
        BEQ.W LBL_498
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_498:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
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
LBL_495:
        UNLK A6
        RTS
        ; func rtIntMapNew  (JT slot 74)
        ;   param valsize : 8(A6)  size 4
LBL_73:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        BRA.W LBL_499
LBL_499:
        UNLK A6
        RTS
        ; func rtIntMapRetain  (JT slot 75)
        ;   param m : 8(A6)  size 4
LBL_74:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
LBL_500:
        UNLK A6
        RTS
        ; func rtIntMapRelease  (JT slot 76)
        ;   param m : 8(A6)  size 4
LBL_75:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
LBL_501:
        UNLK A6
        RTS
        ; func rtIntMapLastref  (JT slot 77)
        ;   param m : 8(A6)  size 4
LBL_76:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_502
LBL_502:
        UNLK A6
        RTS
        ; func rtIntMapCount  (JT slot 78)
        ;   param m : 8(A6)  size 4
LBL_77:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        BRA.W LBL_503
LBL_503:
        UNLK A6
        RTS
        ; func rtIntMapValAt  (JT slot 79)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_78:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDA.W #12,A7
LBL_504:
        UNLK A6
        RTS
        ; func sortedmapValSlot  (JT slot 80)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_79:
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
        BSR.W LBL_238
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_505
LBL_505:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 81)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_80:
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
        BEQ.W LBL_507
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_507:
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
        BEQ.W LBL_508
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_508:
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
        BEQ.W LBL_509
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_509:
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
        BRA.W LBL_506
LBL_506:
        UNLK A6
        RTS
        ; func rtSortedMapRetain  (JT slot 82)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_81:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
        BRA.W LBL_510
LBL_511:
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
LBL_510:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 83)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_82:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_513
        BRA.W LBL_512
LBL_513:
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
        BEQ.W LBL_514
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_514:
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
        BEQ.W LBL_515
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
LBL_515:
LBL_512:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 84)
        ;   param m : 8(A6)  size 4
LBL_83:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_518
LBL_517:
        MOVEQ #0,D0
LBL_518:
        BRA.W LBL_516
LBL_516:
        UNLK A6
        RTS
        ; func rtSortedMapCount  (JT slot 85)
        ;   param m : 8(A6)  size 4
LBL_84:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_519
LBL_519:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 86)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_85:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_521
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
        BRA.W LBL_522
LBL_521:
        MOVEQ #1,D0
LBL_522:
        TST.L D0
        BEQ.W LBL_523
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_523:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
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
LBL_520:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 87)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_86:
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
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_525:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_526
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
        BEQ.W LBL_527
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_527:
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
        BRA.W LBL_525
LBL_526:
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
        BRA.W LBL_524
LBL_524:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 88)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local v2 : -22(A6)  size 4
LBL_87:
        LINK A6,#-74
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
        BEQ.W LBL_529
        MOVEQ #0,D1
        MOVE.L -22(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_529:
        MOVEQ #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_530
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_531
LBL_530:
LBL_532:
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        MOVE.L -22(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_240
        MOVE.L D0,-10(A6)
        MOVE.L -7084(A5),D1
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
        BSR.W LBL_239
        MOVE.L D0,-22(A6)
        MOVE.L -6(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_532
LBL_533:
LBL_531:
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_534
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_534:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_535:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_536
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L 8(A6),D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D1
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
        BRA.W LBL_535
LBL_536:
        MOVE.L -14(A6),D0
        BRA.W LBL_528
LBL_528:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 89)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_88:
        LINK A6,#-52
        MOVE.L -7096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_538
        BRA.W LBL_537
LBL_538:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_539
        BRA.W LBL_537
LBL_539:
        MOVE.L -7076(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7076(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_537:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 90)
LBL_89:
        LINK A6,#-52
        MOVE.L -7076(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7076(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -7076(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7076(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_540:
        UNLK A6
        RTS
        ; func natInit  (JT slot 91)
LBL_90:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7098(A5),D0
        TST.L D0
        BEQ.W LBL_542
        BRA.W LBL_541
LBL_542:
        MOVEQ #1,D0
        MOVE.B D0,-7098(A5)
        CLR.L D0
        MOVE.B -7106(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_543
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-7096(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7134(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7138(A5)
        BRA.W LBL_541
LBL_543:
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7076(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7080(A5)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7084(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7088(A5)
        MOVEQ #0,D0
        MOVE.L D0,-7092(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7134(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7138(A5)
        MOVE.L -7076(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7076(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7076(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7076(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7076(A5),D1
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
        MOVE.L -7076(A5),D1
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
        MOVE.L -7076(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
        MOVE.L -7076(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7076(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7076(A5),D1
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
        BEQ.W LBL_544
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-7096(A5)
        BRA.W LBL_541
LBL_544:
        MOVE.L -7076(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-7096(A5)
        MOVE.L -7076(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7076(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7076(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_541:
        UNLK A6
        RTS
        ; func natSetCapture  (JT slot 92)
LBL_91:
        LINK A6,#-52
        MOVEQ #1,D0
        MOVE.B D0,-7106(A5)
LBL_545:
        UNLK A6
        RTS
        ; func natAppTrace  (JT slot 93)
        ;   param enable : 8(A6)  size 4
LBL_92:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-7130(A5)
LBL_546:
        UNLK A6
        RTS
        ; func natWlOpenFile  (JT slot 94)
LBL_93:
        LINK A6,#-52
        MOVE.L -7110(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7122(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7110(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7110(A5),D1
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
        BEQ.W LBL_548
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_547
LBL_548:
        MOVE.L -7110(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_547
LBL_547:
        UNLK A6
        RTS
        ; func natWlCloseFile  (JT slot 95)
        ;   param ref : 8(A6)  size 4
LBL_94:
        LINK A6,#-52
        MOVE.L -7110(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7110(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -7110(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7122(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7110(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_549:
        UNLK A6
        RTS
        ; func natAppFlushLog  (JT slot 96)
        ;   local ref : -4(A6)  size 4
        ;   local werr : -8(A6)  size 4
LBL_95:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7128(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_551
        MOVE.L -7126(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_552
LBL_551:
        MOVEQ #1,D0
LBL_552:
        TST.L D0
        BEQ.W LBL_553
        BRA.W LBL_550
LBL_553:
        BSR.W LBL_93
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_554
        MOVE.L -7110(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7114(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7126(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #46,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7110(A5),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_94
        ADDQ.L #4,A7
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_556
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_556:
        BRA.W LBL_555
LBL_554:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_555:
        MOVEQ #0,D0
        MOVE.L D0,-7126(A5)
LBL_550:
        UNLK A6
        RTS
        ; func natWlAdd  (JT slot 97)
        ;   param s : 8(A6)  size 4
LBL_96:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7128(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_558
        BRA.W LBL_557
LBL_558:
        MOVE.L -7126(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_559
        BSR.W LBL_95
LBL_559:
        MOVE.L -7126(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7114(A5),D1
        MOVE.L -7126(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-7126(A5)
LBL_557:
        UNLK A6
        RTS
        ; func natAppWriteLog  (JT slot 98)
        ;   param name : 12(A6)  size 4
        ;   param creator : 8(A6)  size 4
        ;   local ref : -4(A6)  size 4
LBL_97:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_95
        MOVEQ #0,D0
        MOVE.B D0,-7128(A5)
        MOVE.L -7110(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_561
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7110(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7114(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7118(A5)
LBL_561:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        MOVE.L -7110(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A014  ; NatGetVol
        MOVE.L -7110(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-7122(A5)
        MOVE.L -7110(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7110(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D1
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
        BEQ.W LBL_562
        MOVE.L -7110(A5),D1
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
        MOVE.L -7110(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7110(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_562:
        BSR.W LBL_93
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_563
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        BRA.W LBL_560
LBL_563:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_94
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-7126(A5)
        MOVEQ #1,D0
        MOVE.B D0,-7128(A5)
LBL_560:
        UNLK A6
        RTS
        ; func natAbortLog  (JT slot 99)
        ;   param s : 8(A6)  size 4
LBL_98:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7106(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_565
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #4,A7
        BSR.W LBL_95
LBL_565:
LBL_564:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 100)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_99:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7106(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_567
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #4,A7
        BRA.W LBL_566
LBL_567:
        BSR.W LBL_90
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #8,A7
        BSR.W LBL_89
LBL_566:
        UNLK A6
        RTS
        ; func natLog  (JT slot 101)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_100:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B -7106(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_569
        BRA.W LBL_568
LBL_569:
        BSR.W LBL_90
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_570:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_572
        MOVE.L -7092(A5),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_573
LBL_572:
        MOVEQ #0,D0
LBL_573:
        TST.L D0
        BEQ.W LBL_571
        MOVE.L -7088(A5),D1
        MOVE.L -7092(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7080(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7092(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-7092(A5)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_570
LBL_571:
LBL_568:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 102)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_101:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7100(A5),D0
        TST.L D0
        BEQ.W LBL_575
        BRA.W LBL_574
LBL_575:
        MOVEQ #1,D0
        MOVE.B D0,-7100(A5)
        BSR.W LBL_95
        CLR.L D0
        MOVE.B -7106(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_576
        DC.W $A9F4  ; NatExitToShell
LBL_576:
        BSR.W LBL_90
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #8,A7
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #8,A7
        MOVE.L -7088(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7092(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #8,A7
        MOVE.L -7096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
        MOVE.L -7076(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7076(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_577:
        BSR.W LBL_89
        DC.W $A9F4  ; NatExitToShell
LBL_574:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 103)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_102:
        LINK A6,#-316
        LEA -256(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_146(PC),A0
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
        BSR.W LBL_90
        LEA -256(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-260(A6)
        MOVE.L -7134(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -260(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
LBL_579:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_580
        MOVE.L -7134(A5),D1
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
        BCS.W LBL_581
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
LBL_581:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_579
LBL_580:
        CLR.L D0
        MOVE.B -7106(A5),D0
        TST.L D0
        BEQ.W LBL_582
        MOVE.L -7134(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #4,A7
LBL_582:
        MOVE.L -7134(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #4,A7
        BSR.W LBL_95
        CLR.L D0
        MOVE.B -7410(A5),D0
        TST.L D0
        BEQ.W LBL_583
        LEA LBL_235(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_584
LBL_583:
        MOVEQ #0,D0
LBL_584:
        TST.L D0
        BEQ.W LBL_585
        MOVEQ #30,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; NatSysBeep
        MOVE.L -7134(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7138(A5),D0
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
LBL_585:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_101
        ADDQ.L #4,A7
LBL_578:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 104)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_103:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-7142(A5)
        LEA -7398(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
LBL_586:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 105)
LBL_104:
        LINK A6,#-52
        MOVE.L -7142(A5),D0
        BRA.W LBL_587
LBL_587:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 106)
        ;   hidden result ptr : 8(A6)  size 4
LBL_105:
        LINK A6,#-52
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -7398(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_588
LBL_588:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 107)
        ;   local __ret4 : -4(A6)  size 4
LBL_106:
        LINK A6,#-56
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-12(A6)
LBL_590:
        MOVE.L A1,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -7104(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_589
LBL_589:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 108)
LBL_107:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7404(A5),D0
        TST.L D0
        BEQ.W LBL_592
        BRA.W LBL_591
LBL_592:
        MOVEQ #1,D0
        MOVE.B D0,-7404(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7402(A5)
LBL_591:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 109)
LBL_108:
        LINK A6,#-52
        MOVE.L -7402(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_593:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 110)
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
LBL_109:
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
        BEQ.W LBL_595
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_594
LBL_595:
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
        BEQ.W LBL_596
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_594
LBL_596:
        BSR.W LBL_107
        MOVE.L -7402(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_597
        MOVE.L -7402(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_597:
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_598
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_594
LBL_598:
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D0
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
        BEQ.W LBL_599
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
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7402(A5),D1
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
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_600
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_600:
LBL_599:
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_108
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_601
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_602
LBL_601:
        MOVEQ #1,D0
LBL_602:
        TST.L D0
        BEQ.W LBL_603
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_594
LBL_603:
        MOVEQ #1,D0
        BRA.W LBL_594
LBL_594:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 111)
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
LBL_110:
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
        BSR.W LBL_107
        MOVE.L -7402(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_605
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_604
LBL_605:
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_606
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_606:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_607:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_608
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -7402(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_609
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_610
LBL_609:
        MOVEQ #0,D0
LBL_610:
        TST.L D0
        BEQ.W LBL_611
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_604
LBL_611:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_612
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
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
LBL_612:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_613
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_614
LBL_613:
        MOVEQ #1,D0
LBL_614:
        TST.L D0
        BEQ.W LBL_615
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_615:
        BRA.W LBL_607
LBL_608:
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
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
        BRA.W LBL_604
LBL_604:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 112)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_111:
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
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_617:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
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
        BEQ.W LBL_619
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_619:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_617
LBL_618:
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
LBL_620:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_621
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
        BRA.W LBL_620
LBL_621:
LBL_616:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 113)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_112:
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
        BEQ.W LBL_623
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_149(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_622
LBL_623:
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
        BSR.W LBL_10
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
        BEQ.W LBL_624
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
LBL_624:
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
        BRA.W LBL_622
LBL_622:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 114)
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
LBL_113:
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
        BEQ.W LBL_626
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_625
LBL_626:
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
        BEQ.W LBL_627
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_625
LBL_627:
        BSR.W LBL_107
        MOVE.L -7402(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_628
        MOVE.L -7402(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_628:
        MOVE.L -7402(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_629
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_625
LBL_629:
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D0
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
        BEQ.W LBL_630
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
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7402(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7402(A5),D1
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
        MOVE.L -7402(A5),D1
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
        BEQ.W LBL_631
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_631:
LBL_630:
        MOVE.L -7402(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7402(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_108
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_632
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_633
LBL_632:
        MOVEQ #1,D0
LBL_633:
        TST.L D0
        BEQ.W LBL_634
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_625
LBL_634:
        MOVEQ #1,D0
        BRA.W LBL_625
LBL_625:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 115)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_114:
        LINK A6,#-52
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_109
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_636
        MOVEQ #1,D0
        BRA.W LBL_635
LBL_636:
        MOVEQ #0,D0
        BRA.W LBL_635
LBL_635:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 116)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_115:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_638
        MOVEQ #1,D0
        BRA.W LBL_637
LBL_638:
        MOVEQ #0,D0
        BRA.W LBL_637
LBL_637:
        UNLK A6
        RTS
        ; func natWlAddText  (JT slot 117)
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_116:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7128(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_640
        BRA.W LBL_639
LBL_640:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L #511,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_641
        MOVE.L #511,D0
        MOVE.L D0,-8(A6)
LBL_641:
        MOVE.L -7126(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_642
        BSR.W LBL_95
LBL_642:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7114(A5),D1
        MOVE.L -7126(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -7114(A5),D1
        MOVE.L -7126(A5),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7126(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-7126(A5)
LBL_639:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 118)
        ;   param cond : 12(A6)  size 2
        ;   param label : 8(A6)  size 4
        ;   local msg : -256(A6)  size 256
LBL_117:
        LINK A6,#-308
        LEA -256(A6),A0
        CLR.B (A0)
        CLR.L D0
        MOVE.B 12(A6),D0
        TST.L D0
        BEQ.W LBL_644
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_150(PC),A0
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
        BRA.W LBL_645
LBL_644:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_151(PC),A0
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
LBL_645:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_99
        ADDQ.L #4,A7
LBL_643:
        UNLK A6
        RTS
        ; func smokeMakePoint  (JT slot 119)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -46(A6)  size 46
        ;   local __store5 : -92(A6)  size 46
        ;   local __ret5 : -138(A6)  size 46
LBL_118:
        LINK A6,#-190
        MOVEQ #3,D0
        MOVE.L D0,-46(A6)
        MOVEQ #4,D0
        MOVE.L D0,-42(A6)
        MOVEQ #5,D0
        MOVE.W D0,-38(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_647:
        CLR.W (A0)+
        DBRA D0,LBL_647
        LEA -92(A6),A0
        MOVE.W #22,D0
LBL_648:
        CLR.W (A0)+
        DBRA D0,LBL_648
        MOVEQ #3,D0
        MOVE.L D0,-138(A6)
        MOVEQ #4,D0
        MOVE.L D0,-134(A6)
        MOVEQ #5,D0
        MOVE.W D0,-130(A6)
        MOVEQ #0,D0
        MOVE.L D0,-128(A6)
        LEA -124(A6),A0
        MOVE.W #15,D0
LBL_649:
        CLR.W (A0)+
        DBRA D0,LBL_649
        LEA -92(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_237
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -92(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #3,D0
        MOVE.L D0,0(A0)
        MOVEA.L A1,A0
        MOVEQ #4,D0
        MOVE.L D0,4(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.W D0,8(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,10(A0)
        MOVEA.L A1,A0
        LEA 14(A0),A0
        MOVE.W #15,D0
LBL_650:
        CLR.W (A0)+
        DBRA D0,LBL_650
        LEA -92(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_236
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_237
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -92(A6),A0
        MOVE.L A0,-(A7)
        LEA -46(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_651:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_651
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -138(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_237
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A0,-(A7)
        LEA -138(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_652:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_652
        LEA -138(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_236
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_237
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -138(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_653:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_653
        BRA.W LBL_646
LBL_646:
        UNLK A6
        RTS
        ; func smokeTakePoint  (JT slot 120)
        ;   param p : 8(A6)  size 4
LBL_119:
        LINK A6,#-52
        MOVEA.L 8(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_654
LBL_654:
        UNLK A6
        RTS
        ; func smokeListInt  (JT slot 121)
        ;   local l : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local x : -16(A6)  size 4
LBL_120:
        LINK A6,#-76
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #20,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #30,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_152(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_153(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_656
        BRA.W LBL_657
LBL_656:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_657:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVEQ #25,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_658
        BRA.W LBL_659
LBL_658:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_659:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_660
        BRA.W LBL_661
LBL_660:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_661:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #25,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_662
        BRA.W LBL_663
LBL_662:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_663:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_158(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_163(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_664
        BRA.W LBL_665
LBL_664:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_665:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #25,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #100,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #200,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_666:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_668
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        LEA -16(A6),A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.L -8(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_667:
        ADDQ.L #1,(A7)
        BRA.W LBL_666
LBL_668:
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #25,D1
        MOVEQ #100,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #200,D0
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_165(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_166(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-32(A6)
LBL_669:
        MOVE.L A1,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_655:
        UNLK A6
        RTS
        ; func smokeListText  (JT slot 122)
        ;   local l : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local __store6 : -12(A6)  size 4
        ;   local __store7 : -16(A6)  size 4
LBL_121:
        LINK A6,#-88
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -12(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -16(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_168(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_170(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_671
        BRA.W LBL_672
LBL_671:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_672:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_168(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #1,D0
        MOVE.L D0,-24(A6)
        BSR.W LBL_11
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_174(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_673
        BRA.W LBL_674
LBL_673:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_674:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
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
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_675
        BRA.W LBL_676
LBL_675:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_676:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVEA.L (A7)+,A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_677
        BRA.W LBL_678
LBL_677:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_678:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_174(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_175(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_176(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_177(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_178(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_179(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_679
        BRA.W LBL_680
LBL_679:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_680:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_181(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_681
        BRA.W LBL_682
LBL_681:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_682:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_181(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_184(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_683
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-48(A6)
        CLR.L -52(A6)
LBL_684:
        MOVE.L -52(A6),D0
        MOVE.L -48(A6),D1
        CMP.L D1,D0
        BGE.W LBL_683
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-52(A6)
        BRA.W LBL_684
LBL_683:
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_670:
        UNLK A6
        RTS
        ; func smokeMapInt  (JT slot 123)
        ;   local m : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local k : -264(A6)  size 256
        ;   local v : -268(A6)  size 4
LBL_122:
        LINK A6,#-336
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -264(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-268(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVEQ #1,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVEQ #2,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVEQ #3,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L -276(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        MOVE.B D0,-(A7)
        LEA LBL_190(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_191(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        MOVEQ #99,D0
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-284(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA -284(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_67
        ADDA.W #12,A7
        MOVE.L -284(A6),D1
        MOVEQ #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_185(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        MOVEQ #99,D0
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-284(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA -284(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_67
        ADDA.W #12,A7
        MOVE.L -284(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVEQ #22,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L -276(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_195(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_196(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_199(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_686:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_688
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_71
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_72
        ADDA.W #12,A7
        MOVE.L -8(A6),D1
        MOVE.L -268(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_687:
        ADDQ.L #1,(A7)
        BRA.W LBL_686
LBL_688:
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #22,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_200(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-292(A6)
LBL_689:
        MOVE.L A1,-(A7)
        MOVE.L -292(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_685:
        UNLK A6
        RTS
        ; func smokeMapText  (JT slot 124)
        ;   local m : -4(A6)  size 4
        ;   local k : -260(A6)  size 256
        ;   local v : -264(A6)  size 4
        ;   local found : -268(A6)  size 4
LBL_123:
        LINK A6,#-340
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        CLR.B (A0)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_691
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_691:
        BSR.W LBL_11
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_692
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_692:
        BSR.W LBL_11
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_204(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_206(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_207(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        BSR.W LBL_11
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-288(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA -288(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_67
        ADDA.W #12,A7
        MOVE.L -288(A6),D0
        MOVE.L -280(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_693
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_693:
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_209(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_201(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        BSR.W LBL_11
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -280(A6),D0
        MOVE.L D0,-288(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA -288(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_67
        ADDA.W #12,A7
        MOVE.L -288(A6),D0
        MOVE.L -280(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_694
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_694:
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_695
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_695:
        BSR.W LBL_11
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_68
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_696
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_696:
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_69
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_697:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_699
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_71
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_72
        ADDA.W #12,A7
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -264(A6),D0
        MOVE.L D0,-268(A6)
LBL_698:
        ADDQ.L #1,(A7)
        BRA.W LBL_697
LBL_699:
        ADDA.W #12,A7
        MOVE.L -268(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-296(A6)
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_700
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-300(A6)
        CLR.L -304(A6)
LBL_701:
        MOVE.L -304(A6),D0
        MOVE.L -300(A6),D1
        CMP.L D1,D0
        BGE.W LBL_700
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -304(A6),D0
        MOVE.L D0,-(A7)
        LEA -308(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_72
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -308(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-304(A6)
        BRA.W LBL_701
LBL_700:
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_690:
        UNLK A6
        RTS
        ; func smokeTextOps  (JT slot 125)
        ;   local t : -4(A6)  size 4
        ;   local __store8 : -8(A6)  size 4
        ;   local u : -12(A6)  size 4
        ;   local __store9 : -16(A6)  size 4
LBL_124:
        LINK A6,#-72
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -16(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_11
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-8(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #33,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_219(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_220(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_11
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        CLR.L -(A7)
        BSR.W LBL_15
        ADDA.W #16,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_222(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_223(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_219(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_225(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_219(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_227(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_228(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_702:
        UNLK A6
        RTS
        ; func smokeAliasing  (JT slot 126)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
        ;   local __store11 : -12(A6)  size 4
LBL_125:
        LINK A6,#-68
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -12(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_704:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_229(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_705
        BRA.W LBL_706
LBL_705:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_233(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_706:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_238
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_707:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 1090(A5)
        MOVE.L D0,-16(A6)
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_708:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_231(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_232(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_117
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_709:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_710:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_703:
        UNLK A6
        RTS
        ; func smokeClamp3  (JT slot 127)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param s : 12(A6)  size 4
LBL_126:
        LINK A6,#-52
        MOVE.L 8(A6),-(A7)
        MOVE.L #3,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_711
LBL_711:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 128)
LBL_127:
        LINK A6,#-52
LBL_712:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 129)
        ;   param path : 8(A6)  size 4
LBL_128:
        LINK A6,#-52
LBL_713:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 130)
LBL_129:
        LINK A6,#-52
LBL_714:
        UNLK A6
        RTS
LBL_238:
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
LBL_239:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_715
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_234(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_715:
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
        BPL.W LBL_716
        NEG.L D2
        MOVE.L #1,D4
LBL_716:
        CLR.L D5
        TST.L D3
        BPL.W LBL_717
        NEG.L D3
        MOVE.L #1,D5
LBL_717:
        CLR.L D6
        MOVE.W #31,D7
LBL_718:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_719
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_719:
        DBRA D7,LBL_718
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_720
        NEG.L D2
LBL_720:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_240:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_721
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_234(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_721:
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
LBL_241:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_727(PC),A0
        MOVE.L A0,-4(A6)
LBL_728:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_729
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_730
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_728
LBL_730:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_731:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_728
LBL_729:
        UNLK A6
        RTS
LBL_727:
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
        DC.W $E61A
        DC.W $0000
        DC.W $E440
        DC.W $0001
        DC.W $0000
        DC.W $0000
LBL_236:
        ; cg_retain_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_237:
        ; cg_release_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_234:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_130:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_131:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_132:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_133:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_134:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_135:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_136:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_137:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_138:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_139:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_140:
        DC.B $12
        DC.B $6D,$61,$70,$3A,$20,$69,$6E,$64,$65,$78,$20,$63,$6F,$72,$72,$75,$70,$74
        DC.B $00
LBL_141:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_144:
        DC.B $18
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$6C,$6F,$67,$20,$66,$69,$6C,$65
        DC.B $00
LBL_145:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_146:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_147:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_148:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_142:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_143:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_149:
        DC.B $12
        DC.B $72,$65,$73,$6F,$75,$72,$63,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_150:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_151:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_152:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
LBL_153:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$69,$72,$73,$74
        DC.B $00
LBL_154:
        DC.B $0D
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$6C,$61,$73,$74
LBL_233:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_155:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
LBL_156:
        DC.B $12
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
        DC.B $00
LBL_157:
        DC.B $10
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_158:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_159:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
LBL_160:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
        DC.B $00
LBL_161:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
LBL_162:
        DC.B $18
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
        DC.B $00
LBL_163:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_164:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_165:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$73,$75,$6D
LBL_166:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_167:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_168:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_169:
        DC.B $05
        DC.B $67,$61,$6D,$6D,$61
LBL_170:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
        DC.B $00
LBL_171:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$66,$69,$72,$73,$74
LBL_172:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$6C,$61,$73,$74
        DC.B $00
LBL_173:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
        DC.B $00
LBL_174:
        DC.B $04
        DC.B $42,$45,$54,$41
        DC.B $00
LBL_175:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
LBL_176:
        DC.B $16
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_177:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
LBL_178:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_179:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
LBL_180:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_181:
        DC.B $04
        DC.B $73,$6F,$6C,$6F
        DC.B $00
LBL_182:
        DC.B $03
        DC.B $64,$75,$6F
LBL_183:
        DC.B $1D
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
LBL_184:
        DC.B $23
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70
LBL_185:
        DC.B $03
        DC.B $6F,$6E,$65
LBL_186:
        DC.B $03
        DC.B $74,$77,$6F
LBL_187:
        DC.B $05
        DC.B $74,$68,$72,$65,$65
LBL_188:
        DC.B $17
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
LBL_189:
        DC.B $15
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
LBL_190:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_191:
        DC.B $04
        DC.B $66,$6F,$75,$72
        DC.B $00
LBL_192:
        DC.B $12
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_193:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_194:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_195:
        DC.B $11
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
LBL_196:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_197:
        DC.B $18
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_198:
        DC.B $0B
        DC.B $6E,$6F,$6E,$65,$78,$69,$73,$74,$65,$6E,$74
LBL_199:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$72,$65,$6D,$6F,$76,$65,$2D,$61,$62,$73,$65,$6E,$74,$20,$6E,$6F,$2D,$6F,$70
LBL_200:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$73,$75,$6D
LBL_201:
        DC.B $01
        DC.B $61
LBL_202:
        DC.B $05
        DC.B $61,$70,$70,$6C,$65
LBL_203:
        DC.B $01
        DC.B $62
LBL_204:
        DC.B $06
        DC.B $62,$61,$6E,$61,$6E,$61
        DC.B $00
LBL_205:
        DC.B $18
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
        DC.B $00
LBL_206:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
        DC.B $00
LBL_207:
        DC.B $01
        DC.B $7A
LBL_208:
        DC.B $04
        DC.B $6E,$6F,$6E,$65
        DC.B $00
LBL_209:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
LBL_210:
        DC.B $1C
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
        DC.B $00
LBL_211:
        DC.B $07
        DC.B $61,$76,$6F,$63,$61,$64,$6F
LBL_212:
        DC.B $12
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
        DC.B $00
LBL_213:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_214:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$76,$61,$6C,$75,$65
        DC.B $00
LBL_215:
        DC.B $05
        DC.B $68,$65,$6C,$6C,$6F
LBL_216:
        DC.B $07
        DC.B $2C,$20,$77,$6F,$72,$6C,$64
LBL_217:
        DC.B $0C
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64
        DC.B $00
LBL_218:
        DC.B $0F
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$73,$74,$72
LBL_219:
        DC.B $0D
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21
LBL_220:
        DC.B $10
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$63,$68,$61,$72
        DC.B $00
LBL_221:
        DC.B $08
        DC.B $20,$28,$61,$67,$61,$69,$6E,$29
        DC.B $00
LBL_222:
        DC.B $15
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21,$20,$28,$61,$67,$61,$69,$6E,$29
LBL_223:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74
LBL_224:
        DC.B $23
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74,$20,$6C,$65,$61,$76,$65,$73,$20,$73,$6F,$75,$72,$63,$65,$20,$75,$6E,$63,$68,$61,$6E,$67,$65,$64
LBL_225:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$6C,$65,$6E,$67,$74,$68
LBL_226:
        DC.B $0E
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$65,$71,$75,$61,$6C
        DC.B $00
LBL_227:
        DC.B $04
        DC.B $6E,$6F,$70,$65
        DC.B $00
LBL_228:
        DC.B $12
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$6E,$6F,$74,$2D,$65,$71,$75,$61,$6C
        DC.B $00
LBL_229:
        DC.B $25
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$6D,$75,$74,$61,$74,$65,$20,$76,$69,$61,$20,$62,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
LBL_230:
        DC.B $1E
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$76,$61,$6C,$75,$65,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
        DC.B $00
LBL_231:
        DC.B $21
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$20,$62,$20,$74,$6F,$20,$61,$20,$66,$72,$65,$73,$68,$20,$6C,$69,$73,$74
LBL_232:
        DC.B $27
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$69,$6E,$67,$20,$62,$20,$6C,$65,$61,$76,$65,$73,$20,$61,$20,$75,$6E,$74,$6F,$75,$63,$68,$65,$64
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_235:
        DC.B $00
        DC.B $00
