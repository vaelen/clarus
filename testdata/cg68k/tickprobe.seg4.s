        ; func clar_ui_fire_menu  (JT slot 409)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_0:
        LINK A6,#-8296
        LEA LBL_8(PC),A0
        MOVE.L A0,-(A7)
        JSR 3098(A5)
        ADDQ.L #4,A7
        BSR.W LBL_15
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3106(A5)
        ADDQ.L #4,A7
LBL_16:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 410)
        ;   param idx : 8(A6)  size 4
LBL_1:
        LINK A6,#-8296
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_18
        JSR 3282(A5)
        BRA.W LBL_19
LBL_18:
        LEA LBL_9(PC),A0
        MOVE.L A0,-(A7)
        JSR 3098(A5)
        ADDQ.L #4,A7
        BSR.W LBL_15
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3106(A5)
        ADDQ.L #4,A7
LBL_19:
LBL_17:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 411)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_2:
        LINK A6,#-8296
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_21
        BRA.W LBL_22
LBL_21:
        LEA LBL_10(PC),A0
        MOVE.L A0,-(A7)
        JSR 3098(A5)
        ADDQ.L #4,A7
        BSR.W LBL_15
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3106(A5)
        ADDQ.L #4,A7
LBL_22:
LBL_20:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 412)
        ;   param rowsIdx : 8(A6)  size 4
LBL_3:
        LINK A6,#-8296
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_24
        LEA -188(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_23
        BRA.W LBL_25
LBL_24:
        LEA LBL_11(PC),A0
        MOVE.L A0,-(A7)
        JSR 3098(A5)
        ADDQ.L #4,A7
        BSR.W LBL_15
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3106(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_23
LBL_25:
LBL_23:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 413) -- pascal callback glue for aeQuitHandler
LBL_4:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1306(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 414) -- pascal callback glue for aeOappHandler
LBL_5:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1314(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 415) -- pascal callback glue for rtUiScrollbarAction
LBL_6:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 2146(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 416) -- pascal callback glue for rtUiLdefDraw
LBL_7:
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
        JSR 2290(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_12:
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
LBL_13:
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
        BPL.W LBL_26
        NEG.L D2
        MOVE.L #1,D4
LBL_26:
        CLR.L D5
        TST.L D3
        BPL.W LBL_27
        NEG.L D3
        MOVE.L #1,D5
LBL_27:
        CLR.L D6
        MOVE.W #31,D7
LBL_28:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_29
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_29:
        DBRA D7,LBL_28
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_30
        NEG.L D2
LBL_30:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_14:
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
        BPL.W LBL_31
        NEG.L D2
        MOVE.L #1,D4
LBL_31:
        CLR.L D5
        TST.L D3
        BPL.W LBL_32
        NEG.L D3
        MOVE.L #1,D5
LBL_32:
        CLR.L D6
        MOVE.W #31,D7
LBL_33:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_34
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_34:
        DBRA D7,LBL_33
        TST.L D4
        BEQ.W LBL_35
        NEG.L D6
LBL_35:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_15:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -188(A5),D0
        MOVE.L D0,-4(A6)
LBL_36:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_8:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_9:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_10:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_11:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
