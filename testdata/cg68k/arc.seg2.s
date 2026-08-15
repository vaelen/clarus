        ; func arcBirth  (JT slot 182)
        ;   local l : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local t : -12(A6)  size 4
LBL_0:
        LINK A6,#-8308
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 418(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-8264(A6)
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_28
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-8268(A6)
        CLR.L -8272(A6)
LBL_29:
        MOVE.L -8272(A6),D0
        MOVE.L -8268(A6),D1
        CMP.L D1,D0
        BGE.W LBL_28
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8272(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-8272(A6)
        BRA.W LBL_29
LBL_28:
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-8264(A6)
LBL_30:
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 434(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -12(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_27:
        UNLK A6
        RTS
        ; func arcAliasRetain  (JT slot 183)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
LBL_1:
        LINK A6,#-8304
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_13(PC),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L D0,-12(A6)
        LEA -12(A6),A0
        MOVE.L A0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-8260(A6)
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_32
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-8264(A6)
        CLR.L -8268(A6)
LBL_33:
        MOVE.L -8268(A6),D0
        MOVE.L -8264(A6),D1
        CMP.L D1,D0
        BGE.W LBL_32
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8268(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-8268(A6)
        BRA.W LBL_33
LBL_32:
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-8260(A6)
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_34
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-8264(A6)
        CLR.L -8268(A6)
LBL_35:
        MOVE.L -8268(A6),D0
        MOVE.L -8264(A6),D1
        CMP.L D1,D0
        BGE.W LBL_34
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8268(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-8268(A6)
        BRA.W LBL_35
LBL_34:
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-8260(A6)
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_36
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-8264(A6)
        CLR.L -8268(A6)
LBL_37:
        MOVE.L -8268(A6),D0
        MOVE.L -8264(A6),D1
        CMP.L D1,D0
        BGE.W LBL_36
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8268(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-8268(A6)
        BRA.W LBL_37
LBL_36:
        MOVE.L A1,-(A7)
        MOVE.L -8260(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_31:
        UNLK A6
        RTS
        ; func arcStmtTempRelease  (JT slot 184)
        ;   local l : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local x : -12(A6)  size 4
LBL_2:
        LINK A6,#-8308
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 418(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_14(PC),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        MOVE.L -20(A6),D0
        MOVE.L D0,-16(A6)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        MOVE.L A0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -16(A6),D0
        MOVE.L A1,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A6)
        MOVEQ #5,D0
        MOVE.L D0,-20(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_16(PC),A0
        MOVE.L A0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 450(A5)
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-24(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_16(PC),A0
        MOVE.L A0,-(A7)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVE.L -24(A6),D0
        MOVE.L D0,-12(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-8264(A6)
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_39
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-8268(A6)
        CLR.L -8272(A6)
LBL_40:
        MOVE.L -8272(A6),D0
        MOVE.L -8268(A6),D1
        CMP.L D1,D0
        BGE.W LBL_39
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8272(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #8,A7
        MOVEA.L (A7)+,A1
        MOVEA.L D0,A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        ADDQ.L #1,-8272(A6)
        BRA.W LBL_40
LBL_39:
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-8264(A6)
LBL_41:
        MOVE.L A1,-(A7)
        MOVE.L -8264(A6),D0
        MOVE.L D0,-(A7)
        JSR 434(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_38:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 185)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_3:
        LINK A6,#-8296
        LEA LBL_17(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_26
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_42:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 186)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_4:
        LINK A6,#-8296
        LEA LBL_18(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_26
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_43:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 187)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_5:
        LINK A6,#-8296
        LEA LBL_19(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_26
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_44:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 188)
        ;   param idx : 8(A6)  size 4
LBL_6:
        LINK A6,#-8296
        LEA LBL_20(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_26
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_45:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 189)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_7:
        LINK A6,#-8296
        LEA LBL_21(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_26
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_46:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 190)
        ;   param rowsIdx : 8(A6)  size 4
LBL_8:
        LINK A6,#-8296
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_48
        LEA -188(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_47
        BRA.W LBL_49
LBL_48:
        LEA LBL_22(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_26
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_47
LBL_49:
LBL_47:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 191) -- pascal callback glue for aeQuitHandler
LBL_9:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 850(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 192) -- pascal callback glue for aeOappHandler
LBL_10:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 858(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 193) -- pascal callback glue for rtUiScrollbarAction
LBL_11:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1018(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 194) -- pascal callback glue for rtUiLdefDraw
LBL_12:
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
        JSR 1074(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_23:
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
LBL_24:
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
        BPL.W LBL_50
        NEG.L D2
        MOVE.L #1,D4
LBL_50:
        CLR.L D5
        TST.L D3
        BPL.W LBL_51
        NEG.L D3
        MOVE.L #1,D5
LBL_51:
        CLR.L D6
        MOVE.W #31,D7
LBL_52:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_53
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_53:
        DBRA D7,LBL_52
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_54
        NEG.L D2
LBL_54:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_25:
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
        BPL.W LBL_55
        NEG.L D2
        MOVE.L #1,D4
LBL_55:
        CLR.L D5
        TST.L D3
        BPL.W LBL_56
        NEG.L D3
        MOVE.L #1,D5
LBL_56:
        CLR.L D6
        MOVE.W #31,D7
LBL_57:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_58
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_58:
        DBRA D7,LBL_57
        TST.L D4
        BEQ.W LBL_59
        NEG.L D6
LBL_59:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_26:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -188(A5),D0
        MOVE.L D0,-4(A6)
LBL_60:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_13:
        DC.B $01
        DC.B $78
LBL_14:
        DC.B $01
        DC.B $61
LBL_15:
        DC.B $01
        DC.B $62
LBL_16:
        DC.B $01
        DC.B $6B
LBL_17:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_18:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_19:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_20:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_21:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_22:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
