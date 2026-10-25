LBL_362:
        ; startup (JT slot 0)
        ; globals (below A5, 7426 bytes total):
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
        ;   rtUiFontScratch : -58(A5)  size 4  type ptr
        ;   rtUiScripted : -60(A5)  size 1  type bool
        ;   rtUiScriptDbl : -62(A5)  size 1  type bool
        ;   rtUiJiggle : -64(A5)  size 1  type bool
        ;   rtUiJiggleBusy : -66(A5)  size 1  type bool
        ;   rtUiAnswerKinds : -70(A5)  size 4  type ptr
        ;   rtUiAnswerVals : -74(A5)  size 4  type ptr
        ;   rtUiAnswerStrs : -78(A5)  size 4  type ptr
        ;   rtUiAnswerHead : -82(A5)  size 4  type int
        ;   rtUiAnswerTail : -86(A5)  size 4  type int
        ;   rtUiTraceSuppressed : -88(A5)  size 1  type bool
        ;   rtUiTraceWinCounts : -92(A5)  size 4  type ptr
        ;   rtUiTraceLastFront : -96(A5)  size 4  type ptr
        ;   rtUiDimPrevArr : -100(A5)  size 4  type ptr
        ;   rtUiDimFirst : -102(A5)  size 1  type bool
        ;   rtUiStdEditDimPrev : -104(A5)  size 1  type int
        ;   rtUiScriptCursor : -108(A5)  size 4  type ptr
        ;   rtUiScriptCursorInit : -110(A5)  size 1  type bool
        ;   rtUiScriptLineBuf : -114(A5)  size 4  type ptr
        ;   rtUiScriptLineLen : -118(A5)  size 4  type int
        ;   rtUiVerbBuf : -122(A5)  size 4  type ptr
        ;   rtUiArg1Buf : -126(A5)  size 4  type ptr
        ;   rtUiArg2Buf : -130(A5)  size 4  type ptr
        ;   rtUiVirtualTicks : -134(A5)  size 4  type int
        ;   rtUiModalActive : -136(A5)  size 1  type bool
        ;   rtUiModalInst : -140(A5)  size 4  type ptr
        ;   rtUiModalBufH : -144(A5)  size 4  type ptr
        ;   rtUiModalBuf : -148(A5)  size 4  type ptr
        ;   rtUiModalIsNew : -150(A5)  size 1  type bool
        ;   rtUiModalWbKind : -154(A5)  size 4  type int
        ;   rtUiModalAddr : -158(A5)  size 4  type ptr
        ;   rtUiModalLst : -162(A5)  size 4  type ptr
        ;   rtUiModalIdx : -166(A5)  size 4  type int
        ;   rtUiModalMp : -170(A5)  size 4  type ptr
        ;   rtUiModalKey255 : -174(A5)  size 4  type ptr
        ;   rtSerPos : -178(A5)  size 4  type int
        ;   rtSerBad : -180(A5)  size 1  type bool
        ;   rtConnState : -212(A5)  size 32  type arr
        ;   rtConnPendOpened : -220(A5)  size 8  type arr
        ;   rtConnPendFailedCode : -252(A5)  size 32  type arr
        ;   rtConnPendFailedMsg : -2300(A5)  size 2048  type arr
        ;   rtConnParsePortIdx : -2304(A5)  size 4  type int
        ;   rtConnParseBaud : -2308(A5)  size 4  type int
        ;   rtConnOutRef : -2340(A5)  size 32  type arr
        ;   rtConnInRef : -2372(A5)  size 32  type arr
        ;   rtConnReadBuf : -2376(A5)  size 4  type ptr
        ;   rtAtUp : -2378(A5)  size 1  type bool
        ;   rtLsnState : -2386(A5)  size 8  type arr
        ;   rtLsnPendFailedCode : -2394(A5)  size 8  type arr
        ;   rtLsnPendFailedMsg : -2906(A5)  size 512  type arr
        ;   rtBrsState : -2914(A5)  size 8  type arr
        ;   rtBrsPendFailedCode : -2922(A5)  size 8  type arr
        ;   rtBrsPendFailedMsg : -3434(A5)  size 512  type arr
        ;   rtSvcState : -3442(A5)  size 8  type arr
        ;   rtSvcSock : -3450(A5)  size 8  type arr
        ;   rtSvcArmed : -3452(A5)  size 2  type arr
        ;   rtSvcInHandler : -3454(A5)  size 2  type arr
        ;   rtSvcReplied : -3456(A5)  size 2  type arr
        ;   rtSvcPendFailedCode : -3464(A5)  size 8  type arr
        ;   rtSvcPendFailedMsg : -3976(A5)  size 512  type arr
        ;   rtSvcName : -4488(A5)  size 512  type arr
        ;   rtSvcType : -5000(A5)  size 512  type arr
        ;   rtLsnName : -5512(A5)  size 512  type arr
        ;   rtLsnType : -6024(A5)  size 512  type arr
        ;   rtAdspPhase : -6056(A5)  size 32  type arr
        ;   rtConnSlotTransport : -6088(A5)  size 32  type arr
        ;   rtAtLastErr : -6092(A5)  size 4  type int
        ;   rtAt68MppRef : -6096(A5)  size 4  type int
        ;   rtAt68AtpRef : -6100(A5)  size 4  type int
        ;   rtAt68XppRef : -6104(A5)  size 4  type int
        ;   rtAt68DspRef : -6108(A5)  size 4  type int
        ;   rtAt68Up : -6110(A5)  size 1  type bool
        ;   rtAt68LastErr : -6114(A5)  size 4  type int
        ;   rtAt68LkPb : -6158(A5)  size 44  type arr
        ;   rtAt68LkEntity : -6202(A5)  size 44  type arr
        ;   rtAt68LkBuf : -6246(A5)  size 44  type arr
        ;   rtAt68Nte : -6262(A5)  size 16  type arr
        ;   rtAt68NteUsed : -6266(A5)  size 4  type arr
        ;   rtAt68SvcGetPb : -6274(A5)  size 8  type arr
        ;   rtAt68SvcReqBuf : -6282(A5)  size 8  type arr
        ;   rtAt68SvcRespPb : -6290(A5)  size 8  type arr
        ;   rtAt68SvcRespBuf : -6298(A5)  size 8  type arr
        ;   rtAt68SvcBds : -6306(A5)  size 8  type arr
        ;   rtAt68SvcSock : -6314(A5)  size 8  type arr
        ;   rtAt68SvcGetLive : -6316(A5)  size 2  type arr
        ;   rtAt68SvcReqOp : -6324(A5)  size 8  type arr
        ;   rtAt68SvcReqFrom : -6332(A5)  size 8  type arr
        ;   rtAt68SvcReqLen : -6340(A5)  size 8  type arr
        ;   rtAt68SvcTransID : -6348(A5)  size 8  type arr
        ;   rtAt68SvcXO : -6356(A5)  size 8  type arr
        ;   rtAt68CallBuf : -6360(A5)  size 4  type ptr
        ;   rtAt68CallBds : -6364(A5)  size 4  type ptr
        ;   rtAt68CallCode : -6368(A5)  size 4  type int
        ;   rtAt68LsnCcb : -6376(A5)  size 8  type arr
        ;   rtAt68LsnPb : -6384(A5)  size 8  type arr
        ;   rtAt68LsnRef : -6392(A5)  size 8  type arr
        ;   rtAt68LsnLive : -6394(A5)  size 2  type arr
        ;   rtAt68Ccb : -6426(A5)  size 32  type arr
        ;   rtAt68Pb : -6458(A5)  size 32  type arr
        ;   rtAt68SendQ : -6490(A5)  size 32  type arr
        ;   rtAt68RecvQ : -6522(A5)  size 32  type arr
        ;   rtAt68Attn : -6554(A5)  size 32  type arr
        ;   rtAt68CcbRef : -6586(A5)  size 32  type arr
        ;   rtAt68OpenLive : -6594(A5)  size 8  type arr
        ;   rtAt68DspAux : -6598(A5)  size 4  type ptr
        ;   rtTcpPhase : -6630(A5)  size 32  type arr
        ;   rtTcpPending : -6662(A5)  size 32  type arr
        ;   rtTcpCloseSent : -6670(A5)  size 8  type arr
        ;   rtTcpCloseTick : -6702(A5)  size 32  type arr
        ;   rtTcpUp : -6704(A5)  size 1  type bool
        ;   rtLsnSlotTransport : -6712(A5)  size 8  type arr
        ;   rtLsnPort : -6720(A5)  size 8  type arr
        ;   rtTcpLastErr : -6724(A5)  size 4  type int
        ;   rtTcpParseIp : -6728(A5)  size 4  type int
        ;   rtTcpParsePort : -6732(A5)  size 4  type int
        ;   rtTcp68Ref : -6736(A5)  size 4  type int
        ;   rtTcp68LastErr : -6740(A5)  size 4  type int
        ;   rtTcp68Aux : -6744(A5)  size 4  type int
        ;   rtTcp68Stream : -6776(A5)  size 32  type arr
        ;   rtTcp68Buf : -6808(A5)  size 32  type arr
        ;   rtTcp68Rcv : -6840(A5)  size 32  type arr
        ;   rtTcp68Snd : -6872(A5)  size 32  type arr
        ;   rtTcp68RcvPb : -6904(A5)  size 32  type arr
        ;   rtTcp68Pb : -6936(A5)  size 32  type arr
        ;   rtTcp68Wds : -6968(A5)  size 32  type arr
        ;   rtTcp68RcvLive : -6976(A5)  size 8  type arr
        ;   rtTcp68PbLive : -6984(A5)  size 8  type arr
        ;   rtTcp68PbOp : -7016(A5)  size 32  type arr
        ;   rtTcp68RcvGot : -7048(A5)  size 32  type arr
        ;   rtTcp68LsnStream : -7056(A5)  size 8  type arr
        ;   rtTcp68LsnBuf : -7064(A5)  size 8  type arr
        ;   rtTcp68LsnPb : -7072(A5)  size 8  type arr
        ;   rtTcp68LsnLive : -7074(A5)  size 2  type arr
        ;   rtTcp68LsnReady : -7076(A5)  size 2  type arr
        ;   natPb : -7080(A5)  size 4  type ptr
        ;   natBuf : -7084(A5)  size 4  type ptr
        ;   natDigits : -7088(A5)  size 4  type ptr
        ;   natLogBuf : -7092(A5)  size 4  type ptr
        ;   natLogLen : -7096(A5)  size 4  type int
        ;   natRef : -7100(A5)  size 4  type int
        ;   natOpened : -7102(A5)  size 1  type bool
        ;   natDone : -7104(A5)  size 1  type bool
        ;   natArgs : -7108(A5)  size 4  type list
        ;   natCapture : -7110(A5)  size 1  type bool
        ;   natWlPb : -7114(A5)  size 4  type ptr
        ;   natWlBuf : -7118(A5)  size 4  type ptr
        ;   natWlName : -7122(A5)  size 4  type ptr
        ;   natWlVRef : -7126(A5)  size 4  type int
        ;   natWlLen : -7130(A5)  size 4  type int
        ;   natWlOpen : -7132(A5)  size 1  type bool
        ;   natTraceOn : -7134(A5)  size 1  type bool
        ;   natPanicBuf : -7138(A5)  size 4  type ptr
        ;   natEmptyStr : -7142(A5)  size 4  type ptr
        ;   natErrCode : -7146(A5)  size 4  type int
        ;   natErrMsg : -7402(A5)  size 256  type str
        ;   natFilePb : -7406(A5)  size 4  type ptr
        ;   natFileReady : -7408(A5)  size 1  type bool
        ;   natUiEmitBuf : -7412(A5)  size 4  type ptr
        ;   natQdInited : -7414(A5)  size 1  type bool
        ;   natQdGlobals : -7418(A5)  size 4  type ptr
        ;   rtFh68kLastErr : -7422(A5)  size 4  type int
        ;   rtFh68kState : -7426(A5)  size 4  type ptr
        LEA -7426(A5),A0
        MOVE.W #3712,D0
LBL_364:
        CLR.W (A0)+
        DBRA D0,LBL_364
        MOVEA.L $0130.W,A0
        ADDA.L #-38846,A0
        DC.W $A02D  ; _SetApplLimit
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_363
        BSR.W LBL_76
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        BSR.W LBL_104
        BSR.W LBL_361
        CLR.L -(A7)
        BSR.W LBL_87
        RTS
