        ; func clar_ui_fire_staterows  (JT slot 406)
        ;   param rowsIdx : 8(A6)  size 4
LBL_0:
        LINK A6,#-8296
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_7
        LEA -4(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_8
LBL_7:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_9
        LEA -8(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_10
LBL_9:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_11
        LEA -12(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_12
LBL_11:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_13
        LEA -16(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_14
LBL_13:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_15
        LEA -18(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_16
LBL_15:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_17
        LEA -22(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_18
LBL_17:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_19
        LEA -26(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_20
LBL_19:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_21
        LEA -30(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_22
LBL_21:
        MOVE.L 8(A6),D1
        MOVEQ #8,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_23
        LEA -34(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_24
LBL_23:
        MOVE.L 8(A6),D1
        MOVEQ #9,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_25
        LEA -38(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_26
LBL_25:
        MOVE.L 8(A6),D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_27
        LEA -40(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_28
LBL_27:
        MOVE.L 8(A6),D1
        MOVEQ #11,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_29
        LEA -42(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_30
LBL_29:
        MOVE.L 8(A6),D1
        MOVEQ #12,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_31
        LEA -46(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_32
LBL_31:
        MOVE.L 8(A6),D1
        MOVEQ #13,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_33
        LEA -50(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_34
LBL_33:
        MOVE.L 8(A6),D1
        MOVEQ #14,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_35
        LEA -54(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_36
LBL_35:
        MOVE.L 8(A6),D1
        MOVEQ #15,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_37
        LEA -58(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_38
LBL_37:
        MOVE.L 8(A6),D1
        MOVEQ #16,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_39
        LEA -62(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_40
LBL_39:
        MOVE.L 8(A6),D1
        MOVEQ #17,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_41
        LEA -66(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_42
LBL_41:
        MOVE.L 8(A6),D1
        MOVEQ #18,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_43
        LEA -70(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_44
LBL_43:
        MOVE.L 8(A6),D1
        MOVEQ #19,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_45
        LEA -74(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_46
LBL_45:
        MOVE.L 8(A6),D1
        MOVEQ #20,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_47
        LEA -76(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_48
LBL_47:
        MOVE.L 8(A6),D1
        MOVEQ #21,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_49
        LEA -78(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_50
LBL_49:
        MOVE.L 8(A6),D1
        MOVEQ #22,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_51
        LEA -82(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_52
LBL_51:
        MOVE.L 8(A6),D1
        MOVEQ #23,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_53
        LEA -84(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_54
LBL_53:
        MOVE.L 8(A6),D1
        MOVEQ #24,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_55
        LEA -88(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_56
LBL_55:
        MOVE.L 8(A6),D1
        MOVEQ #25,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_57
        LEA -92(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_58
LBL_57:
        MOVE.L 8(A6),D1
        MOVEQ #26,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_59
        LEA -96(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_60
LBL_59:
        MOVE.L 8(A6),D1
        MOVEQ #27,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_61
        LEA -100(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_62
LBL_61:
        MOVE.L 8(A6),D1
        MOVEQ #28,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_63
        LEA -104(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_64
LBL_63:
        MOVE.L 8(A6),D1
        MOVEQ #29,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_65
        LEA -108(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_66
LBL_65:
        MOVE.L 8(A6),D1
        MOVEQ #30,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_67
        LEA -110(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_68
LBL_67:
        MOVE.L 8(A6),D1
        MOVEQ #31,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_69
        LEA -114(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_70
LBL_69:
        MOVE.L 8(A6),D1
        MOVEQ #32,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_71
        LEA -118(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_72
LBL_71:
        MOVE.L 8(A6),D1
        MOVEQ #33,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_73
        LEA -122(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_74
LBL_73:
        MOVE.L 8(A6),D1
        MOVEQ #34,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_75
        LEA -124(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_76
LBL_75:
        MOVE.L 8(A6),D1
        MOVEQ #35,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_77
        LEA -128(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_78
LBL_77:
        MOVE.L 8(A6),D1
        MOVEQ #36,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_79
        LEA -132(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_80
LBL_79:
        MOVE.L 8(A6),D1
        MOVEQ #37,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_81
        LEA -136(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_82
LBL_81:
        MOVE.L 8(A6),D1
        MOVEQ #38,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_83
        LEA -140(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_84
LBL_83:
        MOVE.L 8(A6),D1
        MOVEQ #39,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_85
        LEA -144(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_86
LBL_85:
        MOVE.L 8(A6),D1
        MOVEQ #40,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_87
        LEA -148(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_88
LBL_87:
        MOVE.L 8(A6),D1
        MOVEQ #41,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_89
        LEA -152(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_90
LBL_89:
        MOVE.L 8(A6),D1
        MOVEQ #42,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_91
        LEA -156(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_92
LBL_91:
        MOVE.L 8(A6),D1
        MOVEQ #43,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_93
        LEA -160(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_94
LBL_93:
        MOVE.L 8(A6),D1
        MOVEQ #44,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_95
        LEA -164(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_96
LBL_95:
        MOVE.L 8(A6),D1
        MOVEQ #45,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_97
        LEA -168(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_98
LBL_97:
        MOVE.L 8(A6),D1
        MOVEQ #46,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_99
        LEA -172(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_100
LBL_99:
        MOVE.L 8(A6),D1
        MOVEQ #47,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_101
        LEA -174(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_102
LBL_101:
        MOVE.L 8(A6),D1
        MOVEQ #48,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_103
        LEA -176(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_104
LBL_103:
        MOVE.L 8(A6),D1
        MOVEQ #49,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_105
        LEA -180(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_106
LBL_105:
        MOVE.L 8(A6),D1
        MOVEQ #50,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        LEA -184(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_108
LBL_107:
        MOVE.L 8(A6),D1
        MOVEQ #51,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_109
        LEA -440(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_110
LBL_109:
        MOVE.L 8(A6),D1
        MOVEQ #52,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_111
        LEA -444(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_112
LBL_111:
        MOVE.L 8(A6),D1
        MOVEQ #53,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_113
        LEA -446(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_114
LBL_113:
        MOVE.L 8(A6),D1
        MOVEQ #54,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_115
        LEA -450(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_116
LBL_115:
        MOVE.L 8(A6),D1
        MOVEQ #55,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_117
        LEA -452(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_118
LBL_117:
        MOVE.L 8(A6),D1
        MOVEQ #56,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_119
        LEA -456(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_6
        BRA.W LBL_120
LBL_119:
        LEA LBL_1(PC),A0
        MOVE.L A0,-(A7)
        JSR 3002(A5)
        ADDQ.L #4,A7
        BSR.W LBL_5
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3010(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_6
LBL_120:
LBL_118:
LBL_116:
LBL_114:
LBL_112:
LBL_110:
LBL_108:
LBL_106:
LBL_104:
LBL_102:
LBL_100:
LBL_98:
LBL_96:
LBL_94:
LBL_92:
LBL_90:
LBL_88:
LBL_86:
LBL_84:
LBL_82:
LBL_80:
LBL_78:
LBL_76:
LBL_74:
LBL_72:
LBL_70:
LBL_68:
LBL_66:
LBL_64:
LBL_62:
LBL_60:
LBL_58:
LBL_56:
LBL_54:
LBL_52:
LBL_50:
LBL_48:
LBL_46:
LBL_44:
LBL_42:
LBL_40:
LBL_38:
LBL_36:
LBL_34:
LBL_32:
LBL_30:
LBL_28:
LBL_26:
LBL_24:
LBL_22:
LBL_20:
LBL_18:
LBL_16:
LBL_14:
LBL_12:
LBL_10:
LBL_8:
LBL_6:
        UNLK A6
        RTS
LBL_2:
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
LBL_3:
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
        BPL.W LBL_121
        NEG.L D2
        MOVE.L #1,D4
LBL_121:
        CLR.L D5
        TST.L D3
        BPL.W LBL_122
        NEG.L D3
        MOVE.L #1,D5
LBL_122:
        CLR.L D6
        MOVE.W #31,D7
LBL_123:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_124
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_124:
        DBRA D7,LBL_123
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_125
        NEG.L D2
LBL_125:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_4:
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
        BPL.W LBL_126
        NEG.L D2
        MOVE.L #1,D4
LBL_126:
        CLR.L D5
        TST.L D3
        BPL.W LBL_127
        NEG.L D3
        MOVE.L #1,D5
LBL_127:
        CLR.L D6
        MOVE.W #31,D7
LBL_128:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_129
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_129:
        DBRA D7,LBL_128
        TST.L D4
        BEQ.W LBL_130
        NEG.L D6
LBL_130:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_5:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -180(A5),D0
        MOVE.L D0,-4(A6)
LBL_131:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_1:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
