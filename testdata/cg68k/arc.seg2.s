        ; func arcStmtTempRelease  (JT slot 191)
        ;   local l : -4(A6)  size 4
        ;   local m : -8(A6)  size 4
        ;   local x : -12(A6)  size 4
LBL_0:
        LINK A6,#-2128
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
        JSR 426(A5)
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
        LEA LBL_17(PC),A0
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
        LEA LBL_18(PC),A0
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
        LEA LBL_19(PC),A0
        MOVE.L A0,-(A7)
        LEA -20(A6),A0
        MOVE.L A0,-(A7)
        JSR 458(A5)
        ADDA.W #12,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-16(A6)
        LEA LBL_19(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-20(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVE.L -24(A6),D0
        MOVE.L D0,-28(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        LEA -28(A6),A0
        MOVE.L A0,-(A7)
        JSR 474(A5)
        ADDA.W #12,A7
        MOVE.L -28(A6),D0
        MOVE.L D0,-12(A6)
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2084(A6)
        MOVE.L A1,-(A7)
        MOVE.L -2084(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        TST.L D0
        BEQ.W LBL_32
        MOVE.L A1,-(A7)
        MOVE.L -2084(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L D0,-2088(A6)
        CLR.L -2092(A6)
LBL_33:
        MOVE.L -2092(A6),D0
        MOVE.L -2088(A6),D1
        CMP.L D1,D0
        BGE.W LBL_32
        MOVE.L A1,-(A7)
        MOVE.L -2084(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -2092(A6),D0
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
        ADDQ.L #1,-2092(A6)
        BRA.W LBL_33
LBL_32:
        MOVE.L A1,-(A7)
        MOVE.L -2084(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2084(A6)
LBL_34:
        MOVE.L A1,-(A7)
        MOVE.L -2084(A6),D0
        MOVE.L D0,-(A7)
        JSR 442(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_31:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 192)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_1:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_36
        BRA.W LBL_37
LBL_36:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_38
        BRA.W LBL_39
LBL_38:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_40
        BRA.W LBL_41
LBL_40:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_42
LBL_42:
LBL_41:
LBL_39:
LBL_37:
LBL_35:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 193)
        ;   param slot : 8(A6)  size 4
LBL_2:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_44
        BRA.W LBL_45
LBL_44:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_46
        BRA.W LBL_47
LBL_46:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_48
        BRA.W LBL_49
LBL_48:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_50
LBL_50:
LBL_49:
LBL_47:
LBL_45:
LBL_43:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 194)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_3:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_52
        BRA.W LBL_53
LBL_52:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_54
        BRA.W LBL_55
LBL_54:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_56
        BRA.W LBL_57
LBL_56:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_58
LBL_58:
LBL_57:
LBL_55:
LBL_53:
LBL_51:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 195)
LBL_4:
        LINK A6,#-2100
LBL_59:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 196)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_5:
        LINK A6,#-2100
        LEA LBL_20(PC),A0
        MOVE.L A0,-(A7)
        JSR 1354(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #4,A7
LBL_60:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 197)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_6:
        LINK A6,#-2100
        LEA LBL_21(PC),A0
        MOVE.L A0,-(A7)
        JSR 1354(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #4,A7
LBL_61:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 198)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_7:
        LINK A6,#-2100
        LEA LBL_22(PC),A0
        MOVE.L A0,-(A7)
        JSR 1354(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #4,A7
LBL_62:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 199)
        ;   param idx : 8(A6)  size 4
LBL_8:
        LINK A6,#-2100
        LEA LBL_23(PC),A0
        MOVE.L A0,-(A7)
        JSR 1354(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #4,A7
LBL_63:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 200)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_9:
        LINK A6,#-2100
        LEA LBL_24(PC),A0
        MOVE.L A0,-(A7)
        JSR 1354(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #4,A7
LBL_64:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 201)
        ;   param rowsIdx : 8(A6)  size 4
LBL_10:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #65,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_66
        LEA -1304(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_65
        BRA.W LBL_67
LBL_66:
        LEA LBL_25(PC),A0
        MOVE.L A0,-(A7)
        JSR 1354(A5)
        ADDQ.L #4,A7
        BSR.W LBL_30
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1362(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_65
LBL_67:
LBL_65:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 202)
        ;   param path : 8(A6)  size 4
LBL_11:
        LINK A6,#-2100
LBL_68:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 203)
LBL_12:
        LINK A6,#-2100
LBL_69:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 204) -- pascal callback glue for aeQuitHandler
LBL_13:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 874(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 205) -- pascal callback glue for aeOappHandler
LBL_14:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 882(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 206) -- pascal callback glue for rtUiScrollbarAction
LBL_15:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1058(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 207) -- pascal callback glue for rtUiLdefDraw
LBL_16:
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
        JSR 1122(A5)
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
        BNE.W LBL_70
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_26(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_70:
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
        BPL.W LBL_71
        NEG.L D2
        MOVE.L #1,D4
LBL_71:
        CLR.L D5
        TST.L D3
        BPL.W LBL_72
        NEG.L D3
        MOVE.L #1,D5
LBL_72:
        CLR.L D6
        MOVE.W #31,D7
LBL_73:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_74
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_74:
        DBRA D7,LBL_73
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_75
        NEG.L D2
LBL_75:
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
        BNE.W LBL_76
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_26(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_76:
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
        BPL.W LBL_77
        NEG.L D2
        MOVE.L #1,D4
LBL_77:
        CLR.L D5
        TST.L D3
        BPL.W LBL_78
        NEG.L D3
        MOVE.L #1,D5
LBL_78:
        CLR.L D6
        MOVE.W #31,D7
LBL_79:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_80
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_80:
        DBRA D7,LBL_79
        TST.L D4
        BEQ.W LBL_81
        NEG.L D6
LBL_81:
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
        LINK A6,#-48
        MOVE.L -1304(A5),D0
        MOVE.L D0,-4(A6)
LBL_82:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_26:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_17:
        DC.B $01
        DC.B $61
LBL_18:
        DC.B $01
        DC.B $62
LBL_19:
        DC.B $01
        DC.B $6B
LBL_20:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_21:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_22:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_23:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_24:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_25:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