LBL_363:
        ; cg_init_globals
        LINK A6,#-48
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-32(A5)
        MOVE.L #1,D0
        MOVE.B D0,-102(A5)
        LEA -6662(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6658(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6654(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6650(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6646(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6642(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6638(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -6634(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -7108(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_18
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
        BSR.W LBL_89
        ADDQ.L #8,A7
LBL_365:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-52
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
LBL_366:
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
        BEQ.W LBL_368
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_367
LBL_368:
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
        BEQ.W LBL_369
        MOVE.L 16(A6),D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
LBL_369:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_370
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
LBL_370:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_371
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
LBL_371:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_372
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
LBL_372:
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
        BRA.W LBL_367
LBL_367:
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
        BRA.W LBL_373
LBL_373:
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
        BEQ.W LBL_375
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_375:
        MOVE.L 14(A6),D0
        BRA.W LBL_374
LBL_374:
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
        BEQ.W LBL_377
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_378
LBL_377:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_378:
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
        BEQ.W LBL_379
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_379:
LBL_376:
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
        BEQ.W LBL_381
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_382
LBL_381:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_382:
        MOVE.L -4(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_383
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_384
LBL_383:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_384:
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
        BEQ.W LBL_385
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_385:
LBL_380:
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
        BEQ.W LBL_387
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_388
LBL_387:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_388:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_389:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
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
        BEQ.W LBL_391
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_386
LBL_391:
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_392
        MOVEQ #1,D0
        BRA.W LBL_386
LBL_392:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_389
LBL_390:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_393
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_386
LBL_393:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_394
        MOVEQ #1,D0
        BRA.W LBL_386
LBL_394:
        MOVEQ #0,D0
        BRA.W LBL_386
LBL_386:
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
        BRA.W LBL_395
LBL_395:
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
        BNE.W LBL_397
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
        BRA.W LBL_398
LBL_397:
        MOVEQ #1,D0
LBL_398:
        TST.L D0
        BEQ.W LBL_399
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_399:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_396
LBL_396:
        UNLK A6
        RTS
        ; func rtStrSlice  (JT slot 11)
        ;   param out : 20(A6)  size 4
        ;   param s : 16(A6)  size 4
        ;   param start : 12(A6)  size 4
        ;   param len : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
LBL_10:
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
        BNE.W LBL_401
        MOVE.L 8(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_402
LBL_401:
        MOVEQ #1,D0
LBL_402:
        TST.L D0
        BEQ.W LBL_403
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_403:
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_404
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
        BRA.W LBL_405
LBL_404:
        MOVEQ #1,D0
LBL_405:
        TST.L D0
        BEQ.W LBL_406
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_406:
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
LBL_400:
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
        BEQ.W LBL_408
        BRA.W LBL_407
LBL_408:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_409
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_410
LBL_409:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_410:
LBL_411:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_412
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_358
        MOVE.L D0,-12(A6)
        BRA.W LBL_411
LBL_412:
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
        BEQ.W LBL_413
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_413:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_407:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 13)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_12:
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
        BEQ.W LBL_415
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_415:
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
        BEQ.W LBL_416
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_416:
        MOVE.L -4(A6),D0
        BRA.W LBL_414
LBL_414:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 14)
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
        BEQ.W LBL_418
        BRA.W LBL_417
LBL_418:
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
LBL_417:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 15)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_14:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_420
        BRA.W LBL_419
LBL_420:
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
        BEQ.W LBL_421
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_421:
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
        BEQ.W LBL_422
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
LBL_422:
LBL_419:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 16)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_15:
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
LBL_423:
        UNLK A6
        RTS
        ; func rtTextToBytes  (JT slot 17)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_16:
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
        BEQ.W LBL_425
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_426
LBL_425:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_426:
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
        BEQ.W LBL_427
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_427:
        MOVE.L -8(A6),D0
        BRA.W LBL_424
LBL_424:
        UNLK A6
        RTS
        ; func rtListGrow  (JT slot 18)
        ;   param l : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local elemsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
LBL_17:
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
        BEQ.W LBL_429
        BRA.W LBL_428
LBL_429:
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
        BEQ.W LBL_430
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_431
LBL_430:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_431:
LBL_432:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_358
        MOVE.L D0,-12(A6)
        BRA.W LBL_432
LBL_433:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_358
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
        BEQ.W LBL_434
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_434:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_428:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 19)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_18:
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
        BEQ.W LBL_436
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_436:
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
        BEQ.W LBL_437
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_437:
        MOVE.L -4(A6),D0
        BRA.W LBL_435
LBL_435:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 20)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_19:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
        BRA.W LBL_438
LBL_439:
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
LBL_438:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 21)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_20:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        BRA.W LBL_440
LBL_441:
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
        BEQ.W LBL_442
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_442:
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
        BEQ.W LBL_443
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
LBL_443:
LBL_440:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 22)
        ;   param l : 8(A6)  size 4
LBL_21:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_446
LBL_445:
        MOVEQ #0,D0
LBL_446:
        BRA.W LBL_444
LBL_444:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 23)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
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
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_448
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
        BRA.W LBL_449
LBL_448:
        MOVEQ #1,D0
LBL_449:
        TST.L D0
        BEQ.W LBL_450
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_450:
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
        BSR.W LBL_358
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        BRA.W LBL_447
LBL_447:
        UNLK A6
        RTS
        ; func rtListObsEnt  (JT slot 24)
        ;   param e : 8(A6)  size 4
LBL_23:
        LINK A6,#-52
        MOVE.L -4(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_358
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_451
LBL_451:
        UNLK A6
        RTS
        ; func rtListObsNote  (JT slot 25)
        ;   param l : 16(A6)  size 4
        ;   param op : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local cap : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
        ;   local o : -12(A6)  size 4
        ;   local m : -16(A6)  size 4
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
        MOVE.L -4(A5),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_453:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_455
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L 16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_456
LBL_455:
        MOVEQ #0,D0
LBL_456:
        TST.L D0
        BEQ.W LBL_457
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
        BEQ.W LBL_458
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_460
LBL_459:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
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
        BRA.W LBL_462
LBL_461:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
        MOVE.L 8(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_466
LBL_465:
        MOVE.L 8(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
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
LBL_467:
LBL_466:
        BRA.W LBL_464
LBL_463:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_468
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
        BEQ.W LBL_470
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_470:
        BRA.W LBL_469
LBL_468:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_471:
LBL_469:
LBL_464:
LBL_462:
LBL_460:
LBL_458:
LBL_457:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_453
LBL_454:
LBL_452:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 26)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_25:
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
        BEQ.W LBL_473
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDA.W #12,A7
LBL_473:
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
        BSR.W LBL_17
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
        BSR.W LBL_358
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
LBL_472:
        UNLK A6
        RTS
        ; func rtListRemove  (JT slot 27)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local tail : -12(A6)  size 4
LBL_26:
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
        BEQ.W LBL_475
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDA.W #12,A7
LBL_475:
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_476
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
        BRA.W LBL_477
LBL_476:
        MOVEQ #1,D0
LBL_477:
        TST.L D0
        BEQ.W LBL_478
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_478:
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
        BEQ.W LBL_479
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
        BSR.W LBL_358
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
        BSR.W LBL_358
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
        BSR.W LBL_358
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; ListBlockMoveData
LBL_479:
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
LBL_474:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 28)
        ;   param l : 8(A6)  size 4
LBL_27:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_480
LBL_480:
        UNLK A6
        RTS
        ; func mapEntrySlot  (JT slot 29)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_28:
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
        BSR.W LBL_358
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_481
LBL_481:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 30)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_29:
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
        BSR.W LBL_358
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_482
LBL_482:
        UNLK A6
        RTS
        ; func mapIndexSlot  (JT slot 31)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_30:
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
        BSR.W LBL_358
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_483
LBL_483:
        UNLK A6
        RTS
        ; func mapEntryHash  (JT slot 32)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_31:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func mapEntryKeyOff  (JT slot 33)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_32:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_485
LBL_485:
        UNLK A6
        RTS
        ; func mapEntryKeyLen  (JT slot 34)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_33:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_486
LBL_486:
        UNLK A6
        RTS
        ; func mapSetEntryMeta  (JT slot 35)
        ;   param m : 24(A6)  size 4
        ;   param i : 20(A6)  size 4
        ;   param hash : 16(A6)  size 4
        ;   param keyOff : 12(A6)  size 4
        ;   param keyLen : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_34:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
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
LBL_487:
        UNLK A6
        RTS
        ; func mapHash  (JT slot 36)
        ;   param key : 8(A6)  size 4
        ;   local klen : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local h : -12(A6)  size 4
        ;   local b : -16(A6)  size 4
LBL_35:
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
LBL_489:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
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
        BRA.W LBL_489
LBL_490:
        MOVE.L -12(A6),D0
        BRA.W LBL_488
LBL_488:
        UNLK A6
        RTS
        ; func mapPoolKeyEq  (JT slot 37)
        ;   param m : 24(A6)  size 4
        ;   param keyOff : 20(A6)  size 4
        ;   param keyLen : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param klen : 8(A6)  size 4
        ;   local base : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_36:
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
        BEQ.W LBL_492
        MOVEQ #0,D0
        BRA.W LBL_491
LBL_492:
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
LBL_493:
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_494
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
        BEQ.W LBL_495
        MOVEQ #0,D0
        BRA.W LBL_491
LBL_495:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_493
LBL_494:
        MOVEQ #1,D0
        BRA.W LBL_491
LBL_491:
        UNLK A6
        RTS
        ; func mapIndexFindSlot  (JT slot 38)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local slot : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
        ;   local steps : -20(A6)  size 4
LBL_37:
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
        BEQ.W LBL_497
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_496
LBL_497:
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
LBL_498:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_499
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
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
        BEQ.W LBL_500
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_496
LBL_500:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_501
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_502
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDA.W #20,A7
        BRA.W LBL_503
LBL_502:
        MOVEQ #0,D0
LBL_503:
        TST.L D0
        BEQ.W LBL_504
        MOVE.L -12(A6),D0
        BRA.W LBL_496
LBL_504:
LBL_501:
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
        BEQ.W LBL_505
        LEA LBL_149(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_505:
        BRA.W LBL_498
LBL_499:
LBL_496:
        UNLK A6
        RTS
        ; func mapIndexLookup  (JT slot 39)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_38:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_507
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_506
LBL_507:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_506
LBL_506:
        UNLK A6
        RTS
        ; func mapIndexSlotFor  (JT slot 40)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local firstTomb : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
        ;   local steps : -20(A6)  size 4
LBL_39:
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
LBL_509:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_510
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
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
        BEQ.W LBL_511
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_512
        MOVE.L -12(A6),D0
        BRA.W LBL_508
LBL_512:
        MOVE.L -8(A6),D0
        BRA.W LBL_508
LBL_511:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_513
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_514
LBL_513:
        MOVEQ #0,D0
LBL_514:
        TST.L D0
        BEQ.W LBL_515
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_515:
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
        BEQ.W LBL_516
        LEA LBL_149(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_516:
        BRA.W LBL_509
LBL_510:
LBL_508:
        UNLK A6
        RTS
        ; func mapIndexInsert  (JT slot 41)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param entryIdx : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local slotPtr : -12(A6)  size 4
        ;   local old : -16(A6)  size 4
LBL_40:
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
        BSR.W LBL_39
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
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
        BEQ.W LBL_518
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
LBL_518:
LBL_517:
        UNLK A6
        RTS
        ; func mapAllocIndex  (JT slot 42)
        ;   param m : 12(A6)  size 4
        ;   param newcap : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
LBL_41:
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
        BSR.W LBL_358
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
        BEQ.W LBL_520
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_520:
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
LBL_521:
        MOVE.L -16(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_522
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_358
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
        BRA.W LBL_521
LBL_522:
LBL_519:
        UNLK A6
        RTS
        ; func mapRehash  (JT slot 43)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local newcap : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local h : -16(A6)  size 4
LBL_42:
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
        BSR.W LBL_358
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
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
LBL_524:
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
        BEQ.W LBL_525
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDA.W #12,A7
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_524
LBL_525:
LBL_523:
        UNLK A6
        RTS
        ; func mapEnsureIndexCapacity  (JT slot 44)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_43:
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
        BEQ.W LBL_527
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        BRA.W LBL_526
LBL_527:
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
        BSR.W LBL_358
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        BSR.W LBL_358
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_528
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
LBL_528:
LBL_526:
        UNLK A6
        RTS
        ; func mapGrowHandle  (JT slot 45)
        ;   param h : 20(A6)  size 4
        ;   param cap : 16(A6)  size 4
        ;   param need : 12(A6)  size 4
        ;   param unit : 8(A6)  size 4
        ;   local newcap : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
LBL_44:
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
        BEQ.W LBL_530
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_531
LBL_530:
        MOVEQ #4,D0
        MOVE.L D0,-4(A6)
LBL_531:
LBL_532:
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_358
        MOVE.L D0,-4(A6)
        BRA.W LBL_532
LBL_533:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        BSR.W LBL_358
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
        BEQ.W LBL_534
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_534:
        MOVE.L -4(A6),D0
        BRA.W LBL_529
LBL_529:
        UNLK A6
        RTS
        ; func mapGrowEntries  (JT slot 46)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_45:
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
        BEQ.W LBL_536
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
        BSR.W LBL_44
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_536:
LBL_535:
        UNLK A6
        RTS
        ; func mapGrowVals  (JT slot 47)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_46:
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
        BEQ.W LBL_538
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
        BSR.W LBL_44
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_538:
LBL_537:
        UNLK A6
        RTS
        ; func mapGrowPool  (JT slot 48)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_47:
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
        BEQ.W LBL_540
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
        BSR.W LBL_44
        ADDA.W #16,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_540:
LBL_539:
        UNLK A6
        RTS
        ; func mapPoolAppend  (JT slot 49)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_48:
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
        BSR.W LBL_47
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
        BRA.W LBL_541
LBL_541:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 50)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_49:
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
        BEQ.W LBL_543
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_543:
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
        BEQ.W LBL_544
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_544:
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
        BEQ.W LBL_545
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_545:
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
        BEQ.W LBL_546
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_546:
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
        BEQ.W LBL_547
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_547:
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
        BRA.W LBL_542
LBL_542:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 51)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_50:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_549
        BRA.W LBL_548
LBL_549:
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
LBL_548:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 52)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_51:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_551
        BRA.W LBL_550
LBL_551:
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
        BEQ.W LBL_552
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_552:
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
        BEQ.W LBL_553
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
LBL_553:
LBL_550:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 53)
        ;   param m : 8(A6)  size 4
LBL_52:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_555
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_556
LBL_555:
        MOVEQ #0,D0
LBL_556:
        BRA.W LBL_554
LBL_554:
        UNLK A6
        RTS
        ; func rtMapSet  (JT slot 54)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param val : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local h : -8(A6)  size 4
        ;   local idx : -12(A6)  size 4
        ;   local klen : -16(A6)  size 4
        ;   local keyOff : -20(A6)  size 4
LBL_53:
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
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDA.W #12,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_558
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
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
        BRA.W LBL_557
LBL_558:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
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
        BSR.W LBL_45
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
        BSR.W LBL_46
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
        BSR.W LBL_48
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
        BSR.W LBL_34
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
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
        BSR.W LBL_40
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
LBL_557:
        UNLK A6
        RTS
        ; func rtMapGet  (JT slot 55)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_54:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_560
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_560:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
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
LBL_559:
        UNLK A6
        RTS
        ; func rtMapGetDv  (JT slot 56)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
LBL_55:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_562
        MOVEQ #0,D0
        BRA.W LBL_561
LBL_562:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
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
        BRA.W LBL_561
LBL_561:
        UNLK A6
        RTS
        ; func rtMapHas  (JT slot 57)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
LBL_56:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDA.W #12,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_563
LBL_563:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 58)
        ;   param m : 8(A6)  size 4
