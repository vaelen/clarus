LBL_237:
        ; startup (JT slot 0)
        ; globals (below A5, 1600 bytes total):
        ;   rtCrc32Tab : -4(A5)  size 4  type ptr
        ;   rtUiMenuHandlesArr : -8(A5)  size 4  type ptr
        ;   rtUiNMenusVal : -12(A5)  size 4  type int
        ;   rtUiAppleMenuHandle : -16(A5)  size 4  type ptr
        ;   rtUiStdEditMenuIdx : -20(A5)  size 4  type int
        ;   rtUiSys7 : -22(A5)  size 1  type bool
        ;   rtUiEveryDueArr : -26(A5)  size 4  type ptr
        ;   rtUiNEveryVal : -30(A5)  size 4  type int
        ;   rtUiEmptyPStrCache : -34(A5)  size 4  type ptr
        ;   rtUiScratchBitMap : -38(A5)  size 4  type ptr
        ;   rtUiGrayPats : -42(A5)  size 4  type ptr
        ;   rtUiScripted : -44(A5)  size 1  type bool
        ;   rtUiScriptDbl : -46(A5)  size 1  type bool
        ;   rtUiJiggle : -48(A5)  size 1  type bool
        ;   rtUiJiggleBusy : -50(A5)  size 1  type bool
        ;   rtUiAnswerKinds : -54(A5)  size 4  type ptr
        ;   rtUiAnswerVals : -58(A5)  size 4  type ptr
        ;   rtUiAnswerStrs : -62(A5)  size 4  type ptr
        ;   rtUiAnswerHead : -66(A5)  size 4  type int
        ;   rtUiAnswerTail : -70(A5)  size 4  type int
        ;   rtUiTraceSuppressed : -72(A5)  size 1  type bool
        ;   rtUiTraceWinCounts : -76(A5)  size 4  type ptr
        ;   rtUiTraceLastFront : -80(A5)  size 4  type ptr
        ;   rtUiDimPrevArr : -84(A5)  size 4  type ptr
        ;   rtUiDimFirst : -86(A5)  size 1  type bool
        ;   rtUiStdEditDimPrev : -88(A5)  size 1  type bool
        ;   rtUiScriptCursor : -92(A5)  size 4  type ptr
        ;   rtUiScriptCursorInit : -94(A5)  size 1  type bool
        ;   rtUiScriptLineBuf : -98(A5)  size 4  type ptr
        ;   rtUiScriptLineLen : -102(A5)  size 4  type int
        ;   rtUiVerbBuf : -106(A5)  size 4  type ptr
        ;   rtUiArg1Buf : -110(A5)  size 4  type ptr
        ;   rtUiArg2Buf : -114(A5)  size 4  type ptr
        ;   rtUiVirtualTicks : -118(A5)  size 4  type int
        ;   rtUiModalActive : -120(A5)  size 1  type bool
        ;   rtUiModalInst : -124(A5)  size 4  type ptr
        ;   rtUiModalBufH : -128(A5)  size 4  type ptr
        ;   rtUiModalBuf : -132(A5)  size 4  type ptr
        ;   rtUiModalIsNew : -134(A5)  size 1  type bool
        ;   rtUiModalWbKind : -138(A5)  size 4  type int
        ;   rtUiModalAddr : -142(A5)  size 4  type ptr
        ;   rtUiModalLst : -146(A5)  size 4  type ptr
        ;   rtUiModalIdx : -150(A5)  size 4  type int
        ;   rtUiModalMp : -154(A5)  size 4  type ptr
        ;   rtUiModalKey255 : -158(A5)  size 4  type ptr
        ;   rtSerPos : -162(A5)  size 4  type int
        ;   rtSerBad : -164(A5)  size 1  type bool
        ;   rtConnState : -180(A5)  size 16  type arr
        ;   rtConnPendOpened : -184(A5)  size 4  type arr
        ;   rtConnPendFailedCode : -200(A5)  size 16  type arr
        ;   rtConnPendFailedMsg : -1224(A5)  size 1024  type arr
        ;   rtConnParsePortIdx : -1228(A5)  size 4  type int
        ;   rtConnParseBaud : -1232(A5)  size 4  type int
        ;   rtConnOutRef : -1248(A5)  size 16  type arr
        ;   rtConnInRef : -1264(A5)  size 16  type arr
        ;   rtConnReadBuf : -1268(A5)  size 4  type ptr
        ;   natPb : -1272(A5)  size 4  type ptr
        ;   natBuf : -1276(A5)  size 4  type ptr
        ;   natDigits : -1280(A5)  size 4  type ptr
        ;   natLogBuf : -1284(A5)  size 4  type ptr
        ;   natLogLen : -1288(A5)  size 4  type int
        ;   natRef : -1292(A5)  size 4  type int
        ;   natOpened : -1294(A5)  size 1  type bool
        ;   natDone : -1296(A5)  size 1  type bool
        ;   natArgs : -1300(A5)  size 4  type list
        ;   natPanicBuf : -1304(A5)  size 4  type ptr
        ;   natEmptyStr : -1308(A5)  size 4  type ptr
        ;   natErrCode : -1312(A5)  size 4  type int
        ;   natErrMsg : -1568(A5)  size 256  type str
        ;   natFilePb : -1572(A5)  size 4  type ptr
        ;   natFileReady : -1574(A5)  size 1  type bool
        ;   natUiEmitBuf : -1578(A5)  size 4  type ptr
        ;   natQdInited : -1580(A5)  size 1  type bool
        ;   natQdGlobals : -1584(A5)  size 4  type ptr
        ;   rtFh68kLastErr : -1588(A5)  size 4  type int
        ;   rtFh68kState : -1592(A5)  size 4  type ptr
        ;   conn : -1596(A5)  size 4  type int
        LEA -1600(A5),A0
        MOVE.W #799,D0
LBL_239:
        CLR.W (A0)+
        DBRA D0,LBL_239
        MOVEA.L $0130.W,A0
        ADDA.L #-119322,A0
        DC.W $A02D  ; _SetApplLimit
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        BSR.W LBL_238
        JSR 3274(A5)
        ; UI startup: rtUiStartup / [App.launch] / rtUiLaunch / rtUiRun
        BSR.W LBL_197
        JSR 3466(A5)
        JSR 1778(A5)
        JSR 1770(A5)
        BSR.W LBL_236
        CLR.L -(A7)
        JSR 3298(A5)
        RTS
LBL_238:
        ; cg_init_globals
        LINK A6,#-48
        MOVE.L #0,D0
        MOVE.L D0,-4(A5)
        MOVE.L #0,D0
        MOVE.L D0,-8(A5)
        MOVE.L #0,D0
        MOVE.L D0,-8(A5)
        MOVE.L #0,D0
        MOVE.L D0,-12(A5)
        MOVE.L #0,D0
        MOVE.L D0,-12(A5)
        MOVE.L #0,D0
        MOVE.L D0,-16(A5)
        MOVE.L #0,D0
        MOVE.L D0,-16(A5)
        MOVE.L #0,D0
        MOVE.L D0,-20(A5)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-20(A5)
        MOVE.L #0,D0
        MOVE.B D0,-22(A5)
        MOVE.L #0,D0
        MOVE.B D0,-22(A5)
        MOVE.L #0,D0
        MOVE.L D0,-26(A5)
        MOVE.L #0,D0
        MOVE.L D0,-26(A5)
        MOVE.L #0,D0
        MOVE.L D0,-30(A5)
        MOVE.L #0,D0
        MOVE.L D0,-30(A5)
        MOVE.L #0,D0
        MOVE.L D0,-34(A5)
        MOVE.L #0,D0
        MOVE.L D0,-34(A5)
        MOVE.L #0,D0
        MOVE.L D0,-38(A5)
        MOVE.L #0,D0
        MOVE.L D0,-38(A5)
        MOVE.L #0,D0
        MOVE.L D0,-42(A5)
        MOVE.L #0,D0
        MOVE.L D0,-42(A5)
        MOVE.L #0,D0
        MOVE.B D0,-44(A5)
        MOVE.L #0,D0
        MOVE.B D0,-44(A5)
        MOVE.L #0,D0
        MOVE.B D0,-46(A5)
        MOVE.L #0,D0
        MOVE.B D0,-46(A5)
        MOVE.L #0,D0
        MOVE.B D0,-48(A5)
        MOVE.L #0,D0
        MOVE.B D0,-48(A5)
        MOVE.L #0,D0
        MOVE.B D0,-50(A5)
        MOVE.L #0,D0
        MOVE.B D0,-50(A5)
        MOVE.L #0,D0
        MOVE.L D0,-54(A5)
        MOVE.L #0,D0
        MOVE.L D0,-54(A5)
        MOVE.L #0,D0
        MOVE.L D0,-58(A5)
        MOVE.L #0,D0
        MOVE.L D0,-58(A5)
        MOVE.L #0,D0
        MOVE.L D0,-62(A5)
        MOVE.L #0,D0
        MOVE.L D0,-62(A5)
        MOVE.L #0,D0
        MOVE.L D0,-66(A5)
        MOVE.L #0,D0
        MOVE.L D0,-66(A5)
        MOVE.L #0,D0
        MOVE.L D0,-70(A5)
        MOVE.L #0,D0
        MOVE.L D0,-70(A5)
        MOVE.L #0,D0
        MOVE.B D0,-72(A5)
        MOVE.L #0,D0
        MOVE.B D0,-72(A5)
        MOVE.L #0,D0
        MOVE.L D0,-76(A5)
        MOVE.L #0,D0
        MOVE.L D0,-76(A5)
        MOVE.L #0,D0
        MOVE.L D0,-80(A5)
        MOVE.L #0,D0
        MOVE.L D0,-80(A5)
        MOVE.L #0,D0
        MOVE.L D0,-84(A5)
        MOVE.L #0,D0
        MOVE.L D0,-84(A5)
        MOVE.L #0,D0
        MOVE.B D0,-86(A5)
        MOVE.L #1,D0
        MOVE.B D0,-86(A5)
        MOVE.L #0,D0
        MOVE.B D0,-88(A5)
        MOVE.L #0,D0
        MOVE.B D0,-88(A5)
        MOVE.L #0,D0
        MOVE.L D0,-92(A5)
        MOVE.L #0,D0
        MOVE.L D0,-92(A5)
        MOVE.L #0,D0
        MOVE.B D0,-94(A5)
        MOVE.L #0,D0
        MOVE.B D0,-94(A5)
        MOVE.L #0,D0
        MOVE.L D0,-98(A5)
        MOVE.L #0,D0
        MOVE.L D0,-98(A5)
        MOVE.L #0,D0
        MOVE.L D0,-102(A5)
        MOVE.L #0,D0
        MOVE.L D0,-102(A5)
        MOVE.L #0,D0
        MOVE.L D0,-106(A5)
        MOVE.L #0,D0
        MOVE.L D0,-106(A5)
        MOVE.L #0,D0
        MOVE.L D0,-110(A5)
        MOVE.L #0,D0
        MOVE.L D0,-110(A5)
        MOVE.L #0,D0
        MOVE.L D0,-114(A5)
        MOVE.L #0,D0
        MOVE.L D0,-114(A5)
        MOVE.L #0,D0
        MOVE.L D0,-118(A5)
        MOVE.L #0,D0
        MOVE.L D0,-118(A5)
        MOVE.L #0,D0
        MOVE.B D0,-120(A5)
        MOVE.L #0,D0
        MOVE.B D0,-120(A5)
        MOVE.L #0,D0
        MOVE.L D0,-124(A5)
        MOVE.L #0,D0
        MOVE.L D0,-124(A5)
        MOVE.L #0,D0
        MOVE.L D0,-128(A5)
        MOVE.L #0,D0
        MOVE.L D0,-128(A5)
        MOVE.L #0,D0
        MOVE.L D0,-132(A5)
        MOVE.L #0,D0
        MOVE.L D0,-132(A5)
        MOVE.L #0,D0
        MOVE.B D0,-134(A5)
        MOVE.L #0,D0
        MOVE.B D0,-134(A5)
        MOVE.L #0,D0
        MOVE.L D0,-138(A5)
        MOVE.L #0,D0
        MOVE.L D0,-138(A5)
        MOVE.L #0,D0
        MOVE.L D0,-142(A5)
        MOVE.L #0,D0
        MOVE.L D0,-142(A5)
        MOVE.L #0,D0
        MOVE.L D0,-146(A5)
        MOVE.L #0,D0
        MOVE.L D0,-146(A5)
        MOVE.L #0,D0
        MOVE.L D0,-150(A5)
        MOVE.L #0,D0
        MOVE.L D0,-150(A5)
        MOVE.L #0,D0
        MOVE.L D0,-154(A5)
        MOVE.L #0,D0
        MOVE.L D0,-154(A5)
        MOVE.L #0,D0
        MOVE.L D0,-158(A5)
        MOVE.L #0,D0
        MOVE.L D0,-158(A5)
        MOVE.L #0,D0
        MOVE.L D0,-162(A5)
        MOVE.L #0,D0
        MOVE.B D0,-164(A5)
        MOVE.L #0,D0
        MOVE.L D0,-180(A5)
        MOVE.L #0,D0
        MOVE.L D0,-176(A5)
        MOVE.L #0,D0
        MOVE.L D0,-172(A5)
        MOVE.L #0,D0
        MOVE.L D0,-168(A5)
        MOVE.L #0,D0
        MOVE.B D0,-184(A5)
        MOVE.L #0,D0
        MOVE.B D0,-183(A5)
        MOVE.L #0,D0
        MOVE.B D0,-182(A5)
        MOVE.L #0,D0
        MOVE.B D0,-181(A5)
        MOVE.L #0,D0
        MOVE.L D0,-200(A5)
        MOVE.L #0,D0
        MOVE.L D0,-196(A5)
        MOVE.L #0,D0
        MOVE.L D0,-192(A5)
        MOVE.L #0,D0
        MOVE.L D0,-188(A5)
        LEA -1224(A5),A0
        MOVE.W #127,D0
