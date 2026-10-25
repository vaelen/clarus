        ; func rtUiFormFill  (JT slot 429)
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
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1202(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        JSR 2098(A5)
        MOVE.L D0,-68(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-64(A6)
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
LBL_115:
        MOVE.L -28(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1218(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-32(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        JSR 1226(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1354(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
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
        JSR 810(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-52(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 2034(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-56(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1986(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-60(A6)
        MOVE.L -52(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_117
        MOVE.L -56(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_118
LBL_117:
        MOVEQ #0,D0
LBL_118:
        TST.L D0
        BEQ.W LBL_119
        MOVE.L -40(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1370(A5)
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
        BEQ.W LBL_123
        MOVE.L -76(A6),D0
        MOVE.L D0,-80(A6)
LBL_123:
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
        BRA.W LBL_122
LBL_121:
        MOVE.L -40(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_124
        MOVE.L -40(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_125
LBL_124:
        MOVEQ #1,D0
LBL_125:
        TST.L D0
        BEQ.W LBL_126
        MOVE.L -48(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 2626(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 2554(A5)
        ADDQ.L #8,A7
        BRA.W LBL_127
LBL_126:
        MOVE.L -40(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_128
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        JSR 2618(A5)
        ADDQ.L #8,A7
        BRA.W LBL_129
LBL_128:
        MOVE.L -40(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_130
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
        BEQ.W LBL_132
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
        BRA.W LBL_133
LBL_132:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_133:
        BRA.W LBL_131
LBL_130:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_131:
LBL_129:
LBL_127:
LBL_122:
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
        BRA.W LBL_120
LBL_119:
        MOVE.L -52(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_134
        MOVE.L -60(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_135
LBL_134:
        MOVEQ #0,D0
LBL_135:
        TST.L D0
        BEQ.W LBL_136
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
        BEQ.W LBL_138
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
        BRA.W LBL_139
LBL_138:
        MOVE.L -60(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.W D0,-(A7)
        DC.W $A963  ; UiSetControlValue
LBL_139:
        BRA.W LBL_137
LBL_136:
        MOVE.L -52(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_140
        MOVE.L -48(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-72(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-84(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-92(A6)
        MOVEQ #0,D0
        MOVE.L D0,-96(A6)
LBL_141:
        MOVE.L -96(A6),D1
        MOVE.L -84(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_142
        MOVE.L -88(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -96(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVE.L -72(A6),D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_143
        MOVE.L -96(A6),D0
        MOVE.L D0,-92(A6)
        MOVE.L -84(A6),D0
        MOVE.L D0,-96(A6)
        BRA.W LBL_144
LBL_143:
        MOVE.L -96(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-96(A6)
LBL_144:
        BRA.W LBL_141
LBL_142:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -92(A6),D0
        MOVE.L D0,-(A7)
        JSR 2594(A5)
        ADDA.W #12,A7
LBL_140:
LBL_137:
LBL_120:
        MOVE.L -28(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-28(A6)
        BRA.W LBL_115
LBL_116:
        MOVE.L -64(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        MOVE.L -68(A6),D0
        MOVE.L D0,-(A7)
        DC.W $A873  ; UiSetPort
LBL_114:
        UNLK A6
        RTS
        ; func rtUiFormAccept  (JT slot 430)
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
        JSR 786(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-16(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1202(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-20(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 1194(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 1338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-28(A6)
        MOVE.L #256,D0
        MOVE.L D0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-56(A6)
        MOVEQ #0,D0
        MOVE.L D0,-32(A6)
LBL_146:
        MOVE.L -32(A6),D1
        MOVE.L -24(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_147
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1218(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-36(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -32(A6),D0
        MOVE.L D0,-(A7)
        JSR 1226(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-40(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1354(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-44(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
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
        BEQ.W LBL_148
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2170(A5)
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
        JSR 3362(A5)
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_150
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3386(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_145
LBL_150:
        BRA.W LBL_149
LBL_148:
        MOVE.L -44(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_151
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2170(A5)
        ADDA.W #16,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -44(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        JSR 3370(A5)
        ADDA.W #12,A7
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_153
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3386(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_145
LBL_153:
        BRA.W LBL_152
LBL_151:
        MOVE.L -44(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2170(A5)
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
        JSR 3378(A5)
        ADDA.W #12,A7
        MOVE.B D0,-58(A6)
        CLR.L D0
        MOVE.B -58(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_156
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 3386(A5)
        ADDQ.L #8,A7
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; UiDisposePtr
        BRA.W LBL_145
LBL_156:
        BRA.W LBL_155
LBL_154:
        MOVE.L -44(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_157
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2170(A5)
        ADDA.W #16,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1370(A5)
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
        BEQ.W LBL_159
        MOVE.L -62(A6),D0
        MOVE.L D0,-66(A6)
LBL_159:
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
LBL_160:
        MOVE.L -70(A6),D1
        MOVE.L -62(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
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
        BRA.W LBL_160
LBL_161:
        BRA.W LBL_158
LBL_157:
        MOVE.L -44(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_162
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 1986(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-74(A6)
        MOVE.L -74(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_164
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
        BRA.W LBL_165
LBL_164:
        MOVEQ #0,D0
LBL_165:
        TST.L D0
        BEQ.W LBL_166
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        BRA.W LBL_167
LBL_166:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_167:
        BRA.W LBL_163
LBL_162:
        MOVE.L -44(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_168
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -56(A6),D0
        MOVE.L D0,-(A7)
        JSR 2170(A5)
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
        BEQ.W LBL_170
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
        BRA.W LBL_171
LBL_170:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
LBL_171:
        BRA.W LBL_169
LBL_168:
        MOVE.L -44(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_172
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -36(A6),D0
        MOVE.L D0,-(A7)
        JSR 2586(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-78(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-82(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -40(A6),D0
        MOVE.L D0,-(A7)
        JSR 1394(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-86(A6)
        MOVE.L -82(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_175
        MOVE.L -78(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_176
LBL_175:
        MOVEQ #0,D0
LBL_176:
        TST.L D0
        BEQ.W LBL_173
        MOVE.L -78(A6),D1
        MOVE.L -82(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_174
LBL_173:
        MOVEQ #0,D0
LBL_174:
        TST.L D0
        BEQ.W LBL_177
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -86(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
        BRA.W LBL_178
LBL_177:
        MOVE.L -52(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVEA.L (A7)+,A0
        MOVE.W D0,(A0)
LBL_178:
LBL_172:
LBL_169:
LBL_163:
LBL_158:
LBL_155:
LBL_152:
LBL_149:
        MOVE.L -32(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-32(A6)
        BRA.W LBL_146
LBL_147:
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
        BEQ.W LBL_179
        MOVE.L -158(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
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
LBL_181:
        BRA.W LBL_180
LBL_179:
        MOVE.L -154(A5),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_182
        MOVE.L -162(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_186
        MOVE.L -166(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_187
LBL_186:
        MOVEQ #0,D0
LBL_187:
        TST.L D0
        BEQ.W LBL_184
        MOVE.L -166(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -162(A5),D0
        MOVE.L D0,-(A7)
        JSR 314(A5)
        ADDQ.L #4,A7
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_185
LBL_184:
        MOVEQ #0,D0
LBL_185:
        TST.L D0
        BEQ.W LBL_188
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -162(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -166(A5),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
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
        JSR 298(A5)
        ADDQ.L #4,A7
LBL_188:
        BRA.W LBL_183
LBL_182:
        MOVE.L -154(A5),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
        MOVE.L -170(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_190
        MOVE.L -170(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -174(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -148(A5),D0
        MOVE.L D0,-(A7)
        JSR 522(A5)
        ADDA.W #12,A7
LBL_190:
LBL_189:
LBL_183:
LBL_180:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 698(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA LBL_87(PC),A0
        MOVE.L A0,-(A7)
        JSR 2994(A5)
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
        BSR.W LBL_62
        ADDA.W #20,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3402(A5)
        ADDQ.L #4,A7
LBL_145:
        UNLK A6
        RTS
        ; func rtUiAskSave  (JT slot 431)
        ;   param path255 : 12(A6)  size 4
        ;   param suggested : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
LBL_2:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -60(A5),D0
        TST.L D0
        BEQ.W LBL_192
        JSR 2914(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_110
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
        BEQ.W LBL_193
        LEA LBL_88(PC),A0
        MOVE.L A0,-(A7)
        JSR 3322(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        JSR 2954(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_191
LBL_193:
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_194
        LEA LBL_89(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_191
LBL_194:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -78(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_110
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 2138(A5)
        ADDQ.L #8,A7
        LEA LBL_90(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3106(A5)
        ADDQ.L #8,A7
        MOVEQ #1,D0
        BRA.W LBL_191
LBL_192:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3354(A5)
        ADDQ.L #8,A7
        BRA.W LBL_191
LBL_191:
        UNLK A6
        RTS
        ; func rtUiAskSaveChanges  (JT slot 432)
        ;   param name : 8(A6)  size 4
        ;   local idx : -4(A6)  size 4
        ;   local kind : -8(A6)  size 4
        ;   local v : -12(A6)  size 4
        ;   local empty : -16(A6)  size 4
        ;   local item : -20(A6)  size 4
        ;   local t : -24(A6)  size 4
LBL_3:
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
        BEQ.W LBL_196
        JSR 2914(A5)
        MOVE.L D0,-4(A6)
        MOVE.L -70(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_110
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
        BEQ.W LBL_197
        LEA LBL_91(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_195
LBL_197:
        MOVE.L -74(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D1
        MOVEQ #4,D0
        BSR.W LBL_110
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        JSR 122(A5)
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_92(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #8,A7
        MOVE.L -12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_198
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_84(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #8,A7
        BRA.W LBL_199
LBL_198:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_200
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_85(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #8,A7
        BRA.W LBL_201
LBL_200:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_86(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #8,A7
LBL_201:
LBL_199:
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        JSR 2954(A5)
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        BRA.W LBL_195
LBL_196:
        JSR 1642(A5)
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
        BRA.W LBL_195
LBL_195:
        UNLK A6
        RTS
        ; func rtUiAlertMsg  (JT slot 433)
        ;   param msg : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local t : -16(A6)  size 4
        ;   local empty : -20(A6)  size 4
LBL_4:
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
        BSR.W LBL_15
        TST.L D0
        BEQ.W LBL_203
        JSR 122(A5)
        MOVE.L D0,-16(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_204:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_205
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
        BEQ.W LBL_206
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_206:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_204
LBL_205:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 2954(A5)
        ADDQ.L #4,A7
LBL_203:
        CLR.L D0
        MOVE.B -60(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_207
        JSR 1642(A5)
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
LBL_207:
LBL_202:
        UNLK A6
        RTS
        ; func rtSortedMapNew  (JT slot 434)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_5:
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
        BEQ.W LBL_209
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_209:
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
        BEQ.W LBL_210
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_210:
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
        BEQ.W LBL_211
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_211:
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
        BRA.W LBL_208
LBL_208:
        UNLK A6
        RTS
        ; func rtSortedMapRelease  (JT slot 435)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_6:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_213
        BRA.W LBL_212
LBL_213:
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
        BEQ.W LBL_214
        MOVE.L 8(A6),D0
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
LBL_214:
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
        BEQ.W LBL_215
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
LBL_215:
LBL_212:
        UNLK A6
        RTS
        ; func rtSortedMapLastref  (JT slot 436)
        ;   param m : 8(A6)  size 4
LBL_7:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_217
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_218
LBL_217:
        MOVEQ #0,D0
LBL_218:
        BRA.W LBL_216
LBL_216:
        UNLK A6
        RTS
        ; func rtSortedMapCount  (JT slot 437)
        ;   param m : 8(A6)  size 4
LBL_8:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        LEA 16(A0),A0
        MOVE.L (A0),D0
        BRA.W LBL_219
LBL_219:
        UNLK A6
        RTS
        ; func rtSortedMapValAt  (JT slot 438)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_221
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
        BRA.W LBL_222
LBL_221:
        MOVEQ #1,D0
LBL_222:
        TST.L D0
        BEQ.W LBL_223
        LEA LBL_83(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_223:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR 3442(A5)
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
LBL_220:
        UNLK A6
        RTS
        ; func natCrLf  (JT slot 439)
        ;   param s : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local len : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
LBL_10:
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
LBL_225:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_226
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
        BEQ.W LBL_227
        MOVEQ #10,D0
        MOVE.L D0,-12(A6)
LBL_227:
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
        BRA.W LBL_225
LBL_226:
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
        BRA.W LBL_224
LBL_224:
        UNLK A6
        RTS
        ; func natItoa  (JT slot 440)
        ;   param v : 12(A6)  size 4
        ;   param dst : 8(A6)  size 4
        ;   local neg : -2(A6)  size 2
        ;   local j : -6(A6)  size 4
        ;   local d : -10(A6)  size 4
        ;   local n : -14(A6)  size 4
        ;   local i : -18(A6)  size 4
        ;   local v2 : -22(A6)  size 4
LBL_11:
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
        MOVE.L -7088(A5),D0
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
        BSR.W LBL_112
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
        BSR.W LBL_111
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
        BRA.W LBL_235
LBL_236:
        MOVE.L -14(A6),D0
        BRA.W LBL_228
LBL_228:
        UNLK A6
        RTS
        ; func natWriteBytes  (JT slot 441)
        ;   param p : 12(A6)  size 4
        ;   param n : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        MOVE.L -7100(A5),D1
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
LBL_237:
        UNLK A6
        RTS
        ; func natFlush  (JT slot 442)
LBL_13:
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
LBL_240:
        UNLK A6
        RTS
        ; func natInit  (JT slot 443)
LBL_14:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7102(A5),D0
        TST.L D0
        BEQ.W LBL_242
        BRA.W LBL_241
LBL_242:
        MOVEQ #1,D0
        MOVE.B D0,-7102(A5)
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_243
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
        BRA.W LBL_241
LBL_243:
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
        BEQ.W LBL_244
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-7100(A5)
        BRA.W LBL_241
LBL_244:
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
LBL_241:
        UNLK A6
        RTS
        ; func nat_UiTraceOn  (JT slot 444)
LBL_15:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7110(A5),D0
        TST.L D0
        BNE.W LBL_246
        CLR.L D0
        MOVE.B -7134(A5),D0
        TST.L D0
        BEQ.W LBL_248
        CLR.L D0
        MOVE.B -7132(A5),D0
        BRA.W LBL_249
LBL_248:
        MOVEQ #0,D0
LBL_249:
        BRA.W LBL_247
LBL_246:
        MOVEQ #1,D0
LBL_247:
        BRA.W LBL_245
LBL_245:
        UNLK A6
        RTS
        ; func natAppTrace  (JT slot 445)
        ;   param enable : 8(A6)  size 4
LBL_16:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        MOVE.B D0,-7134(A5)
LBL_250:
        UNLK A6
        RTS
        ; func natWlOpenFile  (JT slot 446)
LBL_17:
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
        BEQ.W LBL_252
        MOVEQ #1,D0
        NEG.L D0
        BRA.W LBL_251
LBL_252:
        MOVE.L -7114(A5),D1
        MOVEQ #24,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        BRA.W LBL_251
LBL_251:
        UNLK A6
        RTS
        ; func natWlCloseFile  (JT slot 447)
        ;   param ref : 8(A6)  size 4
LBL_18:
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
LBL_253:
        UNLK A6
        RTS
        ; func natAppFlushLog  (JT slot 448)
        ;   local ref : -4(A6)  size 4
        ;   local werr : -8(A6)  size 4
LBL_19:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7132(A5),D0
        EORI.L #1,D0
        TST.L D0
        BNE.W LBL_255
        MOVE.L -7130(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_256
LBL_255:
        MOVEQ #1,D0
LBL_256:
        TST.L D0
        BEQ.W LBL_257
        BRA.W LBL_254
LBL_257:
        BSR.W LBL_17
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_258
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
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVE.L -8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_260
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
LBL_260:
        BRA.W LBL_259
LBL_258:
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_95(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
LBL_259:
        MOVEQ #0,D0
        MOVE.L D0,-7130(A5)
LBL_254:
        UNLK A6
        RTS
        ; func natWlAdd  (JT slot 449)
        ;   param s : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7132(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_262
        BRA.W LBL_261
LBL_262:
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
        BEQ.W LBL_263
        BSR.W LBL_19
LBL_263:
        MOVE.L -7130(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D1
        MOVE.L -7130(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-7130(A5)
LBL_261:
        UNLK A6
        RTS
        ; func natAppWriteLog  (JT slot 450)
        ;   param name : 12(A6)  size 4
        ;   param creator : 8(A6)  size 4
        ;   local ref : -4(A6)  size 4
LBL_21:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        BSR.W LBL_19
        MOVEQ #0,D0
        MOVE.B D0,-7132(A5)
        MOVE.L -7114(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_265
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
LBL_265:
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
        BEQ.W LBL_266
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
LBL_266:
        BSR.W LBL_17
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_96(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        BRA.W LBL_264
LBL_267:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEQ #0,D0
        MOVE.L D0,-7130(A5)
        MOVEQ #1,D0
        MOVE.B D0,-7132(A5)
LBL_264:
        UNLK A6
        RTS
        ; func natAbortLog  (JT slot 451)
        ;   param s : 8(A6)  size 4
LBL_22:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_269
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        BSR.W LBL_19
LBL_269:
LBL_268:
        UNLK A6
        RTS
        ; func natAlert  (JT slot 452)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_23:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_271
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        BRA.W LBL_270
LBL_271:
        BSR.W LBL_14
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        BSR.W LBL_13
LBL_270:
        UNLK A6
        RTS
        ; func natLog  (JT slot 453)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local i : -8(A6)  size 4
LBL_24:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_273
        BRA.W LBL_272
LBL_273:
        BSR.W LBL_14
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_10
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
LBL_274:
        MOVE.L -8(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_276
        MOVE.L -7096(A5),D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_277
LBL_276:
        MOVEQ #0,D0
LBL_277:
        TST.L D0
        BEQ.W LBL_275
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
        BRA.W LBL_274
LBL_275:
LBL_272:
        UNLK A6
        RTS
        ; func natQuit  (JT slot 454)
        ;   param code : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_25:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7104(A5),D0
        TST.L D0
        BEQ.W LBL_279
        BRA.W LBL_278
LBL_279:
        MOVEQ #1,D0
        MOVE.B D0,-7104(A5)
        BSR.W LBL_19
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_280
        DC.W $A9F4  ; NatExitToShell
LBL_280:
        BSR.W LBL_14
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
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_11
        ADDQ.L #8,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7084(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
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
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L -7092(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7096(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        MOVE.L -7100(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
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
LBL_281:
        BSR.W LBL_13
        DC.W $A9F4  ; NatExitToShell
LBL_278:
        UNLK A6
        RTS
        ; func nat_CorePanic  (JT slot 455)
        ;   param msg : 8(A6)  size 4
        ;   local full : -256(A6)  size 256
        ;   local n : -260(A6)  size 4
        ;   local i : -264(A6)  size 4
LBL_26:
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
        LEA LBL_97(PC),A0
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
        BSR.W LBL_14
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
LBL_283:
        MOVE.L -264(A6),D1
        MOVE.L -260(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_284
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
        BCS.W LBL_285
        MOVE.L A0,-(A7)
        MOVE.L D1,-(A7)
        JSR 106(A5)
        ADDQ.L #8,A7
LBL_285:
        ADDA.L D1,A0
        CLR.L D0
        MOVE.B 1(A0),D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -264(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-264(A6)
        BRA.W LBL_283
LBL_284:
        CLR.L D0
        MOVE.B -7110(A5),D0
        TST.L D0
        BEQ.W LBL_286
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
LBL_286:
        MOVE.L -7138(A5),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_19
        CLR.L D0
        MOVE.B -7414(A5),D0
        TST.L D0
        BEQ.W LBL_287
        LEA LBL_109(PC),A0
        MOVE.L A0,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_288
LBL_287:
        MOVEQ #0,D0
LBL_288:
        TST.L D0
        BEQ.W LBL_289
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
LBL_289:
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_282:
        UNLK A6
        RTS
        ; func nat_CoreSetLastErr  (JT slot 456)
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_27:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-7146(A5)
        LEA -7402(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
LBL_290:
        UNLK A6
        RTS
        ; func natLastErrCode  (JT slot 457)
LBL_28:
        LINK A6,#-52
        MOVE.L -7146(A5),D0
        BRA.W LBL_291
LBL_291:
        UNLK A6
        RTS
        ; func natLastErrMsg  (JT slot 458)
        ;   hidden result ptr : 8(A6)  size 4
LBL_29:
        LINK A6,#-52
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -7402(A5),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        BRA.W LBL_292
LBL_292:
        UNLK A6
        RTS
        ; func natArgsList  (JT slot 459)
        ;   local __ret4 : -4(A6)  size 4
LBL_30:
        LINK A6,#-56
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #256,-(A7)
        JSR 202(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-12(A6)
LBL_294:
        MOVE.L A1,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -7108(A5),D0
        MOVE.L D0,-4(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        BRA.W LBL_293
LBL_293:
        UNLK A6
        RTS
        ; func natFileEnsurePb  (JT slot 460)
LBL_31:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7408(A5),D0
        TST.L D0
        BEQ.W LBL_296
        BRA.W LBL_295
LBL_296:
        MOVEQ #1,D0
        MOVE.B D0,-7408(A5)
        MOVEQ #64,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7406(A5)
LBL_295:
        UNLK A6
        RTS
        ; func natFileFlush  (JT slot 461)
LBL_32:
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
LBL_297:
        UNLK A6
        RTS
        ; func natFileWriteText  (JT slot 462)
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
LBL_33:
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
        BEQ.W LBL_299
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_98(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_298
LBL_299:
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
        BEQ.W LBL_300
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_99(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_298
LBL_300:
        BSR.W LBL_31
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
        BEQ.W LBL_301
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
LBL_301:
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
        BEQ.W LBL_302
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_96(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_298
LBL_302:
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
        BEQ.W LBL_303
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
        BEQ.W LBL_304
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_304:
LBL_303:
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
        BSR.W LBL_32
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_305
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_306
LBL_305:
        MOVEQ #1,D0
LBL_306:
        TST.L D0
        BEQ.W LBL_307
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_93(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_298
LBL_307:
        MOVEQ #1,D0
        BRA.W LBL_298
LBL_298:
        UNLK A6
        RTS
        ; func natFileReadText  (JT slot 463)
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
LBL_34:
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
        BSR.W LBL_31
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
        BEQ.W LBL_309
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_96(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_308
LBL_309:
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
        BEQ.W LBL_310
        LEA LBL_82(PC),A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
        ADDQ.L #4,A7
LBL_310:
        MOVEQ #0,D0
        MOVE.L D0,-28(A6)
        MOVEQ #0,D0
        MOVE.B D0,-30(A6)
LBL_311:
        CLR.L D0
        MOVE.B -30(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_312
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
        BEQ.W LBL_313
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_314
LBL_313:
        MOVEQ #0,D0
LBL_314:
        TST.L D0
        BEQ.W LBL_315
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
        LEA LBL_94(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_308
LBL_315:
        MOVE.L -16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_316
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -28(A6),D1
        MOVE.L -16(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        JSR 114(A5)
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
LBL_316:
        MOVE.L -20(A6),D1
        MOVE.L #65497,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_317
        MOVE.L -16(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_318
LBL_317:
        MOVEQ #1,D0
LBL_318:
        TST.L D0
        BEQ.W LBL_319
        MOVEQ #1,D0
        MOVE.B D0,-30(A6)
LBL_319:
        BRA.W LBL_311
LBL_312:
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
        BRA.W LBL_308
LBL_308:
        UNLK A6
        RTS
        ; func natFileName  (JT slot 464)
        ;   param dst : 12(A6)  size 4
        ;   param path : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
        ;   local start : -8(A6)  size 4
        ;   local i : -12(A6)  size 4
        ;   local c : -16(A6)  size 4
        ;   local len : -20(A6)  size 4
LBL_35:
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
LBL_321:
        MOVE.L -12(A6),D1
        MOVE.L -4(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_322
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
        BEQ.W LBL_323
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
LBL_323:
        MOVE.L -12(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_321
LBL_322:
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
LBL_324:
        MOVE.L -12(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_325
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
        BRA.W LBL_324
LBL_325:
LBL_320:
        UNLK A6
        RTS
        ; func natReadResource  (JT slot 465)
        ;   param name : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
        ;   local h : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
        ;   local srcp : -16(A6)  size 4
        ;   local sz : -20(A6)  size 4
LBL_36:
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
        BEQ.W LBL_327
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_100(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_326
LBL_327:
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
        JSR 114(A5)
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
        BEQ.W LBL_328
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
LBL_328:
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
        BRA.W LBL_326
LBL_326:
        UNLK A6
        RTS
        ; func natWriteRes  (JT slot 466)
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
LBL_37:
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
        BEQ.W LBL_330
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_98(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_329
LBL_330:
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
        BEQ.W LBL_331
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_99(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_329
LBL_331:
        BSR.W LBL_31
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
        BEQ.W LBL_332
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
LBL_332:
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
        BEQ.W LBL_333
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_96(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_329
LBL_333:
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
        BEQ.W LBL_334
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
        BEQ.W LBL_335
        MOVEQ #1,D0
        MOVE.B D0,-22(A6)
LBL_335:
LBL_334:
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
        BSR.W LBL_32
        CLR.L D0
        MOVE.B -22(A6),D0
        TST.L D0
        BNE.W LBL_336
        MOVE.L -20(A6),D1
        MOVE.L -12(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        BRA.W LBL_337
LBL_336:
        MOVEQ #1,D0
LBL_337:
        TST.L D0
        BEQ.W LBL_338
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        LEA LBL_93(PC),A0
        MOVE.L A0,-(A7)
        JSR 42(A5)
        ADDQ.L #8,A7
        MOVEQ #0,D0
        BRA.W LBL_329
LBL_338:
        MOVEQ #1,D0
        BRA.W LBL_329
LBL_329:
        UNLK A6
        RTS
        ; func nat_SerFileWriteData  (JT slot 467)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_38:
        LINK A6,#-52
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_33
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_340
        MOVEQ #1,D0
        BRA.W LBL_339
LBL_340:
        MOVEQ #0,D0
        BRA.W LBL_339
LBL_339:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 468)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_39:
        LINK A6,#-52
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_34
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_342
        MOVEQ #1,D0
        BRA.W LBL_341
LBL_342:
        MOVEQ #0,D0
        BRA.W LBL_341
LBL_341:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 469)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_40:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7110(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_344
        CLR.L D0
        MOVE.B -7134(A5),D0
        TST.L D0
        BEQ.W LBL_345
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_41
        ADDQ.L #4,A7
LBL_345:
        BRA.W LBL_343
LBL_344:
        BSR.W LBL_14
        MOVE.L -7412(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_346
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7412(A5)
LBL_346:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7412(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7412(A5),D1
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
        MOVE.L -7412(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_12
        ADDQ.L #8,A7
        BSR.W LBL_13
LBL_343:
        UNLK A6
        RTS
        ; func natWlAddText  (JT slot 470)
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_41:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7132(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_348
        BRA.W LBL_347
LBL_348:
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
        BEQ.W LBL_349
        MOVE.L #511,D0
        MOVE.L D0,-8(A6)
LBL_349:
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
        BEQ.W LBL_350
        BSR.W LBL_19
LBL_350:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7118(A5),D1
        MOVE.L -7130(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
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
LBL_347:
        UNLK A6
        RTS
        ; func nat_UiRtQuit  (JT slot 471)
        ;   param code : 8(A6)  size 4
LBL_42:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_351:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 472)
LBL_43:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7414(A5),D0
        TST.L D0
        BEQ.W LBL_353
        BRA.W LBL_352
LBL_353:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7418(A5)
        MOVE.L -7418(A5),D1
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
        MOVE.B D0,-7414(A5)
        DC.W $A850  ; NatInitCursor
LBL_352:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 473)
        ;   param out : 8(A6)  size 4
LBL_44:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7418(A5),D1
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
        MOVE.L -7418(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_354:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 474)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_45:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7418(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7418(A5),D1
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
        BEQ.W LBL_356
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_356:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7418(A5),D1
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
        MOVE.L -7418(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_355:
        UNLK A6
        RTS
        ; func nat_UiConnPump  (JT slot 475)
LBL_46:
        LINK A6,#-52
        BSR.W LBL_54
LBL_357:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 476)
LBL_47:
        LINK A6,#-52
        MOVE.L #0,-(A7)
        JSR 1562(A5)
        ADDQ.L #4,A7
LBL_358:
        UNLK A6
        RTS
        ; func ui_every_0  (JT slot 477)
        ;   local g : -4(A6)  size 4
LBL_48:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,-(A7)
        JSR 1522(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_360
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #12451840,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_361
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_362
LBL_361:
        MOVEQ #1,D0
LBL_362:
        TST.L D0
        BEQ.W LBL_363
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_363:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 2322(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        TST.L D0
        BMI.W LBL_364
        MOVEQ #16,D1
        ASR.L D1,D0
        BRA.W LBL_365
LBL_364:
        NEG.L D0
        MOVEQ #16,D1
        ASR.L D1,D0
        NEG.L D0
LBL_365:
        MOVE.L D0,-(A7)
        MOVEQ #100,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 2346(A5)
        ADDA.W #20,A7
LBL_360:
LBL_359:
        UNLK A6
        RTS
        ; func ui_Game_opened  (JT slot 478)
        ;   param window : 8(A6)  size 4
LBL_49:
        LINK A6,#-52
        MOVE.L #655360,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #131072,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1530(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_366:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 479)
        ;   param slot : 8(A6)  size 4
LBL_50:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_368
        BRA.W LBL_369
LBL_368:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_370
        BRA.W LBL_371
LBL_370:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_372
        BRA.W LBL_373
LBL_372:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_374
        BRA.W LBL_375
LBL_374:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_376
        BRA.W LBL_377
LBL_376:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_378
        BRA.W LBL_379
LBL_378:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_380
        BRA.W LBL_381
LBL_380:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_382
LBL_382:
LBL_381:
LBL_379:
LBL_377:
LBL_375:
LBL_373:
LBL_371:
LBL_369:
LBL_367:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 480)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_51:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_384
        BRA.W LBL_385
LBL_384:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_386
        BRA.W LBL_387
LBL_386:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_388
        BRA.W LBL_389
LBL_388:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_390
        BRA.W LBL_391
LBL_390:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_392
        BRA.W LBL_393
LBL_392:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_394
        BRA.W LBL_395
LBL_394:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_396
        BRA.W LBL_397
LBL_396:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_398
LBL_398:
LBL_397:
LBL_395:
LBL_393:
LBL_391:
LBL_389:
LBL_387:
LBL_385:
LBL_383:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 481)
        ;   param slot : 8(A6)  size 4
LBL_52:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_400
        BRA.W LBL_401
LBL_400:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_402
        BRA.W LBL_403
LBL_402:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_404
        BRA.W LBL_405
LBL_404:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_406
        BRA.W LBL_407
LBL_406:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_408
        BRA.W LBL_409
LBL_408:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_410
        BRA.W LBL_411
LBL_410:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_412
        BRA.W LBL_413
LBL_412:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_414
LBL_414:
LBL_413:
LBL_411:
LBL_409:
LBL_407:
LBL_405:
LBL_403:
LBL_401:
LBL_399:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 482)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_53:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_416
        BRA.W LBL_417
LBL_416:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_418
        BRA.W LBL_419
LBL_418:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_420
        BRA.W LBL_421
LBL_420:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_422
        BRA.W LBL_423
LBL_422:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_424
        BRA.W LBL_425
LBL_424:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_426
        BRA.W LBL_427
LBL_426:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_428
        BRA.W LBL_429
LBL_428:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_430
LBL_430:
LBL_429:
LBL_427:
LBL_425:
LBL_423:
LBL_421:
LBL_419:
LBL_417:
LBL_415:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 483)
LBL_54:
        LINK A6,#-52
LBL_431:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 484)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_55:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_433
        BRA.W LBL_434
LBL_433:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_435
LBL_435:
LBL_434:
LBL_432:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 485)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_56:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_437
        BRA.W LBL_438
LBL_437:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_439
LBL_439:
LBL_438:
LBL_436:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 486)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_57:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_441
        BRA.W LBL_442
LBL_441:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_443
LBL_443:
LBL_442:
LBL_440:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 487)
        ;   param slot : 8(A6)  size 4
LBL_58:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_445
        BRA.W LBL_446
LBL_445:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_447
LBL_447:
LBL_446:
LBL_444:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 488)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_59:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_449
        BRA.W LBL_450
LBL_449:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_451
LBL_451:
LBL_450:
LBL_448:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 489)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_60:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_453
        BRA.W LBL_454
LBL_453:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_455
LBL_455:
LBL_454:
LBL_452:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 490)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_61:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_457
        BRA.W LBL_458
LBL_457:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_459
LBL_459:
LBL_458:
LBL_456:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 491)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_62:
        LINK A6,#-52
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_461
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_463
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_49
        ADDQ.L #4,A7
LBL_463:
        BRA.W LBL_462
LBL_461:
        LEA LBL_101(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_113
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_462:
LBL_460:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 492)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_63:
        LINK A6,#-52
        MOVE.L 28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_465
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_467
        BRA.W LBL_468
LBL_467:
        LEA LBL_102(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_113
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_468:
        BRA.W LBL_466
LBL_465:
        LEA LBL_103(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_113
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_466:
LBL_464:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 493)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_64:
        LINK A6,#-52
        LEA LBL_104(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_113
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_469:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 494)
        ;   param idx : 8(A6)  size 4
LBL_65:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_471
        BSR.W LBL_48
        BRA.W LBL_472
LBL_471:
        LEA LBL_105(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_113
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_472:
LBL_470:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 495)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_66:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_474
        BRA.W LBL_475
LBL_474:
        LEA LBL_106(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_113
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
LBL_475:
LBL_473:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 496)
        ;   param rowsIdx : 8(A6)  size 4
LBL_67:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #156,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_477
        LEA -7108(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_476
        BRA.W LBL_478
LBL_477:
        LEA LBL_107(PC),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        BSR.W LBL_113
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_476
LBL_478:
LBL_476:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 497)
        ;   param path : 8(A6)  size 4
LBL_68:
        LINK A6,#-52
LBL_479:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 498)
LBL_69:
        LINK A6,#-52
LBL_480:
        UNLK A6
        RTS
        ; func clar_ui_fire_logop  (JT slot 499)
        ;   param op : 24(A6)  size 4
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_70:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_481
LBL_481:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 500)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_71:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_482
LBL_482:
        UNLK A6
        RTS
        ; func clar_ui_fire_fmtcell  (JT slot 501)
        ;   param stP : 36(A6)  size 4
        ;   param rec : 32(A6)  size 4
        ;   param recH : 28(A6)  size 4
        ;   param hstate : 24(A6)  size 4
        ;   param layoutOff : 20(A6)  size 4
        ;   param colsOff : 16(A6)  size 4
        ;   param k : 12(A6)  size 4
        ;   param colRect : 8(A6)  size 4
LBL_72:
        LINK A6,#-52
LBL_483:
        UNLK A6
        RTS
        ; func clar_ui_fire_geomapply  (JT slot 502)
LBL_73:
        LINK A6,#-52
LBL_484:
        UNLK A6
        RTS
        ; func clar_ui_fire_fontsinit  (JT slot 503)
        ;   param inst : 8(A6)  size 4
LBL_74:
        LINK A6,#-52
LBL_485:
        UNLK A6
        RTS
        ; func clar_ui_fire_drawlabel  (JT slot 504)
        ;   param instV : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_75:
        LINK A6,#-52
LBL_486:
        UNLK A6
        RTS
        ; func clar_ui_fire_labelsettext  (JT slot 505)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_76:
        LINK A6,#-52
LBL_487:
        UNLK A6
        RTS
        ; func clar_ui_fire_canvasmetric  (JT slot 506)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
LBL_77:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_488
LBL_488:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 507) -- pascal callback glue for aeQuitHandler
LBL_78:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1474(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 508) -- pascal callback glue for aeOappHandler
LBL_79:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1482(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 509) -- pascal callback glue for rtUiScrollbarAction
LBL_80:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 2514(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 510) -- pascal callback glue for rtUiLdefDraw
LBL_81:
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
        JSR 2666(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_110:
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
LBL_111:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_489
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_108(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_489:
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
        BPL.W LBL_490
        NEG.L D2
        MOVE.L #1,D4
LBL_490:
        CLR.L D5
        TST.L D3
        BPL.W LBL_491
        NEG.L D3
        MOVE.L #1,D5
LBL_491:
        CLR.L D6
        MOVE.W #31,D7
LBL_492:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_493
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_493:
        DBRA D7,LBL_492
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_494
        NEG.L D2
LBL_494:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_112:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_495
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_108(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_495:
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
        BPL.W LBL_496
        NEG.L D2
        MOVE.L #1,D4
LBL_496:
        CLR.L D5
        TST.L D3
        BPL.W LBL_497
        NEG.L D3
        MOVE.L #1,D5
LBL_497:
        CLR.L D6
        MOVE.W #31,D7
LBL_498:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_499
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_499:
        DBRA D7,LBL_498
        TST.L D4
        BEQ.W LBL_500
        NEG.L D6
LBL_500:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_113:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_501(PC),A0
        MOVE.L A0,-4(A6)
LBL_502:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_503
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_504
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_502
LBL_504:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_505:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_502
LBL_503:
        UNLK A6
        RTS
LBL_501:
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
LBL_108:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_87:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_88:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_89:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_90:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_91:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_92:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_84:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_85:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_86:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_82:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_83:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_95:
        DC.B $18
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$6C,$6F,$67,$20,$66,$69,$6C,$65
        DC.B $00
LBL_96:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_97:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_98:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_99:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_93:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_94:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_100:
        DC.B $12
        DC.B $72,$65,$73,$6F,$75,$72,$63,$65,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        DC.B $00
LBL_101:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_102:
        DC.B $2B
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$64,$67,$65,$74,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_103:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_104:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_105:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_106:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_107:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
        ; constant pool: --events script bytes (0 bytes + NUL)
LBL_109:
        DC.B $00
        DC.B $00
