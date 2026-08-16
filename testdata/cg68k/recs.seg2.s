        ; func handler_App_launch  (JT slot 172)
        ;   local p : -76(A6)  size 76
        ;   local __store4 : -152(A6)  size 76
        ;   local q : -228(A6)  size 76
        ;   local b1 : -264(A6)  size 36
        ;   local b2 : -300(A6)  size 36
        ;   local total : -304(A6)  size 4
        ;   local o1 : -320(A6)  size 16
        ;   local o2 : -336(A6)  size 16
        ;   local __store5 : -412(A6)  size 76
        ;   local __store6 : -448(A6)  size 36
        ;   local __store7 : -484(A6)  size 36
        ;   local __store8 : -500(A6)  size 16
LBL_0:
        LINK A6,#-8796
        LEA -76(A6),A0
        MOVE.W #15,D0
LBL_31:
        CLR.W (A0)+
        DBRA D0,LBL_31
        MOVEQ #18,D0
        MOVE.L D0,-44(A6)
        MOVEQ #5,D0
        MOVE.L D0,-40(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_32:
        CLR.W (A0)+
        DBRA D0,LBL_32
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -152(A6),A0
        MOVE.W #37,D0
LBL_33:
        CLR.W (A0)+
        DBRA D0,LBL_33
        LEA -228(A6),A0
        MOVE.W #15,D0
LBL_34:
        CLR.W (A0)+
        DBRA D0,LBL_34
        MOVEQ #18,D0
        MOVE.L D0,-196(A6)
        MOVEQ #5,D0
        MOVE.L D0,-192(A6)
        LEA -188(A6),A0
        MOVE.W #15,D0
LBL_35:
        CLR.W (A0)+
        DBRA D0,LBL_35
        MOVEQ #0,D0
        MOVE.L D0,-156(A6)
        LEA -264(A6),A0
        MOVE.W #15,D0
LBL_36:
        CLR.W (A0)+
        DBRA D0,LBL_36
        LEA -232(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -300(A6),A0
        MOVE.W #15,D0
LBL_37:
        CLR.W (A0)+
        DBRA D0,LBL_37
        LEA -268(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-304(A6)
        MOVEQ #0,D0
        MOVE.L D0,-320(A6)
        MOVEQ #0,D0
        MOVE.L D0,-316(A6)
        LEA -312(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -308(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-336(A6)
        MOVEQ #0,D0
        MOVE.L D0,-332(A6)
        LEA -328(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -324(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -412(A6),A0
        MOVE.W #37,D0
LBL_38:
        CLR.W (A0)+
        DBRA D0,LBL_38
        LEA -448(A6),A0
        MOVE.W #17,D0
LBL_39:
        CLR.W (A0)+
        DBRA D0,LBL_39
        LEA -484(A6),A0
        MOVE.W #17,D0
LBL_40:
        CLR.W (A0)+
        DBRA D0,LBL_40
        LEA -500(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -152(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -152(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_41:
        CLR.W (A0)+
        DBRA D0,LBL_41
        MOVEA.L A1,A0
        MOVEQ #18,D0
        MOVE.L D0,32(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.L D0,36(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 40(A0),A0
        MOVE.W #15,D0
LBL_42:
        CLR.W (A0)+
        DBRA D0,LBL_42
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,72(A0)
        LEA -152(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -76(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -152(A6),A0
        MOVE.L A0,-(A7)
        LEA -76(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_43:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_43
        LEA -76(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_10(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -76(A6),A0
        LEA 40(A0),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_11(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVE.L #90210,D0
        MOVE.L D0,-(A7)
        LEA -76(A6),A0
        LEA 40(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -412(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -76(A6),A0
        MOVE.L A0,-(A7)
        LEA -412(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_44:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_44
        LEA -412(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_18
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -228(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -412(A6),A0
        MOVE.L A0,-(A7)
        LEA -228(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #37,D0
LBL_45:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_45
        MOVEQ #99,D0
        MOVE.L D0,-(A7)
        LEA -228(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #11111,D0
        MOVE.L D0,-(A7)
        LEA -228(A6),A0
        LEA 40(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -1068(A6),A0
        MOVE.L A0,-(A7)
        JSR 1330(A5)
        ADDQ.L #8,A7
        LEA -1068(A6),A0
        MOVE.L A0,-(A7)
        JSR 1338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        MOVE.L A1,-(A7)
        LEA -1068(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L (A7)+,D1
        MOVE.L (A7)+,D0
        MOVE.L D0,-304(A6)
        LEA -1068(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_46:
        CLR.W (A0)+
        DBRA D0,LBL_46
        MOVEA.L A1,A0
        MOVEQ #18,D0
        MOVE.L D0,32(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.L D0,36(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 40(A0),A0
        MOVE.W #15,D0
LBL_47:
        CLR.W (A0)+
        DBRA D0,LBL_47
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,72(A0)
        LEA -1068(A6),A0
        MOVE.L A0,-(A7)
        JSR 1338(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        MOVE.L A1,-(A7)
        LEA -1068(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L (A7)+,D1
        MOVE.L (A7)+,D0
        MOVE.L D0,-304(A6)
        LEA -448(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -1068(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_12(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -1068(A6),A0
        MOVE.L A0,-(A7)
        LEA -448(A6),A0
        MOVE.L A0,-(A7)
        JSR 1346(A5)
        ADDQ.L #8,A7
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -448(A6),A0
        MOVE.L A0,-(A7)
        LEA -264(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_48:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_48
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -448(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -484(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        LEA -484(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_49:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_49
        LEA -484(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_20
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -300(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -484(A6),A0
        MOVE.L A0,-(A7)
        LEA -300(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_50:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_50
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -484(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -500(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -320(A6),A0
        MOVE.L A0,-(A7)
        LEA -500(A6),A0
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
        LEA -500(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_24
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -336(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -500(A6),A0
        MOVE.L A0,-(A7)
        LEA -336(A6),A0
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
        LEA -500(A6),A0
        LEA 4(A0),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -500(A6),A0
        LEA 12(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -76(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -228(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_19
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -264(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -300(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_21
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -320(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -336(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_30:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 173)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_1:
        LINK A6,#-8296
        LEA LBL_13(PC),A0
        MOVE.L A0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        BSR.W LBL_29
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1162(A5)
        ADDQ.L #4,A7
LBL_51:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 174)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_2:
        LINK A6,#-8296
        LEA LBL_14(PC),A0
        MOVE.L A0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        BSR.W LBL_29
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1162(A5)
        ADDQ.L #4,A7
LBL_52:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 175)
        ;   param idx : 8(A6)  size 4
LBL_3:
        LINK A6,#-8296
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        BSR.W LBL_29
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1162(A5)
        ADDQ.L #4,A7
LBL_53:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 176)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_4:
        LINK A6,#-8296
        LEA LBL_16(PC),A0
        MOVE.L A0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        BSR.W LBL_29
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1162(A5)
        ADDQ.L #4,A7
LBL_54:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 177)
        ;   param rowsIdx : 8(A6)  size 4
LBL_5:
        LINK A6,#-8296
        MOVE.L 8(A6),D1
        MOVEQ #61,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_56
        LEA -1292(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_55
        BRA.W LBL_57
LBL_56:
        LEA LBL_17(PC),A0
        MOVE.L A0,-(A7)
        JSR 1154(A5)
        ADDQ.L #4,A7
        BSR.W LBL_29
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1162(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_55
LBL_57:
LBL_55:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 178) -- pascal callback glue for aeQuitHandler
LBL_6:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 666(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 179) -- pascal callback glue for aeOappHandler
LBL_7:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 674(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 180) -- pascal callback glue for rtUiScrollbarAction
LBL_8:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 834(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 181) -- pascal callback glue for rtUiLdefDraw
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
        JSR 890(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_26:
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
LBL_27:
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
        BPL.W LBL_58
        NEG.L D2
        MOVE.L #1,D4
LBL_58:
        CLR.L D5
        TST.L D3
        BPL.W LBL_59
        NEG.L D3
        MOVE.L #1,D5
LBL_59:
        CLR.L D6
        MOVE.W #31,D7
LBL_60:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_61
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_61:
        DBRA D7,LBL_60
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_62
        NEG.L D2
LBL_62:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_28:
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
        BPL.W LBL_63
        NEG.L D2
        MOVE.L #1,D4
LBL_63:
        CLR.L D5
        TST.L D3
        BPL.W LBL_64
        NEG.L D3
        MOVE.L #1,D5
LBL_64:
        CLR.L D6
        MOVE.W #31,D7
LBL_65:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_66
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_66:
        DBRA D7,LBL_65
        TST.L D4
        BEQ.W LBL_67
        NEG.L D6
LBL_67:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_29:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -1292(A5),D0
        MOVE.L D0,-4(A6)
LBL_68:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_18:
        ; cg_retain_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_19:
        ; cg_release_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_20:
        ; cg_retain_recsBox(rec ptr at 8(A6))
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
LBL_21:
        ; cg_release_recsBox(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 32(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_22:
        ; cg_retain_recsInner(rec ptr at 8(A6))
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
LBL_23:
        ; cg_release_recsInner(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        MOVE.L 4(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_24:
        ; cg_retain_recsOuter(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_22
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
LBL_25:
        ; cg_release_recsOuter(rec ptr at 8(A6))
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
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
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
