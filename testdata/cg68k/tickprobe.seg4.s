        ; func nat_SerFileReadTextInto  (JT slot 365)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_0:
        LINK A6,#-2128
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 2914(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_143
        MOVEQ #1,D0
        BRA.W LBL_142
LBL_143:
        MOVEQ #0,D0
        BRA.W LBL_142
LBL_142:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 366)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_1:
        LINK A6,#-2132
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 2818(A5)
        MOVE.L -450(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_145
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-450(A5)
LBL_145:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -450(A5),D1
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
        MOVE.L -450(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 2802(A5)
        ADDQ.L #8,A7
        JSR 2810(A5)
LBL_144:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 367)
LBL_2:
        LINK A6,#-2128
        CLR.L D0
        MOVE.B -452(A5),D0
        TST.L D0
        BEQ.W LBL_147
        BRA.W LBL_146
LBL_147:
        MOVEQ #1,D0
        MOVE.B D0,-452(A5)
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-456(A5)
        MOVE.L -456(A5),D1
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
        DC.W $A850  ; NatInitCursor
LBL_146:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 368)
        ;   param out : 8(A6)  size 4
LBL_3:
        LINK A6,#-2128
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D1
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
        MOVE.L -456(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_148:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 369)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_4:
        LINK A6,#-2132
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -456(A5),D1
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
        BEQ.W LBL_150
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_150:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -456(A5),D1
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
        MOVE.L -456(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_149:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 370)
LBL_5:
        LINK A6,#-2128
        MOVE.L #0,-(A7)
        JSR 1202(A5)
        ADDQ.L #4,A7
LBL_151:
        UNLK A6
        RTS
        ; func ui_Probe_opened  (JT slot 371)
        ;   param window : 8(A6)  size 4
        ;   local p : -4(A6)  size 4
LBL_6:
        LINK A6,#-2132
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
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
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVEQ #20,D0
        MOVE.L D0,-(A7)
        MOVEQ #20,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.B D0,-(A7)
        JSR 1834(A5)
        ADDA.W #26,A7
LBL_152:
        UNLK A6
        RTS
        ; func ui_every_0  (JT slot 372)
        ;   local p : -4(A6)  size 4