LBL_57:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_564
LBL_564:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 59)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_58:
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
        BNE.W LBL_566
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
        BRA.W LBL_567
LBL_566:
        MOVEQ #1,D0
LBL_567:
        TST.L D0
        BEQ.W LBL_568
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_568:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_29
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
LBL_565:
        UNLK A6
        RTS
        ; func rtIntMapNew  (JT slot 60)
        ;   param valsize : 8(A6)  size 4
LBL_59:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_569
LBL_569:
        UNLK A6
        RTS
        ; func rtIntMapRetain  (JT slot 61)
        ;   param m : 8(A6)  size 4
LBL_60:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
LBL_570:
        UNLK A6
        RTS
        ; func rtIntMapRelease  (JT slot 62)
        ;   param m : 8(A6)  size 4
LBL_61:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
LBL_571:
        UNLK A6
        RTS
        ; func rtIntMapLastref  (JT slot 63)
        ;   param m : 8(A6)  size 4
LBL_62:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        BRA.W LBL_572
LBL_572:
        UNLK A6
        RTS
        ; func rtIntMapCount  (JT slot 64)
        ;   param m : 8(A6)  size 4
LBL_63:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        BRA.W LBL_573
LBL_573:
        UNLK A6
        RTS
        ; func rtIntMapValAt  (JT slot 65)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_64:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDA.W #12,A7
LBL_574:
        UNLK A6
        RTS
        ; func sortedmapValSlot  (JT slot 66)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_65:
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
        BSR.W LBL_358
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_575
LBL_575:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 67)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_66:
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
        BEQ.W LBL_577
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_577:
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
        BEQ.W LBL_578
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_578:
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
        BEQ.W LBL_579
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_579:
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
        BRA.W LBL_576
LBL_576:
        UNLK A6
        RTS
        ; func rtSortedMapRetain  (JT slot 68)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_67:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_581
        BRA.W LBL_580
LBL_581:
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
LBL_580:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 69)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_68:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_583
        BRA.W LBL_582
LBL_583:
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
        BEQ.W LBL_584
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_584:
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
        BEQ.W LBL_585
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
LBL_585:
LBL_582:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 70)
        ;   param m : 8(A6)  size 4
LBL_69:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_587
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_588
LBL_587:
        MOVEQ #0,D0
LBL_588:
        BRA.W LBL_586
LBL_586:
        UNLK A6
        RTS
        ; func rtSortedMapCount  (JT slot 71)
        ;   param m : 8(A6)  size 4
LBL_70:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_589
LBL_589:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 72)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_71:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_591
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
        BRA.W LBL_592
LBL_591:
        MOVEQ #1,D0
LBL_592:
        TST.L D0
        BEQ.W LBL_593
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_593:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
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
LBL_590:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 73)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_72:
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
LBL_595:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_596
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
        BEQ.W LBL_597
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_597:
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
        BRA.W LBL_595
LBL_596:
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
        BRA.W LBL_594
