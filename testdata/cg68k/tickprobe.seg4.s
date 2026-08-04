        ; func rtUiParseInt  (JT slot 331)
        ;   param p : 16(A6)  size 4
        ;   param len : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local neg : -6(A6)  size 2
        ;   local v : -10(A6)  size 4
        ;   local anyDigit : -12(A6)  size 2
        ;   local c : -16(A6)  size 4
LBL_0:
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
        BEQ.W LBL_166
        MOVE.L #0,D0
        BRA.W LBL_165
LBL_166:
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
        BEQ.W LBL_167
        MOVE.L #1,D0
        MOVE.B D0,-6(A6)
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
LBL_167:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_168
        MOVE.L #0,D0
        BRA.W LBL_165
LBL_168:
        MOVE.L #0,D0
        MOVE.L D0,-10(A6)
        MOVE.L #0,D0
        MOVE.B D0,-12(A6)
LBL_169:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_170
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
        BNE.W LBL_171
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_172
LBL_171:
        MOVE.L #1,D0
LBL_172:
        TST.L D0
        BEQ.W LBL_173
        MOVE.L #0,D0
        BRA.W LBL_165
LBL_173:
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
        BSR.W LBL_162
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_174
        MOVE.L #0,D0
        BRA.W LBL_165
LBL_174:
        MOVE.L -10(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
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
        BRA.W LBL_169
LBL_170:
        CLR.L D0
        MOVE.B -12(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_175
        MOVE.L #0,D0
        BRA.W LBL_165
LBL_175:
        CLR.L D0
        MOVE.B -6(A6),D0
        TST.L D0
        BEQ.W LBL_176
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
        BRA.W LBL_177
LBL_176:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -10(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_177:
        MOVE.L #1,D0
        BRA.W LBL_165
LBL_165:
        UNLK A6
        RTS
        ; func rtUiParseFixed  (JT slot 332)
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
LBL_1:
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
        BEQ.W LBL_179
        MOVE.L #0,D0
        BRA.W LBL_178
LBL_179:
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
        BEQ.W LBL_180
        MOVE.L #1,D0
        MOVE.B D0,-14(A6)
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
LBL_180:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
        MOVE.L #0,D0
        BRA.W LBL_178
LBL_181:
        MOVE.L #0,D0
        MOVE.B D0,-24(A6)
LBL_182:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
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
        BEQ.W LBL_184
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_185
LBL_184:
        MOVE.L #0,D0
LBL_185:
        TST.L D0
        BEQ.W LBL_186
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_187
LBL_186:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_188
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_189
LBL_188:
        MOVE.L #1,D0
LBL_189:
        TST.L D0
        BEQ.W LBL_190
        MOVE.L #0,D0
        BRA.W LBL_178
        BRA.W LBL_191
LBL_190:
        MOVE.L #1,D0
        MOVE.B D0,-24(A6)
LBL_191:
LBL_187:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_182
LBL_183:
        CLR.L D0
        MOVE.B -24(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_192
        MOVE.L #0,D0
        BRA.W LBL_178
LBL_192:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_193
        MOVE.L -8(A6),D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_194
LBL_193:
        MOVE.L 12(A6),D0
        MOVE.L D0,-32(A6)
LBL_194:
        MOVE.L #0,D0
        MOVE.L D0,-18(A6)
        CLR.L D0
        MOVE.B -14(A6),D0
        TST.L D0
        BEQ.W LBL_195
        MOVE.L #1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_196
LBL_195:
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
LBL_196:
LBL_197:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_198
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
        BSR.W LBL_162
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_199
        MOVE.L #0,D0
        BRA.W LBL_178
LBL_199:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
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
        BRA.W LBL_197
LBL_198:
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
        BEQ.W LBL_200
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
LBL_201:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_202
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
        BSR.W LBL_161
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_162
        MOVE.L D0,-22(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_201
LBL_202:
LBL_200:
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
        BEQ.W LBL_203
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
        BRA.W LBL_204
LBL_203:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_204:
        MOVE.L #1,D0
        BRA.W LBL_178
LBL_178:
        UNLK A6
        RTS
        ; func rtUiFormCharOk  (JT slot 333)
        ;   param te : 16(A6)  size 4
        ;   param ch : 12(A6)  size 4
        ;   param ftype : 8(A6)  size 4
        ;   local teMp : -4(A6)  size 4
        ;   local th : -8(A6)  size 4
        ;   local thMp : -12(A6)  size 4
        ;   local len : -16(A6)  size 4
        ;   local i : -20(A6)  size 4
        ;   local first : -24(A6)  size 4
LBL_2:
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
        BEQ.W LBL_206
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #57,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        BRA.W LBL_207
LBL_206:
        MOVE.L #0,D0
LBL_207:
        TST.L D0
        BEQ.W LBL_208
        MOVE.L #1,D0
        BRA.W LBL_205
LBL_208:
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
        BEQ.W LBL_209
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
        BEQ.W LBL_210
        MOVE.L #0,D0
        BRA.W LBL_205
LBL_210:
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
        BEQ.W LBL_211
        MOVE.L #1,D0
        BRA.W LBL_205
LBL_211:
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
        BRA.W LBL_205
LBL_209:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #46,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_212
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_213
LBL_212:
        MOVE.L #0,D0
LBL_213:
        TST.L D0
        BEQ.W LBL_214
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
LBL_215:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_216
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
        BEQ.W LBL_217
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVE.L #0,D0
        BRA.W LBL_205
LBL_217:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_215
LBL_216:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A02A  ; UiHUnlock
        MOVE.L #1,D0
        BRA.W LBL_205
LBL_214:
        MOVE.L #0,D0
        BRA.W LBL_205
LBL_205:
        UNLK A6
        RTS
        ; func rtUiFormFill  (JT slot 334)
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
LBL_3:
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
        JSR 514(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 874(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 890(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 882(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        JSR 1602(A5)
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
LBL_219:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_220
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1026(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1034(A5)
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
        JSR 530(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1554(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
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
        BEQ.W LBL_221
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_222
LBL_221:
        MOVE.L #0,D0
LBL_222:
        TST.L D0
        BEQ.W LBL_223
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_225
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1042(A5)
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
        BEQ.W LBL_227
        MOVE.L -76(A6),D0
        MOVE.L D0,-80(A6)
LBL_227:
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
        BRA.W LBL_226
LBL_225:
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_228
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        MOVE.L (A7)+,D0
        DC.W $A9EE  ; UiNumToString
        BRA.W LBL_229
LBL_228:
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_230
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 2042(A5)
        ADDQ.L #8,A7
        BRA.W LBL_231
LBL_230:
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_232
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
        BEQ.W LBL_234
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
        BRA.W LBL_235
LBL_234:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_235:
        BRA.W LBL_233
LBL_232:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_233:
LBL_231:
LBL_229:
LBL_226:
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
        BRA.W LBL_224
LBL_223:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_236
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_237
LBL_236:
        MOVE.L #0,D0
LBL_237:
        TST.L D0
        BEQ.W LBL_238
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_240
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_241
LBL_240:
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_241:
        BRA.W LBL_239
LBL_238:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_242
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1050(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1066(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVE.L #0,D0
        MOVE.L D0,-92(A6)
        MOVE.L #0,D0
        MOVE.L D0,-96(A6)
LBL_243:
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -84(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_244
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 1090(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_245
        MOVE.L -96(A6),D0
        MOVE.L D0,-92(A6)
        MOVE.L -84(A6),D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_246
LBL_245:
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
LBL_246:
        BRA.W LBL_243
LBL_244:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        JSR 2018(A5)
        ADDA.W #12,A7
LBL_242:
LBL_239:
LBL_224:
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_219
LBL_220:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_218:
        UNLK A6
        RTS
        ; func rtUiFormAccept  (JT slot 335)
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
LBL_4:
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
        JSR 514(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 874(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 890(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 882(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1010(A5)
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
LBL_248:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_249
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 914(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1026(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1034(A5)
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
        BEQ.W LBL_250
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1658(A5)
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
        BSR.W LBL_0
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_252
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2650(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_247
LBL_252:
        BRA.W LBL_251
LBL_250:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_253
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1658(A5)
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
        BSR.W LBL_1
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2650(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_247
LBL_255:
        BRA.W LBL_254
LBL_253:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_256
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1658(A5)
        ADDA.W #16,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1042(A5)
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
        BEQ.W LBL_258
        MOVE.L -62(A6),D0
        MOVE.L D0,-66(A6)
LBL_258:
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
LBL_259:
        MOVE.L -70(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -62(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_260
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
        BRA.W LBL_259
LBL_260:
        BRA.W LBL_257
LBL_256:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
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
        BEQ.W LBL_263
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
        BRA.W LBL_264
LBL_263:
        MOVE.L #0,D0
LBL_264:
        TST.L D0
        BEQ.W LBL_265
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_266
LBL_265:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_266:
        BRA.W LBL_262
LBL_261:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 1658(A5)
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
        BEQ.W LBL_269
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
        BRA.W LBL_270
LBL_269:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_270:
        BRA.W LBL_268
LBL_267:
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_271
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2010(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-78(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1050(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-82(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1066(A5)
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
        BEQ.W LBL_274
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_275
LBL_274:
        MOVE.L #0,D0
LBL_275:
        TST.L D0
        BEQ.W LBL_272
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -82(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_273
LBL_272:
        MOVE.L #0,D0
LBL_273:
        TST.L D0
        BEQ.W LBL_276
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 1090(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        BRA.W LBL_277
LBL_276:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_277:
LBL_271:
LBL_268:
LBL_262:
LBL_257:
LBL_254:
LBL_251:
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_248
LBL_249:
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
        BEQ.W LBL_278
        MOVE.L -132(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_280
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
LBL_280:
        BRA.W LBL_279
LBL_278:
        MOVE.L -128(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        MOVE.L -136(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        MOVE.L -140(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_286
LBL_285:
        MOVE.L #0,D0
LBL_286:
        TST.L D0
        BEQ.W LBL_283
        MOVE.L -140(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -136(A5),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_284
LBL_283:
        MOVE.L #0,D0
LBL_284:
        TST.L D0
        BEQ.W LBL_287
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -136(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -140(A5),D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_287:
        BRA.W LBL_282
LBL_281:
        MOVE.L -128(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_288
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_289
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -122(A5),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDA.W #12,A7
LBL_289:
LBL_288:
LBL_282:
LBL_279:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_290:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_290
        JSR 2298(A5)
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
        BSR.W LBL_37
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2658(A5)
        ADDQ.L #4,A7
LBL_247:
        UNLK A6
        RTS
        ; func rtUiEdit  (JT slot 336)
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
LBL_5:
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
        BEQ.W LBL_292
        LEA LBL_136(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_293:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_293
        JSR 50(A5)
        ADDA.W #256,A7
LBL_292:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 514(A5)
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
        BEQ.W LBL_294
        LEA LBL_137(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_295:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_295
        JSR 50(A5)
        ADDA.W #256,A7
LBL_294:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 874(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1010(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1098(A5)
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
        BEQ.W LBL_296
        MOVE.L #1,D0
        MOVE.B D0,-124(A5)
        BRA.W LBL_297
LBL_296:
        MOVE.L #0,D0
        MOVE.B D0,-124(A5)
LBL_297:
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
        BEQ.W LBL_298
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; UiNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-148(A5)
LBL_298:
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
        BEQ.W LBL_299
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_300
LBL_299:
        MOVE.L #0,D0
LBL_300:
        TST.L D0
        BEQ.W LBL_301
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
        BEQ.W LBL_302
        MOVE.L #255,D0
        MOVE.L D0,-28(A6)
LBL_302:
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
LBL_301:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-114(A5)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #4,A7
LBL_291:
        UNLK A6
        RTS
        ; func rtUiFormIsNew  (JT slot 337)
LBL_6:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -110(A5),D0
        TST.L D0
        BEQ.W LBL_304
        CLR.L D0
        MOVE.B -124(A5),D0
        BRA.W LBL_303
LBL_304:
        MOVE.L #0,D0
        BRA.W LBL_303
LBL_303:
        UNLK A6
        RTS
        ; func rtUiAskOpen  (JT slot 338)
        ;   param path255 : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_7:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_306
        JSR 2218(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
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
        BEQ.W LBL_307
        LEA LBL_138(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_308:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_308
        JSR 2618(A5)
        ADDA.W #256,A7
        MOVE.L D0,-(A7)
        JSR 2258(A5)
        ADDQ.L #4,A7
        MOVE.L #0,D0
        BRA.W LBL_305
LBL_307:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_309
        LEA LBL_139(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_310:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_310
        JSR 50(A5)
        ADDA.W #256,A7
        MOVE.L #0,D0
        BRA.W LBL_305
LBL_309:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1626(A5)
        ADDQ.L #8,A7
        LEA LBL_140(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_311:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_311
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2410(A5)
        ADDA.W #260,A7
        MOVE.L #1,D0
        BRA.W LBL_305
LBL_306:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2634(A5)
        ADDQ.L #4,A7
        BRA.W LBL_305
LBL_305:
        UNLK A6
        RTS
        ; func rtUiAskSave  (JT slot 339)
        ;   param path255 : 12(A6)  size 4
        ;   param suggested : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_8:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -40(A5),D0
        TST.L D0
        BEQ.W LBL_313
        JSR 2218(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
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
        BEQ.W LBL_314
        LEA LBL_141(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_315:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_315
        JSR 2618(A5)
        ADDA.W #256,A7
        MOVE.L D0,-(A7)
        JSR 2258(A5)
        ADDQ.L #4,A7
        MOVE.L #0,D0
        BRA.W LBL_312
LBL_314:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_316
        LEA LBL_142(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_317:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_317
        JSR 50(A5)
        ADDA.W #256,A7
        MOVE.L #0,D0
        BRA.W LBL_312
LBL_316:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #256,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 1626(A5)
        ADDQ.L #8,A7
        LEA LBL_143(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_318:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_318
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2410(A5)
        ADDA.W #260,A7
        MOVE.L #1,D0
        BRA.W LBL_312
LBL_313:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 2642(A5)
        ADDQ.L #8,A7
        BRA.W LBL_312
LBL_312:
        UNLK A6
        RTS
        ; func rtUiAskSaveChanges  (JT slot 340)
        ;   param name : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local empty : -16(A6)  size 4
        ;   local item : -20(A6)  size 4
        ;   local t : -24(A6)  size 4
LBL_9:
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
        BEQ.W LBL_320
        JSR 2218(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -46(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
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
        BEQ.W LBL_321
        LEA LBL_144(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_322:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_322
        JSR 50(A5)
        ADDA.W #256,A7
        MOVE.L #0,D0
        BRA.W LBL_319
LBL_321:
        MOVE.L -50(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        JSR 98(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_145(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_111(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        BRA.W LBL_324
LBL_323:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_112(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        BRA.W LBL_326
LBL_325:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
LBL_326:
LBL_324:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2258(A5)
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        BRA.W LBL_319
LBL_320:
        JSR 1250(A5)
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
        BRA.W LBL_319
LBL_319:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 341)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_10:
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
LBL_328:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_329
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
        BEQ.W LBL_330
        MOVE.L #10,D0
        MOVE.L D0,-12(A6)
LBL_330:
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
        BRA.W LBL_328
LBL_329:
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
        BRA.W LBL_327
LBL_327:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 342)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
LBL_11:
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
        BEQ.W LBL_332
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,12(A6)
LBL_332:
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
        BEQ.W LBL_333
        MOVE.L -160(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_334
LBL_333:
LBL_335:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_336
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_163
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
        BSR.W LBL_162
        MOVE.L D0,12(A6)
        MOVE.L -6(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_335
LBL_336:
LBL_334:
        MOVE.L #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_337
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L #1,D0
        MOVE.L D0,-14(A6)
LBL_337:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_338:
        MOVE.L -18(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_339
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
        BRA.W LBL_338
LBL_339:
        MOVE.L -14(A6),D0
        BRA.W LBL_331
LBL_331:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 343)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_12:
        LINK A6,#-2128
        MOVE.L -172(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_341
        BRA.W LBL_340
LBL_341:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_342
        BRA.W LBL_340
LBL_342:
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
LBL_340:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 344)
LBL_13:
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
LBL_343:
        UNLK A6
        RTS
        ; func natInit  (JT slot 345)
LBL_14:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -174(A5),D0
        TST.L D0
        BEQ.W LBL_345
        BRA.W LBL_344
LBL_345:
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
        BEQ.W LBL_346
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-172(A5)
        BRA.W LBL_344
LBL_346:
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
LBL_344:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 346)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_15:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_14
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        BSR.W LBL_13
LBL_347:
        UNLK A6
        RTS
        ; func natLog  (JT slot 347)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_16:
        LINK A6,#-2136
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_14
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
LBL_349:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_351
        MOVE.L -168(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_352
LBL_351:
        MOVE.L #0,D0
LBL_352:
        TST.L D0
        BEQ.W LBL_350
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
        BRA.W LBL_349
LBL_350:
LBL_348:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 348)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_17:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -176(A5),D0
        TST.L D0
        BEQ.W LBL_354
        BRA.W LBL_353
LBL_354:
        MOVE.L #1,D0
        MOVE.B D0,-176(A5)
        BSR.W LBL_14
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
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -156(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
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
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L -164(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -168(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L -172(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_355
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
LBL_355:
        BSR.W LBL_13
        DC.W $A9F4  ; NatExitToShell
LBL_353:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 349)
        ;   param msg : 8(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_18:
        LINK A6,#-2384
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_357:
        CLR.W (A0)+
        DBRA D0,LBL_357
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_146(PC),A0
        MOVE.L A0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 74(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 66(A5)
        ADDA.W #12,A7
        ADDA.L #256,A7
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_356:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 350)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_19:
        LINK A6,#-2128
        MOVE.L 264(A6),D0
        MOVE.L D0,-184(A5)
        LEA -440(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 66(A5)
        ADDA.W #12,A7
LBL_358:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 351)
        ;   hidden result ptr : 8(A6)  size 4
LBL_20:
        LINK A6,#-2128
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -440(A5),A0
        MOVE.L A0,-(A7)
        JSR 66(A5)
        ADDA.W #12,A7
        BRA.W LBL_359
LBL_359:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 352)
        ;   local __ret1 : -4(A6)  size 4
LBL_21:
        LINK A6,#-2132
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2088(A6)
LBL_361:
        MOVE.L A1,-(A7)
        MOVE.L -2088(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_360
LBL_360:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 353)
LBL_22:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -446(A5),D0
        TST.L D0
        BEQ.W LBL_363
        BRA.W LBL_362
LBL_363:
        MOVE.L #1,D0
        MOVE.B D0,-446(A5)
        MOVE.L #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-444(A5)
LBL_362:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 354)
LBL_23:
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
LBL_364:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 355)
        ;   param path : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local ref : -16(A6)  size 4
        ;   local wrote : -20(A6)  size 4
        ;   local failed : -22(A6)  size 2
LBL_24:
        LINK A6,#-2150
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
        BSR.W LBL_22
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
        DC.W $A008  ; NatCreate
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
        BEQ.W LBL_366
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_367:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_367
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_365
LBL_366:
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
        MOVE.L 8(A6),D0
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
        BEQ.W LBL_368
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
        BEQ.W LBL_369
        MOVE.L #1,D0
        MOVE.B D0,-22(A6)
LBL_369:
LBL_368:
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
        BSR.W LBL_23
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_370
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_371
LBL_370:
        MOVE.L #1,D0
LBL_371:
        TST.L D0
        BEQ.W LBL_372
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_148(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_373:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_373
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_365
LBL_372:
        MOVE.L #1,D0
        BRA.W LBL_365
LBL_365:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 356)
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
LBL_25:
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
        BSR.W LBL_22
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
        BEQ.W LBL_375
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_147(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_376:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_376
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_374
LBL_375:
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
        BEQ.W LBL_377
        LEA LBL_51(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_378:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_378
        JSR 50(A5)
        ADDA.W #256,A7
LBL_377:
        MOVE.L #0,D0
        MOVE.L D0,-28(A6)
        MOVE.L #0,D0
        MOVE.B D0,-30(A6)
LBL_379:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
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
        BEQ.W LBL_381
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_382
LBL_381:
        MOVE.L #0,D0
LBL_382:
        TST.L D0
        BEQ.W LBL_383
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
        LEA LBL_149(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_384:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_384
        JSR 42(A5)
        ADDA.W #260,A7
        MOVE.L #0,D0
        BRA.W LBL_374
LBL_383:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_385
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 90(A5)
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
LBL_385:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65497,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_386
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_387
LBL_386:
        MOVE.L #1,D0
LBL_387:
        TST.L D0
        BEQ.W LBL_388
        MOVE.L #1,D0
        MOVE.B D0,-30(A6)
LBL_388:
        BRA.W LBL_379
LBL_380:
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
        BRA.W LBL_374
LBL_374:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 357)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_26:
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
LBL_390:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_391
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
        BEQ.W LBL_392
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_392:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_390
LBL_391:
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
LBL_393:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_394
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
        BRA.W LBL_393
LBL_394:
LBL_389:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 358)
        ;   param path : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
LBL_27:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_396
        MOVE.L #1,D0
        BRA.W LBL_395
LBL_396:
        MOVE.L #0,D0
        BRA.W LBL_395
LBL_395:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 359)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_28:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_398
        MOVE.L #1,D0
        BRA.W LBL_397
LBL_398:
        MOVE.L #0,D0
        BRA.W LBL_397
LBL_397:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 360)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_29:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_14
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-450(A5)
LBL_400:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
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
        BSR.W LBL_12
        ADDQ.L #8,A7
        BSR.W LBL_13
LBL_399:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 361)
        ;   param code : 8(A6)  size 4
LBL_30:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_401:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 362)
LBL_31:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -452(A5),D0
        TST.L D0
        BEQ.W LBL_403
        BRA.W LBL_402
LBL_403:
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
LBL_402:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 363)
        ;   param out : 8(A6)  size 4
LBL_32:
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
LBL_404:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 364)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_33:
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
        BEQ.W LBL_406
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #65536,D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_406:
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
LBL_405:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 365)
LBL_34:
        LINK A6,#-2128
        MOVE.L #0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
LBL_407:
        UNLK A6
        RTS
        ; func ui_Probe_opened  (JT slot 366)
        ;   param window : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
LBL_35:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1138(A5)
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
        JSR 1802(A5)
        ADDA.W #26,A7
LBL_408:
        UNLK A6
        RTS
        ; func ui_every_0  (JT slot 367)
        ;   local p : -4(A6)  size 4
LBL_36:
        LINK A6,#-2132
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,-(A7)
        JSR 1130(A5)
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
        BEQ.W LBL_410
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1138(A5)
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
        JSR 1138(A5)
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
        JSR 1138(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_161
        MOVE.L D0,-(A7)
        MOVE.L #280,D0
        MOVE.L (A7)+,D1
        BSR.W LBL_163
        MOVE.L D0,-(A7)
        MOVE.L #40,D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.B D0,-(A7)
        JSR 1802(A5)
        ADDA.W #26,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1138(A5)
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
        BEQ.W LBL_411
        JSR 1202(A5)
LBL_411:
LBL_410:
LBL_409:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 368)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_37:
        LINK A6,#-2128
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_413
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
LBL_415:
        BRA.W LBL_414
LBL_413:
        LEA LBL_150(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BSR.W LBL_164
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_414:
LBL_412:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 369)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_38:
        LINK A6,#-2128
        MOVE.L 28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_417
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        BRA.W LBL_420
LBL_419:
        LEA LBL_151(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BSR.W LBL_164
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_420:
        BRA.W LBL_418
LBL_417:
        LEA LBL_152(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BSR.W LBL_164
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_418:
LBL_416:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 370)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_39:
        LINK A6,#-2128
        LEA LBL_153(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BSR.W LBL_164
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_421:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 371)
        ;   param idx : 8(A6)  size 4
LBL_40:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_423
        BSR.W LBL_36
        BRA.W LBL_424
LBL_423:
        LEA LBL_154(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BSR.W LBL_164
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_424:
LBL_422:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 372)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_41:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        BRA.W LBL_427
LBL_426:
        LEA LBL_155(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BSR.W LBL_164
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
LBL_427:
LBL_425:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 373)
        ;   param rowsIdx : 8(A6)  size 4
LBL_42:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
        LEA -4(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_430
LBL_429:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
        LEA -8(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_432
LBL_431:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        LEA -12(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_434
LBL_433:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #3,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        LEA -16(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_436
LBL_435:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #4,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_437
        LEA -18(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_438
LBL_437:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
        LEA -22(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_440
LBL_439:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #6,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        LEA -26(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_442
LBL_441:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #7,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_443
        LEA -30(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_444
LBL_443:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #8,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        LEA -34(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_446
LBL_445:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #9,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
        LEA -38(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_448
LBL_447:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #10,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        LEA -40(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_450
LBL_449:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #11,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_451
        LEA -42(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_452
LBL_451:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #12,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_453
        LEA -46(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_454
LBL_453:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #13,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_455
        LEA -50(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_456
LBL_455:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #14,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        LEA -54(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_458
LBL_457:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #15,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        LEA -58(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_460
LBL_459:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #16,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        LEA -62(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_462
LBL_461:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #17,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
        LEA -66(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_464
LBL_463:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #18,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        LEA -70(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_466
LBL_465:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #19,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
        LEA -74(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_468
LBL_467:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #20,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_469
        LEA -76(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_470
LBL_469:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #21,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        LEA -78(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_472
LBL_471:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #22,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_473
        LEA -82(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_474
LBL_473:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #23,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        LEA -84(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_476
LBL_475:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #24,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_477
        LEA -88(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_478
LBL_477:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #25,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_479
        LEA -92(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_480
LBL_479:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #26,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        LEA -96(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_482
LBL_481:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #27,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_483
        LEA -100(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_484
LBL_483:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #28,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_485
        LEA -104(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_486
LBL_485:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #29,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_487
        LEA -108(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_488
LBL_487:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #30,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_489
        LEA -110(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_490
LBL_489:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #31,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_491
        LEA -114(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_492
LBL_491:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_493
        LEA -118(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_494
LBL_493:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #33,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_495
        LEA -122(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_496
LBL_495:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #34,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_497
        LEA -124(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_498
LBL_497:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #35,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_499
        LEA -128(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_500
LBL_499:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #36,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_501
        LEA -132(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_502
LBL_501:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #37,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_503
        LEA -136(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_504
LBL_503:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #38,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_505
        LEA -140(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_506
LBL_505:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #39,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_507
        LEA -144(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_508
LBL_507:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #40,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_509
        LEA -148(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_510
LBL_509:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #41,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_511
        LEA -152(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_512
LBL_511:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #42,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_513
        LEA -156(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_514
LBL_513:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #43,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_515
        LEA -160(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_516
LBL_515:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #44,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        LEA -164(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_518
LBL_517:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #45,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_519
        LEA -168(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_520
LBL_519:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #46,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_521
        LEA -172(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_522
LBL_521:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #47,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_523
        LEA -174(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_524
LBL_523:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #48,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_525
        LEA -176(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_526
LBL_525:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #49,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_527
        LEA -180(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_528
LBL_527:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #50,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_529
        LEA -184(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_530
LBL_529:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #51,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_531
        LEA -440(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_532
LBL_531:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #52,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        LEA -444(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_534
LBL_533:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #53,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_535
        LEA -446(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_536
LBL_535:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #54,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_537
        LEA -450(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_538
LBL_537:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #55,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_539
        LEA -452(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_540
LBL_539:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #56,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        LEA -456(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_428
        BRA.W LBL_542
LBL_541:
        LEA LBL_156(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_16
        ADDQ.L #4,A7
        BSR.W LBL_164
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_17
        ADDQ.L #4,A7
        MOVE.L #0,D0
        BRA.W LBL_428
LBL_542:
LBL_540:
LBL_538:
LBL_536:
LBL_534:
LBL_532:
LBL_530:
LBL_528:
LBL_526:
LBL_524:
LBL_522:
LBL_520:
LBL_518:
LBL_516:
LBL_514:
LBL_512:
LBL_510:
LBL_508:
LBL_506:
LBL_504:
LBL_502:
LBL_500:
LBL_498:
LBL_496:
LBL_494:
LBL_492:
LBL_490:
LBL_488:
LBL_486:
LBL_484:
LBL_482:
LBL_480:
LBL_478:
LBL_476:
LBL_474:
LBL_472:
LBL_470:
LBL_468:
LBL_466:
LBL_464:
LBL_462:
LBL_460:
LBL_458:
LBL_456:
LBL_454:
LBL_452:
LBL_450:
LBL_448:
LBL_446:
LBL_444:
LBL_442:
LBL_440:
LBL_438:
LBL_436:
LBL_434:
LBL_432:
LBL_430:
LBL_428:
        UNLK A6
        RTS
        ; func clar_cb_rtUiScrollbarAction (JT slot 374) -- pascal callback glue for rtUiScrollbarAction
LBL_43:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1970(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 375) -- pascal callback glue for rtUiLdefDraw
LBL_44:
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
        JSR 2074(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_161:
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
LBL_162:
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
        BPL.W LBL_543
        NEG.L D2
        MOVE.L #1,D4
LBL_543:
        CLR.L D5
        TST.L D3
        BPL.W LBL_544
        NEG.L D3
        MOVE.L #1,D5
LBL_544:
        CLR.L D6
        MOVE.W #31,D7
LBL_545:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_546
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_546:
        DBRA D7,LBL_545
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_547
        NEG.L D2
LBL_547:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_163:
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
        BPL.W LBL_548
        NEG.L D2
        MOVE.L #1,D4
LBL_548:
        CLR.L D5
        TST.L D3
        BPL.W LBL_549
        NEG.L D3
        MOVE.L #1,D5
LBL_549:
        CLR.L D6
        MOVE.W #31,D7
LBL_550:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_551
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_551:
        DBRA D7,LBL_550
        TST.L D4
        BEQ.W LBL_552
        NEG.L D6
LBL_552:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_164:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
LBL_553:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_45:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_46:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_47:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_48:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_49:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_50:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_51:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_52:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_53:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_54:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_55:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_56:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_57:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_58:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_59:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_60:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_61:
        DC.B $01
        DC.B $2D
LBL_62:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_63:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_64:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_65:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_66:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_67:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_68:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
LBL_69:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_70:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_71:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_72:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_73:
        DC.B $03
        DC.B $6B,$65,$79
LBL_74:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_75:
        DC.B $01
        DC.B $78
LBL_76:
        DC.B $01
        DC.B $3F
LBL_77:
        DC.B $06
        DC.B $73,$65,$6C,$65,$63,$74
        DC.B $00
LBL_78:
        DC.B $0B
        DC.B $64,$6F,$75,$62,$6C,$65,$43,$6C,$69,$63,$6B
LBL_79:
        DC.B $78
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$66,$6F,$75,$6E,$64,$20,$6E,$6F,$20,$6D,$65,$6E,$75,$20,$69,$6E,$20,$74,$68,$65,$20,$6D,$65,$6E,$75,$20,$6C,$69,$73,$74,$20,$66,$6F,$72,$20,$74,$68,$69,$73,$20,$77,$69,$64,$67,$65,$74,$20,$28,$63,$6C,$6F,$73,$65,$2F,$72,$65,$6F,$70,$65,$6E,$20,$6C,$65,$66,$74,$20,$69,$74,$20,$75,$6E,$64,$65,$6C,$65,$74,$65,$64,$20,$6F,$72,$20,$6E,$65,$76,$65,$72,$20,$72,$65,$69,$6E,$73,$65,$72,$74,$65,$64,$29
        DC.B $00
LBL_80:
        DC.B $71
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$72,$65,$74,$75,$72,$6E,$65,$64,$20,$61,$20,$6D,$65,$6E,$75,$20,$68,$61,$6E,$64,$6C,$65,$20,$74,$68,$61,$74,$20,$69,$73,$6E,$27,$74,$20,$74,$68,$69,$73,$20,$69,$6E,$73,$74,$61,$6E,$63,$65,$27,$73,$20,$6F,$77,$6E,$20,$28,$73,$74,$61,$6C,$65,$2F,$6C,$65,$61,$6B,$65,$64,$20,$65,$6E,$74,$72,$79,$20,$75,$6E,$64,$65,$72,$20,$74,$68,$65,$20,$73,$61,$6D,$65,$20,$49,$44,$29
LBL_81:
        DC.B $57
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$6D,$65,$6E,$75,$20,$69,$74,$65,$6D,$20,$63,$6F,$75,$6E,$74,$20,$64,$6F,$65,$73,$6E,$27,$74,$20,$6D,$61,$74,$63,$68,$20,$74,$68,$65,$20,$62,$6F,$75,$6E,$64,$20,$65,$6E,$75,$6D,$20,$28,$72,$65,$62,$75,$69,$6C,$74,$20,$77,$69,$74,$68,$20,$73,$74,$61,$6C,$65,$2F,$6C,$65,$66,$74,$6F,$76,$65,$72,$20,$69,$74,$65,$6D,$73,$29
LBL_82:
        DC.B $24
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_83:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$61,$6E,$73,$77,$65,$72,$20,$71,$75,$65,$75,$65,$20,$6F,$76,$65,$72,$66,$6C,$6F,$77
LBL_84:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$77,$69,$74,$68,$20,$6E,$6F,$20,$71,$75,$65,$75,$65,$64,$20,$61,$6E,$73,$77,$65,$72
LBL_85:
        DC.B $07
        DC.B $54,$20,$4F,$50,$45,$4E,$20
LBL_86:
        DC.B $01
        DC.B $20
LBL_87:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_88:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_89:
        DC.B $01
        DC.B $2E
LBL_90:
        DC.B $07
        DC.B $2E,$73,$65,$6C,$65,$63,$74
LBL_91:
        DC.B $0D
        DC.B $54,$20,$46,$49,$52,$45,$20,$65,$76,$65,$72,$79,$2E
LBL_92:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_93:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_94:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_95:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_96:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_97:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_98:
        DC.B $08
        DC.B $54,$20,$41,$42,$4F,$55,$54,$20
        DC.B $00
LBL_99:
        DC.B $01
        DC.B $7C
LBL_100:
        DC.B $07
        DC.B $63,$61,$70,$74,$69,$6F,$6E
LBL_101:
        DC.B $04
        DC.B $74,$65,$78,$74
        DC.B $00
LBL_102:
        DC.B $07
        DC.B $65,$6E,$61,$62,$6C,$65,$64
LBL_103:
        DC.B $07
        DC.B $63,$68,$65,$63,$6B,$65,$64
LBL_104:
        DC.B $08
        DC.B $73,$65,$6C,$65,$63,$74,$65,$64
        DC.B $00
LBL_105:
        DC.B $05
        DC.B $77,$69,$64,$74,$68
LBL_106:
        DC.B $06
        DC.B $68,$65,$69,$67,$68,$74
        DC.B $00
LBL_107:
        DC.B $06
        DC.B $54,$20,$53,$45,$54,$20
        DC.B $00
LBL_108:
        DC.B $09
        DC.B $2E,$69,$6E,$76,$61,$6C,$69,$64,$2E
LBL_109:
        DC.B $02
        DC.B $54,$20
        DC.B $00
LBL_110:
        DC.B $0A
        DC.B $54,$20,$4F,$50,$45,$4E,$44,$4F,$43,$20
        DC.B $00
LBL_111:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_112:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_113:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_114:
        DC.B $37
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$73,$61,$76,$65,$7C,$64,$69,$73,$63,$61,$72,$64,$7C,$63,$61,$6E,$63,$65,$6C,$29
LBL_115:
        DC.B $23
        DC.B $73,$6E,$61,$70,$3A,$20,$73,$63,$72,$65,$65,$6E,$42,$69,$74,$73,$2E,$72,$6F,$77,$42,$79,$74,$65,$73,$20,$69,$73,$20,$6E,$6F,$74,$20,$36,$34
LBL_116:
        DC.B $10
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$23,$23,$20
        DC.B $00
LBL_117:
        DC.B $13
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$2D,$45,$4E,$44,$23,$23
LBL_118:
        DC.B $08
        DC.B $64,$62,$6C,$63,$6C,$69,$63,$6B
        DC.B $00
LBL_119:
        DC.B $04
        DC.B $74,$79,$70,$65
        DC.B $00
LBL_120:
        DC.B $04
        DC.B $6D,$65,$6E,$75
        DC.B $00
LBL_121:
        DC.B $05
        DC.B $63,$6C,$6F,$73,$65
LBL_122:
        DC.B $06
        DC.B $72,$65,$73,$69,$7A,$65
        DC.B $00
LBL_123:
        DC.B $04
        DC.B $7A,$6F,$6F,$6D
        DC.B $00
LBL_124:
        DC.B $04
        DC.B $74,$69,$63,$6B
        DC.B $00
LBL_125:
        DC.B $04
        DC.B $73,$6E,$61,$70
        DC.B $00
LBL_126:
        DC.B $04
        DC.B $71,$75,$69,$74
        DC.B $00
LBL_127:
        DC.B $09
        DC.B $6C,$61,$75,$6E,$63,$68,$64,$6F,$63
LBL_128:
        DC.B $0C
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$70,$6F,$70,$75,$70
        DC.B $00
LBL_129:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$6F,$70,$65,$6E
LBL_130:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$73,$61,$76,$65
LBL_131:
        DC.B $0E
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73
        DC.B $00
LBL_132:
        DC.B $0D
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$61,$6E,$63,$65,$6C
LBL_133:
        DC.B $2C
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$6B,$6E,$6F,$77,$6E,$20,$6F,$72,$20,$75,$6E,$73,$75,$70,$70,$6F,$72,$74,$65,$64,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$76,$65,$72,$62
        DC.B $00
LBL_134:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_135:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_136:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_137:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_138:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_139:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_140:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_141:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_142:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_143:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_144:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_145:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_146:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_147:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_148:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_149:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_150:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_151:
        DC.B $2B
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$64,$67,$65,$74,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_152:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_153:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_154:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_155:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_156:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_157:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_160:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (264 bytes)
LBL_158:
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
LBL_159:
        DC.B $00
        DC.B $00
