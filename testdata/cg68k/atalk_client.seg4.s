        ; func rtUiFormFill  (JT slot 437)
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
        JSR 874(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        JSR 2194(A5)
        MOVE.L D0,-68(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_145:
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_146
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1314(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1450(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -144(A5),D1
        MOVE.L -44(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-48(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 898(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 2082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
        MOVE.L -52(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_147
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_148
LBL_147:
        MOVEQ #0,D0
LBL_148:
        TST.L D0
        BEQ.W LBL_149
        MOVE.L -40(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_151
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1458(A5)
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
        BEQ.W LBL_153
        MOVE.L -76(A6),D0
        MOVE.L D0,-80(A6)
LBL_153:
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
        BRA.W LBL_152
LBL_151:
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_154
        MOVE.L -40(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_155
LBL_154:
        MOVEQ #1,D0
LBL_155:
        TST.L D0
        BEQ.W LBL_156
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
        BRA.W LBL_157
LBL_156:
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_158
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 2706(A5)
        ADDQ.L #8,A7
        BRA.W LBL_159
LBL_158:
        MOVE.L -40(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_160
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
        BEQ.W LBL_162
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
        BRA.W LBL_163
LBL_162:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_163:
        BRA.W LBL_161
LBL_160:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_161:
LBL_159:
LBL_157:
LBL_152:
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
        BRA.W LBL_150
LBL_149:
        MOVE.L -52(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_164
        MOVE.L -60(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_165
LBL_164:
        MOVEQ #0,D0
LBL_165:
        TST.L D0
        BEQ.W LBL_166
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
        BEQ.W LBL_168
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_169
LBL_168:
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_169:
        BRA.W LBL_167
LBL_166:
        MOVE.L -52(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_170
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1482(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-92(A6)
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_171:
        MOVE.L -96(A6),D1
        MOVE.L -84(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_172
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -72(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_173
        MOVE.L -96(A6),D0
        MOVE.L D0,-92(A6)
        MOVE.L -84(A6),D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_174
LBL_173:
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
LBL_174:
        BRA.W LBL_171
LBL_172:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        JSR 2682(A5)
        ADDA.W #12,A7
LBL_170:
LBL_167:
LBL_150:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_145
LBL_146:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_144:
        UNLK A6
        RTS
        ; func rtUiFormAccept  (JT slot 438)
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
        JSR 874(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_176:
        MOVE.L -32(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_177
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1314(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1450(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-48(A6)
        MOVE.L -144(A5),D1
        MOVE.L -48(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-52(A6)
        MOVE.L -44(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_178
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2266(A5)
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
        BEQ.W LBL_180
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3458(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_175
LBL_180:
        BRA.W LBL_179
LBL_178:
        MOVE.L -44(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2266(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
        ADDA.W #12,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3458(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_175
LBL_183:
        BRA.W LBL_182
LBL_181:
        MOVE.L -44(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_184
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2266(A5)
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
        JSR 3450(A5)
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_186
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3458(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_175
LBL_186:
        BRA.W LBL_185
LBL_184:
        MOVE.L -44(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_187
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2266(A5)
        ADDA.W #16,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1458(A5)
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
        BEQ.W LBL_189
        MOVE.L -62(A6),D0
        MOVE.L D0,-66(A6)
LBL_189:
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
LBL_190:
        MOVE.L -70(A6),D1
        MOVE.L -62(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_191
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
        BRA.W LBL_190
LBL_191:
        BRA.W LBL_188
LBL_187:
        MOVE.L -44(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_192
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2082(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-74(A6)
        MOVE.L -74(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_194
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
        BRA.W LBL_195
LBL_194:
        MOVEQ #0,D0
LBL_195:
        TST.L D0
        BEQ.W LBL_196
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_197
LBL_196:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_197:
        BRA.W LBL_193
LBL_192:
        MOVE.L -44(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_198
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2266(A5)
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
        BEQ.W LBL_200
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
        BRA.W LBL_201
LBL_200:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_201:
        BRA.W LBL_199
LBL_198:
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_202
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
        JSR 1466(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-82(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1482(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-86(A6)
        MOVE.L -82(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_205
        MOVE.L -78(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_206
LBL_205:
        MOVEQ #0,D0
LBL_206:
        TST.L D0
        BEQ.W LBL_203
        MOVE.L -78(A6),D1
        MOVE.L -82(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_204
LBL_203:
        MOVEQ #0,D0
LBL_204:
        TST.L D0
        BEQ.W LBL_207
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 1506(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        BRA.W LBL_208
LBL_207:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_208:
LBL_202:
LBL_199:
LBL_193:
LBL_188:
LBL_185:
LBL_182:
LBL_179:
        MOVE.L -32(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_176
LBL_177:
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -150(A5),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_209
        MOVE.L -154(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_211
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -154(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_211:
        BRA.W LBL_210
LBL_209:
        MOVE.L -150(A5),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_212
        MOVE.L -158(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_216
        MOVE.L -162(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_217
LBL_216:
        MOVEQ #0,D0
LBL_217:
        TST.L D0
        BEQ.W LBL_214
        MOVE.L -162(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -158(A5),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_215
LBL_214:
        MOVEQ #0,D0
LBL_215:
        TST.L D0
        BEQ.W LBL_218
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -158(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -162(A5),D0
        MOVE.L D0,-(A7)
        JSR 314(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
        MOVE.L -158(A5),D0
        MOVE.L D0,-(A7)
        JSR 378(A5)
        ADDQ.L #4,A7
LBL_218:
        BRA.W LBL_213
LBL_212:
        MOVE.L -150(A5),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_219
        MOVE.L -166(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_220
        MOVE.L -166(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -170(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        JSR 610(A5)
        ADDA.W #12,A7
LBL_220:
LBL_219:
LBL_213:
LBL_210:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_97(PC),A0
        MOVE.L A0,-(A7)
        JSR 3066(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-(A7)
        MOVE.L -144(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 5162(A5)
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3474(A5)
        ADDQ.L #4,A7
LBL_175:
        UNLK A6
        RTS
        ; func rtUiEdit  (JT slot 439)
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
        MOVE.B -132(A5),D0
        TST.L D0
        BEQ.W LBL_222
        LEA LBL_98(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_222:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 874(A5)
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
        BEQ.W LBL_223
        LEA LBL_99(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_223:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1274(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1426(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1514(A5)
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
        MOVE.B D0,-132(A5)
        MOVEQ #0,D0
        MOVE.L D0,-136(A5)
        MOVE.L -20(A6),D0
        MOVE.L D0,-140(A5)
        MOVE.L -16(A6),D0
        MOVE.L D0,-144(A5)
        MOVE.L 32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_224
        MOVEQ #1,D0
        MOVE.B D0,-146(A5)
        BRA.W LBL_225
LBL_224:
        MOVEQ #0,D0
        MOVE.B D0,-146(A5)
LBL_225:
        MOVE.L 28(A6),D0
        MOVE.L D0,-150(A5)
        MOVE.L 24(A6),D0
        MOVE.L D0,-154(A5)
        MOVE.L 20(A6),D0
        MOVE.L D0,-158(A5)
        MOVE.L 16(A6),D0
        MOVE.L D0,-162(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-166(A5)
        MOVE.L -170(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_226
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-170(A5)
LBL_226:
        MOVE.L -170(A5),D0
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
        BEQ.W LBL_227
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_228
LBL_227:
        MOVEQ #0,D0
LBL_228:
        TST.L D0
        BEQ.W LBL_229
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
        BEQ.W LBL_230
        MOVE.L #255,D0
        MOVE.L D0,-28(A6)
LBL_230:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -170(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; UiBlockMoveData
LBL_229:
        MOVE.L 40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1650(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-136(A5)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_0
        ADDQ.L #4,A7
LBL_221:
        UNLK A6
        RTS
        ; func rtUiAskOpen  (JT slot 440)
        ;   param path255 : 12(A6)  size 4
        ;   param filter : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_3:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -56(A5),D0
        TST.L D0
        BEQ.W LBL_232
        JSR 2986(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -66(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_233
        LEA LBL_100(PC),A0
        MOVE.L A0,-(A7)
        JSR 3394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 3026(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_231
LBL_233:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_234
        LEA LBL_101(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_231
LBL_234:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 2234(A5)
        ADDQ.L #8,A7
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3178(A5)
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_231
LBL_232:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3418(A5)
        ADDQ.L #8,A7
        BRA.W LBL_231
LBL_231:
        UNLK A6
        RTS
        ; func rtUiAskSave  (JT slot 441)
        ;   param path255 : 12(A6)  size 4
        ;   param suggested : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_4:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -56(A5),D0
        TST.L D0
        BEQ.W LBL_236
        JSR 2986(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -66(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_237
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        JSR 3394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 3026(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_235
LBL_237:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_238
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_235
LBL_238:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 2234(A5)
        ADDQ.L #8,A7
        LEA LBL_105(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3178(A5)
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_235
LBL_236:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3426(A5)
        ADDQ.L #8,A7
        BRA.W LBL_235
LBL_235:
        UNLK A6
        RTS
        ; func rtUiAskSaveChanges  (JT slot 442)
        ;   param name : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local empty : -16(A6)  size 4
        ;   local item : -20(A6)  size 4
        ;   local t : -24(A6)  size 4
LBL_5:
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
        MOVE.B -56(A5),D0
        TST.L D0
        BEQ.W LBL_240
        JSR 2986(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -66(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_241
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_239
LBL_241:
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        JSR 178(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_107(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_242
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_94(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        BRA.W LBL_243
LBL_242:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_244
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_95(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        BRA.W LBL_245
LBL_244:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_96(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
LBL_245:
LBL_243:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 3026(A5)
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        BRA.W LBL_239
LBL_240:
        JSR 1730(A5)
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
        BRA.W LBL_239
LBL_239:
        UNLK A6
        RTS
        ; func rtUiAlertMsg  (JT slot 443)
        ;   param msg : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local t : -16(A6)  size 4
        ;   local empty : -20(A6)  size 4
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
        JSR 4722(A5)
        TST.L D0
        BEQ.W LBL_247
        JSR 178(A5)
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_248:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_249
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
        BEQ.W LBL_250
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_250:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_248
LBL_249:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 3026(A5)
        ADDQ.L #4,A7
LBL_247:
        CLR.L D0
        MOVE.B -56(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_251
        JSR 1730(A5)
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
LBL_251:
LBL_246:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 444)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_7:
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
        BEQ.W LBL_253
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_253:
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
        BEQ.W LBL_254
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_254:
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
        BEQ.W LBL_255
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_255:
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
        BRA.W LBL_252
LBL_252:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 445)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_8:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_257
        BRA.W LBL_256
LBL_257:
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
        BEQ.W LBL_258
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_258:
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
        BEQ.W LBL_259
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
LBL_259:
LBL_256:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 446)
        ;   param m : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_262
LBL_261:
        MOVEQ #0,D0
LBL_262:
        BRA.W LBL_260
LBL_260:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 447)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_10:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_264
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
        BRA.W LBL_265
LBL_264:
        MOVEQ #1,D0
LBL_265:
        TST.L D0
        BEQ.W LBL_266
        LEA LBL_92(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_266:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3498(A5)
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
LBL_263:
        UNLK A6
        RTS
        ; func rtConnParseSpec  (JT slot 448)
        ;   param spec : 8(A6)  size 4
        ;   local colonIdx : -4(A6)  size 4
        ;   local name : -260(A6)  size 256
        ;   local baudStr : -516(A6)  size 256
        ;   local baud : -520(A6)  size 4
LBL_11:
        LINK A6,#-572
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -260(A6),A0
        CLR.B (A0)
        LEA -516(A6),A0
        CLR.B (A0)
        MOVEQ #0,D0
        MOVE.L D0,-520(A6)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #58,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_268
        MOVEQ #0,D0
        BRA.W LBL_267
LBL_268:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #16,A7
        LEA -260(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVE.L -4(A6),D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #16,A7
        LEA -516(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_109(PC),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_269
        MOVEQ #0,D0
        MOVE.L D0,-2300(A5)
        BRA.W LBL_270
LBL_269:
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_110(PC),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_271
        MOVEQ #1,D0
        MOVE.L D0,-2300(A5)
        BRA.W LBL_272
LBL_271:
        MOVEQ #0,D0
        BRA.W LBL_267
LBL_272:
LBL_270:
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_12
        ADDQ.L #4,A7
        MOVE.L D0,-520(A6)
        MOVE.L -520(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_13
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_273
        MOVEQ #0,D0
        BRA.W LBL_267
LBL_273:
        MOVE.L -520(A6),D0
        MOVE.L D0,-2304(A5)
        MOVEQ #1,D0
        BRA.W LBL_267
LBL_267:
        UNLK A6
        RTS
        ; func rtConnParseInt  (JT slot 449)
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local v : -8(A6)  size 4
        ;   local c : -10(A6)  size 2
LBL_12:
        LINK A6,#-62
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_275
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_274
LBL_275:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_276:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,D1
        MOVEA.L (A7)+,A0
        CLR.L D0
        MOVE.B (A0),D0
        CMP.L D0,D1
        BCS.W LBL_278
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
LBL_278:
        ADDA.L D1,A0
        MOVE.B 1(A0),D0
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.L D0,D1
        MOVEQ #48,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_279
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.L D0,D1
        MOVEQ #57,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_280
LBL_279:
        MOVEQ #1,D0
LBL_280:
        TST.L D0
        BEQ.W LBL_281
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_274
LBL_281:
        MOVE.L -8(A6),D1
        MOVEQ #10,D0
        BSR.W LBL_140
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.L D0,D1
        MOVEQ #48,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_276
LBL_277:
        MOVE.L -8(A6),D0
        BRA.W LBL_274
LBL_274:
        UNLK A6
        RTS
        ; func rtConnValidBaud  (JT slot 450)
        ;   param b : 8(A6)  size 4
LBL_13:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #300,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_301
        MOVE.L 8(A6),D1
        MOVE.L #600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_302
LBL_301:
        MOVEQ #1,D0
LBL_302:
        TST.L D0
        BNE.W LBL_299
        MOVE.L 8(A6),D1
        MOVE.L #1200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_300
LBL_299:
        MOVEQ #1,D0
LBL_300:
        TST.L D0
        BNE.W LBL_297
        MOVE.L 8(A6),D1
        MOVE.L #1800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_298
LBL_297:
        MOVEQ #1,D0
LBL_298:
        TST.L D0
        BNE.W LBL_295
        MOVE.L 8(A6),D1
        MOVE.L #2400,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_296
LBL_295:
        MOVEQ #1,D0
LBL_296:
        TST.L D0
        BNE.W LBL_293
        MOVE.L 8(A6),D1
        MOVE.L #3600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_294
LBL_293:
        MOVEQ #1,D0
LBL_294:
        TST.L D0
        BNE.W LBL_291
        MOVE.L 8(A6),D1
        MOVE.L #4800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_292
LBL_291:
        MOVEQ #1,D0
LBL_292:
        TST.L D0
        BNE.W LBL_289
        MOVE.L 8(A6),D1
        MOVE.L #7200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_290
LBL_289:
        MOVEQ #1,D0
LBL_290:
        TST.L D0
        BNE.W LBL_287
        MOVE.L 8(A6),D1
        MOVE.L #9600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_288
LBL_287:
        MOVEQ #1,D0
LBL_288:
        TST.L D0
        BNE.W LBL_285
        MOVE.L 8(A6),D1
        MOVE.L #19200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_286
LBL_285:
        MOVEQ #1,D0
LBL_286:
        TST.L D0
        BNE.W LBL_283
        MOVE.L 8(A6),D1
        MOVE.L #57600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_284
LBL_283:
        MOVEQ #1,D0
LBL_284:
        BRA.W LBL_282
LBL_282:
        UNLK A6
        RTS
        ; func rtConnSetFailed  (JT slot 451)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_14:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -216(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2296(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
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
LBL_303:
        UNLK A6
        RTS
        ; func rtConnOpen  (JT slot 452)
        ;   param h : 16(A6)  size 4
        ;   param transport : 12(A6)  size 4
        ;   param spec : 8(A6)  size 4
        ;   local devErr : -4(A6)  size 4
        ;   local slot : -8(A6)  size 4
LBL_15:
        LINK A6,#-60
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
        BEQ.W LBL_305
        LEA LBL_111(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_305:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-8(A6)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_306
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-1,D0
        MOVE.L D0,-(A7)
        LEA LBL_112(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_304
LBL_306:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_307
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_40
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_308
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_304
LBL_308:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_304
LBL_307:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_309
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 4402(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_310
        MOVE.L -4(A6),D1
        MOVEQ #-2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_311
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_312
LBL_311:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
LBL_312:
        BRA.W LBL_304
LBL_310:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_304
LBL_309:
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_11
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_313
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-2,D0
        MOVE.L D0,-(A7)
        LEA LBL_114(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_304
LBL_313:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2300(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -2304(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_22
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_314
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_304
LBL_314:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -216(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_304:
        UNLK A6
        RTS
        ; func rtConnSendText  (JT slot 453)
        ;   param h : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local scratch : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local wErr : -16(A6)  size 4
        ;   local slot : -20(A6)  size 4
LBL_16:
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
        BEQ.W LBL_316
        LEA LBL_111(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_316:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-20(A6)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_317
        LEA LBL_115(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_317:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_318
        BRA.W LBL_315
LBL_318:
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
        BEQ.W LBL_319
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_320
        MOVEQ #108,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2296(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
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
LBL_320:
        BRA.W LBL_315
LBL_319:
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
LBL_321:
        MOVE.L -12(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_322
        MOVE.L -4(A6),D1
        MOVE.L -12(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_321
LBL_322:
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_323
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_45
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_324
LBL_323:
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_325
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4426(A5)
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
        BRA.W LBL_326
LBL_325:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDA.W #12,A7
        MOVE.L D0,-16(A6)
LBL_326:
LBL_324:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_327
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_328
LBL_327:
        MOVEQ #0,D0
LBL_328:
        TST.L D0
        BEQ.W LBL_329
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2296(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
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
LBL_329:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
LBL_315:
        UNLK A6
        RTS
        ; func rtConnClose  (JT slot 454)
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
        BEQ.W LBL_331
        LEA LBL_111(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_331:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_332
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4450(A5)
        ADDQ.L #4,A7
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
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_330
LBL_332:
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_333
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        BRA.W LBL_334
LBL_333:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
LBL_334:
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
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
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_330:
        UNLK A6
        RTS
        ; func rtConnPump  (JT slot 455)
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
LBL_336:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_337
        LEA -216(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_338
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -216(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 5074(A5)
        ADDQ.L #4,A7
        BRA.W LBL_339
LBL_338:
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_340
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2296(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 5098(A5)
        ADDA.W #12,A7
        LEA -2296(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_340:
LBL_339:
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_341
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_342
LBL_341:
        MOVEQ #0,D0
LBL_342:
        TST.L D0
        BEQ.W LBL_343
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_344
        MOVEQ #1,D0
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
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 5074(A5)
        ADDQ.L #4,A7
        BRA.W LBL_345
LBL_344:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
LBL_346:
LBL_345:
LBL_343:
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_347
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4458(A5)
        ADDQ.L #4,A7
        BRA.W LBL_348
LBL_347:
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_349
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_350
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_47
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
        BRA.W LBL_351
LBL_350:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_27
        ADDQ.L #4,A7
        MOVE.B D0,-26(A6)
LBL_351:
        CLR.L D0
        MOVE.B -26(A6),D0
        TST.L D0
        BEQ.W LBL_352
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_354
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        BRA.W LBL_355
LBL_354:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
LBL_355:
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
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 5090(A5)
        ADDQ.L #4,A7
        BRA.W LBL_353
LBL_352:
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_356
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_358
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
        LEA LBL_90(PC),A0
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
        BSR.W LBL_44
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_359
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 5082(A5)
        ADDQ.L #8,A7
LBL_359:
LBL_358:
        BRA.W LBL_357
LBL_356:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
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
        LEA LBL_90(PC),A0
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
        BSR.W LBL_23
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_361:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_362
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_361
LBL_362:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 5082(A5)
        ADDQ.L #8,A7
LBL_360:
LBL_357:
LBL_353:
LBL_349:
LBL_348:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_336
LBL_337:
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_335:
        UNLK A6
        RTS
        ; func rtConnAlive  (JT slot 456)
        ;   local i : -4(A6)  size 4
LBL_19:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_364:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_365
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BNE.W LBL_368
        LEA -216(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_369
LBL_368:
        MOVEQ #1,D0
LBL_369:
        TST.L D0
        BNE.W LBL_366
        LEA -248(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_367
LBL_366:
        MOVEQ #1,D0
LBL_367:
        TST.L D0
        BEQ.W LBL_370
        MOVEQ #1,D0
        BRA.W LBL_363
LBL_370:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_364
LBL_365:
        JSR 4482(A5)
        BRA.W LBL_363
LBL_363:
        UNLK A6
        RTS
        ; func rtConn68kName  (JT slot 457)
        ;   param s : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_20:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_372:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_373
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,D1
        MOVEA.L (A7)+,A0
        CLR.L D0
        MOVE.B (A0),D0
        CMP.L D0,D1
        BCS.W LBL_374
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
LBL_374:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_372
LBL_373:
        MOVE.L -4(A6),D0
        BRA.W LBL_371
LBL_371:
        UNLK A6
        RTS
        ; func rtConn68kBaudWord  (JT slot 458)
        ;   param baud : 8(A6)  size 4
LBL_21:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #300,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        MOVE.L #380,D0
        BRA.W LBL_375
LBL_376:
        MOVE.L 8(A6),D1
        MOVE.L #600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_377
        MOVE.L #189,D0
        BRA.W LBL_375
LBL_377:
        MOVE.L 8(A6),D1
        MOVE.L #1200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_378
        MOVEQ #94,D0
        BRA.W LBL_375
LBL_378:
        MOVE.L 8(A6),D1
        MOVE.L #1800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_379
        MOVEQ #62,D0
        BRA.W LBL_375
LBL_379:
        MOVE.L 8(A6),D1
        MOVE.L #2400,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        MOVEQ #46,D0
        BRA.W LBL_375
LBL_380:
        MOVE.L 8(A6),D1
        MOVE.L #3600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_381
        MOVEQ #30,D0
        BRA.W LBL_375
LBL_381:
        MOVE.L 8(A6),D1
        MOVE.L #4800,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_382
        MOVEQ #22,D0
        BRA.W LBL_375
LBL_382:
        MOVE.L 8(A6),D1
        MOVE.L #7200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_383
        MOVEQ #14,D0
        BRA.W LBL_375
LBL_383:
        MOVE.L 8(A6),D1
        MOVE.L #9600,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_384
        MOVEQ #10,D0
        BRA.W LBL_375
LBL_384:
        MOVE.L 8(A6),D1
        MOVE.L #19200,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_385
        MOVEQ #4,D0
        BRA.W LBL_375
LBL_385:
        MOVEQ #0,D0
        BRA.W LBL_375
LBL_375:
        UNLK A6
        RTS
        ; func rtConnDevOpen  (JT slot 459)
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
LBL_22:
        LINK A6,#-768
        LEA -256(A6),A0
        CLR.B (A0)
        LEA -512(A6),A0
        CLR.B (A0)
        LEA -562(A6),A0
        MOVE.W #11,D0
LBL_387:
        CLR.L (A0)+
        DBRA D0,LBL_387
        CLR.W (A0)+
        LEA -612(A6),A0
        MOVE.W #11,D0
LBL_388:
        CLR.L (A0)+
        DBRA D0,LBL_388
        CLR.W (A0)+
        LEA -662(A6),A0
        MOVE.W #11,D0
LBL_389:
        CLR.L (A0)+
        DBRA D0,LBL_389
        CLR.W (A0)+
        LEA -712(A6),A0
        MOVE.W #11,D0
LBL_390:
        CLR.L (A0)+
        DBRA D0,LBL_390
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-716(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_391
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_117(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_118(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_392
LBL_391:
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_119(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_120(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_392:
        LEA -544(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
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
        BEQ.W LBL_393
        MOVE.L -716(A6),D0
        BRA.W LBL_386
LBL_393:
        LEA -538(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -2336(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BSR.W LBL_20
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
        BEQ.W LBL_394
        MOVE.L -716(A6),D0
        BRA.W LBL_386
LBL_394:
        LEA -588(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -2368(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_395
        MOVEQ #108,D0
        NEG.L D0
        BRA.W LBL_386
LBL_395:
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
        BEQ.W LBL_396
        MOVE.L -716(A6),D0
        BRA.W LBL_386
LBL_396:
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
        BSR.W LBL_21
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
        BRA.W LBL_386
LBL_386:
        UNLK A6
        RTS
        ; func rtConnDevAvail  (JT slot 460)
        ;   param slot : 8(A6)  size 4
        ;   local countPb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_23:
        LINK A6,#-106
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_398:
        CLR.L (A0)+
        DBRA D0,LBL_398
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2368(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_399
        MOVEQ #0,D0
        BRA.W LBL_397
LBL_399:
        LEA -22(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        BRA.W LBL_397
LBL_397:
        UNLK A6
        RTS
        ; func rtConnDevReadByte  (JT slot 461)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
        ;   local err : -54(A6)  size 4
LBL_24:
        LINK A6,#-106
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_401:
        CLR.L (A0)+
        DBRA D0,LBL_401
        CLR.W (A0)+
        MOVEQ #0,D0
        MOVE.L D0,-54(A6)
        MOVE.L -2372(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_402
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; SerNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-2372(A5)
LBL_402:
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2368(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        LEA -18(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -2372(A5),D0
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
        BEQ.W LBL_403
        MOVEQ #0,D0
        BRA.W LBL_400
LBL_403:
        MOVE.L -2372(A5),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        BRA.W LBL_400
LBL_400:
        UNLK A6
        RTS
        ; func rtConnDevWrite  (JT slot 462)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_25:
        LINK A6,#-102
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_405:
        CLR.L (A0)+
        DBRA D0,LBL_405
        CLR.W (A0)+
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2336(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BRA.W LBL_404
LBL_404:
        UNLK A6
        RTS
        ; func rtConnDevClose  (JT slot 463)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
LBL_26:
        LINK A6,#-102
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_407:
        CLR.L (A0)+
        DBRA D0,LBL_407
        CLR.W (A0)+
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -2368(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
LBL_406:
        UNLK A6
        RTS
        ; func rtConnDevGone  (JT slot 464)
        ;   param slot : 8(A6)  size 4
LBL_27:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_408
LBL_408:
        UNLK A6
        RTS
        ; func rtAtEnsureUp  (JT slot 465)
        ;   local e : -4(A6)  size 4
LBL_28:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_62
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_410
        MOVE.L -4(A6),D0
        MOVE.L D0,-6088(A5)
        MOVE.L -4(A6),D0
        BRA.W LBL_409
LBL_410:
        MOVEQ #1,D0
        MOVE.B D0,-2374(A5)
        MOVEQ #0,D0
        BRA.W LBL_409
LBL_409:
        UNLK A6
        RTS
        ; func rtSvcSetFailed  (JT slot 466)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_29:
        LINK A6,#-52
        LEA -3460(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_412
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -3460(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -3972(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
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
LBL_412:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6088(A5)
LBL_411:
        UNLK A6
        RTS
        ; func rtBrsSetFailed  (JT slot 467)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_30:
        LINK A6,#-52
        LEA -2918(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_414
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2918(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -3430(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
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
LBL_414:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6088(A5)
LBL_413:
        UNLK A6
        RTS
        ; func rtAdspFailed  (JT slot 468)
        ;   param slot : 8(A6)  size 4
LBL_31:
        LINK A6,#-52
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_415:
        UNLK A6
        RTS
        ; func rtLsnSetFailed  (JT slot 469)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_32:
        LINK A6,#-52
        LEA -2390(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_417
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -2390(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
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
LBL_417:
        MOVE.L 12(A6),D0
        MOVE.L D0,-6088(A5)
LBL_416:
        UNLK A6
        RTS
        ; func rtAtTextToPtr  (JT slot 470)
        ;   param t : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
LBL_33:
        LINK A6,#-64
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
        BEQ.W LBL_419
        MOVEQ #0,D0
        BRA.W LBL_418
LBL_419:
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
        BEQ.W LBL_420
        MOVEQ #0,D0
        BRA.W LBL_418
LBL_420:
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_421:
        MOVE.L -8(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_422
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
        BRA.W LBL_421
LBL_422:
        MOVE.L -4(A6),D0
        BRA.W LBL_418
LBL_418:
        UNLK A6
        RTS
        ; func rtAtAppendBytes  (JT slot 471)
        ;   param t : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
LBL_34:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
        BRA.W LBL_423
LBL_424:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_425:
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
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
        BRA.W LBL_425
LBL_426:
LBL_423:
        UNLK A6
        RTS
        ; func rtSvcCallAddr  (JT slot 472)
        ;   param h : 24(A6)  size 4
        ;   param addr : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param reply : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local code : -12(A6)  size 4
        ;   local p : -16(A6)  size 4
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
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_428:
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
        BEQ.W LBL_429
        MOVE.L #-3106,D0
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_427
LBL_429:
        BSR.W LBL_28
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_427
LBL_430:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_431
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_432
LBL_431:
        MOVEQ #0,D0
LBL_432:
        TST.L D0
        BEQ.W LBL_433
        MOVEQ #-108,D0
        MOVE.L D0,-(A7)
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_427
LBL_433:
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
        BSR.W LBL_84
        ADDA.W #16,A7
        MOVE.L D0,-8(A6)
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_434
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
LBL_434:
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
        MOVE.L -8(A6),D0
        MOVE.L D0,-6088(A5)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_124(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_427
LBL_435:
        BSR.W LBL_85
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_86
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDA.W #12,A7
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_436
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_125(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_427
LBL_436:
        MOVEQ #1,D0
        BRA.W LBL_427
LBL_427:
        UNLK A6
        RTS
        ; func rtSvcCallName  (JT slot 473)
        ;   param h : 24(A6)  size 4
        ;   param name : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param reply : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local addr : -8(A6)  size 4
        ;   local idx : -12(A6)  size 4
LBL_36:
        LINK A6,#-1088
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
        BEQ.W LBL_438
        LEA LBL_121(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_438:
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
        BEQ.W LBL_439
        MOVE.L #-3106,D0
        MOVE.L D0,-(A7)
        LEA LBL_123(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_437
LBL_439:
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
        BEQ.W LBL_440
        MOVE.L #-1025,D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_437
LBL_440:
        BSR.W LBL_28
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_437
LBL_441:
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
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_67
        ADDA.W #16,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_442
        MOVE.L -4(A6),D0
        MOVE.L D0,-6088(A5)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_437
LBL_442:
LBL_443:
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_444
        JSR 3522(A5)
        BRA.W LBL_443
LBL_444:
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        MOVE.L #-1025,D0
        MOVE.L D0,-(A7)
        LEA LBL_126(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_437
LBL_445:
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
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
        BSR.W LBL_35
        ADDA.W #20,A7
        BRA.W LBL_437
LBL_437:
        UNLK A6
        RTS
        ; func rtBrsFind  (JT slot 474)
        ;   param h : 16(A6)  size 4
        ;   param typ : 12(A6)  size 4
        ;   param zone : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
        ;   local z : -264(A6)  size 256
LBL_37:
        LINK A6,#-316
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
        BEQ.W LBL_447
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_447:
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
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_448
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_448:
        BSR.W LBL_28
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_122(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
        BRA.W LBL_446
LBL_449:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_67
        ADDA.W #16,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_450
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_30
        ADDA.W #12,A7
        BRA.W LBL_446
LBL_450:
        MOVEQ #1,D0
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_446:
        UNLK A6
        RTS
        ; func rtBrsZones  (JT slot 475)
        ;   param h : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_38:
        LINK A6,#-564
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_452
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_452:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 402(A5)
        ADDQ.L #4,A7
        BSR.W LBL_28
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_455
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_73
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_456
LBL_455:
        MOVEQ #1,D0
LBL_456:
        TST.L D0
        BNE.W LBL_453
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 394(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_454
LBL_453:
        MOVEQ #1,D0
LBL_454:
        TST.L D0
        BEQ.W LBL_457
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 402(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        JSR 386(A5)
        ADDQ.L #8,A7
LBL_457:
LBL_451:
        UNLK A6
        RTS
        ; func rtLsnStop  (JT slot 476)
        ;   param h : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
LBL_39:
        LINK A6,#-1080
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_459:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
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
        BSR.W LBL_140
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
        BEQ.W LBL_460
        BRA.W LBL_458
LBL_460:
        LEA -6708(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_461
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4466(A5)
        ADDQ.L #4,A7
        BRA.W LBL_462
LBL_461:
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA -5508(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
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
        LEA -6020(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -1032(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_65
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4370(A5)
        ADDQ.L #4,A7
LBL_462:
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -5508(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -6020(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_458:
        UNLK A6
        RTS
        ; func rtAdspOpenName  (JT slot 477)
        ;   param slot : 12(A6)  size 4
        ;   param spec : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local idx : -8(A6)  size 4
LBL_40:
        LINK A6,#-1084
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
        BEQ.W LBL_464
        MOVE.L #-1025,D0
        BRA.W LBL_463
LBL_464:
        BSR.W LBL_28
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        MOVE.L -4(A6),D0
        BRA.W LBL_463
LBL_465:
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
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_67
        ADDA.W #16,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_466
        MOVE.L -4(A6),D0
        MOVE.L D0,-6088(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_463
LBL_466:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_463
LBL_463:
        UNLK A6
        RTS
        ; func rtAdspOpenAddr  (JT slot 478)
        ;   param slot : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
LBL_41:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_28
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_468
        MOVE.L -4(A6),D0
        BRA.W LBL_467
LBL_468:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4282(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_469
        MOVE.L -4(A6),D0
        MOVE.L D0,-6088(A5)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_467
LBL_469:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_467
LBL_467:
        UNLK A6
        RTS
        ; func rtAdspPoll  (JT slot 479)
        ;   param slot : 8(A6)  size 4
        ;   local e : -4(A6)  size 4
        ;   local addr : -8(A6)  size 4
LBL_42:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_471
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_472
        MOVEQ #0,D0
        BRA.W LBL_470
LBL_472:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_473
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L #-1025,D0
        BRA.W LBL_470
LBL_473:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4282(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_474
        MOVE.L -4(A6),D0
        MOVE.L D0,-6088(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_470
LBL_474:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_470
LBL_471:
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_475
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4290(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_476
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_470
LBL_476:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_477
        MOVE.L -4(A6),D0
        MOVE.L D0,-6088(A5)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
        MOVE.L -4(A6),D0
        BRA.W LBL_470
LBL_477:
        MOVEQ #0,D0
        BRA.W LBL_470
LBL_475:
        MOVEQ #0,D0
        BRA.W LBL_470
LBL_470:
        UNLK A6
        RTS
        ; func rtAdspAvail  (JT slot 480)
        ;   param slot : 8(A6)  size 4
LBL_43:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4298(A5)
        ADDQ.L #4,A7
        BRA.W LBL_478
LBL_478:
        UNLK A6
        RTS
        ; func rtAdspReadInto  (JT slot 481)
        ;   param slot : 12(A6)  size 4
        ;   param t : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local got : -8(A6)  size 4
        ;   local scratch : -12(A6)  size 4
LBL_44:
        LINK A6,#-64
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 4298(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_480
        MOVEQ #0,D0
        BRA.W LBL_479
LBL_480:
        MOVE.L -4(A6),D1
        MOVE.L #1024,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_481
        MOVE.L #1024,D0
        MOVE.L D0,-4(A6)
LBL_481:
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
        BEQ.W LBL_482
        MOVEQ #-108,D0
        MOVE.L D0,-6088(A5)
        MOVEQ #0,D0
        BRA.W LBL_479
LBL_482:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4306(A5)
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_483
        MOVE.L -8(A6),D0
        MOVE.L D0,-6088(A5)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_483:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDA.W #12,A7
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; SerDisposePtr
        MOVE.L -8(A6),D0
        BRA.W LBL_479
LBL_479:
        UNLK A6
        RTS
        ; func rtAdspWrite  (JT slot 482)
        ;   param slot : 16(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_45:
        LINK A6,#-52
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4314(A5)
        ADDA.W #12,A7
        BRA.W LBL_484
LBL_484:
        UNLK A6
        RTS
        ; func rtAdspClose  (JT slot 483)
        ;   param slot : 8(A6)  size 4
LBL_46:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4330(A5)
        ADDQ.L #4,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_31
        ADDQ.L #4,A7
LBL_485:
        UNLK A6
        RTS
        ; func rtAdspGone  (JT slot 484)
        ;   param slot : 8(A6)  size 4
LBL_47:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4322(A5)
        ADDQ.L #4,A7
        BRA.W LBL_486
LBL_486:
        UNLK A6
        RTS
        ; func rtConnOpenAddr  (JT slot 485)
        ;   param h : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
        ;   local slot : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_48:
        LINK A6,#-60
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
        BEQ.W LBL_488
        LEA LBL_111(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_488:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_489
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #-1,D0
        MOVE.L D0,-(A7)
        LEA LBL_112(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
        BRA.W LBL_487
LBL_489:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #8,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_490
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_113(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_14
        ADDA.W #12,A7
LBL_490:
LBL_487:
        UNLK A6
        RTS
        ; func rtAtalkPump  (JT slot 486)
        ;   local i : -4(A6)  size 4
        ;   local code : -8(A6)  size 4
        ;   local pr : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local req : -20(A6)  size 4
        ;   local free : -24(A6)  size 4
        ;   local j : -28(A6)  size 4
        ;   local e : -32(A6)  size 4
        ;   local __store3 : -36(A6)  size 4
LBL_49:
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
        JSR 4474(A5)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_492:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_493
        LEA -2390(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_494
        LEA -2390(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2390(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
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
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 5114(A5)
        ADDA.W #12,A7
        LEA -2902(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_494:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_492
LBL_493:
        CLR.L D0
        MOVE.B -2374(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_495
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_491
LBL_495:
        JSR 3522(A5)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_496:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_497
        LEA -3460(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_498
        LEA -3460(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3460(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -3972(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 5154(A5)
        ADDA.W #12,A7
        LEA -3972(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_498:
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
        BSR.W LBL_140
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
        BEQ.W LBL_499
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_500
LBL_499:
        MOVEQ #0,D0
LBL_500:
        TST.L D0
        BEQ.W LBL_501
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_76
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_502
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3448(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_29
        ADDA.W #12,A7
        BRA.W LBL_503
LBL_502:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_504
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -3448(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_79
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVE.L #578,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_505
        MOVE.L #578,D0
        MOVE.L D0,-16(A6)
LBL_505:
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
        LEA LBL_90(PC),A0
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
        BSR.W LBL_80
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDA.W #12,A7
        MOVEQ #1,D0
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
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_77
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_78
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 5146(A5)
        ADDA.W #16,A7
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
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_506
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
        BSR.W LBL_140
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
        BSR.W LBL_81
        ADDA.W #16,A7
LBL_506:
LBL_504:
LBL_503:
        LEA -3448(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_507
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_82
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_508
LBL_507:
        MOVEQ #0,D0
LBL_508:
        TST.L D0
        BEQ.W LBL_509
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -3446(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_75
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_510
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -3448(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
LBL_510:
LBL_509:
LBL_501:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_496
LBL_497:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_511:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_512
        LEA -2918(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_513
        LEA -2918(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -2918(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA -3430(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        JSR 5138(A5)
        ADDA.W #12,A7
        LEA -3430(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_514
LBL_513:
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
        BSR.W LBL_140
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
        BEQ.W LBL_515
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_68
        ADDQ.L #4,A7
        BRA.W LBL_516
LBL_515:
        MOVEQ #0,D0
LBL_516:
        TST.L D0
        BEQ.W LBL_517
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_518:
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_520
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_521
LBL_520:
        MOVEQ #0,D0
LBL_521:
        TST.L D0
        BEQ.W LBL_519
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        LEA -556(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_72
        ADDA.W #12,A7
        LEA -556(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_71
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        JSR 5122(A5)
        ADDA.W #12,A7
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_518
LBL_519:
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
        BSR.W LBL_140
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
        BEQ.W LBL_522
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 5130(A5)
        ADDQ.L #4,A7
LBL_522:
LBL_517:
LBL_514:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_511
LBL_512:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_523:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_524
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
        BSR.W LBL_140
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
        BEQ.W LBL_525
        LEA -6708(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_526
LBL_525:
        MOVEQ #0,D0
LBL_526:
        TST.L D0
        BEQ.W LBL_527
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4346(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_528
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_32
        ADDA.W #12,A7
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_39
        ADDQ.L #4,A7
        BRA.W LBL_529
LBL_528:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_530
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_531:
        MOVE.L -28(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_532
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_537
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_538
LBL_537:
        MOVEQ #0,D0
LBL_538:
        TST.L D0
        BEQ.W LBL_535
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_536
LBL_535:
        MOVEQ #0,D0
LBL_536:
        TST.L D0
        BEQ.W LBL_533
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_88
        ADDQ.L #4,A7
        BRA.W LBL_534
LBL_533:
        MOVEQ #0,D0
LBL_534:
        TST.L D0
        BEQ.W LBL_539
        MOVE.L -28(A6),D0
        MOVE.L D0,-24(A6)
LBL_539:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_531
LBL_532:
        MOVE.L -24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_540
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4362(A5)
        ADDQ.L #4,A7
        BRA.W LBL_541
LBL_540:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 4354(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_542
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_134(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_32
        ADDA.W #12,A7
        BRA.W LBL_543
LBL_542:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -208(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6084(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        JSR 5106(A5)
        ADDQ.L #8,A7
LBL_543:
LBL_541:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 4338(A5)
        ADDQ.L #4,A7
LBL_530:
LBL_529:
LBL_527:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_523
LBL_524:
        LEA -20(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_491:
        UNLK A6
        RTS
        ; func rtAtalkAlive  (JT slot 487)
        ;   local i : -4(A6)  size 4
LBL_50:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_545:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_546
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
        BSR.W LBL_140
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
        BNE.W LBL_547
        LEA -3460(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_548
LBL_547:
        MOVEQ #1,D0
LBL_548:
        TST.L D0
        BEQ.W LBL_549
        MOVEQ #1,D0
        BRA.W LBL_544
LBL_549:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_545
LBL_546:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_550:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_551
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
        BSR.W LBL_140
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
        BNE.W LBL_552
        LEA -2918(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_553
LBL_552:
        MOVEQ #1,D0
LBL_553:
        TST.L D0
        BEQ.W LBL_554
        MOVEQ #1,D0
        BRA.W LBL_544
LBL_554:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_550
LBL_551:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_555:
        MOVE.L -4(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_556
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_557
        LEA -6052(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_558
LBL_557:
        MOVEQ #0,D0
LBL_558:
        TST.L D0
        BEQ.W LBL_559
        MOVEQ #1,D0
        BRA.W LBL_544
LBL_559:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_555
LBL_556:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_560:
        MOVE.L -4(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_561
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
        BSR.W LBL_140
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
        BNE.W LBL_562
        LEA -2390(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_563
LBL_562:
        MOVEQ #1,D0
LBL_563:
        TST.L D0
        BEQ.W LBL_564
        MOVEQ #1,D0
        BRA.W LBL_544
LBL_564:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_560
LBL_561:
        MOVEQ #0,D0
        BRA.W LBL_544
LBL_544:
        UNLK A6
        RTS
        ; func rtAtalkAddrStr  (JT slot 488)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param addr : 12(A6)  size 4
LBL_51:
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
        LEA LBL_93(PC),A0
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
        LEA LBL_93(PC),A0
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
        BRA.W LBL_565
LBL_565:
        UNLK A6
        RTS
        ; func rtAt68SignW  (JT slot 489)
        ;   param v : 8(A6)  size 4
LBL_52:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_567
        MOVE.L 8(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        BRA.W LBL_566
LBL_567:
        MOVE.L 8(A6),D0
        BRA.W LBL_566
LBL_566:
        UNLK A6
        RTS
        ; func rtAt68Zero  (JT slot 490)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
LBL_53:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_569
        BRA.W LBL_568
LBL_569:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_570:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_571
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
        BRA.W LBL_570
LBL_571:
LBL_572:
        MOVE.L -4(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_573
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
        BRA.W LBL_572
LBL_573:
LBL_568:
        UNLK A6
        RTS
        ; func rtAt68Pending  (JT slot 491)
        ;   param pb : 8(A6)  size 4
LBL_54:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_575
        MOVEQ #0,D0
        BRA.W LBL_574
LBL_575:
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
        BRA.W LBL_574
LBL_574:
        UNLK A6
        RTS
        ; func rtAt68Result  (JT slot 492)
        ;   param pb : 8(A6)  size 4
LBL_55:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_52
        ADDQ.L #4,A7
        BRA.W LBL_576
LBL_576:
        UNLK A6
        RTS
        ; func rtAt68PStr  (JT slot 493)
        ;   param p : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_56:
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
        BEQ.W LBL_578
        MOVEQ #32,D0
        MOVE.L D0,-8(A6)
LBL_578:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_579:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_580
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
        BCS.W LBL_581
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
LBL_581:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_579
LBL_580:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        BRA.W LBL_577
LBL_577:
        UNLK A6
        RTS
        ; func rtAt68GetPStr  (JT slot 494)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param p : 12(A6)  size 4
        ;   local s : -256(A6)  size 256
        ;   local i : -260(A6)  size 4
        ;   local n : -264(A6)  size 4
LBL_57:
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
LBL_583:
        MOVE.L -260(A6),D1
        MOVE.L -264(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_584
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
        BRA.W LBL_583
LBL_584:
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_582
LBL_582:
        UNLK A6
        RTS
        ; func rtAt68SkipPStr  (JT slot 495)
        ;   param p : 8(A6)  size 4
LBL_58:
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
        BRA.W LBL_585
LBL_585:
        UNLK A6
        RTS
        ; func rtAt68PackAddr  (JT slot 496)
        ;   param p : 8(A6)  size 4
LBL_59:
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
        BRA.W LBL_586
LBL_586:
        UNLK A6
        RTS
        ; func rtAt68PokeAddr  (JT slot 497)
        ;   param p : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_60:
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
LBL_587:
        UNLK A6
        RTS
        ; func rtAt68OpenDrv  (JT slot 498)
        ;   param name : 8(A6)  size 4
        ;   local pb : -50(A6)  size 50
        ;   local nm : -54(A6)  size 4
        ;   local e : -58(A6)  size 4
LBL_61:
        LINK A6,#-110
        LEA -50(A6),A0
        MOVE.W #11,D0
LBL_589:
        CLR.L (A0)+
        DBRA D0,LBL_589
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
        BEQ.W LBL_590
        MOVEQ #-108,D0
        MOVE.L D0,-6110(A5)
        MOVEQ #0,D0
        BRA.W LBL_588
LBL_590:
        MOVE.L -54(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
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
        BEQ.W LBL_591
        MOVE.L -58(A6),D0
        MOVE.L D0,-6110(A5)
        MOVEQ #0,D0
        BRA.W LBL_588
LBL_591:
        LEA -26(A6),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        EXT.L D0
        BRA.W LBL_588
LBL_588:
        UNLK A6
        RTS
        ; func rtAtDevUp  (JT slot 499)
LBL_62:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -6106(A5),D0
        TST.L D0
        BEQ.W LBL_593
        MOVEQ #0,D0
        BRA.W LBL_592
LBL_593:
        LEA LBL_135(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVE.L D0,-6092(A5)
        MOVE.L -6092(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_594
        MOVE.L -6110(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_595
        MOVE.L #-1273,D0
        MOVE.L D0,-6110(A5)
LBL_595:
        MOVE.L -6110(A5),D0
        BRA.W LBL_592
LBL_594:
        LEA LBL_136(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVE.L D0,-6096(A5)
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_596
        MOVE.L -6110(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_597
        MOVE.L #-1273,D0
        MOVE.L D0,-6110(A5)
LBL_597:
        MOVE.L -6110(A5),D0
        BRA.W LBL_592
LBL_596:
        LEA LBL_137(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVE.L D0,-6100(A5)
        LEA LBL_138(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_61
        ADDQ.L #4,A7
        MOVE.L D0,-6104(A5)
        MOVEQ #0,D0
        MOVE.L D0,-6110(A5)
        MOVEQ #1,D0
        MOVE.B D0,-6106(A5)
        MOVEQ #0,D0
        BRA.W LBL_592
LBL_592:
        UNLK A6
        RTS
        ; func rtAt68PStrEq  (JT slot 500)
        ;   param p : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_63:
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
        BEQ.W LBL_599
        MOVEQ #32,D0
        MOVE.L D0,-8(A6)
LBL_599:
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
        BEQ.W LBL_600
        MOVEQ #0,D0
        BRA.W LBL_598
LBL_600:
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_601:
        MOVE.L -4(A6),D1
        MOVE.L -8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_602
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
        BCS.W LBL_603
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
LBL_603:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_604
        MOVEQ #0,D0
        BRA.W LBL_598
LBL_604:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_601
LBL_602:
        MOVEQ #1,D0
        BRA.W LBL_598
LBL_598:
        UNLK A6
        RTS
        ; func rtAt68NteFind  (JT slot 501)
        ;   param obj : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local ent : -8(A6)  size 4
LBL_64:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
LBL_606:
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_607
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        TST.L D0
        BEQ.W LBL_608
        LEA -6258(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_609
LBL_608:
        MOVEQ #0,D0
LBL_609:
        TST.L D0
        BEQ.W LBL_610
        LEA -6258(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BSR.W LBL_63
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_611
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_63
        ADDQ.L #8,A7
        BRA.W LBL_612
LBL_611:
        MOVEQ #0,D0
LBL_612:
        TST.L D0
        BEQ.W LBL_613
        MOVE.L -4(A6),D0
        BRA.W LBL_605
LBL_613:
LBL_610:
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_606
LBL_607:
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_605
LBL_605:
        UNLK A6
        RTS
        ; func rtAtDevRemove  (JT slot 502)
        ;   param obj : 12(A6)  size 4
        ;   param typ : 8(A6)  size 4
        ;   local pb : -52(A6)  size 52
        ;   local k : -56(A6)  size 4
        ;   local e : -60(A6)  size 4
LBL_65:
        LINK A6,#-112
        LEA -52(A6),A0
        MOVE.W #12,D0
LBL_615:
        CLR.L (A0)+
        DBRA D0,LBL_615
        MOVEQ #0,D0
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
        MOVE.L -6092(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_616
        MOVE.L #-1273,D0
        BRA.W LBL_614
LBL_616:
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_64
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_617
        MOVE.L #-1028,D0
        BRA.W LBL_614
LBL_617:
        LEA -28(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6092(A5),D0
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
        LEA -6258(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        LEA -6262(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
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
        BEQ.W LBL_618
        MOVE.L -60(A6),D0
        MOVE.L D0,-6110(A5)
LBL_618:
        MOVE.L -60(A6),D0
        BRA.W LBL_614
LBL_614:
        UNLK A6
        RTS
        ; func rtAt68LkEnsure  (JT slot 503)
        ;   param lk : 8(A6)  size 4
LBL_66:
        LINK A6,#-52
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_620
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_620:
        LEA -6198(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_621
        MOVEQ #104,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6198(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_621:
        LEA -6242(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        MOVE.L #4096,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6242(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_622:
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_625
        LEA -6198(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_626
LBL_625:
        MOVEQ #0,D0
LBL_626:
        TST.L D0
        BEQ.W LBL_623
        LEA -6242(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_624
LBL_623:
        MOVEQ #0,D0
LBL_624:
        BRA.W LBL_619
LBL_619:
        UNLK A6
        RTS
        ; func rtAtDevLookupStart  (JT slot 504)
        ;   param lk : 20(A6)  size 4
        ;   param obj : 16(A6)  size 4
        ;   param typ : 12(A6)  size 4
        ;   param zone : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local ent : -8(A6)  size 4
        ;   local end : -12(A6)  size 4
        ;   local z : -268(A6)  size 256
        ;   local e : -272(A6)  size 4
LBL_67:
        LINK A6,#-324
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
        MOVE.L -6092(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_628
        MOVE.L #-1273,D0
        BRA.W LBL_627
LBL_628:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_66
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_629
        MOVEQ #-108,D0
        BRA.W LBL_627
LBL_629:
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        LEA -6198(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
LBL_630:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_631
        BRA.W LBL_630
LBL_631:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #104,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
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
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_632
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
LBL_632:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 16(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_56
        ADDQ.L #8,A7
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6092(A5),D0
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
        LEA -6242(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_633
        MOVE.L -272(A6),D0
        MOVE.L D0,-6110(A5)
        MOVE.L -272(A6),D0
        BRA.W LBL_627
LBL_633:
        MOVEQ #0,D0
        BRA.W LBL_627
LBL_627:
        UNLK A6
        RTS
        ; func rtAtDevLookupDone  (JT slot 505)
        ;   param lk : 8(A6)  size 4
LBL_68:
        LINK A6,#-52
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_635
        MOVEQ #1,D0
        BRA.W LBL_634
LBL_635:
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        EORI.L #1,D0
        BRA.W LBL_634
LBL_634:
        UNLK A6
        RTS
        ; func rtAtDevLookupCount  (JT slot 506)
        ;   param lk : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
LBL_69:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_637
        MOVEQ #0,D0
        BRA.W LBL_636
LBL_637:
        LEA -6154(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_638
        MOVEQ #0,D0
        BRA.W LBL_636
LBL_638:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_639
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-6110(A5)
        MOVEQ #0,D0
        BRA.W LBL_636
LBL_639:
        MOVE.L -4(A6),D1
        MOVEQ #42,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_636
LBL_636:
        UNLK A6
        RTS
        ; func rtAt68LkTuple  (JT slot 507)
        ;   param lk : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
        ;   local j : -8(A6)  size 4
LBL_70:
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
        BNE.W LBL_641
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_69
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_642
LBL_641:
        MOVEQ #1,D0
LBL_642:
        TST.L D0
        BEQ.W LBL_643
        MOVEQ #0,D0
        BRA.W LBL_640
LBL_643:
        LEA -6242(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #11,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_644:
        MOVE.L -8(A6),D1
        MOVE.L 8(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_645
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_644
LBL_645:
        MOVE.L -4(A6),D0
        BRA.W LBL_640
LBL_640:
        UNLK A6
        RTS
        ; func rtAtDevLookupAddr  (JT slot 508)
        ;   param lk : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local t : -4(A6)  size 4
LBL_71:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_647
        MOVEQ #0,D0
        BRA.W LBL_646
LBL_647:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #4,A7
        BRA.W LBL_646
LBL_646:
        UNLK A6
        RTS
        ; func rtAtDevLookupName  (JT slot 509)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param lk : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   local t : -4(A6)  size 4
        ;   local obj : -260(A6)  size 256
        ;   local typ : -516(A6)  size 256
LBL_72:
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
        BSR.W LBL_70
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_649
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        BRA.W LBL_648
LBL_649:
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_57
        ADDQ.L #8,A7
        MOVE.L -4(A6),D1
        MOVEQ #5,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -516(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_57
        ADDQ.L #8,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_108(PC),A0
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
        BRA.W LBL_648
LBL_648:
        UNLK A6
        RTS
        ; func rtAtDevZones  (JT slot 510)
        ;   param out : 8(A6)  size 4
        ;   local pb : -112(A6)  size 112
        ;   local buf : -116(A6)  size 4
        ;   local e : -120(A6)  size 4
        ;   local n : -124(A6)  size 4
        ;   local i : -128(A6)  size 4
        ;   local p : -132(A6)  size 4
        ;   local last : -136(A6)  size 4
        ;   local guard : -140(A6)  size 4
LBL_73:
        LINK A6,#-704
        LEA -112(A6),A0
        MOVE.W #27,D0
LBL_651:
        CLR.L (A0)+
        DBRA D0,LBL_651
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
        MOVE.L -6100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_652
        MOVEQ #-93,D0
        BRA.W LBL_650
LBL_652:
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
        BEQ.W LBL_653
        MOVEQ #-108,D0
        BRA.W LBL_650
LBL_653:
        MOVEQ #0,D0
        MOVE.L D0,-136(A6)
        MOVEQ #0,D0
        MOVE.L D0,-140(A6)
        MOVEQ #0,D0
        MOVE.L D0,-120(A6)
LBL_654:
        MOVE.L -136(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_656
        MOVE.L -140(A6),D1
        MOVEQ #64,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_657
LBL_656:
        MOVEQ #0,D0
LBL_657:
        TST.L D0
        BEQ.W LBL_655
        LEA -88(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6100(A5),D0
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
        BEQ.W LBL_658
        MOVE.L -120(A6),D0
        MOVE.L D0,-6110(A5)
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVE.L -120(A6),D0
        BRA.W LBL_650
LBL_658:
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
LBL_659:
        MOVE.L -128(A6),D1
        MOVE.L -124(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_660
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -132(A6),D0
        MOVE.L D0,-(A7)
        LEA -656(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_57
        ADDQ.L #8,A7
        LEA -656(A6),A0
        MOVE.L A0,-(A7)
        JSR 386(A5)
        ADDQ.L #8,A7
        MOVE.L -132(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_58
        ADDQ.L #4,A7
        MOVE.L D0,-132(A6)
        MOVE.L -128(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-128(A6)
        BRA.W LBL_659
LBL_660:
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
        BRA.W LBL_654
LBL_655:
        MOVE.L -116(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; DisposePtr
        MOVEQ #0,D0
        BRA.W LBL_650
LBL_650:
        UNLK A6
        RTS
        ; func rtAt68SvcEnsure  (JT slot 511)
        ;   param slot : 8(A6)  size 4
LBL_74:
        LINK A6,#-52
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
        BSR.W LBL_140
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
        BEQ.W LBL_662
        MOVEQ #56,D0
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_662:
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
        BSR.W LBL_140
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
        BEQ.W LBL_663
        MOVE.L #600,D0
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_663:
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
        BSR.W LBL_140
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
        BEQ.W LBL_664
        MOVEQ #56,D0
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_664:
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
        BSR.W LBL_140
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
        BEQ.W LBL_665
        MOVE.L #4624,D0
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_665:
        LEA -6302(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_666
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        LEA -6302(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_666:
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
        BSR.W LBL_140
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
        BEQ.W LBL_673
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_674
LBL_673:
        MOVEQ #0,D0
LBL_674:
        TST.L D0
        BEQ.W LBL_671
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_672
LBL_671:
        MOVEQ #0,D0
LBL_672:
        TST.L D0
        BEQ.W LBL_669
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_670
LBL_669:
        MOVEQ #0,D0
LBL_670:
        TST.L D0
        BEQ.W LBL_667
        LEA -6302(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_668
LBL_667:
        MOVEQ #0,D0
LBL_668:
        BRA.W LBL_661
LBL_661:
        UNLK A6
        RTS
        ; func rtAtDevAtpArm  (JT slot 512)
        ;   param slot : 12(A6)  size 4
        ;   param sock : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local e : -8(A6)  size 4
LBL_75:
        LINK A6,#-60
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
        BEQ.W LBL_676
        MOVE.L #-1273,D0
        BRA.W LBL_675
LBL_676:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_677
        MOVEQ #-108,D0
        BRA.W LBL_675
LBL_677:
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_678
        MOVE.L #-1273,D0
        BRA.W LBL_675
LBL_678:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        LEA -6310(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
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
        LEA -6278(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        BEQ.W LBL_679
        MOVE.L -8(A6),D0
        MOVE.L D0,-6110(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_675
LBL_679:
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA -6312(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVEQ #0,D0
        BRA.W LBL_675
LBL_675:
        UNLK A6
        RTS
        ; func rtAtDevAtpPoll  (JT slot 513)
        ;   param slot : 8(A6)  size 4
        ;   local pb : -4(A6)  size 4
        ;   local res : -8(A6)  size 4
LBL_76:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        LEA -6312(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        CLR.L D0
        MOVE.B (A0),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_681
        MOVEQ #0,D0
        BRA.W LBL_680
LBL_681:
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_682
        MOVEQ #0,D0
        BRA.W LBL_680
LBL_682:
        MOVEQ #0,D0
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
        MOVEQ #1,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_55
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_683
        MOVE.L -8(A6),D0
        MOVE.L D0,-6110(A5)
        MOVE.L -8(A6),D0
        BRA.W LBL_680
LBL_683:
        MOVE.L -4(A6),D1
        MOVEQ #18,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #30,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_59
        ADDQ.L #4,A7
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
        BSR.W LBL_140
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
        BSR.W LBL_140
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
        BSR.W LBL_140
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
        LEA -6352(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #1,D0
        BRA.W LBL_680
LBL_680:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqOp  (JT slot 514)
        ;   param slot : 8(A6)  size 4
LBL_77:
        LINK A6,#-52
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_684
LBL_684:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqFrom  (JT slot 515)
        ;   param slot : 8(A6)  size 4
LBL_78:
        LINK A6,#-52
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_685
LBL_685:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqLen  (JT slot 516)
        ;   param slot : 8(A6)  size 4
LBL_79:
        LINK A6,#-52
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_686
LBL_686:
        UNLK A6
        RTS
        ; func rtAtDevAtpReqPtr  (JT slot 517)
        ;   param slot : 8(A6)  size 4
LBL_80:
        LINK A6,#-52
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        BRA.W LBL_687
LBL_687:
        UNLK A6
        RTS
        ; func rtAtDevAtpRespond  (JT slot 518)
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
LBL_81:
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
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_689
        MOVE.L #-1273,D0
        BRA.W LBL_688
LBL_689:
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_74
        ADDQ.L #4,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_690
        MOVEQ #-108,D0
        BRA.W LBL_688
LBL_690:
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        TST.L D0
        BEQ.W LBL_691
        MOVE.L #-1273,D0
        BRA.W LBL_688
LBL_691:
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
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
        BSR.W LBL_140
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
        BEQ.W LBL_692
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_692:
        MOVE.L -32(A6),D1
        MOVE.L #4624,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_693
        MOVE.L #4624,D0
        MOVE.L D0,-32(A6)
LBL_693:
        MOVE.L -32(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_694
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_695
LBL_694:
        MOVEQ #0,D0
LBL_695:
        TST.L D0
        BEQ.W LBL_696
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
LBL_696:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #56,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
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
        BSR.W LBL_141
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_697
        MOVEQ #1,D0
        MOVE.L D0,-16(A6)
LBL_697:
        MOVE.L -16(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_698
        MOVEQ #8,D0
        MOVE.L D0,-16(A6)
LBL_698:
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
LBL_699:
        MOVE.L -20(A6),D1
        MOVE.L -16(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_700
        MOVE.L -20(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_140
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
        BEQ.W LBL_701
        MOVE.L #578,D0
        MOVE.L D0,-28(A6)
LBL_701:
        MOVE.L -28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_702
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_702:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_140
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
        BSR.W LBL_140
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
        BSR.W LBL_140
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
        BEQ.W LBL_703
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_703:
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_699
LBL_700:
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
        MOVEQ #28,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -6310(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        LEA -6352(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
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
        LEA -6328(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_60
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
        BSR.W LBL_140
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
        BEQ.W LBL_704
        MOVE.L -36(A6),D0
        MOVE.L D0,-6110(A5)
        MOVE.L -36(A6),D0
        BRA.W LBL_688
LBL_704:
        MOVEQ #0,D0
        BRA.W LBL_688
LBL_688:
        UNLK A6
        RTS
        ; func rtAtDevAtpRespBusy  (JT slot 519)
        ;   param slot : 8(A6)  size 4
LBL_82:
        LINK A6,#-52
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
        BSR.W LBL_140
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
        BEQ.W LBL_706
        MOVEQ #0,D0
        BRA.W LBL_705
LBL_706:
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
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_54
        ADDQ.L #4,A7
        BRA.W LBL_705
LBL_705:
        UNLK A6
        RTS
        ; func rtAt68CallEnsure  (JT slot 520)
LBL_83:
        LINK A6,#-52
        MOVE.L -6356(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_708
        MOVE.L #4624,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-6356(A5)
LBL_708:
        MOVE.L -6360(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_709
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-6360(A5)
LBL_709:
        MOVE.L -6356(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_710
        MOVE.L -6360(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_711
LBL_710:
        MOVEQ #0,D0
LBL_711:
        BRA.W LBL_707
LBL_707:
        UNLK A6
        RTS
        ; func rtAtDevAtpCall  (JT slot 521)
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
LBL_84:
        LINK A6,#-128
        LEA -56(A6),A0
        MOVE.W #13,D0
LBL_713:
        CLR.L (A0)+
        DBRA D0,LBL_713
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
        MOVE.L -6096(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_714
        MOVE.L #-1273,D0
        BRA.W LBL_712
LBL_714:
        BSR.W LBL_83
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_715
        MOVEQ #-108,D0
        BRA.W LBL_712
LBL_715:
        MOVE.L -6360(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #96,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
LBL_716:
        MOVE.L -60(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_717
        MOVE.L -6360(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L #578,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        MOVE.L -6360(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #2,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6356(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -60(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_716
LBL_717:
        MOVEQ #0,D0
        MOVE.L D0,-6364(A5)
        LEA -32(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        MOVE.L -6096(A5),D0
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
        MOVE.L -6360(A5),D0
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
        BEQ.W LBL_718
        MOVE.L -76(A6),D0
        MOVE.L D0,-6110(A5)
        MOVE.L -76(A6),D0
        BRA.W LBL_712
LBL_718:
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
        BEQ.W LBL_719
        MOVEQ #8,D0
        MOVE.L D0,-64(A6)
LBL_719:
        MOVEQ #0,D0
        MOVE.L D0,-68(A6)
        MOVEQ #0,D0
        MOVE.L D0,-60(A6)
LBL_720:
        MOVE.L -60(A6),D1
        MOVE.L -64(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_721
        MOVE.L -6360(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVEQ #12,D0
        BSR.W LBL_140
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
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_722
        MOVE.L -72(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_723
LBL_722:
        MOVEQ #0,D0
LBL_723:
        TST.L D0
        BEQ.W LBL_724
        MOVE.L -6356(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -60(A6),D1
        MOVE.L #578,D0
        BSR.W LBL_140
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6356(A5),D1
        MOVE.L -68(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -72(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; BlockMoveData
LBL_724:
        MOVE.L -68(A6),D1
        MOVE.L -72(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-68(A6)
        MOVE.L -60(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-60(A6)
        BRA.W LBL_720
LBL_721:
        MOVE.L -6360(A5),D1
        MOVEQ #8,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-6364(A5)
        MOVE.L -68(A6),D0
        BRA.W LBL_712
LBL_712:
        UNLK A6
        RTS
        ; func rtAtDevAtpCallCode  (JT slot 522)
LBL_85:
        LINK A6,#-52
        MOVE.L -6364(A5),D0
        BRA.W LBL_725
LBL_725:
        UNLK A6
        RTS
        ; func rtAtDevAtpCallPtr  (JT slot 523)
LBL_86:
        LINK A6,#-52
        MOVE.L -6356(A5),D0
        BRA.W LBL_726
LBL_726:
        UNLK A6
        RTS
        ; func rtAt68DspAuxPb  (JT slot 524)
LBL_87:
        LINK A6,#-52
        MOVE.L -6594(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_728
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NewPtrClear
        MOVE.L A0,D0
        MOVE.L D0,-6594(A5)
LBL_728:
        MOVE.L -6594(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_729
        MOVE.L -6594(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #68,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_53
        ADDQ.L #8,A7
LBL_729:
        MOVE.L -6594(A5),D0
        BRA.W LBL_727
LBL_727:
        UNLK A6
        RTS
        ; func rtTcpFree  (JT slot 525)
        ;   param slot : 8(A6)  size 4
LBL_88:
        LINK A6,#-52
        LEA -6626(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_140
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_730
LBL_730:
        UNLK A6
        RTS
        ; func rtTcpDevLsnDeny  (JT slot 526)
        ;   param lsn : 8(A6)  size 4
LBL_89:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 4634(A5)
        ADDQ.L #4,A7
LBL_731:
        UNLK A6
        RTS
LBL_140:
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
LBL_141:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_732
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_732:
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
        BPL.W LBL_733
        NEG.L D2
        MOVE.L #1,D4
LBL_733:
        CLR.L D5
        TST.L D3
        BPL.W LBL_734
        NEG.L D3
        MOVE.L #1,D5
LBL_734:
        CLR.L D6
        MOVE.W #31,D7
LBL_735:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_736
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_736:
        DBRA D7,LBL_735
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_737
        NEG.L D2
LBL_737:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_142:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_738
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_139(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_738:
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
        BPL.W LBL_739
        NEG.L D2
        MOVE.L #1,D4
LBL_739:
        CLR.L D5
        TST.L D3
        BPL.W LBL_740
        NEG.L D3
        MOVE.L #1,D5
LBL_740:
        CLR.L D6
        MOVE.W #31,D7
LBL_741:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_742
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_742:
        DBRA D7,LBL_741
        TST.L D4
        BEQ.W LBL_743
        NEG.L D6
LBL_743:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_143:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_744(PC),A0
        MOVE.L A0,-4(A6)
LBL_745:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_746
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_747
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_745
LBL_747:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_748:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_745
LBL_746:
        UNLK A6
        RTS
LBL_744:
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
        DC.W $E2EA
        DC.W $0001
        DC.W $E2E6
        DC.W $0000
        DC.W $E2E2
        DC.W $0000
        DC.W $0000
        DC.W $0000
        ; constant pool: string literals
LBL_139:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_97:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_98:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_99:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_100:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_101:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_102:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_103:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_104:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_105:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_106:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_107:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_94:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_95:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_96:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_91:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_92:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_109:
        DC.B $05
        DC.B $6D,$6F,$64,$65,$6D
LBL_110:
        DC.B $07
        DC.B $70,$72,$69,$6E,$74,$65,$72
LBL_111:
        DC.B $15
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_112:
        DC.B $17
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_113:
        DC.B $19
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_114:
        DC.B $17
        DC.B $69,$6E,$76,$61,$6C,$69,$64,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$73,$70,$65,$63
LBL_115:
        DC.B $13
        DC.B $63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E
LBL_116:
        DC.B $0C
        DC.B $77,$72,$69,$74,$65,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_90:
        DC.B $00
        DC.B $00
LBL_117:
        DC.B $05
        DC.B $2E,$41,$4F,$75,$74
LBL_118:
        DC.B $04
        DC.B $2E,$41,$49,$6E
        DC.B $00
LBL_119:
        DC.B $05
        DC.B $2E,$42,$4F,$75,$74
LBL_120:
        DC.B $04
        DC.B $2E,$42,$49,$6E
        DC.B $00
LBL_121:
        DC.B $12
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$73,$65,$72,$76,$69,$63,$65
        DC.B $00
LBL_123:
        DC.B $10
        DC.B $72,$65,$71,$75,$65,$73,$74,$20,$74,$6F,$6F,$20,$6C,$6F,$6E,$67
        DC.B $00
LBL_122:
        DC.B $15
        DC.B $41,$70,$70,$6C,$65,$54,$61,$6C,$6B,$20,$75,$6E,$61,$76,$61,$69,$6C,$61,$62,$6C,$65
LBL_124:
        DC.B $0B
        DC.B $6E,$6F,$20,$72,$65,$73,$70,$6F,$6E,$73,$65
LBL_125:
        DC.B $07
        DC.B $73,$65,$72,$76,$69,$63,$65
LBL_126:
        DC.B $0E
        DC.B $6E,$61,$6D,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_127:
        DC.B $01
        DC.B $2A
LBL_128:
        DC.B $19
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$73,$65,$72,$76,$69,$63,$65,$42,$72,$6F,$77,$73,$65,$72
LBL_129:
        DC.B $01
        DC.B $3D
LBL_130:
        DC.B $0D
        DC.B $6C,$6F,$6F,$6B,$75,$70,$20,$66,$61,$69,$6C,$65,$64
LBL_131:
        DC.B $13
        DC.B $75,$73,$65,$20,$6F,$66,$20,$6E,$69,$6C,$20,$6C,$69,$73,$74,$65,$6E,$65,$72
LBL_132:
        DC.B $0E
        DC.B $72,$65,$71,$75,$65,$73,$74,$20,$66,$61,$69,$6C,$65,$64
        DC.B $00
LBL_133:
        DC.B $0F
        DC.B $6C,$69,$73,$74,$65,$6E,$65,$72,$20,$66,$61,$69,$6C,$65,$64
LBL_134:
        DC.B $1B
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$61,$63,$63,$65,$70,$74,$20,$63,$6F,$6E,$6E,$65,$63,$74,$69,$6F,$6E
LBL_93:
        DC.B $01
        DC.B $2E
LBL_135:
        DC.B $04
        DC.B $2E,$4D,$50,$50
        DC.B $00
LBL_136:
        DC.B $04
        DC.B $2E,$41,$54,$50
        DC.B $00
LBL_137:
        DC.B $04
        DC.B $2E,$58,$50,$50
        DC.B $00
LBL_138:
        DC.B $04
        DC.B $2E,$44,$53,$50
        DC.B $00
LBL_108:
        DC.B $01
        DC.B $3A
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
