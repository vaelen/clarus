        ; func handler_App_launch  (JT slot 202)
        ;   local p : -74(A6)  size 74
        ;   local __store7 : -148(A6)  size 74
        ;   local q : -222(A6)  size 74
        ;   local b1 : -258(A6)  size 36
        ;   local b2 : -294(A6)  size 36
        ;   local total : -298(A6)  size 4
        ;   local o1 : -314(A6)  size 16
        ;   local o2 : -330(A6)  size 16
        ;   local __store8 : -404(A6)  size 74
        ;   local __store9 : -440(A6)  size 36
        ;   local __store10 : -476(A6)  size 36
        ;   local __store11 : -492(A6)  size 16
LBL_0:
        LINK A6,#-1056
        LEA -74(A6),A0
        MOVE.W #15,D0
LBL_32:
        CLR.W (A0)+
        DBRA D0,LBL_32
        MOVEQ #18,D0
        MOVE.L D0,-42(A6)
        MOVEQ #5,D0
        MOVE.W D0,-38(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_33:
        CLR.W (A0)+
        DBRA D0,LBL_33
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -148(A6),A0
        MOVE.W #36,D0
LBL_34:
        CLR.W (A0)+
        DBRA D0,LBL_34
        LEA -222(A6),A0
        MOVE.W #15,D0
LBL_35:
        CLR.W (A0)+
        DBRA D0,LBL_35
        MOVEQ #18,D0
        MOVE.L D0,-190(A6)
        MOVEQ #5,D0
        MOVE.W D0,-186(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_36:
        CLR.W (A0)+
        DBRA D0,LBL_36
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        LEA -258(A6),A0
        MOVE.W #15,D0
LBL_37:
        CLR.W (A0)+
        DBRA D0,LBL_37
        LEA -226(A6),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -294(A6),A0
        MOVE.W #15,D0
LBL_38:
        CLR.W (A0)+
        DBRA D0,LBL_38
        LEA -262(A6),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-298(A6)
        MOVEQ #0,D0
        MOVE.L D0,-314(A6)
        MOVEQ #0,D0
        MOVE.L D0,-310(A6)
        LEA -306(A6),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -302(A6),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-330(A6)
        MOVEQ #0,D0
        MOVE.L D0,-326(A6)
        LEA -322(A6),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -318(A6),A0
        MOVE.L A0,-(A7)
        JSR 122(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -404(A6),A0
        MOVE.W #36,D0
LBL_39:
        CLR.W (A0)+
        DBRA D0,LBL_39
        LEA -440(A6),A0
        MOVE.W #17,D0
LBL_40:
        CLR.W (A0)+
        DBRA D0,LBL_40
        LEA -476(A6),A0
        MOVE.W #17,D0
LBL_41:
        CLR.W (A0)+
        DBRA D0,LBL_41
        LEA -492(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_42:
        CLR.W (A0)+
        DBRA D0,LBL_42
        MOVEA.L A1,A0
        MOVEQ #18,D0
        MOVE.L D0,32(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.W D0,36(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 38(A0),A0
        MOVE.W #15,D0
LBL_43:
        CLR.W (A0)+
        DBRA D0,LBL_43
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVE.L A0,-(A7)
        LEA -74(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_44:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_44
        LEA -74(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_10(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -74(A6),A0
        LEA 38(A0),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_11(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L #90210,D0
        MOVE.L D0,-(A7)
        LEA -74(A6),A0
        LEA 38(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -404(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A0,-(A7)
        LEA -404(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_45:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_45
        LEA -404(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -404(A6),A0
        MOVE.L A0,-(A7)
        LEA -222(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_46:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_46
        MOVEQ #99,D0
        MOVE.L D0,-(A7)
        LEA -222(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #11111,D0
        MOVE.L D0,-(A7)
        LEA -222(A6),A0
        LEA 38(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        JSR 1482(A5)
        ADDQ.L #8,A7
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-298(A6)
        MOVE.L A1,-(A7)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -1008(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_47:
        CLR.W (A0)+
        DBRA D0,LBL_47
        MOVEA.L A1,A0
        MOVEQ #18,D0
        MOVE.L D0,32(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.W D0,36(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 38(A0),A0
        MOVE.W #15,D0
LBL_48:
        CLR.W (A0)+
        DBRA D0,LBL_48
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        JSR 1490(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        MOVE.L A1,-(A7)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L (A7)+,D1
        MOVE.L (A7)+,D0
        MOVE.L D0,-298(A6)
        LEA -440(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_12(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        LEA -440(A6),A0
        MOVE.L A0,-(A7)
        JSR 1498(A5)
        ADDQ.L #8,A7
        LEA -258(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -440(A6),A0
        MOVE.L A0,-(A7)
        LEA -258(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_49:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_49
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -440(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -476(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -258(A6),A0
        MOVE.L A0,-(A7)
        LEA -476(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_50:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_50
        LEA -476(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -294(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -476(A6),A0
        MOVE.L A0,-(A7)
        LEA -294(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_51:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_51
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -476(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -492(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -314(A6),A0
        MOVE.L A0,-(A7)
        LEA -492(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        LEA -492(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -330(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -492(A6),A0
        MOVE.L A0,-(A7)
        LEA -330(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -492(A6),A0
        LEA 4(A0),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -492(A6),A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -258(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -294(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_22
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -314(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -330(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_31:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 203)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_1:
        LINK A6,#-52
        LEA LBL_13(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_52:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 204)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_2:
        LINK A6,#-52
        LEA LBL_14(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_53:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 205)
        ;   param idx : 8(A6)  size 4
LBL_3:
        LINK A6,#-52
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_54:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 206)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_4:
        LINK A6,#-52
        LEA LBL_16(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_55:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 207)
        ;   param rowsIdx : 8(A6)  size 4
LBL_5:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #153,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_57
        LEA -7096(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_56
        BRA.W LBL_58
LBL_57:
        LEA LBL_17(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_56
LBL_58:
LBL_56:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 208) -- pascal callback glue for aeQuitHandler
LBL_6:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 706(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 209) -- pascal callback glue for aeOappHandler
LBL_7:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 714(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 210) -- pascal callback glue for rtUiScrollbarAction
LBL_8:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 922(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 211) -- pascal callback glue for rtUiLdefDraw
LBL_9:
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
        JSR 994(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_27:
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
LBL_28:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_59
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_18(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_59:
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
        BPL.W LBL_60
        NEG.L D2
        MOVE.L #1,D4
LBL_60:
        CLR.L D5
        TST.L D3
        BPL.W LBL_61
        NEG.L D3
        MOVE.L #1,D5
LBL_61:
        CLR.L D6
        MOVE.W #31,D7
LBL_62:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_63
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_63:
        DBRA D7,LBL_62
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_64
        NEG.L D2
LBL_64:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_29:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_65
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_18(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_65:
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
        BPL.W LBL_66
        NEG.L D2
        MOVE.L #1,D4
LBL_66:
        CLR.L D5
        TST.L D3
        BPL.W LBL_67
        NEG.L D3
        MOVE.L #1,D5
LBL_67:
        CLR.L D6
        MOVE.W #31,D7
LBL_68:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_69
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_69:
        DBRA D7,LBL_68
        TST.L D4
        BEQ.W LBL_70
        NEG.L D6
LBL_70:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_30:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_71(PC),A0
        MOVE.L A0,-4(A6)
LBL_72:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_73
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_74
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_72
LBL_74:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_75:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_72
LBL_73:
        UNLK A6
        RTS
LBL_71:
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
        DC.W $E61E
        DC.W $0000
        DC.W $E622
        DC.W $0000
        DC.W $E448
        DC.W $0001
        DC.W $0000
        DC.W $0000
LBL_19:
        ; cg_retain_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_20:
        ; cg_release_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_21:
        ; cg_retain_recsBox(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 32(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_22:
        ; cg_release_recsBox(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 32(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_23:
        ; cg_retain_recsInner(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 4(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_24:
        ; cg_release_recsInner(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 4(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_25:
        ; cg_retain_recsOuter(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_23
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 12(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_26:
        ; cg_release_recsOuter(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 12(A0),D0
        MOVE.L D0,-(A7)
        JSR 138(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_18:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_10:
        DC.B $08
        DC.B $4F,$72,$69,$67,$69,$6E,$61,$6C
        DC.B $00
LBL_11:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_12:
        DC.B $05
        DC.B $66,$69,$72,$73,$74
LBL_13:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_14:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_15:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_16:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_17:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
