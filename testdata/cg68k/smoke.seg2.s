        ; func rtConnDevClose  (JT slot 175)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_0:
        LINK A6,#-2246
        MOVEQ #0,D0
        MOVE.B D0,-50(A6)
        MOVEQ #0,D0
        MOVE.B D0,-49(A6)
        MOVEQ #0,D0
        MOVE.B D0,-48(A6)
        MOVEQ #0,D0
        MOVE.B D0,-47(A6)
        MOVEQ #0,D0
        MOVE.B D0,-46(A6)
        MOVEQ #0,D0
        MOVE.B D0,-45(A6)
        MOVEQ #0,D0
        MOVE.B D0,-44(A6)
        MOVEQ #0,D0
        MOVE.B D0,-43(A6)
        MOVEQ #0,D0
        MOVE.B D0,-42(A6)
        MOVEQ #0,D0
        MOVE.B D0,-41(A6)
        MOVEQ #0,D0
        MOVE.B D0,-40(A6)
        MOVEQ #0,D0
        MOVE.B D0,-39(A6)
        MOVEQ #0,D0
        MOVE.B D0,-38(A6)
        MOVEQ #0,D0
        MOVE.B D0,-37(A6)
        MOVEQ #0,D0
        MOVE.B D0,-36(A6)
        MOVEQ #0,D0
        MOVE.B D0,-35(A6)
        MOVEQ #0,D0
        MOVE.B D0,-34(A6)
        MOVEQ #0,D0
        MOVE.B D0,-33(A6)
        MOVEQ #0,D0
        MOVE.B D0,-32(A6)
        MOVEQ #0,D0
        MOVE.B D0,-31(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
        MOVEQ #0,D0
        MOVE.B D0,-29(A6)
        MOVEQ #0,D0
        MOVE.B D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-27(A6)
        MOVEQ #0,D0
        MOVE.B D0,-26(A6)
        MOVEQ #0,D0
        MOVE.B D0,-25(A6)
        MOVEQ #0,D0
        MOVE.B D0,-24(A6)
        MOVEQ #0,D0
        MOVE.B D0,-23(A6)
        MOVEQ #0,D0
        MOVE.B D0,-22(A6)
        MOVEQ #0,D0
        MOVE.B D0,-21(A6)
        MOVEQ #0,D0
        MOVE.B D0,-20(A6)
        MOVEQ #0,D0
        MOVE.B D0,-19(A6)
        MOVEQ #0,D0
        MOVE.B D0,-18(A6)
        MOVEQ #0,D0
        MOVE.B D0,-17(A6)
        MOVEQ #0,D0
        MOVE.B D0,-16(A6)
        MOVEQ #0,D0
        MOVE.B D0,-15(A6)
        MOVEQ #0,D0
        MOVE.B D0,-14(A6)
        MOVEQ #0,D0
        MOVE.B D0,-13(A6)
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
        MOVEQ #0,D0
        MOVE.B D0,-11(A6)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEQ #0,D0
        MOVE.B D0,-9(A6)
        MOVEQ #0,D0
        MOVE.B D0,-8(A6)
        MOVEQ #0,D0
        MOVE.B D0,-7(A6)
        MOVEQ #0,D0
        MOVE.B D0,-6(A6)
        MOVEQ #0,D0
        MOVE.B D0,-5(A6)
        MOVEQ #0,D0
        MOVE.B D0,-4(A6)
        MOVEQ #0,D0
        MOVE.B D0,-3(A6)
        MOVEQ #0,D0
        MOVE.B D0,-2(A6)
        MOVEQ #0,D0
        MOVE.B D0,-1(A6)
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -1264(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_223
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
LBL_227:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 176)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local v2 : -22(A6)  size 4
LBL_1:
        LINK A6,#-2218
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
        BEQ.W LBL_229
        MOVEQ #0,D1
        MOVE.L -22(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_229:
        MOVEQ #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_230
        MOVE.L -1280(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_231
LBL_230:
LBL_232:
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_233
        MOVE.L -22(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_225
        MOVE.L D0,-10(A6)
        MOVE.L -1280(A5),D1
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
        BSR.W LBL_224
        MOVE.L D0,-22(A6)
        MOVE.L -6(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_232
LBL_233:
LBL_231:
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_234
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_234:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_235:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_236
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L 8(A6),D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1280(A5),D1
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
        BRA.W LBL_235
LBL_236:
        MOVE.L -14(A6),D0
        BRA.W LBL_228
LBL_228:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 177)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_2:
        LINK A6,#-2196
        MOVE.L -1292(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_238
        BRA.W LBL_237
LBL_238:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_239
        BRA.W LBL_237
LBL_239:
        MOVE.L -1272(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1292(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1272(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_237:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 178)
LBL_3:
        LINK A6,#-2196
        MOVE.L -1272(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1272(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -1272(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1272(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_240:
        UNLK A6
        RTS
        ; func natInit  (JT slot 179)
LBL_4:
        LINK A6,#-2196
        CLR.L D0
        MOVE.B -1294(A5),D0
        TST.L D0
        BEQ.W LBL_242
        BRA.W LBL_241
LBL_242:
        MOVEQ #1,D0
        MOVE.B D0,-1294(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1272(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1276(A5)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1280(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1284(A5)
        MOVEQ #0,D0
        MOVE.L D0,-1288(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1304(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1308(A5)
        MOVE.L -1272(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1272(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1272(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1272(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1272(A5),D1
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
        MOVE.L -1272(A5),D1
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
        MOVE.L -1272(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
        MOVE.L -1272(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1272(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -1272(A5),D1
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
        BEQ.W LBL_243
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-1292(A5)
        BRA.W LBL_241
LBL_243:
        MOVE.L -1272(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-1292(A5)
        MOVE.L -1272(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1292(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1272(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1272(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_241:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 180)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_5:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        BSR.W LBL_3
LBL_244:
        UNLK A6
        RTS
        ; func natLog  (JT slot 181)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_6:
        LINK A6,#-2204
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_246:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_248
        MOVE.L -1288(A5),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_249
LBL_248:
        MOVEQ #0,D0
LBL_249:
        TST.L D0
        BEQ.W LBL_247
        MOVE.L -1284(A5),D1
        MOVE.L -1288(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1276(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1288(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-1288(A5)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_246
LBL_247:
LBL_245:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 182)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_7:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -1296(A5),D0
        TST.L D0
        BEQ.W LBL_251
        BRA.W LBL_250
LBL_251:
        MOVEQ #1,D0
        MOVE.B D0,-1296(A5)
        BSR.W LBL_4
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -1276(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        MOVE.L -1284(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1288(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        MOVE.L -1292(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_252
        MOVE.L -1272(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -1292(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1272(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_252:
        BSR.W LBL_3
        DC.W $A9F4  ; NatExitToShell
LBL_250:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 183)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_8:
        LINK A6,#-2460
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_254:
        CLR.W (A0)+
        DBRA D0,LBL_254
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_63(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        BSR.W LBL_4
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-260(A6)
        MOVE.L -1304(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -260(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
LBL_255:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_256
        MOVE.L -1304(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -264(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -264(A6),D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_255
LBL_256:
        MOVE.L -1304(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDQ.L #4,A7
        MOVE.L -1304(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B -1580(A5),D0
        TST.L D0
        BEQ.W LBL_257
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
        BRA.W LBL_258
LBL_257:
        MOVEQ #0,D0
LBL_258:
        TST.L D0
        BEQ.W LBL_259
        MOVEQ #30,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; NatSysBeep
        MOVE.L -1304(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1308(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -1308(A5),D0
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
LBL_259:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
LBL_253:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 184)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_9:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-1312(A5)
        LEA -1568(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_260:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 185)
LBL_10:
        LINK A6,#-2196
        MOVE.L -1312(A5),D0
        BRA.W LBL_261
LBL_261:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 186)
        ;   hidden result ptr : 8(A6)  size 4
LBL_11:
        LINK A6,#-2196
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -1568(A5),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_262
LBL_262:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 187)
        ;   local __ret4 : -4(A6)  size 4
LBL_12:
        LINK A6,#-2200
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2156(A6)
LBL_264:
        MOVE.L A1,-(A7)
        MOVE.L -2156(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -1300(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_263
LBL_263:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 188)
LBL_13:
        LINK A6,#-2196
        CLR.L D0
        MOVE.B -1574(A5),D0
        TST.L D0
        BEQ.W LBL_266
        BRA.W LBL_265
LBL_266:
        MOVEQ #1,D0
        MOVE.B D0,-1574(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1572(A5)
LBL_265:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 189)
LBL_14:
        LINK A6,#-2196
        MOVE.L -1572(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_267:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 190)
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
LBL_15:
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
        BEQ.W LBL_269
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_64(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_268
LBL_269:
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
        BEQ.W LBL_270
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_65(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_268
LBL_270:
        BSR.W LBL_13
        MOVE.L -1572(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_271
        MOVE.L -1572(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_271:
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_272
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_268
LBL_272:
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D0
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
        BEQ.W LBL_273
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
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -1572(A5),D1
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
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_274
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_274:
LBL_273:
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_14
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_275
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_276
LBL_275:
        MOVEQ #1,D0
LBL_276:
        TST.L D0
        BEQ.W LBL_277
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_61(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_268
LBL_277:
        MOVEQ #1,D0
        BRA.W LBL_268
LBL_268:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 191)
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
LBL_16:
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
        BSR.W LBL_13
        MOVE.L -1572(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_279
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_278
LBL_279:
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_280
        LEA LBL_60(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_280:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_281:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_282
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -1572(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_283
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_284
LBL_283:
        MOVEQ #0,D0
LBL_284:
        TST.L D0
        BEQ.W LBL_285
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
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
        BRA.W LBL_278
LBL_285:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_286
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
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
LBL_286:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_287
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_288
LBL_287:
        MOVEQ #1,D0
LBL_288:
        TST.L D0
        BEQ.W LBL_289
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_289:
        BRA.W LBL_281
LBL_282:
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
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
        BRA.W LBL_278
LBL_278:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 192)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_17:
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
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_291:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_292
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
        BEQ.W LBL_293
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_293:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_291
LBL_292:
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
LBL_294:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_295
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
        BRA.W LBL_294
LBL_295:
LBL_290:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 193)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_18:
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
        BEQ.W LBL_297
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_67(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_296
LBL_297:
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
        JSR 130(A5)
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
        BEQ.W LBL_298
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
LBL_298:
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
        BRA.W LBL_296
LBL_296:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 194)
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
LBL_19:
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
        BEQ.W LBL_300
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_64(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_299
LBL_300:
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
        BEQ.W LBL_301
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_65(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_299
LBL_301:
        BSR.W LBL_13
        MOVE.L -1572(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_302
        MOVE.L -1572(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_302:
        MOVE.L -1572(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00A  ; NatOpenRF
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_303
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_299
LBL_303:
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D0
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
        BEQ.W LBL_304
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
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1572(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -1572(A5),D1
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
        MOVE.L -1572(A5),D1
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
        BEQ.W LBL_305
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_305:
LBL_304:
        MOVE.L -1572(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -1572(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_14
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_306
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_307
LBL_306:
        MOVEQ #1,D0
LBL_307:
        TST.L D0
        BEQ.W LBL_308
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_61(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_299
LBL_308:
        MOVEQ #1,D0
        BRA.W LBL_299
LBL_299:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 195)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_20:
        LINK A6,#-2196
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_310
        MOVEQ #1,D0
        BRA.W LBL_309
LBL_310:
        MOVEQ #0,D0
        BRA.W LBL_309
LBL_309:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 196)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_21:
        LINK A6,#-2196
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_312
        MOVEQ #1,D0
        BRA.W LBL_311
LBL_312:
        MOVEQ #0,D0
        BRA.W LBL_311
LBL_311:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 197)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_22:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_4
        MOVE.L -1578(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1578(A5)
LBL_314:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1578(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -1578(A5),D1
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
        MOVE.L -1578(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        BSR.W LBL_3
LBL_313:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 198)
        ;   param code : 8(A6)  size 4
LBL_23:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
LBL_315:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 199)
LBL_24:
        LINK A6,#-2196
        CLR.L D0
        MOVE.B -1580(A5),D0
        TST.L D0
        BEQ.W LBL_317
        BRA.W LBL_316
LBL_317:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-1584(A5)
        MOVE.L -1584(A5),D1
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
        MOVE.B D0,-1580(A5)
        DC.W $A850  ; NatInitCursor
LBL_316:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 200)
        ;   param out : 8(A6)  size 4
LBL_25:
        LINK A6,#-2196
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1584(A5),D1
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
        MOVE.L -1584(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_318:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 201)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_26:
        LINK A6,#-2200
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1584(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -1584(A5),D1
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
        BEQ.W LBL_320
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_320:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -1584(A5),D1
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
        MOVE.L -1584(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_319:
        UNLK A6
        RTS
        ; func nat_UiConnPump  (JT slot 202)
LBL_27:
        LINK A6,#-2196
        JSR 1386(A5)
LBL_321:
        UNLK A6
        RTS
        ; func smokeCheck  (JT slot 203)
        ;   param cond : 12(A6)  size 2
        ;   param label : 8(A6)  size 4
        ;   local msg : -256(A6)  size 256
LBL_28:
        LINK A6,#-2452
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_323:
        CLR.W (A0)+
        DBRA D0,LBL_323
        CLR.L D0
        MOVE.B 12(A6),D0
        TST.L D0
        BEQ.W LBL_324
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_68(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        BRA.W LBL_325
LBL_324:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_69(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
LBL_325:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #4,A7
LBL_322:
        UNLK A6
        RTS
        ; func smokeMakePoint  (JT slot 204)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -48(A6)  size 48
        ;   local __store2 : -96(A6)  size 48
        ;   local __ret5 : -144(A6)  size 48
LBL_29:
        LINK A6,#-2340
        MOVEQ #3,D0
        MOVE.L D0,-48(A6)
        MOVEQ #4,D0
        MOVE.L D0,-44(A6)
        MOVEQ #5,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_327:
        CLR.W (A0)+
        DBRA D0,LBL_327
        LEA -96(A6),A0
        MOVE.W #23,D0
LBL_328:
        CLR.W (A0)+
        DBRA D0,LBL_328
        MOVEQ #3,D0
        MOVE.L D0,-144(A6)
        MOVEQ #4,D0
        MOVE.L D0,-140(A6)
        MOVEQ #5,D0
        MOVE.L D0,-136(A6)
        MOVEQ #0,D0
        MOVE.L D0,-132(A6)
        LEA -128(A6),A0
        MOVE.W #15,D0
LBL_329:
        CLR.W (A0)+
        DBRA D0,LBL_329
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #3,D0
        MOVE.L D0,0(A0)
        MOVEA.L A1,A0
        MOVEQ #4,D0
        MOVE.L D0,4(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.L D0,8(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,12(A0)
        MOVEA.L A1,A0
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_330:
        CLR.W (A0)+
        DBRA D0,LBL_330
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_331:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_331
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
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_332:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_332
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_333:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_333
        BRA.W LBL_326
LBL_326:
        UNLK A6
        RTS
        ; func smokeTakePoint  (JT slot 205)
        ;   param p : 8(A6)  size 4
LBL_30:
        LINK A6,#-2196
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
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_334
LBL_334:
        UNLK A6
        RTS
        ; func smokeListInt  (JT slot 206)
        ;   local l : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local x : -16(A6)  size 4
LBL_31:
        LINK A6,#-2212
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 250(A5)
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
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #20,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #30,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_70(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 322(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_71(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 330(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_72(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_336
        BRA.W LBL_337
LBL_336:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_337:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVEQ #25,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_338
        BRA.W LBL_339
LBL_338:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_339:
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
        BCC.W LBL_340
        BRA.W LBL_341
LBL_340:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_341:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 314(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_342
        BRA.W LBL_343
LBL_342:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_343:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_76(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 306(A5)
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_78(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
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
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_79(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_80(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_81(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_344
        BRA.W LBL_345
LBL_344:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_345:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #100,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #200,D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_346:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_348
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        LEA -16(A6),A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.L -8(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_347:
        ADDQ.L #1,(A7)
        BRA.W LBL_346
LBL_348:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 298(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_84(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2168(A6)
LBL_349:
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_335:
        UNLK A6
        RTS
        ; func smokeListText  (JT slot 207)
        ;   local l : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local __store3 : -12(A6)  size 4
        ;   local __store4 : -16(A6)  size 4
LBL_32:
        LINK A6,#-2212
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
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
        JSR 138(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_86(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 322(A5)
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_89(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 330(A5)
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_351
        BRA.W LBL_352
LBL_351:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_352:
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
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #1,D0
        MOVE.L D0,-24(A6)
        JSR 138(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_92(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_353
        BRA.W LBL_354
LBL_353:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_354:
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_355
        BRA.W LBL_356
LBL_355:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_356:
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
        BCC.W LBL_357
        BRA.W LBL_358
LBL_357:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_358:
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
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_93(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 306(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 298(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_96(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_97(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D1
        MOVE.L -24(A6),D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_359
        BRA.W LBL_360
LBL_359:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_360:
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_98(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_99(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_100(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-20(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 298(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_101(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_361
        BRA.W LBL_362
LBL_361:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_362:
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
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2168(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 274(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_363
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2172(A6)
        CLR.L -2176(A6)
LBL_364:
        MOVE.L -2176(A6),D0
        MOVE.L -2172(A6),D1
        CMP.L D1,D0
        BGE.W LBL_363
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2176(A6),D0
        MOVE.L D0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2176(A6)
        BRA.W LBL_364
LBL_363:
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_350:
        UNLK A6
        RTS
        ; func smokeMapInt  (JT slot 208)
        ;   local m : -4(A6)  size 4
        ;   local sum : -8(A6)  size 4
        ;   local k : -264(A6)  size 256
        ;   local v : -268(A6)  size 4
LBL_33:
        LINK A6,#-2464
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
        MOVE.W #127,D0
LBL_366:
        CLR.W (A0)+
        DBRA D0,LBL_366
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
        BSR.W LBL_28
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
LBL_367:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_369
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
LBL_368:
        ADDQ.L #1,(A7)
        BRA.W LBL_367
LBL_369:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2420(A6)
LBL_370:
        MOVE.L A1,-(A7)
        MOVE.L -2420(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_365:
        UNLK A6
        RTS
        ; func smokeMapText  (JT slot 209)
        ;   local m : -4(A6)  size 4
        ;   local k : -260(A6)  size 256
        ;   local v : -264(A6)  size 4
        ;   local found : -268(A6)  size 4
LBL_34:
        LINK A6,#-2464
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 522(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        MOVE.W #127,D0
LBL_372:
        CLR.W (A0)+
        DBRA D0,LBL_372
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
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
        BEQ.W LBL_373
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_373:
        JSR 138(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
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
        BEQ.W LBL_374
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_374:
        JSR 138(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
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
        BSR.W LBL_28
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
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_124(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_125(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        JSR 138(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
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
        BEQ.W LBL_375
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_375:
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-272(A6)
        LEA LBL_119(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-276(A6)
        JSR 138(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
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
        BEQ.W LBL_376
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -280(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_376:
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -288(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        BEQ.W LBL_377
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_377:
        JSR 138(A5)
        MOVE.L D0,-284(A6)
        MOVE.L -284(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
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
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -276(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        BEQ.W LBL_378
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_378:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_379:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_381
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
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -264(A6),D0
        MOVE.L D0,-268(A6)
LBL_380:
        ADDQ.L #1,(A7)
        BRA.W LBL_379
LBL_381:
        ADDA.W #12,A7
        MOVE.L -268(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2420(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2420(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_382
        MOVE.L A1,-(A7)
        MOVE.L -2420(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2424(A6)
        CLR.L -2428(A6)
LBL_383:
        MOVE.L -2428(A6),D0
        MOVE.L -2424(A6),D1
        CMP.L D1,D0
        BGE.W LBL_382
        MOVE.L A1,-(A7)
        MOVE.L -2420(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2428(A6),D0
        MOVE.L D0,-(A7)
        LEA -2432(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2432(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2428(A6)
        BRA.W LBL_383
LBL_382:
        MOVE.L A1,-(A7)
        MOVE.L -2420(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -268(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_371:
        UNLK A6
        RTS
        ; func smokeTextOps  (JT slot 210)
        ;   local t : -4(A6)  size 4
        ;   local __store5 : -8(A6)  size 4
        ;   local u : -12(A6)  size 4
        ;   local __store6 : -16(A6)  size 4
LBL_35:
        LINK A6,#-2212
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -16(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 138(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-8(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #33,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 138(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        CLR.L -(A7)
        JSR 170(A5)
        ADDA.W #16,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_141(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_142(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_143(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_146(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_384:
        UNLK A6
        RTS
        ; func smokeNested  (JT slot 211)
        ;   local lm : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local got : -12(A6)  size 4
        ;   local __store7 : -16(A6)  size 4
LBL_36:
        LINK A6,#-2212
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 250(A5)
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
        BEQ.W LBL_386
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_386:
        JSR 138(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
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
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_149(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -16(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2168(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_387
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2172(A6)
        CLR.L -2176(A6)
LBL_388:
        MOVE.L -2176(A6),D0
        MOVE.L -2172(A6),D1
        CMP.L D1,D0
        BGE.W LBL_387
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2176(A6),D0
        MOVE.L D0,-(A7)
        LEA -2180(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2180(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2176(A6)
        BRA.W LBL_388
LBL_387:
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_389
        BRA.W LBL_390
LBL_389:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_390:
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
        MOVE.L D0,-2168(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_391
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2172(A6)
        CLR.L -2176(A6)
LBL_392:
        MOVE.L -2176(A6),D0
        MOVE.L -2172(A6),D1
        CMP.L D1,D0
        BGE.W LBL_391
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2176(A6),D0
        MOVE.L D0,-(A7)
        LEA -2180(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2180(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2176(A6)
        BRA.W LBL_392
LBL_391:
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
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
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        BEQ.W LBL_393
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_393:
        JSR 138(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_151(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
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
        BCC.W LBL_394
        BRA.W LBL_395
LBL_394:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_395:
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
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_151(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_152(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2168(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 274(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_396
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2172(A6)
        CLR.L -2176(A6)
LBL_397:
        MOVE.L -2176(A6),D0
        MOVE.L -2172(A6),D1
        CMP.L D1,D0
        BGE.W LBL_396
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2176(A6),D0
        MOVE.L D0,-(A7)
        JSR 282(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2184(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2184(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_398
        MOVE.L A1,-(A7)
        MOVE.L -2184(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2188(A6)
        CLR.L -2192(A6)
LBL_399:
        MOVE.L -2192(A6),D0
        MOVE.L -2188(A6),D1
        CMP.L D1,D0
        BGE.W LBL_398
        MOVE.L A1,-(A7)
        MOVE.L -2184(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2192(A6),D0
        MOVE.L D0,-(A7)
        LEA -2196(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2196(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2192(A6)
        BRA.W LBL_399
LBL_398:
        MOVE.L A1,-(A7)
        MOVE.L -2184(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2176(A6)
        BRA.W LBL_397
LBL_396:
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2168(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_400
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2172(A6)
        CLR.L -2176(A6)
LBL_401:
        MOVE.L -2176(A6),D0
        MOVE.L -2172(A6),D1
        CMP.L D1,D0
        BGE.W LBL_400
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2176(A6),D0
        MOVE.L D0,-(A7)
        LEA -2180(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2180(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2176(A6)
        BRA.W LBL_401
LBL_400:
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2168(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_402
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 594(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2172(A6)
        CLR.L -2176(A6)
LBL_403:
        MOVE.L -2176(A6),D0
        MOVE.L -2172(A6),D1
        CMP.L D1,D0
        BGE.W LBL_402
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2176(A6),D0
        MOVE.L D0,-(A7)
        LEA -2180(A6),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2180(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2176(A6)
        BRA.W LBL_403
LBL_402:
        MOVE.L A1,-(A7)
        MOVE.L -2168(A6),D0
        MOVE.L D0,-(A7)
        JSR 538(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_385:
        UNLK A6
        RTS
        ; func smokeAliasing  (JT slot 212)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
        ;   local __store8 : -12(A6)  size 4
LBL_37:
        LINK A6,#-2208
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 250(A5)
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
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2164(A6)
LBL_405:
        MOVE.L A1,-(A7)
        MOVE.L -2164(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
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
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_153(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_406
        BRA.W LBL_407
LBL_406:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_217(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_407:
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2164(A6)
LBL_408:
        MOVE.L A1,-(A7)
        MOVE.L -2164(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_38
        MOVE.L D0,-16(A6)
        MOVE.L D0,-12(A6)
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2164(A6)
LBL_409:
        MOVE.L A1,-(A7)
        MOVE.L -2164(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2164(A6)
LBL_410:
        MOVE.L A1,-(A7)
        MOVE.L -2164(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2164(A6)
LBL_411:
        MOVE.L A1,-(A7)
        MOVE.L -2164(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_404:
        UNLK A6
        RTS
        ; func other  (JT slot 213)
        ;   local l : -4(A6)  size 4
        ;   local __ret6 : -8(A6)  size 4
LBL_38:
        LINK A6,#-2204
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #42,D0
        MOVE.L D0,-12(A6)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2160(A6)
LBL_413:
        MOVE.L A1,-(A7)
        MOVE.L -2160(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2160(A6)
LBL_414:
        MOVE.L A1,-(A7)
        MOVE.L -2160(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        BRA.W LBL_412
LBL_412:
        UNLK A6
        RTS
        ; func smokeClamp3  (JT slot 214)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param s : 12(A6)  size 4
LBL_39:
        LINK A6,#-2196
        MOVE.L 8(A6),-(A7)
        MOVE.L #3,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_415
LBL_415:
        UNLK A6
        RTS
        ; func smokeFileNameOf  (JT slot 215)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param p : 12(A6)  size 4
LBL_40:
        LINK A6,#-2196
        MOVE.L 8(A6),-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        BRA.W LBL_416
LBL_416:
        UNLK A6
        RTS
        ; func smokeFiles  (JT slot 216)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local n : -268(A6)  size 256
        ;   local errMsg : -524(A6)  size 256
        ;   local e : -784(A6)  size 260
        ;   local __store9 : -788(A6)  size 4
        ;   local __store10 : -792(A6)  size 4
LBL_41:
        LINK A6,#-2988
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
        LEA -268(A6),A0
        MOVE.W #127,D0
LBL_418:
        CLR.W (A0)+
        DBRA D0,LBL_418
        LEA -524(A6),A0
        MOVE.W #127,D0
LBL_419:
        CLR.W (A0)+
        DBRA D0,LBL_419
        MOVEQ #0,D0
        MOVE.L D0,-784(A6)
        LEA -780(A6),A0
        MOVE.W #127,D0
LBL_420:
        CLR.W (A0)+
        DBRA D0,LBL_420
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 138(A5)
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-788(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        BSR.W LBL_15
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_161(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA LBL_158(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_162(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,-(A7)
        JSR 186(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_163(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -792(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 138(A5)
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_59(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-792(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
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
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #13,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #66,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_15
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_165(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_166(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVEQ #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_421:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #65,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_422
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_422:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_423
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_423:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #13,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_424:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_425:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #66,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_426:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_168(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_170(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_172(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_173(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_17
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_59(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_174(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA LBL_175(PC),A0
        MOVE.L A0,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_176(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_177(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA LBL_178(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_179(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        BSR.W LBL_10
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_180(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_181(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -784(A6),A0
        MOVEA.L A0,A1
        BSR.W LBL_10
        MOVE.L D0,0(A1)
        LEA 4(A1),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -784(A6),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_66(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_183(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_417:
        UNLK A6
        RTS
        ; func smokeFilesBig  (JT slot 217)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local i : -16(A6)  size 4
        ;   local n : -20(A6)  size 4
        ;   local __store11 : -24(A6)  size 4
LBL_42:
        LINK A6,#-2220
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
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
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 138(A5)
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_59(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -28(A6),D0
        MOVE.L D0,-24(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_428:
        MOVE.L -16(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_225
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_428
LBL_429:
        LEA LBL_184(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_160(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_15
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_185(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA LBL_184(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_16
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_186(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVEQ #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_430:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_431:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
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
        BEQ.W LBL_432
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_432:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
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
        BEQ.W LBL_433
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_433:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
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
        BEQ.W LBL_434
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_434:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_187(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_427:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 218)
        ;   local p : -48(A6)  size 48
        ;   local __store12 : -96(A6)  size 48
        ;   local q : -144(A6)  size 48
        ;   local e : -148(A6)  size 4
        ;   local n : -152(A6)  size 4
        ;   local __store13 : -200(A6)  size 48
        ;   local __store14 : -248(A6)  size 48
LBL_43:
        LINK A6,#-2444
        MOVEQ #3,D0
        MOVE.L D0,-48(A6)
        MOVEQ #4,D0
        MOVE.L D0,-44(A6)
        MOVEQ #5,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_436:
        CLR.W (A0)+
        DBRA D0,LBL_436
        LEA -96(A6),A0
        MOVE.W #23,D0
LBL_437:
        CLR.W (A0)+
        DBRA D0,LBL_437
        MOVEQ #3,D0
        MOVE.L D0,-144(A6)
        MOVEQ #4,D0
        MOVE.L D0,-140(A6)
        MOVEQ #5,D0
        MOVE.L D0,-136(A6)
        MOVEQ #0,D0
        MOVE.L D0,-132(A6)
        LEA -128(A6),A0
        MOVE.W #15,D0
LBL_438:
        CLR.W (A0)+
        DBRA D0,LBL_438
        MOVEQ #0,D0
        MOVE.L D0,-148(A6)
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        LEA -200(A6),A0
        MOVE.W #23,D0
LBL_439:
        CLR.W (A0)+
        DBRA D0,LBL_439
        LEA -248(A6),A0
        MOVE.W #23,D0
LBL_440:
        CLR.W (A0)+
        DBRA D0,LBL_440
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #3,D0
        MOVE.L D0,0(A0)
        MOVEA.L A1,A0
        MOVEQ #4,D0
        MOVE.L D0,4(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.L D0,8(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,12(A0)
        MOVEA.L A1,A0
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_441:
        CLR.W (A0)+
        DBRA D0,LBL_441
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_442:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_442
        LEA -48(A6),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_190(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -144(A6),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -144(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_193(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
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
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_195(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_194(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_197(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -200(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_443:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_443
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_221
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -200(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_444:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_444
        MOVEQ #99,D0
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
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_198(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -144(A6),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -144(A6),A0
        LEA 12(A0),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -248(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDQ.L #8,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_445:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_445
        LEA -48(A6),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_30
        ADDQ.L #4,A7
        MOVE.L D0,-152(A6)
        MOVE.L -152(A6),D0
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
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVEQ #6,D0
        MOVE.L D0,D1
        LEA LBL_220(PC),A0
        MOVE.W #2,D2
LBL_447:
        CMP.L (A0)+,D1
        BEQ.W LBL_446
        DBRA D2,LBL_447
        ; enum conversion miss -> rtEnumCheck(v, false, <name arg unused>) panics
        MOVE.L D1,-(A7)
        CLR.W -(A7)
        ADDA.L #-256,A7
        JSR 82(A5)
        ADDA.W #262,A7
LBL_446:
        MOVE.L D0,-148(A6)
        MOVE.L -148(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_205(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        MOVE.L -148(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_206(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        BSR.W LBL_31
        BSR.W LBL_32
        BSR.W LBL_33
        BSR.W LBL_34
        BSR.W LBL_35
        BSR.W LBL_36
        BSR.W LBL_37
        LEA LBL_207(PC),A0
        MOVE.L A0,-(A7)
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_208(PC),A0
        MOVE.L A0,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_209(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_28
        ADDQ.L #6,A7
        BSR.W LBL_41
        BSR.W LBL_42
        LEA LBL_210(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_226
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_222
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_435:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 219)
        ;   param slot : 8(A6)  size 4
LBL_44:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        BRA.W LBL_450
LBL_449:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_451
        BRA.W LBL_452
LBL_451:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_453
        BRA.W LBL_454
LBL_453:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_455
LBL_455:
LBL_454:
LBL_452:
LBL_450:
LBL_448:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 220)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_45:
        LINK A6,#-2196
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        BRA.W LBL_458
LBL_457:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        BRA.W LBL_460
LBL_459:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        BRA.W LBL_462
LBL_461:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
LBL_463:
LBL_462:
LBL_460:
LBL_458:
LBL_456:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 221)
        ;   param slot : 8(A6)  size 4
LBL_46:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        BRA.W LBL_466
LBL_465:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
        BRA.W LBL_468
LBL_467:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_469
        BRA.W LBL_470
LBL_469:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
LBL_471:
LBL_470:
LBL_468:
LBL_466:
LBL_464:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 222)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
        ;   local err : -260(A6)  size 260
LBL_47:
        LINK A6,#-2456
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_473:
        CLR.W (A0)+
        DBRA D0,LBL_473
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_474
        BRA.W LBL_475
LBL_474:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_476
        BRA.W LBL_477
LBL_476:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_478
        BRA.W LBL_479
LBL_478:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_480
LBL_480:
LBL_479:
LBL_477:
LBL_475:
LBL_472:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 223)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_48:
        LINK A6,#-2196
        LEA LBL_211(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
LBL_481:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 224)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_49:
        LINK A6,#-2196
        LEA LBL_212(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
LBL_482:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 225)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_50:
        LINK A6,#-2196
        LEA LBL_213(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
LBL_483:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 226)
        ;   param idx : 8(A6)  size 4
LBL_51:
        LINK A6,#-2196
        LEA LBL_214(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
LBL_484:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 227)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_52:
        LINK A6,#-2196
        LEA LBL_215(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
LBL_485:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 228)
        ;   param rowsIdx : 8(A6)  size 4
LBL_53:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #64,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_487
        LEA -1300(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_486
        BRA.W LBL_488
LBL_487:
        LEA LBL_216(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        BSR.W LBL_226
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_486
LBL_488:
LBL_486:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 229)
LBL_54:
        LINK A6,#-2196
LBL_489:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 230) -- pascal callback glue for aeQuitHandler
LBL_55:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 978(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 231) -- pascal callback glue for aeOappHandler
LBL_56:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 986(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 232) -- pascal callback glue for rtUiScrollbarAction
LBL_57:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1146(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 233) -- pascal callback glue for rtUiLdefDraw
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
        JSR 1202(A5)
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
        BNE.W LBL_490
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_490:
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
        BPL.W LBL_491
        NEG.L D2
        MOVE.L #1,D4
LBL_491:
        CLR.L D5
        TST.L D3
        BPL.W LBL_492
        NEG.L D3
        MOVE.L #1,D5
LBL_492:
        CLR.L D6
        MOVE.W #31,D7
LBL_493:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_494
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_494:
        DBRA D7,LBL_493
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_495
        NEG.L D2
LBL_495:
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
        BNE.W LBL_496
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_218(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_496:
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
        BPL.W LBL_497
        NEG.L D2
        MOVE.L #1,D4
LBL_497:
        CLR.L D5
        TST.L D3
        BPL.W LBL_498
        NEG.L D3
        MOVE.L #1,D5
LBL_498:
        CLR.L D6
        MOVE.W #31,D7
LBL_499:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_500
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_500:
        DBRA D7,LBL_499
        TST.L D4
        BEQ.W LBL_501
        NEG.L D6
LBL_501:
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
        LINK A6,#-48
        MOVE.L -1300(A5),D0
        MOVE.L D0,-4(A6)
LBL_502:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
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
LBL_63:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_64:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_65:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_66:
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
