        ; func clar_svc_fire_request  (JT slot 194)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_0:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_27
        BRA.W LBL_28
LBL_27:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_29
LBL_29:
LBL_28:
LBL_26:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 195)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_1:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_31
        BRA.W LBL_32
LBL_31:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_33
LBL_33:
LBL_32:
LBL_30:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 196)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_2:
        LINK A6,#-52
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        BSR.W LBL_25
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_34:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 197)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_3:
        LINK A6,#-52
        LEA LBL_16(PC),A0
        MOVE.L A0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        BSR.W LBL_25
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_35:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 198)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_4:
        LINK A6,#-52
        LEA LBL_17(PC),A0
        MOVE.L A0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        BSR.W LBL_25
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_36:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 199)
        ;   param idx : 8(A6)  size 4
LBL_5:
        LINK A6,#-52
        LEA LBL_18(PC),A0
        MOVE.L A0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        BSR.W LBL_25
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_37:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 200)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_6:
        LINK A6,#-52
        LEA LBL_19(PC),A0
        MOVE.L A0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        BSR.W LBL_25
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_38:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 201)
        ;   param rowsIdx : 8(A6)  size 4
LBL_7:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #153,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_40
        LEA -7096(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_39
        BRA.W LBL_41
LBL_40:
        LEA LBL_20(PC),A0
        MOVE.L A0,-(A7)
        JSR 1282(A5)
        ADDQ.L #4,A7
        BSR.W LBL_25
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_39
LBL_41:
LBL_39:
        UNLK A6
        RTS
        ; func clar_ui_fire_logop  (JT slot 202)
        ;   param op : 24(A6)  size 4
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_8:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_42
LBL_42:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 203)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_43
LBL_43:
        UNLK A6
        RTS
        ; func clar_ui_fire_geomapply  (JT slot 204)
LBL_10:
        LINK A6,#-52
LBL_44:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 205) -- pascal callback glue for aeQuitHandler
LBL_11:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 722(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 206) -- pascal callback glue for aeOappHandler
LBL_12:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 730(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 207) -- pascal callback glue for rtUiScrollbarAction
LBL_13:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 906(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 208) -- pascal callback glue for rtUiLdefDraw
LBL_14:
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
        JSR 978(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_22:
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
LBL_23:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_45
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_21(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_45:
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
        BPL.W LBL_46
        NEG.L D2
        MOVE.L #1,D4
LBL_46:
        CLR.L D5
        TST.L D3
        BPL.W LBL_47
        NEG.L D3
        MOVE.L #1,D5
LBL_47:
        CLR.L D6
        MOVE.W #31,D7
LBL_48:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_49
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_49:
        DBRA D7,LBL_48
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_50
        NEG.L D2
LBL_50:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_24:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_51
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_21(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_51:
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
        BPL.W LBL_52
        NEG.L D2
        MOVE.L #1,D4
LBL_52:
        CLR.L D5
        TST.L D3
        BPL.W LBL_53
        NEG.L D3
        MOVE.L #1,D5
LBL_53:
        CLR.L D6
        MOVE.W #31,D7
LBL_54:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_55
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_55:
        DBRA D7,LBL_54
        TST.L D4
        BEQ.W LBL_56
        NEG.L D6
LBL_56:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_25:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_57(PC),A0
        MOVE.L A0,-4(A6)
LBL_58:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_59
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_60
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_58
LBL_60:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_61:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_58
LBL_59:
        UNLK A6
        RTS
LBL_57:
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
        ; constant pool: string literals
LBL_21:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_15:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_16:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_17:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_18:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_19:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_20:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
