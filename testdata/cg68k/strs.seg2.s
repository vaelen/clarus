        ; func clar_conn_fire_closed  (JT slot 173)
        ;   param slot : 8(A6)  size 4
LBL_0:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_22
        BRA.W LBL_23
LBL_22:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_24
        BRA.W LBL_25
LBL_24:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_26
        BRA.W LBL_27
LBL_26:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_28
LBL_28:
LBL_27:
LBL_25:
LBL_23:
LBL_21:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 174)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
        ;   local err : -260(A6)  size 260
LBL_1:
        LINK A6,#-2456
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_30:
        CLR.W (A0)+
        DBRA D0,LBL_30
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
        BRA.W LBL_34
LBL_33:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_35
        BRA.W LBL_36
LBL_35:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_37
LBL_37:
LBL_36:
LBL_34:
LBL_32:
LBL_29:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 175)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_2:
        LINK A6,#-2196
        LEA LBL_11(PC),A0
        MOVE.L A0,-(A7)
        JSR 1178(A5)
        ADDQ.L #4,A7
        BSR.W LBL_20
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
LBL_38:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 176)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_3:
        LINK A6,#-2196
        LEA LBL_12(PC),A0
        MOVE.L A0,-(A7)
        JSR 1178(A5)
        ADDQ.L #4,A7
        BSR.W LBL_20
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
LBL_39:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 177)
        ;   param idx : 8(A6)  size 4
LBL_4:
        LINK A6,#-2196
        LEA LBL_13(PC),A0
        MOVE.L A0,-(A7)
        JSR 1178(A5)
        ADDQ.L #4,A7
        BSR.W LBL_20
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
LBL_40:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 178)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_5:
        LINK A6,#-2196
        LEA LBL_14(PC),A0
        MOVE.L A0,-(A7)
        JSR 1178(A5)
        ADDQ.L #4,A7
        BSR.W LBL_20
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
LBL_41:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 179)
        ;   param rowsIdx : 8(A6)  size 4
LBL_6:
        LINK A6,#-2196
        MOVE.L 8(A6),D1
        MOVEQ #64,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_43
        LEA -1300(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_42
        BRA.W LBL_44
LBL_43:
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 1178(A5)
        ADDQ.L #4,A7
        BSR.W LBL_20
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1186(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_42
LBL_44:
LBL_42:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 180) -- pascal callback glue for aeQuitHandler
LBL_7:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 682(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 181) -- pascal callback glue for aeOappHandler
LBL_8:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 690(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 182) -- pascal callback glue for rtUiScrollbarAction
LBL_9:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 850(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 183) -- pascal callback glue for rtUiLdefDraw
LBL_10:
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
        JSR 906(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_17:
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
LBL_18:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_45
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_16(PC),A0
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
LBL_19:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_51
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_16(PC),A0
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
LBL_20:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -1300(A5),D0
        MOVE.L D0,-4(A6)
LBL_57:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_16:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_11:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_12:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_13:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_14:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_15:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
