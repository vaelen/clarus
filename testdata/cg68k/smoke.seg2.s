        ; func smokeNested  (JT slot 93)
        ;   local lm : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local got : -12(A6)  size 4
        ;   local __store6 : -16(A6)  size 4
LBL_0:
        LINK A6,#-2144
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 378(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 378(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 378(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        JSR 434(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_177
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 418(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_177:
        JSR 114(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 410(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L A1,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        JSR 386(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 258(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 314(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_104(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_178:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_178
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -16(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2100(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 402(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_179
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 450(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2104(A6)
        CLR.L -2108(A6)
LBL_180:
        MOVE.L -2108(A6),D0
        MOVE.L -2104(A6),D1
        CMP.L D1,D0
        BGE.W LBL_179
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2108(A6),D0
        MOVE.L D0,-(A7)
        LEA -2112(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2112(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2108(A6)
        BRA.W LBL_180
LBL_179:
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_181
        BRA.W LBL_182
LBL_181:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_183:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_183
        JSR 50(A5)
LBL_182:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_172
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
        JSR 386(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2100(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 402(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_184
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 450(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2104(A6)
        CLR.L -2108(A6)
LBL_185:
        MOVE.L -2108(A6),D0
        MOVE.L -2104(A6),D1
        CMP.L D1,D0
        BGE.W LBL_184
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2108(A6),D0
        MOVE.L D0,-(A7)
        LEA -2112(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2112(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2108(A6)
        BRA.W LBL_185
LBL_184:
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 418(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_105(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_186:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_186
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -12(A6),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        JSR 434(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_187
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 418(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_187:
        JSR 114(A5)
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
        MOVE.L -32(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 410(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_188
        BRA.W LBL_189
LBL_188:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_167(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_190:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_190
        JSR 50(A5)
LBL_189:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_172
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 418(A5)
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_107(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_191:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_191
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L A1,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2100(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_192
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 314(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2104(A6)
        CLR.L -2108(A6)
LBL_193:
        MOVE.L -2108(A6),D0
        MOVE.L -2104(A6),D1
        CMP.L D1,D0
        BGE.W LBL_192
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2108(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2116(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2116(A6),D0
        MOVE.L D0,-(A7)
        JSR 402(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_194
        MOVE.L A1,-(A7)
        MOVE.L -2116(A6),D0
        MOVE.L D0,-(A7)
        JSR 450(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2120(A6)
        CLR.L -2124(A6)
LBL_195:
        MOVE.L -2124(A6),D0
        MOVE.L -2120(A6),D1
        CMP.L D1,D0
        BGE.W LBL_194
        MOVE.L A1,-(A7)
        MOVE.L -2116(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2124(A6),D0
        MOVE.L D0,-(A7)
        LEA -2128(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2128(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2124(A6)
        BRA.W LBL_195
LBL_194:
        MOVE.L A1,-(A7)
        MOVE.L -2116(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2108(A6)
        BRA.W LBL_193
LBL_192:
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2100(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 402(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_196
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 450(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2104(A6)
        CLR.L -2108(A6)
LBL_197:
        MOVE.L -2108(A6),D0
        MOVE.L -2104(A6),D1
        CMP.L D1,D0
        BGE.W LBL_196
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2108(A6),D0
        MOVE.L D0,-(A7)
        LEA -2112(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2112(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2108(A6)
        BRA.W LBL_197
LBL_196:
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2100(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 402(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_198
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 450(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2104(A6)
        CLR.L -2108(A6)
LBL_199:
        MOVE.L -2108(A6),D0
        MOVE.L -2104(A6),D1
        CMP.L D1,D0
        BGE.W LBL_198
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2108(A6),D0
        MOVE.L D0,-(A7)
        LEA -2112(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVEA.L (A7)+,A1
        LEA -2112(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-2108(A6)
        BRA.W LBL_199
LBL_198:
        MOVE.L A1,-(A7)
        MOVE.L -2100(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_176:
        UNLK A6
        RTS
        ; func smokeFiles  (JT slot 94)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local n : -268(A6)  size 256
        ;   local errMsg : -524(A6)  size 256
        ;   local e : -784(A6)  size 260
        ;   local __store8 : -788(A6)  size 4
        ;   local __store9 : -792(A6)  size 4
LBL_1:
        LINK A6,#-2920
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #0,D0
        MOVE.B D0,-10(A6)
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
        LEA -268(A6),A0
        MOVE.W #127,D0
LBL_201:
        CLR.W (A0)+
        DBRA D0,LBL_201
        LEA -524(A6),A0
        MOVE.W #127,D0
LBL_202:
        CLR.W (A0)+
        DBRA D0,LBL_202
        MOVE.L #0,D0
        MOVE.L D0,-784(A6)
        LEA -780(A6),A0
        MOVE.W #127,D0
LBL_203:
        CLR.W (A0)+
        DBRA D0,LBL_203
        LEA -788(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -792(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -788(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 114(A5)
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_112(PC),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-788(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -788(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-788(A6)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_115(PC),A0
        MOVE.L A0,-(A7)
        JSR 594(A5)
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_116(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_204:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_204
        JSR 674(A5)
        ADDA.W #258,A7
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_117(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_205:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_205
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_112(PC),A0
        MOVE.L A0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_118(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_206:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_206
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -792(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 114(A5)
        MOVE.L D0,-796(A6)
        MOVE.L -796(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
        MOVE.L -796(A6),D0
        MOVE.L D0,-792(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -792(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-792(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #66,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_115(PC),A0
        MOVE.L A0,-(A7)
        JSR 594(A5)
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_121(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_207:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_207
        JSR 674(A5)
        ADDA.W #258,A7
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_122(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_208:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_208
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_209
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_209:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #65,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_210
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_210:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_211
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_211:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_212
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_212:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_213
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_213:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #66,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_214
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_214:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_123(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_215:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_215
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_124(PC),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_125(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_126(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_216:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_216
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_128(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_217:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_217
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 610(A5)
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_130(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_218:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_218
        JSR 674(A5)
        ADDA.W #258,A7
        LEA LBL_131(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_219:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_219
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        JSR 762(A5)
        ADDA.W #260,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_133(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_220:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_220
        JSR 674(A5)
        ADDA.W #258,A7
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        EORI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_135(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_221:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_221
        JSR 674(A5)
        ADDA.W #258,A7
        JSR 554(A5)
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_136(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_222:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_222
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDQ.L #4,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_20(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_137(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_223:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_223
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -784(A6),A0
        MOVEA.L A0,A1
        JSR 554(A5)
        MOVE.L D0,0(A1)
        LEA 4(A1),A0
        MOVE.L A0,-(A7)
        JSR 562(A5)
        ADDQ.L #4,A7
        LEA -784(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_138(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_224:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_224
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -784(A6),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_20(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_139(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_225:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_225
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_200:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 95)
        ;   local p : -48(A6)  size 48
        ;   local __store11 : -96(A6)  size 48
        ;   local q : -144(A6)  size 48
        ;   local e : -148(A6)  size 4
        ;   local n : -152(A6)  size 4
        ;   local __store12 : -200(A6)  size 48
        ;   local __store13 : -248(A6)  size 48
LBL_2:
        LINK A6,#-2376
        MOVE.L #3,D0
        MOVE.L D0,-48(A6)
        MOVE.L #4,D0
        MOVE.L D0,-44(A6)
        MOVE.L #5,D0
        MOVE.L D0,-40(A6)
        MOVE.L #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_227:
        CLR.W (A0)+
        DBRA D0,LBL_227
        MOVE.L #3,D0
        MOVE.L D0,-96(A6)
        MOVE.L #4,D0
        MOVE.L D0,-92(A6)
        MOVE.L #5,D0
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-84(A6)
        LEA -80(A6),A0
        MOVE.W #15,D0
LBL_228:
        CLR.W (A0)+
        DBRA D0,LBL_228
        MOVE.L #3,D0
        MOVE.L D0,-144(A6)
        MOVE.L #4,D0
        MOVE.L D0,-140(A6)
        MOVE.L #5,D0
        MOVE.L D0,-136(A6)
        MOVE.L #0,D0
        MOVE.L D0,-132(A6)
        LEA -128(A6),A0
        MOVE.W #15,D0
LBL_229:
        CLR.W (A0)+
        DBRA D0,LBL_229
        MOVE.L #0,D0
        MOVE.L D0,-148(A6)
        MOVE.L #0,D0
        MOVE.L D0,-152(A6)
        MOVE.L #3,D0
        MOVE.L D0,-200(A6)
        MOVE.L #4,D0
        MOVE.L D0,-196(A6)
        MOVE.L #5,D0
        MOVE.L D0,-192(A6)
        MOVE.L #0,D0
        MOVE.L D0,-188(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_230:
        CLR.W (A0)+
        DBRA D0,LBL_230
        MOVE.L #3,D0
        MOVE.L D0,-248(A6)
        MOVE.L #4,D0
        MOVE.L D0,-244(A6)
        MOVE.L #5,D0
        MOVE.L D0,-240(A6)
        MOVE.L #0,D0
        MOVE.L D0,-236(A6)
        LEA -232(A6),A0
        MOVE.W #15,D0
LBL_231:
        CLR.W (A0)+
        DBRA D0,LBL_231
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L #3,D0
        MOVE.L D0,0(A0)
        MOVEA.L A1,A0
        MOVE.L #4,D0
        MOVE.L D0,4(A0)
        MOVEA.L A1,A0
        MOVE.L #5,D0
        MOVE.L D0,8(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L #0,D0
        MOVE.L D0,12(A0)
        MOVEA.L A1,A0
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_232:
        CLR.W (A0)+
        DBRA D0,LBL_232
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_233:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_233
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_144(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_234:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_234
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_145(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_235:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_235
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_146(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_236:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_236
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_147(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_237:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_237
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_148(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_238:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_238
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_149(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_239:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_239
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L #10,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
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
        MOVE.L #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_151(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_240:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_240
        JSR 674(A5)
        ADDA.W #258,A7
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
        LEA LBL_152(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_241:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_241
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_153(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_242:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_242
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -200(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_243:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_243
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_170
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -200(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_244:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_244
        MOVE.L #99,D0
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
        MOVE.L #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_154(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_245:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_245
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_155(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_246:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_246
        JSR 674(A5)
        ADDA.W #258,A7
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
        LEA LBL_156(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_247:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_247
        JSR 674(A5)
        ADDA.W #258,A7
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
        LEA LBL_157(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_248:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_248
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -248(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        JSR 682(A5)
        ADDQ.L #8,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_249:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_249
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_158(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_250:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_250
        JSR 674(A5)
        ADDA.W #258,A7
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
        LEA LBL_159(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_251:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_251
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        ADDA.L #-48,A7
        MOVEA.L A7,A1
        MOVE.W #23,D0
LBL_252:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_252
        JSR 690(A5)
        ADDA.W #48,A7
        MOVE.L D0,-152(A6)
        MOVE.L -152(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L D0,D1
        MOVE.L #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #555,D0
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_160(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_253:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_253
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L #6,D0
        MOVE.L D0,D1
        LEA LBL_169(PC),A0
        MOVE.W #2,D2
LBL_255:
        CMP.L (A0)+,D1
        BEQ.W LBL_254
        DBRA D2,LBL_255
        ; enum conversion miss -> rtEnumCheck(v, false, <name arg unused>) panics
        MOVE.L D1,-(A7)
        CLR.W -(A7)
        ADDA.L #-256,A7
        JSR 74(A5)
        ADDA.W #262,A7
LBL_254:
        MOVE.L D0,-148(A6)
        MOVE.L -148(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_161(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_256:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_256
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L -148(A6),D0
        MOVE.L D0,D1
        MOVE.L #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_162(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_257:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_257
        JSR 674(A5)
        ADDA.W #258,A7
        JSR 698(A5)
        JSR 706(A5)
        JSR 714(A5)
        JSR 722(A5)
        JSR 730(A5)
        BSR.W LBL_0
        JSR 738(A5)
        LEA LBL_163(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_258:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_258
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        JSR 754(A5)
        ADDA.W #260,A7
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_164(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_165(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_259:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_259
        JSR 674(A5)
        ADDA.W #258,A7
        BSR.W LBL_1
        JSR 770(A5)
        LEA LBL_166(PC),A0
        MOVE.L A0,-(A7)
        JSR 514(A5)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_175
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_171
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_226:
        UNLK A6
        RTS
LBL_172:
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
LBL_173:
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
        BPL.W LBL_260
        NEG.L D2
        MOVE.L #1,D4
LBL_260:
        CLR.L D5
        TST.L D3
        BPL.W LBL_261
        NEG.L D3
        MOVE.L #1,D5
LBL_261:
        CLR.L D6
        MOVE.W #31,D7
LBL_262:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_263
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_263:
        DBRA D7,LBL_262
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_264
        NEG.L D2
LBL_264:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_174:
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
        BPL.W LBL_265
        NEG.L D2
        MOVE.L #1,D4
LBL_265:
        CLR.L D5
        TST.L D3
        BPL.W LBL_266
        NEG.L D3
        MOVE.L #1,D5
LBL_266:
        CLR.L D6
        MOVE.W #31,D7
LBL_267:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_268
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_268:
        DBRA D7,LBL_267
        TST.L D4
        BEQ.W LBL_269
        NEG.L D6
LBL_269:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_175:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
LBL_270:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_170:
        ; cg_retain_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_171:
        ; cg_release_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_3:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_4:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_5:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_6:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_7:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_8:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_9:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_10:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_11:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_12:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_13:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_14:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_15:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_16:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_17:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_18:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_19:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_20:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_21:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_22:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_23:
        DC.B $05
        DC.B $50,$41,$53,$53,$20
LBL_24:
        DC.B $05
        DC.B $46,$41,$49,$4C,$20
LBL_25:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
LBL_26:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$69,$72,$73,$74
        DC.B $00
LBL_27:
        DC.B $0D
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$6C,$61,$73,$74
LBL_28:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
LBL_29:
        DC.B $12
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
        DC.B $00
LBL_30:
        DC.B $10
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_31:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$75,$6E,$73,$68,$69,$66,$74
        DC.B $00
LBL_32:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
LBL_33:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
        DC.B $00
LBL_34:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
LBL_35:
        DC.B $18
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
        DC.B $00
LBL_36:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_37:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_38:
        DC.B $15
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$73,$75,$6D
LBL_39:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_40:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_41:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_42:
        DC.B $05
        DC.B $67,$61,$6D,$6D,$61
LBL_43:
        DC.B $1A
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$75,$73,$68
        DC.B $00
LBL_44:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$66,$69,$72,$73,$74
LBL_45:
        DC.B $0E
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$6C,$61,$73,$74
        DC.B $00
LBL_46:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$72,$65,$61,$64
        DC.B $00
LBL_47:
        DC.B $04
        DC.B $42,$45,$54,$41
        DC.B $00
LBL_48:
        DC.B $13
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$73,$65,$74
LBL_49:
        DC.B $16
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$73,$68,$69,$66,$74,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_50:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$68,$69,$66,$74
LBL_51:
        DC.B $14
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$70,$6F,$70,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_52:
        DC.B $19
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$70,$6F,$70
LBL_53:
        DC.B $1C
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_54:
        DC.B $04
        DC.B $73,$6F,$6C,$6F
        DC.B $00
LBL_55:
        DC.B $03
        DC.B $64,$75,$6F
LBL_56:
        DC.B $1D
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70,$20,$63,$6F,$75,$6E,$74
LBL_57:
        DC.B $23
        DC.B $6C,$69,$73,$74,$20,$74,$65,$78,$74,$20,$76,$61,$6C,$75,$65,$20,$61,$66,$74,$65,$72,$20,$64,$69,$73,$63,$61,$72,$64,$65,$64,$20,$70,$6F,$70
LBL_58:
        DC.B $03
        DC.B $6F,$6E,$65
LBL_59:
        DC.B $03
        DC.B $74,$77,$6F
LBL_60:
        DC.B $05
        DC.B $74,$68,$72,$65,$65
LBL_61:
        DC.B $17
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
LBL_62:
        DC.B $15
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
LBL_63:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_64:
        DC.B $04
        DC.B $66,$6F,$75,$72
        DC.B $00
LBL_65:
        DC.B $12
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_66:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
        DC.B $00
LBL_67:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
LBL_68:
        DC.B $11
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
LBL_69:
        DC.B $1A
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_70:
        DC.B $18
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$68,$61,$73,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
        DC.B $00
LBL_71:
        DC.B $0B
        DC.B $6E,$6F,$6E,$65,$78,$69,$73,$74,$65,$6E,$74
LBL_72:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$72,$65,$6D,$6F,$76,$65,$2D,$61,$62,$73,$65,$6E,$74,$20,$6E,$6F,$2D,$6F,$70
LBL_73:
        DC.B $13
        DC.B $6D,$61,$70,$20,$69,$6E,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$73,$75,$6D
LBL_74:
        DC.B $01
        DC.B $61
LBL_75:
        DC.B $05
        DC.B $61,$70,$70,$6C,$65
LBL_76:
        DC.B $01
        DC.B $62
LBL_77:
        DC.B $06
        DC.B $62,$61,$6E,$61,$6E,$61
        DC.B $00
LBL_78:
        DC.B $18
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$73,$65,$74
        DC.B $00
LBL_79:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$73,$75,$62,$73,$63,$72,$69,$70,$74,$20,$67,$65,$74
        DC.B $00
LBL_80:
        DC.B $01
        DC.B $7A
LBL_81:
        DC.B $04
        DC.B $6E,$6F,$6E,$65
        DC.B $00
LBL_82:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$61,$62,$73,$65,$6E,$74
LBL_83:
        DC.B $1C
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$67,$65,$74,$2D,$64,$65,$66,$61,$75,$6C,$74,$20,$70,$72,$65,$73,$65,$6E,$74
        DC.B $00
LBL_84:
        DC.B $07
        DC.B $61,$76,$6F,$63,$61,$64,$6F
LBL_85:
        DC.B $12
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$6F,$76,$65,$72,$77,$72,$69,$74,$65
        DC.B $00
LBL_86:
        DC.B $1B
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$63,$6F,$75,$6E,$74,$20,$61,$66,$74,$65,$72,$20,$72,$65,$6D,$6F,$76,$65
LBL_87:
        DC.B $16
        DC.B $6D,$61,$70,$20,$74,$65,$78,$74,$20,$66,$6F,$72,$2D,$6D,$61,$70,$20,$76,$61,$6C,$75,$65
        DC.B $00
LBL_88:
        DC.B $05
        DC.B $68,$65,$6C,$6C,$6F
LBL_89:
        DC.B $07
        DC.B $2C,$20,$77,$6F,$72,$6C,$64
LBL_90:
        DC.B $0C
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64
        DC.B $00
LBL_91:
        DC.B $0F
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$73,$74,$72
LBL_92:
        DC.B $0D
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21
LBL_93:
        DC.B $10
        DC.B $74,$65,$78,$74,$20,$61,$70,$70,$65,$6E,$64,$20,$63,$68,$61,$72
        DC.B $00
LBL_94:
        DC.B $08
        DC.B $20,$28,$61,$67,$61,$69,$6E,$29
        DC.B $00
LBL_95:
        DC.B $15
        DC.B $68,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21,$20,$28,$61,$67,$61,$69,$6E,$29
LBL_96:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74
LBL_97:
        DC.B $23
        DC.B $74,$65,$78,$74,$20,$63,$6F,$6E,$63,$61,$74,$20,$6C,$65,$61,$76,$65,$73,$20,$73,$6F,$75,$72,$63,$65,$20,$75,$6E,$63,$68,$61,$6E,$67,$65,$64
LBL_98:
        DC.B $0B
        DC.B $74,$65,$78,$74,$20,$6C,$65,$6E,$67,$74,$68
LBL_99:
        DC.B $0E
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$65,$71,$75,$61,$6C
        DC.B $00
LBL_100:
        DC.B $04
        DC.B $6E,$6F,$70,$65
        DC.B $00
LBL_101:
        DC.B $12
        DC.B $74,$65,$78,$74,$20,$63,$6D,$70,$20,$6E,$6F,$74,$2D,$65,$71,$75,$61,$6C
        DC.B $00
LBL_102:
        DC.B $01
        DC.B $6B
LBL_103:
        DC.B $02
        DC.B $76,$31
        DC.B $00
LBL_104:
        DC.B $18
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$63,$6F,$75,$6E,$74
        DC.B $00
LBL_105:
        DC.B $17
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$72,$65,$61,$64
LBL_106:
        DC.B $02
        DC.B $76,$32
        DC.B $00
LBL_107:
        DC.B $26
        DC.B $6E,$65,$73,$74,$65,$64,$20,$6C,$69,$73,$74,$2D,$6F,$66,$2D,$6D,$61,$70,$20,$61,$6C,$69,$61,$73,$69,$6E,$67,$20,$28,$73,$61,$6D,$65,$20,$6D,$61,$70,$29
        DC.B $00
LBL_108:
        DC.B $25
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$6D,$75,$74,$61,$74,$65,$20,$76,$69,$61,$20,$62,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
LBL_109:
        DC.B $1E
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$76,$61,$6C,$75,$65,$20,$76,$69,$73,$69,$62,$6C,$65,$20,$74,$68,$72,$6F,$75,$67,$68,$20,$61
        DC.B $00
LBL_110:
        DC.B $21
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$20,$62,$20,$74,$6F,$20,$61,$20,$66,$72,$65,$73,$68,$20,$6C,$69,$73,$74
LBL_111:
        DC.B $27
        DC.B $61,$6C,$69,$61,$73,$3A,$20,$72,$65,$61,$73,$73,$69,$67,$6E,$69,$6E,$67,$20,$62,$20,$6C,$65,$61,$76,$65,$73,$20,$61,$20,$75,$6E,$74,$6F,$75,$63,$68,$65,$64
LBL_112:
        DC.B $0A
        DC.B $68,$65,$6C,$6C,$6F,$20,$66,$69,$6C,$65
        DC.B $00
LBL_113:
        DC.B $0D
        DC.B $73,$6D,$6F,$6B,$65,$66,$69,$6C,$65,$2E,$74,$78,$74
LBL_114:
        DC.B $04
        DC.B $54,$45,$58,$54
        DC.B $00
LBL_115:
        DC.B $04
        DC.B $3F,$3F,$3F,$3F
        DC.B $00
LBL_116:
        DC.B $11
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$6F,$6B
LBL_117:
        DC.B $10
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6F,$6B
        DC.B $00
LBL_118:
        DC.B $1D
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
LBL_119:
        DC.B $00
        DC.B $00
LBL_120:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$6E,$2E,$64,$61,$74
        DC.B $00
LBL_121:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
        DC.B $00
LBL_122:
        DC.B $17
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$62,$69,$6E,$61,$72,$79,$20,$6F,$6B
LBL_123:
        DC.B $1B
        DC.B $66,$69,$6C,$65,$20,$62,$69,$6E,$61,$72,$79,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70,$20,$62,$79,$74,$65,$73
LBL_124:
        DC.B $09
        DC.B $61,$2F,$62,$2F,$63,$2E,$74,$78,$74
LBL_125:
        DC.B $05
        DC.B $63,$2E,$74,$78,$74
LBL_126:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$62,$61,$73,$65,$6E,$61,$6D,$65
        DC.B $00
LBL_127:
        DC.B $08
        DC.B $73,$6F,$6C,$6F,$2E,$74,$78,$74
        DC.B $00
LBL_128:
        DC.B $12
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$6E,$6F,$2D,$73,$6C,$61,$73,$68
        DC.B $00
LBL_129:
        DC.B $04
        DC.B $64,$69,$72,$2F
        DC.B $00
LBL_130:
        DC.B $18
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$74,$72,$61,$69,$6C,$69,$6E,$67,$20,$73,$6C,$61,$73,$68
        DC.B $00
LBL_131:
        DC.B $09
        DC.B $78,$2F,$79,$2F,$7A,$2E,$74,$78,$74
LBL_132:
        DC.B $05
        DC.B $7A,$2E,$74,$78,$74
LBL_133:
        DC.B $14
        DC.B $66,$69,$6C,$65,$20,$6E,$61,$6D,$65,$20,$76,$69,$61,$20,$72,$65,$74,$75,$72,$6E
        DC.B $00
LBL_134:
        DC.B $18
        DC.B $73,$6D,$6F,$6B,$65,$2D,$64,$6F,$65,$73,$2D,$6E,$6F,$74,$2D,$65,$78,$69,$73,$74,$2E,$74,$78,$74
        DC.B $00
LBL_135:
        DC.B $23
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$72,$65,$74,$75,$72,$6E,$73,$20,$66,$61,$6C,$73,$65
LBL_136:
        DC.B $24
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$63,$6F,$64,$65
        DC.B $00
LBL_137:
        DC.B $27
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$6D,$69,$73,$73,$69,$6E,$67,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$20,$6D,$65,$73,$73,$61,$67,$65
LBL_138:
        DC.B $25
        DC.B $65,$72,$72,$6F,$72,$20,$6C,$6F,$63,$61,$6C,$20,$63,$6F,$70,$79,$20,$28,$65,$20,$3D,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$29,$20,$63,$6F,$64,$65
LBL_139:
        DC.B $28
        DC.B $65,$72,$72,$6F,$72,$20,$6C,$6F,$63,$61,$6C,$20,$63,$6F,$70,$79,$20,$28,$65,$20,$3D,$20,$6C,$61,$73,$74,$45,$72,$72,$6F,$72,$29,$20,$6D,$65,$73,$73,$61,$67,$65
        DC.B $00
LBL_140:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$67,$2E,$64,$61,$74
        DC.B $00
LBL_141:
        DC.B $16
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
        DC.B $00
LBL_142:
        DC.B $15
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
LBL_143:
        DC.B $22
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
        DC.B $00
LBL_144:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_145:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$79
        DC.B $00
LBL_146:
        DC.B $11
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_147:
        DC.B $17
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
LBL_148:
        DC.B $18
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_149:
        DC.B $1B
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_150:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_151:
        DC.B $0B
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$78
LBL_152:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
        DC.B $00
LBL_153:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$73,$74,$72
        DC.B $00
LBL_154:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$78
LBL_155:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$78
LBL_156:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_157:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_158:
        DC.B $17
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
LBL_159:
        DC.B $13
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$66,$69,$65,$6C,$64
LBL_160:
        DC.B $15
        DC.B $72,$65,$63,$6F,$72,$64,$20,$70,$61,$72,$61,$6D,$20,$62,$79,$20,$76,$61,$6C,$75,$65
LBL_161:
        DC.B $14
        DC.B $65,$6E,$75,$6D,$20,$69,$6E,$74,$2D,$3E,$65,$6E,$75,$6D,$20,$76,$61,$6C,$69,$64
        DC.B $00
LBL_162:
        DC.B $18
        DC.B $65,$6E,$75,$6D,$20,$65,$6E,$75,$6D,$2D,$3E,$69,$6E,$74,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70
        DC.B $00
LBL_163:
        DC.B $06
        DC.B $61,$62,$63,$64,$65,$66
        DC.B $00
LBL_164:
        DC.B $03
        DC.B $61,$62,$63
LBL_165:
        DC.B $1C
        DC.B $73,$74,$72,$69,$6E,$67,$28,$33,$29,$2D,$72,$65,$74,$75,$72,$6E,$20,$41,$42,$49,$20,$70,$61,$74,$68,$20,$6F,$6B
        DC.B $00
LBL_166:
        DC.B $0A
        DC.B $73,$6D,$6F,$6B,$65,$20,$64,$6F,$6E,$65
        DC.B $00
LBL_167:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_168:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
LBL_169:
        DC.L $00000005
        DC.L $00000006
        DC.L $00000007
        ; constant pool: serdesc tables
