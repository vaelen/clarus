        ; func natQuit  (JT slot 199)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_0:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7092(A5),D0
        TST.L D0
        BEQ.W LBL_228
        BRA.W LBL_227
LBL_228:
        MOVEQ #1,D0
        MOVE.B D0,-7092(A5)
        JSR 1530(A5)
        CLR.L D0
        MOVE.B -7098(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_229
        DC.W $A9F4  ; NatExitToShell
LBL_229:
        JSR 1482(A5)
        MOVE.L -7072(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7072(A5),D0
        MOVE.L D0,-(A7)
        JSR 1458(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7072(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L -7072(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7072(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L -7080(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L -7088(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_230
        MOVE.L -7068(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7088(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7068(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_230:
        JSR 1474(A5)
        DC.W $A9F4  ; NatExitToShell
LBL_227:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 200)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_1:
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
        LEA LBL_64(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        JSR 1482(A5)
        LEA -256(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-260(A6)
        MOVE.L -7126(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -260(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
LBL_232:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_233
        MOVE.L -7126(A5),D1
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
        BCS.W LBL_234
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 114(A5)
        ADDQ.L #8,A7
LBL_234:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_232
LBL_233:
        CLR.L D0
        MOVE.B -7098(A5),D0
        TST.L D0
        BEQ.W LBL_235
        MOVE.L -7126(A5),D0
        MOVE.L D0,-(A7)
        JSR 1562(A5)
        ADDQ.L #4,A7
LBL_235:
        MOVE.L -7126(A5),D0
        MOVE.L D0,-(A7)
        JSR 1570(A5)
        ADDQ.L #4,A7
        JSR 1530(A5)
        CLR.L D0
        MOVE.B -7402(A5),D0
        TST.L D0
        BEQ.W LBL_236
        LEA LBL_219(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_237
LBL_236:
        MOVEQ #0,D0
LBL_237:
        TST.L D0
        BEQ.W LBL_238
        MOVEQ #30,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; NatSysBeep
        MOVE.L -7126(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7130(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7130(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7130(A5),D0
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
LBL_238:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_231:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 201)
LBL_2:
        LINK A6,#-52
        MOVE.L -7394(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_239:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 202)
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
LBL_3:
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
        JSR 66(A5)
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
        BEQ.W LBL_241
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_65(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_240
LBL_241:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 66(A5)
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
        BEQ.W LBL_242
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_240
LBL_242:
        JSR 1610(A5)
        MOVE.L -7394(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_243
        MOVE.L -7394(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_243:
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_244
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_63(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_240
LBL_244:
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D0
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
        BEQ.W LBL_245
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
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7394(A5),D1
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
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_246
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_246:
LBL_245:
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_2
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_247
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_248
LBL_247:
        MOVEQ #1,D0
LBL_248:
        TST.L D0
        BEQ.W LBL_249
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_61(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_240
LBL_249:
        MOVEQ #1,D0
        BRA.W LBL_240
LBL_240:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 203)
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
LBL_4:
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
        JSR 1610(A5)
        MOVE.L -7394(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_251
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_63(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_250
LBL_251:
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_252
        LEA LBL_60(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_252:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_253:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_254
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -7394(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_255
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_256
LBL_255:
        MOVEQ #0,D0
LBL_256:
        TST.L D0
        BEQ.W LBL_257
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_62(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_250
LBL_257:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_258
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
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
LBL_258:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_259
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_260
LBL_259:
        MOVEQ #1,D0
LBL_260:
        TST.L D0
        BEQ.W LBL_261
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_261:
        BRA.W LBL_253
LBL_254:
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
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
        BRA.W LBL_250
LBL_250:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 204)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
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
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_263:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_264
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
        BEQ.W LBL_265
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_265:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_263
LBL_264:
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
LBL_266:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
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
        BRA.W LBL_266
LBL_267:
LBL_262:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 205)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_6:
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
        BEQ.W LBL_269
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_67(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_268
LBL_269:
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
        JSR 122(A5)
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
        BEQ.W LBL_270
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
LBL_270:
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
        BRA.W LBL_268
LBL_268:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 206)
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
LBL_7:
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
        JSR 66(A5)
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
        BEQ.W LBL_272
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_65(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_271
LBL_272:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 66(A5)
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
        BEQ.W LBL_273
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_271
LBL_273:
        JSR 1610(A5)
        MOVE.L -7394(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_274
        MOVE.L -7394(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_274:
        MOVE.L -7394(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_275
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_63(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_271
LBL_275:
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D0
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
        BEQ.W LBL_276
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
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7394(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -7394(A5),D1
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
        MOVE.L -7394(A5),D1
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
        BEQ.W LBL_277
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_277:
LBL_276:
        MOVE.L -7394(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -7394(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_2
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_278
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_279
LBL_278:
        MOVEQ #1,D0
LBL_279:
        TST.L D0
        BEQ.W LBL_280
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_61(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_271
LBL_280:
        MOVEQ #1,D0
        BRA.W LBL_271
LBL_271:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 207)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_8:
        LINK A6,#-52
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_282
        MOVEQ #1,D0
        BRA.W LBL_281
LBL_282:
        MOVEQ #0,D0
        BRA.W LBL_281
LBL_281:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 208)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_284
        MOVEQ #1,D0
        BRA.W LBL_283
LBL_284:
        MOVEQ #0,D0
        BRA.W LBL_283
LBL_283:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 209)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_10:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7098(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_286
        CLR.L D0
        MOVE.B -7122(A5),D0
        TST.L D0
        BEQ.W LBL_287
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
LBL_287:
        BRA.W LBL_285
LBL_286:
        JSR 1482(A5)
        MOVE.L -7400(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_288
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7400(A5)
LBL_288:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7400(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7400(A5),D1
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
        MOVE.L -7400(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        JSR 1474(A5)
LBL_285:
        UNLK A6
        RTS
        ; func natWlAddText  (JT slot 210)
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_11:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7120(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_290
        BRA.W LBL_289
LBL_290:
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
        BEQ.W LBL_291
        MOVE.L #511,D0
        MOVE.L D0,-8(A6)
LBL_291:
        MOVE.L -7118(A5),D1
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
        BEQ.W LBL_292
        JSR 1530(A5)
LBL_292:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7106(A5),D1
        MOVE.L -7118(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -7106(A5),D1
        MOVE.L -7118(A5),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7118(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-7118(A5)
LBL_289:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 211)
LBL_12:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7402(A5),D0
        TST.L D0
        BEQ.W LBL_294
        BRA.W LBL_293
LBL_294:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7406(A5)
        MOVE.L -7406(A5),D1
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
        MOVE.B D0,-7402(A5)
        DC.W $A850  ; NatInitCursor
LBL_293:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 212)
        ;   param out : 8(A6)  size 4
LBL_13:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
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
        MOVE.L -7406(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_295:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 213)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_14:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_297
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_297:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
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
        MOVE.L -7406(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_296:
        UNLK A6
        RTS
        ; func nat_UiConnPump  (JT slot 214)
LBL_15:
        LINK A6,#-52
        BSR.W LBL_36
LBL_298:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 215)
        ;   param cond : 12(A6)  size 2
        ;   param label : 8(A6)  size 4
        ;   local msg : -256(A6)  size 256
LBL_16:
        LINK A6,#-308
        LEA -256(A6),A0
        CLR.B (A0)
        CLR.L D0
        MOVE.B 12(A6),D0
        TST.L D0
        BEQ.W LBL_300
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_68(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        BRA.W LBL_301
LBL_300:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_69(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
LBL_301:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 1562(A5)
        ADDQ.L #4,A7
LBL_299:
        UNLK A6
        RTS
        ; func smokeMakePoint  (JT slot 216)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -46(A6)  size 46
        ;   local __store5 : -92(A6)  size 46
        ;   local __ret5 : -138(A6)  size 46
LBL_17:
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
LBL_303:
        CLR.W (A0)+
        DBRA D0,LBL_303
        LEA -92(A6),A0
        MOVE.W #22,D0
LBL_304:
        CLR.W (A0)+
        DBRA D0,LBL_304
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
LBL_305:
        CLR.W (A0)+
        DBRA D0,LBL_305
        LEA -92(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
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
LBL_306:
        CLR.W (A0)+
        DBRA D0,LBL_306
        LEA -92(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -92(A6),A0
        MOVE.L A0,-(A7)
        LEA -46(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_307:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_307
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
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A0,-(A7)
        LEA -138(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_308:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_308
        LEA -138(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -138(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_309:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_309
        BRA.W LBL_302
LBL_302:
        UNLK A6
        RTS
        ; func smokeTakePoint  (JT slot 217)
        ;   param p : 8(A6)  size 4
LBL_18:
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
        BRA.W LBL_310
LBL_310:
        UNLK A6
        RTS
        ; func smokeListInt  (JT slot 218)
        ;   local l : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local x : -16(A6)  size 4
LBL_19:
        LINK A6,#-76
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 242(A5)
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
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #20,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #30,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_70(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 314(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_71(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 322(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_72(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_312
        BRA.W LBL_313
LBL_312:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_313:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        LEA LBL_73(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVEQ #25,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_314
        BRA.W LBL_315
LBL_314:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_315:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        BCC.W LBL_316
        BRA.W LBL_317
LBL_316:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_317:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        LEA LBL_74(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 306(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_318
        BRA.W LBL_319
LBL_318:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_319:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        LEA LBL_75(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_76(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 298(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_77(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_78(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_79(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_80(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 330(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_81(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_320
        BRA.W LBL_321
LBL_320:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_321:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #100,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #200,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_322:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_324
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        JSR 274(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        LEA -16(A6),A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.L -8(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_323:
        ADDQ.L #1,(A7)
        BRA.W LBL_322
LBL_324:
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
        LEA LBL_83(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_84(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-32(A6)
LBL_325:
        MOVE.L A1,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_311:
        UNLK A6
        RTS
        ; func smokeListText  (JT slot 219)
        ;   local l : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local __store6 : -12(A6)  size 4
        ;   local __store7 : -16(A6)  size 4
LBL_20:
        LINK A6,#-88
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
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
        JSR 130(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_86(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 314(A5)
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_89(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 322(A5)
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_327
        BRA.W LBL_328
LBL_327:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_328:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_86(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #1,D0
        MOVE.L D0,-24(A6)
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_92(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_329
        BRA.W LBL_330
LBL_329:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_330:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_331
        BRA.W LBL_332
LBL_331:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_332:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        BCC.W LBL_333
        BRA.W LBL_334
LBL_333:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_334:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_92(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_93(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 298(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_96(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_97(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_335
        BRA.W LBL_336
LBL_335:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_336:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 330(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_98(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_99(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_100(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_101(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_337
        BRA.W LBL_338
LBL_337:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_338:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA LBL_99(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-44(A6)
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_339
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-48(A6)
        CLR.L -52(A6)
LBL_340:
        MOVE.L -52(A6),D0
        MOVE.L -48(A6),D1
        CMP.L D1,D0
        BGE.W LBL_339
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR 274(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-52(A6)
        BRA.W LBL_340
LBL_339:
        MOVE.L A1,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_326:
        UNLK A6
        RTS
        ; func smokeMapInt  (JT slot 220)
        ;   local m : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local k : -264(A6)  size 256
        ;   local v : -268(A6)  size 4
LBL_21:
        LINK A6,#-336
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 522(A5)
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
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVEQ #2,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVEQ #3,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_105(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L -276(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_107(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_105(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-(A7)
        LEA LBL_108(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_109(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_110(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_109(PC),A0
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
        JSR 570(A5)
        ADDA.W #12,A7
        MOVE.L -284(A6),D1
        MOVEQ #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_111(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_103(PC),A0
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
        JSR 570(A5)
        ADDA.W #12,A7
        MOVE.L -284(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_112(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVEQ #22,D0
        MOVE.L D0,-276(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L -276(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        JSR 586(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_115(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 586(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_117(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_342:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_344
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        JSR 602(A5)
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVE.L -8(A6),D1
        MOVE.L -268(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_343:
        ADDQ.L #1,(A7)
        BRA.W LBL_342
LBL_344:
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
        LEA LBL_118(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-292(A6)
LBL_345:
        MOVE.L A1,-(A7)
        MOVE.L -292(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_341:
        UNLK A6
        RTS
        ; func smokeMapText  (JT slot 221)
        ;   local m : -4(A6)  size 4
        ;   local k : -260(A6)  size 256
        ;   local v : -264(A6)  size 4
        ;   local found : -268(A6)  size 4
LBL_22:
        LINK A6,#-340
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        CLR.B (A0)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_347
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_347:
        JSR 130(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_348
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_348:
        JSR 130(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_124(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_125(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        JSR 130(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
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
        JSR 570(A5)
        ADDA.W #12,A7
        MOVE.L -288(A6),D0
        MOVE.L -280(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_349
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_349:
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_119(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        JSR 130(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
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
        JSR 570(A5)
        ADDA.W #12,A7
        MOVE.L -288(A6),D0
        MOVE.L -280(A6),D1
        CMP.L D1,D0
        BEQ.W LBL_350
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_350:
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_351
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_351:
        JSR 130(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -284(A6),D0
        MOVE.L D0,-280(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        LEA -280(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_352
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        LEA -276(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_352:
        MOVE.L -272(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 586(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_353:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_355
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        JSR 602(A5)
        ADDA.W #12,A7
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -264(A6),D0
        MOVE.L D0,-268(A6)
LBL_354:
        ADDQ.L #1,(A7)
        BRA.W LBL_353
LBL_355:
        ADDA.W #12,A7
        MOVE.L -268(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-296(A6)
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_356
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-300(A6)
        CLR.L -304(A6)
LBL_357:
        MOVE.L -304(A6),D0
        MOVE.L -300(A6),D1
        CMP.L D1,D0
        BGE.W LBL_356
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -304(A6),D0
        MOVE.L D0,-(A7)
        LEA -308(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -308(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-304(A6)
        BRA.W LBL_357
LBL_356:
        MOVE.L A1,-(A7)
        MOVE.L -296(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_346:
        UNLK A6
        RTS
        ; func smokeTextOps  (JT slot 222)
        ;   local t : -4(A6)  size 4
        ;   local __store8 : -8(A6)  size 4
        ;   local u : -12(A6)  size 4
        ;   local __store9 : -16(A6)  size 4
LBL_23:
        LINK A6,#-72
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -16(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 130(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-8(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        JSR 210(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #33,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 130(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        CLR.L -(A7)
        JSR 162(A5)
        ADDA.W #16,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_146(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_358:
        UNLK A6
        RTS
        ; func smokeNested  (JT slot 223)
        ;   local lm : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local got : -12(A6)  size 4
        ;   local __store10 : -16(A6)  size 4
LBL_24:
        LINK A6,#-84
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -16(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_360
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_360:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_149(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_361
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-44(A6)
        CLR.L -48(A6)
LBL_362:
        MOVE.L -48(A6),D0
        MOVE.L -44(A6),D1
        CMP.L D1,D0
        BGE.W LBL_361
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        LEA -52(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -52(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-48(A6)
        BRA.W LBL_362
LBL_361:
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_363
        BRA.W LBL_364
LBL_363:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_364:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        JSR 530(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_365
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-44(A6)
        CLR.L -48(A6)
LBL_366:
        MOVE.L -48(A6),D0
        MOVE.L -44(A6),D1
        CMP.L D1,D0
        BGE.W LBL_365
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        LEA -52(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -52(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-48(A6)
        BRA.W LBL_366
LBL_365:
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_367
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_367:
        JSR 130(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_151(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 554(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_368
        BRA.W LBL_369
LBL_368:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_369:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_151(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_152(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_370
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-44(A6)
        CLR.L -48(A6)
LBL_371:
        MOVE.L -48(A6),D0
        MOVE.L -44(A6),D1
        CMP.L D1,D0
        BGE.W LBL_370
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        JSR 274(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-56(A6)
        MOVE.L A1,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_372
        MOVE.L A1,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-60(A6)
        CLR.L -64(A6)
LBL_373:
        MOVE.L -64(A6),D0
        MOVE.L -60(A6),D1
        CMP.L D1,D0
        BGE.W LBL_372
        MOVE.L A1,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        LEA -68(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -68(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-64(A6)
        BRA.W LBL_373
LBL_372:
        MOVE.L A1,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-48(A6)
        BRA.W LBL_371
LBL_370:
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_374
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-44(A6)
        CLR.L -48(A6)
LBL_375:
        MOVE.L -48(A6),D0
        MOVE.L -44(A6),D1
        CMP.L D1,D0
        BGE.W LBL_374
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        LEA -52(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -52(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-48(A6)
        BRA.W LBL_375
LBL_374:
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-40(A6)
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_376
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-44(A6)
        CLR.L -48(A6)
LBL_377:
        MOVE.L -48(A6),D0
        MOVE.L -44(A6),D1
        CMP.L D1,D0
        BGE.W LBL_376
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        LEA -52(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -52(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-48(A6)
        BRA.W LBL_377
LBL_376:
        MOVE.L A1,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_359:
        UNLK A6
        RTS
        ; func smokeAliasing  (JT slot 224)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
        ;   local __store11 : -12(A6)  size 4
LBL_25:
        LINK A6,#-68
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 242(A5)
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
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_379:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
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
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_153(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_380
        BRA.W LBL_381
LBL_380:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_381:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_223
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
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_382:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_26
        MOVE.L D0,-16(A6)
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_383:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_384:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-24(A6)
LBL_385:
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_378:
        UNLK A6
        RTS
        ; func other  (JT slot 225)
        ;   local l : -4(A6)  size 4
        ;   local __ret6 : -8(A6)  size 4
LBL_26:
        LINK A6,#-64
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #42,D0
        MOVE.L D0,-12(A6)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-20(A6)
LBL_387:
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-20(A6)
LBL_388:
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func smokeClamp3  (JT slot 226)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param s : 12(A6)  size 4
LBL_27:
        LINK A6,#-52
        MOVE.L 8(A6),-(A7)
        MOVE.L #3,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        BRA.W LBL_389
LBL_389:
        UNLK A6
        RTS
        ; func smokeFileNameOf  (JT slot 227)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param p : 12(A6)  size 4
LBL_28:
        LINK A6,#-52
        MOVE.L 8(A6),-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        BRA.W LBL_390
LBL_390:
        UNLK A6
        RTS
        ; func smokeFiles  (JT slot 228)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local n : -268(A6)  size 256
        ;   local errMsg : -524(A6)  size 256
        ;   local e : -784(A6)  size 260
        ;   local __store12 : -788(A6)  size 4
        ;   local __store13 : -792(A6)  size 4
LBL_29:
        LINK A6,#-848
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
        LEA -268(A6),A0
        CLR.B (A0)
        LEA -524(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-784(A6)
        LEA -780(A6),A0
        MOVE.W #127,D0
LBL_392:
        CLR.W (A0)+
        DBRA D0,LBL_392
        LEA -788(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -792(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -788(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 130(A5)
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-788(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -788(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-788(A6)
        LEA LBL_158(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA LBL_158(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_163(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -792(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 130(A5)
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_59(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-792(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -792(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-792(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #13,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #66,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_165(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_166(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVEQ #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_393
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_393:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #65,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_394
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_394:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_395
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_395:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #13,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_396
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_396:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_397
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_397:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #66,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_398
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_398:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_168(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_170(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_59(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_174(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA LBL_175(PC),A0
        MOVE.L A0,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_176(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_177(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA LBL_178(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_179(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        JSR 1586(A5)
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        JSR 1594(A5)
        ADDQ.L #4,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_63(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_181(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -784(A6),A0
        MOVEA.L A0,A1
        JSR 1586(A5)
        MOVE.L D0,0(A1)
        LEA 4(A1),A0
        MOVE.L A0,-(A7)
        JSR 1594(A5)
        ADDQ.L #4,A7
        LEA -784(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_182(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -784(A6),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_63(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_391:
        UNLK A6
        RTS
        ; func smokeFilesBig  (JT slot 229)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local i : -16(A6)  size 4
        ;   local n : -20(A6)  size 4
        ;   local __store14 : -24(A6)  size 4
LBL_30:
        LINK A6,#-80
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        LEA -24(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        MOVE.L #40000,D0
        MOVE.L D0,-20(A6)
        LEA -24(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 130(A5)
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_59(PC),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
        ADDQ.L #8,A7
        MOVE.L -28(A6),D0
        MOVE.L D0,-24(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_400:
        MOVE.L -16(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_225
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_400
LBL_401:
        LEA LBL_184(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA LBL_184(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVEQ #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_402
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_402:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_403:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_225
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_404
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_404:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #32767,D1
        MOVE.L #256,D0
        BSR.W LBL_225
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_405
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_405:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #32768,D1
        MOVE.L #256,D0
        BSR.W LBL_225
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_406:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_399:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 230)
        ;   local p : -46(A6)  size 46
        ;   local __store15 : -92(A6)  size 46
        ;   local q : -138(A6)  size 46
        ;   local e : -140(A6)  size 2
        ;   local n : -144(A6)  size 4
        ;   local __store16 : -190(A6)  size 46
        ;   local __store17 : -236(A6)  size 46
LBL_31:
        LINK A6,#-292
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
LBL_408:
        CLR.W (A0)+
        DBRA D0,LBL_408
        LEA -92(A6),A0
        MOVE.W #22,D0
LBL_409:
        CLR.W (A0)+
        DBRA D0,LBL_409
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
LBL_410:
        CLR.W (A0)+
        DBRA D0,LBL_410
        MOVEQ #0,D0
        MOVE.W D0,-140(A6)
        MOVEQ #0,D0
        MOVE.L D0,-144(A6)
        LEA -190(A6),A0
        MOVE.W #22,D0
LBL_411:
        CLR.W (A0)+
        DBRA D0,LBL_411
        LEA -236(A6),A0
        MOVE.W #22,D0
LBL_412:
        CLR.W (A0)+
        DBRA D0,LBL_412
        LEA -92(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
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
LBL_413:
        CLR.W (A0)+
        DBRA D0,LBL_413
        LEA -92(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -92(A6),A0
        MOVE.L A0,-(A7)
        LEA -46(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_414:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_414
        LEA -46(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_188(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_189(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        LEA 8(A0),A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_190(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_191(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -138(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_192(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -138(A6),A0
        LEA 8(A0),A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        LEA -46(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L #90210,D0
        MOVE.L D0,-(A7)
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -46(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_195(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #90210,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_196(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -190(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -46(A6),A0
        MOVE.L A0,-(A7)
        LEA -190(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_415:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_415
        LEA -190(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -138(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -190(A6),A0
        MOVE.L A0,-(A7)
        LEA -138(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_416:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_416
        MOVEQ #99,D0
        MOVE.L D0,-(A7)
        LEA -138(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #11111,D0
        MOVE.L D0,-(A7)
        LEA -138(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -46(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -138(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_199(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #90210,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_200(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -138(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #11111,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_201(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -236(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -236(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -236(A6),A0
        MOVE.L A0,-(A7)
        LEA -46(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #22,D0
LBL_417:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_417
        LEA -46(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_202(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        LEA 10(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #555,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_203(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        LEA -46(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVE.L D0,-144(A6)
        MOVE.L -144(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #555,D0
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_204(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        MOVEQ #6,D0
        MOVE.L D0,D1
        LEA LBL_220(PC),A0
        MOVE.W #2,D2
LBL_419:
        CMP.L (A0)+,D1
        BEQ.W LBL_418
        DBRA D2,LBL_419
        ; enum conversion miss -> rtEnumCheck(v, false, <name arg unused>) panics
        MOVE.L D1,-(A7)
        CLR.W -(A7)
        ADDA.L #-256,A7
        JSR 74(A5)
        ADDA.W #262,A7
LBL_418:
        MOVE.W D0,-140(A6)
        CLR.L D0
        MOVE.W -140(A6),D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        CLR.L D0
        MOVE.W -140(A6),D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_206(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        BSR.W LBL_19
        BSR.W LBL_20
        BSR.W LBL_21
        BSR.W LBL_22
        BSR.W LBL_23
        BSR.W LBL_24
        BSR.W LBL_25
        LEA LBL_207(PC),A0
        MOVE.L A0,-(A7)
        LEA -240(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDQ.L #8,A7
        LEA -240(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_209(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #6,A7
        BSR.W LBL_29
        BSR.W LBL_30
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        JSR 1562(A5)
        ADDQ.L #4,A7
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -138(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_226
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
        LEA -46(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -138(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_407:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 231)
        ;   param slot : 8(A6)  size 4
LBL_32:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        BRA.W LBL_422
LBL_421:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_423
        BRA.W LBL_424
LBL_423:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        BRA.W LBL_426
LBL_425:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_427
        BRA.W LBL_428
LBL_427:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
        BRA.W LBL_430
LBL_429:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
        BRA.W LBL_432
LBL_431:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        BRA.W LBL_434
LBL_433:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
LBL_435:
LBL_434:
LBL_432:
LBL_430:
LBL_428:
LBL_426:
LBL_424:
LBL_422:
LBL_420:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 232)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_33:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_437
        BRA.W LBL_438
LBL_437:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
        BRA.W LBL_440
LBL_439:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        BRA.W LBL_442
LBL_441:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_443
        BRA.W LBL_444
LBL_443:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        BRA.W LBL_446
LBL_445:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
        BRA.W LBL_448
LBL_447:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        BRA.W LBL_450
LBL_449:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_451
LBL_451:
LBL_450:
LBL_448:
LBL_446:
LBL_444:
LBL_442:
LBL_440:
LBL_438:
LBL_436:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 233)
        ;   param slot : 8(A6)  size 4
LBL_34:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_453
        BRA.W LBL_454
LBL_453:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_455
        BRA.W LBL_456
LBL_455:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        BRA.W LBL_458
LBL_457:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        BRA.W LBL_460
LBL_459:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        BRA.W LBL_462
LBL_461:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
        BRA.W LBL_464
LBL_463:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        BRA.W LBL_466
LBL_465:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
LBL_467:
LBL_466:
LBL_464:
LBL_462:
LBL_460:
LBL_458:
LBL_456:
LBL_454:
LBL_452:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 234)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_35:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_469
        BRA.W LBL_470
LBL_469:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        BRA.W LBL_472
LBL_471:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_473
        BRA.W LBL_474
LBL_473:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        BRA.W LBL_476
LBL_475:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_477
        BRA.W LBL_478
LBL_477:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_479
        BRA.W LBL_480
LBL_479:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        BRA.W LBL_482
LBL_481:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_483
LBL_483:
LBL_482:
LBL_480:
LBL_478:
LBL_476:
LBL_474:
LBL_472:
LBL_470:
LBL_468:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 235)
LBL_36:
        LINK A6,#-52
LBL_484:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 236)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_37:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_486
        BRA.W LBL_487
LBL_486:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_488
LBL_488:
LBL_487:
LBL_485:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 237)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_38:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
        BRA.W LBL_491
LBL_490:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_492
LBL_492:
LBL_491:
LBL_489:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 238)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_39:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_494
        BRA.W LBL_495
LBL_494:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_496
LBL_496:
LBL_495:
LBL_493:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 239)
        ;   param slot : 8(A6)  size 4
LBL_40:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_498
        BRA.W LBL_499
LBL_498:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_500
LBL_500:
LBL_499:
LBL_497:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 240)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_41:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_502
        BRA.W LBL_503
LBL_502:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_504
LBL_504:
LBL_503:
LBL_501:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 241)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_42:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_506
        BRA.W LBL_507
LBL_506:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_508
LBL_508:
LBL_507:
LBL_505:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 242)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_43:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_510
        BRA.W LBL_511
LBL_510:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_512
LBL_512:
LBL_511:
LBL_509:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 243)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_44:
        LINK A6,#-52
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        JSR 1570(A5)
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_513:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 244)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_45:
        LINK A6,#-52
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        JSR 1570(A5)
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_514:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 245)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_46:
        LINK A6,#-52
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        JSR 1570(A5)
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_515:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 246)
        ;   param idx : 8(A6)  size 4
LBL_47:
        LINK A6,#-52
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        JSR 1570(A5)
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_516:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 247)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_48:
        LINK A6,#-52
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        JSR 1570(A5)
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_517:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 248)
        ;   param rowsIdx : 8(A6)  size 4
LBL_49:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #153,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_519
        LEA -7096(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_518
        BRA.W LBL_520
LBL_519:
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        JSR 1570(A5)
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_518
LBL_520:
LBL_518:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 249)
        ;   param path : 8(A6)  size 4
LBL_50:
        LINK A6,#-52
LBL_521:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 250)
LBL_51:
        LINK A6,#-52
LBL_522:
        UNLK A6
        RTS
        ; func clar_ui_fire_logop  (JT slot 251)
        ;   param op : 24(A6)  size 4
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_52:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_523
LBL_523:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 252)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_53:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_524
LBL_524:
        UNLK A6
        RTS
        ; func clar_ui_fire_geomapply  (JT slot 253)
LBL_54:
        LINK A6,#-52
LBL_525:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 254) -- pascal callback glue for aeQuitHandler
LBL_55:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1010(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 255) -- pascal callback glue for aeOappHandler
LBL_56:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1018(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 256) -- pascal callback glue for rtUiScrollbarAction
LBL_57:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 257) -- pascal callback glue for rtUiLdefDraw
LBL_58:
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
        JSR 1266(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_223:
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
LBL_224:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_526
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_526:
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
        BPL.W LBL_527
        NEG.L D2
        MOVE.L #1,D4
LBL_527:
        CLR.L D5
        TST.L D3
        BPL.W LBL_528
        NEG.L D3
        MOVE.L #1,D5
LBL_528:
        CLR.L D6
        MOVE.W #31,D7
LBL_529:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_530
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_530:
        DBRA D7,LBL_529
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_531
        NEG.L D2
LBL_531:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_225:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_532
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_532:
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
        BPL.W LBL_533
        NEG.L D2
        MOVE.L #1,D4
LBL_533:
        CLR.L D5
        TST.L D3
        BPL.W LBL_534
        NEG.L D3
        MOVE.L #1,D5
LBL_534:
        CLR.L D6
        MOVE.W #31,D7
LBL_535:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_536
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_536:
        DBRA D7,LBL_535
        TST.L D4
        BEQ.W LBL_537
        NEG.L D6
LBL_537:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_226:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_538(PC),A0
        MOVE.L A0,-4(A6)
LBL_539:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_540
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_541
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_539
LBL_541:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_542:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_539
LBL_540:
        UNLK A6
        RTS
LBL_538:
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
LBL_221:
        ; cg_retain_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_222:
        ; cg_release_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_218:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_64:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_65:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_66:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_63:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_61:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_60:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_62:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_67:
        DC.B $12
        DC.B $72,$65,$73,$6F,$75,$72,$63,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_68:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_69:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_70:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
LBL_71:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$69,$72,$73,$74
        DC.B $00
LBL_72:
        DC.B $0D
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$6C,$61,$73,$74
LBL_217:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_73:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
LBL_74:
        DC.B $12
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
        DC.B $00
LBL_75:
        DC.B $10
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_76:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_77:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
LBL_78:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
        DC.B $00
LBL_79:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
LBL_80:
        DC.B $18
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
        DC.B $00
LBL_81:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_82:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_83:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$73,$75,$6D
LBL_84:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_85:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_86:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_87:
        DC.B $05
        DC.B $67,$61,$6D,$6D,$61
LBL_88:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
        DC.B $00
LBL_89:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$66,$69,$72,$73,$74
LBL_90:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$6C,$61,$73,$74
        DC.B $00
LBL_91:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
        DC.B $00
LBL_92:
        DC.B $04
        DC.B $42,$45,$54,$41
        DC.B $00
LBL_93:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
LBL_94:
        DC.B $16
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_95:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
LBL_96:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_97:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
LBL_98:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_99:
        DC.B $04
        DC.B $73,$6F,$6C,$6F
        DC.B $00
LBL_100:
        DC.B $03
        DC.B $64,$75,$6F
LBL_101:
        DC.B $1D
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
LBL_102:
        DC.B $23
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70
LBL_103:
        DC.B $03
        DC.B $6F,$6E,$65
LBL_104:
        DC.B $03
        DC.B $74,$77,$6F
LBL_105:
        DC.B $05
        DC.B $74,$68,$72,$65,$65
LBL_106:
        DC.B $17
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
LBL_107:
        DC.B $15
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
LBL_108:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_109:
        DC.B $04
        DC.B $66,$6F,$75,$72
        DC.B $00
LBL_110:
        DC.B $12
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_111:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_112:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_113:
        DC.B $11
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
LBL_114:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_115:
        DC.B $18
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_116:
        DC.B $0B
        DC.B $6E,$6F,$6E,$65,$78,$69,$73,$74,$65,$6E,$74
LBL_117:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$72,$65,$6D,$6F,$76,$65,$2D,$61,$62,$73,$65,$6E,$74,$20,$6E,$6F,$2D,$6F,$70
LBL_118:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$73,$75,$6D
LBL_119:
        DC.B $01
        DC.B $61
LBL_120:
        DC.B $05
        DC.B $61,$70,$70,$6C,$65
LBL_121:
        DC.B $01
        DC.B $62
LBL_122:
        DC.B $06
        DC.B $62,$61,$6E,$61,$6E,$61
        DC.B $00
LBL_123:
        DC.B $18
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
        DC.B $00
LBL_124:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
        DC.B $00
LBL_125:
        DC.B $01
        DC.B $7A
LBL_126:
        DC.B $04
        DC.B $6E,$6F,$6E,$65
        DC.B $00
LBL_127:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
LBL_128:
        DC.B $1C
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
        DC.B $00
LBL_129:
        DC.B $07
        DC.B $61,$76,$6F,$63,$61,$64,$6F
LBL_130:
        DC.B $12
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
        DC.B $00
LBL_131:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_132:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$76,$61,$6C,$75,$65
        DC.B $00
LBL_133:
        DC.B $05
        DC.B $68,$65,$6C,$6C,$6F
LBL_134:
        DC.B $07
        DC.B $2C,$20,$77,$6F,$72,$6C,$64
LBL_135:
        DC.B $0C
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64
        DC.B $00
LBL_136:
        DC.B $0F
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$73,$74,$72
LBL_137:
        DC.B $0D
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21
LBL_138:
        DC.B $10
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$63,$68,$61,$72
        DC.B $00
LBL_139:
        DC.B $08
        DC.B $20,$28,$61,$67,$61,$69,$6E,$29
        DC.B $00
LBL_140:
        DC.B $15
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21,$20,$28,$61,$67,$61,$69,$6E,$29
LBL_141:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74
LBL_142:
        DC.B $23
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74,$20,$6C,$65,$61,$76,$65,$73,$20,$73,$6F,$75,$72,$63,$65,$20,$75,$6E,$63,$68,$61,$6E,$67,$65,$64
LBL_143:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$6C,$65,$6E,$67,$74,$68
LBL_144:
        DC.B $0E
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$65,$71,$75,$61,$6C
        DC.B $00
LBL_145:
        DC.B $04
        DC.B $6E,$6F,$70,$65
        DC.B $00
LBL_146:
        DC.B $12
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$6E,$6F,$74,$2D,$65,$71,$75,$61,$6C
        DC.B $00
LBL_147:
        DC.B $01
        DC.B $6B
LBL_148:
        DC.B $02
        DC.B $76,$31
        DC.B $00
LBL_149:
        DC.B $18
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_150:
        DC.B $17
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$72,$65,$61,$64
LBL_151:
        DC.B $02
        DC.B $76,$32
        DC.B $00
LBL_152:
        DC.B $26
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$61,$6C,$69,$61,$73,$69,$6E,$67,$20,$28,$73,$61,$6D,$65,$20,$6D,$61,$70,$29
        DC.B $00
LBL_153:
        DC.B $25
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$6D,$75,$74,$61,$74,$65,$20,$76,$69,$61,$20,$62,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
LBL_154:
        DC.B $1E
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$76,$61,$6C,$75,$65,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
        DC.B $00
LBL_155:
        DC.B $21
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$20,$62,$20,$74,$6F,$20,$61,$20,$66,$72,$65,$73,$68,$20,$6C,$69,$73,$74
LBL_156:
        DC.B $27
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$69,$6E,$67,$20,$62,$20,$6C,$65,$61,$76,$65,$73,$20,$61,$20,$75,$6E,$74,$6F,$75,$63,$68,$65,$64
LBL_157:
        DC.B $0A
        DC.B $68,$65,$6C,$6C,$6F,$20,$66,$69,$6C,$65
        DC.B $00
LBL_158:
        DC.B $0D
        DC.B $73,$6D,$6F,$6B,$65,$66,$69,$6C,$65,$2E,$74,$78,$74
LBL_159:
        DC.B $04
        DC.B $54,$45,$58,$54
        DC.B $00
LBL_160:
        DC.B $04
        DC.B $3F,$3F,$3F,$3F
        DC.B $00
LBL_161:
        DC.B $11
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$6F,$6B
LBL_162:
        DC.B $10
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6F,$6B
        DC.B $00
LBL_163:
        DC.B $1D
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
LBL_59:
        DC.B $00
        DC.B $00
LBL_164:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$6E,$2E,$64,$61,$74
        DC.B $00
LBL_165:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
        DC.B $00
LBL_166:
        DC.B $17
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
LBL_167:
        DC.B $1B
        DC.B $66,$69,$6C,$65,$20,$62,$69,$6E,$61,$72,$79,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70,$20,$62,$79,$74,$65,$73
LBL_168:
        DC.B $09
        DC.B $61,$2F,$62,$2F,$63,$2E,$74,$78,$74
LBL_169:
        DC.B $05
        DC.B $63,$2E,$74,$78,$74
LBL_170:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$62,$61,$73,$65,$6E,$61,$6D,$65
        DC.B $00
LBL_171:
        DC.B $08
        DC.B $73,$6F,$6C,$6F,$2E,$74,$78,$74
        DC.B $00
LBL_172:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$6E,$6F,$2D,$73,$6C,$61,$73,$68
        DC.B $00
LBL_173:
        DC.B $04
        DC.B $64,$69,$72,$2F
        DC.B $00
LBL_174:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$74,$72,$61,$69,$6C,$69,$6E,$67,$20,$73,$6C,$61,$73,$68
        DC.B $00
LBL_175:
        DC.B $09
        DC.B $78,$2F,$79,$2F,$7A,$2E,$74,$78,$74
LBL_176:
        DC.B $05
        DC.B $7A,$2E,$74,$78,$74
LBL_177:
        DC.B $14
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$76,$69,$61,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_178:
        DC.B $18
        DC.B $73,$6D,$6F,$6B,$65,$2D,$64,$6F,$65,$73,$2D,$6E,$6F,$74,$2D,$65,$78,$69,$73,$74,$2E,$74,$78,$74
        DC.B $00
LBL_179:
        DC.B $23
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$72,$65,$74,$75,$72,$6E,$73,$20,$66,$61,$6C,$73,$65
LBL_180:
        DC.B $24
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$63,$6F,$64,$65
        DC.B $00
LBL_181:
        DC.B $27
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$6D,$65,$73,$73,$61,$67,$65
LBL_182:
        DC.B $25
        DC.B $65,$72,$72,$6F,$72,$20,$6C,$6F,$63,$61,$6C,$20,$63,$6F,$70,$79,$20,$28,$65,$20,$3D,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$29,$20,$63,$6F,$64,$65
LBL_183:
        DC.B $28
        DC.B $65,$72,$72,$6F,$72,$20,$6C,$6F,$63,$61,$6C,$20,$63,$6F,$70,$79,$20,$28,$65,$20,$3D,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$29,$20,$6D,$65,$73,$73,$61,$67,$65
        DC.B $00
LBL_184:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$67,$2E,$64,$61,$74
        DC.B $00
LBL_185:
        DC.B $16
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
        DC.B $00
LBL_186:
        DC.B $15
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
LBL_187:
        DC.B $22
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
        DC.B $00
LBL_188:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_189:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$79
        DC.B $00
LBL_190:
        DC.B $11
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_191:
        DC.B $17
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
LBL_192:
        DC.B $18
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_193:
        DC.B $1B
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_194:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_195:
        DC.B $0B
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$78
LBL_196:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
        DC.B $00
LBL_197:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$73,$74,$72
        DC.B $00
LBL_198:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$78
LBL_199:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$78
LBL_200:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_201:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_202:
        DC.B $17
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
LBL_203:
        DC.B $13
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$66,$69,$65,$6C,$64
LBL_204:
        DC.B $15
        DC.B $72,$65,$63,$6F,$72,$64,$20,$70,$61,$72,$61,$6D,$20,$62,$79,$20,$76,$61,$6C,$75,$65
LBL_205:
        DC.B $14
        DC.B $65,$6E,$75,$6D,$20,$69,$6E,$74,$2D,$3E,$65,$6E,$75,$6D,$20,$76,$61,$6C,$69,$64
        DC.B $00
LBL_206:
        DC.B $18
        DC.B $65,$6E,$75,$6D,$20,$65,$6E,$75,$6D,$2D,$3E,$69,$6E,$74,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70
        DC.B $00
LBL_207:
        DC.B $06
        DC.B $61,$62,$63,$64,$65,$66
        DC.B $00
LBL_208:
        DC.B $03
        DC.B $61,$62,$63
LBL_209:
        DC.B $1C
        DC.B $73,$74,$72,$69,$6E,$67,$28,$33,$29,$2D,$72,$65,$74,$75,$72,$6E,$20,$41,$42,$49,$20,$70,$61,$74,$68,$20,$6F,$6B
        DC.B $00
LBL_210:
        DC.B $0A
        DC.B $73,$6D,$6F,$6B,$65,$20,$64,$6F,$6E,$65
        DC.B $00
LBL_211:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_212:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_213:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_214:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_215:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_216:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
LBL_220:
        DC.L $00000005
        DC.L $00000006
        DC.L $00000007
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_219:
        DC.B $00
        DC.B $00
