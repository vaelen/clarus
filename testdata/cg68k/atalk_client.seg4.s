        ; func rtConnPump  (JT slot 420)
        ;   local i : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local code : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local j : -20(A6)  size 4
        ;   local e : -24(A6)  size 4
        ;   local gone : -26(A6)  size 2
        ;   local __store1 : -30(A6)  size 4
        ;   local __store2 : -34(A6)  size 4
LBL_0:
        LINK A6,#-2138
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
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
LBL_141:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_142
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_143
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4354(A5)
        ADDQ.L #4,A7
        BRA.W LBL_144
LBL_143:
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_145
        LEA -240(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4378(A5)
        ADDA.W #12,A7
        LEA -2288(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_145:
LBL_144:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_146
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_147
LBL_146:
        MOVEQ #0,D0
LBL_147:
        TST.L D0
        BEQ.W LBL_148
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_149
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4354(A5)
        ADDQ.L #4,A7
        BRA.W LBL_150
LBL_149:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_151
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_110(PC),A0
        MOVE.L A0,-(A7)
        JSR 3330(A5)
        ADDA.W #12,A7
LBL_151:
LBL_150:
LBL_148:
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_152
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_153
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
        BRA.W LBL_154
LBL_153:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
LBL_154:
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BEQ.W LBL_155
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_157
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_158
LBL_157:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDQ.L #4,A7
LBL_158:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_156
LBL_155:
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_159
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
        LEA -30(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 178(A5)
        MOVE.L D0,-38(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -38(A6),D0
        MOVE.L D0,-30(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
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
        BSR.W LBL_23
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_162
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4362(A5)
        ADDQ.L #8,A7
LBL_162:
LBL_161:
        BRA.W LBL_160
LBL_159:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_163
        LEA -34(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 178(A5)
        MOVE.L D0,-38(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -34(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_164:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_165
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_3
        ADDQ.L #4,A7
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_164
LBL_165:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4362(A5)
        ADDQ.L #8,A7
LBL_163:
LBL_160:
LBL_156:
LBL_152:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_141
LBL_142:
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_140:
        UNLK A6
        RTS
        ; func rtConnDevOpen  (JT slot 421)
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
LBL_1:
        LINK A6,#-2816
        LEA -256(A6),A0
        CLR.B (A0)
        LEA -512(A6),A0
        CLR.B (A0)
        LEA -562(A6),A0
        MOVE.W #11,D0
LBL_167:
        CLR.L (A0)+
        DBRA D0,LBL_167
        CLR.W (A0)+
        LEA -612(A6),A0
        MOVE.W #11,D0
LBL_168:
        CLR.L (A0)+
        DBRA D0,LBL_168
        CLR.W (A0)+
        LEA -662(A6),A0
        MOVE.W #11,D0
LBL_169:
        CLR.L (A0)+
        DBRA D0,LBL_169
        CLR.W (A0)+
        LEA -712(A6),A0
        MOVE.W #11,D0
LBL_170:
        CLR.L (A0)+
        DBRA D0,LBL_170
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-716(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_171
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_111(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_112(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_172
LBL_171:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_172:
        LEA -544(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 3370(A5)
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
        BEQ.W LBL_173
        MOVE.L -716(A6),D0
        BRA.W LBL_166
LBL_173:
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        JSR 3370(A5)
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
        BEQ.W LBL_174
        MOVE.L -716(A6),D0
        BRA.W LBL_166
LBL_174:
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_175
        MOVEQ #108,D0
        NEG.L D0
        BRA.W LBL_166
LBL_175:
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
        BEQ.W LBL_176
        MOVE.L -716(A6),D0
        BRA.W LBL_166
LBL_176:
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
        JSR 3378(A5)
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
        BRA.W LBL_166
LBL_166:
        UNLK A6
        RTS
        ; func rtConnDevAvail  (JT slot 422)
        ;   param slot : 8(A6)  size 4
        ;   local countPb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_2:
        LINK A6,#-2154
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_178:
        CLR.L (A0)+
        DBRA D0,LBL_178
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_179
        MOVEQ #0,D0
        BRA.W LBL_177
LBL_179:
        LEA -22(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_177
LBL_177:
        UNLK A6
        RTS
        ; func rtConnDevReadByte  (JT slot 423)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_3:
        LINK A6,#-2154
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_181:
        CLR.L (A0)+
        DBRA D0,LBL_181
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        MOVE.L -2364(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_182
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-2364(A5)
LBL_182:
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2360(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_183
        MOVEQ #0,D0
        BRA.W LBL_180
LBL_183:
        MOVE.L -2364(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_180
LBL_180:
        UNLK A6
        RTS
        ; func rtConnDevWrite  (JT slot 424)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_4:
        LINK A6,#-2150
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_185:
        CLR.L (A0)+
        DBRA D0,LBL_185
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BRA.W LBL_184
LBL_184:
        UNLK A6
        RTS
        ; func rtConnDevClose  (JT slot 425)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_5:
        LINK A6,#-2150
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_187:
        CLR.L (A0)+
        DBRA D0,LBL_187
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
LBL_186:
        UNLK A6
        RTS
        ; func rtConnDevGone  (JT slot 426)
        ;   param slot : 8(A6)  size 4
LBL_6:
        LINK A6,#-2100
        MOVEQ #0,D0
        BRA.W LBL_188
LBL_188:
        UNLK A6
        RTS
        ; func rtAtEnsureUp  (JT slot 427)
        ;   local e : -4(A6)  size 4
LBL_7:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_41
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_190
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_189
LBL_190:
        MOVEQ #1,D0
        MOVE.B D0,-2366(A5)
        MOVEQ #0,D0
        BRA.W LBL_189
LBL_189:
        UNLK A6
        RTS
        ; func rtSvcSetFailed  (JT slot 428)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_8:
        LINK A6,#-2100
        LEA -3452(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_192
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -3452(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -3964(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_192:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6080(A5)
LBL_191:
        UNLK A6
        RTS
        ; func rtBrsSetFailed  (JT slot 429)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_9:
        LINK A6,#-2100
        LEA -2910(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_194
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2910(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -3422(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_194:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6080(A5)
LBL_193:
        UNLK A6
        RTS
        ; func rtAdspFailed  (JT slot 430)
        ;   param slot : 8(A6)  size 4
LBL_10:
        LINK A6,#-2100
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_195:
        UNLK A6
        RTS
        ; func rtLsnSetFailed  (JT slot 431)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_11:
        LINK A6,#-2100
        LEA -2382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_197
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2894(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_197:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6080(A5)
LBL_196:
        UNLK A6
        RTS
        ; func rtAtTextToPtr  (JT slot 432)
        ;   param t : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_12:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_199
        MOVEQ #0,D0
        BRA.W LBL_198
LBL_199:
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
        BEQ.W LBL_200
        MOVEQ #0,D0
        BRA.W LBL_198
LBL_200:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_201:
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_202
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_201
LBL_202:
        MOVE.L -4(A6),D0
        BRA.W LBL_198
LBL_198:
        UNLK A6
        RTS
        ; func rtAtAppendBytes  (JT slot 433)
        ;   param t : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
LBL_13:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_204
        BRA.W LBL_203
LBL_204:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_205:
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_206
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
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_205
LBL_206:
LBL_203:
        UNLK A6
        RTS
        ; func rtSvcCallAddr  (JT slot 434)
        ;   param h : 24(A6)  size 4
        ;   param addr : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param reply : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local code : -12(A6)  size 4
        ;   local p : -16(A6)  size 4
LBL_14:
        LINK A6,#-2116
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_208
        LEA LBL_115(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_208:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L #578,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_209
        MOVE.L #-3106,D0
        MOVE.L D0,-(A7)
        LEA LBL_117(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_207
LBL_209:
        BSR.W LBL_7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_210
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_207
LBL_210:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_211
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_212
LBL_211:
        MOVEQ #0,D0
LBL_212:
        TST.L D0
        BEQ.W LBL_213
        MOVEQ #-108,D0
        MOVE.L D0,-(A7)
        LEA LBL_105(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_207
LBL_213:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDA.W #16,A7
        MOVE.L D0,-8(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_214
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
LBL_214:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_215
        MOVE.L -8(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_118(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_207
LBL_215:
        BSR.W LBL_64
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #12,A7
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_216
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_207
LBL_216:
        MOVEQ #1,D0
        BRA.W LBL_207
LBL_207:
        UNLK A6
        RTS
        ; func rtSvcCallName  (JT slot 435)
        ;   param h : 24(A6)  size 4
        ;   param name : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param reply : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local addr : -8(A6)  size 4
        ;   local idx : -12(A6)  size 4
LBL_15:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_218
        LEA LBL_115(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_218:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L #578,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_219
        MOVE.L #-3106,D0
        MOVE.L D0,-(A7)
        LEA LBL_117(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_217
LBL_219:
        MOVEA.L 20(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #58,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_220
        MOVE.L #-1025,D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_217
LBL_220:
        BSR.W LBL_7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_221
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_217
LBL_221:
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 20(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #16,A7
        LEA -528(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -528(A6),A0
        MOVE.L A0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 20(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 20(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L -12(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #16,A7
        LEA -1040(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1040(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDA.W #16,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_222
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_217
LBL_222:
LBL_223:
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_224
        JSR 1818(A5)
        BRA.W LBL_223
LBL_224:
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_225
        MOVE.L #-1025,D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_217
LBL_225:
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_14
        ADDA.W #20,A7
        BRA.W LBL_217
LBL_217:
        UNLK A6
        RTS
        ; func rtBrsFind  (JT slot 436)
        ;   param h : 16(A6)  size 4
        ;   param typ : 12(A6)  size 4
        ;   param zone : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
        ;   local z : -264(A6)  size 256
LBL_16:
        LINK A6,#-2364
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -264(A6),A0
        CLR.B (A0)
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_227
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_227:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_228
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_228:
        BSR.W LBL_7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_229
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
        ADDA.W #12,A7
        BRA.W LBL_226
LBL_229:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDA.W #16,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_230
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_124(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_9
        ADDA.W #12,A7
        BRA.W LBL_226
LBL_230:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_226:
        UNLK A6
        RTS
        ; func rtBrsZones  (JT slot 437)
        ;   param h : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_17:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_232
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_232:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        BSR.W LBL_7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_235
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_236
LBL_235:
        MOVEQ #1,D0
LBL_236:
        TST.L D0
        BNE.W LBL_233
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 330(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_234
LBL_233:
        MOVEQ #1,D0
LBL_234:
        TST.L D0
        BEQ.W LBL_237
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 338(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        JSR 322(A5)
        ADDQ.L #8,A7
LBL_237:
LBL_231:
        UNLK A6
        RTS
        ; func rtLsnStop  (JT slot 438)
        ;   param h : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
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
        BEQ.W LBL_239
        LEA LBL_125(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_239:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -2374(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_240
        BRA.W LBL_238
LBL_240:
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA -5500(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA -6012(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2374(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -5500(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -6012(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_238:
        UNLK A6
        RTS
        ; func rtAdspOpenName  (JT slot 439)
        ;   param slot : 12(A6)  size 4
        ;   param spec : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local idx : -8(A6)  size 4
LBL_19:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #58,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_242
        MOVE.L #-1025,D0
        BRA.W LBL_241
LBL_242:
        BSR.W LBL_7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_243
        MOVE.L -4(A6),D0
        BRA.W LBL_241
LBL_243:
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
        JSR 154(A5)
        ADDA.W #16,A7
        LEA -524(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
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
        JSR 154(A5)
        ADDA.W #16,A7
        LEA -1036(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1036(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDA.W #16,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_244
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_241
LBL_244:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_241
LBL_241:
        UNLK A6
        RTS
        ; func rtAdspOpenAddr  (JT slot 440)
        ;   param slot : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
LBL_20:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_246
        MOVE.L -4(A6),D0
        BRA.W LBL_245
LBL_246:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_247
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_245
LBL_247:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_245
LBL_245:
        UNLK A6
        RTS
        ; func rtAdspPoll  (JT slot 441)
        ;   param slot : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local addr : -8(A6)  size 4
LBL_21:
        LINK A6,#-2108
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
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_249
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_250
        MOVEQ #0,D0
        BRA.W LBL_248
LBL_250:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_251
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #4,A7
        MOVE.L #-1025,D0
        BRA.W LBL_248
LBL_251:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_252
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_248
LBL_252:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_248
LBL_249:
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_253
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_254
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_248
LBL_254:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
        MOVE.L -4(A6),D0
        MOVE.L D0,-6080(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_248
LBL_255:
        MOVEQ #0,D0
        BRA.W LBL_248
LBL_253:
        MOVEQ #0,D0
        BRA.W LBL_248
LBL_248:
        UNLK A6
        RTS
        ; func rtAdspAvail  (JT slot 442)
        ;   param slot : 8(A6)  size 4
LBL_22:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        BRA.W LBL_256
LBL_256:
        UNLK A6
        RTS
        ; func rtAdspReadInto  (JT slot 443)
        ;   param slot : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local got : -8(A6)  size 4
        ;   local scratch : -12(A6)  size 4
LBL_23:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_258
        MOVEQ #0,D0
        BRA.W LBL_257
LBL_258:
        MOVE.L -4(A6),D1
        MOVE.L #1024,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_259
        MOVE.L #1024,D0
        MOVE.L D0,-4(A6)
LBL_259:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_260
        MOVEQ #-108,D0
        MOVE.L D0,-6080(A5)
        MOVEQ #0,D0
        BRA.W LBL_257
LBL_260:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
        MOVE.L -8(A6),D0
        MOVE.L D0,-6080(A5)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_261:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #12,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
        MOVE.L -8(A6),D0
        BRA.W LBL_257
LBL_257:
        UNLK A6
        RTS
        ; func rtAdspWrite  (JT slot 444)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_24:
        LINK A6,#-2100
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDA.W #12,A7
        BRA.W LBL_262
LBL_262:
        UNLK A6
        RTS
        ; func rtAdspClose  (JT slot 445)
        ;   param slot : 8(A6)  size 4
LBL_25:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #4,A7
LBL_263:
        UNLK A6
        RTS
        ; func rtAdspGone  (JT slot 446)
        ;   param slot : 8(A6)  size 4
LBL_26:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDQ.L #4,A7
        BRA.W LBL_264
LBL_264:
        UNLK A6
        RTS
        ; func rtConnOpenAddr  (JT slot 447)
        ;   param h : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_27:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_266
        LEA LBL_108(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_266:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_267
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-1,D0
        MOVE.L D0,-(A7)
        LEA LBL_109(PC),A0
        MOVE.L A0,-(A7)
        JSR 3330(A5)
        ADDA.W #12,A7
        BRA.W LBL_265
LBL_267:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_110(PC),A0
        MOVE.L A0,-(A7)
        JSR 3330(A5)
        ADDA.W #12,A7
LBL_268:
LBL_265:
        UNLK A6
        RTS
        ; func rtAtalkPump  (JT slot 448)
        ;   local i : -4(A6)  size 4
        ;   local code : -8(A6)  size 4
        ;   local pr : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local req : -20(A6)  size 4
        ;   local free : -24(A6)  size 4
        ;   local j : -28(A6)  size 4
        ;   local e : -32(A6)  size 4
        ;   local __store3 : -36(A6)  size 4
LBL_28:
        LINK A6,#-2140
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
        LEA -36(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.L D0
        MOVE.B -2366(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_270
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_269
LBL_270:
        JSR 1818(A5)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_271:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_272
        LEA -3452(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_273
        LEA -3452(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3452(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -3964(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4442(A5)
        ADDA.W #12,A7
        LEA -3964(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_273:
        LEA -3430(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_274
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_275
LBL_274:
        MOVEQ #0,D0
LBL_275:
        TST.L D0
        BEQ.W LBL_276
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3440(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_8
        ADDA.W #12,A7
        BRA.W LBL_278
LBL_277:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_279
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3440(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVE.L #578,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_280
        MOVE.L #578,D0
        MOVE.L D0,-16(A6)
LBL_280:
        LEA -36(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 178(A5)
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -40(A6),D0
        MOVE.L D0,-36(A6)
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -36(A6),D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDA.W #12,A7
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -3442(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3444(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_57
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 4434(A5)
        ADDA.W #16,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3442(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        LEA -3444(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -3444(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDA.W #16,A7
LBL_281:
LBL_279:
LBL_278:
        LEA -3440(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_282
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_283
LBL_282:
        MOVEQ #0,D0
LBL_283:
        TST.L D0
        BEQ.W LBL_284
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -3438(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -3440(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
LBL_285:
LBL_284:
LBL_276:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_271
LBL_272:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_286:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_287
        LEA -2910(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_288
        LEA -2910(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2910(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -3422(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4426(A5)
        ADDA.W #12,A7
        LEA -3422(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_289
LBL_288:
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_290
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        BRA.W LBL_291
LBL_290:
        MOVEQ #0,D0
LBL_291:
        TST.L D0
        BEQ.W LBL_292
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_293:
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_295
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_296
LBL_295:
        MOVEQ #0,D0
LBL_296:
        TST.L D0
        BEQ.W LBL_294
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        LEA -556(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_51
        ADDA.W #12,A7
        LEA -556(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 4410(A5)
        ADDA.W #12,A7
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_293
LBL_294:
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_297
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4418(A5)
        ADDQ.L #4,A7
LBL_297:
LBL_292:
LBL_289:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_286
LBL_287:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_298:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_299
        LEA -2382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_300
        LEA -2382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -2894(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4402(A5)
        ADDA.W #12,A7
        LEA -2894(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_300:
        LEA -2374(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_301
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_302
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        ADDA.W #12,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        BRA.W LBL_303
LBL_302:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_304
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_305:
        MOVE.L -28(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_306
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_309
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_310
LBL_309:
        MOVEQ #0,D0
LBL_310:
        TST.L D0
        BEQ.W LBL_307
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_308
LBL_307:
        MOVEQ #0,D0
LBL_308:
        TST.L D0
        BEQ.W LBL_311
        MOVE.L -28(A6),D0
        MOVE.L D0,-24(A6)
LBL_311:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_305
LBL_306:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_312
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #4,A7
        BRA.W LBL_313
LBL_312:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_80
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        ADDA.W #12,A7
        BRA.W LBL_315
LBL_314:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -200(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6076(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 4394(A5)
        ADDQ.L #8,A7
LBL_315:
LBL_313:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
LBL_304:
LBL_303:
LBL_301:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_298
LBL_299:
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_269:
        UNLK A6
        RTS
        ; func rtAtalkAlive  (JT slot 449)
        ;   local i : -4(A6)  size 4
LBL_29:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_317:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        LEA -3430(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BNE.W LBL_319
        LEA -3452(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_320
LBL_319:
        MOVEQ #1,D0
LBL_320:
        TST.L D0
        BEQ.W LBL_321
        MOVEQ #1,D0
        BRA.W LBL_316
LBL_321:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_317
LBL_318:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_322:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_323
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BNE.W LBL_324
        LEA -2910(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_325
LBL_324:
        MOVEQ #1,D0
LBL_325:
        TST.L D0
        BEQ.W LBL_326
        MOVEQ #1,D0
        BRA.W LBL_316
LBL_326:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_322
LBL_323:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_327:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_328
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_329
        LEA -6044(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_330
LBL_329:
        MOVEQ #0,D0
LBL_330:
        TST.L D0
        BEQ.W LBL_331
        MOVEQ #1,D0
        BRA.W LBL_316
LBL_331:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_327
LBL_328:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_332:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_333
        LEA -2374(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BNE.W LBL_334
        LEA -2382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_335
LBL_334:
        MOVEQ #1,D0
LBL_335:
        TST.L D0
        BEQ.W LBL_336
        MOVEQ #1,D0
        BRA.W LBL_316
LBL_336:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_332
LBL_333:
        MOVEQ #0,D0
        BRA.W LBL_316
LBL_316:
        UNLK A6
        RTS
        ; func rtAtalkAddrStr  (JT slot 450)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param addr : 12(A6)  size 4
LBL_30:
        LINK A6,#-3124
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        LEA -2052(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -2052(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -1540(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1540(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #8,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #255,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        LEA -2564(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -2564(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -1028(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1028(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -516(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D1
        MOVE.L #255,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        LEA -3076(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -3076(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        BRA.W LBL_337
LBL_337:
        UNLK A6
        RTS
        ; func rtAt68SignW  (JT slot 451)
        ;   param v : 8(A6)  size 4
LBL_31:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_339
        MOVE.L 8(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_338
LBL_339:
        MOVE.L 8(A6),D0
        BRA.W LBL_338
LBL_338:
        UNLK A6
        RTS
        ; func rtAt68Zero  (JT slot 452)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
LBL_32:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_341
        BRA.W LBL_340
LBL_341:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_342:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_343
        MOVE.L 12(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_342
LBL_343:
LBL_344:
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_345
        MOVE.L 12(A6),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_344
LBL_345:
LBL_340:
        UNLK A6
        RTS
        ; func rtAt68Pending  (JT slot 453)
        ;   param pb : 8(A6)  size 4
LBL_33:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_347
        MOVEQ #0,D0
        BRA.W LBL_346
LBL_347:
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_346
LBL_346:
        UNLK A6
        RTS
        ; func rtAt68Result  (JT slot 454)
        ;   param pb : 8(A6)  size 4
LBL_34:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        BRA.W LBL_348
LBL_348:
        UNLK A6
        RTS
        ; func rtAt68PStr  (JT slot 455)
        ;   param p : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_35:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_350
        MOVEQ #32,D0
        MOVE.L D0,-8(A6)
LBL_350:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_351:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_352
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVEA.L (A7)+,A0
        CLR.L D0
        MOVE.B (A0),D0
        CMP.L D0,D1
        BCS.W LBL_353
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
LBL_353:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_351
LBL_352:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_349
LBL_349:
        UNLK A6
        RTS
        ; func rtAt68GetPStr  (JT slot 456)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   local s : -256(A6)  size 256
        ;   local i : -260(A6)  size 4
        ;   local n : -264(A6)  size 4
LBL_36:
        LINK A6,#-2364
        LEA -256(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-264(A6)
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
LBL_355:
        MOVE.L -260(A6),D1
        MOVE.L -264(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_356
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -260(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 106(A5)
        ADDA.W #12,A7
        LEA -256(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        MOVE.L -260(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-260(A6)
        BRA.W LBL_355
LBL_356:
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_354
LBL_354:
        UNLK A6
        RTS
        ; func rtAt68SkipPStr  (JT slot 457)
        ;   param p : 8(A6)  size 4
LBL_37:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_357
LBL_357:
        UNLK A6
        RTS
        ; func rtAt68PackAddr  (JT slot 458)
        ;   param p : 8(A6)  size 4
LBL_38:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ASL.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_358
LBL_358:
        UNLK A6
        RTS
        ; func rtAt68PokeAddr  (JT slot 459)
        ;   param p : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_39:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #255,D0
        AND.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D1
        MOVE.L #255,D0
        AND.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_359:
        UNLK A6
        RTS
        ; func rtAt68OpenDrv  (JT slot 460)
        ;   param name : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
        ;   local nm : -54(A6)  size 4
        ;   local e : -58(A6)  size 4
LBL_40:
        LINK A6,#-2158
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_361:
        CLR.L (A0)+
        DBRA D0,LBL_361
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        MOVEQ #0,D0
        MOVE.L D0,-58(A6)
        MOVEQ #40,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-54(A6)
        MOVE.L -54(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        MOVEQ #-108,D0
        MOVE.L D0,-6102(A5)
        MOVEQ #0,D0
        BRA.W LBL_360
LBL_362:
        MOVE.L -54(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        LEA -32(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -54(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -50(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; PBOpenSync
        MOVE.L D0,-58(A6)
        MOVE.L -54(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVE.L -58(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_363
        MOVE.L -58(A6),D0
        MOVE.L D0,-6102(A5)
        MOVEQ #0,D0
        BRA.W LBL_360
LBL_363:
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        BRA.W LBL_360
LBL_360:
        UNLK A6
        RTS
        ; func rtAtDevUp  (JT slot 461)
LBL_41:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6098(A5),D0
        TST.L D0
        BEQ.W LBL_365
        MOVEQ #0,D0
        BRA.W LBL_364
LBL_365:
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-6084(A5)
        MOVE.L -6084(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_366
        MOVE.L -6102(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_367
        MOVE.L #-1273,D0
        MOVE.L D0,-6102(A5)
LBL_367:
        MOVE.L -6102(A5),D0
        BRA.W LBL_364
LBL_366:
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-6088(A5)
        MOVE.L -6088(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_368
        MOVE.L -6102(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_369
        MOVE.L #-1273,D0
        MOVE.L D0,-6102(A5)
LBL_369:
        MOVE.L -6102(A5),D0
        BRA.W LBL_364
LBL_368:
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-6092(A5)
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_40
        ADDQ.L #4,A7
        MOVE.L D0,-6096(A5)
        MOVEQ #0,D0
        MOVE.L D0,-6102(A5)
        MOVEQ #1,D0
        MOVE.B D0,-6098(A5)
        MOVEQ #0,D0
        BRA.W LBL_364
LBL_364:
        UNLK A6
        RTS
        ; func rtAt68PStrEq  (JT slot 462)
        ;   param p : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_42:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_371
        MOVEQ #32,D0
        MOVE.L D0,-8(A6)
LBL_371:
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_372
        MOVEQ #0,D0
        BRA.W LBL_370
LBL_372:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_373:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_374
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVEA.L (A7)+,A0
        CLR.L D0
        MOVE.B (A0),D0
        CMP.L D0,D1
        BCS.W LBL_375
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
LBL_375:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVEQ #0,D0
        BRA.W LBL_370
LBL_376:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_373
LBL_374:
        MOVEQ #1,D0
        BRA.W LBL_370
LBL_370:
        UNLK A6
        RTS
        ; func rtAt68NteFind  (JT slot 463)
        ;   param obj : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local ent : -8(A6)  size 4
LBL_43:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_378:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_379
        LEA -6254(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_380
        LEA -6250(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_381
LBL_380:
        MOVEQ #0,D0
LBL_381:
        TST.L D0
        BEQ.W LBL_382
        LEA -6250(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_383
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #8,A7
        BRA.W LBL_384
LBL_383:
        MOVEQ #0,D0
LBL_384:
        TST.L D0
        BEQ.W LBL_385
        MOVE.L -4(A6),D0
        BRA.W LBL_377
LBL_385:
LBL_382:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_378
LBL_379:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_377
LBL_377:
        UNLK A6
        RTS
        ; func rtAtDevRemove  (JT slot 464)
        ;   param obj : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local pb : -52(A6)  size 52
        ;   local k : -56(A6)  size 4
        ;   local e : -60(A6)  size 4
LBL_44:
        LINK A6,#-2160
        LEA -52(A6),A0
        MOVE.W #12,D0
LBL_387:
        CLR.L (A0)+
        DBRA D0,LBL_387
        MOVEQ #0,D0
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVE.L -6084(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_388
        MOVE.L #-1273,D0
        BRA.W LBL_386
LBL_388:
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_389
        MOVE.L #-1028,D0
        BRA.W LBL_386
LBL_389:
        LEA -28(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6084(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #252,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -22(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6250(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -52(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-60(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6254(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -60(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        MOVE.L -60(A6),D0
        MOVE.L D0,-6102(A5)
LBL_390:
        MOVE.L -60(A6),D0
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func rtAt68LkEnsure  (JT slot 465)
        ;   param lk : 8(A6)  size 4
LBL_45:
        LINK A6,#-2100
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_392
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_392:
        LEA -6190(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_393
        MOVEQ #104,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6190(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_393:
        LEA -6234(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_394
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6234(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_394:
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_397
        LEA -6190(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_398
LBL_397:
        MOVEQ #0,D0
LBL_398:
        TST.L D0
        BEQ.W LBL_395
        LEA -6234(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_396
LBL_395:
        MOVEQ #0,D0
LBL_396:
        BRA.W LBL_391
LBL_391:
        UNLK A6
        RTS
        ; func rtAtDevLookupStart  (JT slot 466)
        ;   param lk : 20(A6)  size 4
        ;   param obj : 16(A6)  size 4
        ;   param typ : 12(A6)  size 4
        ;   param zone : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local ent : -8(A6)  size 4
        ;   local end : -12(A6)  size 4
        ;   local z : -268(A6)  size 256
        ;   local e : -272(A6)  size 4
LBL_46:
        LINK A6,#-2372
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        LEA -268(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-272(A6)
        MOVE.L -6084(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVE.L #-1273,D0
        BRA.W LBL_399
LBL_400:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_401
        MOVEQ #-108,D0
        BRA.W LBL_399
LBL_401:
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        LEA -6190(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
LBL_402:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_403
        BRA.W LBL_402
LBL_403:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #104,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_404
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_404:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6084(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #251,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #29,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #30,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6234(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #4096,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A404  ; PBControlAsync
        MOVE.L D0,-272(A6)
        MOVE.L -272(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_405
        MOVE.L -272(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -272(A6),D0
        BRA.W LBL_399
LBL_405:
        MOVEQ #0,D0
        BRA.W LBL_399
LBL_399:
        UNLK A6
        RTS
        ; func rtAtDevLookupDone  (JT slot 467)
        ;   param lk : 8(A6)  size 4
LBL_47:
        LINK A6,#-2100
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_407
        MOVEQ #1,D0
        BRA.W LBL_406
LBL_407:
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_406
LBL_406:
        UNLK A6
        RTS
        ; func rtAtDevLookupCount  (JT slot 468)
        ;   param lk : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
LBL_48:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_409
        MOVEQ #0,D0
        BRA.W LBL_408
LBL_409:
        LEA -6146(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_410
        MOVEQ #0,D0
        BRA.W LBL_408
LBL_410:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_411
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVE.L D0,-6102(A5)
        MOVEQ #0,D0
        BRA.W LBL_408
LBL_411:
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_408
LBL_408:
        UNLK A6
        RTS
        ; func rtAt68LkTuple  (JT slot 469)
        ;   param lk : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local j : -8(A6)  size 4
LBL_49:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_413
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_414
LBL_413:
        MOVEQ #1,D0
LBL_414:
        TST.L D0
        BEQ.W LBL_415
        MOVEQ #0,D0
        BRA.W LBL_412
LBL_415:
        LEA -6234(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_416:
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_417
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_416
LBL_417:
        MOVE.L -4(A6),D0
        BRA.W LBL_412
LBL_412:
        UNLK A6
        RTS
        ; func rtAtDevLookupAddr  (JT slot 470)
        ;   param lk : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_50:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        MOVEQ #0,D0
        BRA.W LBL_418
LBL_419:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        BRA.W LBL_418
LBL_418:
        UNLK A6
        RTS
        ; func rtAtDevLookupName  (JT slot 471)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param lk : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local obj : -260(A6)  size 256
        ;   local typ : -516(A6)  size 256
LBL_51:
        LINK A6,#-2616
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -260(A6),A0
        CLR.B (A0)
        LEA -516(A6),A0
        CLR.B (A0)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_421
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_420
LBL_421:
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_107(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -1032(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        BRA.W LBL_420
LBL_420:
        UNLK A6
        RTS
        ; func rtAtDevZones  (JT slot 472)
        ;   param out : 8(A6)  size 4
        ;   local pb : -112(A6)  size 112
        ;   local buf : -116(A6)  size 4
        ;   local e : -120(A6)  size 4
        ;   local n : -124(A6)  size 4
        ;   local i : -128(A6)  size 4
        ;   local p : -132(A6)  size 4
        ;   local last : -136(A6)  size 4
        ;   local guard : -140(A6)  size 4
LBL_52:
        LINK A6,#-2240
        LEA -112(A6),A0
        MOVE.W #27,D0
LBL_423:
        CLR.L (A0)+
        DBRA D0,LBL_423
        MOVEQ #0,D0
        MOVE.L D0,-116(A6)
        MOVEQ #0,D0
        MOVE.L D0,-120(A6)
        MOVEQ #0,D0
        MOVE.L D0,-124(A6)
        MOVEQ #0,D0
        MOVE.L D0,-128(A6)
        MOVEQ #0,D0
        MOVE.L D0,-132(A6)
        MOVEQ #0,D0
        MOVE.L D0,-136(A6)
        MOVEQ #0,D0
        MOVE.L D0,-140(A6)
        MOVE.L -6092(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
        MOVEQ #-93,D0
        BRA.W LBL_422
LBL_424:
        MOVE.L #578,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-116(A6)
        MOVE.L -116(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_425
        MOVEQ #-108,D0
        BRA.W LBL_422
LBL_425:
        MOVEQ #0,D0
        MOVE.L D0,-136(A6)
        MOVEQ #0,D0
        MOVE.L D0,-140(A6)
        MOVEQ #0,D0
        MOVE.L D0,-120(A6)
LBL_426:
        MOVE.L -136(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVE.L -140(A6),D1
        MOVEQ #64,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_429
LBL_428:
        MOVEQ #0,D0
LBL_429:
        TST.L D0
        BEQ.W LBL_427
        LEA -88(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6092(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -86(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #246,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -84(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #6,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -82(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -81(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -78(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -116(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -112(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-120(A6)
        MOVE.L -120(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
        MOVE.L -120(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVE.L -120(A6),D0
        BRA.W LBL_422
LBL_430:
        LEA -74(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L D0,-124(A6)
        MOVE.L -116(A6),D0
        MOVE.L D0,-132(A6)
        MOVEQ #0,D0
        MOVE.L D0,-128(A6)
LBL_431:
        MOVE.L -128(A6),D1
        MOVE.L -124(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -132(A6),D0
        MOVE.L D0,-(A7)
        LEA -656(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #8,A7
        LEA -656(A6),A0
        MOVE.L A0,-(A7)
        JSR 322(A5)
        ADDQ.L #8,A7
        MOVE.L -132(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVE.L D0,-132(A6)
        MOVE.L -128(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-128(A6)
        BRA.W LBL_431
LBL_432:
        LEA -72(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-136(A6)
        MOVE.L -140(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-140(A6)
        BRA.W LBL_426
LBL_427:
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        BRA.W LBL_422
LBL_422:
        UNLK A6
        RTS
        ; func rtAt68SvcEnsure  (JT slot 473)
        ;   param slot : 8(A6)  size 4
LBL_53:
        LINK A6,#-2100
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_434
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_434:
        LEA -6270(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_435
        MOVE.L #600,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6270(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_435:
        LEA -6278(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_436
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6278(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_436:
        LEA -6286(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_437
        MOVE.L #4624,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6286(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_437:
        LEA -6294(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_438
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6294(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_438:
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_445
        LEA -6270(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_446
LBL_445:
        MOVEQ #0,D0
LBL_446:
        TST.L D0
        BEQ.W LBL_443
        LEA -6278(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_444
LBL_443:
        MOVEQ #0,D0
LBL_444:
        TST.L D0
        BEQ.W LBL_441
        LEA -6286(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_442
LBL_441:
        MOVEQ #0,D0
LBL_442:
        TST.L D0
        BEQ.W LBL_439
        LEA -6294(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_440
LBL_439:
        MOVEQ #0,D0
LBL_440:
        BRA.W LBL_433
LBL_433:
        UNLK A6
        RTS
        ; func rtAtDevAtpArm  (JT slot 474)
        ;   param slot : 12(A6)  size 4
        ;   param sock : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_54:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6088(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_448
        MOVE.L #-1273,D0
        BRA.W LBL_447
LBL_448:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        MOVEQ #-108,D0
        BRA.W LBL_447
LBL_449:
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_450
        MOVE.L #-1273,D0
        BRA.W LBL_447
LBL_450:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -6302(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6088(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #253,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #578,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6270(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A404  ; PBControlAsync
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_451
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_447
LBL_451:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6304(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_447
LBL_447:
        UNLK A6
        RTS
        ; func rtAtDevAtpPoll  (JT slot 475)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local res : -8(A6)  size 4
LBL_55:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -6304(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_453
        MOVEQ #0,D0
        BRA.W LBL_452
LBL_453:
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_454
        MOVEQ #0,D0
        BRA.W LBL_452
LBL_454:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6304(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_455
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_452
LBL_455:
        MOVE.L -4(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -6312(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #30,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -6320(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -6328(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #46,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -6336(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #29,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #32,D0
        AND.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6344(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_452
LBL_452:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqOp  (JT slot 476)
        ;   param slot : 8(A6)  size 4
LBL_56:
        LINK A6,#-2100
        LEA -6312(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_456
LBL_456:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqFrom  (JT slot 477)
        ;   param slot : 8(A6)  size 4
LBL_57:
        LINK A6,#-2100
        LEA -6320(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_457
LBL_457:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqLen  (JT slot 478)
        ;   param slot : 8(A6)  size 4
LBL_58:
        LINK A6,#-2100
        LEA -6328(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_458
LBL_458:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqPtr  (JT slot 479)
        ;   param slot : 8(A6)  size 4
LBL_59:
        LINK A6,#-2100
        LEA -6270(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_459
LBL_459:
        UNLK A6
        RTS
        ; func rtAtDevAtpRespond  (JT slot 480)
        ;   param slot : 20(A6)  size 4
        ;   param code : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local bds : -8(A6)  size 4
        ;   local buf : -12(A6)  size 4
        ;   local nb : -16(A6)  size 4
        ;   local i : -20(A6)  size 4
        ;   local off : -24(A6)  size 4
        ;   local ds : -28(A6)  size 4
        ;   local cnt : -32(A6)  size 4
        ;   local e : -36(A6)  size 4
LBL_60:
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
        MOVE.L -6088(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        MOVE.L #-1273,D0
        BRA.W LBL_460
LBL_461:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_462
        MOVEQ #-108,D0
        BRA.W LBL_460
LBL_462:
        LEA -6278(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_463
        MOVE.L #-1273,D0
        BRA.W LBL_460
LBL_463:
        LEA -6294(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        LEA -6286(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_464
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_464:
        MOVE.L -32(A6),D1
        MOVE.L #4624,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        MOVE.L #4624,D0
        MOVE.L D0,-32(A6)
LBL_465:
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_466
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_467
LBL_466:
        MOVEQ #0,D0
LBL_467:
        TST.L D0
        BEQ.W LBL_468
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; BlockMoveData
LBL_468:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -32(A6),D1
        MOVE.L #578,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #578,D0
        BSR.W LBL_137
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_469
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
LBL_469:
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_470
        MOVEQ #8,D0
        MOVE.L D0,-16(A6)
LBL_470:
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_471:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_472
        MOVE.L -20(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_136
        MOVE.L D0,-24(A6)
        MOVE.L -32(A6),D1
        MOVE.L -24(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVE.L #578,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_473
        MOVE.L #578,D0
        MOVE.L D0,-28(A6)
LBL_473:
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_474
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_474:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #578,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D1
        MOVE.L -24(A6),D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_475
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_475:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_471
LBL_472:
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6088(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #252,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6302(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #29,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6344(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #30,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6320(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #45,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #46,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6336(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A404  ; PBControlAsync
        MOVE.L D0,-36(A6)
        MOVE.L -36(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_476
        MOVE.L -36(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -36(A6),D0
        BRA.W LBL_460
LBL_476:
        MOVEQ #0,D0
        BRA.W LBL_460
LBL_460:
        UNLK A6
        RTS
        ; func rtAtDevAtpRespBusy  (JT slot 481)
        ;   param slot : 8(A6)  size 4
LBL_61:
        LINK A6,#-2100
        LEA -6278(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_478
        MOVEQ #0,D0
        BRA.W LBL_477
LBL_478:
        LEA -6278(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        BRA.W LBL_477
LBL_477:
        UNLK A6
        RTS
        ; func rtAt68CallEnsure  (JT slot 482)
LBL_62:
        LINK A6,#-2100
        MOVE.L -6348(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_480
        MOVE.L #4624,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-6348(A5)
LBL_480:
        MOVE.L -6352(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-6352(A5)
LBL_481:
        MOVE.L -6348(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_482
        MOVE.L -6352(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_483
LBL_482:
        MOVEQ #0,D0
LBL_483:
        BRA.W LBL_479
LBL_479:
        UNLK A6
        RTS
        ; func rtAtDevAtpCall  (JT slot 483)
        ;   param addr : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param reqLen : 8(A6)  size 4
        ;   local pb : -56(A6)  size 56
        ;   local i : -60(A6)  size 4
        ;   local nresp : -64(A6)  size 4
        ;   local total : -68(A6)  size 4
        ;   local ds : -72(A6)  size 4
        ;   local e : -76(A6)  size 4
LBL_63:
        LINK A6,#-2176
        LEA -56(A6),A0
        MOVE.W #13,D0
LBL_485:
        CLR.L (A0)+
        DBRA D0,LBL_485
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
        MOVE.L -6088(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_486
        MOVE.L #-1273,D0
        BRA.W LBL_484
LBL_486:
        BSR.W LBL_62
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_487
        MOVEQ #-108,D0
        BRA.W LBL_484
LBL_487:
        MOVE.L -6352(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
LBL_488:
        MOVE.L -60(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_489
        MOVE.L -6352(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #578,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6352(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6348(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -60(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_488
LBL_489:
        MOVEQ #0,D0
        MOVE.L D0,-6356(A5)
        LEA -32(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6088(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -30(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -38(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -27(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D1
        MOVEQ #16,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #65535,D0
        AND.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -24(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D1
        MOVEQ #8,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #255,D0
        AND.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -23(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 20(A6),D1
        MOVE.L #255,D0
        AND.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -22(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -20(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -16(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6352(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -12(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -11(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -9(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -56(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-76(A6)
        MOVE.L -76(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
        MOVE.L -76(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -76(A6),D0
        BRA.W LBL_484
LBL_490:
        LEA -10(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-64(A6)
        MOVE.L -64(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_491
        MOVEQ #8,D0
        MOVE.L D0,-64(A6)
LBL_491:
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
LBL_492:
        MOVE.L -60(A6),D1
        MOVE.L -64(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_493
        MOVE.L -6352(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_494
        MOVE.L -72(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_495
LBL_494:
        MOVEQ #0,D0
LBL_495:
        TST.L D0
        BEQ.W LBL_496
        MOVE.L -6348(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_136
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6348(A5),D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; BlockMoveData
LBL_496:
        MOVE.L -68(A6),D1
        MOVE.L -72(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-68(A6)
        MOVE.L -60(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_492
LBL_493:
        MOVE.L -6352(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-6356(A5)
        MOVE.L -68(A6),D0
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func rtAtDevAtpCallCode  (JT slot 484)
LBL_64:
        LINK A6,#-2100
        MOVE.L -6356(A5),D0
        BRA.W LBL_497
LBL_497:
        UNLK A6
        RTS
        ; func rtAtDevAtpCallPtr  (JT slot 485)
LBL_65:
        LINK A6,#-2100
        MOVE.L -6348(A5),D0
        BRA.W LBL_498
LBL_498:
        UNLK A6
        RTS
        ; func rtAt68DspAuxPb  (JT slot 486)
LBL_66:
        LINK A6,#-2100
        MOVE.L -6586(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_500
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-6586(A5)
LBL_500:
        MOVE.L -6586(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_501
        MOVE.L -6586(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
LBL_501:
        MOVE.L -6586(A5),D0
        BRA.W LBL_499
LBL_499:
        UNLK A6
        RTS
        ; func rtAt68CcbEnsure  (JT slot 487)
        ;   param slot : 8(A6)  size 4
LBL_67:
        LINK A6,#-2100
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_503
        MOVE.L #242,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_503:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_504
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_504:
        LEA -6478(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_505
        MOVE.L #1024,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6478(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_505:
        LEA -6510(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_506
        MOVE.L #1024,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6510(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_506:
        LEA -6542(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_507
        MOVE.L #570,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6542(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_507:
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_514
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_515
LBL_514:
        MOVEQ #0,D0
LBL_515:
        TST.L D0
        BEQ.W LBL_512
        LEA -6478(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_513
LBL_512:
        MOVEQ #0,D0
LBL_513:
        TST.L D0
        BEQ.W LBL_510
        LEA -6510(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_511
LBL_510:
        MOVEQ #0,D0
LBL_511:
        TST.L D0
        BEQ.W LBL_508
        LEA -6542(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_509
LBL_508:
        MOVEQ #0,D0
LBL_509:
        BRA.W LBL_502
LBL_502:
        UNLK A6
        RTS
        ; func rtAt68DspFree  (JT slot 488)
        ;   param slot : 8(A6)  size 4
LBL_68:
        LINK A6,#-2100
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_517
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_517:
        LEA -6478(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_518
        LEA -6478(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6478(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_518:
        LEA -6510(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_519
        LEA -6510(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6510(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_519:
        LEA -6542(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_520
        LEA -6542(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6542(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_520:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_516:
        UNLK A6
        RTS
        ; func rtAt68DspInitEnd  (JT slot 489)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_69:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_67
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_522
        MOVEQ #-108,D0
        BRA.W LBL_521
LBL_522:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_523
        MOVE.L #-1273,D0
        BRA.W LBL_521
LBL_523:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #242,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #1024,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6478(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #48,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #1024,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6510(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #54,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6542(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #58,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_524
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_521
LBL_524:
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_521
LBL_521:
        UNLK A6
        RTS
        ; func rtAt68DspRemoveEnd  (JT slot 490)
        ;   param slot : 8(A6)  size 4
        ;   local aux : -4(A6)  size 4
LBL_70:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_526
        BRA.W LBL_525
LBL_526:
        BSR.W LBL_66
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_527
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #254,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
LBL_527:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_525:
        UNLK A6
        RTS
        ; func rtAdspDevOpen  (JT slot 491)
        ;   param slot : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_71:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_529
        MOVE.L #-1273,D0
        BRA.W LBL_528
LBL_529:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_530
        MOVE.L -8(A6),D0
        BRA.W LBL_528
LBL_530:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #253,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #64,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #65,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #6,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #66,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A404  ; PBControlAsync
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_531
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        BRA.W LBL_528
LBL_531:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6582(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_528
LBL_528:
        UNLK A6
        RTS
        ; func rtAdspDevOpenPoll  (JT slot 492)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local res : -8(A6)  size 4
LBL_72:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_533
        MOVE.L #-1273,D0
        BRA.W LBL_532
LBL_533:
        LEA -6582(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_534
        MOVE.L #-1273,D0
        BRA.W LBL_532
LBL_534:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_535
        MOVEQ #0,D0
        BRA.W LBL_532
LBL_535:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6582(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_536
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        BRA.W LBL_532
LBL_536:
        MOVEQ #1,D0
        BRA.W LBL_532
LBL_532:
        UNLK A6
        RTS
        ; func rtAdspDevAvail  (JT slot 493)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
LBL_73:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_538
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_539
LBL_538:
        MOVEQ #1,D0
LBL_539:
        TST.L D0
        BEQ.W LBL_540
        MOVEQ #0,D0
        BRA.W LBL_537
LBL_540:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_541
        MOVEQ #0,D0
        BRA.W LBL_537
LBL_541:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #247,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_542
        MOVEQ #0,D0
        BRA.W LBL_537
LBL_542:
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_537
LBL_537:
        UNLK A6
        RTS
        ; func rtAdspDevRead  (JT slot 494)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_74:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_544
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_545
LBL_544:
        MOVEQ #1,D0
LBL_545:
        TST.L D0
        BEQ.W LBL_546
        MOVEQ #0,D0
        BRA.W LBL_543
LBL_546:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_547
        MOVEQ #0,D0
        BRA.W LBL_543
LBL_547:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_548
        MOVEQ #0,D0
        BRA.W LBL_543
LBL_548:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #246,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_549
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVEQ #0,D0
        BRA.W LBL_543
LBL_549:
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_543
LBL_543:
        UNLK A6
        RTS
        ; func rtAdspDevWrite  (JT slot 495)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_75:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_551
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
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
        MOVE.L #-1273,D0
        BRA.W LBL_550
LBL_553:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_554
        MOVEQ #0,D0
        BRA.W LBL_550
LBL_554:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_555
        MOVE.L #-1273,D0
        BRA.W LBL_550
LBL_555:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #245,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #43,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_556
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
LBL_556:
        MOVE.L -8(A6),D0
        BRA.W LBL_550
LBL_550:
        UNLK A6
        RTS
        ; func rtAdspDevGone  (JT slot 496)
        ;   param slot : 8(A6)  size 4
LBL_76:
        LINK A6,#-2100
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BNE.W LBL_558
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_559
LBL_558:
        MOVEQ #1,D0
LBL_559:
        TST.L D0
        BEQ.W LBL_560
        MOVEQ #1,D0
        BRA.W LBL_557
LBL_560:
        LEA -6414(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_557
LBL_557:
        UNLK A6
        RTS
        ; func rtAdspDevClose  (JT slot 497)
        ;   param slot : 8(A6)  size 4
        ;   local aux : -4(A6)  size 4
LBL_77:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_562
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6582(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        BRA.W LBL_561
LBL_562:
        BSR.W LBL_66
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_563
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #252,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
LBL_563:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6582(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
LBL_561:
        UNLK A6
        RTS
        ; func rtLsnDevListen  (JT slot 498)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_78:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_565
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_566
LBL_565:
        MOVEQ #1,D0
LBL_566:
        TST.L D0
        BEQ.W LBL_567
        MOVE.L #-1273,D0
        BRA.W LBL_564
LBL_567:
        LEA -6372(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_568
        MOVEQ #0,D0
        BRA.W LBL_564
LBL_568:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #249,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A404  ; PBControlAsync
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_569
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_564
LBL_569:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_564
LBL_564:
        UNLK A6
        RTS
        ; func rtLsnDevPoll  (JT slot 499)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local res : -8(A6)  size 4
LBL_79:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -6382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_571
        MOVEQ #0,D0
        BRA.W LBL_570
LBL_571:
        LEA -6372(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_572
        MOVEQ #0,D0
        BRA.W LBL_570
LBL_572:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_573
        MOVE.L -8(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_570
LBL_573:
        MOVEQ #1,D0
        BRA.W LBL_570
LBL_570:
        UNLK A6
        RTS
        ; func rtLsnDevAccept  (JT slot 500)
        ;   param slot : 12(A6)  size 4
        ;   param connSlot : 8(A6)  size 4
        ;   local lpb : -4(A6)  size 4
        ;   local pb : -8(A6)  size 4
        ;   local e : -12(A6)  size 4
LBL_80:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_575
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_576
LBL_575:
        MOVEQ #1,D0
LBL_576:
        TST.L D0
        BEQ.W LBL_577
        MOVE.L #-1273,D0
        BRA.W LBL_574
LBL_577:
        LEA -6372(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_578
        MOVE.L -12(A6),D0
        BRA.W LBL_574
LBL_578:
        LEA -6446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_32
        ADDQ.L #8,A7
        MOVE.L -8(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #253,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6574(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #46,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #46,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #56,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #56,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #64,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #65,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #6,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #66,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_579
        MOVE.L -12(A6),D0
        MOVE.L D0,-6102(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        BRA.W LBL_574
LBL_579:
        MOVEQ #0,D0
        BRA.W LBL_574
LBL_574:
        UNLK A6
        RTS
        ; func rtLsnDevDeny  (JT slot 501)
        ;   param slot : 8(A6)  size 4
        ;   local lpb : -4(A6)  size 4
        ;   local aux : -8(A6)  size 4
        ;   local e : -12(A6)  size 4
LBL_81:
        LINK A6,#-2112
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_581
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_582
LBL_581:
        MOVEQ #1,D0
LBL_582:
        TST.L D0
        BEQ.W LBL_583
        MOVE.L #-1273,D0
        BRA.W LBL_580
LBL_583:
        LEA -6372(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_66
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_584
        MOVEQ #-108,D0
        BRA.W LBL_580
LBL_584:
        MOVE.L -8(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #248,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #38,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_585
        MOVE.L -12(A6),D0
        MOVE.L D0,-6102(A5)
LBL_585:
        MOVE.L -12(A6),D0
        BRA.W LBL_580
LBL_580:
        UNLK A6
        RTS
        ; func rtLsnDevRemove  (JT slot 502)
        ;   param slot : 8(A6)  size 4
        ;   local aux : -4(A6)  size 4
LBL_82:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_587
        BRA.W LBL_586
LBL_587:
        BSR.W LBL_66
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_588
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #26,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #250,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #34,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
LBL_588:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6380(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6382(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        LEA -6364(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
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
        BEQ.W LBL_589
        LEA -6364(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6364(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_136
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_589:
LBL_586:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 503)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_83:
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
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_591:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_592
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
        BEQ.W LBL_593
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_593:
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
        BRA.W LBL_591
LBL_592:
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
        BRA.W LBL_590
LBL_590:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 504)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local v2 : -22(A6)  size 4
LBL_84:
        LINK A6,#-2122
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
        BEQ.W LBL_595
        MOVEQ #0,D1
        MOVE.L -22(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-22(A6)
LBL_595:
        MOVEQ #0,D0
        MOVE.L D0,-6(A6)
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_596
        MOVE.L -6598(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #48,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_597
LBL_596:
LBL_598:
        MOVE.L -22(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_599
        MOVE.L -22(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_138
        MOVE.L D0,-10(A6)
        MOVE.L -6598(A5),D1
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
        BSR.W LBL_137
        MOVE.L D0,-22(A6)
        MOVE.L -6(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6(A6)
        BRA.W LBL_598
LBL_599:
LBL_597:
        MOVEQ #0,D0
        MOVE.L D0,-14(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        TST.L D0
        BEQ.W LBL_600
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-14(A6)
LBL_600:
        MOVE.L -6(A6),D0
        MOVE.L D0,-18(A6)
LBL_601:
        MOVE.L -18(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_602
        MOVE.L -18(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-18(A6)
        MOVE.L 8(A6),D1
        MOVE.L -14(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6598(A5),D1
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
        BRA.W LBL_601
LBL_602:
        MOVE.L -14(A6),D0
        BRA.W LBL_594
LBL_594:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 505)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_85:
        LINK A6,#-2100
        MOVE.L -6610(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_604
        BRA.W LBL_603
LBL_604:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_605
        BRA.W LBL_603
LBL_605:
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6610(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A003  ; NatWrite
LBL_603:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 506)
LBL_86:
        LINK A6,#-2100
        MOVE.L -6590(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
        MOVE.L -6590(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_606:
        UNLK A6
        RTS
        ; func natInit  (JT slot 507)
LBL_87:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6612(A5),D0
        TST.L D0
        BEQ.W LBL_608
        BRA.W LBL_607
LBL_608:
        MOVEQ #1,D0
        MOVE.B D0,-6612(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6590(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6594(A5)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6598(A5)
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6602(A5)
        MOVEQ #0,D0
        MOVE.L D0,-6606(A5)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6622(A5)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6626(A5)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #111,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #117,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #116,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6590(A5),D1
        MOVEQ #50,D0
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A008  ; NatCreate
        MOVE.L -6590(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #40,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #44,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D1
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
        MOVE.L -6590(A5),D1
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
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A00D  ; NatSetFInfo
        MOVE.L -6590(A5),D1
        MOVEQ #27,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A000  ; NatOpen
        MOVE.L -6590(A5),D1
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
        BEQ.W LBL_609
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-6610(A5)
        BRA.W LBL_607
LBL_609:
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-6610(A5)
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6610(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D1
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A012  ; NatSetEOF
LBL_607:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 508)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_88:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_87
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #8,A7
        BSR.W LBL_86
LBL_610:
        UNLK A6
        RTS
        ; func natLog  (JT slot 509)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_89:
        LINK A6,#-2108
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        BSR.W LBL_87
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_612:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_614
        MOVE.L -6606(A5),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_615
LBL_614:
        MOVEQ #0,D0
LBL_615:
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -6602(A5),D1
        MOVE.L -6606(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6606(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-6606(A5)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_612
LBL_613:
LBL_611:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 510)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_90:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -6614(A5),D0
        TST.L D0
        BEQ.W LBL_617
        BRA.W LBL_616
LBL_617:
        MOVEQ #1,D0
        MOVE.B D0,-6614(A5)
        BSR.W LBL_87
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #69,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #88,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #73,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #84,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #32,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #8,A7
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #67,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #65,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #6,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #82,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #7,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #85,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #83,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #45,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #10,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #76,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #11,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #79,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #12,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #71,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #13,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #14,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #35,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D1
        MOVEQ #15,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #16,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #8,A7
        MOVE.L -6602(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6606(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #8,A7
        MOVE.L -6610(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
        MOVE.L -6590(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6610(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6590(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A001  ; NatClose
LBL_618:
        BSR.W LBL_86
        DC.W $A9F4  ; NatExitToShell
LBL_616:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 511)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_91:
        LINK A6,#-2364
        LEA -256(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_133(PC),A0
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
        BSR.W LBL_87
        LEA -256(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-260(A6)
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -260(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-264(A6)
LBL_620:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_621
        MOVE.L -6622(A5),D1
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
        BCS.W LBL_622
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
LBL_622:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_620
LBL_621:
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B -6898(A5),D0
        TST.L D0
        BEQ.W LBL_623
        LEA LBL_135(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_624
LBL_623:
        MOVEQ #0,D0
LBL_624:
        TST.L D0
        BEQ.W LBL_625
        MOVEQ #30,D0
        MOVE.W D0,-(A7)
        DC.W $A9C8  ; NatSysBeep
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6626(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6626(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -6626(A5),D0
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
LBL_625:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
LBL_619:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 512)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_92:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-6630(A5)
        LEA -6886(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_626:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 513)
LBL_93:
        LINK A6,#-2100
        MOVE.L -6630(A5),D0
        BRA.W LBL_627
LBL_627:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 514)
        ;   hidden result ptr : 8(A6)  size 4
LBL_94:
        LINK A6,#-2100
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -6886(A5),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_628
LBL_628:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 515)
        ;   local __ret4 : -4(A6)  size 4
LBL_95:
        LINK A6,#-2104
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        JSR 282(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2060(A6)
LBL_630:
        MOVE.L A1,-(A7)
        MOVE.L -2060(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -6618(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 290(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_629
LBL_629:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 516)
LBL_96:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6892(A5),D0
        TST.L D0
        BEQ.W LBL_632
        BRA.W LBL_631
LBL_632:
        MOVEQ #1,D0
        MOVE.B D0,-6892(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6890(A5)
LBL_631:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 517)
LBL_97:
        LINK A6,#-2100
        MOVE.L -6890(A5),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6890(A5),D1
        MOVEQ #22,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6890(A5),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A013  ; NatFlushVol
LBL_633:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 518)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_98:
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
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_635:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_636
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
        BEQ.W LBL_637
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_637:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_635
LBL_636:
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
LBL_638:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_639
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
        BRA.W LBL_638
LBL_639:
LBL_634:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 519)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_99:
        LINK A6,#-2100
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4226(A5)
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_641
        MOVEQ #1,D0
        BRA.W LBL_640
LBL_641:
        MOVEQ #0,D0
        BRA.W LBL_640
LBL_640:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 520)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_100:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4234(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_643
        MOVEQ #1,D0
        BRA.W LBL_642
LBL_643:
        MOVEQ #0,D0
        BRA.W LBL_642
LBL_642:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 521)
        ;   param code : 8(A6)  size 4
LBL_101:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
LBL_644:
        UNLK A6
        RTS
        ; func nat_UiConnPump  (JT slot 522)
LBL_102:
        LINK A6,#-2100
        JSR 4386(A5)
LBL_645:
        UNLK A6
        RTS
        ; func handler_link_closed  (JT slot 523)
LBL_103:
        LINK A6,#-2100
        JSR 1570(A5)
LBL_646:
        UNLK A6
        RTS
LBL_136:
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
LBL_137:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_647
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_647:
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
        BPL.W LBL_648
        NEG.L D2
        MOVE.L #1,D4
LBL_648:
        CLR.L D5
        TST.L D3
        BPL.W LBL_649
        NEG.L D3
        MOVE.L #1,D5
LBL_649:
        CLR.L D6
        MOVE.W #31,D7
LBL_650:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_651
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_651:
        DBRA D7,LBL_650
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_652
        NEG.L D2
LBL_652:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_138:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_653
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_653:
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
        BPL.W LBL_654
        NEG.L D2
        MOVE.L #1,D4
LBL_654:
        CLR.L D5
        TST.L D3
        BPL.W LBL_655
        NEG.L D3
        MOVE.L #1,D5
LBL_655:
        CLR.L D6
        MOVE.W #31,D7
LBL_656:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_657
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_657:
        DBRA D7,LBL_656
        TST.L D4
        BEQ.W LBL_658
        NEG.L D6
LBL_658:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_139:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -6618(A5),D0
        MOVE.L D0,-4(A6)
LBL_659:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -6934(A5),D0
        MOVE.L D0,-4(A6)
LBL_660:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6938(A5),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6942(A5),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_134:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_104:
        DC.B $00
        DC.B $00
LBL_110:
        DC.B $19
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_111:
        DC.B $05
        DC.B $2E,$41,$4F,$75,$74
LBL_112:
        DC.B $04
        DC.B $2E,$41,$49,$6E
        DC.B $00
LBL_113:
        DC.B $05
        DC.B $2E,$42,$4F,$75,$74
LBL_114:
        DC.B $04
        DC.B $2E,$42,$49,$6E
        DC.B $00
LBL_115:
        DC.B $12
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$73,$65,$72,$76,$69,$63,$65
        DC.B $00
LBL_117:
        DC.B $10
        DC.B $72,$65,$71,$75,$65,$73,$74,$20,$74,$6F,$6F,$20,$6C,$6F,$6E,$67
        DC.B $00
LBL_116:
        DC.B $15
        DC.B $41,$70,$70,$6C,$65,$54,$61,$6C,$6B,$20,$75,$6E,$61,$76,$61,$69,$6C,$61,$62,$6C,$65
LBL_105:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_118:
        DC.B $0B
        DC.B $6E,$6F,$20,$72,$65,$73,$70,$6F,$6E,$73,$65
LBL_119:
        DC.B $07
        DC.B $73,$65,$72,$76,$69,$63,$65
LBL_120:
        DC.B $0E
        DC.B $6E,$61,$6D,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_121:
        DC.B $01
        DC.B $2A
LBL_122:
        DC.B $19
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$73,$65,$72,$76,$69,$63,$65,$42,$72,$6F,$77,$73,$65,$72
LBL_123:
        DC.B $01
        DC.B $3D
LBL_124:
        DC.B $0D
        DC.B $6C,$6F,$6F,$6B,$75,$70,$20,$66,$61,$69,$6C,$65,$64
LBL_125:
        DC.B $13
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$6C,$69,$73,$74,$65,$6E,$65,$72
LBL_108:
        DC.B $15
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_109:
        DC.B $17
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_126:
        DC.B $0E
        DC.B $72,$65,$71,$75,$65,$73,$74,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_127:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$65,$6E,$65,$72,$20,$66,$61,$69,$6C,$65,$64
LBL_128:
        DC.B $1B
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$61,$63,$63,$65,$70,$74,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_106:
        DC.B $01
        DC.B $2E
LBL_129:
        DC.B $04
        DC.B $2E,$4D,$50,$50
        DC.B $00
LBL_130:
        DC.B $04
        DC.B $2E,$41,$54,$50
        DC.B $00
LBL_131:
        DC.B $04
        DC.B $2E,$58,$50,$50
        DC.B $00
LBL_132:
        DC.B $04
        DC.B $2E,$44,$53,$50
        DC.B $00
LBL_107:
        DC.B $01
        DC.B $3A
LBL_133:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_135:
        DC.B $00
        DC.B $00
