        ; func handler_brs_done  (JT slot 624)
        ;   local __store5 : -4(A6)  size 4
LBL_0:
        LINK A6,#-2620
        LEA -4(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 178(A5)
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -8(A6),D0
        MOVE.L D0,-4(A6)
        LEA -7458(A5),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -4(A6),D0
        MOVE.L D0,-7458(A5)
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -7434(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7446(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVE.L -7458(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7454(A5),D0
        MOVE.L D0,-(A7)
        JSR 3826(A5)
        ADDA.W #20,A7
        TST.L D0
        BEQ.W LBL_61
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -7454(A5),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -1036(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -1036(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
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
        JSR 4810(A5)
        ADDQ.L #4,A7
        BRA.W LBL_62
LBL_61:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 4842(A5)
        MOVE.L D0,-(A7)
        LEA -2060(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -2060(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -1548(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1548(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
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
        LEA -2572(A6),A0
        MOVE.L A0,-(A7)
        JSR 4850(A5)
        ADDQ.L #4,A7
        LEA -2572(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
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
        JSR 4810(A5)
        ADDQ.L #4,A7
LBL_62:
        MOVE.L -7434(A5),D0
        MOVE.L D0,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        MOVEQ #2,D0
        MOVE.L D0,-(A7)
        MOVE.L -7458(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7454(A5),D0
        MOVE.L D0,-(A7)
        JSR 3834(A5)
        ADDA.W #20,A7
        TST.L D0
        BEQ.W LBL_63
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -7454(A5),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -1036(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -1036(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
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
        JSR 4810(A5)
        ADDQ.L #4,A7
        BRA.W LBL_64
LBL_63:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        JSR 4842(A5)
        MOVE.L D0,-(A7)
        LEA -2060(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -2060(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
        LEA -1548(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1548(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
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
        LEA -2572(A6),A0
        MOVE.L A0,-(A7)
        JSR 4850(A5)
        ADDQ.L #4,A7
        LEA -2572(A6),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDA.W #12,A7
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
        JSR 4810(A5)
        ADDQ.L #4,A7
LBL_64:
        MOVE.L -7438(A5),D0
        MOVE.L D0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_44(PC),A0
        MOVE.L A0,-(A7)
        JSR 3674(A5)
        ADDA.W #12,A7
        MOVE.L -7442(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -7446(A5),D0
        MOVE.L D0,-(A7)
        JSR 3930(A5)
        ADDQ.L #8,A7
LBL_60:
        UNLK A6
        RTS
        ; func handler_brs_failed  (JT slot 625)
        ;   param err : 8(A6)  size 4
LBL_1:
        LINK A6,#-2100
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_45(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -2052(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -2052(A6),A0
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
        LEA LBL_37(PC),A0
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
        MOVEA.L 8(A6),A0
        LEA 4(A0),A0
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
        JSR 4810(A5)
        ADDQ.L #4,A7
LBL_65:
        UNLK A6
        RTS
        ; func handler_link_received  (JT slot 626)
        ;   param data : 8(A6)  size 4
LBL_2:
        LINK A6,#-1076
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_46(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        LEA -1028(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -1028(A6),A0
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
        JSR 4810(A5)
        ADDQ.L #4,A7
        MOVE.L -7438(A5),D0
        MOVE.L D0,-(A7)
        JSR 3690(A5)
        ADDQ.L #4,A7
LBL_66:
        UNLK A6
        RTS
        ; func handler_link_failed  (JT slot 627)
        ;   param err : 8(A6)  size 4
LBL_3:
        LINK A6,#-2100
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_47(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -2052(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -2052(A6),A0
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
        LEA LBL_37(PC),A0
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
        MOVEA.L 8(A6),A0
        LEA 4(A0),A0
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
        JSR 4810(A5)
        ADDQ.L #4,A7
        JSR 1682(A5)
LBL_67:
        UNLK A6
        RTS
        ; func handler_direct_failed  (JT slot 628)
        ;   param err : 8(A6)  size 4
LBL_4:
        LINK A6,#-2100
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_48(PC),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        LEA -2052(A6),A0
        MOVE.L A0,-(A7)
        JSR 146(A5)
        ADDQ.L #8,A7
        LEA -2052(A6),A0
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
        LEA LBL_37(PC),A0
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
        MOVEA.L 8(A6),A0
        LEA 4(A0),A0
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
        JSR 4810(A5)
        ADDQ.L #4,A7
LBL_68:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 629)
        ;   param slot : 8(A6)  size 4
LBL_5:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_70
        JSR 5010(A5)
        BRA.W LBL_71
LBL_70:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_72
        BRA.W LBL_73
LBL_72:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_74
        BRA.W LBL_75
LBL_74:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_76
        BRA.W LBL_77
LBL_76:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_78
        BRA.W LBL_79
LBL_78:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_80
        BRA.W LBL_81
LBL_80:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_82
        BRA.W LBL_83
LBL_82:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_84
LBL_84:
LBL_83:
LBL_81:
LBL_79:
LBL_77:
LBL_75:
LBL_73:
LBL_71:
LBL_69:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 630)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_6:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_86
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_2
        ADDQ.L #4,A7
        BRA.W LBL_87
LBL_86:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_88
        BRA.W LBL_89
LBL_88:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_90
        BRA.W LBL_91
LBL_90:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_92
        BRA.W LBL_93
LBL_92:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_94
        BRA.W LBL_95
LBL_94:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_96
        BRA.W LBL_97
LBL_96:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        BRA.W LBL_99
LBL_98:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_100
LBL_100:
LBL_99:
LBL_97:
LBL_95:
LBL_93:
LBL_91:
LBL_89:
LBL_87:
LBL_85:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 631)
        ;   param slot : 8(A6)  size 4
LBL_7:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_102
        JSR 5018(A5)
        BRA.W LBL_103
LBL_102:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_104
        BRA.W LBL_105
LBL_104:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
        BRA.W LBL_107
LBL_106:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_108
        BRA.W LBL_109
LBL_108:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_110
        BRA.W LBL_111
LBL_110:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_112
        BRA.W LBL_113
LBL_112:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_114
        BRA.W LBL_115
LBL_114:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
LBL_116:
LBL_115:
LBL_113:
LBL_111:
LBL_109:
LBL_107:
LBL_105:
LBL_103:
LBL_101:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 632)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
        ;   local err : -260(A6)  size 260
LBL_8:
        LINK A6,#-312
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_118:
        CLR.W (A0)+
        DBRA D0,LBL_118
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_119
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -260(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_3
        ADDQ.L #4,A7
        BRA.W LBL_120
LBL_119:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -260(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_4
        ADDQ.L #4,A7
        BRA.W LBL_122
LBL_121:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_123
        BRA.W LBL_124
LBL_123:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_125
        BRA.W LBL_126
LBL_125:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_127
        BRA.W LBL_128
LBL_127:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_129
        BRA.W LBL_130
LBL_129:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
        BRA.W LBL_132
LBL_131:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
LBL_133:
LBL_132:
LBL_130:
LBL_128:
LBL_126:
LBL_124:
LBL_122:
LBL_120:
LBL_117:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 633)
LBL_9:
        LINK A6,#-52
        JSR 3698(A5)
        JSR 3938(A5)
LBL_134:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 634)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_10:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_136
        BRA.W LBL_137
LBL_136:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_138
LBL_138:
LBL_137:
LBL_135:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 635)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_11:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_140
        BRA.W LBL_141
LBL_140:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_142
LBL_142:
LBL_141:
LBL_139:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 636)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_144
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        MOVE.L A0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 5002(A5)
        ADDQ.L #8,A7
        BRA.W LBL_145
LBL_144:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_146
LBL_146:
LBL_145:
LBL_143:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 637)
        ;   param slot : 8(A6)  size 4
LBL_13:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
        BSR.W LBL_0
        BRA.W LBL_149
LBL_148:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_150
LBL_150:
LBL_149:
LBL_147:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 638)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
        ;   local err : -260(A6)  size 260
LBL_14:
        LINK A6,#-312
        MOVEQ #0,D0
        MOVE.L D0,-260(A6)
        LEA -256(A6),A0
        MOVE.W #127,D0
LBL_152:
        CLR.W (A0)+
        DBRA D0,LBL_152
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_153
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -260(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
        BRA.W LBL_154
LBL_153:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_155
LBL_155:
LBL_154:
LBL_151:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 639)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_15:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_157
        BRA.W LBL_158
LBL_157:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_159
LBL_159:
LBL_158:
LBL_156:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 640)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_16:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
        BRA.W LBL_162
LBL_161:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_163
LBL_163:
LBL_162:
LBL_160:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 641)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_17:
        LINK A6,#-52
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_165
        BRA.W LBL_166
LBL_165:
        LEA LBL_49(PC),A0
        MOVE.L A0,-(A7)
        JSR 4810(A5)
        ADDQ.L #4,A7
        BSR.W LBL_59
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4818(A5)
        ADDQ.L #4,A7
LBL_166:
LBL_164:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 642)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_18:
        LINK A6,#-52
        MOVE.L 28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_168
        BRA.W LBL_169
LBL_168:
        LEA LBL_50(PC),A0
        MOVE.L A0,-(A7)
        JSR 4810(A5)
        ADDQ.L #4,A7
        BSR.W LBL_59
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4818(A5)
        ADDQ.L #4,A7
LBL_169:
LBL_167:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 643)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_19:
        LINK A6,#-52
        LEA LBL_51(PC),A0
        MOVE.L A0,-(A7)
        JSR 4810(A5)
        ADDQ.L #4,A7
        BSR.W LBL_59
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4818(A5)
        ADDQ.L #4,A7
LBL_170:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 644)
        ;   param idx : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        LEA LBL_52(PC),A0
        MOVE.L A0,-(A7)
        JSR 4810(A5)
        ADDQ.L #4,A7
        BSR.W LBL_59
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4818(A5)
        ADDQ.L #4,A7
LBL_171:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 645)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_21:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_173
        BRA.W LBL_174
LBL_173:
        LEA LBL_53(PC),A0
        MOVE.L A0,-(A7)
        JSR 4810(A5)
        ADDQ.L #4,A7
        BSR.W LBL_59
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4818(A5)
        ADDQ.L #4,A7
LBL_174:
LBL_172:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 646)
        ;   param rowsIdx : 8(A6)  size 4
LBL_22:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #156,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_176
        LEA -7108(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_175
        BRA.W LBL_177
LBL_176:
        MOVE.L 8(A6),D1
        MOVE.L #181,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_178
        LEA -7450(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_175
        BRA.W LBL_179
LBL_178:
        LEA LBL_54(PC),A0
        MOVE.L A0,-(A7)
        JSR 4810(A5)
        ADDQ.L #4,A7
        BSR.W LBL_59
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 4818(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_175
LBL_179:
LBL_177:
LBL_175:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 647)
        ;   param path : 8(A6)  size 4
LBL_23:
        LINK A6,#-52
LBL_180:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 648)
LBL_24:
        LINK A6,#-52
LBL_181:
        UNLK A6
        RTS
        ; func clar_ui_fire_logop  (JT slot 649)
        ;   param op : 24(A6)  size 4
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_25:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_182
LBL_182:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 650)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_26:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_183
LBL_183:
        UNLK A6
        RTS
        ; func clar_ui_fire_fmtcell  (JT slot 651)
        ;   param stP : 36(A6)  size 4
        ;   param rec : 32(A6)  size 4
        ;   param recH : 28(A6)  size 4
        ;   param hstate : 24(A6)  size 4
        ;   param layoutOff : 20(A6)  size 4
        ;   param colsOff : 16(A6)  size 4
        ;   param k : 12(A6)  size 4
        ;   param colRect : 8(A6)  size 4
LBL_27:
        LINK A6,#-52
LBL_184:
        UNLK A6
        RTS
        ; func clar_ui_fire_geomapply  (JT slot 652)
LBL_28:
        LINK A6,#-52
LBL_185:
        UNLK A6
        RTS
        ; func clar_ui_fire_fontsinit  (JT slot 653)
        ;   param inst : 8(A6)  size 4
LBL_29:
        LINK A6,#-52
LBL_186:
        UNLK A6
        RTS
        ; func clar_ui_fire_drawlabel  (JT slot 654)
        ;   param instV : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_30:
        LINK A6,#-52
LBL_187:
        UNLK A6
        RTS
        ; func clar_ui_fire_labelsettext  (JT slot 655)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
LBL_31:
        LINK A6,#-52
LBL_188:
        UNLK A6
        RTS
        ; func clar_ui_fire_canvasmetric  (JT slot 656)
        ;   param instV : 16(A6)  size 4
        ;   param wIdx : 12(A6)  size 4
        ;   param prop : 8(A6)  size 4
LBL_32:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_189
LBL_189:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 657) -- pascal callback glue for aeQuitHandler
LBL_33:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1562(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 658) -- pascal callback glue for aeOappHandler
LBL_34:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1570(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 659) -- pascal callback glue for rtUiScrollbarAction
LBL_35:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 2634(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 660) -- pascal callback glue for rtUiLdefDraw
LBL_36:
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
        JSR 2794(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_56:
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
LBL_57:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_190
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_55(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_190:
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
        BPL.W LBL_191
        NEG.L D2
        MOVE.L #1,D4
LBL_191:
        CLR.L D5
        TST.L D3
        BPL.W LBL_192
        NEG.L D3
        MOVE.L #1,D5
LBL_192:
        CLR.L D6
        MOVE.W #31,D7
LBL_193:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_194
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_194:
        DBRA D7,LBL_193
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_195
        NEG.L D2
LBL_195:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_58:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_196
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_55(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_196:
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
        BPL.W LBL_197
        NEG.L D2
        MOVE.L #1,D4
LBL_197:
        CLR.L D5
        TST.L D3
        BPL.W LBL_198
        NEG.L D3
        MOVE.L #1,D5
LBL_198:
        CLR.L D6
        MOVE.W #31,D7
LBL_199:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_200
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_200:
        DBRA D7,LBL_199
        TST.L D4
        BEQ.W LBL_201
        NEG.L D6
LBL_201:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_59:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_202(PC),A0
        MOVE.L A0,-4(A6)
LBL_203:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_204
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_205
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_203
LBL_205:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_206:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 298(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_203
LBL_204:
        UNLK A6
        RTS
LBL_202:
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
        DC.W $E2E6
        DC.W $0001
        DC.W $E2E2
        DC.W $0000
        DC.W $E2DE
        DC.W $0000
        DC.W $0000
        DC.W $0000
        ; constant pool: string literals
LBL_55:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_38:
        DC.B $02
        DC.B $68,$69
        DC.B $00
LBL_39:
        DC.B $08
        DC.B $61,$64,$64,$72,$20,$6F,$6B,$20
        DC.B $00
LBL_40:
        DC.B $09
        DC.B $61,$64,$64,$72,$20,$65,$72,$72,$20
LBL_37:
        DC.B $01
        DC.B $20
LBL_41:
        DC.B $17
        DC.B $43,$6C,$61,$72,$75,$73,$53,$65,$72,$76,$65,$72,$3A,$43,$6C,$61,$72,$75,$73,$54,$65,$73,$74
LBL_42:
        DC.B $08
        DC.B $6E,$61,$6D,$65,$20,$6F,$6B,$20
        DC.B $00
LBL_43:
        DC.B $09
        DC.B $6E,$61,$6D,$65,$20,$65,$72,$72,$20
LBL_44:
        DC.B $17
        DC.B $43,$6C,$61,$72,$75,$73,$53,$74,$72,$65,$61,$6D,$3A,$43,$6C,$61,$72,$75,$73,$54,$65,$73,$74
LBL_45:
        DC.B $0B
        DC.B $62,$72,$73,$20,$66,$61,$69,$6C,$65,$64,$20
LBL_46:
        DC.B $03
        DC.B $72,$78,$20
LBL_47:
        DC.B $0C
        DC.B $6C,$69,$6E,$6B,$20,$66,$61,$69,$6C,$65,$64,$20
        DC.B $00
LBL_48:
        DC.B $0E
        DC.B $64,$69,$72,$65,$63,$74,$20,$66,$61,$69,$6C,$65,$64,$20
        DC.B $00
LBL_49:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_50:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_51:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_52:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_53:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_54:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