LBL_594:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 74)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local v2 : -22(A6)  size 4
LBL_73:
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
        BEQ.W LBL_599
        MOVEQ #0,D1
        MOVE.L -22(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_599:
        MOVEQ #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_600
        MOVE.L -7088(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_601
LBL_600:
LBL_602:
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_603
        MOVE.L -22(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_360
        MOVE.L D0,-10(A6)
        MOVE.L -7088(A5),D1
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
        BSR.W LBL_359
        MOVE.L D0,-22(A6)
        MOVE.L -6(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_602
LBL_603:
LBL_601:
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_604
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_604:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_605:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_606
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L 8(A6),D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7088(A5),D1
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
        BRA.W LBL_605
LBL_606:
        MOVE.L -14(A6),D0
        BRA.W LBL_598
LBL_598:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 75)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_74:
        LINK A6,#-52
        MOVE.L -7100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_608
        BRA.W LBL_607
LBL_608:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_609
        BRA.W LBL_607
LBL_609:
        MOVE.L -7080(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7100(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_607:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 76)
LBL_75:
        LINK A6,#-52
        MOVE.L -7080(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -7080(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7080(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_610:
        UNLK A6
        RTS
        ; func natInit  (JT slot 77)
LBL_76:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7102(A5),D0
        TST.L D0
        BEQ.W LBL_612
        BRA.W LBL_611
LBL_612:
        MOVEQ #1,D0
        MOVE.B D0,-7102(A5)
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_613
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-7100(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7138(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7142(A5)
        BRA.W LBL_611
LBL_613:
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7080(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7084(A5)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7088(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7092(A5)
        MOVEQ #0,D0
        MOVE.L D0,-7096(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7138(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7142(A5)
        MOVE.L -7080(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7080(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7080(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7080(A5),D1
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
        MOVE.L -7080(A5),D1
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
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
        MOVE.L -7080(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7080(A5),D1
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
        BEQ.W LBL_614
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-7100(A5)
        BRA.W LBL_611
LBL_614:
        MOVE.L -7080(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-7100(A5)
        MOVE.L -7080(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7100(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7080(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_611:
        UNLK A6
        RTS
        ; func natSetCapture  (JT slot 78)
LBL_77:
        LINK A6,#-52
        MOVEQ #1,D0
        MOVE.B D0,-7110(A5)
LBL_615:
        UNLK A6
        RTS
        ; func natAppTrace  (JT slot 79)
        ;   param enable : 8(A6)  size 4
LBL_78:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-7134(A5)
LBL_616:
        UNLK A6
        RTS
        ; func natWlOpenFile  (JT slot 80)
LBL_79:
        LINK A6,#-52
        MOVE.L -7114(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7122(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7126(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7114(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7114(A5),D1
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
        BEQ.W LBL_618
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_617
LBL_618:
        MOVE.L -7114(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_617
LBL_617:
        UNLK A6
        RTS
        ; func natWlCloseFile  (JT slot 81)
        ;   param ref : 8(A6)  size 4
LBL_80:
        LINK A6,#-52
        MOVE.L -7114(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7114(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -7114(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7126(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7114(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_619:
        UNLK A6
        RTS
        ; func natAppFlushLog  (JT slot 82)
        ;   local ref : -4(A6)  size 4
        ;   local werr : -8(A6)  size 4
LBL_81:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7132(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_621
        MOVE.L -7130(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_622
LBL_621:
        MOVEQ #1,D0
LBL_622:
        TST.L D0
        BEQ.W LBL_623
        BRA.W LBL_620
LBL_623:
        BSR.W LBL_79
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_624
        MOVE.L -7114(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7130(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #46,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7114(A5),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #4,A7
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_626
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_303(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_626:
        BRA.W LBL_625
LBL_624:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_303(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_625:
        MOVEQ #0,D0
        MOVE.L D0,-7130(A5)
LBL_620:
        UNLK A6
        RTS
        ; func natWlAdd  (JT slot 83)
        ;   param s : 8(A6)  size 4
LBL_82:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7132(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_628
        BRA.W LBL_627
LBL_628:
        MOVE.L -7130(A5),D0
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
        BEQ.W LBL_629
        BSR.W LBL_81
LBL_629:
        MOVE.L -7130(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D1
        MOVE.L -7130(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-7130(A5)
LBL_627:
        UNLK A6
        RTS
        ; func natAppWriteLog  (JT slot 84)
        ;   param name : 12(A6)  size 4
        ;   param creator : 8(A6)  size 4
        ;   local ref : -4(A6)  size 4
LBL_83:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_81
        MOVEQ #0,D0
        MOVE.B D0,-7132(A5)
        MOVE.L -7114(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_631
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7114(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7118(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7122(A5)
LBL_631:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7122(A5),D0
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
        MOVE.L -7114(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A014  ; NatGetVol
        MOVE.L -7114(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-7126(A5)
        MOVE.L -7114(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7122(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7114(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D1
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
        BEQ.W LBL_632
        MOVE.L -7114(A5),D1
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
        MOVE.L -7114(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7114(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_632:
        BSR.W LBL_79
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_633
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_304(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        BRA.W LBL_630
LBL_633:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-7130(A5)
        MOVEQ #1,D0
        MOVE.B D0,-7132(A5)
LBL_630:
        UNLK A6
        RTS
        ; func natAbortLog  (JT slot 85)
        ;   param s : 8(A6)  size 4
LBL_84:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_635
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        BSR.W LBL_81
LBL_635:
LBL_634:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 86)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_85:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_637
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        BRA.W LBL_636
LBL_637:
        BSR.W LBL_76
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        BSR.W LBL_75
LBL_636:
        UNLK A6
        RTS
        ; func natLog  (JT slot 87)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_86:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_639
        BRA.W LBL_638
LBL_639:
        BSR.W LBL_76
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_640:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_642
        MOVE.L -7096(A5),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_643
LBL_642:
        MOVEQ #0,D0
LBL_643:
        TST.L D0
        BEQ.W LBL_641
        MOVE.L -7092(A5),D1
        MOVE.L -7096(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7096(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-7096(A5)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_640
LBL_641:
LBL_638:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 88)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_87:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7104(A5),D0
        TST.L D0
        BEQ.W LBL_645
        BRA.W LBL_644
LBL_645:
        MOVEQ #1,D0
        MOVE.B D0,-7104(A5)
        BSR.W LBL_81
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_646
        DC.W $A9F4  ; NatExitToShell
LBL_646:
        BSR.W LBL_76
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        MOVE.L -7092(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7096(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #8,A7
        MOVE.L -7100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        MOVE.L -7080(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7100(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_647:
        BSR.W LBL_75
        DC.W $A9F4  ; NatExitToShell
LBL_644:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 89)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_88:
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
        LEA LBL_305(PC),A0
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
        BSR.W LBL_76
        LEA -256(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-260(A6)
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -260(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
LBL_649:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_650
        MOVE.L -7138(A5),D1
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
        BCS.W LBL_651
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_9
        ADDQ.L #8,A7
LBL_651:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_649
LBL_650:
        CLR.L D0
        MOVE.B -7110(A5),D0
        TST.L D0
        BEQ.W LBL_652
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
LBL_652:
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        BSR.W LBL_81
        CLR.L D0
        MOVE.B -7414(A5),D0
        TST.L D0
        BEQ.W LBL_653
        LEA LBL_356(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_654
LBL_653:
        MOVEQ #0,D0
LBL_654:
        TST.L D0
        BEQ.W LBL_655
        MOVEQ #30,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; NatSysBeep
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7142(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7142(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7142(A5),D0
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
LBL_655:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
LBL_648:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 90)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_89:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-7146(A5)
        LEA -7402(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
LBL_656:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 91)
LBL_90:
        LINK A6,#-52
        MOVE.L -7146(A5),D0
        BRA.W LBL_657
LBL_657:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 92)
        ;   hidden result ptr : 8(A6)  size 4
LBL_91:
        LINK A6,#-52
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -7402(A5),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        BRA.W LBL_658
LBL_658:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 93)
        ;   local __ret4 : -4(A6)  size 4
LBL_92:
        LINK A6,#-56
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-12(A6)
LBL_660:
        MOVE.L A1,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -7108(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_659
LBL_659:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 94)
LBL_93:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7408(A5),D0
        TST.L D0
        BEQ.W LBL_662
        BRA.W LBL_661
LBL_662:
        MOVEQ #1,D0
        MOVE.B D0,-7408(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7406(A5)
LBL_661:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 95)
LBL_94:
        LINK A6,#-52
        MOVE.L -7406(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_663:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 96)
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
LBL_95:
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
        BEQ.W LBL_665
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_306(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_664
LBL_665:
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
        BEQ.W LBL_666
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_307(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_664
LBL_666:
        BSR.W LBL_93
        MOVE.L -7406(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_667
        MOVE.L -7406(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_667:
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_668
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_304(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_664
LBL_668:
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D0
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
        BEQ.W LBL_669
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
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7406(A5),D1
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
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_670
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_670:
LBL_669:
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_94
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_671
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_672
LBL_671:
        MOVEQ #1,D0
LBL_672:
        TST.L D0
        BEQ.W LBL_673
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_254(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_664
LBL_673:
        MOVEQ #1,D0
        BRA.W LBL_664
LBL_664:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 97)
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
LBL_96:
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
        BSR.W LBL_93
        MOVE.L -7406(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_675
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_304(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_674
LBL_675:
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_676
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_676:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_677:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_678
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -7406(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_679
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_680
LBL_679:
        MOVEQ #0,D0
LBL_680:
        TST.L D0
        BEQ.W LBL_681
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_256(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_674
LBL_681:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_682
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
LBL_682:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_683
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_684
LBL_683:
        MOVEQ #1,D0
LBL_684:
        TST.L D0
        BEQ.W LBL_685
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_685:
        BRA.W LBL_677
LBL_678:
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
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
        BRA.W LBL_674
LBL_674:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 98)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_97:
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
LBL_687:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_688
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
        BEQ.W LBL_689
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_689:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_687
LBL_688:
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
LBL_690:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_691
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
        BRA.W LBL_690
LBL_691:
LBL_686:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 99)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_98:
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
        BEQ.W LBL_693
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_308(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_692
LBL_693:
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
        BEQ.W LBL_694
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
LBL_694:
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
        BRA.W LBL_692
LBL_692:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 100)
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
LBL_99:
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
        BEQ.W LBL_696
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_306(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_695
LBL_696:
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
        BEQ.W LBL_697
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_307(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_695
LBL_697:
        BSR.W LBL_93
        MOVE.L -7406(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_698
        MOVE.L -7406(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_698:
        MOVE.L -7406(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_699
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_304(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_695
LBL_699:
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D0
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
        BEQ.W LBL_700
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
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7406(A5),D1
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
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_701
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_701:
LBL_700:
        MOVE.L -7406(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7406(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_94
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_702
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_703
LBL_702:
        MOVEQ #1,D0
LBL_703:
        TST.L D0
        BEQ.W LBL_704
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_254(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_695
LBL_704:
        MOVEQ #1,D0
        BRA.W LBL_695
LBL_695:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 101)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_100:
        LINK A6,#-52
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_95
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_706
        MOVEQ #1,D0
        BRA.W LBL_705
LBL_706:
        MOVEQ #0,D0
        BRA.W LBL_705
LBL_705:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 102)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_101:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_708
        MOVEQ #1,D0
        BRA.W LBL_707
LBL_708:
        MOVEQ #0,D0
        BRA.W LBL_707
LBL_707:
        UNLK A6
        RTS
        ; func natWlAddText  (JT slot 103)
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_102:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7132(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_710
        BRA.W LBL_709
LBL_710:
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
        BEQ.W LBL_711
        MOVE.L #511,D0
        MOVE.L D0,-8(A6)
LBL_711:
        MOVE.L -7130(A5),D1
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
        BEQ.W LBL_712
        BSR.W LBL_81
LBL_712:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D1
        MOVE.L -7130(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -7118(A5),D1
        MOVE.L -7130(A5),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7130(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-7130(A5)
LBL_709:
        UNLK A6
        RTS
        ; func strcontainersRun  (JT slot 104)
        ;   local sl : -4(A6)  size 4
        ;   local joined : -260(A6)  size 256
        ;   local sm : -264(A6)  size 4
        ;   local ka : -520(A6)  size 256
        ;   local kb : -776(A6)  size 256
        ;   local x : -786(A6)  size 10
LBL_103:
        LINK A6,#-1366
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #10,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        CLR.B (A0)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -520(A6),A0
        CLR.B (A0)
        LEA -776(A6),A0
        CLR.B (A0)
        LEA -786(A6),A0
        CLR.B (A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_324(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_325(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_714
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_716
        BRA.W LBL_717
LBL_716:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_351(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_717:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_358
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_324(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_715
LBL_714:
        MOVEQ #0,D0
LBL_715:
        TST.L D0
        BEQ.W LBL_718
        LEA LBL_326(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        BRA.W LBL_719
LBL_718:
        LEA LBL_327(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
LBL_719:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_720
        BRA.W LBL_721
LBL_720:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_351(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_721:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_358
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_328(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_722
        BRA.W LBL_723
LBL_722:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_351(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_723:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_358
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_328(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_724
        LEA LBL_329(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        BRA.W LBL_725
LBL_724:
        LEA LBL_330(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
LBL_725:
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_726:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_728
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        BSR.W LBL_22
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        LEA -786(A6),A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA -786(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
LBL_727:
        ADDQ.L #1,(A7)
        BRA.W LBL_726
LBL_728:
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_331(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_729
        LEA LBL_332(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        BRA.W LBL_730
LBL_729:
        LEA LBL_333(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
LBL_730:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_334(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-790(A6)
        MOVEQ #0,D0
        MOVE.L D0,-794(A6)
        MOVE.L -790(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -794(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_733
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_735
        BRA.W LBL_736
LBL_735:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_351(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_736:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_358
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_325(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_734
LBL_733:
        MOVEQ #0,D0
LBL_734:
        TST.L D0
        BEQ.W LBL_731
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_737
        BRA.W LBL_738
LBL_737:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_351(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_738:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_358
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_334(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_732
LBL_731:
        MOVEQ #0,D0
LBL_732:
        TST.L D0
        BEQ.W LBL_739
        LEA LBL_335(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        BRA.W LBL_740
LBL_739:
        LEA LBL_336(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
LBL_740:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_337(PC),A0
        MOVE.L A0,-(A7)
        MOVEQ #6,D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDA.W #16,A7
        LEA -1318(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_338(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_741
        LEA LBL_339(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        BRA.W LBL_742
LBL_741:
        LEA LBL_340(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
LBL_742:
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_341(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        LEA -776(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_342(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVE.L -264(A6),D0
        MOVE.L D0,-790(A6)
        MOVEQ #42,D0
        MOVE.L D0,-794(A6)
        MOVE.L -790(A6),D0
        MOVE.L D0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        LEA -776(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        LEA -794(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_53
        ADDA.W #12,A7
        MOVE.L -264(A6),D0
        MOVE.L D0,-790(A6)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        LEA -776(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1318(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-794(A6)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-798(A6)
        MOVE.L -798(A6),D0
        MOVE.L D0,-802(A6)
        MOVE.L -790(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -794(A6),D0
        MOVE.L D0,-(A7)
        LEA -802(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_55
        ADDA.W #12,A7
        MOVE.L -802(A6),D1
        MOVEQ #42,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_743
        LEA LBL_343(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        BRA.W LBL_744
LBL_743:
        LEA LBL_344(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
LBL_744:
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-1322(A6)
LBL_745:
        MOVE.L A1,-(A7)
        MOVE.L -1322(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -264(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-1322(A6)
LBL_746:
        MOVE.L A1,-(A7)
        MOVE.L -1322(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_713:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 105)
LBL_104:
        LINK A6,#-52
        BSR.W LBL_103
        BSR.W LBL_361
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
LBL_747:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 106)
        ;   param slot : 8(A6)  size 4
LBL_105:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_749
        BRA.W LBL_750
LBL_749:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_751
        BRA.W LBL_752
LBL_751:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_753
        BRA.W LBL_754
LBL_753:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_755
        BRA.W LBL_756
LBL_755:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_757
        BRA.W LBL_758
LBL_757:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_759
        BRA.W LBL_760
LBL_759:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_761
        BRA.W LBL_762
LBL_761:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_763
LBL_763:
LBL_762:
LBL_760:
LBL_758:
LBL_756:
LBL_754:
LBL_752:
LBL_750:
LBL_748:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 107)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_106:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_765
        BRA.W LBL_766
LBL_765:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_767
        BRA.W LBL_768
LBL_767:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_769
        BRA.W LBL_770
LBL_769:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_771
        BRA.W LBL_772
LBL_771:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_773
        BRA.W LBL_774
LBL_773:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_775
        BRA.W LBL_776
LBL_775:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_777
        BRA.W LBL_778
LBL_777:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_779
LBL_779:
LBL_778:
LBL_776:
LBL_774:
LBL_772:
LBL_770:
LBL_768:
LBL_766:
LBL_764:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 108)
        ;   param slot : 8(A6)  size 4
LBL_107:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_781
        BRA.W LBL_782
LBL_781:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_783
        BRA.W LBL_784
LBL_783:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_785
        BRA.W LBL_786
LBL_785:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_787
        BRA.W LBL_788
LBL_787:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_789
        BRA.W LBL_790
LBL_789:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_791
        BRA.W LBL_792
LBL_791:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_793
        BRA.W LBL_794
LBL_793:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_795
LBL_795:
LBL_794:
LBL_792:
LBL_790:
LBL_788:
LBL_786:
LBL_784:
LBL_782:
LBL_780:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 109)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_108:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_797
        BRA.W LBL_798
LBL_797:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_799
        BRA.W LBL_800
LBL_799:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_801
        BRA.W LBL_802
LBL_801:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_803
        BRA.W LBL_804
LBL_803:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_805
        BRA.W LBL_806
LBL_805:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_807
        BRA.W LBL_808
LBL_807:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_809
        BRA.W LBL_810
LBL_809:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_811
LBL_811:
LBL_810:
LBL_808:
LBL_806:
LBL_804:
LBL_802:
LBL_800:
LBL_798:
LBL_796:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 110)
LBL_109:
        LINK A6,#-52
LBL_812:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 111)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_110:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_814
        BRA.W LBL_815
LBL_814:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_816
LBL_816:
LBL_815:
LBL_813:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 112)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_111:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_818
        BRA.W LBL_819
LBL_818:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_820
LBL_820:
LBL_819:
LBL_817:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 113)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_112:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_822
        BRA.W LBL_823
LBL_822:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_824
LBL_824:
LBL_823:
LBL_821:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 114)
        ;   param slot : 8(A6)  size 4
LBL_113:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_826
        BRA.W LBL_827
LBL_826:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_828
LBL_828:
LBL_827:
LBL_825:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 115)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_114:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_830
        BRA.W LBL_831
LBL_830:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_832
LBL_832:
LBL_831:
LBL_829:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 116)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_115:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_834
        BRA.W LBL_835
LBL_834:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_836
LBL_836:
LBL_835:
LBL_833:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 117)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_116:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_838
        BRA.W LBL_839
LBL_838:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_840
LBL_840:
LBL_839:
LBL_837:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 118)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_117:
        LINK A6,#-52
        LEA LBL_345(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        BSR.W LBL_361
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
LBL_841:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 119)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_118:
        LINK A6,#-52
        LEA LBL_346(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        BSR.W LBL_361
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
LBL_842:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 120)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_119:
        LINK A6,#-52
        LEA LBL_347(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        BSR.W LBL_361
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
LBL_843:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 121)
        ;   param idx : 8(A6)  size 4
LBL_120:
        LINK A6,#-52
        LEA LBL_348(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        BSR.W LBL_361
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
LBL_844:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 122)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_121:
        LINK A6,#-52
        LEA LBL_349(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        BSR.W LBL_361
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
LBL_845:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 123)
        ;   param rowsIdx : 8(A6)  size 4
LBL_122:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #156,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_847
        LEA -7108(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_846
        BRA.W LBL_848
LBL_847:
        LEA LBL_350(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        BSR.W LBL_361
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_846
LBL_848:
LBL_846:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 124)
        ;   param path : 8(A6)  size 4
LBL_123:
        LINK A6,#-52
LBL_849:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 125)
LBL_124:
        LINK A6,#-52
LBL_850:
        UNLK A6
        RTS
        ; func clar_ui_fire_logop  (JT slot 126)
        ;   param op : 24(A6)  size 4
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_125:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_851
LBL_851:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 127)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_126:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_852
LBL_852:
        UNLK A6
        RTS
        ; func clar_ui_fire_fmtcell  (JT slot 128)
        ;   param stP : 36(A6)  size 4
        ;   param rec : 32(A6)  size 4
        ;   param recH : 28(A6)  size 4
        ;   param hstate : 24(A6)  size 4
        ;   param layoutOff : 20(A6)  size 4
        ;   param colsOff : 16(A6)  size 4
        ;   param k : 12(A6)  size 4
        ;   param colRect : 8(A6)  size 4
LBL_127:
        LINK A6,#-52
LBL_853:
        UNLK A6
        RTS
        ; func clar_ui_fire_geomapply  (JT slot 129)
LBL_128:
        LINK A6,#-52
LBL_854:
        UNLK A6
        RTS
        ; func clar_ui_fire_fontsinit  (JT slot 130)
        ;   param inst : 8(A6)  size 4
LBL_129:
        LINK A6,#-52
LBL_855:
        UNLK A6
        RTS
        ; func clar_ui_fire_drawlabel  (JT slot 131)
        ;   param instV : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_130:
        LINK A6,#-52
LBL_856:
        UNLK A6
        RTS
        ; func clar_ui_fire_labelsettext  (JT slot 132)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_131:
        LINK A6,#-52
LBL_857:
        UNLK A6
        RTS
        ; func clar_ui_fire_canvasmetric  (JT slot 133)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
LBL_132:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_858
LBL_858:
        UNLK A6
        RTS
LBL_358:
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
LBL_359:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_859
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_352(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_859:
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
        BPL.W LBL_860
        NEG.L D2
        MOVE.L #1,D4
LBL_860:
        CLR.L D5
        TST.L D3
        BPL.W LBL_861
        NEG.L D3
        MOVE.L #1,D5
LBL_861:
        CLR.L D6
        MOVE.W #31,D7
LBL_862:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_863
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_863:
        DBRA D7,LBL_862
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_864
        NEG.L D2
LBL_864:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_360:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_865
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_352(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_865:
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
        BPL.W LBL_866
        NEG.L D2
        MOVE.L #1,D4
LBL_866:
        CLR.L D5
        TST.L D3
        BPL.W LBL_867
        NEG.L D3
        MOVE.L #1,D5
LBL_867:
        CLR.L D6
        MOVE.W #31,D7
LBL_868:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_869
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_869:
        DBRA D7,LBL_868
        TST.L D4
        BEQ.W LBL_870
        NEG.L D6
LBL_870:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_361:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_871(PC),A0
        MOVE.L A0,-4(A6)
LBL_872:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_873
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_874
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_872
LBL_874:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_875:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_872
LBL_873:
        UNLK A6
        RTS
LBL_871:
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
        DC.W $0000
        DC.W $0000
        ; constant pool: string literals
LBL_133:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_134:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_135:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_136:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_137:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_138:
        DC.B $01
        DC.B $30
LBL_139:
        DC.B $00
        DC.B $00
LBL_140:
        DC.B $01
        DC.B $2D
LBL_141:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_142:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_143:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_144:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_145:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_146:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_147:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_148:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_149:
        DC.B $12
        DC.B $6D,$61,$70,$3A,$20,$69,$6E,$64,$65,$78,$20,$63,$6F,$72,$72,$75,$70,$74
        DC.B $00
LBL_150:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_151:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_152:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_153:
        DC.B $01
        DC.B $78
LBL_154:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_155:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_156:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_157:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_158:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_159:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_160:
        DC.B $0C
        DC.B $53,$65,$6C,$65,$63,$74,$20,$41,$6C,$6C,$2F,$41
        DC.B $00
LBL_161:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
LBL_162:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_163:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_164:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_165:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_166:
        DC.B $03
        DC.B $6B,$65,$79
LBL_167:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_168:
        DC.B $01
        DC.B $3F
LBL_169:
        DC.B $0D
        DC.B $74,$61,$62,$6C,$65,$20,$63,$6F,$6C,$75,$6D,$6E,$20
LBL_170:
        DC.B $13
        DC.B $3A,$20,$66,$6F,$72,$6D,$61,$74,$74,$65,$72,$20,$61,$62,$6F,$72,$74,$65,$64
LBL_171:
        DC.B $06
        DC.B $73,$65,$6C,$65,$63,$74
        DC.B $00
LBL_172:
        DC.B $0B
        DC.B $64,$6F,$75,$62,$6C,$65,$43,$6C,$69,$63,$6B
LBL_173:
        DC.B $78
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$66,$6F,$75,$6E,$64,$20,$6E,$6F,$20,$6D,$65,$6E,$75,$20,$69,$6E,$20,$74,$68,$65,$20,$6D,$65,$6E,$75,$20,$6C,$69,$73,$74,$20,$66,$6F,$72,$20,$74,$68,$69,$73,$20,$77,$69,$64,$67,$65,$74,$20,$28,$63,$6C,$6F,$73,$65,$2F,$72,$65,$6F,$70,$65,$6E,$20,$6C,$65,$66,$74,$20,$69,$74,$20,$75,$6E,$64,$65,$6C,$65,$74,$65,$64,$20,$6F,$72,$20,$6E,$65,$76,$65,$72,$20,$72,$65,$69,$6E,$73,$65,$72,$74,$65,$64,$29
        DC.B $00
LBL_174:
        DC.B $71
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$72,$65,$74,$75,$72,$6E,$65,$64,$20,$61,$20,$6D,$65,$6E,$75,$20,$68,$61,$6E,$64,$6C,$65,$20,$74,$68,$61,$74,$20,$69,$73,$6E,$27,$74,$20,$74,$68,$69,$73,$20,$69,$6E,$73,$74,$61,$6E,$63,$65,$27,$73,$20,$6F,$77,$6E,$20,$28,$73,$74,$61,$6C,$65,$2F,$6C,$65,$61,$6B,$65,$64,$20,$65,$6E,$74,$72,$79,$20,$75,$6E,$64,$65,$72,$20,$74,$68,$65,$20,$73,$61,$6D,$65,$20,$49,$44,$29
LBL_175:
        DC.B $57
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$6D,$65,$6E,$75,$20,$69,$74,$65,$6D,$20,$63,$6F,$75,$6E,$74,$20,$64,$6F,$65,$73,$6E,$27,$74,$20,$6D,$61,$74,$63,$68,$20,$74,$68,$65,$20,$62,$6F,$75,$6E,$64,$20,$65,$6E,$75,$6D,$20,$28,$72,$65,$62,$75,$69,$6C,$74,$20,$77,$69,$74,$68,$20,$73,$74,$61,$6C,$65,$2F,$6C,$65,$66,$74,$6F,$76,$65,$72,$20,$69,$74,$65,$6D,$73,$29
LBL_176:
        DC.B $24
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_177:
        DC.B $02
        DC.B $6F,$6E
        DC.B $00
LBL_178:
        DC.B $03
        DC.B $6F,$66,$66
LBL_179:
        DC.B $22
        DC.B $6A,$69,$67,$67,$6C,$65,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$6F,$6E,$7C,$6F,$66,$66,$29
        DC.B $00
LBL_180:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$61,$6E,$73,$77,$65,$72,$20,$71,$75,$65,$75,$65,$20,$6F,$76,$65,$72,$66,$6C,$6F,$77
LBL_181:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$77,$69,$74,$68,$20,$6E,$6F,$20,$71,$75,$65,$75,$65,$64,$20,$61,$6E,$73,$77,$65,$72
LBL_182:
        DC.B $07
        DC.B $54,$20,$4F,$50,$45,$4E,$20
LBL_183:
        DC.B $01
        DC.B $20
LBL_184:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_185:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_186:
        DC.B $01
        DC.B $2E
LBL_187:
        DC.B $07
        DC.B $2E,$73,$65,$6C,$65,$63,$74
LBL_188:
        DC.B $0D
        DC.B $54,$20,$46,$49,$52,$45,$20,$65,$76,$65,$72,$79,$2E
LBL_189:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_190:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_191:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_192:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_193:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_194:
        DC.B $0B
        DC.B $2E,$53,$65,$6C,$65,$63,$74,$41,$6C,$6C,$20
LBL_195:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_196:
        DC.B $08
        DC.B $54,$20,$41,$42,$4F,$55,$54,$20
        DC.B $00
LBL_197:
        DC.B $01
        DC.B $7C
LBL_198:
        DC.B $07
        DC.B $63,$61,$70,$74,$69,$6F,$6E
LBL_199:
        DC.B $04
        DC.B $74,$65,$78,$74
        DC.B $00
LBL_200:
        DC.B $07
        DC.B $65,$6E,$61,$62,$6C,$65,$64
LBL_201:
        DC.B $07
        DC.B $63,$68,$65,$63,$6B,$65,$64
LBL_202:
        DC.B $08
        DC.B $73,$65,$6C,$65,$63,$74,$65,$64
        DC.B $00
LBL_203:
        DC.B $05
        DC.B $77,$69,$64,$74,$68
LBL_204:
        DC.B $06
        DC.B $68,$65,$69,$67,$68,$74
        DC.B $00
LBL_205:
        DC.B $06
        DC.B $54,$20,$53,$45,$54,$20
        DC.B $00
LBL_206:
        DC.B $09
        DC.B $2E,$69,$6E,$76,$61,$6C,$69,$64,$2E
LBL_207:
        DC.B $02
        DC.B $54,$20
        DC.B $00
LBL_208:
        DC.B $0A
        DC.B $54,$20,$4F,$50,$45,$4E,$44,$4F,$43,$20
        DC.B $00
LBL_209:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_210:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_211:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_212:
        DC.B $37
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$73,$61,$76,$65,$7C,$64,$69,$73,$63,$61,$72,$64,$7C,$63,$61,$6E,$63,$65,$6C,$29
LBL_213:
        DC.B $23
        DC.B $73,$6E,$61,$70,$3A,$20,$73,$63,$72,$65,$65,$6E,$42,$69,$74,$73,$2E,$72,$6F,$77,$42,$79,$74,$65,$73,$20,$69,$73,$20,$6E,$6F,$74,$20,$36,$34
LBL_214:
        DC.B $10
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$23,$23,$20
        DC.B $00
LBL_215:
        DC.B $13
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$2D,$45,$4E,$44,$23,$23
LBL_216:
        DC.B $2C
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$6B,$6E,$6F,$77,$6E,$20,$6F,$72,$20,$75,$6E,$73,$75,$70,$70,$6F,$72,$74,$65,$64,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$76,$65,$72,$62
        DC.B $00
LBL_217:
        DC.B $08
        DC.B $64,$62,$6C,$63,$6C,$69,$63,$6B
        DC.B $00
LBL_218:
        DC.B $04
        DC.B $74,$79,$70,$65
        DC.B $00
LBL_219:
        DC.B $04
        DC.B $6D,$65,$6E,$75
        DC.B $00
LBL_220:
        DC.B $05
        DC.B $63,$6C,$6F,$73,$65
LBL_221:
        DC.B $06
        DC.B $72,$65,$73,$69,$7A,$65
        DC.B $00
LBL_222:
        DC.B $04
        DC.B $7A,$6F,$6F,$6D
        DC.B $00
LBL_223:
        DC.B $05
        DC.B $64,$65,$6C,$61,$79
LBL_224:
        DC.B $04
        DC.B $74,$69,$63,$6B
        DC.B $00
LBL_225:
        DC.B $04
        DC.B $73,$6E,$61,$70
        DC.B $00
LBL_226:
        DC.B $06
        DC.B $6A,$69,$67,$67,$6C,$65
        DC.B $00
LBL_227:
        DC.B $04
        DC.B $71,$75,$69,$74
        DC.B $00
LBL_228:
        DC.B $09
        DC.B $6C,$61,$75,$6E,$63,$68,$64,$6F,$63
LBL_229:
        DC.B $0C
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$70,$6F,$70,$75,$70
        DC.B $00
LBL_230:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$6F,$70,$65,$6E
LBL_231:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$73,$61,$76,$65
LBL_232:
        DC.B $0E
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73
        DC.B $00
LBL_233:
        DC.B $0D
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$61,$6E,$63,$65,$6C
LBL_234:
        DC.B $2A
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$6D,$75,$73,$74,$20,$68,$61,$76,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$65,$6E,$74,$72,$69,$65,$73
        DC.B $00
LBL_235:
        DC.B $31
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$65,$6E,$74,$72,$79,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_236:
        DC.B $08
        DC.B $53,$61,$76,$65,$20,$61,$73,$3A
        DC.B $00
LBL_237:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_238:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_239:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_240:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_241:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_242:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_243:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_244:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_245:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_246:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_247:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_248:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_249:
        DC.B $01
        DC.B $3A
LBL_250:
        DC.B $02
        DC.B $68,$20
        DC.B $00
LBL_251:
        DC.B $02
        DC.B $6D,$20
        DC.B $00
LBL_252:
        DC.B $01
        DC.B $73
LBL_253:
        DC.B $1F
        DC.B $72,$65,$63,$6F,$72,$64,$20,$74,$6F,$6F,$20,$6C,$61,$72,$67,$65,$20,$66,$6F,$72,$20,$73,$65,$72,$69,$61,$6C,$69,$7A,$65,$72
LBL_254:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_255:
        DC.B $0F
        DC.B $62,$61,$64,$20,$66,$69,$6C,$65,$20,$66,$6F,$72,$6D,$61,$74
LBL_256:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_257:
        DC.B $05
        DC.B $6D,$6F,$64,$65,$6D
LBL_258:
        DC.B $07
        DC.B $70,$72,$69,$6E,$74,$65,$72
LBL_259:
        DC.B $15
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_260:
        DC.B $17
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_261:
        DC.B $19
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_262:
        DC.B $17
        DC.B $69,$6E,$76,$61,$6C,$69,$64,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$73,$70,$65,$63
LBL_263:
        DC.B $13
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E
LBL_264:
        DC.B $0C
        DC.B $77,$72,$69,$74,$65,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_265:
        DC.B $05
        DC.B $2E,$41,$4F,$75,$74
LBL_266:
        DC.B $04
        DC.B $2E,$41,$49,$6E
        DC.B $00
LBL_267:
        DC.B $05
        DC.B $2E,$42,$4F,$75,$74
LBL_268:
        DC.B $04
        DC.B $2E,$42,$49,$6E
        DC.B $00
LBL_269:
        DC.B $0B
        DC.B $6E,$61,$6D,$65,$20,$69,$6E,$20,$75,$73,$65
LBL_270:
        DC.B $17
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$67,$69,$73,$74,$65,$72,$20,$6E,$61,$6D,$65
LBL_271:
        DC.B $12
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$73,$65,$72,$76,$69,$63,$65
        DC.B $00
LBL_272:
        DC.B $17
        DC.B $73,$65,$72,$76,$69,$63,$65,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$73,$65,$72,$76,$69,$6E,$67
LBL_273:
        DC.B $15
        DC.B $41,$70,$70,$6C,$65,$54,$61,$6C,$6B,$20,$75,$6E,$61,$76,$61,$69,$6C,$61,$62,$6C,$65
LBL_274:
        DC.B $15
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$73,$6F,$63,$6B,$65,$74
LBL_275:
        DC.B $1A
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$63,$65,$69,$76,$65,$20,$72,$65,$71,$75,$65,$73,$74,$73
        DC.B $00
LBL_276:
        DC.B $1F
        DC.B $72,$65,$70,$6C,$79,$20,$6F,$75,$74,$73,$69,$64,$65,$20,$61,$20,$72,$65,$71,$75,$65,$73,$74,$20,$68,$61,$6E,$64,$6C,$65,$72
LBL_277:
        DC.B $12
        DC.B $72,$65,$70,$6C,$79,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$73,$65,$6E,$74
        DC.B $00
LBL_278:
        DC.B $0E
        DC.B $72,$65,$70,$6C,$79,$20,$74,$6F,$6F,$20,$6C,$6F,$6E,$67
        DC.B $00
LBL_279:
        DC.B $0C
        DC.B $72,$65,$70,$6C,$79,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_280:
        DC.B $10
        DC.B $72,$65,$71,$75,$65,$73,$74,$20,$74,$6F,$6F,$20,$6C,$6F,$6E,$67
        DC.B $00
LBL_281:
        DC.B $0B
        DC.B $6E,$6F,$20,$72,$65,$73,$70,$6F,$6E,$73,$65
LBL_282:
        DC.B $07
        DC.B $73,$65,$72,$76,$69,$63,$65
LBL_283:
        DC.B $0E
        DC.B $6E,$61,$6D,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_284:
        DC.B $01
        DC.B $2A
LBL_285:
        DC.B $19
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$73,$65,$72,$76,$69,$63,$65,$42,$72,$6F,$77,$73,$65,$72
LBL_286:
        DC.B $01
        DC.B $3D
LBL_287:
        DC.B $0D
        DC.B $6C,$6F,$6F,$6B,$75,$70,$20,$66,$61,$69,$6C,$65,$64
LBL_288:
        DC.B $13
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$6C,$69,$73,$74,$65,$6E,$65,$72
LBL_289:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$65,$6E,$65,$72,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$72,$65,$67,$69,$73,$74,$65,$72,$65,$64
LBL_290:
        DC.B $22
        DC.B $73,$74,$72,$65,$61,$6D,$73,$20,$6E,$6F,$74,$20,$61,$76,$61,$69,$6C,$61,$62,$6C,$65,$20,$6F,$6E,$20,$74,$68,$69,$73,$20,$6C,$61,$6E,$65
        DC.B $00
LBL_291:
        DC.B $18
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$73,$74,$61,$72,$74,$20,$6C,$69,$73,$74,$65,$6E,$65,$72
        DC.B $00
LBL_292:
        DC.B $0E
        DC.B $72,$65,$71,$75,$65,$73,$74,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_293:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$65,$6E,$65,$72,$20,$66,$61,$69,$6C,$65,$64
LBL_294:
        DC.B $1B
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$61,$63,$63,$65,$70,$74,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_295:
        DC.B $04
        DC.B $2E,$4D,$50,$50
        DC.B $00
LBL_296:
        DC.B $04
        DC.B $2E,$41,$54,$50
        DC.B $00
LBL_297:
        DC.B $04
        DC.B $2E,$58,$50,$50
        DC.B $00
LBL_298:
        DC.B $04
        DC.B $2E,$44,$53,$50
        DC.B $00
LBL_299:
        DC.B $0C
        DC.B $69,$6E,$76,$61,$6C,$69,$64,$20,$70,$6F,$72,$74
        DC.B $00
LBL_300:
        DC.B $0F
        DC.B $54,$43,$50,$20,$75,$6E,$61,$76,$61,$69,$6C,$61,$62,$6C,$65
LBL_301:
        DC.B $0B
        DC.B $70,$6F,$72,$74,$20,$69,$6E,$20,$75,$73,$65
LBL_302:
        DC.B $04
        DC.B $2E,$49,$50,$50
        DC.B $00
LBL_303:
        DC.B $18
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$6C,$6F,$67,$20,$66,$69,$6C,$65
        DC.B $00
LBL_304:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_305:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_306:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_307:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_308:
        DC.B $12
        DC.B $72,$65,$73,$6F,$75,$72,$63,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_309:
        DC.B $0B
        DC.B $6F,$70,$65,$6E,$20,$66,$61,$69,$6C,$65,$64
LBL_310:
        DC.B $0D
        DC.B $63,$72,$65,$61,$74,$65,$20,$66,$61,$69,$6C,$65,$64
LBL_311:
        DC.B $15
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$66,$69,$6C,$65,$68,$61,$6E,$64,$6C,$65
LBL_312:
        DC.B $20
        DC.B $66,$69,$6C,$65,$68,$61,$6E,$64,$6C,$65,$20,$70,$6F,$73,$69,$74,$69,$6F,$6E,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_313:
        DC.B $0B
        DC.B $72,$65,$61,$64,$20,$66,$61,$69,$6C,$65,$64
LBL_314:
        DC.B $0B
        DC.B $73,$69,$7A,$65,$20,$66,$61,$69,$6C,$65,$64
LBL_315:
        DC.B $0E
        DC.B $73,$65,$74,$53,$69,$7A,$65,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_316:
        DC.B $0C
        DC.B $66,$6C,$75,$73,$68,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_317:
        DC.B $0B
        DC.B $69,$6E,$66,$6F,$20,$66,$61,$69,$6C,$65,$64
LBL_318:
        DC.B $0E
        DC.B $6D,$61,$6B,$65,$44,$69,$72,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_319:
        DC.B $0D
        DC.B $64,$65,$6C,$65,$74,$65,$20,$66,$61,$69,$6C,$65,$64
LBL_320:
        DC.B $0B
        DC.B $6C,$69,$73,$74,$20,$66,$61,$69,$6C,$65,$64
LBL_321:
        DC.B $0E
        DC.B $73,$65,$74,$49,$6E,$66,$6F,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_322:
        DC.B $0D
        DC.B $72,$65,$6E,$61,$6D,$65,$20,$66,$61,$69,$6C,$65,$64
LBL_323:
        DC.B $0B
        DC.B $6D,$6F,$76,$65,$20,$66,$61,$69,$6C,$65,$64
LBL_324:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_325:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_326:
        DC.B $21
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$70,$75,$73,$68,$2F,$63,$6F,$75,$6E,$74,$2F,$69,$6E,$64,$65,$78,$2D,$72,$65,$61,$64,$20,$6F,$6B
LBL_327:
        DC.B $23
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$70,$75,$73,$68,$2F,$63,$6F,$75,$6E,$74,$2F,$69,$6E,$64,$65,$78,$2D,$72,$65,$61,$64,$20,$46,$41,$49,$4C
LBL_328:
        DC.B $05
        DC.B $47,$41,$4D,$4D,$41
LBL_329:
        DC.B $17
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$2D,$77,$72,$69,$74,$65,$20,$6F,$6B
LBL_330:
        DC.B $19
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$2D,$77,$72,$69,$74,$65,$20,$46,$41,$49,$4C
LBL_331:
        DC.B $09
        DC.B $47,$41,$4D,$4D,$41,$62,$65,$74,$61
LBL_332:
        DC.B $1C
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$69,$74,$65,$72,$61,$74,$65,$20,$6F,$6B
        DC.B $00
LBL_333:
        DC.B $1E
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$69,$74,$65,$72,$61,$74,$65,$20,$46,$41,$49,$4C
        DC.B $00
LBL_334:
        DC.B $05
        DC.B $64,$65,$6C,$74,$61
LBL_335:
        DC.B $12
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$72,$65,$6D,$6F,$76,$65,$20,$6F,$6B
        DC.B $00
LBL_336:
        DC.B $14
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$72,$65,$6D,$6F,$76,$65,$20,$46,$41,$49,$4C
        DC.B $00
LBL_337:
        DC.B $0B
        DC.B $68,$65,$6C,$6C,$6F,$20,$77,$6F,$72,$6C,$64
LBL_338:
        DC.B $05
        DC.B $77,$6F,$72,$6C,$64
LBL_339:
        DC.B $20
        DC.B $73,$74,$72,$69,$6E,$67,$20,$73,$6C,$69,$63,$65,$20,$69,$6E,$20,$65,$78,$70,$72,$20,$70,$6F,$73,$69,$74,$69,$6F,$6E,$20,$6F,$6B
        DC.B $00
LBL_340:
        DC.B $22
        DC.B $73,$74,$72,$69,$6E,$67,$20,$73,$6C,$69,$63,$65,$20,$69,$6E,$20,$65,$78,$70,$72,$20,$70,$6F,$73,$69,$74,$69,$6F,$6E,$20,$46,$41,$49,$4C
        DC.B $00
LBL_341:
        DC.B $02
        DC.B $66,$6F
        DC.B $00
LBL_342:
        DC.B $01
        DC.B $6F
LBL_343:
        DC.B $2A
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$66,$72,$6F,$6D,$20,$63,$6F,$6E,$63,$61,$74,$20,$65,$78,$70,$72,$20,$28,$6D,$61,$74,$65,$72,$69,$61,$6C,$69,$7A,$65,$64,$29,$20,$6F,$6B
        DC.B $00
LBL_344:
        DC.B $2C
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$66,$72,$6F,$6D,$20,$63,$6F,$6E,$63,$61,$74,$20,$65,$78,$70,$72,$20,$28,$6D,$61,$74,$65,$72,$69,$61,$6C,$69,$7A,$65,$64,$29,$20,$46,$41,$49,$4C
        DC.B $00
LBL_345:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_346:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_347:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_348:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_349:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_350:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_351:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_352:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
        ; constant pool: array literals
LBL_353:
        DC.L $00000000
        DC.L $00001189
        DC.L $00002312
        DC.L $0000329B
        DC.L $00004624
        DC.L $000057AD
        DC.L $00006536
        DC.L $000074BF
        DC.L $00008C48
        DC.L $00009DC1
        DC.L $0000AF5A
        DC.L $0000BED3
        DC.L $0000CA6C
        DC.L $0000DBE5
        DC.L $0000E97E
        DC.L $0000F8F7
        DC.L $00001081
        DC.L $00000108
        DC.L $00003393
        DC.L $0000221A
        DC.L $000056A5
        DC.L $0000472C
        DC.L $000075B7
        DC.L $0000643E
        DC.L $00009CC9
        DC.L $00008D40
        DC.L $0000BFDB
        DC.L $0000AE52
        DC.L $0000DAED
        DC.L $0000CB64
        DC.L $0000F9FF
        DC.L $0000E876
        DC.L $00002102
        DC.L $0000308B
        DC.L $00000210
        DC.L $00001399
        DC.L $00006726
        DC.L $000076AF
        DC.L $00004434
        DC.L $000055BD
        DC.L $0000AD4A
        DC.L $0000BCC3
        DC.L $00008E58
        DC.L $00009FD1
        DC.L $0000EB6E
        DC.L $0000FAE7
        DC.L $0000C87C
        DC.L $0000D9F5
        DC.L $00003183
        DC.L $0000200A
        DC.L $00001291
        DC.L $00000318
        DC.L $000077A7
        DC.L $0000662E
        DC.L $000054B5
        DC.L $0000453C
        DC.L $0000BDCB
        DC.L $0000AC42
        DC.L $00009ED9
        DC.L $00008F50
        DC.L $0000FBEF
        DC.L $0000EA66
        DC.L $0000D8FD
        DC.L $0000C974
        DC.L $00004204
        DC.L $0000538D
        DC.L $00006116
        DC.L $0000709F
        DC.L $00000420
        DC.L $000015A9
        DC.L $00002732
        DC.L $000036BB
        DC.L $0000CE4C
        DC.L $0000DFC5
        DC.L $0000ED5E
        DC.L $0000FCD7
        DC.L $00008868
        DC.L $000099E1
        DC.L $0000AB7A
        DC.L $0000BAF3
        DC.L $00005285
        DC.L $0000430C
        DC.L $00007197
        DC.L $0000601E
        DC.L $000014A1
        DC.L $00000528
        DC.L $000037B3
        DC.L $0000263A
        DC.L $0000DECD
        DC.L $0000CF44
        DC.L $0000FDDF
        DC.L $0000EC56
        DC.L $000098E9
        DC.L $00008960
        DC.L $0000BBFB
        DC.L $0000AA72
        DC.L $00006306
        DC.L $0000728F
        DC.L $00004014
        DC.L $0000519D
        DC.L $00002522
        DC.L $000034AB
        DC.L $00000630
        DC.L $000017B9
        DC.L $0000EF4E
        DC.L $0000FEC7
        DC.L $0000CC5C
        DC.L $0000DDD5
        DC.L $0000A96A
        DC.L $0000B8E3
        DC.L $00008A78
        DC.L $00009BF1
        DC.L $00007387
        DC.L $0000620E
        DC.L $00005095
        DC.L $0000411C
        DC.L $000035A3
        DC.L $0000242A
        DC.L $000016B1
        DC.L $00000738
        DC.L $0000FFCF
        DC.L $0000EE46
        DC.L $0000DCDD
        DC.L $0000CD54
        DC.L $0000B9EB
        DC.L $0000A862
        DC.L $00009AF9
        DC.L $00008B70
        DC.L $00008408
        DC.L $00009581
        DC.L $0000A71A
        DC.L $0000B693
        DC.L $0000C22C
        DC.L $0000D3A5
        DC.L $0000E13E
        DC.L $0000F0B7
        DC.L $00000840
        DC.L $000019C9
        DC.L $00002B52
        DC.L $00003ADB
        DC.L $00004E64
        DC.L $00005FED
        DC.L $00006D76
        DC.L $00007CFF
        DC.L $00009489
        DC.L $00008500
        DC.L $0000B79B
        DC.L $0000A612
        DC.L $0000D2AD
        DC.L $0000C324
        DC.L $0000F1BF
        DC.L $0000E036
        DC.L $000018C1
        DC.L $00000948
        DC.L $00003BD3
        DC.L $00002A5A
        DC.L $00005EE5
        DC.L $00004F6C
        DC.L $00007DF7
        DC.L $00006C7E
        DC.L $0000A50A
        DC.L $0000B483
        DC.L $00008618
        DC.L $00009791
        DC.L $0000E32E
        DC.L $0000F2A7
        DC.L $0000C03C
        DC.L $0000D1B5
        DC.L $00002942
        DC.L $000038CB
        DC.L $00000A50
        DC.L $00001BD9
        DC.L $00006F66
        DC.L $00007EEF
        DC.L $00004C74
        DC.L $00005DFD
        DC.L $0000B58B
        DC.L $0000A402
        DC.L $00009699
        DC.L $00008710
        DC.L $0000F3AF
        DC.L $0000E226
        DC.L $0000D0BD
        DC.L $0000C134
        DC.L $000039C3
        DC.L $0000284A
        DC.L $00001AD1
        DC.L $00000B58
        DC.L $00007FE7
        DC.L $00006E6E
        DC.L $00005CF5
        DC.L $00004D7C
        DC.L $0000C60C
        DC.L $0000D785
        DC.L $0000E51E
        DC.L $0000F497
        DC.L $00008028
        DC.L $000091A1
        DC.L $0000A33A
        DC.L $0000B2B3
        DC.L $00004A44
        DC.L $00005BCD
        DC.L $00006956
        DC.L $000078DF
        DC.L $00000C60
        DC.L $00001DE9
        DC.L $00002F72
        DC.L $00003EFB
        DC.L $0000D68D
        DC.L $0000C704
        DC.L $0000F59F
        DC.L $0000E416
        DC.L $000090A9
        DC.L $00008120
        DC.L $0000B3BB
        DC.L $0000A232
        DC.L $00005AC5
        DC.L $00004B4C
        DC.L $000079D7
        DC.L $0000685E
        DC.L $00001CE1
        DC.L $00000D68
        DC.L $00003FF3
        DC.L $00002E7A
        DC.L $0000E70E
        DC.L $0000F687
        DC.L $0000C41C
        DC.L $0000D595
        DC.L $0000A12A
        DC.L $0000B0A3
        DC.L $00008238
        DC.L $000093B1
        DC.L $00006B46
        DC.L $00007ACF
        DC.L $00004854
        DC.L $000059DD
        DC.L $00002D62
        DC.L $00003CEB
        DC.L $00000E70
        DC.L $00001FF9
        DC.L $0000F78F
        DC.L $0000E606
        DC.L $0000D49D
        DC.L $0000C514
        DC.L $0000B1AB
        DC.L $0000A022
        DC.L $000092B9
        DC.L $00008330
        DC.L $00007BC7
        DC.L $00006A4E
        DC.L $000058D5
        DC.L $0000495C
        DC.L $00003DE3
        DC.L $00002C6A
        DC.L $00001EF1
        DC.L $00000F78
LBL_354:
        DC.L $00000000
        DC.L $00001021
        DC.L $00002042
        DC.L $00003063
        DC.L $00004084
        DC.L $000050A5
        DC.L $000060C6
        DC.L $000070E7
        DC.L $00008108
        DC.L $00009129
        DC.L $0000A14A
        DC.L $0000B16B
        DC.L $0000C18C
        DC.L $0000D1AD
        DC.L $0000E1CE
        DC.L $0000F1EF
        DC.L $00001231
        DC.L $00000210
        DC.L $00003273
        DC.L $00002252
        DC.L $000052B5
        DC.L $00004294
        DC.L $000072F7
        DC.L $000062D6
        DC.L $00009339
        DC.L $00008318
        DC.L $0000B37B
        DC.L $0000A35A
        DC.L $0000D3BD
        DC.L $0000C39C
        DC.L $0000F3FF
        DC.L $0000E3DE
        DC.L $00002462
        DC.L $00003443
        DC.L $00000420
        DC.L $00001401
        DC.L $000064E6
        DC.L $000074C7
        DC.L $000044A4
        DC.L $00005485
        DC.L $0000A56A
        DC.L $0000B54B
        DC.L $00008528
        DC.L $00009509
        DC.L $0000E5EE
        DC.L $0000F5CF
        DC.L $0000C5AC
        DC.L $0000D58D
        DC.L $00003653
        DC.L $00002672
        DC.L $00001611
        DC.L $00000630
        DC.L $000076D7
        DC.L $000066F6
        DC.L $00005695
        DC.L $000046B4
        DC.L $0000B75B
        DC.L $0000A77A
        DC.L $00009719
        DC.L $00008738
        DC.L $0000F7DF
        DC.L $0000E7FE
        DC.L $0000D79D
        DC.L $0000C7BC
        DC.L $000048C4
        DC.L $000058E5
        DC.L $00006886
        DC.L $000078A7
        DC.L $00000840
        DC.L $00001861
        DC.L $00002802
        DC.L $00003823
        DC.L $0000C9CC
        DC.L $0000D9ED
        DC.L $0000E98E
        DC.L $0000F9AF
        DC.L $00008948
        DC.L $00009969
        DC.L $0000A90A
        DC.L $0000B92B
        DC.L $00005AF5
        DC.L $00004AD4
        DC.L $00007AB7
        DC.L $00006A96
        DC.L $00001A71
        DC.L $00000A50
        DC.L $00003A33
        DC.L $00002A12
        DC.L $0000DBFD
        DC.L $0000CBDC
        DC.L $0000FBBF
        DC.L $0000EB9E
        DC.L $00009B79
        DC.L $00008B58
        DC.L $0000BB3B
        DC.L $0000AB1A
        DC.L $00006CA6
        DC.L $00007C87
        DC.L $00004CE4
        DC.L $00005CC5
        DC.L $00002C22
        DC.L $00003C03
        DC.L $00000C60
        DC.L $00001C41
        DC.L $0000EDAE
        DC.L $0000FD8F
        DC.L $0000CDEC
        DC.L $0000DDCD
        DC.L $0000AD2A
        DC.L $0000BD0B
        DC.L $00008D68
        DC.L $00009D49
        DC.L $00007E97
        DC.L $00006EB6
        DC.L $00005ED5
        DC.L $00004EF4
        DC.L $00003E13
        DC.L $00002E32
        DC.L $00001E51
        DC.L $00000E70
        DC.L $0000FF9F
        DC.L $0000EFBE
        DC.L $0000DFDD
        DC.L $0000CFFC
        DC.L $0000BF1B
        DC.L $0000AF3A
        DC.L $00009F59
        DC.L $00008F78
        DC.L $00009188
        DC.L $000081A9
        DC.L $0000B1CA
        DC.L $0000A1EB
        DC.L $0000D10C
        DC.L $0000C12D
        DC.L $0000F14E
        DC.L $0000E16F
        DC.L $00001080
        DC.L $000000A1
        DC.L $000030C2
        DC.L $000020E3
        DC.L $00005004
        DC.L $00004025
        DC.L $00007046
        DC.L $00006067
        DC.L $000083B9
        DC.L $00009398
        DC.L $0000A3FB
        DC.L $0000B3DA
        DC.L $0000C33D
        DC.L $0000D31C
        DC.L $0000E37F
        DC.L $0000F35E
        DC.L $000002B1
        DC.L $00001290
        DC.L $000022F3
        DC.L $000032D2
        DC.L $00004235
        DC.L $00005214
        DC.L $00006277
        DC.L $00007256
        DC.L $0000B5EA
        DC.L $0000A5CB
        DC.L $000095A8
        DC.L $00008589
        DC.L $0000F56E
        DC.L $0000E54F
        DC.L $0000D52C
        DC.L $0000C50D
        DC.L $000034E2
        DC.L $000024C3
        DC.L $000014A0
        DC.L $00000481
        DC.L $00007466
        DC.L $00006447
        DC.L $00005424
        DC.L $00004405
        DC.L $0000A7DB
        DC.L $0000B7FA
        DC.L $00008799
        DC.L $000097B8
        DC.L $0000E75F
        DC.L $0000F77E
        DC.L $0000C71D
        DC.L $0000D73C
        DC.L $000026D3
        DC.L $000036F2
        DC.L $00000691
        DC.L $000016B0
        DC.L $00006657
        DC.L $00007676
        DC.L $00004615
        DC.L $00005634
        DC.L $0000D94C
        DC.L $0000C96D
        DC.L $0000F90E
        DC.L $0000E92F
        DC.L $000099C8
        DC.L $000089E9
        DC.L $0000B98A
        DC.L $0000A9AB
        DC.L $00005844
        DC.L $00004865
        DC.L $00007806
        DC.L $00006827
        DC.L $000018C0
        DC.L $000008E1
        DC.L $00003882
        DC.L $000028A3
        DC.L $0000CB7D
        DC.L $0000DB5C
        DC.L $0000EB3F
        DC.L $0000FB1E
        DC.L $00008BF9
        DC.L $00009BD8
        DC.L $0000ABBB
        DC.L $0000BB9A
        DC.L $00004A75
        DC.L $00005A54
        DC.L $00006A37
        DC.L $00007A16
        DC.L $00000AF1
        DC.L $00001AD0
        DC.L $00002AB3
        DC.L $00003A92
        DC.L $0000FD2E
        DC.L $0000ED0F
        DC.L $0000DD6C
        DC.L $0000CD4D
        DC.L $0000BDAA
        DC.L $0000AD8B
        DC.L $00009DE8
        DC.L $00008DC9
        DC.L $00007C26
        DC.L $00006C07
        DC.L $00005C64
        DC.L $00004C45
        DC.L $00003CA2
        DC.L $00002C83
        DC.L $00001CE0
        DC.L $00000CC1
        DC.L $0000EF1F
        DC.L $0000FF3E
        DC.L $0000CF5D
        DC.L $0000DF7C
        DC.L $0000AF9B
        DC.L $0000BFBA
        DC.L $00008FD9
        DC.L $00009FF8
        DC.L $00006E17
        DC.L $00007E36
        DC.L $00004E55
        DC.L $00005E74
        DC.L $00002E93
        DC.L $00003EB2
        DC.L $00000ED1
        DC.L $00001EF0
LBL_355:
        DC.L $00000000
        DC.L $77073096
        DC.L $EE0E612C
        DC.L $990951BA
        DC.L $076DC419
        DC.L $706AF48F
        DC.L $E963A535
        DC.L $9E6495A3
        DC.L $0EDB8832
        DC.L $79DCB8A4
        DC.L $E0D5E91E
        DC.L $97D2D988
        DC.L $09B64C2B
        DC.L $7EB17CBD
        DC.L $E7B82D07
        DC.L $90BF1D91
        DC.L $1DB71064
        DC.L $6AB020F2
        DC.L $F3B97148
        DC.L $84BE41DE
        DC.L $1ADAD47D
        DC.L $6DDDE4EB
        DC.L $F4D4B551
        DC.L $83D385C7
        DC.L $136C9856
        DC.L $646BA8C0
        DC.L $FD62F97A
        DC.L $8A65C9EC
        DC.L $14015C4F
        DC.L $63066CD9
        DC.L $FA0F3D63
        DC.L $8D080DF5
        DC.L $3B6E20C8
        DC.L $4C69105E
        DC.L $D56041E4
        DC.L $A2677172
        DC.L $3C03E4D1
        DC.L $4B04D447
        DC.L $D20D85FD
        DC.L $A50AB56B
        DC.L $35B5A8FA
        DC.L $42B2986C
        DC.L $DBBBC9D6
        DC.L $ACBCF940
        DC.L $32D86CE3
        DC.L $45DF5C75
        DC.L $DCD60DCF
        DC.L $ABD13D59
        DC.L $26D930AC
        DC.L $51DE003A
        DC.L $C8D75180
        DC.L $BFD06116
        DC.L $21B4F4B5
        DC.L $56B3C423
        DC.L $CFBA9599
        DC.L $B8BDA50F
        DC.L $2802B89E
        DC.L $5F058808
        DC.L $C60CD9B2
        DC.L $B10BE924
        DC.L $2F6F7C87
        DC.L $58684C11
        DC.L $C1611DAB
        DC.L $B6662D3D
        DC.L $76DC4190
        DC.L $01DB7106
        DC.L $98D220BC
        DC.L $EFD5102A
        DC.L $71B18589
        DC.L $06B6B51F
        DC.L $9FBFE4A5
        DC.L $E8B8D433
        DC.L $7807C9A2
        DC.L $0F00F934
        DC.L $9609A88E
        DC.L $E10E9818
        DC.L $7F6A0DBB
        DC.L $086D3D2D
        DC.L $91646C97
        DC.L $E6635C01
        DC.L $6B6B51F4
        DC.L $1C6C6162
        DC.L $856530D8
        DC.L $F262004E
        DC.L $6C0695ED
        DC.L $1B01A57B
        DC.L $8208F4C1
        DC.L $F50FC457
        DC.L $65B0D9C6
        DC.L $12B7E950
        DC.L $8BBEB8EA
        DC.L $FCB9887C
        DC.L $62DD1DDF
        DC.L $15DA2D49
        DC.L $8CD37CF3
        DC.L $FBD44C65
        DC.L $4DB26158
        DC.L $3AB551CE
        DC.L $A3BC0074
        DC.L $D4BB30E2
        DC.L $4ADFA541
        DC.L $3DD895D7
        DC.L $A4D1C46D
        DC.L $D3D6F4FB
        DC.L $4369E96A
        DC.L $346ED9FC
        DC.L $AD678846
        DC.L $DA60B8D0
        DC.L $44042D73
        DC.L $33031DE5
        DC.L $AA0A4C5F
        DC.L $DD0D7CC9
        DC.L $5005713C
        DC.L $270241AA
        DC.L $BE0B1010
        DC.L $C90C2086
        DC.L $5768B525
        DC.L $206F85B3
        DC.L $B966D409
        DC.L $CE61E49F
        DC.L $5EDEF90E
        DC.L $29D9C998
        DC.L $B0D09822
        DC.L $C7D7A8B4
        DC.L $59B33D17
        DC.L $2EB40D81
        DC.L $B7BD5C3B
        DC.L $C0BA6CAD
        DC.L $EDB88320
        DC.L $9ABFB3B6
        DC.L $03B6E20C
        DC.L $74B1D29A
        DC.L $EAD54739
        DC.L $9DD277AF
        DC.L $04DB2615
        DC.L $73DC1683
        DC.L $E3630B12
        DC.L $94643B84
        DC.L $0D6D6A3E
        DC.L $7A6A5AA8
        DC.L $E40ECF0B
        DC.L $9309FF9D
        DC.L $0A00AE27
        DC.L $7D079EB1
        DC.L $F00F9344
        DC.L $8708A3D2
        DC.L $1E01F268
        DC.L $6906C2FE
        DC.L $F762575D
        DC.L $806567CB
        DC.L $196C3671
        DC.L $6E6B06E7
        DC.L $FED41B76
        DC.L $89D32BE0
        DC.L $10DA7A5A
        DC.L $67DD4ACC
        DC.L $F9B9DF6F
        DC.L $8EBEEFF9
        DC.L $17B7BE43
        DC.L $60B08ED5
        DC.L $D6D6A3E8
        DC.L $A1D1937E
        DC.L $38D8C2C4
        DC.L $4FDFF252
        DC.L $D1BB67F1
        DC.L $A6BC5767
        DC.L $3FB506DD
        DC.L $48B2364B
        DC.L $D80D2BDA
        DC.L $AF0A1B4C
        DC.L $36034AF6
        DC.L $41047A60
        DC.L $DF60EFC3
        DC.L $A867DF55
        DC.L $316E8EEF
        DC.L $4669BE79
        DC.L $CB61B38C
        DC.L $BC66831A
        DC.L $256FD2A0
        DC.L $5268E236
        DC.L $CC0C7795
        DC.L $BB0B4703
        DC.L $220216B9
        DC.L $5505262F
        DC.L $C5BA3BBE
        DC.L $B2BD0B28
        DC.L $2BB45A92
        DC.L $5CB36A04
        DC.L $C2D7FFA7
        DC.L $B5D0CF31
        DC.L $2CD99E8B
        DC.L $5BDEAE1D
        DC.L $9B64C2B0
        DC.L $EC63F226
        DC.L $756AA39C
        DC.L $026D930A
        DC.L $9C0906A9
        DC.L $EB0E363F
        DC.L $72076785
        DC.L $05005713
        DC.L $95BF4A82
        DC.L $E2B87A14
        DC.L $7BB12BAE
        DC.L $0CB61B38
        DC.L $92D28E9B
        DC.L $E5D5BE0D
        DC.L $7CDCEFB7
        DC.L $0BDBDF21
        DC.L $86D3D2D4
        DC.L $F1D4E242
        DC.L $68DDB3F8
        DC.L $1FDA836E
        DC.L $81BE16CD
        DC.L $F6B9265B
        DC.L $6FB077E1
        DC.L $18B74777
        DC.L $88085AE6
        DC.L $FF0F6A70
        DC.L $66063BCA
        DC.L $11010B5C
        DC.L $8F659EFF
        DC.L $F862AE69
        DC.L $616BFFD3
        DC.L $166CCF45
        DC.L $A00AE278
        DC.L $D70DD2EE
        DC.L $4E048354
        DC.L $3903B3C2
        DC.L $A7672661
        DC.L $D06016F7
        DC.L $4969474D
        DC.L $3E6E77DB
        DC.L $AED16A4A
        DC.L $D9D65ADC
        DC.L $40DF0B66
        DC.L $37D83BF0
        DC.L $A9BCAE53
        DC.L $DEBB9EC5
        DC.L $47B2CF7F
        DC.L $30B5FFE9
        DC.L $BDBDF21C
        DC.L $CABAC28A
        DC.L $53B39330
        DC.L $24B4A3A6
        DC.L $BAD03605
        DC.L $CDD70693
        DC.L $54DE5729
        DC.L $23D967BF
        DC.L $B3667A2E
        DC.L $C4614AB8
        DC.L $5D681B02
        DC.L $2A6F2B94
        DC.L $B40BBE37
        DC.L $C30C8EA1
        DC.L $5A05DF1B
        DC.L $2D02EF8D
        ; constant pool: enum value tables
LBL_357:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_356:
        DC.B $00
        DC.B $00
