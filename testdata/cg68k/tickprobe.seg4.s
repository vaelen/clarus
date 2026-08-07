        ; func rtUiHexLineText  (JT slot 328)
        ;   param src : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local b : -12(A6)  size 4
LBL_0:
        LINK A6,#-2140
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        JSR 114(A5)
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_180:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #64,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        JSR 2618(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        AND.L D1,D0
        MOVE.L D0,-(A7)
        JSR 2618(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_180
LBL_181:
        MOVE.L -4(A6),D0
        BRA.W LBL_179
LBL_179:
        UNLK A6
        RTS
        ; func rtUiTestSnap  (JT slot 329)
        ;   param namePtr : 8(A6)  size 4
        ;   local baseAddrSlot : -4(A6)  size 4
        ;   local rowBytesSlot : -8(A6)  size 4
        ;   local boundsSlot : -12(A6)  size 4
        ;   local baseAddr : -16(A6)  size 4
        ;   local rowBytes : -20(A6)  size 4
        ;   local rows : -24(A6)  size 4
        ;   local total : -28(A6)  size 4
        ;   local off : -32(A6)  size 4
        ;   local hdr : -36(A6)  size 4
LBL_1:
        LINK A6,#-2164
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #8,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #64,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
        LEA LBL_123(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_184:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_184
        JSR 50(A5)
        ADDA.W #256,A7
LBL_183:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L D0,-28(A6)
        JSR 114(A5)
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_124(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2474(A5)
        ADDQ.L #8,A7
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2282(A5)
        ADDQ.L #4,A7
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
LBL_185:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_186
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2282(A5)
        ADDQ.L #4,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #64,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_185
LBL_186:
        LEA LBL_125(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_187:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_187
        JSR 2626(A5)
        ADDA.W #256,A7
        MOVE.L D0,-(A7)
        JSR 2282(A5)
        ADDQ.L #4,A7
LBL_182:
        UNLK A6
        RTS
        ; func rtUiScriptDispatchLine  (JT slot 330)
LBL_2:
        LINK A6,#-2128
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_78(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_189
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.B D0,-(A7)
        JSR 2514(A5)
        ADDA.W #10,A7
        BRA.W LBL_190
LBL_189:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_191
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.B D0,-(A7)
        JSR 2514(A5)
        ADDA.W #10,A7
        BRA.W LBL_192
LBL_191:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_79(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_193
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2522(A5)
        ADDQ.L #8,A7
        BRA.W LBL_194
LBL_193:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_81(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_195
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2466(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2530(A5)
        ADDQ.L #4,A7
        BRA.W LBL_196
LBL_195:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_197
        JSR 2538(A5)
        BRA.W LBL_198
LBL_197:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_199
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2602(A5)
        ADDQ.L #8,A7
        BRA.W LBL_200
LBL_199:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_130(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_201
        JSR 2562(A5)
        BRA.W LBL_202
LBL_201:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_131(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_203
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -104(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2570(A5)
        ADDQ.L #8,A7
        BRA.W LBL_204
LBL_203:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_132(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_205
        JSR 2578(A5)
        BRA.W LBL_206
LBL_205:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_133(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_207
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2594(A5)
        ADDQ.L #4,A7
        BRA.W LBL_208
LBL_207:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_209
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
        BRA.W LBL_210
LBL_209:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_211
        JSR 1234(A5)
        BRA.W LBL_212
LBL_211:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_136(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_213
        BRA.W LBL_214
LBL_213:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_137(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_215
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L -100(A5),D0
        MOVE.L D0,-(A7)
        JSR 2458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2226(A5)
        ADDQ.L #8,A7
        BRA.W LBL_216
LBL_215:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_138(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_217
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L D0,-(A7)
        JSR 2546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2234(A5)
        ADDQ.L #8,A7
        BRA.W LBL_218
LBL_217:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_219
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L D0,-(A7)
        JSR 2546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2234(A5)
        ADDQ.L #8,A7
        BRA.W LBL_220
LBL_219:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_221
        JSR 2554(A5)
        BRA.W LBL_222
LBL_221:
        MOVE.L -96(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_141(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 2450(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_223
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 2226(A5)
        ADDQ.L #8,A7
        BRA.W LBL_224
LBL_223:
        MOVE.L -96(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_225
        BRA.W LBL_226
LBL_225:
        MOVE.L #0,D0
        BRA.W LBL_188
LBL_226:
LBL_224:
LBL_222:
LBL_220:
LBL_218:
LBL_216:
LBL_214:
LBL_212:
LBL_210:
LBL_208:
LBL_206:
LBL_204:
LBL_202:
LBL_200:
LBL_198:
LBL_196:
LBL_194:
LBL_192:
LBL_190:
        MOVE.L #1,D0
        BRA.W LBL_188
LBL_188:
        UNLK A6
        RTS
        ; func nat_UiSFGetFile  (JT slot 331)
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
LBL_3:
        LINK A6,#-2572
        MOVE.L #0,D0
        MOVE.B D0,-74(A6)
        MOVE.L #0,D0
        MOVE.B D0,-73(A6)
        MOVE.L #0,D0
        MOVE.B D0,-72(A6)
        MOVE.L #0,D0
        MOVE.B D0,-71(A6)
        MOVE.L #0,D0
        MOVE.B D0,-70(A6)
        MOVE.L #0,D0
        MOVE.B D0,-69(A6)
        MOVE.L #0,D0
        MOVE.B D0,-68(A6)
        MOVE.L #0,D0
        MOVE.B D0,-67(A6)
        MOVE.L #0,D0
        MOVE.B D0,-66(A6)
        MOVE.L #0,D0
        MOVE.B D0,-65(A6)
        MOVE.L #0,D0
        MOVE.B D0,-64(A6)
        MOVE.L #0,D0
        MOVE.B D0,-63(A6)
        MOVE.L #0,D0
        MOVE.B D0,-62(A6)
        MOVE.L #0,D0
        MOVE.B D0,-61(A6)
        MOVE.L #0,D0
        MOVE.B D0,-60(A6)
        MOVE.L #0,D0
        MOVE.B D0,-59(A6)
        MOVE.L #0,D0
        MOVE.B D0,-58(A6)
        MOVE.L #0,D0
        MOVE.B D0,-57(A6)
        MOVE.L #0,D0
        MOVE.B D0,-56(A6)
        MOVE.L #0,D0
        MOVE.B D0,-55(A6)
        MOVE.L #0,D0
        MOVE.B D0,-54(A6)
        MOVE.L #0,D0
        MOVE.B D0,-53(A6)
        MOVE.L #0,D0
        MOVE.B D0,-52(A6)
        MOVE.L #0,D0
        MOVE.B D0,-51(A6)
        MOVE.L #0,D0
        MOVE.B D0,-50(A6)
        MOVE.L #0,D0
        MOVE.B D0,-49(A6)
        MOVE.L #0,D0
        MOVE.B D0,-48(A6)
        MOVE.L #0,D0
        MOVE.B D0,-47(A6)
        MOVE.L #0,D0
        MOVE.B D0,-46(A6)
        MOVE.L #0,D0
        MOVE.B D0,-45(A6)
        MOVE.L #0,D0
        MOVE.B D0,-44(A6)
        MOVE.L #0,D0
        MOVE.B D0,-43(A6)
        MOVE.L #0,D0
        MOVE.B D0,-42(A6)
        MOVE.L #0,D0
        MOVE.B D0,-41(A6)
        MOVE.L #0,D0
        MOVE.B D0,-40(A6)
        MOVE.L #0,D0
        MOVE.B D0,-39(A6)
        MOVE.L #0,D0
        MOVE.B D0,-38(A6)
        MOVE.L #0,D0
        MOVE.B D0,-37(A6)
        MOVE.L #0,D0
        MOVE.B D0,-36(A6)
        MOVE.L #0,D0
        MOVE.B D0,-35(A6)
        MOVE.L #0,D0
        MOVE.B D0,-34(A6)
        MOVE.L #0,D0
        MOVE.B D0,-33(A6)
        MOVE.L #0,D0
        MOVE.B D0,-32(A6)
        MOVE.L #0,D0
        MOVE.B D0,-31(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L #0,D0
        MOVE.B D0,-29(A6)
        MOVE.L #0,D0
        MOVE.B D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-27(A6)
        MOVE.L #0,D0
        MOVE.B D0,-26(A6)
        MOVE.L #0,D0
        MOVE.B D0,-25(A6)
        MOVE.L #0,D0
        MOVE.B D0,-24(A6)
        MOVE.L #0,D0
        MOVE.B D0,-23(A6)
        MOVE.L #0,D0
        MOVE.B D0,-22(A6)
        MOVE.L #0,D0
        MOVE.B D0,-21(A6)
        MOVE.L #0,D0
        MOVE.B D0,-20(A6)
        MOVE.L #0,D0
        MOVE.B D0,-19(A6)
        MOVE.L #0,D0
        MOVE.B D0,-18(A6)
        MOVE.L #0,D0
        MOVE.B D0,-17(A6)
        MOVE.L #0,D0
        MOVE.B D0,-16(A6)
        MOVE.L #0,D0
        MOVE.B D0,-15(A6)
        MOVE.L #0,D0
        MOVE.B D0,-14(A6)
        MOVE.L #0,D0
        MOVE.B D0,-13(A6)
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
        MOVE.L #0,D0
        MOVE.B D0,-11(A6)
        MOVE.L #0,D0
        MOVE.B D0,-10(A6)
        MOVE.L #0,D0
        MOVE.B D0,-9(A6)
        MOVE.L #0,D0
        MOVE.B D0,-8(A6)
        MOVE.L #0,D0
        MOVE.B D0,-7(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L #0,D0
        MOVE.B D0,-5(A6)
        MOVE.L #0,D0
        MOVE.B D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-3(A6)
        MOVE.L #0,D0
        MOVE.B D0,-2(A6)
        MOVE.L #0,D0
        MOVE.B D0,-1(A6)
        MOVE.L #0,D0
        MOVE.B D0,-90(A6)
        MOVE.L #0,D0
        MOVE.B D0,-89(A6)
        MOVE.L #0,D0
        MOVE.B D0,-88(A6)
        MOVE.L #0,D0
        MOVE.B D0,-87(A6)
        MOVE.L #0,D0
        MOVE.B D0,-86(A6)
        MOVE.L #0,D0
        MOVE.B D0,-85(A6)
        MOVE.L #0,D0
        MOVE.B D0,-84(A6)
        MOVE.L #0,D0
        MOVE.B D0,-83(A6)
        MOVE.L #0,D0
        MOVE.B D0,-82(A6)
        MOVE.L #0,D0
        MOVE.B D0,-81(A6)
        MOVE.L #0,D0
        MOVE.B D0,-80(A6)
        MOVE.L #0,D0
        MOVE.B D0,-79(A6)
        MOVE.L #0,D0
        MOVE.B D0,-78(A6)
        MOVE.L #0,D0
        MOVE.B D0,-77(A6)
        MOVE.L #0,D0
        MOVE.B D0,-76(A6)
        MOVE.L #0,D0
        MOVE.B D0,-75(A6)
        MOVE.L #0,D0
        MOVE.B D0,-154(A6)
        MOVE.L #0,D0
        MOVE.B D0,-153(A6)
        MOVE.L #0,D0
        MOVE.B D0,-152(A6)
        MOVE.L #0,D0
        MOVE.B D0,-151(A6)
        MOVE.L #0,D0
        MOVE.B D0,-150(A6)
        MOVE.L #0,D0
        MOVE.B D0,-149(A6)
        MOVE.L #0,D0
        MOVE.B D0,-148(A6)
        MOVE.L #0,D0
        MOVE.B D0,-147(A6)
        MOVE.L #0,D0
        MOVE.B D0,-146(A6)
        MOVE.L #0,D0
        MOVE.B D0,-145(A6)
        MOVE.L #0,D0
        MOVE.B D0,-144(A6)
        MOVE.L #0,D0
        MOVE.B D0,-143(A6)
        MOVE.L #0,D0
        MOVE.B D0,-142(A6)
        MOVE.L #0,D0
        MOVE.B D0,-141(A6)
        MOVE.L #0,D0
        MOVE.B D0,-140(A6)
        MOVE.L #0,D0
        MOVE.B D0,-139(A6)
        MOVE.L #0,D0
        MOVE.B D0,-138(A6)
        MOVE.L #0,D0
        MOVE.B D0,-137(A6)
        MOVE.L #0,D0
        MOVE.B D0,-136(A6)
        MOVE.L #0,D0
        MOVE.B D0,-135(A6)
        MOVE.L #0,D0
        MOVE.B D0,-134(A6)
        MOVE.L #0,D0
        MOVE.B D0,-133(A6)
        MOVE.L #0,D0
        MOVE.B D0,-132(A6)
        MOVE.L #0,D0
        MOVE.B D0,-131(A6)
        MOVE.L #0,D0
        MOVE.B D0,-130(A6)
        MOVE.L #0,D0
        MOVE.B D0,-129(A6)
        MOVE.L #0,D0
        MOVE.B D0,-128(A6)
        MOVE.L #0,D0
        MOVE.B D0,-127(A6)
        MOVE.L #0,D0
        MOVE.B D0,-126(A6)
        MOVE.L #0,D0
        MOVE.B D0,-125(A6)
        MOVE.L #0,D0
        MOVE.B D0,-124(A6)
        MOVE.L #0,D0
        MOVE.B D0,-123(A6)
        MOVE.L #0,D0
        MOVE.B D0,-122(A6)
        MOVE.L #0,D0
        MOVE.B D0,-121(A6)
        MOVE.L #0,D0
        MOVE.B D0,-120(A6)
        MOVE.L #0,D0
        MOVE.B D0,-119(A6)
        MOVE.L #0,D0
        MOVE.B D0,-118(A6)
        MOVE.L #0,D0
        MOVE.B D0,-117(A6)
        MOVE.L #0,D0
        MOVE.B D0,-116(A6)
        MOVE.L #0,D0
        MOVE.B D0,-115(A6)
        MOVE.L #0,D0
        MOVE.B D0,-114(A6)
        MOVE.L #0,D0
        MOVE.B D0,-113(A6)
        MOVE.L #0,D0
        MOVE.B D0,-112(A6)
        MOVE.L #0,D0
        MOVE.B D0,-111(A6)
        MOVE.L #0,D0
        MOVE.B D0,-110(A6)
        MOVE.L #0,D0
        MOVE.B D0,-109(A6)
        MOVE.L #0,D0
        MOVE.B D0,-108(A6)
        MOVE.L #0,D0
        MOVE.B D0,-107(A6)
        MOVE.L #0,D0
        MOVE.B D0,-106(A6)
        MOVE.L #0,D0
        MOVE.B D0,-105(A6)
        MOVE.L #0,D0
        MOVE.B D0,-104(A6)
        MOVE.L #0,D0
        MOVE.B D0,-103(A6)
        MOVE.L #0,D0
        MOVE.B D0,-102(A6)
        MOVE.L #0,D0
        MOVE.B D0,-101(A6)
        MOVE.L #0,D0
        MOVE.B D0,-100(A6)
        MOVE.L #0,D0
        MOVE.B D0,-99(A6)
        MOVE.L #0,D0
        MOVE.B D0,-98(A6)
        MOVE.L #0,D0
        MOVE.B D0,-97(A6)
        MOVE.L #0,D0
        MOVE.B D0,-96(A6)
        MOVE.L #0,D0
        MOVE.B D0,-95(A6)
        MOVE.L #0,D0
        MOVE.B D0,-94(A6)
        MOVE.L #0,D0
        MOVE.B D0,-93(A6)
        MOVE.L #0,D0
        MOVE.B D0,-92(A6)
        MOVE.L #0,D0
        MOVE.B D0,-91(A6)
        LEA -410(A6),A0
        MOVE.W #127,D0
LBL_228:
        CLR.W (A0)+
        DBRA D0,LBL_228
        MOVE.L #0,D0
        MOVE.L D0,-414(A6)
        MOVE.L #0,D0
        MOVE.L D0,-418(A6)
        MOVE.L #0,D0
        MOVE.L D0,-422(A6)
        MOVE.L #0,D0
        MOVE.L D0,-426(A6)
        MOVE.L #0,D0
        MOVE.L D0,-430(A6)
        MOVE.L #0,D0
        MOVE.L D0,-434(A6)
        MOVE.L #0,D0
        MOVE.L D0,-438(A6)
        LEA -442(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.B D0,-444(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-418(A6)
        MOVE.L -418(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_229
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #42,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_230
LBL_229:
        MOVE.L #0,D0
LBL_230:
        TST.L D0
        BEQ.W LBL_231
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-422(A6)
        BRA.W LBL_232
LBL_231:
        MOVE.L #0,D0
        MOVE.L D0,-426(A6)
        MOVE.L #0,D0
        MOVE.L D0,-430(A6)
LBL_233:
        MOVE.L -430(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -418(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_234
        MOVE.L -430(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -418(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_235
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -430(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_236
LBL_235:
        MOVE.L #1,D0
LBL_236:
        TST.L D0
        BEQ.W LBL_237
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_238
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_142(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_239:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_239
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2528(A6)
LBL_240:
        MOVE.L A1,-(A7)
        MOVE.L -2528(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_227
LBL_238:
        MOVE.L -430(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -426(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-434(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -426(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -434(A6),D0
        MOVE.L D0,-(A7)
        JSR 58(A5)
        ADDA.W #12,A7
        MOVE.L D0,-438(A6)
        MOVE.L -438(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_241
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_143(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_242:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_242
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2528(A6)
LBL_243:
        MOVE.L A1,-(A7)
        MOVE.L -2528(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_227
LBL_241:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -438(A6),D0
        MOVE.L D0,-448(A6)
        LEA -448(A6),A0
        MOVE.L A0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVE.L -430(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-426(A6)
LBL_237:
        MOVE.L -430(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-430(A6)
        BRA.W LBL_233
LBL_234:
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-422(A6)
        MOVE.L -422(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_244
        LEA -90(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_245
        BRA.W LBL_246
LBL_245:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_247:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_247
        JSR 50(A5)
LBL_246:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_175
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_244:
        MOVE.L -422(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_248
        LEA -86(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_249
        BRA.W LBL_250
LBL_249:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_251:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_251
        JSR 50(A5)
LBL_250:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_175
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_248:
        MOVE.L -422(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_252
        LEA -82(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_253
        BRA.W LBL_254
LBL_253:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_255:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_255
        JSR 50(A5)
LBL_254:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_175
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_252:
        MOVE.L -422(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_256
        LEA -78(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -442(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_257
        BRA.W LBL_258
LBL_257:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_171(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_259:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_259
        JSR 50(A5)
LBL_258:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_175
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_256:
LBL_232:
        MOVE.L #100,D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #100,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        LEA LBL_144(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -422(A6),D0
        MOVE.W D0,-(A7)
        LEA -90(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
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
        BEQ.W LBL_260
        MOVE.L #0,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2528(A6)
LBL_261:
        MOVE.L A1,-(A7)
        MOVE.L -2528(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_227
LBL_260:
        LEA -136(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
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
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -410(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 1650(A5)
        ADDQ.L #8,A7
        MOVE.L #1,D0
        MOVE.B D0,-444(A6)
        LEA -442(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2528(A6)
LBL_262:
        MOVE.L A1,-(A7)
        MOVE.L -2528(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        CLR.L D0
        MOVE.B -444(A6),D0
        BRA.W LBL_227
LBL_227:
        UNLK A6
        RTS
        ; func nat_UiSFPutFile  (JT slot 332)
        ;   param suggested255 : 12(A6)  size 4
        ;   param path255Out : 8(A6)  size 4
        ;   local rep : -74(A6)  size 74
        ;   local vp : -138(A6)  size 64
        ;   local s : -394(A6)  size 256
        ;   local junk : -398(A6)  size 4
LBL_4:
        LINK A6,#-2526
        MOVE.L #0,D0
        MOVE.B D0,-74(A6)
        MOVE.L #0,D0
        MOVE.B D0,-73(A6)
        MOVE.L #0,D0
        MOVE.B D0,-72(A6)
        MOVE.L #0,D0
        MOVE.B D0,-71(A6)
        MOVE.L #0,D0
        MOVE.B D0,-70(A6)
        MOVE.L #0,D0
        MOVE.B D0,-69(A6)
        MOVE.L #0,D0
        MOVE.B D0,-68(A6)
        MOVE.L #0,D0
        MOVE.B D0,-67(A6)
        MOVE.L #0,D0
        MOVE.B D0,-66(A6)
        MOVE.L #0,D0
        MOVE.B D0,-65(A6)
        MOVE.L #0,D0
        MOVE.B D0,-64(A6)
        MOVE.L #0,D0
        MOVE.B D0,-63(A6)
        MOVE.L #0,D0
        MOVE.B D0,-62(A6)
        MOVE.L #0,D0
        MOVE.B D0,-61(A6)
        MOVE.L #0,D0
        MOVE.B D0,-60(A6)
        MOVE.L #0,D0
        MOVE.B D0,-59(A6)
        MOVE.L #0,D0
        MOVE.B D0,-58(A6)
        MOVE.L #0,D0
        MOVE.B D0,-57(A6)
        MOVE.L #0,D0
        MOVE.B D0,-56(A6)
        MOVE.L #0,D0
        MOVE.B D0,-55(A6)
        MOVE.L #0,D0
        MOVE.B D0,-54(A6)
        MOVE.L #0,D0
        MOVE.B D0,-53(A6)
        MOVE.L #0,D0
        MOVE.B D0,-52(A6)
        MOVE.L #0,D0
        MOVE.B D0,-51(A6)
        MOVE.L #0,D0
        MOVE.B D0,-50(A6)
        MOVE.L #0,D0
        MOVE.B D0,-49(A6)
        MOVE.L #0,D0
        MOVE.B D0,-48(A6)
        MOVE.L #0,D0
        MOVE.B D0,-47(A6)
        MOVE.L #0,D0
        MOVE.B D0,-46(A6)
        MOVE.L #0,D0
        MOVE.B D0,-45(A6)
        MOVE.L #0,D0
        MOVE.B D0,-44(A6)
        MOVE.L #0,D0
        MOVE.B D0,-43(A6)
        MOVE.L #0,D0
        MOVE.B D0,-42(A6)
        MOVE.L #0,D0
        MOVE.B D0,-41(A6)
        MOVE.L #0,D0
        MOVE.B D0,-40(A6)
        MOVE.L #0,D0
        MOVE.B D0,-39(A6)
        MOVE.L #0,D0
        MOVE.B D0,-38(A6)
        MOVE.L #0,D0
        MOVE.B D0,-37(A6)
        MOVE.L #0,D0
        MOVE.B D0,-36(A6)
        MOVE.L #0,D0
        MOVE.B D0,-35(A6)
        MOVE.L #0,D0
        MOVE.B D0,-34(A6)
        MOVE.L #0,D0
        MOVE.B D0,-33(A6)
        MOVE.L #0,D0
        MOVE.B D0,-32(A6)
        MOVE.L #0,D0
        MOVE.B D0,-31(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
        MOVE.L #0,D0
        MOVE.B D0,-29(A6)
        MOVE.L #0,D0
        MOVE.B D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-27(A6)
        MOVE.L #0,D0
        MOVE.B D0,-26(A6)
        MOVE.L #0,D0
        MOVE.B D0,-25(A6)
        MOVE.L #0,D0
        MOVE.B D0,-24(A6)
        MOVE.L #0,D0
        MOVE.B D0,-23(A6)
        MOVE.L #0,D0
        MOVE.B D0,-22(A6)
        MOVE.L #0,D0
        MOVE.B D0,-21(A6)
        MOVE.L #0,D0
        MOVE.B D0,-20(A6)
        MOVE.L #0,D0
        MOVE.B D0,-19(A6)
        MOVE.L #0,D0
        MOVE.B D0,-18(A6)
        MOVE.L #0,D0
        MOVE.B D0,-17(A6)
        MOVE.L #0,D0
        MOVE.B D0,-16(A6)
        MOVE.L #0,D0
        MOVE.B D0,-15(A6)
        MOVE.L #0,D0
        MOVE.B D0,-14(A6)
        MOVE.L #0,D0
        MOVE.B D0,-13(A6)
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
        MOVE.L #0,D0
        MOVE.B D0,-11(A6)
        MOVE.L #0,D0
        MOVE.B D0,-10(A6)
        MOVE.L #0,D0
        MOVE.B D0,-9(A6)
        MOVE.L #0,D0
        MOVE.B D0,-8(A6)
        MOVE.L #0,D0
        MOVE.B D0,-7(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L #0,D0
        MOVE.B D0,-5(A6)
        MOVE.L #0,D0
        MOVE.B D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-3(A6)
        MOVE.L #0,D0
        MOVE.B D0,-2(A6)
        MOVE.L #0,D0
        MOVE.B D0,-1(A6)
        MOVE.L #0,D0
        MOVE.B D0,-138(A6)
        MOVE.L #0,D0
        MOVE.B D0,-137(A6)
        MOVE.L #0,D0
        MOVE.B D0,-136(A6)
        MOVE.L #0,D0
        MOVE.B D0,-135(A6)
        MOVE.L #0,D0
        MOVE.B D0,-134(A6)
        MOVE.L #0,D0
        MOVE.B D0,-133(A6)
        MOVE.L #0,D0
        MOVE.B D0,-132(A6)
        MOVE.L #0,D0
        MOVE.B D0,-131(A6)
        MOVE.L #0,D0
        MOVE.B D0,-130(A6)
        MOVE.L #0,D0
        MOVE.B D0,-129(A6)
        MOVE.L #0,D0
        MOVE.B D0,-128(A6)
        MOVE.L #0,D0
        MOVE.B D0,-127(A6)
        MOVE.L #0,D0
        MOVE.B D0,-126(A6)
        MOVE.L #0,D0
        MOVE.B D0,-125(A6)
        MOVE.L #0,D0
        MOVE.B D0,-124(A6)
        MOVE.L #0,D0
        MOVE.B D0,-123(A6)
        MOVE.L #0,D0
        MOVE.B D0,-122(A6)
        MOVE.L #0,D0
        MOVE.B D0,-121(A6)
        MOVE.L #0,D0
        MOVE.B D0,-120(A6)
        MOVE.L #0,D0
        MOVE.B D0,-119(A6)
        MOVE.L #0,D0
        MOVE.B D0,-118(A6)
        MOVE.L #0,D0
        MOVE.B D0,-117(A6)
        MOVE.L #0,D0
        MOVE.B D0,-116(A6)
        MOVE.L #0,D0
        MOVE.B D0,-115(A6)
        MOVE.L #0,D0
        MOVE.B D0,-114(A6)
        MOVE.L #0,D0
        MOVE.B D0,-113(A6)
        MOVE.L #0,D0
        MOVE.B D0,-112(A6)
        MOVE.L #0,D0
        MOVE.B D0,-111(A6)
        MOVE.L #0,D0
        MOVE.B D0,-110(A6)
        MOVE.L #0,D0
        MOVE.B D0,-109(A6)
        MOVE.L #0,D0
        MOVE.B D0,-108(A6)
        MOVE.L #0,D0
        MOVE.B D0,-107(A6)
        MOVE.L #0,D0
        MOVE.B D0,-106(A6)
        MOVE.L #0,D0
        MOVE.B D0,-105(A6)
        MOVE.L #0,D0
        MOVE.B D0,-104(A6)
        MOVE.L #0,D0
        MOVE.B D0,-103(A6)
        MOVE.L #0,D0
        MOVE.B D0,-102(A6)
        MOVE.L #0,D0
        MOVE.B D0,-101(A6)
        MOVE.L #0,D0
        MOVE.B D0,-100(A6)
        MOVE.L #0,D0
        MOVE.B D0,-99(A6)
        MOVE.L #0,D0
        MOVE.B D0,-98(A6)
        MOVE.L #0,D0
        MOVE.B D0,-97(A6)
        MOVE.L #0,D0
        MOVE.B D0,-96(A6)
        MOVE.L #0,D0
        MOVE.B D0,-95(A6)
        MOVE.L #0,D0
        MOVE.B D0,-94(A6)
        MOVE.L #0,D0
        MOVE.B D0,-93(A6)
        MOVE.L #0,D0
        MOVE.B D0,-92(A6)
        MOVE.L #0,D0
        MOVE.B D0,-91(A6)
        MOVE.L #0,D0
        MOVE.B D0,-90(A6)
        MOVE.L #0,D0
        MOVE.B D0,-89(A6)
        MOVE.L #0,D0
        MOVE.B D0,-88(A6)
        MOVE.L #0,D0
        MOVE.B D0,-87(A6)
        MOVE.L #0,D0
        MOVE.B D0,-86(A6)
        MOVE.L #0,D0
        MOVE.B D0,-85(A6)
        MOVE.L #0,D0
        MOVE.B D0,-84(A6)
        MOVE.L #0,D0
        MOVE.B D0,-83(A6)
        MOVE.L #0,D0
        MOVE.B D0,-82(A6)
        MOVE.L #0,D0
        MOVE.B D0,-81(A6)
        MOVE.L #0,D0
        MOVE.B D0,-80(A6)
        MOVE.L #0,D0
        MOVE.B D0,-79(A6)
        MOVE.L #0,D0
        MOVE.B D0,-78(A6)
        MOVE.L #0,D0
        MOVE.B D0,-77(A6)
        MOVE.L #0,D0
        MOVE.B D0,-76(A6)
        MOVE.L #0,D0
        MOVE.B D0,-75(A6)
        LEA -394(A6),A0
        MOVE.W #127,D0
LBL_264:
        CLR.W (A0)+
        DBRA D0,LBL_264
        MOVE.L #0,D0
        MOVE.L D0,-398(A6)
        MOVE.L #100,D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #100,D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
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
        BEQ.W LBL_265
        MOVE.L #0,D0
        BRA.W LBL_263
LBL_265:
        LEA -120(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
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
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -394(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 1650(A5)
        ADDQ.L #8,A7
        MOVE.L #1,D0
        BRA.W LBL_263
LBL_263:
        UNLK A6
        RTS
        ; func rtUiParseInt  (JT slot 333)
        ;   param p : 16(A6)  size 4
        ;   param len : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local neg : -6(A6)  size 2
        ;   local v : -10(A6)  size 4
        ;   local anyDigit : -12(A6)  size 2
        ;   local c : -16(A6)  size 4
LBL_5:
        LINK A6,#-2144
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVE.L #0,D0
        BRA.W LBL_266
LBL_267:
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-6(A6)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        MOVE.L #1,D0
        MOVE.B D0,-6(A6)
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
LBL_268:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_269
        MOVE.L #0,D0
        BRA.W LBL_266
LBL_269:
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_270:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_271
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_272
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_273
LBL_272:
        MOVE.L #1,D0
LBL_273:
        TST.L D0
        BEQ.W LBL_274
        MOVE.L #0,D0
        BRA.W LBL_266
LBL_274:
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2147483647,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_176
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_275
        MOVE.L #0,D0
        BRA.W LBL_266
LBL_275:
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-10(A6)
        MOVE.L #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_270
LBL_271:
        CLR.L D0
        MOVE.B -12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_276
        MOVE.L #0,D0
        BRA.W LBL_266
LBL_276:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_277
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_278
LBL_277:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_278:
        MOVE.L #1,D0
        BRA.W LBL_266
LBL_266:
        UNLK A6
        RTS
        ; func rtUiParseFixed  (JT slot 334)
        ;   param p : 16(A6)  size 4
        ;   param len : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local dot : -8(A6)  size 4
        ;   local j : -12(A6)  size 4
        ;   local neg : -14(A6)  size 2
        ;   local ipart : -18(A6)  size 4
        ;   local frac : -22(A6)  size 4
        ;   local anyDigit : -24(A6)  size 2
        ;   local c : -28(A6)  size 4
        ;   local limit : -32(A6)  size 4
        ;   local v : -36(A6)  size 4
LBL_6:
        LINK A6,#-2164
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.B D0,-14(A6)
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
        MOVE.L #0,D0
        MOVE.L D0,-22(A6)
        MOVE.L #0,D0
        MOVE.B D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_280
        MOVE.L #0,D0
        BRA.W LBL_279
LBL_280:
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.B D0,-14(A6)
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        MOVE.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
LBL_281:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_282
        MOVE.L #0,D0
        BRA.W LBL_279
LBL_282:
        MOVE.L #0,D0
        MOVE.B D0,-24(A6)
LBL_283:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_284
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #46,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_286
LBL_285:
        MOVE.L #0,D0
LBL_286:
        TST.L D0
        BEQ.W LBL_287
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_288
LBL_287:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_289
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_290
LBL_289:
        MOVE.L #1,D0
LBL_290:
        TST.L D0
        BEQ.W LBL_291
        MOVE.L #0,D0
        BRA.W LBL_279
        BRA.W LBL_292
LBL_291:
        MOVE.L #1,D0
        MOVE.B D0,-24(A6)
LBL_292:
LBL_288:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_283
LBL_284:
        CLR.L D0
        MOVE.B -24(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_293
        MOVE.L #0,D0
        BRA.W LBL_279
LBL_293:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_294
        MOVE.L -8(A6),D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_295
LBL_294:
        MOVE.L 12(A6),D0
        MOVE.L D0,-32(A6)
LBL_295:
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
        CLR.L D0
        MOVE.B -14(A6),D0
        TST.L D0
        BEQ.W LBL_296
        MOVE.L #1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_297
LBL_296:
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_297:
LBL_298:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_299
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_176
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_300
        MOVE.L #0,D0
        BRA.W LBL_279
LBL_300:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_298
LBL_299:
        MOVE.L #0,D0
        MOVE.L D0,-22(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_301
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
LBL_302:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_303
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -22(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #65536,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_176
        MOVE.L D0,-22(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_302
LBL_303:
LBL_301:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -22(A6),D0
        MOVE.L (A7)+,D1
        OR.L D1,D0
        MOVE.L D0,-36(A6)
        CLR.L D0
        MOVE.B -14(A6),D0
        TST.L D0
        BEQ.W LBL_304
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_305
LBL_304:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_305:
        MOVE.L #1,D0
        BRA.W LBL_279
LBL_279:
        UNLK A6
        RTS
        ; func rtUiFormInvalid  (JT slot 335)
        ;   param inst : 12(A6)  size 4
        ;   param wIdx : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_7:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; UiSysBeep
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1946(A5)
        ADDQ.L #8,A7
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        DC.W $A9D1  ; UiTESetSelect
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 2426(A5)
        ADDQ.L #8,A7
LBL_306:
        UNLK A6
        RTS
        ; func rtUiFormCharOk  (JT slot 336)
        ;   param te : 16(A6)  size 4
        ;   param ch : 12(A6)  size 4
        ;   param ftype : 8(A6)  size 4
        ;   local teMp : -4(A6)  size 4
        ;   local th : -8(A6)  size 4
        ;   local thMp : -12(A6)  size 4
        ;   local len : -16(A6)  size 4
        ;   local i : -20(A6)  size 4
        ;   local first : -24(A6)  size 4
LBL_8:
        LINK A6,#-2152
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_308
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_309
LBL_308:
        MOVE.L #0,D0
LBL_309:
        TST.L D0
        BEQ.W LBL_310
        MOVE.L #1,D0
        BRA.W LBL_307
LBL_310:
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_311
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
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
        BEQ.W LBL_312
        MOVE.L #0,D0
        BRA.W LBL_307
LBL_312:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #60,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_313
        MOVE.L #1,D0
        BRA.W LBL_307
LBL_313:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #62,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_307
LBL_311:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #46,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_315
LBL_314:
        MOVE.L #0,D0
LBL_315:
        TST.L D0
        BEQ.W LBL_316
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #62,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #60,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A029  ; UiHLock
        MOVE.L -8(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
LBL_317:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #46,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_319
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVE.L #0,D0
        BRA.W LBL_307
LBL_319:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_317
LBL_318:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVE.L #1,D0
        BRA.W LBL_307
LBL_316:
        MOVE.L #0,D0
        BRA.W LBL_307
LBL_307:
        UNLK A6
        RTS
        ; func rtUiFormFill  (JT slot 337)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local formOff : -12(A6)  size 4
        ;   local layoutOff : -16(A6)  size 4
        ;   local bindsOff : -20(A6)  size 4
        ;   local nBinds : -24(A6)  size 4
        ;   local b : -28(A6)  size 4
        ;   local wIdx : -32(A6)  size 4
        ;   local fieldIdx : -36(A6)  size 4
        ;   local ftype : -40(A6)  size 4
        ;   local fieldOffset : -44(A6)  size 4
        ;   local base : -48(A6)  size 4
        ;   local kind : -52(A6)  size 4
        ;   local te : -56(A6)  size 4
        ;   local ctrl : -60(A6)  size 4
        ;   local text : -64(A6)  size 4
        ;   local savedPort : -68(A6)  size 4
        ;   local v : -72(A6)  size 4
        ;   local strCap : -76(A6)  size 4
        ;   local baseLen : -80(A6)  size 4
        ;   local enumCount : -84(A6)  size 4
        ;   local enumValuesOff : -88(A6)  size 4
        ;   local sel : -92(A6)  size 4
        ;   local k : -96(A6)  size 4
LBL_9:
        LINK A6,#-2224
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L #0,D0
        MOVE.L D0,-56(A6)
        MOVE.L #0,D0
        MOVE.L D0,-60(A6)
        MOVE.L #0,D0
        MOVE.L D0,-64(A6)
        MOVE.L #0,D0
        MOVE.L D0,-68(A6)
        MOVE.L #0,D0
        MOVE.L D0,-72(A6)
        MOVE.L #0,D0
        MOVE.L D0,-76(A6)
        MOVE.L #0,D0
        MOVE.L D0,-80(A6)
        MOVE.L #0,D0
        MOVE.L D0,-84(A6)
        MOVE.L #0,D0
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-92(A6)
        MOVE.L #0,D0
        MOVE.L D0,-96(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 922(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        JSR 1626(A5)
        MOVE.L D0,-68(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-64(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
LBL_321:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_322
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 938(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 946(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1058(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1066(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-48(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 562(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1578(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1458(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_324
LBL_323:
        MOVE.L #0,D0
LBL_324:
        TST.L D0
        BEQ.W LBL_325
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_327
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1074(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-76(A6)
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -76(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_329
        MOVE.L -76(A6),D0
        MOVE.L D0,-80(A6)
LBL_329:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        BRA.W LBL_328
LBL_327:
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_330
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        MOVE.L (A7)+,D0
        DC.W $A9EE  ; UiNumToString
        BRA.W LBL_331
LBL_330:
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_332
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 2058(A5)
        ADDQ.L #8,A7
        BRA.W LBL_333
LBL_332:
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_334
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_336
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_337
LBL_336:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_337:
        BRA.W LBL_335
LBL_334:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_335:
LBL_333:
LBL_331:
LBL_328:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9CF  ; UiTESetText
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A9D0  ; UiTECalText
        BRA.W LBL_326
LBL_325:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_338
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_339
LBL_338:
        MOVE.L #0,D0
LBL_339:
        TST.L D0
        BEQ.W LBL_340
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_342
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_343
LBL_342:
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_343:
        BRA.W LBL_341
LBL_340:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_344
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1098(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-92(A6)
        MOVE.L #0,D0
        MOVE.L D0,-96(A6)
LBL_345:
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -84(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_347
        MOVE.L -96(A6),D0
        MOVE.L D0,-92(A6)
        MOVE.L -84(A6),D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_348
LBL_347:
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
LBL_348:
        BRA.W LBL_345
LBL_346:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDA.W #12,A7
LBL_344:
LBL_341:
LBL_326:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_321
LBL_322:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_320:
        UNLK A6
        RTS
        ; func rtUiFormAccept  (JT slot 338)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
        ;   local winIdx : -8(A6)  size 4
        ;   local formOff : -12(A6)  size 4
        ;   local layoutOff : -16(A6)  size 4
        ;   local bindsOff : -20(A6)  size 4
        ;   local nBinds : -24(A6)  size 4
        ;   local recSize : -28(A6)  size 4
        ;   local b : -32(A6)  size 4
        ;   local wIdx : -36(A6)  size 4
        ;   local fieldIdx : -40(A6)  size 4
        ;   local ftype : -44(A6)  size 4
        ;   local fieldOffset : -48(A6)  size 4
        ;   local base : -52(A6)  size 4
        ;   local text : -56(A6)  size 4
        ;   local ok : -58(A6)  size 2
        ;   local strCap : -62(A6)  size 4
        ;   local len : -66(A6)  size 4
        ;   local z : -70(A6)  size 4
        ;   local ctrl : -74(A6)  size 4
        ;   local sel : -78(A6)  size 4
        ;   local enumCount : -82(A6)  size 4
        ;   local enumValuesOff : -86(A6)  size 4
LBL_10:
        LINK A6,#-2214
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L #0,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-44(A6)
        MOVE.L #0,D0
        MOVE.L D0,-48(A6)
        MOVE.L #0,D0
        MOVE.L D0,-52(A6)
        MOVE.L #0,D0
        MOVE.L D0,-56(A6)
        MOVE.L #0,D0
        MOVE.B D0,-58(A6)
        MOVE.L #0,D0
        MOVE.L D0,-62(A6)
        MOVE.L #0,D0
        MOVE.L D0,-66(A6)
        MOVE.L #0,D0
        MOVE.L D0,-70(A6)
        MOVE.L #0,D0
        MOVE.L D0,-74(A6)
        MOVE.L #0,D0
        MOVE.L D0,-78(A6)
        MOVE.L #0,D0
        MOVE.L D0,-82(A6)
        MOVE.L #0,D0
        MOVE.L D0,-86(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 922(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1042(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-56(A6)
        MOVE.L #0,D0
        MOVE.L D0,-32(A6)
LBL_350:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_351
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 938(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 946(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1058(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1066(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_352
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1682(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_354
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_349
LBL_354:
        BRA.W LBL_353
LBL_352:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_355
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1682(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_357
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_7
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_349
LBL_357:
        BRA.W LBL_356
LBL_355:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1682(A5)
        ADDA.W #16,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1074(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-62(A6)
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-66(A6)
        MOVE.L -66(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
        MOVE.L -62(A6),D0
        MOVE.L D0,-66(A6)
LBL_360:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -66(A6),D0
        MOVE.L D0,-70(A6)
LBL_361:
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -70(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-70(A6)
        BRA.W LBL_361
LBL_362:
        BRA.W LBL_359
LBL_358:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_363
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1458(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-74(A6)
        MOVE.L -74(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_365
        CLR.W -(A7)
        MOVE.L -74(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_366
LBL_365:
        MOVE.L #0,D0
LBL_366:
        TST.L D0
        BEQ.W LBL_367
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_368
LBL_367:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_368:
        BRA.W LBL_364
LBL_363:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_369
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1682(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_371
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_372
LBL_371:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_372:
        BRA.W LBL_370
LBL_369:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_373
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2026(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-78(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-82(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1098(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-86(A6)
        MOVE.L -82(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_377
LBL_376:
        MOVE.L #0,D0
LBL_377:
        TST.L D0
        BEQ.W LBL_374
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -82(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_375
LBL_374:
        MOVE.L #0,D0
LBL_375:
        TST.L D0
        BEQ.W LBL_378
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 1122(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_379
LBL_378:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_379:
LBL_373:
LBL_370:
LBL_364:
LBL_359:
LBL_356:
LBL_353:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_350
LBL_351:
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -128(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        MOVE.L -132(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_382
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -132(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_382:
        BRA.W LBL_381
LBL_380:
        MOVE.L -128(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_383
        MOVE.L -136(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_387
        MOVE.L -140(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_388
LBL_387:
        MOVE.L #0,D0
LBL_388:
        TST.L D0
        BEQ.W LBL_385
        MOVE.L -140(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -136(A5),D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_386
LBL_385:
        MOVE.L #0,D0
LBL_386:
        TST.L D0
        BEQ.W LBL_389
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -136(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -140(A5),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_389:
        BRA.W LBL_384
LBL_383:
        MOVE.L -128(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_391
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        JSR 330(A5)
        ADDA.W #12,A7
LBL_391:
LBL_390:
LBL_384:
LBL_381:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_146(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_392:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_392
        JSR 2322(A5)
        ADDA.W #260,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L D0,-(A7)
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
LBL_349:
        UNLK A6
        RTS
        ; func rtUiFormTeardown  (JT slot 339)
        ;   param inst : 8(A6)  size 4
        ;   local bufH : -4(A6)  size 4
LBL_11:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -118(A5),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.B D0,-110(A5)
        MOVE.L #0,D0
        MOVE.L D0,-114(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; UiDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1210(A5)
        ADDQ.L #4,A7
LBL_393:
        UNLK A6
        RTS
        ; func rtUiFormCancel  (JT slot 340)
        ;   param inst : 8(A6)  size 4
        ;   local w : -4(A6)  size 4
LBL_12:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_395:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_395
        JSR 2322(A5)
        ADDA.W #260,A7
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
LBL_394:
        UNLK A6
        RTS
        ; func rtUiEdit  (JT slot 341)
        ;   param winIdx : 40(A6)  size 4
        ;   param src : 36(A6)  size 4
        ;   param isNew : 32(A6)  size 4
        ;   param wbKind : 28(A6)  size 4
        ;   param addr : 24(A6)  size 4
        ;   param lst : 20(A6)  size 4
        ;   param idx : 16(A6)  size 4
        ;   param mp : 12(A6)  size 4
        ;   param key255 : 8(A6)  size 4
        ;   local formOff : -4(A6)  size 4
        ;   local layoutOff : -8(A6)  size 4
        ;   local recSize : -12(A6)  size 4
        ;   local buf : -16(A6)  size 4
        ;   local bufH : -20(A6)  size 4
        ;   local inst : -24(A6)  size 4
        ;   local klen : -28(A6)  size 4
LBL_13:
        LINK A6,#-2156
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        CLR.L D0
        MOVE.B -110(A5),D0
        TST.L D0
        BEQ.W LBL_397
        LEA LBL_148(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_398:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_398
        JSR 50(A5)
        ADDA.W #256,A7
LBL_397:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_399
        LEA LBL_149(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_400:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_400
        JSR 50(A5)
        ADDA.W #256,A7
LBL_399:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1042(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1130(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L 36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L #1,D0
        MOVE.B D0,-110(A5)
        MOVE.L #0,D0
        MOVE.L D0,-114(A5)
        MOVE.L -20(A6),D0
        MOVE.L D0,-118(A5)
        MOVE.L -16(A6),D0
        MOVE.L D0,-122(A5)
        MOVE.L 32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        MOVE.L #1,D0
        MOVE.B D0,-124(A5)
        BRA.W LBL_402
LBL_401:
        MOVE.L #0,D0
        MOVE.B D0,-124(A5)
LBL_402:
        MOVE.L 28(A6),D0
        MOVE.L D0,-128(A5)
        MOVE.L 24(A6),D0
        MOVE.L D0,-132(A5)
        MOVE.L 20(A6),D0
        MOVE.L D0,-136(A5)
        MOVE.L 16(A6),D0
        MOVE.L D0,-140(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-144(A5)
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-148(A5)
LBL_403:
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_404
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_405
LBL_404:
        MOVE.L #0,D0
LBL_405:
        TST.L D0
        BEQ.W LBL_406
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_407
        MOVE.L #255,D0
        MOVE.L D0,-28(A6)
LBL_407:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_406:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1202(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-114(A5)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_9
        ADDQ.L #4,A7
LBL_396:
        UNLK A6
        RTS
        ; func rtUiFormIsNew  (JT slot 342)
LBL_14:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -110(A5),D0
        TST.L D0
        BEQ.W LBL_409
        CLR.L D0
        MOVE.B -124(A5),D0
        BRA.W LBL_408
LBL_409:
        MOVE.L #0,D0
        BRA.W LBL_408
LBL_408:
        UNLK A6
        RTS
        ; func rtUiAskOpen  (JT slot 343)
        ;   param path255 : 12(A6)  size 4
        ;   param filter : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_15:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_411
        JSR 2242(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_412
        LEA LBL_150(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_413:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_413
        JSR 2626(A5)
        ADDA.W #256,A7
        MOVE.L D0,-(A7)
        JSR 2282(A5)
        ADDQ.L #4,A7
        MOVE.L #0,D0
        BRA.W LBL_410
LBL_412:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
        LEA LBL_151(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_415:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_415
        JSR 50(A5)
        ADDA.W #256,A7
        MOVE.L #0,D0
        BRA.W LBL_410
LBL_414:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1650(A5)
        ADDQ.L #8,A7
        LEA LBL_152(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_416:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_416
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2434(A5)
        ADDA.W #260,A7
        MOVE.L #1,D0
        BRA.W LBL_410
LBL_411:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #8,A7
        BRA.W LBL_410
LBL_410:
        UNLK A6
        RTS
        ; func rtUiAskSave  (JT slot 344)
        ;   param path255 : 12(A6)  size 4
        ;   param suggested : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_16:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_418
        JSR 2242(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        LEA LBL_153(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_420:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_420
        JSR 2626(A5)
        ADDA.W #256,A7
        MOVE.L D0,-(A7)
        JSR 2282(A5)
        ADDQ.L #4,A7
        MOVE.L #0,D0
        BRA.W LBL_417
LBL_419:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        LEA LBL_154(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_422:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_422
        JSR 50(A5)
        ADDA.W #256,A7
        MOVE.L #0,D0
        BRA.W LBL_417
LBL_421:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1650(A5)
        ADDQ.L #8,A7
        LEA LBL_155(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_423:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_423
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2434(A5)
        ADDA.W #260,A7
        MOVE.L #1,D0
        BRA.W LBL_417
LBL_418:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_4
        ADDQ.L #8,A7
        BRA.W LBL_417
LBL_417:
        UNLK A6
        RTS
        ; func rtUiAskSaveChanges  (JT slot 345)
        ;   param name : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local empty : -16(A6)  size 4
        ;   local item : -20(A6)  size 4
        ;   local t : -24(A6)  size 4
LBL_17:
        LINK A6,#-2152
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_425
        JSR 2242(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        LEA LBL_156(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_427:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_427
        JSR 50(A5)
        ADDA.W #256,A7
        MOVE.L #0,D0
        BRA.W LBL_424
LBL_426:
        MOVE.L -50(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        JSR 114(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_157(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        BRA.W LBL_429
LBL_428:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        BRA.W LBL_431
LBL_430:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
LBL_431:
LBL_429:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2282(A5)
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        BRA.W LBL_424
LBL_425:
        JSR 1282(A5)
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A98B  ; UiParamText
        CLR.W -(A7)
        MOVE.L #130,D0
        MOVE.W D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A985  ; UiAlert
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_424
LBL_424:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 346)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_18:
        LINK A6,#-2144
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_433:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
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
        BEQ.W LBL_435
        MOVE.L #10,D0
        MOVE.L D0,-12(A6)
LBL_435:
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
        BRA.W LBL_433
LBL_434:
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
        BRA.W LBL_432
LBL_432:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 347)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
LBL_19:
        LINK A6,#-2146
        MOVE.L #0,D0
        MOVE.B D0,-2(A6)
        MOVE.L #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
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
        BEQ.W LBL_437
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,12(A6)
LBL_437:
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
        BEQ.W LBL_438
        MOVE.L -160(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_439
LBL_438:
LBL_440:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_177
        MOVE.L D0,-10(A6)
        MOVE.L -160(A5),D0
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
        BSR.W LBL_176
        MOVE.L D0,12(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_440
LBL_441:
LBL_439:
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_442
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-14(A6)
LBL_442:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_443:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_444
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
        MOVE.L -160(A5),D0
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
        BRA.W LBL_443
LBL_444:
        MOVE.L -14(A6),D0
        BRA.W LBL_436
LBL_436:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 348)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_20:
        LINK A6,#-2128
        MOVE.L -172(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_446
        BRA.W LBL_445
LBL_446:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
        BRA.W LBL_445
LBL_447:
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -172(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_445:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 349)
LBL_21:
        LINK A6,#-2128
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_448:
        UNLK A6
        RTS
        ; func natInit  (JT slot 350)
LBL_22:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -174(A5),D0
        TST.L D0
        BEQ.W LBL_450
        BRA.W LBL_449
LBL_450:
        MOVE.L #1,D0
        MOVE.B D0,-174(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-152(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-156(A5)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-160(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-164(A5)
        MOVE.L #0,D0
        MOVE.L D0,-168(A5)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -152(A5),D0
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
        MOVE.L -152(A5),D0
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
        MOVE.L -152(A5),D0
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
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #27,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -152(A5),D0
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
        BEQ.W LBL_451
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-172(A5)
        BRA.W LBL_449
LBL_451:
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-172(A5)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -172(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_449:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 351)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_23:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_22
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        BSR.W LBL_21
LBL_452:
        UNLK A6
        RTS
        ; func natLog  (JT slot 352)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_24:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_22
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_454:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_456
        MOVE.L -168(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_457
LBL_456:
        MOVE.L #0,D0
LBL_457:
        TST.L D0
        BEQ.W LBL_455
        MOVE.L -164(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -168(A5),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -168(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-168(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_454
LBL_455:
LBL_453:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 353)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_25:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -176(A5),D0
        TST.L D0
        BEQ.W LBL_459
        BRA.W LBL_458
LBL_459:
        MOVE.L #1,D0
        MOVE.B D0,-176(A5)
        BSR.W LBL_22
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_19
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L -164(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -168(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L -172(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_460
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -172(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -152(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_460:
        BSR.W LBL_21
        DC.W $A9F4  ; NatExitToShell
LBL_458:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 354)
        ;   param msg : 8(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_26:
        LINK A6,#-2384
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_462:
        CLR.W (A0)+
        DBRA D0,LBL_462
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_158(PC),A0
        MOVE.L A0,-(A7)
        LEA 8(A6),A0
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
        ADDA.L #256,A7
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_461:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 355)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_27:
        LINK A6,#-2128
        MOVE.L 264(A6),D0
        MOVE.L D0,-184(A5)
        LEA -440(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
LBL_463:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 356)
        ;   hidden result ptr : 8(A6)  size 4
LBL_28:
        LINK A6,#-2128
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -440(A5),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        BRA.W LBL_464
LBL_464:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 357)
        ;   local __ret2 : -4(A6)  size 4
LBL_29:
        LINK A6,#-2132
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2088(A6)
LBL_466:
        MOVE.L A1,-(A7)
        MOVE.L -2088(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_465
LBL_465:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 358)
LBL_30:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -446(A5),D0
        TST.L D0
        BEQ.W LBL_468
        BRA.W LBL_467
LBL_468:
        MOVE.L #1,D0
        MOVE.B D0,-446(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-444(A5)
LBL_467:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 359)
LBL_31:
        LINK A6,#-2128
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_469:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 360)
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
LBL_32:
        LINK A6,#-2158
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.B D0,-22(A6)
        MOVE.L #0,D0
        MOVE.L D0,-26(A6)
        MOVE.L #0,D0
        MOVE.L D0,-30(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 66(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-26(A6)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_159(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_472:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_472
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_470
LBL_471:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 66(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-30(A6)
        MOVE.L -30(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_473
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_160(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_474:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_474
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_470
LBL_473:
        BSR.W LBL_30
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -444(A5),D0
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
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
LBL_475:
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -444(A5),D0
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
        BEQ.W LBL_476
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_477:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_477
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_470
LBL_476:
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
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
        BEQ.W LBL_478
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
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
        MOVE.L -444(A5),D0
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
        MOVE.L -444(A5),D0
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
        BEQ.W LBL_479
        MOVE.L #1,D0
        MOVE.B D0,-22(A6)
LBL_479:
LBL_478:
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        BSR.W LBL_31
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_480
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_481
LBL_480:
        MOVE.L #1,D0
LBL_481:
        TST.L D0
        BEQ.W LBL_482
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_162(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_483:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_483
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_470
LBL_482:
        MOVE.L #1,D0
        BRA.W LBL_470
LBL_470:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 361)
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
LBL_33:
        LINK A6,#-2158
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
        BSR.W LBL_30
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -444(A5),D0
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
        BEQ.W LBL_485
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_161(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_486:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_486
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_484
LBL_485:
        MOVE.L -444(A5),D0
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
        BEQ.W LBL_487
        LEA LBL_59(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_488:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_488
        JSR 50(A5)
        ADDA.W #256,A7
LBL_487:
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
LBL_489:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A002  ; NatRead
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #40,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-16(A6)
        MOVE.L -444(A5),D0
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
        BEQ.W LBL_491
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_492
LBL_491:
        MOVE.L #0,D0
LBL_492:
        TST.L D0
        BEQ.W LBL_493
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_163(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_494:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_494
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_484
LBL_493:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_495
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 106(A5)
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
LBL_495:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_496
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_497
LBL_496:
        MOVE.L #1,D0
LBL_497:
        TST.L D0
        BEQ.W LBL_498
        MOVE.L #1,D0
        MOVE.B D0,-30(A6)
LBL_498:
        BRA.W LBL_489
LBL_490:
        MOVE.L -444(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -444(A5),D0
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
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 362)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_34:
        LINK A6,#-2148
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_500:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_501
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
        BEQ.W LBL_502
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_502:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_500
LBL_501:
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
LBL_503:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_504
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
        BRA.W LBL_503
LBL_504:
LBL_499:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 363)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_35:
        LINK A6,#-2128
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_506
        MOVE.L #1,D0
        BRA.W LBL_505
LBL_506:
        MOVE.L #0,D0
        BRA.W LBL_505
LBL_505:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 364)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_36:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_508
        MOVE.L #1,D0
        BRA.W LBL_507
LBL_508:
        MOVE.L #0,D0
        BRA.W LBL_507
LBL_507:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 365)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_37:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_22
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_510
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-450(A5)
LBL_510:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        BSR.W LBL_21
LBL_509:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 366)
        ;   param code : 8(A6)  size 4
LBL_38:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_511:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 367)
LBL_39:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -452(A5),D0
        TST.L D0
        BEQ.W LBL_513
        BRA.W LBL_512
LBL_513:
        MOVE.L #1,D0
        MOVE.B D0,-452(A5)
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-456(A5)
        MOVE.L -456(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #202,D0
        MOVE.L (A7)+,D1
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
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        DC.W $A97B  ; NatInitDialogs
        DC.W $A850  ; NatInitCursor
LBL_512:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 368)
        ;   param out : 8(A6)  size 4
LBL_40:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #86,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #90,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_514:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 369)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_41:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #80,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -456(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #84,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_516
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65536,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_516:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #86,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #90,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_515:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 370)
LBL_42:
        LINK A6,#-2128
        MOVE.L #0,-(A7)
        JSR 1202(A5)
        ADDQ.L #4,A7
LBL_517:
        UNLK A6
        RTS
        ; func ui_Probe_opened  (JT slot 371)
        ;   param window : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
LBL_43:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.B D0,-(A7)
        JSR 1834(A5)
        ADDA.W #26,A7
LBL_518:
        UNLK A6
        RTS
        ; func ui_every_0  (JT slot 372)
        ;   local p : -4(A6)  size 4
LBL_44:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,-(A7)
        JSR 1162(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_175
        MOVE.L D0,-(A7)
        MOVE.L #280,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_177
        MOVE.L D0,-(A7)
        MOVE.L #40,D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.B D0,-(A7)
        JSR 1834(A5)
        ADDA.W #26,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #60,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_521
        JSR 1234(A5)
LBL_521:
LBL_520:
LBL_519:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 373)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_45:
        LINK A6,#-2128
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_523
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_525
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
LBL_525:
        BRA.W LBL_524
LBL_523:
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_178
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_524:
LBL_522:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 374)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_46:
        LINK A6,#-2128
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_527
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_529
        BRA.W LBL_530
LBL_529:
        LEA LBL_165(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_178
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_530:
        BRA.W LBL_528
LBL_527:
        LEA LBL_166(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_178
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_528:
LBL_526:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 375)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_47:
        LINK A6,#-2128
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_178
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_531:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 376)
        ;   param idx : 8(A6)  size 4
LBL_48:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        BSR.W LBL_44
        BRA.W LBL_534
LBL_533:
        LEA LBL_168(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_178
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_534:
LBL_532:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 377)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_49:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_536
        BRA.W LBL_537
LBL_536:
        LEA LBL_169(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_178
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_537:
LBL_535:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 378)
        ;   param rowsIdx : 8(A6)  size 4
LBL_50:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_539
        LEA -4(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_540
LBL_539:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        LEA -8(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_542
LBL_541:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_543
        LEA -12(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_544
LBL_543:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_545
        LEA -16(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_546
LBL_545:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_547
        LEA -18(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_548
LBL_547:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_549
        LEA -22(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_550
LBL_549:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_551
        LEA -26(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_552
LBL_551:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_553
        LEA -30(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_554
LBL_553:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_555
        LEA -34(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_556
LBL_555:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_557
        LEA -38(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_558
LBL_557:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_559
        LEA -40(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_560
LBL_559:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_561
        LEA -42(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_562
LBL_561:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_563
        LEA -46(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_564
LBL_563:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_565
        LEA -50(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_566
LBL_565:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_567
        LEA -54(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_568
LBL_567:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_569
        LEA -58(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_570
LBL_569:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_571
        LEA -62(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_572
LBL_571:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #17,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_573
        LEA -66(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_574
LBL_573:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_575
        LEA -70(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_576
LBL_575:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #19,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_577
        LEA -74(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_578
LBL_577:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_579
        LEA -76(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_580
LBL_579:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #21,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_581
        LEA -78(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_582
LBL_581:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_583
        LEA -82(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_584
LBL_583:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #23,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_585
        LEA -84(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_586
LBL_585:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_587
        LEA -88(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_588
LBL_587:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #25,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_589
        LEA -92(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_590
LBL_589:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #26,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_591
        LEA -96(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_592
LBL_591:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #27,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_593
        LEA -100(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_594
LBL_593:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_595
        LEA -104(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_596
LBL_595:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #29,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        LEA -108(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_598
LBL_597:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #30,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_599
        LEA -110(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_600
LBL_599:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #31,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_601
        LEA -114(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_602
LBL_601:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_603
        LEA -118(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_604
LBL_603:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #33,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_605
        LEA -122(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_606
LBL_605:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_607
        LEA -124(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_608
LBL_607:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_609
        LEA -128(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_610
LBL_609:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_611
        LEA -132(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_612
LBL_611:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #37,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_613
        LEA -136(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_614
LBL_613:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #38,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_615
        LEA -140(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_616
LBL_615:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #39,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_617
        LEA -144(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_618
LBL_617:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #40,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_619
        LEA -148(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_620
LBL_619:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #41,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_621
        LEA -152(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_622
LBL_621:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #42,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_623
        LEA -156(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_624
LBL_623:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #43,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_625
        LEA -160(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_626
LBL_625:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        LEA -164(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_628
LBL_627:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_629
        LEA -168(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_630
LBL_629:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #46,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_631
        LEA -172(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_632
LBL_631:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #47,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_633
        LEA -174(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_634
LBL_633:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_635
        LEA -176(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_636
LBL_635:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #49,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_637
        LEA -180(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_638
LBL_637:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_639
        LEA -184(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_640
LBL_639:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #51,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_641
        LEA -440(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_642
LBL_641:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #52,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_643
        LEA -444(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_644
LBL_643:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #53,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_645
        LEA -446(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_646
LBL_645:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #54,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        LEA -450(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_648
LBL_647:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #55,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_649
        LEA -452(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_650
LBL_649:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #56,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_651
        LEA -456(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_538
        BRA.W LBL_652
LBL_651:
        LEA LBL_170(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_178
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVE.L #0,D0
        BRA.W LBL_538
LBL_652:
LBL_650:
LBL_648:
LBL_646:
LBL_644:
LBL_642:
LBL_640:
LBL_638:
LBL_636:
LBL_634:
LBL_632:
LBL_630:
LBL_628:
LBL_626:
LBL_624:
LBL_622:
LBL_620:
LBL_618:
LBL_616:
LBL_614:
LBL_612:
LBL_610:
LBL_608:
LBL_606:
LBL_604:
LBL_602:
LBL_600:
LBL_598:
LBL_596:
LBL_594:
LBL_592:
LBL_590:
LBL_588:
LBL_586:
LBL_584:
LBL_582:
LBL_580:
LBL_578:
LBL_576:
LBL_574:
LBL_572:
LBL_570:
LBL_568:
LBL_566:
LBL_564:
LBL_562:
LBL_560:
LBL_558:
LBL_556:
LBL_554:
LBL_552:
LBL_550:
LBL_548:
LBL_546:
LBL_544:
LBL_542:
LBL_540:
LBL_538:
        UNLK A6
        RTS
        ; func clar_cb_rtUiScrollbarAction (JT slot 379) -- pascal callback glue for rtUiScrollbarAction
LBL_51:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1962(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 380) -- pascal callback glue for rtUiLdefDraw
LBL_52:
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
        JSR 2098(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_175:
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
LBL_176:
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
        BPL.W LBL_653
        NEG.L D2
        MOVE.L #1,D4
LBL_653:
        CLR.L D5
        TST.L D3
        BPL.W LBL_654
        NEG.L D3
        MOVE.L #1,D5
LBL_654:
        CLR.L D6
        MOVE.W #31,D7
LBL_655:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_656
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_656:
        DBRA D7,LBL_655
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_657
        NEG.L D2
LBL_657:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_177:
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
        BPL.W LBL_658
        NEG.L D2
        MOVE.L #1,D4
LBL_658:
        CLR.L D5
        TST.L D3
        BPL.W LBL_659
        NEG.L D3
        MOVE.L #1,D5
LBL_659:
        CLR.L D6
        MOVE.W #31,D7
LBL_660:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_661
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_661:
        DBRA D7,LBL_660
        TST.L D4
        BEQ.W LBL_662
        NEG.L D6
LBL_662:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_178:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
LBL_663:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_53:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_54:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_55:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_56:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_57:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_58:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_59:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_60:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_61:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_62:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_63:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_64:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_65:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_66:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_67:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_68:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_69:
        DC.B $01
        DC.B $2D
LBL_70:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_71:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_72:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_73:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_74:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_75:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_76:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
LBL_77:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_78:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_79:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_80:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_81:
        DC.B $03
        DC.B $6B,$65,$79
LBL_82:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_83:
        DC.B $01
        DC.B $78
LBL_84:
        DC.B $01
        DC.B $3F
LBL_85:
        DC.B $06
        DC.B $73,$65,$6C,$65,$63,$74
        DC.B $00
LBL_86:
        DC.B $0B
        DC.B $64,$6F,$75,$62,$6C,$65,$43,$6C,$69,$63,$6B
LBL_87:
        DC.B $78
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$66,$6F,$75,$6E,$64,$20,$6E,$6F,$20,$6D,$65,$6E,$75,$20,$69,$6E,$20,$74,$68,$65,$20,$6D,$65,$6E,$75,$20,$6C,$69,$73,$74,$20,$66,$6F,$72,$20,$74,$68,$69,$73,$20,$77,$69,$64,$67,$65,$74,$20,$28,$63,$6C,$6F,$73,$65,$2F,$72,$65,$6F,$70,$65,$6E,$20,$6C,$65,$66,$74,$20,$69,$74,$20,$75,$6E,$64,$65,$6C,$65,$74,$65,$64,$20,$6F,$72,$20,$6E,$65,$76,$65,$72,$20,$72,$65,$69,$6E,$73,$65,$72,$74,$65,$64,$29
        DC.B $00
LBL_88:
        DC.B $71
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$72,$65,$74,$75,$72,$6E,$65,$64,$20,$61,$20,$6D,$65,$6E,$75,$20,$68,$61,$6E,$64,$6C,$65,$20,$74,$68,$61,$74,$20,$69,$73,$6E,$27,$74,$20,$74,$68,$69,$73,$20,$69,$6E,$73,$74,$61,$6E,$63,$65,$27,$73,$20,$6F,$77,$6E,$20,$28,$73,$74,$61,$6C,$65,$2F,$6C,$65,$61,$6B,$65,$64,$20,$65,$6E,$74,$72,$79,$20,$75,$6E,$64,$65,$72,$20,$74,$68,$65,$20,$73,$61,$6D,$65,$20,$49,$44,$29
LBL_89:
        DC.B $57
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$6D,$65,$6E,$75,$20,$69,$74,$65,$6D,$20,$63,$6F,$75,$6E,$74,$20,$64,$6F,$65,$73,$6E,$27,$74,$20,$6D,$61,$74,$63,$68,$20,$74,$68,$65,$20,$62,$6F,$75,$6E,$64,$20,$65,$6E,$75,$6D,$20,$28,$72,$65,$62,$75,$69,$6C,$74,$20,$77,$69,$74,$68,$20,$73,$74,$61,$6C,$65,$2F,$6C,$65,$66,$74,$6F,$76,$65,$72,$20,$69,$74,$65,$6D,$73,$29
LBL_90:
        DC.B $24
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_91:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$61,$6E,$73,$77,$65,$72,$20,$71,$75,$65,$75,$65,$20,$6F,$76,$65,$72,$66,$6C,$6F,$77
LBL_92:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$77,$69,$74,$68,$20,$6E,$6F,$20,$71,$75,$65,$75,$65,$64,$20,$61,$6E,$73,$77,$65,$72
LBL_93:
        DC.B $07
        DC.B $54,$20,$4F,$50,$45,$4E,$20
LBL_94:
        DC.B $01
        DC.B $20
LBL_95:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_96:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_97:
        DC.B $01
        DC.B $2E
LBL_98:
        DC.B $07
        DC.B $2E,$73,$65,$6C,$65,$63,$74
LBL_99:
        DC.B $0D
        DC.B $54,$20,$46,$49,$52,$45,$20,$65,$76,$65,$72,$79,$2E
LBL_100:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_101:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_102:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_103:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_104:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_105:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_106:
        DC.B $08
        DC.B $54,$20,$41,$42,$4F,$55,$54,$20
        DC.B $00
LBL_107:
        DC.B $01
        DC.B $7C
LBL_108:
        DC.B $07
        DC.B $63,$61,$70,$74,$69,$6F,$6E
LBL_109:
        DC.B $04
        DC.B $74,$65,$78,$74
        DC.B $00
LBL_110:
        DC.B $07
        DC.B $65,$6E,$61,$62,$6C,$65,$64
LBL_111:
        DC.B $07
        DC.B $63,$68,$65,$63,$6B,$65,$64
LBL_112:
        DC.B $08
        DC.B $73,$65,$6C,$65,$63,$74,$65,$64
        DC.B $00
LBL_113:
        DC.B $05
        DC.B $77,$69,$64,$74,$68
LBL_114:
        DC.B $06
        DC.B $68,$65,$69,$67,$68,$74
        DC.B $00
LBL_115:
        DC.B $06
        DC.B $54,$20,$53,$45,$54,$20
        DC.B $00
LBL_116:
        DC.B $09
        DC.B $2E,$69,$6E,$76,$61,$6C,$69,$64,$2E
LBL_117:
        DC.B $02
        DC.B $54,$20
        DC.B $00
LBL_118:
        DC.B $0A
        DC.B $54,$20,$4F,$50,$45,$4E,$44,$4F,$43,$20
        DC.B $00
LBL_119:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_120:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_121:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_122:
        DC.B $37
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$73,$61,$76,$65,$7C,$64,$69,$73,$63,$61,$72,$64,$7C,$63,$61,$6E,$63,$65,$6C,$29
LBL_123:
        DC.B $23
        DC.B $73,$6E,$61,$70,$3A,$20,$73,$63,$72,$65,$65,$6E,$42,$69,$74,$73,$2E,$72,$6F,$77,$42,$79,$74,$65,$73,$20,$69,$73,$20,$6E,$6F,$74,$20,$36,$34
LBL_124:
        DC.B $10
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$23,$23,$20
        DC.B $00
LBL_125:
        DC.B $13
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$2D,$45,$4E,$44,$23,$23
LBL_126:
        DC.B $2C
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$6B,$6E,$6F,$77,$6E,$20,$6F,$72,$20,$75,$6E,$73,$75,$70,$70,$6F,$72,$74,$65,$64,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$76,$65,$72,$62
        DC.B $00
LBL_127:
        DC.B $08
        DC.B $64,$62,$6C,$63,$6C,$69,$63,$6B
        DC.B $00
LBL_128:
        DC.B $04
        DC.B $74,$79,$70,$65
        DC.B $00
LBL_129:
        DC.B $04
        DC.B $6D,$65,$6E,$75
        DC.B $00
LBL_130:
        DC.B $05
        DC.B $63,$6C,$6F,$73,$65
LBL_131:
        DC.B $06
        DC.B $72,$65,$73,$69,$7A,$65
        DC.B $00
LBL_132:
        DC.B $04
        DC.B $7A,$6F,$6F,$6D
        DC.B $00
LBL_133:
        DC.B $04
        DC.B $74,$69,$63,$6B
        DC.B $00
LBL_134:
        DC.B $04
        DC.B $73,$6E,$61,$70
        DC.B $00
LBL_135:
        DC.B $04
        DC.B $71,$75,$69,$74
        DC.B $00
LBL_136:
        DC.B $09
        DC.B $6C,$61,$75,$6E,$63,$68,$64,$6F,$63
LBL_137:
        DC.B $0C
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$70,$6F,$70,$75,$70
        DC.B $00
LBL_138:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$6F,$70,$65,$6E
LBL_139:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$73,$61,$76,$65
LBL_140:
        DC.B $0E
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73
        DC.B $00
LBL_141:
        DC.B $0D
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$61,$6E,$63,$65,$6C
LBL_142:
        DC.B $2A
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$6D,$75,$73,$74,$20,$68,$61,$76,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$65,$6E,$74,$72,$69,$65,$73
        DC.B $00
LBL_143:
        DC.B $31
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$65,$6E,$74,$72,$79,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_144:
        DC.B $00
        DC.B $00
LBL_145:
        DC.B $08
        DC.B $53,$61,$76,$65,$20,$61,$73,$3A
        DC.B $00
LBL_146:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_147:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_148:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_149:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_150:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_151:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_152:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_153:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_154:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_155:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_156:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_157:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_158:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_159:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_160:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_161:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_162:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_163:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_164:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_165:
        DC.B $2B
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$64,$67,$65,$74,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_166:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_167:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_168:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_169:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_170:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_171:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_174:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (264 bytes)
LBL_172:
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
        DC.B $90
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $90
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $90
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $94
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $A8
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $AE
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $2C
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
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $5C
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $04
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $02
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $A4
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
        DC.B $00
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $FF
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $01
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $AE
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $B8
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $BC
        DC.B $00
        DC.B $00
        DC.B $00
        DC.B $E0
        DC.B $03
        DC.B $50
        DC.B $61
        DC.B $64
        DC.B $05
        DC.B $50
        DC.B $72
        DC.B $6F
        DC.B $62
        DC.B $65
        DC.B $09
        DC.B $54
        DC.B $69
        DC.B $63
        DC.B $6B
        DC.B $50
        DC.B $72
        DC.B $6F
        DC.B $62
        DC.B $65
        DC.B $03
        DC.B $31
        DC.B $2E
        DC.B $30
        DC.B $23
        DC.B $41
        DC.B $6E
        DC.B $64
        DC.B $72
        DC.B $65
        DC.B $77
        DC.B $20
        DC.B $43
        DC.B $2E
        DC.B $20
        DC.B $59
        DC.B $6F
        DC.B $75
        DC.B $6E
        DC.B $67
        DC.B $20
        DC.B $3C
        DC.B $61
        DC.B $6E
        DC.B $64
        DC.B $72
        DC.B $65
        DC.B $77
        DC.B $40
        DC.B $76
        DC.B $61
        DC.B $65
        DC.B $6C
        DC.B $65
        DC.B $6E
        DC.B $2E
        DC.B $6F
        DC.B $72
        DC.B $67
        DC.B $3E
        DC.B $27
        DC.B $52
        DC.B $65
        DC.B $61
        DC.B $6C
        DC.B $2D
        DC.B $65
        DC.B $76
        DC.B $65
        DC.B $6E
        DC.B $74
        DC.B $2D
        DC.B $6C
        DC.B $6F
        DC.B $6F
        DC.B $70
        DC.B $20
        DC.B $74
        DC.B $69
        DC.B $6D
        DC.B $65
        DC.B $72
        DC.B $20
        DC.B $72
        DC.B $65
        DC.B $67
        DC.B $72
        DC.B $65
        DC.B $73
        DC.B $73
        DC.B $69
        DC.B $6F
        DC.B $6E
        DC.B $20
        DC.B $70
        DC.B $72
        DC.B $6F
        DC.B $62
        DC.B $65
        DC.B $2E
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_173:
        DC.B $00
        DC.B $00