LBL_7:
        LINK A6,#-2132
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,-(A7)
        JSR 1162(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #1,D0
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
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1170(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        BSR.W LBL_138
        MOVE.L D0,D1
        MOVE.L #280,D0
        BSR.W LBL_140
        MOVE.L D0,-(A7)
        MOVEQ #40,D0
        MOVE.L D0,-(A7)
        MOVEQ #4,D0
        MOVE.L D0,-(A7)
        MOVEQ #20,D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
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
        MOVE.L D0,D1
        MOVEQ #60,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_155
        JSR 1234(A5)
LBL_155:
LBL_154:
LBL_153:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 373)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_8:
        LINK A6,#-2128
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_157
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_159
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_6
        ADDQ.L #4,A7
LBL_159:
        BRA.W LBL_158
LBL_157:
        LEA LBL_127(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_141
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
LBL_158:
LBL_156:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 374)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_9:
        LINK A6,#-2128
        MOVE.L 28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_163
        BRA.W LBL_164
LBL_163:
        LEA LBL_128(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_141
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
LBL_164:
        BRA.W LBL_162
LBL_161:
        LEA LBL_129(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_141
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
LBL_162:
LBL_160:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 375)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_10:
        LINK A6,#-2128
        LEA LBL_130(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_141
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
LBL_165:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 376)
        ;   param idx : 8(A6)  size 4
LBL_11:
        LINK A6,#-2128
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_167
        BSR.W LBL_7
        BRA.W LBL_168
LBL_167:
        LEA LBL_131(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_141
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
LBL_168:
LBL_166:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 377)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_12:
        LINK A6,#-2128
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_170
        BRA.W LBL_171
LBL_170:
        LEA LBL_132(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_141
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
LBL_171:
LBL_169:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 378)
        ;   param rowsIdx : 8(A6)  size 4
LBL_13:
        LINK A6,#-2128
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_173
        LEA -4(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_174
LBL_173:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_175
        LEA -8(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_176
LBL_175:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_177
        LEA -12(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_178
LBL_177:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_179
        LEA -16(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_180
LBL_179:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
        LEA -18(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_182
LBL_181:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
        LEA -22(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_184
LBL_183:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_185
        LEA -26(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_186
LBL_185:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_187
        LEA -30(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_188
LBL_187:
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
        LEA -34(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_190
LBL_189:
        MOVE.L 8(A6),D1
        MOVEQ #9,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_191
        LEA -38(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_192
LBL_191:
        MOVE.L 8(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_193
        LEA -40(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_194
LBL_193:
        MOVE.L 8(A6),D1
        MOVEQ #11,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_195
        LEA -42(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_196
LBL_195:
        MOVE.L 8(A6),D1
        MOVEQ #12,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_197
        LEA -46(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_198
LBL_197:
        MOVE.L 8(A6),D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_199
        LEA -50(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_200
LBL_199:
        MOVE.L 8(A6),D1
        MOVEQ #14,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_201
        LEA -54(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_202
LBL_201:
        MOVE.L 8(A6),D1
        MOVEQ #15,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_203
        LEA -58(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_204
LBL_203:
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_205
        LEA -62(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_206
LBL_205:
        MOVE.L 8(A6),D1
        MOVEQ #17,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_207
        LEA -66(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_208
LBL_207:
        MOVE.L 8(A6),D1
        MOVEQ #18,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_209
        LEA -70(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_210
LBL_209:
        MOVE.L 8(A6),D1
        MOVEQ #19,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_211
        LEA -74(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_212
LBL_211:
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_213
        LEA -76(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_214
LBL_213:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_215
        LEA -78(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_216
LBL_215:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_217
        LEA -82(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_218
LBL_217:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_219
        LEA -84(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_220
LBL_219:
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_221
        LEA -88(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_222
LBL_221:
        MOVE.L 8(A6),D1
        MOVEQ #25,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_223
        LEA -92(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_224
LBL_223:
        MOVE.L 8(A6),D1
        MOVEQ #26,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_225
        LEA -96(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_226
LBL_225:
        MOVE.L 8(A6),D1
        MOVEQ #27,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_227
        LEA -100(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_228
LBL_227:
        MOVE.L 8(A6),D1
        MOVEQ #28,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_229
        LEA -104(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_230
LBL_229:
        MOVE.L 8(A6),D1
        MOVEQ #29,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_231
        LEA -108(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_232
LBL_231:
        MOVE.L 8(A6),D1
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_233
        LEA -110(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_234
LBL_233:
        MOVE.L 8(A6),D1
        MOVEQ #31,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_235
        LEA -114(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_236
LBL_235:
        MOVE.L 8(A6),D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_237
        LEA -118(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_238
LBL_237:
        MOVE.L 8(A6),D1
        MOVEQ #33,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_239
        LEA -122(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_240
LBL_239:
        MOVE.L 8(A6),D1
        MOVEQ #34,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_241
        LEA -124(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_242
LBL_241:
        MOVE.L 8(A6),D1
        MOVEQ #35,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_243
        LEA -128(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_244
LBL_243:
        MOVE.L 8(A6),D1
        MOVEQ #36,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_245
        LEA -132(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_246
LBL_245:
        MOVE.L 8(A6),D1
        MOVEQ #37,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_247
        LEA -136(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_248
LBL_247:
        MOVE.L 8(A6),D1
        MOVEQ #38,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_249
        LEA -140(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_250
LBL_249:
        MOVE.L 8(A6),D1
        MOVEQ #39,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_251
        LEA -144(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_252
LBL_251:
        MOVE.L 8(A6),D1
        MOVEQ #40,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_253
        LEA -148(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_254
LBL_253:
        MOVE.L 8(A6),D1
        MOVEQ #41,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_255
        LEA -152(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_256
LBL_255:
        MOVE.L 8(A6),D1
        MOVEQ #42,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_257
        LEA -156(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_258
LBL_257:
        MOVE.L 8(A6),D1
        MOVEQ #43,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_259
        LEA -160(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_260
LBL_259:
        MOVE.L 8(A6),D1
        MOVEQ #44,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_261
        LEA -164(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_262
LBL_261:
        MOVE.L 8(A6),D1
        MOVEQ #45,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_263
        LEA -168(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_264
LBL_263:
        MOVE.L 8(A6),D1
        MOVEQ #46,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_265
        LEA -172(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_266
LBL_265:
        MOVE.L 8(A6),D1
        MOVEQ #47,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_267
        LEA -174(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_268
LBL_267:
        MOVE.L 8(A6),D1
        MOVEQ #48,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_269
        LEA -176(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_270
LBL_269:
        MOVE.L 8(A6),D1
        MOVEQ #49,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_271
        LEA -180(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_272
LBL_271:
        MOVE.L 8(A6),D1
        MOVEQ #50,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_273
        LEA -184(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_274
LBL_273:
        MOVE.L 8(A6),D1
        MOVEQ #51,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_275
        LEA -440(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_276
LBL_275:
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_277
        LEA -444(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_278
LBL_277:
        MOVE.L 8(A6),D1
        MOVEQ #53,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_279
        LEA -446(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_280
LBL_279:
        MOVE.L 8(A6),D1
        MOVEQ #54,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_281
        LEA -450(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_282
LBL_281:
        MOVE.L 8(A6),D1
        MOVEQ #55,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_283
        LEA -452(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_284
LBL_283:
        MOVE.L 8(A6),D1
        MOVEQ #56,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_285
        LEA -456(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_286
LBL_285:
        LEA LBL_133(PC),A0
        MOVE.L A0,-(A7)
        JSR 2834(A5)
        ADDQ.L #4,A7
        BSR.W LBL_141
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 2842(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_172
LBL_286:
LBL_284:
LBL_282:
LBL_280:
LBL_278:
LBL_276:
LBL_274:
LBL_272:
LBL_270:
LBL_268:
LBL_266:
LBL_264:
LBL_262:
LBL_260:
LBL_258:
LBL_256:
LBL_254:
LBL_252:
LBL_250:
LBL_248:
LBL_246:
LBL_244:
LBL_242:
LBL_240:
LBL_238:
LBL_236:
LBL_234:
LBL_232:
LBL_230:
LBL_228:
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
LBL_188:
LBL_186:
LBL_184:
LBL_182:
LBL_180:
LBL_178:
LBL_176:
LBL_174:
LBL_172:
        UNLK A6
        RTS
        ; func clar_cb_rtUiScrollbarAction (JT slot 379) -- pascal callback glue for rtUiScrollbarAction
LBL_14:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1954(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 380) -- pascal callback glue for rtUiLdefDraw
LBL_15:
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
LBL_138:
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
LBL_139:
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
        BPL.W LBL_287
        NEG.L D2
        MOVE.L #1,D4
LBL_287:
        CLR.L D5
        TST.L D3
        BPL.W LBL_288
        NEG.L D3
        MOVE.L #1,D5
LBL_288:
        CLR.L D6
        MOVE.W #31,D7
LBL_289:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_290
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_290:
        DBRA D7,LBL_289
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_291
        NEG.L D2
LBL_291:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_140:
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
        BPL.W LBL_292
        NEG.L D2
        MOVE.L #1,D4
LBL_292:
        CLR.L D5
        TST.L D3
        BPL.W LBL_293
        NEG.L D3
        MOVE.L #1,D5
LBL_293:
        CLR.L D6
        MOVE.W #31,D7
LBL_294:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_295
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_295:
        DBRA D7,LBL_294
        TST.L D4
        BEQ.W LBL_296
        NEG.L D6
LBL_296:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_141:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
LBL_297:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_16:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_17:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_18:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_19:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_20:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_21:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_22:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_23:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_24:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_25:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_26:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_27:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_28:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_29:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_30:
        DC.B $06
        DC.B $63,$6C,$6F,$73,$65,$64
        DC.B $00
LBL_31:
        DC.B $0C
        DC.B $63,$6C,$6F,$73,$65,$52,$65,$71,$75,$65,$73,$74
        DC.B $00
LBL_32:
        DC.B $01
        DC.B $2D
LBL_33:
        DC.B $18
        DC.B $41,$62,$6F,$75,$74,$20,$54,$68,$69,$73,$20,$41,$70,$70,$6C,$69,$63,$61,$74,$69,$6F,$6E,$3B,$2D
        DC.B $00
LBL_34:
        DC.B $06
        DC.B $55,$6E,$64,$6F,$2F,$5A
        DC.B $00
LBL_35:
        DC.B $05
        DC.B $43,$75,$74,$2F,$58
LBL_36:
        DC.B $06
        DC.B $43,$6F,$70,$79,$2F,$43
        DC.B $00
LBL_37:
        DC.B $07
        DC.B $50,$61,$73,$74,$65,$2F,$56
LBL_38:
        DC.B $05
        DC.B $43,$6C,$65,$61,$72
LBL_39:
        DC.B $07
        DC.B $72,$65,$73,$69,$7A,$65,$64
LBL_40:
        DC.B $06
        DC.B $63,$68,$61,$6E,$67,$65
        DC.B $00
LBL_41:
        DC.B $05
        DC.B $63,$6C,$69,$63,$6B
LBL_42:
        DC.B $04
        DC.B $64,$72,$61,$67
        DC.B $00
LBL_43:
        DC.B $05
        DC.B $65,$6E,$74,$65,$72
LBL_44:
        DC.B $03
        DC.B $6B,$65,$79
LBL_45:
        DC.B $20
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$72,$65,$63,$6F,$67,$6E,$69,$7A,$65,$64,$20,$77,$69,$64,$67,$65,$74,$20,$6B,$69,$6E,$64
        DC.B $00
LBL_46:
        DC.B $01
        DC.B $78
LBL_47:
        DC.B $01
        DC.B $3F
LBL_48:
        DC.B $06
        DC.B $73,$65,$6C,$65,$63,$74
        DC.B $00
LBL_49:
        DC.B $0B
        DC.B $64,$6F,$75,$62,$6C,$65,$43,$6C,$69,$63,$6B
LBL_50:
        DC.B $78
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$66,$6F,$75,$6E,$64,$20,$6E,$6F,$20,$6D,$65,$6E,$75,$20,$69,$6E,$20,$74,$68,$65,$20,$6D,$65,$6E,$75,$20,$6C,$69,$73,$74,$20,$66,$6F,$72,$20,$74,$68,$69,$73,$20,$77,$69,$64,$67,$65,$74,$20,$28,$63,$6C,$6F,$73,$65,$2F,$72,$65,$6F,$70,$65,$6E,$20,$6C,$65,$66,$74,$20,$69,$74,$20,$75,$6E,$64,$65,$6C,$65,$74,$65,$64,$20,$6F,$72,$20,$6E,$65,$76,$65,$72,$20,$72,$65,$69,$6E,$73,$65,$72,$74,$65,$64,$29
        DC.B $00
LBL_51:
        DC.B $71
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$47,$65,$74,$4D,$65,$6E,$75,$48,$61,$6E,$64,$6C,$65,$20,$72,$65,$74,$75,$72,$6E,$65,$64,$20,$61,$20,$6D,$65,$6E,$75,$20,$68,$61,$6E,$64,$6C,$65,$20,$74,$68,$61,$74,$20,$69,$73,$6E,$27,$74,$20,$74,$68,$69,$73,$20,$69,$6E,$73,$74,$61,$6E,$63,$65,$27,$73,$20,$6F,$77,$6E,$20,$28,$73,$74,$61,$6C,$65,$2F,$6C,$65,$61,$6B,$65,$64,$20,$65,$6E,$74,$72,$79,$20,$75,$6E,$64,$65,$72,$20,$74,$68,$65,$20,$73,$61,$6D,$65,$20,$49,$44,$29
LBL_52:
        DC.B $57
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$6D,$65,$6E,$75,$20,$69,$74,$65,$6D,$20,$63,$6F,$75,$6E,$74,$20,$64,$6F,$65,$73,$6E,$27,$74,$20,$6D,$61,$74,$63,$68,$20,$74,$68,$65,$20,$62,$6F,$75,$6E,$64,$20,$65,$6E,$75,$6D,$20,$28,$72,$65,$62,$75,$69,$6C,$74,$20,$77,$69,$74,$68,$20,$73,$74,$61,$6C,$65,$2F,$6C,$65,$66,$74,$6F,$76,$65,$72,$20,$69,$74,$65,$6D,$73,$29
LBL_53:
        DC.B $24
        DC.B $70,$6F,$70,$75,$70,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_54:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$61,$6E,$73,$77,$65,$72,$20,$71,$75,$65,$75,$65,$20,$6F,$76,$65,$72,$66,$6C,$6F,$77
LBL_55:
        DC.B $25
        DC.B $73,$63,$72,$69,$70,$74,$65,$64,$20,$64,$69,$61,$6C,$6F,$67,$20,$77,$69,$74,$68,$20,$6E,$6F,$20,$71,$75,$65,$75,$65,$64,$20,$61,$6E,$73,$77,$65,$72
LBL_56:
        DC.B $07
        DC.B $54,$20,$4F,$50,$45,$4E,$20
LBL_57:
        DC.B $01
        DC.B $20
LBL_58:
        DC.B $08
        DC.B $54,$20,$43,$4C,$4F,$53,$45,$20
        DC.B $00
LBL_59:
        DC.B $07
        DC.B $54,$20,$46,$49,$52,$45,$20
LBL_60:
        DC.B $01
        DC.B $2E
LBL_61:
        DC.B $07
        DC.B $2E,$73,$65,$6C,$65,$63,$74
LBL_62:
        DC.B $0D
        DC.B $54,$20,$46,$49,$52,$45,$20,$65,$76,$65,$72,$79,$2E
LBL_63:
        DC.B $06
        DC.B $54,$20,$44,$49,$4D,$20
        DC.B $00
LBL_64:
        DC.B $05
        DC.B $2E,$43,$75,$74,$20
LBL_65:
        DC.B $06
        DC.B $2E,$43,$6F,$70,$79,$20
        DC.B $00
LBL_66:
        DC.B $07
        DC.B $2E,$50,$61,$73,$74,$65,$20
LBL_67:
        DC.B $07
        DC.B $2E,$43,$6C,$65,$61,$72,$20
LBL_68:
        DC.B $08
        DC.B $54,$20,$46,$52,$4F,$4E,$54,$20
        DC.B $00
LBL_69:
        DC.B $08
        DC.B $54,$20,$41,$42,$4F,$55,$54,$20
        DC.B $00
LBL_70:
        DC.B $01
        DC.B $7C
LBL_71:
        DC.B $07
        DC.B $63,$61,$70,$74,$69,$6F,$6E
LBL_72:
        DC.B $04
        DC.B $74,$65,$78,$74
        DC.B $00
LBL_73:
        DC.B $07
        DC.B $65,$6E,$61,$62,$6C,$65,$64
LBL_74:
        DC.B $07
        DC.B $63,$68,$65,$63,$6B,$65,$64
LBL_75:
        DC.B $08
        DC.B $73,$65,$6C,$65,$63,$74,$65,$64
        DC.B $00
LBL_76:
        DC.B $05
        DC.B $77,$69,$64,$74,$68
LBL_77:
        DC.B $06
        DC.B $68,$65,$69,$67,$68,$74
        DC.B $00
LBL_78:
        DC.B $06
        DC.B $54,$20,$53,$45,$54,$20
        DC.B $00
LBL_79:
        DC.B $09
        DC.B $2E,$69,$6E,$76,$61,$6C,$69,$64,$2E
LBL_80:
        DC.B $02
        DC.B $54,$20
        DC.B $00
LBL_81:
        DC.B $0A
        DC.B $54,$20,$4F,$50,$45,$4E,$44,$4F,$43,$20
        DC.B $00
LBL_82:
        DC.B $04
        DC.B $73,$61,$76,$65
        DC.B $00
LBL_83:
        DC.B $07
        DC.B $64,$69,$73,$63,$61,$72,$64
LBL_84:
        DC.B $06
        DC.B $63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_85:
        DC.B $37
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73,$3A,$20,$62,$61,$64,$20,$61,$72,$67,$75,$6D,$65,$6E,$74,$20,$28,$77,$61,$6E,$74,$20,$73,$61,$76,$65,$7C,$64,$69,$73,$63,$61,$72,$64,$7C,$63,$61,$6E,$63,$65,$6C,$29
LBL_86:
        DC.B $23
        DC.B $73,$6E,$61,$70,$3A,$20,$73,$63,$72,$65,$65,$6E,$42,$69,$74,$73,$2E,$72,$6F,$77,$42,$79,$74,$65,$73,$20,$69,$73,$20,$6E,$6F,$74,$20,$36,$34
LBL_87:
        DC.B $10
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$23,$23,$20
        DC.B $00
LBL_88:
        DC.B $13
        DC.B $23,$23,$43,$4C,$41,$52,$55,$53,$2D,$53,$4E,$41,$50,$2D,$45,$4E,$44,$23,$23
LBL_89:
        DC.B $2C
        DC.B $75,$69,$70,$6F,$72,$74,$3A,$20,$75,$6E,$6B,$6E,$6F,$77,$6E,$20,$6F,$72,$20,$75,$6E,$73,$75,$70,$70,$6F,$72,$74,$65,$64,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$76,$65,$72,$62
        DC.B $00
LBL_90:
        DC.B $08
        DC.B $64,$62,$6C,$63,$6C,$69,$63,$6B
        DC.B $00
LBL_91:
        DC.B $04
        DC.B $74,$79,$70,$65
        DC.B $00
LBL_92:
        DC.B $04
        DC.B $6D,$65,$6E,$75
        DC.B $00
LBL_93:
        DC.B $05
        DC.B $63,$6C,$6F,$73,$65
LBL_94:
        DC.B $06
        DC.B $72,$65,$73,$69,$7A,$65
        DC.B $00
LBL_95:
        DC.B $04
        DC.B $7A,$6F,$6F,$6D
        DC.B $00
LBL_96:
        DC.B $04
        DC.B $74,$69,$63,$6B
        DC.B $00
LBL_97:
        DC.B $04
        DC.B $73,$6E,$61,$70
        DC.B $00
LBL_98:
        DC.B $04
        DC.B $71,$75,$69,$74
        DC.B $00
LBL_99:
        DC.B $09
        DC.B $6C,$61,$75,$6E,$63,$68,$64,$6F,$63
LBL_100:
        DC.B $0C
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$70,$6F,$70,$75,$70
        DC.B $00
LBL_101:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$6F,$70,$65,$6E
LBL_102:
        DC.B $0B
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$73,$61,$76,$65
LBL_103:
        DC.B $0E
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$68,$61,$6E,$67,$65,$73
        DC.B $00
LBL_104:
        DC.B $0D
        DC.B $61,$6E,$73,$77,$65,$72,$2D,$63,$61,$6E,$63,$65,$6C
LBL_105:
        DC.B $2A
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$6D,$75,$73,$74,$20,$68,$61,$76,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$65,$6E,$74,$72,$69,$65,$73
        DC.B $00
LBL_106:
        DC.B $31
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$20,$66,$69,$6C,$74,$65,$72,$20,$65,$6E,$74,$72,$79,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_107:
        DC.B $00
        DC.B $00
LBL_108:
        DC.B $08
        DC.B $53,$61,$76,$65,$20,$61,$73,$3A
        DC.B $00
LBL_109:
        DC.B $08
        DC.B $61,$63,$63,$65,$70,$74,$65,$64
        DC.B $00
LBL_110:
        DC.B $09
        DC.B $63,$61,$6E,$63,$65,$6C,$6C,$65,$64
LBL_111:
        DC.B $21
        DC.B $65,$64,$69,$74,$20,$77,$68,$69,$6C,$65,$20,$61,$20,$66,$6F,$72,$6D,$20,$69,$73,$20,$61,$6C,$72,$65,$61,$64,$79,$20,$6F,$70,$65,$6E
LBL_112:
        DC.B $18
        DC.B $65,$64,$69,$74,$3A,$20,$77,$69,$6E,$64,$6F,$77,$20,$68,$61,$73,$20,$6E,$6F,$20,$66,$6F,$72,$6D
        DC.B $00
LBL_113:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$4F,$50,$45,$4E,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_114:
        DC.B $26
        DC.B $61,$73,$6B,$4F,$70,$65,$6E,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_115:
        DC.B $07
        DC.B $41,$53,$4B,$4F,$50,$45,$4E
LBL_116:
        DC.B $10
        DC.B $54,$20,$41,$53,$4B,$53,$41,$56,$45,$20,$63,$61,$6E,$63,$65,$6C
        DC.B $00
LBL_117:
        DC.B $26
        DC.B $61,$73,$6B,$53,$61,$76,$65,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
        DC.B $00
LBL_118:
        DC.B $07
        DC.B $41,$53,$4B,$53,$41,$56,$45
LBL_119:
        DC.B $2D
        DC.B $61,$73,$6B,$53,$61,$76,$65,$43,$68,$61,$6E,$67,$65,$73,$3A,$20,$73,$63,$72,$69,$70,$74,$65,$64,$20,$61,$6E,$73,$77,$65,$72,$20,$6B,$69,$6E,$64,$20,$6D,$69,$73,$6D,$61,$74,$63,$68
LBL_120:
        DC.B $0D
        DC.B $54,$20,$41,$53,$4B,$43,$48,$41,$4E,$47,$45,$53,$20
LBL_121:
        DC.B $0F
        DC.B $72,$75,$6E,$74,$69,$6D,$65,$20,$65,$72,$72,$6F,$72,$3A,$20
LBL_122:
        DC.B $26
        DC.B $66,$69,$6C,$65,$20,$74,$79,$70,$65,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
        DC.B $00
LBL_123:
        DC.B $29
        DC.B $66,$69,$6C,$65,$20,$63,$72,$65,$61,$74,$6F,$72,$20,$6D,$75,$73,$74,$20,$62,$65,$20,$61,$74,$20,$6D,$6F,$73,$74,$20,$34,$20,$63,$68,$61,$72,$61,$63,$74,$65,$72,$73
LBL_124:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$6F,$70,$65,$6E,$20,$66,$69,$6C,$65
LBL_125:
        DC.B $14
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$77,$72,$69,$74,$65,$20,$66,$69,$6C,$65
        DC.B $00
LBL_126:
        DC.B $13
        DC.B $63,$6F,$75,$6C,$64,$20,$6E,$6F,$74,$20,$72,$65,$61,$64,$20,$66,$69,$6C,$65
LBL_127:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_128:
        DC.B $2B
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$64,$67,$65,$74,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_129:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_130:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_131:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_132:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_133:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_134:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        ; constant pool: enum value tables
LBL_137:
        DC.L $00000000
        DC.L $00000001
        DC.L $00000002
        ; constant pool: serdesc tables
        ; constant pool: UI descriptor blob (264 bytes)
LBL_135:
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
LBL_136:
        DC.B $00
        DC.B $00