LBL_240:
        CLR.W (A0)+
        DBRA D0,LBL_240
        LEA -968(A5),A0
        MOVE.W #127,D0
LBL_241:
        CLR.W (A0)+
        DBRA D0,LBL_241
        LEA -712(A5),A0
        MOVE.W #127,D0
LBL_242:
        CLR.W (A0)+
        DBRA D0,LBL_242
        LEA -456(A5),A0
        MOVE.W #127,D0
LBL_243:
        CLR.W (A0)+
        DBRA D0,LBL_243
        MOVE.L #0,D0
        MOVE.L D0,-1228(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1232(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1248(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1244(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1240(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1236(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1264(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1260(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1256(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1252(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1268(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1268(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1272(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1276(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1280(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1284(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1288(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1292(A5)
        MOVE.L #0,D0
        MOVE.B D0,-1294(A5)
        MOVE.L #0,D0
        MOVE.B D0,-1296(A5)
        LEA -1300(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.L D0,-1304(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1308(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1312(A5)
        LEA -1568(A5),A0
        MOVE.W #127,D0
LBL_244:
        CLR.W (A0)+
        DBRA D0,LBL_244
        MOVE.L #0,D0
        MOVE.L D0,-1572(A5)
        MOVE.L #0,D0
        MOVE.B D0,-1574(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1578(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1578(A5)
        MOVE.L #0,D0
        MOVE.B D0,-1580(A5)
        MOVE.L #0,D0
        MOVE.B D0,-1580(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1584(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1584(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1588(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1592(A5)
        MOVE.L #0,D0
        MOVE.L D0,-1596(A5)
        MOVE.L #1,D0
        MOVE.L D0,-1596(A5)
        UNLK A6
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_0:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 3314(A5)
        ADDQ.L #8,A7
LBL_245:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-2196
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 3306(A5)
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
        LINK A6,#-2212
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
        LINK A6,#-2196
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
        ; func rtArrCheck  (JT slot 5)
        ;   param i : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_4:
        LINK A6,#-2196
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_255
        MOVE.L 12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_256
LBL_255:
        MOVEQ #1,D0
LBL_256:
        TST.L D0
        BEQ.W LBL_257
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_257:
        MOVE.L 12(A6),D0
        BRA.W LBL_254
LBL_254:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 6)
        ;   param v : 14(A6)  size 4
        ;   param found : 12(A6)  size 2
        ;   param name : 8(A6)  size 4
LBL_5:
        LINK A6,#-2196
        CLR.L D0
        MOVE.B 12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_259
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_259:
        MOVE.L 14(A6),D0
        BRA.W LBL_258
LBL_258:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 7)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_6:
        LINK A6,#-2204
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
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_263:
LBL_260:
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
        LINK A6,#-2220
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
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_269:
LBL_264:
        UNLK A6
        RTS
        ; func rtStrCmp  (JT slot 9)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local ca : -20(A6)  size 4
        ;   local cb : -24(A6)  size 4
LBL_8:
        LINK A6,#-2220
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
        BEQ.W LBL_271
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_272
LBL_271:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_272:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_273:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_274
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
        BEQ.W LBL_275
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_270
LBL_275:
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_276
        MOVEQ #1,D0
        BRA.W LBL_270
LBL_276:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_273
LBL_274:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_270
LBL_277:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_278
        MOVEQ #1,D0
        BRA.W LBL_270
LBL_278:
        MOVEQ #0,D0
        BRA.W LBL_270
LBL_270:
        UNLK A6
        RTS
        ; func rtStrLen  (JT slot 10)
        ;   param s : 8(A6)  size 4
LBL_9:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_279
LBL_279:
        UNLK A6
        RTS
        ; func rtStrIndex  (JT slot 11)
        ;   param s : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_10:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_281
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
        BRA.W LBL_282
LBL_281:
        MOVEQ #1,D0
LBL_282:
        TST.L D0
        BEQ.W LBL_283
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_283:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_280
LBL_280:
        UNLK A6
        RTS
        ; func rtStrSlice  (JT slot 12)
        ;   param out : 20(A6)  size 4
        ;   param s : 16(A6)  size 4
        ;   param start : 12(A6)  size 4
        ;   param len : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
LBL_11:
        LINK A6,#-2200
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
        BNE.W LBL_285
        MOVE.L 8(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_286
LBL_285:
        MOVEQ #1,D0
LBL_286:
        TST.L D0
        BEQ.W LBL_287
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_287:
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_288
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
        BRA.W LBL_289
LBL_288:
        MOVEQ #1,D0
LBL_289:
        TST.L D0
        BEQ.W LBL_290
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_290:
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
LBL_284:
        UNLK A6
        RTS
        ; func rtStrIndexOfChar  (JT slot 13)
        ;   param s : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local slen : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_12:
        LINK A6,#-2204
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
LBL_292:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_293
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
        BEQ.W LBL_294
        MOVE.L -8(A6),D0
        BRA.W LBL_291
LBL_294:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_292
LBL_293:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_291
LBL_291:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 14)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_13:
        LINK A6,#-2212
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
        BEQ.W LBL_296
        BRA.W LBL_295
LBL_296:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_297
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_298
LBL_297:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_298:
LBL_299:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_300
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_233
        MOVE.L D0,-12(A6)
        BRA.W LBL_299
LBL_300:
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
        BEQ.W LBL_301
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_301:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_295:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 15)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_14:
        LINK A6,#-2204
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
        BEQ.W LBL_303
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_303:
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
        BEQ.W LBL_304
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_304:
        MOVE.L -4(A6),D0
        BRA.W LBL_302
LBL_302:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 16)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_15:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_306
        BRA.W LBL_305
LBL_306:
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
LBL_305:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 17)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_16:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_308
        BRA.W LBL_307
LBL_308:
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
        BEQ.W LBL_309
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_309:
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
        BEQ.W LBL_310
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
LBL_310:
LBL_307:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 18)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_17:
        LINK A6,#-2208
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
        BSR.W LBL_13
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
LBL_311:
        UNLK A6
        RTS
        ; func rtTextFromBytes  (JT slot 19)
        ;   param t : 20(A6)  size 4
        ;   param buf : 16(A6)  size 4
        ;   param bufcap : 12(A6)  size 4
        ;   param count : 8(A6)  size 4
        ;   local want : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local rt : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_18:
        LINK A6,#-2212
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
        BEQ.W LBL_313
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_314
LBL_313:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
LBL_314:
        MOVE.L -4(A6),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_315
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_316
LBL_315:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
LBL_316:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
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
LBL_312:
        UNLK A6
        RTS
        ; func rtTextToBytes  (JT slot 20)
        ;   param t : 16(A6)  size 4
        ;   param buf : 12(A6)  size 4
        ;   param bufcap : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_19:
        LINK A6,#-2208
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
        BEQ.W LBL_318
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_319
LBL_318:
        MOVE.L 8(A6),D0
        MOVE.L D0,-8(A6)
LBL_319:
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
        BEQ.W LBL_320
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_0
        ADDQ.L #8,A7
LBL_320:
        MOVE.L -8(A6),D0
        BRA.W LBL_317
LBL_317:
        UNLK A6
        RTS
        ; func rtTextAppendStr  (JT slot 21)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local len0 : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_20:
        LINK A6,#-2212
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
        BSR.W LBL_13
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
LBL_321:
        UNLK A6
        RTS
        ; func rtTextAppendChar  (JT slot 22)
        ;   param t : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local len0 : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_21:
        LINK A6,#-2208
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
        BSR.W LBL_13
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
LBL_322:
        UNLK A6
        RTS
        ; func rtTextAppendText  (JT slot 23)
        ;   param t : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local rs : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local len0 : -16(A6)  size 4
        ;   local srcmp : -20(A6)  size 4
        ;   local dstmp : -24(A6)  size 4
LBL_22:
        LINK A6,#-2220
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
        BSR.W LBL_13
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
LBL_323:
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
        BEQ.W LBL_325
        BRA.W LBL_324
LBL_325:
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
        BEQ.W LBL_326
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_327
LBL_326:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_327:
LBL_328:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_329
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_233
        MOVE.L D0,-12(A6)
        BRA.W LBL_328
LBL_329:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_233
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
        BEQ.W LBL_330
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_330:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_324:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 25)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_24:
        LINK A6,#-2204
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
        BEQ.W LBL_332
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_332:
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
        BEQ.W LBL_333
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_333:
        MOVE.L -4(A6),D0
        BRA.W LBL_331
LBL_331:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 26)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_25:
        LINK A6,#-2200
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
        ; func rtListRelease  (JT slot 27)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_26:
        LINK A6,#-2200
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
        DC.W $A023  ; ListDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; ListDisposePtr
LBL_339:
LBL_336:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 28)
        ;   param l : 8(A6)  size 4
LBL_27:
        LINK A6,#-2196
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
        ; func rtListAt  (JT slot 29)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_28:
        LINK A6,#-2208
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
        BNE.W LBL_344
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
        BRA.W LBL_345
LBL_344:
        MOVEQ #1,D0
LBL_345:
        TST.L D0
        BEQ.W LBL_346
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_346:
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
        BSR.W LBL_233
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        BRA.W LBL_343
LBL_343:
        UNLK A6
        RTS
        ; func rtListPush  (JT slot 30)
        ;   param l : 12(A6)  size 4
        ;   param elem : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_29:
        LINK A6,#-2208
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
        BSR.W LBL_233
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
LBL_347:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 31)
        ;   param l : 8(A6)  size 4
LBL_30:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_348
LBL_348:
        UNLK A6
        RTS
        ; func mapEntrySlot  (JT slot 32)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_31:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_349
LBL_349:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 33)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_32:
        LINK A6,#-2196
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
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_350
LBL_350:
        UNLK A6
        RTS
        ; func mapIndexSlot  (JT slot 34)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_33:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 40(A0),A0
        MOVE.L (A0),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_351
LBL_351:
        UNLK A6
        RTS
        ; func mapEntryHash  (JT slot 35)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_34:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_352
LBL_352:
        UNLK A6
        RTS
        ; func mapEntryKeyOff  (JT slot 36)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_35:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_353
LBL_353:
        UNLK A6
        RTS
        ; func mapEntryKeyLen  (JT slot 37)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_36:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_354
LBL_354:
        UNLK A6
        RTS
        ; func mapSetEntryMeta  (JT slot 38)
        ;   param m : 24(A6)  size 4
        ;   param i : 20(A6)  size 4
        ;   param hash : 16(A6)  size 4
        ;   param keyOff : 12(A6)  size 4
        ;   param keyLen : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_37:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
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
LBL_355:
        UNLK A6
        RTS
        ; func mapHash  (JT slot 39)
        ;   param key : 8(A6)  size 4
        ;   local klen : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local h : -12(A6)  size 4
        ;   local b : -16(A6)  size 4
LBL_38:
        LINK A6,#-2212
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
LBL_357:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
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
        BRA.W LBL_357
LBL_358:
        MOVE.L -12(A6),D0
        BRA.W LBL_356
LBL_356:
        UNLK A6
        RTS
        ; func mapPoolKeyEq  (JT slot 40)
        ;   param m : 24(A6)  size 4
        ;   param keyOff : 20(A6)  size 4
        ;   param keyLen : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param klen : 8(A6)  size 4
        ;   local base : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_39:
        LINK A6,#-2204
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
        BEQ.W LBL_360
        MOVEQ #0,D0
        BRA.W LBL_359
LBL_360:
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
LBL_361:
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
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
        BEQ.W LBL_363
        MOVEQ #0,D0
        BRA.W LBL_359
LBL_363:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_361
LBL_362:
        MOVEQ #1,D0
        BRA.W LBL_359
LBL_359:
        UNLK A6
        RTS
        ; func mapIndexFindSlot  (JT slot 41)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local slot : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
LBL_40:
        LINK A6,#-2212
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
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
        BEQ.W LBL_365
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_364
LBL_365:
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
LBL_366:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_367
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
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
        BEQ.W LBL_368
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_364
LBL_368:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_369
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_370
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDA.W #20,A7
        BRA.W LBL_371
LBL_370:
        MOVEQ #0,D0
LBL_371:
        TST.L D0
        BEQ.W LBL_372
        MOVE.L -12(A6),D0
        BRA.W LBL_364
LBL_372:
LBL_369:
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
        BRA.W LBL_366
LBL_367:
LBL_364:
        UNLK A6
        RTS
        ; func mapIndexLookup  (JT slot 42)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_41:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_40
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_374
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_373
LBL_374:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_373
LBL_373:
        UNLK A6
        RTS
        ; func mapIndexSlotFor  (JT slot 43)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local indexcap : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local firstTomb : -12(A6)  size 4
        ;   local v : -16(A6)  size 4
LBL_42:
        LINK A6,#-2212
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
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
LBL_376:
        MOVEQ #1,D0
        TST.L D0
        BEQ.W LBL_377
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
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
        BEQ.W LBL_378
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_379
        MOVE.L -12(A6),D0
        BRA.W LBL_375
LBL_379:
        MOVE.L -8(A6),D0
        BRA.W LBL_375
LBL_378:
        MOVE.L -16(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_381
LBL_380:
        MOVEQ #0,D0
LBL_381:
        TST.L D0
        BEQ.W LBL_382
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_382:
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
        BRA.W LBL_376
LBL_377:
LBL_375:
        UNLK A6
        RTS
        ; func mapIndexInsert  (JT slot 44)
        ;   param m : 16(A6)  size 4
        ;   param hash : 12(A6)  size 4
        ;   param entryIdx : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
        ;   local slotPtr : -12(A6)  size 4
        ;   local old : -16(A6)  size 4
LBL_43:
        LINK A6,#-2212
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
        BSR.W LBL_42
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
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
        BEQ.W LBL_384
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
LBL_384:
LBL_383:
        UNLK A6
        RTS
        ; func mapAllocIndex  (JT slot 45)
        ;   param m : 12(A6)  size 4
        ;   param newcap : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
LBL_44:
        LINK A6,#-2212
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
        BSR.W LBL_233
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
        BEQ.W LBL_386
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_386:
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
LBL_387:
        MOVE.L -16(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_388
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
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
        BRA.W LBL_387
LBL_388:
LBL_385:
        UNLK A6
        RTS
        ; func mapRehash  (JT slot 46)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local newcap : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local h : -16(A6)  size 4
LBL_45:
        LINK A6,#-2212
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
        BSR.W LBL_233
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_44
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
LBL_390:
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
        BEQ.W LBL_391
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDA.W #12,A7
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_390
LBL_391:
LBL_389:
        UNLK A6
        RTS
        ; func mapEnsureIndexCapacity  (JT slot 47)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_46:
        LINK A6,#-2200
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
        BEQ.W LBL_393
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_44
        ADDQ.L #8,A7
        BRA.W LBL_392
LBL_393:
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 44(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_394
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
LBL_394:
LBL_392:
        UNLK A6
        RTS
        ; func mapGrowEntries  (JT slot 48)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_47:
        LINK A6,#-2212
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
        LEA 20(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_396
        BRA.W LBL_395
LBL_396:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_397
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_398
LBL_397:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_398:
LBL_399:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_233
        MOVE.L D0,-12(A6)
        BRA.W LBL_399
LBL_400:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; MapSetHandleSize
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_401:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 20(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_395:
        UNLK A6
        RTS
        ; func mapGrowVals  (JT slot 49)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local valsize : -16(A6)  size 4
        ;   local err : -20(A6)  size 4
LBL_48:
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
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        BRA.W LBL_402
LBL_403:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_404
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_405
LBL_404:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_405:
LBL_406:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_407
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_233
        MOVE.L D0,-12(A6)
        BRA.W LBL_406
LBL_407:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -16(A6),D0
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; MapSetHandleSize
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_408
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_408:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 24(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_402:
        UNLK A6
        RTS
        ; func mapGrowPool  (JT slot 50)
        ;   param m : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_49:
        LINK A6,#-2212
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
        LEA 36(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_410
        BRA.W LBL_409
LBL_410:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_411
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_412
LBL_411:
        MOVEQ #4,D0
        MOVE.L D0,-12(A6)
LBL_412:
LBL_413:
        MOVE.L -12(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
        MOVE.L -12(A6),D1
        MOVEQ #2,D0
        BSR.W LBL_233
        MOVE.L D0,-12(A6)
        BRA.W LBL_413
LBL_414:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 28(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; MapSetHandleSize
        MOVE.W $0220.W,D0
        EXT.L D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_415:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 36(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_409:
        UNLK A6
        RTS
        ; func mapPoolAppend  (JT slot 51)
        ;   param m : 12(A6)  size 4
        ;   param key : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local klen : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
        ;   local mp : -16(A6)  size 4
LBL_50:
        LINK A6,#-2212
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
        BSR.W LBL_49
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
        BRA.W LBL_416
LBL_416:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 52)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_51:
        LINK A6,#-2204
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
        BEQ.W LBL_418
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_418:
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
        BEQ.W LBL_419
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_419:
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
        BEQ.W LBL_420
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_420:
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
        BEQ.W LBL_421
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_421:
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
        BEQ.W LBL_422
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_422:
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
        BRA.W LBL_417
LBL_417:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 53)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_52:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
        BRA.W LBL_423
LBL_424:
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
LBL_423:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 54)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_53:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        BRA.W LBL_425
LBL_426:
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
        BEQ.W LBL_427
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_427:
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
        BEQ.W LBL_428
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
LBL_428:
LBL_425:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 55)
        ;   param m : 8(A6)  size 4
LBL_54:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_431
LBL_430:
        MOVEQ #0,D0
LBL_431:
        BRA.W LBL_429
LBL_429:
        UNLK A6
        RTS
        ; func rtMapSet  (JT slot 56)
        ;   param m : 16(A6)  size 4
        ;   param key : 12(A6)  size 4
        ;   param val : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
        ;   local h : -8(A6)  size 4
        ;   local idx : -12(A6)  size 4
        ;   local klen : -16(A6)  size 4
        ;   local keyOff : -20(A6)  size 4
LBL_55:
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
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
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
        BRA.W LBL_432
LBL_433:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
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
        BSR.W LBL_47
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
        BSR.W LBL_48
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
        BSR.W LBL_50
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
        BSR.W LBL_37
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
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
        BSR.W LBL_43
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
LBL_432:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 57)
        ;   param m : 8(A6)  size 4
LBL_56:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_434
LBL_434:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 58)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_57:
        LINK A6,#-2200
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
        BNE.W LBL_436
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
        BRA.W LBL_437
LBL_436:
        MOVEQ #1,D0
LBL_437:
        TST.L D0
        BEQ.W LBL_438
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_438:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
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
LBL_435:
        UNLK A6
        RTS
        ; func rtIntMapNew  (JT slot 59)
        ;   param valsize : 8(A6)  size 4
LBL_58:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_51
        ADDQ.L #4,A7
        BRA.W LBL_439
LBL_439:
        UNLK A6
        RTS
        ; func rtIntMapRetain  (JT slot 60)
        ;   param m : 8(A6)  size 4
LBL_59:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
LBL_440:
        UNLK A6
        RTS
        ; func rtIntMapRelease  (JT slot 61)
        ;   param m : 8(A6)  size 4
LBL_60:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
LBL_441:
        UNLK A6
        RTS
        ; func rtIntMapLastref  (JT slot 62)
        ;   param m : 8(A6)  size 4
LBL_61:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        BRA.W LBL_442
LBL_442:
        UNLK A6
        RTS
        ; func rtIntMapCount  (JT slot 63)
        ;   param m : 8(A6)  size 4
LBL_62:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        BRA.W LBL_443
LBL_443:
        UNLK A6
        RTS
        ; func rtIntMapValAt  (JT slot 64)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_63:
        LINK A6,#-2196
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDA.W #12,A7
LBL_444:
        UNLK A6
        RTS
        ; func uidI32  (JT slot 65)
        ;   param p : 8(A6)  size 4
        ;   local b0 : -4(A6)  size 4
        ;   local b1 : -8(A6)  size 4
        ;   local b2 : -12(A6)  size 4
        ;   local b3 : -16(A6)  size 4
LBL_64:
        LINK A6,#-2212
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
        BRA.W LBL_445
LBL_445:
        UNLK A6
        RTS
        ; func uidStrPtr  (JT slot 66)
        ;   param off : 8(A6)  size 4
LBL_65:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
        MOVEQ #0,D0
        BRA.W LBL_446
LBL_447:
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_446
LBL_446:
        UNLK A6
        RTS
        ; func uidNWins  (JT slot 67)
LBL_66:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_448
LBL_448:
        UNLK A6
        RTS
        ; func uidWinsOff  (JT slot 68)
LBL_67:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_449
LBL_449:
        UNLK A6
        RTS
        ; func uidNMenus  (JT slot 69)
LBL_68:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_450
LBL_450:
        UNLK A6
        RTS
        ; func uidMenusOff  (JT slot 70)
LBL_69:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_451
LBL_451:
        UNLK A6
        RTS
        ; func uidNMenuHandlers  (JT slot 71)
LBL_70:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_452
LBL_452:
        UNLK A6
        RTS
        ; func uidMhOff  (JT slot 72)
LBL_71:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_453
LBL_453:
        UNLK A6
        RTS
        ; func uidNEvery  (JT slot 73)
LBL_72:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_454
LBL_454:
        UNLK A6
        RTS
        ; func uidEveryOff  (JT slot 74)
LBL_73:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_455
LBL_455:
        UNLK A6
        RTS
        ; func uidAppOff  (JT slot 75)
LBL_74:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_456
LBL_456:
        UNLK A6
        RTS
        ; func uidWinBase  (JT slot 76)
        ;   param winIdx : 8(A6)  size 4
LBL_75:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #48,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_457
LBL_457:
        UNLK A6
        RTS
        ; func uidWinNameOff  (JT slot 77)
        ;   param winIdx : 8(A6)  size 4
LBL_76:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_458
LBL_458:
        UNLK A6
        RTS
        ; func uidWinName  (JT slot 78)
        ;   param winIdx : 8(A6)  size 4
LBL_77:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_459
LBL_459:
        UNLK A6
        RTS
        ; func uidWinTitleOff  (JT slot 79)
        ;   param winIdx : 8(A6)  size 4
LBL_78:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_460
LBL_460:
        UNLK A6
        RTS
        ; func uidWinTitle  (JT slot 80)
        ;   param winIdx : 8(A6)  size 4
LBL_79:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_461
LBL_461:
        UNLK A6
        RTS
        ; func uidWinW  (JT slot 81)
        ;   param winIdx : 8(A6)  size 4
LBL_80:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_462
LBL_462:
        UNLK A6
        RTS
        ; func uidWinH  (JT slot 82)
        ;   param winIdx : 8(A6)  size 4
LBL_81:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_463
LBL_463:
        UNLK A6
        RTS
        ; func uidWinResizable  (JT slot 83)
        ;   param winIdx : 8(A6)  size 4
LBL_82:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_464
LBL_464:
        UNLK A6
        RTS
        ; func uidWinMinW  (JT slot 84)
        ;   param winIdx : 8(A6)  size 4
LBL_83:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_465
LBL_465:
        UNLK A6
        RTS
        ; func uidWinMinH  (JT slot 85)
        ;   param winIdx : 8(A6)  size 4
LBL_84:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_466
LBL_466:
        UNLK A6
        RTS
        ; func uidWinNWidgets  (JT slot 86)
        ;   param winIdx : 8(A6)  size 4
LBL_85:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_467
LBL_467:
        UNLK A6
        RTS
        ; func uidWinWidgetsOff  (JT slot 87)
        ;   param winIdx : 8(A6)  size 4
LBL_86:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_468
LBL_468:
        UNLK A6
        RTS
        ; func uidWinStateSize  (JT slot 88)
        ;   param winIdx : 8(A6)  size 4
LBL_87:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_469
LBL_469:
        UNLK A6
        RTS
        ; func uidWinFormOff  (JT slot 89)
        ;   param winIdx : 8(A6)  size 4
LBL_88:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_470
LBL_470:
        UNLK A6
        RTS
        ; func uidWidgetBase  (JT slot 90)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_89:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_471
LBL_471:
        UNLK A6
        RTS
        ; func uidWidgetKind  (JT slot 91)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_90:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_472
LBL_472:
        UNLK A6
        RTS
        ; func uidWidgetNameOff  (JT slot 92)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_91:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_473
LBL_473:
        UNLK A6
        RTS
        ; func uidWidgetName  (JT slot 93)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_92:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_91
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_474
LBL_474:
        UNLK A6
        RTS
        ; func uidWidgetCaptionOff  (JT slot 94)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_93:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_475
LBL_475:
        UNLK A6
        RTS
        ; func uidWidgetCaption  (JT slot 95)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_94:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_93
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_476
LBL_476:
        UNLK A6
        RTS
        ; func uidWidgetAtKind  (JT slot 96)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_95:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_477
LBL_477:
        UNLK A6
        RTS
        ; func uidWidgetX  (JT slot 97)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_96:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_478
LBL_478:
        UNLK A6
        RTS
        ; func uidWidgetYIsBottom  (JT slot 98)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_97:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_479
LBL_479:
        UNLK A6
        RTS
        ; func uidWidgetY  (JT slot 99)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_98:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_480
LBL_480:
        UNLK A6
        RTS
        ; func uidWidgetWidthIsFill  (JT slot 100)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_99:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_481
LBL_481:
        UNLK A6
        RTS
        ; func uidWidgetWidth  (JT slot 101)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_100:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_482
LBL_482:
        UNLK A6
        RTS
        ; func uidWidgetFillBoth  (JT slot 102)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_101:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_483
LBL_483:
        UNLK A6
        RTS
        ; func uidWidgetFlags  (JT slot 103)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_102:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func uidWidgetTableOff  (JT slot 104)
        ;   param winIdx : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
LBL_103:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_485
LBL_485:
        UNLK A6
        RTS
        ; func uidMenuBase  (JT slot 105)
        ;   param menuIdx : 8(A6)  size 4
LBL_104:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_486
LBL_486:
        UNLK A6
        RTS
        ; func uidMenuTitleOff  (JT slot 106)
        ;   param menuIdx : 8(A6)  size 4
LBL_105:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_104
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_487
LBL_487:
        UNLK A6
        RTS
        ; func uidMenuTitle  (JT slot 107)
        ;   param menuIdx : 8(A6)  size 4
LBL_106:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_105
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_488
LBL_488:
        UNLK A6
        RTS
        ; func uidMenuNItems  (JT slot 108)
        ;   param menuIdx : 8(A6)  size 4
LBL_107:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_104
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_489
LBL_489:
        UNLK A6
        RTS
        ; func uidMenuItemsOff  (JT slot 109)
        ;   param menuIdx : 8(A6)  size 4
LBL_108:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_104
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_490
LBL_490:
        UNLK A6
        RTS
        ; func uidMenuIsStandardEdit  (JT slot 110)
        ;   param menuIdx : 8(A6)  size 4
LBL_109:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_104
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_491
LBL_491:
        UNLK A6
        RTS
        ; func uidItemBase  (JT slot 111)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_110:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_108
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_492
LBL_492:
        UNLK A6
        RTS
        ; func uidItemLabelOff  (JT slot 112)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_111:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_493
LBL_493:
        UNLK A6
        RTS
        ; func uidItemLabel  (JT slot 113)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_112:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_111
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_494
LBL_494:
        UNLK A6
        RTS
        ; func uidItemKey  (JT slot 114)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_113:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_495
LBL_495:
        UNLK A6
        RTS
        ; func uidItemSeparator  (JT slot 115)
        ;   param menuIdx : 12(A6)  size 4
        ;   param itemIdx : 8(A6)  size 4
LBL_114:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_110
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_496
LBL_496:
        UNLK A6
        RTS
        ; func uidMenuHandlerBase  (JT slot 116)
        ;   param k : 8(A6)  size 4
LBL_115:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_497
LBL_497:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuIdx  (JT slot 117)
        ;   param k : 8(A6)  size 4
LBL_116:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_498
LBL_498:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemIdx  (JT slot 118)
        ;   param k : 8(A6)  size 4
LBL_117:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_499
LBL_499:
        UNLK A6
        RTS
        ; func uidMenuHandlerScopeWinIdx  (JT slot 119)
        ;   param k : 8(A6)  size 4
LBL_118:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_500
LBL_500:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuNameOff  (JT slot 120)
        ;   param k : 8(A6)  size 4
LBL_119:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_501
LBL_501:
        UNLK A6
        RTS
        ; func uidMenuHandlerMenuName  (JT slot 121)
        ;   param k : 8(A6)  size 4
LBL_120:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_119
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_502
LBL_502:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemNameOff  (JT slot 122)
        ;   param k : 8(A6)  size 4
LBL_121:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_115
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_503
LBL_503:
        UNLK A6
        RTS
        ; func uidMenuHandlerItemName  (JT slot 123)
        ;   param k : 8(A6)  size 4
LBL_122:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_121
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_504
LBL_504:
        UNLK A6
        RTS
        ; func uidEveryTicks  (JT slot 124)
        ;   param k : 8(A6)  size 4
LBL_123:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_505
LBL_505:
        UNLK A6
        RTS
        ; func uidHasApp  (JT slot 125)
LBL_124:
        LINK A6,#-2196
        BSR.W LBL_74
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_506
LBL_506:
        UNLK A6
        RTS
        ; func uidAppNameOff  (JT slot 126)
LBL_125:
        LINK A6,#-2196
        BSR.W LBL_124
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_508
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_507
LBL_508:
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_507
LBL_507:
        UNLK A6
        RTS
        ; func uidAppName  (JT slot 127)
LBL_126:
        LINK A6,#-2196
        BSR.W LBL_125
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_509
LBL_509:
        UNLK A6
        RTS
        ; func uidAppVersionOff  (JT slot 128)
LBL_127:
        LINK A6,#-2196
        BSR.W LBL_124
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_510
LBL_511:
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_510
LBL_510:
        UNLK A6
        RTS
        ; func uidAppVersion  (JT slot 129)
LBL_128:
        LINK A6,#-2196
        BSR.W LBL_127
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_512
LBL_512:
        UNLK A6
        RTS
        ; func uidAppAuthorOff  (JT slot 130)
LBL_129:
        LINK A6,#-2196
        BSR.W LBL_124
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_514
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_513
LBL_514:
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_513
LBL_513:
        UNLK A6
        RTS
        ; func uidAppAuthor  (JT slot 131)
LBL_130:
        LINK A6,#-2196
        BSR.W LBL_129
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_515
LBL_515:
        UNLK A6
        RTS
        ; func uidAppAboutOff  (JT slot 132)
LBL_131:
        LINK A6,#-2196
        BSR.W LBL_124
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_516
LBL_517:
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_516
LBL_516:
        UNLK A6
        RTS
        ; func uidAppAbout  (JT slot 133)
LBL_132:
        LINK A6,#-2196
        BSR.W LBL_131
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_518
LBL_518:
        UNLK A6
        RTS
        ; func uidFormLayoutOff  (JT slot 134)
        ;   param off : 8(A6)  size 4
LBL_133:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_519
LBL_519:
        UNLK A6
        RTS
        ; func uidFormNBinds  (JT slot 135)
        ;   param off : 8(A6)  size 4
LBL_134:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_520
LBL_520:
        UNLK A6
        RTS
        ; func uidFormBindsOff  (JT slot 136)
        ;   param off : 8(A6)  size 4
LBL_135:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_521
LBL_521:
        UNLK A6
        RTS
        ; func uidBindBase  (JT slot 137)
        ;   param bindsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_136:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_522
LBL_522:
        UNLK A6
        RTS
        ; func uidBindWidgetIndex  (JT slot 138)
        ;   param bindsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_137:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_136
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_523
LBL_523:
        UNLK A6
        RTS
        ; func uidBindFieldIndex  (JT slot 139)
        ;   param bindsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_138:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_136
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_524
LBL_524:
        UNLK A6
        RTS
        ; func uidFormFindFieldIndex  (JT slot 140)
        ;   param off : 12(A6)  size 4
        ;   param widgetIdx : 8(A6)  size 4
        ;   local bindsOff : -4(A6)  size 4
        ;   local nBinds : -8(A6)  size 4
        ;   local b : -12(A6)  size 4
LBL_139:
        LINK A6,#-2208
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
        BEQ.W LBL_526
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_525
LBL_526:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_135
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_134
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_527:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_528
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_137
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_529
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_138
        ADDQ.L #8,A7
        BRA.W LBL_525
LBL_529:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_527
LBL_528:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_525
LBL_525:
        UNLK A6
        RTS
        ; func uidTableRowsIdx  (JT slot 141)
        ;   param off : 8(A6)  size 4
LBL_140:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_530
LBL_530:
        UNLK A6
        RTS
        ; func uidTableLayoutOff  (JT slot 142)
        ;   param off : 8(A6)  size 4
LBL_141:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_531
LBL_531:
        UNLK A6
        RTS
        ; func uidTableNCols  (JT slot 143)
        ;   param off : 8(A6)  size 4
LBL_142:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_532
LBL_532:
        UNLK A6
        RTS
        ; func uidTableColsOff  (JT slot 144)
        ;   param off : 8(A6)  size 4
LBL_143:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_533
LBL_533:
        UNLK A6
        RTS
        ; func uidColBase  (JT slot 145)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_144:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_534
LBL_534:
        UNLK A6
        RTS
        ; func uidColHeaderOff  (JT slot 146)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_145:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_535
LBL_535:
        UNLK A6
        RTS
        ; func uidColHeader  (JT slot 147)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_146:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_145
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_536
LBL_536:
        UNLK A6
        RTS
        ; func uidColWidthPx  (JT slot 148)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_147:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_537
LBL_537:
        UNLK A6
        RTS
        ; func uidColWidthFill  (JT slot 149)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_148:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_538
LBL_538:
        UNLK A6
        RTS
        ; func uidColFieldIndex  (JT slot 150)
        ;   param colsOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_149:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_144
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_539
LBL_539:
        UNLK A6
        RTS
        ; func uidLayoutRecSize  (JT slot 151)
        ;   param off : 8(A6)  size 4
LBL_150:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_540
LBL_540:
        UNLK A6
        RTS
        ; func uidFieldBase  (JT slot 152)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_151:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
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
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_541
LBL_541:
        UNLK A6
        RTS
        ; func uidFieldFtype  (JT slot 153)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_152:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_151
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_542
LBL_542:
        UNLK A6
        RTS
        ; func uidFieldOffset  (JT slot 154)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_153:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_151
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_543
LBL_543:
        UNLK A6
        RTS
        ; func uidFieldStrCap  (JT slot 155)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_154:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_151
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_544
LBL_544:
        UNLK A6
        RTS
        ; func uidFieldEnumCount  (JT slot 156)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_155:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_151
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_545
LBL_545:
        UNLK A6
        RTS
        ; func uidFieldEnumLabelsOff  (JT slot 157)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_156:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_151
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_546
LBL_546:
        UNLK A6
        RTS
        ; func uidFieldEnumValuesOff  (JT slot 158)
        ;   param layoutOff : 12(A6)  size 4
        ;   param k : 8(A6)  size 4
LBL_157:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_151
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #20,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_547
LBL_547:
        UNLK A6
        RTS
        ; func uidEnumLabelOff  (JT slot 159)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_158:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_548
LBL_548:
        UNLK A6
        RTS
        ; func uidEnumLabel  (JT slot 160)
        ;   param enumLabelsOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_159:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_158
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #4,A7
        BRA.W LBL_549
LBL_549:
        UNLK A6
        RTS
        ; func uidEnumValue  (JT slot 161)
        ;   param enumValuesOff : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_160:
        LINK A6,#-2196
        LEA LBL_231(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,D1
        MOVE.L 12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #4,A7
        BRA.W LBL_550
LBL_550:
        UNLK A6
        RTS
        ; func rtUiAllocLocked  (JT slot 162)
        ;   param sz : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
LBL_161:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A322  ; UiNewHandleClear
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_552
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_552:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -4(A6),D0
        BRA.W LBL_551
LBL_551:
        UNLK A6
        RTS
        ; func UiNewPtr  (JT slot 163)
        ;   param size : 8(A6)  size 4
LBL_162:
        LINK A6,#-2196
        JSR 2482(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtrRaw
        MOVE.L A0,D0
        BRA.W LBL_553
LBL_553:
        UNLK A6
        RTS
        ; func aeQuitHandler  (JT slot 164)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_163:
        LINK A6,#-2196
        BSR.W LBL_178
        MOVEQ #0,D0
        BRA.W LBL_554
LBL_554:
        UNLK A6
        RTS
        ; func aeOappHandler  (JT slot 165)
        ;   param theAppleEvent : 16(A6)  size 4
        ;   param reply : 12(A6)  size 4
        ;   param handlerRefcon : 8(A6)  size 4
LBL_164:
        LINK A6,#-2196
        MOVEQ #0,D0
        BRA.W LBL_555
LBL_555:
        UNLK A6
        RTS
        ; func nat_UiLaunchReal  (JT slot 166)
        ;   local junk : -4(A6)  size 4
LBL_165:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -22(A5),D0
        TST.L D0
        BEQ.W LBL_557
        CLR.W -(A7)
        MOVE.L #1634039412,D0
        MOVE.L D0,-(A7)
        MOVE.L #1903520116,D0
        MOVE.L D0,-(A7)
        LEA 3570(A5),A0
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
        LEA 3578(A5),A0
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
LBL_557:
        JSR 3562(A5)
LBL_556:
        UNLK A6
        RTS
        ; func nat_UiAEProcessEvent  (JT slot 167)
        ;   param evBuf : 8(A6)  size 4
        ;   local junk : -4(A6)  size 4
LBL_166:
        LINK A6,#-2200
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
LBL_558:
        UNLK A6
        RTS
        ; func rtUiIsOurs  (JT slot 168)
        ;   param wp : 8(A6)  size 4
LBL_167:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_560
        MOVEQ #0,D0
        BRA.W LBL_559
LBL_560:
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
        BRA.W LBL_559
LBL_559:
        UNLK A6
        RTS
        ; func rtUiWinstOf  (JT slot 169)
        ;   param wp : 8(A6)  size 4
LBL_168:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_167
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_562
        MOVEQ #0,D0
        BRA.W LBL_561
LBL_562:
        CLR.L -(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        BRA.W LBL_561
LBL_561:
        UNLK A6
        RTS
        ; func rtUiFront  (JT slot 170)
        ;   param winIdx : 8(A6)  size 4
        ;   local wp : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
LBL_169:
        LINK A6,#-2208
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
LBL_564:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_565
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
        BEQ.W LBL_566
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
        BEQ.W LBL_567
        MOVE.L -8(A6),D0
        BRA.W LBL_563
LBL_567:
LBL_566:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_564
LBL_565:
        MOVEQ #0,D0
        BRA.W LBL_563
LBL_563:
        UNLK A6
        RTS
        ; func rtUiState  (JT slot 171)
        ;   param instV : 8(A6)  size 4
LBL_170:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_568
LBL_568:
        UNLK A6
        RTS
        ; func rtUiSetTitle  (JT slot 172)
        ;   param instV : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_171:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A91A  ; UiSetWTitle
LBL_569:
        UNLK A6
        RTS
        ; func rtUiGetTitle  (JT slot 173)
        ;   param instV : 12(A6)  size 4
        ;   param dst255 : 8(A6)  size 4
LBL_172:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A919  ; UiGetWTitle
LBL_570:
        UNLK A6
        RTS
        ; func rtUiNaturalSize  (JT slot 174)
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
LBL_173:
        LINK A6,#-2252
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
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_572:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_573
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_95
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1882(A5)
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
        BEQ.W LBL_574
        MOVE.L -20(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_575
LBL_574:
        MOVE.L -56(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_576
        MOVE.L -16(A6),D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_577
LBL_576:
        MOVE.L -56(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_578
        MOVEQ #12,D0
        MOVE.L D0,-36(A6)
        BRA.W LBL_579
LBL_578:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_96
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
LBL_579:
LBL_577:
LBL_575:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_97
        ADDQ.L #8,A7
        TST.L D0
        BNE.W LBL_580
        MOVE.L -32(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_581
LBL_580:
        MOVEQ #1,D0
LBL_581:
        TST.L D0
        BEQ.W LBL_582
        MOVE.L -24(A6),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-40(A6)
        BRA.W LBL_583
LBL_582:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_98
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
LBL_583:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_99
        ADDQ.L #8,A7
        TST.L D0
        BNE.W LBL_584
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_101
        ADDQ.L #8,A7
        BRA.W LBL_585
LBL_584:
        MOVEQ #1,D0
LBL_585:
        TST.L D0
        BEQ.W LBL_586
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1890(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        BRA.W LBL_587
LBL_586:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_588
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1890(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        BRA.W LBL_589
LBL_588:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_100
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
LBL_589:
LBL_587:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_101
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_590
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1882(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-48(A6)
LBL_590:
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
        BEQ.W LBL_591
        MOVE.L -52(A6),D0
        MOVE.L D0,-12(A6)
LBL_591:
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
        BRA.W LBL_572
LBL_573:
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
LBL_571:
        UNLK A6
        RTS
        ; func rtUiOpen  (JT slot 175)
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
LBL_174:
        LINK A6,#-2300
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
        BSR.W LBL_161
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
        BSR.W LBL_87
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_593
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BRA.W LBL_594
LBL_593:
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
LBL_594:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        MOVEQ #36,D0
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BSR.W LBL_161
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        BSR.W LBL_161
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
LBL_595:
        MOVE.L -96(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_596
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 1818(A5)
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
        BRA.W LBL_595
LBL_596:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #4,A7
        MOVE.L D0,-52(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVE.L -52(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-60(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_173
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
LBL_597:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
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
        BSR.W LBL_234
        MOVE.L D0,-68(A6)
        MOVE.L -68(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_598
        MOVEQ #4,D0
        MOVE.L D0,-68(A6)
LBL_598:
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
        BEQ.W LBL_599
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
        BEQ.W LBL_600
        MOVEQ #1,D0
        MOVE.L D0,-76(A6)
LBL_600:
LBL_599:
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
        BEQ.W LBL_601
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
        BEQ.W LBL_602
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
        BEQ.W LBL_603
        MOVEQ #1,D0
        MOVE.L D0,-80(A6)
LBL_603:
LBL_602:
LBL_601:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        BSR.W LBL_88
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
        BEQ.W LBL_604
        CLR.L D0
        MOVE.B -22(A5),D0
        TST.L D0
        BEQ.W LBL_606
        MOVEQ #5,D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_607
LBL_606:
        MOVEQ #4,D0
        MOVE.L D0,-88(A6)
LBL_607:
        BRA.W LBL_605
LBL_604:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_608
        MOVEQ #8,D0
        MOVE.L D0,-88(A6)
        BRA.W LBL_609
LBL_608:
        MOVEQ #4,D0
        MOVE.L D0,-88(A6)
LBL_609:
LBL_605:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-92(A6)
        CLR.L -(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -84(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -88(A6),D0
        MOVE.W D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A913  ; UiNewWindow
        MOVE.L (A7)+,D0
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
        BEQ.W LBL_610
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_610:
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
        JSR 1914(A5)
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1906(A5)
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_611:
        MOVE.L -96(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_612
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 2434(A5)
        ADDQ.L #8,A7
LBL_613:
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_611
LBL_612:
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_614:
        MOVE.L -96(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_615
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_616
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_617
LBL_616:
        MOVEQ #1,D0
LBL_617:
        TST.L D0
        BEQ.W LBL_618
        JSR 1874(A5)
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
        JSR 2202(A5)
        ADDQ.L #8,A7
        MOVE.L -100(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -20(A6),D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_619
LBL_618:
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
LBL_619:
        BRA.W LBL_614
LBL_615:
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
        JSR 2586(A5)
        ADDQ.L #8,A7
        BSR.W LBL_192
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
        JSR 3514(A5)
        ADDA.W #20,A7
        MOVE.L -8(A6),D0
        BRA.W LBL_592
LBL_592:
        UNLK A6
        RTS
        ; func rtUiTeardownWindow  (JT slot 176)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local lh : -20(A6)  size 4
        ;   local ldefH : -24(A6)  size 4
LBL_175:
        LINK A6,#-2220
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
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_621:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_622
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2250(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_623
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
LBL_623:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_621
LBL_622:
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
        JSR 2594(A5)
        ADDQ.L #8,A7
        BSR.W LBL_192
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_219(PC),A0
        MOVE.L A0,-(A7)
        JSR 2602(A5)
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
        JSR 3514(A5)
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
        BEQ.W LBL_624
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3546(A5)
        ADDQ.L #8,A7
LBL_624:
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_625:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_626
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1818(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 2018(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9CD  ; UiTEDispose
LBL_627:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2266(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_628
        MOVE.L #1000,D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A936  ; UiDeleteMenu
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2266(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A932  ; UiDisposeMenu
LBL_628:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_625
LBL_626:
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
        BEQ.W LBL_629
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 12(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
LBL_629:
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
LBL_620:
        UNLK A6
        RTS
        ; func rtUiCloseInternal  (JT slot 177)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local cancelSlot : -12(A6)  size 4
        ;   local cancelled : -14(A6)  size 2
LBL_176:
        LINK A6,#-2210
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.B D0,-14(A6)
        CLR.L D0
        MOVE.B -120(A5),D0
        TST.L D0
        BEQ.W LBL_631
        MOVE.L 8(A6),D1
        MOVE.L -124(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_632
LBL_631:
        MOVEQ #0,D0
LBL_632:
        TST.L D0
        BEQ.W LBL_633
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_630
LBL_633:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_220(PC),A0
        MOVE.L A0,-(A7)
        JSR 2602(A5)
        ADDQ.L #8,A7
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        JSR 3514(A5)
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
        BEQ.W LBL_634
        MOVEQ #0,D0
        BRA.W LBL_630
LBL_634:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_175
        ADDQ.L #4,A7
        MOVEQ #1,D0
        BRA.W LBL_630
LBL_630:
        UNLK A6
        RTS
        ; func rtUiClose  (JT slot 178)
        ;   param instV : 8(A6)  size 4
        ;   local ok : -2(A6)  size 2
LBL_177:
        LINK A6,#-2198
        MOVEQ #0,D0
        MOVE.B D0,-2(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_176
        ADDQ.L #4,A7
        MOVE.B D0,-2(A6)
LBL_635:
        UNLK A6
        RTS
        ; func rtUiQuit  (JT slot 179)
        ;   local wp : -4(A6)  size 4
        ;   local next : -8(A6)  size 4
        ;   local inst : -12(A6)  size 4
LBL_178:
        LINK A6,#-2208
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
LBL_637:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_638
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_167
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_639
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_176
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_640
        BRA.W LBL_636
LBL_640:
LBL_639:
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_637
LBL_638:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 3426(A5)
        ADDQ.L #4,A7
LBL_636:
        UNLK A6
        RTS
        ; func rtUiGlobalToLocalPt  (JT slot 180)
        ;   param pt : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local result : -8(A6)  size 4
LBL_179:
        LINK A6,#-2204
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        BRA.W LBL_641
LBL_641:
        UNLK A6
        RTS
        ; func rtUiGetMousePt  (JT slot 181)
        ;   local slot : -4(A6)  size 4
        ;   local v : -8(A6)  size 4
LBL_180:
        LINK A6,#-2204
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        BRA.W LBL_642
LBL_642:
        UNLK A6
        RTS
        ; func rtUiHiWord  (JT slot 182)
        ;   param v : 8(A6)  size 4
LBL_181:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        BRA.W LBL_643
LBL_643:
        UNLK A6
        RTS
        ; func rtUiLoWord  (JT slot 183)
        ;   param v : 8(A6)  size 4
LBL_182:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVE.L #65535,D0
        AND.L D1,D0
        BRA.W LBL_644
LBL_644:
        UNLK A6
        RTS
        ; func rtUiAboutPrefixPtr  (JT slot 184)
        ;   local p : -4(A6)  size 4
LBL_183:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #7,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        BRA.W LBL_645
LBL_645:
        UNLK A6
        RTS
        ; func rtUiEmptyPStrGet  (JT slot 185)
LBL_184:
        LINK A6,#-2196
        MOVE.L -34(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-34(A5)
        MOVE.L -34(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_647:
        MOVE.L -34(A5),D0
        BRA.W LBL_646
LBL_646:
        UNLK A6
        RTS
        ; func rtUiBuildAppleMenu  (JT slot 186)
        ;   local titleBuf : -4(A6)  size 4
        ;   local buf : -8(A6)  size 4
        ;   local prefix : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local appName : -20(A6)  size 4
        ;   local appNameLen : -24(A6)  size 4
LBL_185:
        LINK A6,#-2220
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
        BSR.W LBL_162
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
        CLR.L -(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A931  ; UiNewMenu
        MOVE.L (A7)+,D0
        MOVE.L D0,-16(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BSR.W LBL_126
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_649
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_650
LBL_649:
        MOVEQ #0,D0
LBL_650:
        TST.L D0
        BEQ.W LBL_651
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L #264,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        BSR.W LBL_183
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1898(A5)
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
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A933  ; UiAppendMenu
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        BRA.W LBL_652
LBL_651:
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_221(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
LBL_652:
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1146246738,D0
        MOVE.L D0,-(A7)
        DC.W $A94D  ; UiAppendResMenu
        MOVE.L -16(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A935  ; UiInsertMenu
LBL_648:
        UNLK A6
        RTS
        ; func rtUiAboutParam  (JT slot 187)
        ;   param p : 8(A6)  size 4
LBL_186:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_654
        BSR.W LBL_184
        BRA.W LBL_653
LBL_654:
        MOVE.L 8(A6),D0
        BRA.W LBL_653
LBL_653:
        UNLK A6
        RTS
        ; func rtUiAboutAlert  (JT slot 188)
LBL_187:
        LINK A6,#-2196
        BSR.W LBL_126
        MOVE.L D0,-(A7)
        BSR.W LBL_186
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_128
        MOVE.L D0,-(A7)
        BSR.W LBL_186
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_130
        MOVE.L D0,-(A7)
        BSR.W LBL_186
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_132
        MOVE.L D0,-(A7)
        BSR.W LBL_186
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
LBL_655:
        UNLK A6
        RTS
        ; func rtUiAppleSelect  (JT slot 189)
        ;   param itemNum : 8(A6)  size 4
        ;   local empty : -4(A6)  size 4
        ;   local itemNameBuf : -8(A6)  size 4
LBL_188:
        LINK A6,#-2204
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
        BEQ.W LBL_657
        CLR.L D0
        MOVE.B -44(A5),D0
        TST.L D0
        BEQ.W LBL_658
        JSR 2658(A5)
        BRA.W LBL_656
LBL_658:
        BSR.W LBL_124
        TST.L D0
        BEQ.W LBL_661
        BSR.W LBL_126
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_662
LBL_661:
        MOVEQ #0,D0
LBL_662:
        TST.L D0
        BEQ.W LBL_659
        BSR.W LBL_126
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_660
LBL_659:
        MOVEQ #0,D0
LBL_660:
        TST.L D0
        BEQ.W LBL_663
        BSR.W LBL_187
        BRA.W LBL_664
LBL_663:
        BSR.W LBL_184
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
LBL_664:
        BRA.W LBL_656
LBL_657:
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -16(A5),D0
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
LBL_656:
        UNLK A6
        RTS
        ; func rtUiBuildMenus  (JT slot 190)
        ;   local nMenus : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local j : -12(A6)  size 4
        ;   local mh : -16(A6)  size 4
        ;   local nItems : -20(A6)  size 4
        ;   local buf : -24(A6)  size 4
        ;   local n : -28(A6)  size 4
        ;   local key : -32(A6)  size 4
LBL_189:
        LINK A6,#-2228
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
        BSR.W LBL_68
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A5)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_666
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; UiNewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-8(A5)
        BRA.W LBL_667
LBL_666:
        MOVEQ #0,D0
        MOVE.L D0,-8(A5)
LBL_667:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_668:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_669
        CLR.L -(A7)
        MOVEQ #2,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_106
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        DC.W $A931  ; UiNewMenu
        MOVE.L (A7)+,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_109
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_670
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_222(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_223(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_224(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_225(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_226(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A93A  ; UiDisableItem
        MOVE.L -20(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_672
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A5)
LBL_672:
        BRA.W LBL_671
LBL_670:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_107
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_673:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_674
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_114
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_675
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        DC.W $A933  ; UiAppendMenuStr
        BRA.W LBL_676
LBL_675:
        MOVE.L #258,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_112
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 1898(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_113
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_677
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -28(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #47,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -24(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -28(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_677:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A933  ; UiAppendMenu
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_676:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_673
LBL_674:
LBL_671:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A935  ; UiInsertMenu
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_668
LBL_669:
        DC.W $A937  ; UiDrawMenuBar
LBL_665:
        UNLK A6
        RTS
        ; func rtUiMenuEnable  (JT slot 191)
        ;   param menuIdx : 14(A6)  size 4
        ;   param itemIdx : 10(A6)  size 4
        ;   param enable : 8(A6)  size 2
        ;   local mh : -4(A6)  size 4
LBL_190:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -8(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_681
        MOVE.L 14(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_682
LBL_681:
        MOVEQ #1,D0
LBL_682:
        TST.L D0
        BNE.W LBL_679
        MOVE.L 14(A6),D1
        MOVE.L -12(A5),D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_680
LBL_679:
        MOVEQ #1,D0
LBL_680:
        TST.L D0
        BEQ.W LBL_683
        BRA.W LBL_678
LBL_683:
        MOVE.L -8(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 14(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
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
        BEQ.W LBL_684
        BRA.W LBL_678
LBL_684:
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_685
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A939  ; UiEnableItem
        BRA.W LBL_686
LBL_685:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 10(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.W D0,-(A7)
        DC.W $A93A  ; UiDisableItem
LBL_686:
LBL_678:
        UNLK A6
        RTS
        ; func rtUiMenuRecomputeDim  (JT slot 192)
        ;   local k : -4(A6)  size 4
        ;   local nMh : -8(A6)  size 4
        ;   local scopeWinIdx : -12(A6)  size 4
        ;   local enable : -14(A6)  size 2
        ;   local front : -18(A6)  size 4
        ;   local j : -22(A6)  size 4
LBL_191:
        LINK A6,#-2218
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
        BSR.W LBL_70
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_688:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_689
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
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
        BEQ.W LBL_690
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_169
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_117
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_190
        ADDA.W #10,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        JSR 2634(A5)
        ADDQ.L #6,A7
LBL_690:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_688
LBL_689:
        MOVE.L -20(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_691
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_168
        ADDQ.L #4,A7
        MOVE.L D0,-18(A6)
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_692
        MOVE.L -18(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_693
LBL_692:
        MOVEQ #0,D0
LBL_693:
        MOVE.B D0,-14(A6)
        MOVEQ #2,D0
        MOVE.L D0,-22(A6)
LBL_694:
        MOVE.L -22(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_695
        MOVE.L -20(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        BSR.W LBL_190
        ADDA.W #10,A7
        MOVE.L -22(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-22(A6)
        BRA.W LBL_694
LBL_695:
        CLR.L D0
        MOVE.B -14(A6),D0
        MOVE.B D0,-(A7)
        JSR 2642(A5)
        ADDQ.L #2,A7
LBL_691:
        JSR 2386(A5)
LBL_687:
        UNLK A6
        RTS
        ; func rtUiAfterFrontChange  (JT slot 193)
LBL_192:
        LINK A6,#-2196
        BSR.W LBL_191
        JSR 2650(A5)
LBL_696:
        UNLK A6
        RTS
        ; func rtUiStdEditDispatch  (JT slot 194)
        ;   param itemIdx : 8(A6)  size 4
        ;   local front : -4(A6)  size 4
        ;   local inst : -8(A6)  size 4
        ;   local w : -12(A6)  size 4
        ;   local te : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
LBL_193:
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
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_167
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_698
        BRA.W LBL_697
LBL_698:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_699
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_700
LBL_699:
        MOVEQ #1,D0
LBL_700:
        TST.L D0
        BEQ.W LBL_701
        BRA.W LBL_697
LBL_701:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_168
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_702
        BRA.W LBL_697
LBL_702:
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
        BEQ.W LBL_703
        BRA.W LBL_697
LBL_703:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_704
        BRA.W LBL_697
LBL_704:
        JSR 1874(A5)
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
        BEQ.W LBL_705
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D6  ; UiTECut
        CLR.L -(A7)
        DC.W $A9FC  ; UiZeroScrap
        MOVE.L (A7)+,D0
        JSR 2138(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        JSR 2186(A5)
        ADDA.W #10,A7
        BRA.W LBL_706
LBL_705:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_707
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D5  ; UiTECopy
        CLR.L -(A7)
        DC.W $A9FC  ; UiZeroScrap
        MOVE.L (A7)+,D0
        JSR 2138(A5)
        BRA.W LBL_708
LBL_707:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_709
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2242(A5)
        ADDQ.L #8,A7
        BRA.W LBL_710
LBL_709:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_711
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
        JSR 2186(A5)
        ADDA.W #10,A7
LBL_711:
LBL_710:
LBL_708:
LBL_706:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_697:
        UNLK A6
        RTS
        ; func rtUiMenuDispatch  (JT slot 195)
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
LBL_194:
        LINK A6,#-2230
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
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_182
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
        BEQ.W LBL_713
        BRA.W LBL_712
LBL_713:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_714
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_188
        ADDQ.L #4,A7
        BRA.W LBL_712
LBL_714:
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
        MOVE.L -20(A5),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_715
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_193
        ADDQ.L #4,A7
        BRA.W LBL_712
LBL_715:
        BSR.W LBL_70
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_716:
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_717
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_116
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_718
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_117
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_719
LBL_718:
        MOVEQ #0,D0
LBL_719:
        TST.L D0
        BEQ.W LBL_720
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_118
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
        BEQ.W LBL_721
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_169
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_723
        MOVEQ #1,D0
        MOVE.B D0,-34(A6)
LBL_723:
        BRA.W LBL_722
LBL_721:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_722:
        CLR.L D0
        MOVE.B -34(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_724
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 2618(A5)
        ADDQ.L #4,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 3530(A5)
        ADDQ.L #8,A7
LBL_724:
LBL_720:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_716
LBL_717:
LBL_712:
        UNLK A6
        RTS
        ; func rtUiBuildEvery  (JT slot 196)
        ;   local n : -4(A6)  size 4
        ;   local now : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
LBL_195:
        LINK A6,#-2208
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        BSR.W LBL_72
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-30(A5)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_726
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; UiNewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-26(A5)
        BRA.W LBL_727
LBL_726:
        MOVEQ #0,D0
        MOVE.L D0,-26(A5)
LBL_727:
        LEA LBL_232(PC),A0
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
        BEQ.W LBL_728
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_729
LBL_728:
        CLR.L -(A7)
        DC.W $A975  ; UiTickCount
        MOVE.L (A7)+,D0
        MOVE.L D0,-8(A6)
LBL_729:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_730:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_731
        MOVE.L -26(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_123
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_730
LBL_731:
LBL_725:
        UNLK A6
        RTS
        ; func rtUiEveryPump  (JT slot 197)
        ;   local now : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local due : -12(A6)  size 4
LBL_196:
        LINK A6,#-2208
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B -44(A5),D0
        TST.L D0
        BEQ.W LBL_733
        JSR 2858(A5)
        BRA.W LBL_732
LBL_733:
        MOVE.L -26(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_734
        BRA.W LBL_732
LBL_734:
        CLR.L -(A7)
        DC.W $A975  ; UiTickCount
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_735:
        MOVE.L -8(A6),D1
        MOVE.L -30(A5),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_736
        MOVE.L -26(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
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
        BEQ.W LBL_737
        MOVE.L -26(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_233
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_123
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2626(A5)
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3538(A5)
        ADDQ.L #4,A7
LBL_737:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_735
LBL_736:
LBL_732:
        UNLK A6
        RTS
        ; func rtUiStartup  (JT slot 198)
        ;   local resp : -4(A6)  size 4
        ;   local err : -8(A6)  size 4
LBL_197:
        LINK A6,#-2204
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        JSR 3434(A5)
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
        BEQ.W LBL_739
        MOVE.L #1937339254,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A1AD  ; UiGestaltValue
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_740
LBL_739:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_740:
        MOVE.L -4(A6),D1
        MOVE.L #1792,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_741
        MOVE.L -4(A6),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_742
LBL_741:
        MOVEQ #0,D0
LBL_742:
        MOVE.B D0,-22(A5)
        BSR.W LBL_185
        BSR.W LBL_189
        JSR 2570(A5)
        BSR.W LBL_191
        BSR.W LBL_195
LBL_738:
        UNLK A6
        RTS
        ; func rtUiFlushAllBuffered  (JT slot 199)
        ;   local wp : -4(A6)  size 4
LBL_198:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-4(A6)
LBL_744:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_745
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
        BEQ.W LBL_746
        CLR.L -(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A917  ; UiGetWRefCon
        MOVE.L (A7)+,D0
        MOVE.L D0,-(A7)
        JSR 2042(A5)
        ADDQ.L #4,A7
LBL_746:
        MOVE.L -4(A6),D1
        MOVE.L #144,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_744
LBL_745:
LBL_743:
        UNLK A6
        RTS
        ; func rtUiDrawDefaultOutline  (JT slot 200)
        ;   param box : 8(A6)  size 4
        ;   local r : -4(A6)  size 4
LBL_199:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
LBL_747:
        UNLK A6
        RTS
        ; func rtUiHandleUpdate  (JT slot 201)
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
LBL_200:
        LINK A6,#-2312
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
        BSR.W LBL_168
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_749
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
        BSR.W LBL_82
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_750
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        CLR.L -(A7)
        DC.W $A8D8  ; UiNewRgn
        MOVE.L (A7)+,D0
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
LBL_750:
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_751:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_752
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_753
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1810(A5)
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
        JSR 1802(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A9CE  ; UiTextBox
        BRA.W LBL_754
LBL_753:
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_755
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_102
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
        BEQ.W LBL_757
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1802(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_199
        ADDQ.L #4,A7
LBL_757:
        BRA.W LBL_756
LBL_755:
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_758
        MOVE.L -20(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_759
LBL_758:
        MOVEQ #1,D0
LBL_759:
        TST.L D0
        BEQ.W LBL_760
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_762
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        BEQ.W LBL_763
        MOVE.L -48(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_763:
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
        BEQ.W LBL_764
        MOVE.L -48(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_764:
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
LBL_762:
        MOVE.L -20(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_765
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1810(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_766
LBL_765:
        MOVEQ #0,D0
LBL_766:
        TST.L D0
        BEQ.W LBL_767
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-52(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1802(A5)
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
        JSR 1810(A5)
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
LBL_767:
        BRA.W LBL_761
LBL_760:
        MOVE.L -20(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_768
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1786(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_769
LBL_768:
        MOVEQ #0,D0
LBL_769:
        TST.L D0
        BEQ.W LBL_770
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1810(A5)
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
        BEQ.W LBL_772
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-52(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1802(A5)
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
        JSR 1810(A5)
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
LBL_772:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2298(A5)
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
        JSR 2266(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-68(A6)
        MOVE.L -68(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_773
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        JSR 2282(A5)
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
        BSR.W LBL_162
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
        BSR.W LBL_234
        MOVE.L D0,D1
        MOVEQ #2,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-76(A6)
        MOVEQ #0,D0
        MOVE.L D0,-80(A6)
LBL_774:
        MOVE.L -80(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_775
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
        BRA.W LBL_774
LBL_775:
LBL_773:
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_771
LBL_770:
        MOVE.L -20(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_776
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2250(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_777
LBL_776:
        MOVEQ #0,D0
LBL_777:
        TST.L D0
        BEQ.W LBL_778
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2250(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_103
        ADDQ.L #8,A7
        MOVE.L D0,-92(A6)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_143
        ADDQ.L #4,A7
        MOVE.L D0,-96(A6)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_142
        ADDQ.L #4,A7
        MOVE.L D0,-100(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1802(A5)
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
        BSR.W LBL_162
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
        JSR 2306(A5)
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
LBL_779:
        MOVE.L -116(A6),D1
        MOVE.L -100(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_780
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
        BSR.W LBL_146
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
        BSR.W LBL_146
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
        BSR.W LBL_148
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_781
        MOVE.L -108(A6),D1
        MOVE.L -104(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-108(A6)
        BRA.W LBL_782
LBL_781:
        MOVE.L -108(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_147
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-108(A6)
LBL_782:
        MOVE.L -116(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-116(A6)
        BRA.W LBL_779
LBL_780:
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
LBL_778:
LBL_771:
LBL_761:
LBL_756:
LBL_754:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_751
LBL_752:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2042(A5)
        ADDQ.L #4,A7
LBL_749:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A923  ; UiEndUpdate
LBL_748:
        UNLK A6
        RTS
        ; func rtUiHandleActivate  (JT slot 202)
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
LBL_201:
        LINK A6,#-2230
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
        BSR.W LBL_168
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_784
        BRA.W LBL_783
LBL_784:
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
        BSR.W LBL_85
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_785:
        MOVE.L -16(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_786
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1786(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_787
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_788
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1858(A5)
        ADDQ.L #8,A7
        BRA.W LBL_789
LBL_788:
        MOVEQ #0,D0
LBL_789:
        MOVE.B D0,-34(A6)
        CLR.L D0
        MOVE.B -34(A6),D0
        TST.L D0
        BEQ.W LBL_790
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
        BRA.W LBL_791
LBL_790:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
LBL_791:
LBL_787:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1842(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_792
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_793
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
        BRA.W LBL_794
LBL_793:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.W D0,-(A7)
        DC.W $A95D  ; UiHiliteControl
LBL_794:
LBL_792:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2250(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_795
        CLR.L D0
        MOVE.B 8(A6),D0
        LSL.W #8,D0
        MOVE.W D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W #0,-(A7)
        DC.W $A9E7  ; UiLActivate
LBL_795:
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_785
LBL_786:
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
        BEQ.W LBL_796
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        LEA 76(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 1826(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_797
        CLR.L D0
        MOVE.B 8(A6),D0
        TST.L D0
        BEQ.W LBL_798
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D8  ; UiTEActivate
        BRA.W LBL_799
LBL_798:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D9  ; UiTEDeactivate
LBL_799:
LBL_797:
LBL_796:
LBL_783:
        UNLK A6
        RTS
        ; func rtUiInvalGrowCorner  (JT slot 203)
        ;   param wp : 8(A6)  size 4
        ;   local r : -4(A6)  size 4
LBL_202:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
LBL_800:
        UNLK A6
        RTS
        ; func rtUiApplyResize  (JT slot 204)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param newW : 12(A6)  size 4
        ;   param newH : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local savedPort : -8(A6)  size 4
LBL_203:
        LINK A6,#-2204
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        JSR 1874(A5)
        MOVE.L D0,-8(A6)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_202
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
        BSR.W LBL_202
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1906(A5)
        ADDQ.L #4,A7
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_227(PC),A0
        MOVE.L A0,-(A7)
        JSR 2602(A5)
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
        JSR 3514(A5)
        ADDA.W #20,A7
LBL_801:
        UNLK A6
        RTS
        ; func rtUiHandleGrow  (JT slot 205)
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
LBL_204:
        LINK A6,#-2252
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
        BSR.W LBL_82
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_803
        BRA.W LBL_802
LBL_803:
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
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
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
        BEQ.W LBL_804
        MOVEQ #1,D0
        MOVE.L D0,-36(A6)
LBL_804:
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_805
        MOVEQ #1,D0
        MOVE.L D0,-40(A6)
LBL_805:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_806
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-44(A6)
        BRA.W LBL_807
LBL_806:
        MOVEQ #1,D0
        MOVE.L D0,-44(A6)
LBL_807:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_808
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L D0,-48(A6)
        BRA.W LBL_809
LBL_808:
        MOVEQ #1,D0
        MOVE.L D0,-48(A6)
LBL_809:
        MOVE.L -36(A6),D1
        MOVE.L -44(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_810
        MOVE.L -44(A6),D0
        MOVE.L D0,-36(A6)
LBL_810:
        MOVE.L -40(A6),D1
        MOVE.L -48(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_811
        MOVE.L -48(A6),D0
        MOVE.L D0,-40(A6)
LBL_811:
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
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
        BEQ.W LBL_812
        BRA.W LBL_802
LBL_812:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_182
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_181
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_203
        ADDA.W #16,A7
LBL_802:
        UNLK A6
        RTS
        ; func rtUiApplyZoom  (JT slot 206)
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
LBL_205:
        LINK A6,#-2226
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
        BEQ.W LBL_814
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_162
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
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
        BSR.W LBL_162
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
        BEQ.W LBL_815
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
LBL_815:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
LBL_814:
        JSR 1874(A5)
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
        BSR.W LBL_203
        ADDA.W #16,A7
LBL_813:
        UNLK A6
        RTS
        ; func rtUiHandleZoom  (JT slot 207)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param wherePt : 12(A6)  size 4
        ;   param part : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_206:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_817
        BRA.W LBL_816
LBL_817:
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
        BEQ.W LBL_818
        BRA.W LBL_816
LBL_818:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_205
        ADDA.W #12,A7
LBL_816:
        UNLK A6
        RTS
        ; func rtUiFireWidget  (JT slot 208)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local ctrl : -12(A6)  size 4
        ;   local newVal : -16(A6)  size 4
        ;   local savedPort : -20(A6)  size 4
        ;   local wasModalInst : -22(A6)  size 2
        ;   local flags : -26(A6)  size 4
        ;   local front : -30(A6)  size 4
LBL_207:
        LINK A6,#-2226
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
        MOVE.L D0,-4(A6)
        JSR 1874(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1786(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        CLR.L D0
        MOVE.B -120(A5),D0
        TST.L D0
        BEQ.W LBL_820
        MOVE.L -124(A5),D1
        MOVE.L 12(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_821
LBL_820:
        MOVEQ #0,D0
LBL_821:
        MOVE.B D0,-22(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_822
        CLR.W -(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_824
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_825
LBL_824:
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
LBL_825:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_228(PC),A0
        MOVE.L A0,-(A7)
        JSR 2610(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 3522(A5)
        ADDA.W #24,A7
        BRA.W LBL_823
LBL_822:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_826
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_102
        ADDQ.L #8,A7
        MOVE.L D0,-26(A6)
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_827
        MOVE.L -26(A6),D1
        MOVEQ #1,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_828
LBL_827:
        MOVEQ #0,D0
LBL_828:
        TST.L D0
        BEQ.W LBL_829
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2994(A5)
        ADDQ.L #4,A7
        BRA.W LBL_830
LBL_829:
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_831
        MOVE.L -26(A6),D1
        MOVEQ #2,D0
        AND.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_832
LBL_831:
        MOVEQ #0,D0
LBL_832:
        TST.L D0
        BEQ.W LBL_833
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
        BRA.W LBL_834
LBL_833:
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_92
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        LEA LBL_229(PC),A0
        MOVE.L A0,-(A7)
        JSR 2610(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 3522(A5)
        ADDA.W #24,A7
LBL_834:
LBL_830:
LBL_826:
LBL_823:
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BEQ.W LBL_835
        CLR.L D0
        MOVE.B -120(A5),D0
        EORI.L #1,D0
        BRA.W LBL_836
LBL_835:
        MOVEQ #0,D0
LBL_836:
        TST.L D0
        BEQ.W LBL_837
        CLR.L -(A7)
        DC.W $A924  ; UiFrontWindow
        MOVE.L (A7)+,D0
        MOVE.L D0,-30(A6)
        MOVE.L -30(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_839
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_839:
        BRA.W LBL_838
LBL_837:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_838:
LBL_819:
        UNLK A6
        RTS
        ; func rtUiHandleCanvasClick  (JT slot 209)
        ;   param wp : 20(A6)  size 4
        ;   param inst : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param wherePt : 8(A6)  size 4
        ;   local last : -4(A6)  size 4
        ;   local cur : -8(A6)  size 4
LBL_208:
        LINK A6,#-2204
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1738(A5)
        ADDA.W #16,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
LBL_841:
        CLR.W -(A7)
        DC.W $A973  ; UiStillDown
        CLR.L D0
        MOVE.W (A7)+,D0
        LSR.L #8,D0
        TST.L D0
        BEQ.W LBL_842
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        BSR.W LBL_180
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_843
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1738(A5)
        ADDA.W #16,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
LBL_843:
        BRA.W LBL_841
LBL_842:
LBL_840:
        UNLK A6
        RTS
        ; func nat_UiCbAddr  (JT slot 210)
        ;   param cb : 8(A6)  size 4
LBL_209:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        BRA.W LBL_844
LBL_844:
        UNLK A6
        RTS
LBL_233:
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
LBL_234:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_845
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_845:
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
        BPL.W LBL_846
        NEG.L D2
        MOVE.L #1,D4
LBL_846:
        CLR.L D5
        TST.L D3
        BPL.W LBL_847
        NEG.L D3
        MOVE.L #1,D5
LBL_847:
        CLR.L D6
        MOVE.W #31,D7
LBL_848:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_849
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_849:
        DBRA D7,LBL_848
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_850
        NEG.L D2
LBL_850:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_235:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_851
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_230(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
LBL_851:
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
        BPL.W LBL_852
        NEG.L D2
        MOVE.L #1,D4
LBL_852:
        CLR.L D5
        TST.L D3
        BPL.W LBL_853
        NEG.L D3
        MOVE.L #1,D5
LBL_853:
        CLR.L D6
        MOVE.W #31,D7
LBL_854:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_855
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_855:
        DBRA D7,LBL_854
        TST.L D4
        BEQ.W LBL_856
        NEG.L D6
LBL_856:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_236:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -1300(A5),D0
        MOVE.L D0,-4(A6)
LBL_857:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_230:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_210:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_211:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_212:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_213:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_215:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_216:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_217:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_218:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_219:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_220:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_214:
        DC.B $01
        DC.B $2D
LBL_221:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_222:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_223:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_224:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_225:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_226:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_227:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
LBL_228:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_229:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (112 bytes)
LBL_231:
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
        DC.B $5C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $5C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $5C
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $5C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $61
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $C8
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $64
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
        DC.B $04
        DC.B $4D
        DC.B $61
        DC.B $69
        DC.B $6E
        DC.B $0D
        DC.B $43
        DC.B $6F
        DC.B $6E
        DC.B $6E
        DC.B $46
        DC.B $61
        DC.B $69
        DC.B $6C
        DC.B $50
        DC.B $72
        DC.B $6F
        DC.B $62
        DC.B $65
        DC.B $00
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_232:
        DC.B $00
        DC.B $00
