        ; func rtUiFormFill  (JT slot 431)
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
LBL_0:
        LINK A6,#-148
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
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 842(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1258(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1250(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        JSR 2154(A5)
        MOVE.L D0,-68(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_146:
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_147
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1282(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1410(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -148(A5),D1
        MOVE.L -44(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-48(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 866(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 2090(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 2050(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
        MOVE.L -52(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_149
LBL_148:
        MOVEQ #0,D0
LBL_149:
        TST.L D0
        BEQ.W LBL_150
        MOVE.L -40(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_152
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-76(A6)
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-80(A6)
        MOVE.L -80(A6),D1
        MOVE.L -76(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        MOVE.L -76(A6),D0
        MOVE.L D0,-80(A6)
LBL_154:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -48(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -80(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        BRA.W LBL_153
LBL_152:
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_155
        MOVE.L -40(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_156
LBL_155:
        MOVEQ #1,D0
LBL_156:
        TST.L D0
        BEQ.W LBL_157
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 2714(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 2650(A5)
        ADDQ.L #8,A7
        BRA.W LBL_158
LBL_157:
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_159
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 2706(A5)
        ADDQ.L #8,A7
        BRA.W LBL_160
LBL_159:
        MOVE.L -40(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_163
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -64(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_164
LBL_163:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_164:
        BRA.W LBL_162
LBL_161:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_162:
LBL_160:
LBL_158:
LBL_153:
        MOVE.L -64(A6),D1
        MOVEQ #1,D0
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
        BRA.W LBL_151
LBL_150:
        MOVE.L -52(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_165
        MOVE.L -60(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_166
LBL_165:
        MOVEQ #0,D0
LBL_166:
        TST.L D0
        BEQ.W LBL_167
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -72(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_169
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_170
LBL_169:
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_170:
        BRA.W LBL_168
LBL_167:
        MOVE.L -52(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_171
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1434(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1450(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-92(A6)
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_172:
        MOVE.L -96(A6),D1
        MOVE.L -84(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_173
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -72(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_174
        MOVE.L -96(A6),D0
        MOVE.L D0,-92(A6)
        MOVE.L -84(A6),D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_175
LBL_174:
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
LBL_175:
        BRA.W LBL_172
LBL_173:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        JSR 2682(A5)
        ADDA.W #12,A7
LBL_171:
LBL_168:
LBL_151:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_146
LBL_147:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_145:
        UNLK A6
        RTS
        ; func rtUiFormAccept  (JT slot 432)
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
LBL_1:
        LINK A6,#-138
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
        MOVE.B D0,-58(A6)
        MOVEQ #0,D0
        MOVE.L D0,-62(A6)
        MOVEQ #0,D0
        MOVE.L D0,-66(A6)
        MOVEQ #0,D0
        MOVE.L D0,-70(A6)
        MOVEQ #0,D0
        MOVE.L D0,-74(A6)
        MOVEQ #0,D0
        MOVE.L D0,-78(A6)
        MOVEQ #0,D0
        MOVE.L D0,-82(A6)
        MOVEQ #0,D0
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
        JSR 842(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1258(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1250(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_177:
        MOVE.L -32(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_178
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1282(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1410(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -148(A5),D1
        MOVE.L -48(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
        MOVE.L -44(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_179
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2226(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR 3418(A5)
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_176
LBL_181:
        BRA.W LBL_180
LBL_179:
        MOVE.L -44(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_182
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2226(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR 3426(A5)
        ADDA.W #12,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_184
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_176
LBL_184:
        BRA.W LBL_183
LBL_182:
        MOVE.L -44(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_185
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2226(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR 3434(A5)
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_187
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_176
LBL_187:
        BRA.W LBL_186
LBL_185:
        MOVE.L -44(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_188
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2226(A5)
        ADDA.W #16,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-62(A6)
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-66(A6)
        MOVE.L -66(A6),D1
        MOVE.L -62(A6),D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_190
        MOVE.L -62(A6),D0
        MOVE.L D0,-66(A6)
LBL_190:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -66(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -56(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D1
        MOVEQ #1,D0
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
LBL_191:
        MOVE.L -70(A6),D1
        MOVE.L -62(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_192
        MOVE.L -52(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -70(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -70(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-70(A6)
        BRA.W LBL_191
LBL_192:
        BRA.W LBL_189
LBL_188:
        MOVE.L -44(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_193
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2050(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-74(A6)
        MOVE.L -74(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_195
        CLR.W -(A7)
        MOVE.L -74(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A960  ; UiGetControlValue
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_196
LBL_195:
        MOVEQ #0,D0
LBL_196:
        TST.L D0
        BEQ.W LBL_197
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_198
LBL_197:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_198:
        BRA.W LBL_194
LBL_193:
        MOVE.L -44(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_199
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2226(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_201
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_202
LBL_201:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_202:
        BRA.W LBL_200
LBL_199:
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_203
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2674(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-78(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1434(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-82(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1450(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-86(A6)
        MOVE.L -82(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_206
        MOVE.L -78(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_207
LBL_206:
        MOVEQ #0,D0
LBL_207:
        TST.L D0
        BEQ.W LBL_204
        MOVE.L -78(A6),D1
        MOVE.L -82(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_205
LBL_204:
        MOVEQ #0,D0
LBL_205:
        TST.L D0
        BEQ.W LBL_208
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 1474(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        BRA.W LBL_209
LBL_208:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_209:
LBL_203:
LBL_200:
LBL_194:
LBL_189:
LBL_186:
LBL_183:
LBL_180:
        MOVE.L -32(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_177
LBL_178:
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -154(A5),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_210
        MOVE.L -158(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_212
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -158(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_212:
        BRA.W LBL_211
LBL_210:
        MOVE.L -154(A5),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_213
        MOVE.L -162(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_217
        MOVE.L -166(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_218
LBL_217:
        MOVEQ #0,D0
LBL_218:
        TST.L D0
        BEQ.W LBL_215
        MOVE.L -166(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -162(A5),D0
        MOVE.L D0,-(A7)
        JSR 370(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_216
LBL_215:
        MOVEQ #0,D0
LBL_216:
        TST.L D0
        BEQ.W LBL_219
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -162(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -166(A5),D0
        MOVE.L D0,-(A7)
        JSR 290(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -162(A5),D0
        MOVE.L D0,-(A7)
        JSR 354(A5)
        ADDQ.L #4,A7
LBL_219:
        BRA.W LBL_214
LBL_213:
        MOVE.L -154(A5),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_220
        MOVE.L -170(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_221
        MOVE.L -170(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -174(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        JSR 578(A5)
        ADDA.W #12,A7
LBL_221:
LBL_220:
LBL_214:
LBL_211:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 754(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_101(PC),A0
        MOVE.L A0,-(A7)
        JSR 3050(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-(A7)
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 4994(A5)
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3458(A5)
        ADDQ.L #4,A7
LBL_176:
        UNLK A6
        RTS
        ; func rtUiEdit  (JT slot 433)
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
LBL_2:
        LINK A6,#-80
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
        CLR.L D0
        MOVE.B -136(A5),D0
        TST.L D0
        BEQ.W LBL_223
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_223:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 842(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_224
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_224:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1242(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1482(A5)
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
        MOVEQ #1,D0
        MOVE.B D0,-136(A5)
        MOVEQ #0,D0
        MOVE.L D0,-140(A5)
        MOVE.L -20(A6),D0
        MOVE.L D0,-144(A5)
        MOVE.L -16(A6),D0
        MOVE.L D0,-148(A5)
        MOVE.L 32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_225
        MOVEQ #1,D0
        MOVE.B D0,-150(A5)
        BRA.W LBL_226
LBL_225:
        MOVEQ #0,D0
        MOVE.B D0,-150(A5)
LBL_226:
        MOVE.L 28(A6),D0
        MOVE.L D0,-154(A5)
        MOVE.L 24(A6),D0
        MOVE.L D0,-158(A5)
        MOVE.L 20(A6),D0
        MOVE.L D0,-162(A5)
        MOVE.L 16(A6),D0
        MOVE.L D0,-166(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-170(A5)
        MOVE.L -174(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_227
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-174(A5)
LBL_227:
        MOVE.L -174(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L 28(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_228
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_229
LBL_228:
        MOVEQ #0,D0
LBL_229:
        TST.L D0
        BEQ.W LBL_230
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D1
        MOVE.L #255,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_231
        MOVE.L #255,D0
        MOVE.L D0,-28(A6)
LBL_231:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -174(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_230:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1618(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-140(A5)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_222:
        UNLK A6
        RTS
        ; func rtUiFormIsNew  (JT slot 434)
LBL_3:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -136(A5),D0
        TST.L D0
        BEQ.W LBL_233
        CLR.L D0
        MOVE.B -150(A5),D0
        BRA.W LBL_232
LBL_233:
        MOVEQ #0,D0
        BRA.W LBL_232
LBL_232:
        UNLK A6
        RTS
        ; func rtUiAskOpen  (JT slot 435)
        ;   param path255 : 12(A6)  size 4
        ;   param filter : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_4:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -60(A5),D0
        TST.L D0
        BEQ.W LBL_235
        JSR 2970(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_236
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 3378(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_234
LBL_236:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_237
        LEA LBL_105(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_234
LBL_237:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 2194(A5)
        ADDQ.L #8,A7
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3162(A5)
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_234
LBL_235:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3402(A5)
        ADDQ.L #8,A7
        BRA.W LBL_234
LBL_234:
        UNLK A6
        RTS
        ; func rtUiAskSave  (JT slot 436)
        ;   param path255 : 12(A6)  size 4
        ;   param suggested : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_5:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -60(A5),D0
        TST.L D0
        BEQ.W LBL_239
        JSR 2970(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_240
        LEA LBL_107(PC),A0
        MOVE.L A0,-(A7)
        JSR 3378(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_238
LBL_240:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_241
        LEA LBL_108(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_238
LBL_241:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 2194(A5)
        ADDQ.L #8,A7
        LEA LBL_109(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3162(A5)
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_238
LBL_239:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3410(A5)
        ADDQ.L #8,A7
        BRA.W LBL_238
LBL_238:
        UNLK A6
        RTS
        ; func rtUiAskSaveChanges  (JT slot 437)
        ;   param name : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local empty : -16(A6)  size 4
        ;   local item : -20(A6)  size 4
        ;   local t : -24(A6)  size 4
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
        CLR.L D0
        MOVE.B -60(A5),D0
        TST.L D0
        BEQ.W LBL_243
        JSR 2970(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_244
        LEA LBL_110(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_242
LBL_244:
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        JSR 154(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_111(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_245
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_98(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        BRA.W LBL_246
LBL_245:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_247
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_99(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        BRA.W LBL_248
LBL_247:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_100(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
LBL_248:
LBL_246:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        BRA.W LBL_242
LBL_243:
        JSR 1698(A5)
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
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A985  ; UiAlert
        MOVE.W (A7)+,D0
        EXT.L D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_242
LBL_242:
        UNLK A6
        RTS
        ; func rtUiAlertMsg  (JT slot 438)
        ;   param msg : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local t : -16(A6)  size 4
        ;   local empty : -20(A6)  size 4
LBL_7:
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
        JSR 4602(A5)
        TST.L D0
        BEQ.W LBL_250
        JSR 154(A5)
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_251:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_252
        MOVE.L 8(A6),D1
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
        BEQ.W LBL_253
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_253:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_251
LBL_252:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
LBL_250:
        CLR.L D0
        MOVE.B -60(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_254
        JSR 1698(A5)
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
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
LBL_254:
LBL_249:
        UNLK A6
        RTS
        ; func sortedmapValSlot  (JT slot 439)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_8:
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
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_255
LBL_255:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 440)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_9:
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
        BEQ.W LBL_257
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_257:
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
        BEQ.W LBL_258
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_258:
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
        BEQ.W LBL_259
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_259:
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
        BRA.W LBL_256
LBL_256:
        UNLK A6
        RTS
        ; func rtSortedMapRetain  (JT slot 441)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_10:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
        BRA.W LBL_260
LBL_261:
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
LBL_260:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 442)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_11:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_263
        BRA.W LBL_262
LBL_263:
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
        BEQ.W LBL_264
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_264:
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
        BEQ.W LBL_265
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
LBL_265:
LBL_262:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 443)
        ;   param m : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_268
LBL_267:
        MOVEQ #0,D0
LBL_268:
        BRA.W LBL_266
LBL_266:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 444)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_13:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_270
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
        BRA.W LBL_271
LBL_270:
        MOVEQ #1,D0
LBL_271:
        TST.L D0
        BEQ.W LBL_272
        LEA LBL_96(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_272:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
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
LBL_269:
        UNLK A6
        RTS
        ; func rtConnSetFailed  (JT slot 445)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_14:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -220(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2300(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
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
LBL_273:
        UNLK A6
        RTS
        ; func rtConnSendText  (JT slot 446)
        ;   param h : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local scratch : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local wErr : -16(A6)  size 4
        ;   local slot : -20(A6)  size 4
LBL_15:
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
        BEQ.W LBL_275
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_275:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_276
        LEA LBL_115(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_276:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        BRA.W LBL_274
LBL_277:
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
        BEQ.W LBL_278
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_279
        MOVEQ #108,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2300(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_279:
        BRA.W LBL_274
LBL_278:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_280:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        MOVE.L -4(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_280
LBL_281:
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_282
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_283
LBL_282:
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_284
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4330(A5)
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_285
LBL_284:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
LBL_285:
LBL_283:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_286
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_287
LBL_286:
        MOVEQ #0,D0
LBL_287:
        TST.L D0
        BEQ.W LBL_288
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2300(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_116(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_288:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
LBL_274:
        UNLK A6
        RTS
        ; func rtConnSendStr  (JT slot 447)
        ;   param h : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_16:
        LINK A6,#-56
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_15
        ADDQ.L #8,A7
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_289:
        UNLK A6
        RTS
        ; func rtConnClose  (JT slot 448)
        ;   param h : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
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
        BEQ.W LBL_291
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_291:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_292
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4354(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_290
LBL_292:
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_293
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        BRA.W LBL_294
LBL_293:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
LBL_294:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_290:
        UNLK A6
        RTS
        ; func rtConnPump  (JT slot 449)
        ;   local i : -4(A6)  size 4
        ;   local t : -8(A6)  size 4
        ;   local code : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local j : -20(A6)  size 4
        ;   local e : -24(A6)  size 4
        ;   local gone : -26(A6)  size 2
        ;   local __store1 : -30(A6)  size 4
        ;   local __store2 : -34(A6)  size 4
LBL_18:
        LINK A6,#-90
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 154(A5)
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
LBL_296:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_297
        LEA -220(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_298
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -220(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4898(A5)
        ADDQ.L #4,A7
        BRA.W LBL_299
LBL_298:
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2300(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4922(A5)
        ADDA.W #12,A7
        LEA -2300(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_300:
LBL_299:
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_302
LBL_301:
        MOVEQ #0,D0
LBL_302:
        TST.L D0
        BEQ.W LBL_303
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_304
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4898(A5)
        ADDQ.L #4,A7
        BRA.W LBL_305
LBL_304:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_306
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
LBL_306:
LBL_305:
LBL_303:
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_307
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4362(A5)
        ADDQ.L #4,A7
        BRA.W LBL_308
LBL_307:
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_309
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_310
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
        BRA.W LBL_311
LBL_310:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
LBL_311:
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BEQ.W LBL_312
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_314
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_315
LBL_314:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
LBL_315:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4914(A5)
        ADDQ.L #4,A7
        BRA.W LBL_313
LBL_312:
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_316
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        LEA -30(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 154(A5)
        MOVE.L D0,-38(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L -38(A6),D0
        MOVE.L D0,-30(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
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
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_319
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4906(A5)
        ADDQ.L #8,A7
LBL_319:
LBL_318:
        BRA.W LBL_317
LBL_316:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_320
        LEA -34(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 154(A5)
        MOVE.L D0,-38(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L -38(A6),D0
        MOVE.L D0,-34(A6)
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -34(A6),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_321:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_322
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_321
LBL_322:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4906(A5)
        ADDQ.L #8,A7
LBL_320:
LBL_317:
LBL_313:
LBL_309:
LBL_308:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_296
LBL_297:
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_295:
        UNLK A6
        RTS
        ; func rtConnAlive  (JT slot 450)
        ;   local i : -4(A6)  size 4
LBL_19:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_324:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BNE.W LBL_328
        LEA -220(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_329
LBL_328:
        MOVEQ #1,D0
LBL_329:
        TST.L D0
        BNE.W LBL_326
        LEA -252(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_327
LBL_326:
        MOVEQ #1,D0
LBL_327:
        TST.L D0
        BEQ.W LBL_330
        MOVEQ #1,D0
        BRA.W LBL_323
LBL_330:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_324
LBL_325:
        JSR 4386(A5)
        BRA.W LBL_323
LBL_323:
        UNLK A6
        RTS
        ; func rtConnDevAvail  (JT slot 451)
        ;   param slot : 8(A6)  size 4
        ;   local countPb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_20:
        LINK A6,#-106
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_332:
        CLR.L (A0)+
        DBRA D0,LBL_332
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2372(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_333
        MOVEQ #0,D0
        BRA.W LBL_331
LBL_333:
        LEA -22(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_331
LBL_331:
        UNLK A6
        RTS
        ; func rtConnDevReadByte  (JT slot 452)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_21:
        LINK A6,#-106
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_335:
        CLR.L (A0)+
        DBRA D0,LBL_335
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        MOVE.L -2376(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_336
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-2376(A5)
LBL_336:
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2372(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -18(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -2376(A5),D0
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
        BEQ.W LBL_337
        MOVEQ #0,D0
        BRA.W LBL_334
LBL_337:
        MOVE.L -2376(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_334
LBL_334:
        UNLK A6
        RTS
        ; func rtConnDevWrite  (JT slot 453)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_22:
        LINK A6,#-102
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_339:
        CLR.L (A0)+
        DBRA D0,LBL_339
        CLR.W (A0)+
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2340(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BRA.W LBL_338
LBL_338:
        UNLK A6
        RTS
        ; func rtConnDevClose  (JT slot 454)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_23:
        LINK A6,#-102
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_341:
        CLR.L (A0)+
        DBRA D0,LBL_341
        CLR.W (A0)+
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2372(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
LBL_340:
        UNLK A6
        RTS
        ; func rtConnDevGone  (JT slot 455)
        ;   param slot : 8(A6)  size 4
LBL_24:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_342
LBL_342:
        UNLK A6
        RTS
        ; func rtAtEnsureUp  (JT slot 456)
        ;   local e : -4(A6)  size 4
LBL_25:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_57
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_344
        MOVE.L -4(A6),D0
        MOVE.L D0,-6092(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_343
LBL_344:
        MOVEQ #1,D0
        MOVE.B D0,-2378(A5)
        MOVEQ #0,D0
        BRA.W LBL_343
LBL_343:
        UNLK A6
        RTS
        ; func rtAtRegMsg  (JT slot 457)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param code : 12(A6)  size 4
LBL_26:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVE.L #-1027,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_117(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_345
LBL_346:
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_118(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_345
LBL_345:
        UNLK A6
        RTS
        ; func rtSvcSetFailed  (JT slot 458)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_27:
        LINK A6,#-52
        LEA -3464(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_348
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -3464(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -3976(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
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
LBL_348:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6092(A5)
LBL_347:
        UNLK A6
        RTS
        ; func rtAdspFailed  (JT slot 459)
        ;   param slot : 8(A6)  size 4
LBL_28:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_349:
        UNLK A6
        RTS
        ; func rtLsnSetFailed  (JT slot 460)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_29:
        LINK A6,#-52
        LEA -2394(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_351
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2394(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2906(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
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
LBL_351:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6092(A5)
LBL_350:
        UNLK A6
        RTS
        ; func rtAtTextToPtr  (JT slot 461)
        ;   param t : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_30:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_353
        MOVEQ #0,D0
        BRA.W LBL_352
LBL_353:
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
        BEQ.W LBL_354
        MOVEQ #0,D0
        BRA.W LBL_352
LBL_354:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_355:
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_356
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_355
LBL_356:
        MOVE.L -4(A6),D0
        BRA.W LBL_352
LBL_352:
        UNLK A6
        RTS
        ; func rtAtAppendBytes  (JT slot 462)
        ;   param t : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
LBL_31:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
        BRA.W LBL_357
LBL_358:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_359:
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
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
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_359
LBL_360:
LBL_357:
        UNLK A6
        RTS
        ; func rtSvcServe  (JT slot 463)
        ;   param h : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
        ;   local sock : -12(A6)  size 4
LBL_32:
        LINK A6,#-576
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_362:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -3442(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_363
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-1,D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        BRA.W LBL_361
LBL_363:
        BSR.W LBL_25
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_364
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        BRA.W LBL_361
LBL_364:
        BSR.W LBL_67
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_365
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        BRA.W LBL_361
LBL_365:
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_366
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -528(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        LEA -528(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        BRA.W LBL_361
LBL_366:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA -3450(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -4488(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -5000(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
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
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
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
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_367
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        BRA.W LBL_368
LBL_367:
        MOVEQ #1,D0
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
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
LBL_368:
LBL_361:
        UNLK A6
        RTS
        ; func rtSvcReply  (JT slot 464)
        ;   param h : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local e : -12(A6)  size 4
        ;   local scratch : -16(A6)  size 4
LBL_33:
        LINK A6,#-68
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_370
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_370:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -3454(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_371
        LEA LBL_124(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_371:
        LEA -3456(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_372
        LEA LBL_125(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_372:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -3456(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L #4624,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_373
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #-3106,D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDA.W #16,A7
        BRA.W LBL_369
LBL_373:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_374
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDA.W #16,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_375
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
LBL_375:
        BRA.W LBL_369
LBL_374:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_30
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-108,D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDA.W #16,A7
        BRA.W LBL_369
LBL_376:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDA.W #16,A7
        MOVE.L D0,-12(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_377
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
LBL_377:
LBL_369:
        UNLK A6
        RTS
        ; func rtSvcReplyStr  (JT slot 465)
        ;   param h : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_34:
        LINK A6,#-56
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDA.W #12,A7
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_378:
        UNLK A6
        RTS
        ; func rtSvcStop  (JT slot 466)
        ;   param h : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_35:
        LINK A6,#-1080
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_380:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -3442(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_381
        BRA.W LBL_379
LBL_381:
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA -4488(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
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
        LEA -5000(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_61
        ADDQ.L #8,A7
        LEA -3450(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
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
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
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
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3450(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -4488(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -5000(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_379:
        UNLK A6
        RTS
        ; func rtLsnRegister  (JT slot 467)
        ;   param h : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_36:
        LINK A6,#-572
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
        BEQ.W LBL_383
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_383:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -2386(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_384
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-1,D0
        MOVE.L D0,-(A7)
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        BRA.W LBL_382
LBL_384:
        BSR.W LBL_25
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_385
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        BRA.W LBL_382
LBL_385:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4258(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_386
        MOVE.L -8(A6),D1
        MOVE.L #-1273,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_387
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        BRA.W LBL_388
LBL_387:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
LBL_388:
        BRA.W LBL_382
LBL_386:
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_90
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        BSR.W LBL_60
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_389
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4298(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #8,A7
        LEA -524(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        BRA.W LBL_382
LBL_389:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4266(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_61
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4298(A5)
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        BRA.W LBL_382
LBL_390:
        LEA -5512(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -6024(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
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
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -2386(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_382:
        UNLK A6
        RTS
        ; func rtLsnStop  (JT slot 468)
        ;   param h : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_37:
        LINK A6,#-1080
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_392
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_392:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -2386(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_393
        BRA.W LBL_391
LBL_393:
        LEA -6712(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_394
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_395
LBL_394:
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA -5512(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
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
        LEA -6024(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_61
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4298(A5)
        ADDQ.L #4,A7
LBL_395:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2386(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -5512(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -6024(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_391:
        UNLK A6
        RTS
        ; func rtAdspPoll  (JT slot 469)
        ;   param slot : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local addr : -8(A6)  size 4
LBL_38:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_397
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_398
        MOVEQ #0,D0
        BRA.W LBL_396
LBL_398:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_399
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #4,A7
        MOVE.L #-1025,D0
        BRA.W LBL_396
LBL_399:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_85
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        MOVE.L -4(A6),D0
        MOVE.L D0,-6092(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_396
LBL_400:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_396
LBL_397:
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_401
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_402
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_396
LBL_402:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_403
        MOVE.L -4(A6),D0
        MOVE.L D0,-6092(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_396
LBL_403:
        MOVEQ #0,D0
        BRA.W LBL_396
LBL_401:
        MOVEQ #0,D0
        BRA.W LBL_396
LBL_396:
        UNLK A6
        RTS
        ; func rtAdspAvail  (JT slot 470)
        ;   param slot : 8(A6)  size 4
LBL_39:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
        BRA.W LBL_404
LBL_404:
        UNLK A6
        RTS
        ; func rtAdspReadInto  (JT slot 471)
        ;   param slot : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local got : -8(A6)  size 4
        ;   local scratch : -12(A6)  size 4
LBL_40:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_87
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
        MOVEQ #0,D0
        BRA.W LBL_405
LBL_406:
        MOVE.L -4(A6),D1
        MOVE.L #1024,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_407
        MOVE.L #1024,D0
        MOVE.L D0,-4(A6)
LBL_407:
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
        BEQ.W LBL_408
        MOVEQ #-108,D0
        MOVE.L D0,-6092(A5)
        MOVEQ #0,D0
        BRA.W LBL_405
LBL_408:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_409
        MOVE.L -8(A6),D0
        MOVE.L D0,-6092(A5)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_409:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDA.W #12,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
        MOVE.L -8(A6),D0
        BRA.W LBL_405
LBL_405:
        UNLK A6
        RTS
        ; func rtAdspWrite  (JT slot 472)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_41:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4234(A5)
        ADDA.W #12,A7
        BRA.W LBL_410
LBL_410:
        UNLK A6
        RTS
        ; func rtAdspClose  (JT slot 473)
        ;   param slot : 8(A6)  size 4
LBL_42:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4242(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_28
        ADDQ.L #4,A7
LBL_411:
        UNLK A6
        RTS
        ; func rtAdspGone  (JT slot 474)
        ;   param slot : 8(A6)  size 4
LBL_43:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_89
        ADDQ.L #4,A7
        BRA.W LBL_412
LBL_412:
        UNLK A6
        RTS
        ; func rtAtalkPump  (JT slot 475)
        ;   local i : -4(A6)  size 4
        ;   local code : -8(A6)  size 4
        ;   local pr : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local req : -20(A6)  size 4
        ;   local free : -24(A6)  size 4
        ;   local j : -28(A6)  size 4
        ;   local e : -32(A6)  size 4
        ;   local __store3 : -36(A6)  size 4
LBL_44:
        LINK A6,#-604
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
        JSR 154(A5)
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
        JSR 4378(A5)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_414:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_415
        LEA -2394(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_416
        LEA -2394(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2394(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -2906(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4946(A5)
        ADDA.W #12,A7
        LEA -2906(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_416:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_414
LBL_415:
        CLR.L D0
        MOVE.B -2378(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_417
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_413
LBL_417:
        BSR.W LBL_79
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_418:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_419
        LEA -3464(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_420
        LEA -3464(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3464(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -3976(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4986(A5)
        ADDA.W #12,A7
        LEA -3976(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_420:
        LEA -3442(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_421
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_422
LBL_421:
        MOVEQ #0,D0
LBL_422:
        TST.L D0
        BEQ.W LBL_423
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
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
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_27
        ADDA.W #12,A7
        BRA.W LBL_425
LBL_424:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
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
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVE.L #578,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_427
        MOVE.L #578,D0
        MOVE.L D0,-16(A6)
LBL_427:
        LEA -36(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 154(A5)
        MOVE.L D0,-40(A6)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L -40(A6),D0
        MOVE.L D0,-36(A6)
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
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
        BSR.W LBL_75
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDA.W #12,A7
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -3454(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3456(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_72
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 4978(A5)
        ADDA.W #16,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3454(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        LEA -3456(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -3456(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
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
        BSR.W LBL_76
        ADDA.W #16,A7
LBL_428:
LBL_426:
LBL_425:
        LEA -3452(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_429
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_430
LBL_429:
        MOVEQ #0,D0
LBL_430:
        TST.L D0
        BEQ.W LBL_431
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -3450(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_432
        MOVEQ #1,D0
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
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
LBL_432:
LBL_431:
LBL_423:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_418
LBL_419:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_433:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
        LEA -2922(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_435
        LEA -2922(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2922(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -3434(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 4970(A5)
        ADDA.W #12,A7
        LEA -3434(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_436
LBL_435:
        LEA -2914(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_437
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_62
        ADDQ.L #4,A7
        BRA.W LBL_438
LBL_437:
        MOVEQ #0,D0
LBL_438:
        TST.L D0
        BEQ.W LBL_439
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2914(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_440:
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_442
        LEA -2914(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_443
LBL_442:
        MOVEQ #0,D0
LBL_443:
        TST.L D0
        BEQ.W LBL_441
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        LEA -556(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_66
        ADDA.W #12,A7
        LEA -556(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 4954(A5)
        ADDA.W #12,A7
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_440
LBL_441:
        LEA -2914(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_444
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4962(A5)
        ADDQ.L #4,A7
LBL_444:
LBL_439:
LBL_436:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_433
LBL_434:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_445:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_446
        LEA -2386(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_447
        LEA -6712(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_448
LBL_447:
        MOVEQ #0,D0
LBL_448:
        TST.L D0
        BEQ.W LBL_449
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4274(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_450
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        BRA.W LBL_451
LBL_450:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_452
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_453:
        MOVE.L -28(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_454
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_460
LBL_459:
        MOVEQ #0,D0
LBL_460:
        TST.L D0
        BEQ.W LBL_457
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_458
LBL_457:
        MOVEQ #0,D0
LBL_458:
        TST.L D0
        BEQ.W LBL_455
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_91
        ADDQ.L #4,A7
        BRA.W LBL_456
LBL_455:
        MOVEQ #0,D0
LBL_456:
        TST.L D0
        BEQ.W LBL_461
        MOVE.L -28(A6),D0
        MOVE.L D0,-24(A6)
LBL_461:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_453
LBL_454:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_462
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4290(A5)
        ADDQ.L #4,A7
        BRA.W LBL_463
LBL_462:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 4282(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_464
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        BRA.W LBL_465
LBL_464:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -212(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6088(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        JSR 4938(A5)
        ADDQ.L #8,A7
LBL_465:
LBL_463:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4266(A5)
        ADDQ.L #4,A7
LBL_452:
LBL_451:
LBL_449:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_445
LBL_446:
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_413:
        UNLK A6
        RTS
        ; func rtAtalkAlive  (JT slot 476)
        ;   local i : -4(A6)  size 4
LBL_45:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_467:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_468
        LEA -3442(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BNE.W LBL_469
        LEA -3464(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_470
LBL_469:
        MOVEQ #1,D0
LBL_470:
        TST.L D0
        BEQ.W LBL_471
        MOVEQ #1,D0
        BRA.W LBL_466
LBL_471:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_467
LBL_468:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_472:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_473
        LEA -2914(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BNE.W LBL_474
        LEA -2922(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_475
LBL_474:
        MOVEQ #1,D0
LBL_475:
        TST.L D0
        BEQ.W LBL_476
        MOVEQ #1,D0
        BRA.W LBL_466
LBL_476:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_472
LBL_473:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_477:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_478
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_479
        LEA -6056(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_480
LBL_479:
        MOVEQ #0,D0
LBL_480:
        TST.L D0
        BEQ.W LBL_481
        MOVEQ #1,D0
        BRA.W LBL_466
LBL_481:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_477
LBL_478:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_482:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_483
        LEA -2386(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BNE.W LBL_484
        LEA -2394(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_485
LBL_484:
        MOVEQ #1,D0
LBL_485:
        TST.L D0
        BEQ.W LBL_486
        MOVEQ #1,D0
        BRA.W LBL_466
LBL_486:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_482
LBL_483:
        MOVEQ #0,D0
        BRA.W LBL_466
LBL_466:
        UNLK A6
        RTS
        ; func rtAtalkAddrStr  (JT slot 477)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param addr : 12(A6)  size 4
LBL_46:
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
        JSR 138(A5)
        ADDQ.L #8,A7
        LEA -2052(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_97(PC),A0
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
        JSR 138(A5)
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
        LEA LBL_97(PC),A0
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
        JSR 138(A5)
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
        BRA.W LBL_487
LBL_487:
        UNLK A6
        RTS
        ; func rtAt68SignW  (JT slot 478)
        ;   param v : 8(A6)  size 4
LBL_47:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_489
        MOVE.L 8(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_488
LBL_489:
        MOVE.L 8(A6),D0
        BRA.W LBL_488
LBL_488:
        UNLK A6
        RTS
        ; func rtAt68Zero  (JT slot 479)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
LBL_48:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_491
        BRA.W LBL_490
LBL_491:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_492:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_493
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
        BRA.W LBL_492
LBL_493:
LBL_494:
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_495
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
        BRA.W LBL_494
LBL_495:
LBL_490:
        UNLK A6
        RTS
        ; func rtAt68Pending  (JT slot 480)
        ;   param pb : 8(A6)  size 4
LBL_49:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_497
        MOVEQ #0,D0
        BRA.W LBL_496
LBL_497:
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
        BRA.W LBL_496
LBL_496:
        UNLK A6
        RTS
        ; func rtAt68Result  (JT slot 481)
        ;   param pb : 8(A6)  size 4
LBL_50:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        BRA.W LBL_498
LBL_498:
        UNLK A6
        RTS
        ; func rtAt68PStr  (JT slot 482)
        ;   param p : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_51:
        LINK A6,#-60
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
        BEQ.W LBL_500
        MOVEQ #32,D0
        MOVE.L D0,-8(A6)
LBL_500:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_501:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_502
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
        BCS.W LBL_503
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 130(A5)
        ADDQ.L #8,A7
LBL_503:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_501
LBL_502:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_499
LBL_499:
        UNLK A6
        RTS
        ; func rtAt68GetPStr  (JT slot 483)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   local s : -256(A6)  size 256
        ;   local i : -260(A6)  size 4
        ;   local n : -264(A6)  size 4
LBL_52:
        LINK A6,#-316
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
LBL_505:
        MOVE.L -260(A6),D1
        MOVE.L -264(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_506
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
        BRA.W LBL_505
LBL_506:
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_504
LBL_504:
        UNLK A6
        RTS
        ; func rtAt68SkipPStr  (JT slot 484)
        ;   param p : 8(A6)  size 4
LBL_53:
        LINK A6,#-52
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
        BRA.W LBL_507
LBL_507:
        UNLK A6
        RTS
        ; func rtAt68PackAddr  (JT slot 485)
        ;   param p : 8(A6)  size 4
LBL_54:
        LINK A6,#-52
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
        BRA.W LBL_508
LBL_508:
        UNLK A6
        RTS
        ; func rtAt68PokeAddr  (JT slot 486)
        ;   param p : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_55:
        LINK A6,#-52
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
LBL_509:
        UNLK A6
        RTS
        ; func rtAt68OpenDrv  (JT slot 487)
        ;   param name : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
        ;   local nm : -54(A6)  size 4
        ;   local e : -58(A6)  size 4
LBL_56:
        LINK A6,#-110
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_511:
        CLR.L (A0)+
        DBRA D0,LBL_511
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
        BEQ.W LBL_512
        MOVEQ #-108,D0
        MOVE.L D0,-6114(A5)
        MOVEQ #0,D0
        BRA.W LBL_510
LBL_512:
        MOVE.L -54(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_51
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
        BEQ.W LBL_513
        MOVE.L -58(A6),D0
        MOVE.L D0,-6114(A5)
        MOVEQ #0,D0
        BRA.W LBL_510
LBL_513:
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        BRA.W LBL_510
LBL_510:
        UNLK A6
        RTS
        ; func rtAtDevUp  (JT slot 488)
LBL_57:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -6110(A5),D0
        TST.L D0
        BEQ.W LBL_515
        MOVEQ #0,D0
        BRA.W LBL_514
LBL_515:
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-6096(A5)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_516
        MOVE.L -6114(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_517
        MOVE.L #-1273,D0
        MOVE.L D0,-6114(A5)
LBL_517:
        MOVE.L -6114(A5),D0
        BRA.W LBL_514
LBL_516:
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-6100(A5)
        MOVE.L -6100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_518
        MOVE.L -6114(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_519
        MOVE.L #-1273,D0
        MOVE.L D0,-6114(A5)
LBL_519:
        MOVE.L -6114(A5),D0
        BRA.W LBL_514
LBL_518:
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-6104(A5)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #4,A7
        MOVE.L D0,-6108(A5)
        MOVEQ #0,D0
        MOVE.L D0,-6114(A5)
        MOVEQ #1,D0
        MOVE.B D0,-6110(A5)
        MOVEQ #0,D0
        BRA.W LBL_514
LBL_514:
        UNLK A6
        RTS
        ; func rtAt68PStrEq  (JT slot 489)
        ;   param p : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_58:
        LINK A6,#-60
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
        BEQ.W LBL_521
        MOVEQ #32,D0
        MOVE.L D0,-8(A6)
LBL_521:
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
        BEQ.W LBL_522
        MOVEQ #0,D0
        BRA.W LBL_520
LBL_522:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_523:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_524
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
        BCS.W LBL_525
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 130(A5)
        ADDQ.L #8,A7
LBL_525:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_526
        MOVEQ #0,D0
        BRA.W LBL_520
LBL_526:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_523
LBL_524:
        MOVEQ #1,D0
        BRA.W LBL_520
LBL_520:
        UNLK A6
        RTS
        ; func rtAt68NteFind  (JT slot 490)
        ;   param obj : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local ent : -8(A6)  size 4
LBL_59:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_528:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_529
        LEA -6266(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_530
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_531
LBL_530:
        MOVEQ #0,D0
LBL_531:
        TST.L D0
        BEQ.W LBL_532
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BSR.W LBL_58
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_533
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_58
        ADDQ.L #8,A7
        BRA.W LBL_534
LBL_533:
        MOVEQ #0,D0
LBL_534:
        TST.L D0
        BEQ.W LBL_535
        MOVE.L -4(A6),D0
        BRA.W LBL_527
LBL_535:
LBL_532:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_528
LBL_529:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_527
LBL_527:
        UNLK A6
        RTS
        ; func rtAtDevRegister  (JT slot 491)
        ;   param obj : 16(A6)  size 4
        ;   param typ : 12(A6)  size 4
        ;   param sock : 8(A6)  size 4
        ;   local pb : -52(A6)  size 52
        ;   local nte : -56(A6)  size 4
        ;   local end : -60(A6)  size 4
        ;   local k : -64(A6)  size 4
        ;   local e : -68(A6)  size 4
LBL_60:
        LINK A6,#-120
        LEA -52(A6),A0
        MOVE.W #12,D0
LBL_537:
        CLR.L (A0)+
        DBRA D0,LBL_537
        MOVEQ #0,D0
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_538
        MOVE.L #-1273,D0
        BRA.W LBL_536
LBL_538:
        MOVEQ #0,D0
        MOVE.L D0,-64(A6)
LBL_539:
        MOVE.L -64(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_541
        LEA -6266(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_542
LBL_541:
        MOVEQ #0,D0
LBL_542:
        TST.L D0
        BEQ.W LBL_540
        MOVE.L -64(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-64(A6)
        BRA.W LBL_539
LBL_540:
        MOVE.L -64(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_543
        MOVEQ #-108,D0
        BRA.W LBL_536
LBL_543:
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_544
        MOVEQ #108,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_545
        MOVEQ #-108,D0
        BRA.W LBL_536
LBL_545:
LBL_544:
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-56(A6)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #108,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        MOVE.L -56(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -56(A6),D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_51
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
        LEA -28(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #253,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -24(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -23(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -22(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -18(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -52(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-68(A6)
        MOVE.L -68(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_546
        MOVE.L -68(A6),D0
        MOVE.L D0,-6114(A5)
        MOVE.L -68(A6),D0
        BRA.W LBL_536
LBL_546:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6266(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_536
LBL_536:
        UNLK A6
        RTS
        ; func rtAtDevRemove  (JT slot 492)
        ;   param obj : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local pb : -52(A6)  size 52
        ;   local k : -56(A6)  size 4
        ;   local e : -60(A6)  size 4
LBL_61:
        LINK A6,#-112
        LEA -52(A6),A0
        MOVE.W #12,D0
LBL_548:
        CLR.L (A0)+
        DBRA D0,LBL_548
        MOVEQ #0,D0
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_549
        MOVE.L #-1273,D0
        BRA.W LBL_547
LBL_549:
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_59
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_550
        MOVE.L #-1028,D0
        BRA.W LBL_547
LBL_550:
        LEA -28(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
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
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6266(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
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
        BEQ.W LBL_551
        MOVE.L -60(A6),D0
        MOVE.L D0,-6114(A5)
LBL_551:
        MOVE.L -60(A6),D0
        BRA.W LBL_547
LBL_547:
        UNLK A6
        RTS
        ; func rtAtDevLookupDone  (JT slot 493)
        ;   param lk : 8(A6)  size 4
LBL_62:
        LINK A6,#-52
        LEA -6158(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_553
        MOVEQ #1,D0
        BRA.W LBL_552
LBL_553:
        LEA -6158(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_552
LBL_552:
        UNLK A6
        RTS
        ; func rtAtDevLookupCount  (JT slot 494)
        ;   param lk : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
LBL_63:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -6158(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_555
        MOVEQ #0,D0
        BRA.W LBL_554
LBL_555:
        LEA -6158(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_556
        MOVEQ #0,D0
        BRA.W LBL_554
LBL_556:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_557
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVE.L D0,-6114(A5)
        MOVEQ #0,D0
        BRA.W LBL_554
LBL_557:
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_554
LBL_554:
        UNLK A6
        RTS
        ; func rtAt68LkTuple  (JT slot 495)
        ;   param lk : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local j : -8(A6)  size 4
LBL_64:
        LINK A6,#-60
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
        BNE.W LBL_559
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_63
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_560
LBL_559:
        MOVEQ #1,D0
LBL_560:
        TST.L D0
        BEQ.W LBL_561
        MOVEQ #0,D0
        BRA.W LBL_558
LBL_561:
        LEA -6246(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_562:
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_563
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_562
LBL_563:
        MOVE.L -4(A6),D0
        BRA.W LBL_558
LBL_558:
        UNLK A6
        RTS
        ; func rtAtDevLookupAddr  (JT slot 496)
        ;   param lk : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_65:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_64
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_565
        MOVEQ #0,D0
        BRA.W LBL_564
LBL_565:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        BRA.W LBL_564
LBL_564:
        UNLK A6
        RTS
        ; func rtAtDevLookupName  (JT slot 497)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param lk : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local obj : -260(A6)  size 256
        ;   local typ : -516(A6)  size 256
LBL_66:
        LINK A6,#-1080
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
        BSR.W LBL_64
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_567
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_566
LBL_567:
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_52
        ADDQ.L #8,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_112(PC),A0
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
        BRA.W LBL_566
LBL_566:
        UNLK A6
        RTS
        ; func rtAtDevAtpOpen  (JT slot 498)
        ;   local pb : -56(A6)  size 56
        ;   local e : -60(A6)  size 4
LBL_67:
        LINK A6,#-112
        LEA -56(A6),A0
        MOVE.W #13,D0
LBL_569:
        CLR.L (A0)+
        DBRA D0,LBL_569
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVE.L -6100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_570
        MOVE.L #-1273,D0
        MOVE.L D0,-6114(A5)
        MOVEQ #0,D0
        BRA.W LBL_568
LBL_570:
        LEA -32(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6100(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -30(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #254,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -28(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -56(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
        MOVE.L D0,-60(A6)
        MOVE.L -60(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_571
        MOVE.L -60(A6),D0
        MOVE.L D0,-6114(A5)
        MOVEQ #0,D0
        BRA.W LBL_568
LBL_571:
        LEA -28(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_568
LBL_568:
        UNLK A6
        RTS
        ; func rtAtDevAtpClose  (JT slot 499)
        ;   param sock : 8(A6)  size 4
        ;   local pb : -56(A6)  size 56
LBL_68:
        LINK A6,#-108
        LEA -56(A6),A0
        MOVE.W #13,D0
LBL_573:
        CLR.L (A0)+
        DBRA D0,LBL_573
        MOVE.L -6100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_574
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_575
LBL_574:
        MOVEQ #1,D0
LBL_575:
        TST.L D0
        BEQ.W LBL_576
        BRA.W LBL_572
LBL_576:
        LEA -32(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6100(A5),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -30(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L #250,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -28(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        LEA -56(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A004  ; PBControlSync
LBL_572:
        UNLK A6
        RTS
        ; func rtAt68SvcEnsure  (JT slot 500)
        ;   param slot : 8(A6)  size 4
LBL_69:
        LINK A6,#-52
        LEA -6274(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_578
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6274(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_578:
        LEA -6282(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_579
        MOVE.L #600,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6282(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_579:
        LEA -6290(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_580
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6290(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_580:
        LEA -6298(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_581
        MOVE.L #4624,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6298(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_581:
        LEA -6306(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_582
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6306(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_582:
        LEA -6274(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6282(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_590
LBL_589:
        MOVEQ #0,D0
LBL_590:
        TST.L D0
        BEQ.W LBL_587
        LEA -6290(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_588
LBL_587:
        MOVEQ #0,D0
LBL_588:
        TST.L D0
        BEQ.W LBL_585
        LEA -6298(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_586
LBL_585:
        MOVEQ #0,D0
LBL_586:
        TST.L D0
        BEQ.W LBL_583
        LEA -6306(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_584
LBL_583:
        MOVEQ #0,D0
LBL_584:
        BRA.W LBL_577
LBL_577:
        UNLK A6
        RTS
        ; func rtAtDevAtpArm  (JT slot 501)
        ;   param slot : 12(A6)  size 4
        ;   param sock : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_70:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_592
        MOVE.L #-1273,D0
        BRA.W LBL_591
LBL_592:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_593
        MOVEQ #-108,D0
        BRA.W LBL_591
LBL_593:
        LEA -6274(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_594
        MOVE.L #-1273,D0
        BRA.W LBL_591
LBL_594:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -6314(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6100(A5),D0
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
        LEA -6282(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_595
        MOVE.L -8(A6),D0
        MOVE.L D0,-6114(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_591
LBL_595:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6316(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_591
LBL_591:
        UNLK A6
        RTS
        ; func rtAtDevAtpPoll  (JT slot 502)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local res : -8(A6)  size 4
LBL_71:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -6316(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        MOVEQ #0,D0
        BRA.W LBL_596
LBL_597:
        LEA -6274(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_598
        MOVEQ #0,D0
        BRA.W LBL_596
LBL_598:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6316(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_599
        MOVE.L -8(A6),D0
        MOVE.L D0,-6114(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_596
LBL_599:
        MOVE.L -4(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -6324(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #30,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -6332(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6340(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6348(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6356(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_596
LBL_596:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqOp  (JT slot 503)
        ;   param slot : 8(A6)  size 4
LBL_72:
        LINK A6,#-52
        LEA -6324(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_600
LBL_600:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqFrom  (JT slot 504)
        ;   param slot : 8(A6)  size 4
LBL_73:
        LINK A6,#-52
        LEA -6332(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_601
LBL_601:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqLen  (JT slot 505)
        ;   param slot : 8(A6)  size 4
LBL_74:
        LINK A6,#-52
        LEA -6340(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_602
LBL_602:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqPtr  (JT slot 506)
        ;   param slot : 8(A6)  size 4
LBL_75:
        LINK A6,#-52
        LEA -6282(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_603
LBL_603:
        UNLK A6
        RTS
        ; func rtAtDevAtpRespond  (JT slot 507)
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
LBL_76:
        LINK A6,#-88
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
        MOVE.L -6100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_605
        MOVE.L #-1273,D0
        BRA.W LBL_604
LBL_605:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_606
        MOVEQ #-108,D0
        BRA.W LBL_604
LBL_606:
        LEA -6290(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_607
        MOVE.L #-1273,D0
        BRA.W LBL_604
LBL_607:
        LEA -6306(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        LEA -6298(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_608
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_608:
        MOVE.L -32(A6),D1
        MOVE.L #4624,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_609
        MOVE.L #4624,D0
        MOVE.L D0,-32(A6)
LBL_609:
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_610
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_611
LBL_610:
        MOVEQ #0,D0
LBL_611:
        TST.L D0
        BEQ.W LBL_612
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
LBL_612:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
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
        BSR.W LBL_142
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_613
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
LBL_613:
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_614
        MOVEQ #8,D0
        MOVE.L D0,-16(A6)
LBL_614:
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_615:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_616
        MOVE.L -20(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_141
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
        BEQ.W LBL_617
        MOVE.L #578,D0
        MOVE.L D0,-28(A6)
LBL_617:
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_618
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_618:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_141
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
        BSR.W LBL_141
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
        BSR.W LBL_141
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
        BEQ.W LBL_619
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_141
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_619:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_615
LBL_616:
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6100(A5),D0
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
        LEA -6314(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6356(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6332(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
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
        LEA -6348(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_620
        MOVE.L -36(A6),D0
        MOVE.L D0,-6114(A5)
        MOVE.L -36(A6),D0
        BRA.W LBL_604
LBL_620:
        MOVEQ #0,D0
        BRA.W LBL_604
LBL_604:
        UNLK A6
        RTS
        ; func rtAtDevAtpRespBusy  (JT slot 508)
        ;   param slot : 8(A6)  size 4
LBL_77:
        LINK A6,#-52
        LEA -6290(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_622
        MOVEQ #0,D0
        BRA.W LBL_621
LBL_622:
        LEA -6290(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        BRA.W LBL_621
LBL_621:
        UNLK A6
        RTS
        ; func rtAtDevLastErr  (JT slot 509)
LBL_78:
        LINK A6,#-52
        MOVE.L -6114(A5),D0
        BRA.W LBL_623
LBL_623:
        UNLK A6
        RTS
        ; func rtAtDevPoll  (JT slot 510)
LBL_79:
        LINK A6,#-52
LBL_624:
        UNLK A6
        RTS
        ; func rtAt68DspAuxPb  (JT slot 511)
LBL_80:
        LINK A6,#-52
        MOVE.L -6598(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_626
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-6598(A5)
LBL_626:
        MOVE.L -6598(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_627
        MOVE.L -6598(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
LBL_627:
        MOVE.L -6598(A5),D0
        BRA.W LBL_625
LBL_625:
        UNLK A6
        RTS
        ; func rtAt68CcbEnsure  (JT slot 512)
        ;   param slot : 8(A6)  size 4
LBL_81:
        LINK A6,#-52
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_629
        MOVE.L #242,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_629:
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_630
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_630:
        LEA -6490(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_631
        MOVE.L #1024,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6490(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_631:
        LEA -6522(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_632
        MOVE.L #1024,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6522(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_632:
        LEA -6554(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_633
        MOVE.L #570,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6554(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_633:
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_640
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_641
LBL_640:
        MOVEQ #0,D0
LBL_641:
        TST.L D0
        BEQ.W LBL_638
        LEA -6490(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_639
LBL_638:
        MOVEQ #0,D0
LBL_639:
        TST.L D0
        BEQ.W LBL_636
        LEA -6522(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_637
LBL_636:
        MOVEQ #0,D0
LBL_637:
        TST.L D0
        BEQ.W LBL_634
        LEA -6554(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_635
LBL_634:
        MOVEQ #0,D0
LBL_635:
        BRA.W LBL_628
LBL_628:
        UNLK A6
        RTS
        ; func rtAt68DspFree  (JT slot 513)
        ;   param slot : 8(A6)  size 4
LBL_82:
        LINK A6,#-52
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_643
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_643:
        LEA -6490(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_644
        LEA -6490(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6490(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_644:
        LEA -6522(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_645
        LEA -6522(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6522(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_645:
        LEA -6554(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_646
        LEA -6554(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6554(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_646:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_642:
        UNLK A6
        RTS
        ; func rtAt68DspInitEnd  (JT slot 514)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_83:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_81
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_648
        MOVEQ #-108,D0
        BRA.W LBL_647
LBL_648:
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_649
        MOVE.L #-1273,D0
        BRA.W LBL_647
LBL_649:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L #242,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6108(A5),D0
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
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6490(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6522(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6554(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_650
        MOVE.L -8(A6),D0
        MOVE.L D0,-6114(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_647
LBL_650:
        MOVE.L -4(A6),D1
        MOVEQ #32,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_647
LBL_647:
        UNLK A6
        RTS
        ; func rtAt68DspRemoveEnd  (JT slot 515)
        ;   param slot : 8(A6)  size 4
        ;   local aux : -4(A6)  size 4
LBL_84:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_652
        BRA.W LBL_651
LBL_652:
        BSR.W LBL_80
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_653
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6108(A5),D0
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
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
LBL_653:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_651:
        UNLK A6
        RTS
        ; func rtAdspDevOpen  (JT slot 516)
        ;   param slot : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_85:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6108(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_655
        MOVE.L #-1273,D0
        BRA.W LBL_654
LBL_655:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_83
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_656
        MOVE.L -8(A6),D0
        BRA.W LBL_654
LBL_656:
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6108(A5),D0
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
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BSR.W LBL_55
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
        BEQ.W LBL_657
        MOVE.L -8(A6),D0
        MOVE.L D0,-6114(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        BRA.W LBL_654
LBL_657:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6594(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_654
LBL_654:
        UNLK A6
        RTS
        ; func rtAdspDevOpenPoll  (JT slot 517)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local res : -8(A6)  size 4
LBL_86:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6108(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_659
        MOVE.L #-1273,D0
        BRA.W LBL_658
LBL_659:
        LEA -6594(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_660
        MOVE.L #-1273,D0
        BRA.W LBL_658
LBL_660:
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_661
        MOVEQ #0,D0
        BRA.W LBL_658
LBL_661:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6594(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_662
        MOVE.L -8(A6),D0
        MOVE.L D0,-6114(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_84
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        MOVE.L -8(A6),D0
        BRA.W LBL_658
LBL_662:
        MOVEQ #1,D0
        BRA.W LBL_658
LBL_658:
        UNLK A6
        RTS
        ; func rtAdspDevAvail  (JT slot 518)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
LBL_87:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -6108(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_664
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_665
LBL_664:
        MOVEQ #1,D0
LBL_665:
        TST.L D0
        BEQ.W LBL_666
        MOVEQ #0,D0
        BRA.W LBL_663
LBL_666:
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_667
        MOVEQ #0,D0
        BRA.W LBL_663
LBL_667:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6108(A5),D0
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
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_668
        MOVEQ #0,D0
        BRA.W LBL_663
LBL_668:
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_663
LBL_663:
        UNLK A6
        RTS
        ; func rtAdspDevRead  (JT slot 519)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_88:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L -6108(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_670
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_671
LBL_670:
        MOVEQ #1,D0
LBL_671:
        TST.L D0
        BEQ.W LBL_672
        MOVEQ #0,D0
        BRA.W LBL_669
LBL_672:
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_673
        MOVEQ #0,D0
        BRA.W LBL_669
LBL_673:
        LEA -6458(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_674
        MOVEQ #0,D0
        BRA.W LBL_669
LBL_674:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_48
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6108(A5),D0
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
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_675
        MOVE.L -8(A6),D0
        MOVE.L D0,-6114(A5)
        MOVEQ #0,D0
        BRA.W LBL_669
LBL_675:
        MOVE.L -4(A6),D1
        MOVEQ #36,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_669
LBL_669:
        UNLK A6
        RTS
        ; func rtAdspDevGone  (JT slot 520)
        ;   param slot : 8(A6)  size 4
LBL_89:
        LINK A6,#-52
        LEA -6586(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BNE.W LBL_677
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_678
LBL_677:
        MOVEQ #1,D0
LBL_678:
        TST.L D0
        BEQ.W LBL_679
        MOVEQ #1,D0
        BRA.W LBL_676
LBL_679:
        LEA -6426(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BRA.W LBL_676
LBL_676:
        UNLK A6
        RTS
        ; func rtLsnDevSocket  (JT slot 521)
        ;   param slot : 8(A6)  size 4
LBL_90:
        LINK A6,#-52
        LEA -6376(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
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
        BEQ.W LBL_681
        MOVEQ #0,D0
        BRA.W LBL_680
LBL_681:
        LEA -6376(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #9,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_680
LBL_680:
        UNLK A6
        RTS
        ; func rtTcpFree  (JT slot 522)
        ;   param slot : 8(A6)  size 4
LBL_91:
        LINK A6,#-52
        LEA -6630(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_141
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_682
LBL_682:
        UNLK A6
        RTS
        ; func rtTcpDevLsnDeny  (JT slot 523)
        ;   param lsn : 8(A6)  size 4
LBL_92:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4514(A5)
        ADDQ.L #4,A7
LBL_683:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 524)
        ;   param path : 8(A6)  size 4
LBL_93:
        LINK A6,#-52
LBL_684:
        UNLK A6
        RTS
LBL_141:
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
LBL_142:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_685
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_685:
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
        BPL.W LBL_686
        NEG.L D2
        MOVE.L #1,D4
LBL_686:
        CLR.L D5
        TST.L D3
        BPL.W LBL_687
        NEG.L D3
        MOVE.L #1,D5
LBL_687:
        CLR.L D6
        MOVE.W #31,D7
LBL_688:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_689
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_689:
        DBRA D7,LBL_688
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_690
        NEG.L D2
LBL_690:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_143:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_691
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_140(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_691:
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
        BPL.W LBL_692
        NEG.L D2
        MOVE.L #1,D4
LBL_692:
        CLR.L D5
        TST.L D3
        BPL.W LBL_693
        NEG.L D3
        MOVE.L #1,D5
LBL_693:
        CLR.L D6
        MOVE.W #31,D7
LBL_694:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_695
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_695:
        DBRA D7,LBL_694
        TST.L D4
        BEQ.W LBL_696
        NEG.L D6
LBL_696:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_144:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_697(PC),A0
        MOVE.L A0,-4(A6)
LBL_698:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_699
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_700
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_698
LBL_700:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_701:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 274(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_698
LBL_699:
        UNLK A6
        RTS
LBL_697:
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
LBL_140:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_101:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_102:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_103:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_104:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_105:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_106:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_107:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_108:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_109:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_110:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_111:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_98:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_99:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_100:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_95:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_96:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_113:
        DC.B $15
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_115:
        DC.B $13
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E
LBL_116:
        DC.B $0C
        DC.B $77,$72,$69,$74,$65,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_94:
        DC.B $00
        DC.B $00
LBL_114:
        DC.B $19
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_117:
        DC.B $0B
        DC.B $6E,$61,$6D,$65,$20,$69,$6E,$20,$75,$73,$65
LBL_118:
        DC.B $17
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$67,$69,$73,$74,$65,$72,$20,$6E,$61,$6D,$65
LBL_119:
        DC.B $12
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$73,$65,$72,$76,$69,$63,$65
        DC.B $00
LBL_120:
        DC.B $17
        DC.B $73,$65,$72,$76,$69,$63,$65,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$73,$65,$72,$76,$69,$6E,$67
LBL_121:
        DC.B $15
        DC.B $41,$70,$70,$6C,$65,$54,$61,$6C,$6B,$20,$75,$6E,$61,$76,$61,$69,$6C,$61,$62,$6C,$65
LBL_122:
        DC.B $15
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$73,$6F,$63,$6B,$65,$74
LBL_123:
        DC.B $1A
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$63,$65,$69,$76,$65,$20,$72,$65,$71,$75,$65,$73,$74,$73
        DC.B $00
LBL_124:
        DC.B $1F
        DC.B $72,$65,$70,$6C,$79,$20,$6F,$75,$74,$73,$69,$64,$65,$20,$61,$20,$72,$65,$71,$75,$65,$73,$74,$20,$68,$61,$6E,$64,$6C,$65,$72
LBL_125:
        DC.B $12
        DC.B $72,$65,$70,$6C,$79,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$73,$65,$6E,$74
        DC.B $00
LBL_126:
        DC.B $0E
        DC.B $72,$65,$70,$6C,$79,$20,$74,$6F,$6F,$20,$6C,$6F,$6E,$67
        DC.B $00
LBL_127:
        DC.B $0C
        DC.B $72,$65,$70,$6C,$79,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_129:
        DC.B $13
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$6C,$69,$73,$74,$65,$6E,$65,$72
LBL_130:
        DC.B $1B
        DC.B $6C,$69,$73,$74,$65,$6E,$65,$72,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$72,$65,$67,$69,$73,$74,$65,$72,$65,$64
LBL_131:
        DC.B $22
        DC.B $73,$74,$72,$65,$61,$6D,$73,$20,$6E,$6F,$74,$20,$61,$76,$61,$69,$6C,$61,$62,$6C,$65,$20,$6F,$6E,$20,$74,$68,$69,$73,$20,$6C,$61,$6E,$65
        DC.B $00
LBL_132:
        DC.B $18
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$73,$74,$61,$72,$74,$20,$6C,$69,$73,$74,$65,$6E,$65,$72
        DC.B $00
LBL_133:
        DC.B $0E
        DC.B $72,$65,$71,$75,$65,$73,$74,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_134:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$65,$6E,$65,$72,$20,$66,$61,$69,$6C,$65,$64
LBL_135:
        DC.B $1B
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$61,$63,$63,$65,$70,$74,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_97:
        DC.B $01
        DC.B $2E
LBL_136:
        DC.B $04
        DC.B $2E,$4D,$50,$50
        DC.B $00
LBL_137:
        DC.B $04
        DC.B $2E,$41,$54,$50
        DC.B $00
LBL_138:
        DC.B $04
        DC.B $2E,$58,$50,$50
        DC.B $00
LBL_139:
        DC.B $04
        DC.B $2E,$44,$53,$50
        DC.B $00
LBL_128:
        DC.B $01
        DC.B $2A
LBL_112:
        DC.B $01
        DC.B $3A
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
