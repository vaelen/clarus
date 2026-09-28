        ; func strcontainersRun  (JT slot 193)
        ;   local sl : -4(A6)  size 4
        ;   local joined : -260(A6)  size 256
        ;   local sm : -264(A6)  size 4
        ;   local ka : -520(A6)  size 256
        ;   local kb : -776(A6)  size 256
        ;   local x : -786(A6)  size 10
LBL_0:
        LINK A6,#-2902
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #10,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        CLR.B (A0)
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 442(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -520(A6),A0
        CLR.B (A0)
        LEA -776(A6),A0
        CLR.B (A0)
        LEA -786(A6),A0
        CLR.B (A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_24(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_25(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_58
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_60
        BRA.W LBL_61
LBL_60:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_51(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_61:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_53
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_24(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_59
LBL_58:
        MOVEQ #0,D0
LBL_59:
        TST.L D0
        BEQ.W LBL_62
        LEA LBL_26(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_63
LBL_62:
        LEA LBL_27(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
LBL_63:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_64
        BRA.W LBL_65
LBL_64:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_51(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_65:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_53
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_28(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_66
        BRA.W LBL_67
LBL_66:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_51(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_67:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_53
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_28(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_68
        LEA LBL_29(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_69
LBL_68:
        LEA LBL_30(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
LBL_69:
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_23(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_70:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_72
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVEA.L D0,A0
        LEA -786(A6),A1
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        MOVE.W (A0)+,(A1)+
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA -786(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
LBL_71:
        ADDQ.L #1,(A7)
        BRA.W LBL_70
LBL_72:
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_73
        LEA LBL_32(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_74
LBL_73:
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
LBL_74:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        JSR 250(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-790(A6)
        MOVEQ #0,D0
        MOVE.L D0,-794(A6)
        MOVE.L -790(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -794(A6),D0
        MOVE.L D0,-(A7)
        JSR 258(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 266(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_77
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_79
        BRA.W LBL_80
LBL_79:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_51(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_80:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_53
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_25(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_78
LBL_77:
        MOVEQ #0,D0
LBL_78:
        TST.L D0
        BEQ.W LBL_75
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_81
        BRA.W LBL_82
LBL_81:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_51(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_82:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_53
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_76
LBL_75:
        MOVEQ #0,D0
LBL_76:
        TST.L D0
        BEQ.W LBL_83
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_84
LBL_83:
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
LBL_84:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        MOVEQ #6,D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-(A7)
        JSR 122(A5)
        ADDA.W #16,A7
        LEA -1318(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_85
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_86
LBL_85:
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
LBL_86:
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -776(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L -264(A6),D0
        MOVE.L D0,-790(A6)
        MOVEQ #42,D0
        MOVE.L D0,-794(A6)
        MOVE.L -790(A6),D0
        MOVE.L D0,-(A7)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        LEA -776(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1318(A6),A0
        MOVE.L A0,-(A7)
        LEA -794(A6),A0
        MOVE.L A0,-(A7)
        JSR 474(A5)
        ADDA.W #12,A7
        MOVE.L -264(A6),D0
        MOVE.L D0,-790(A6)
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        LEA -776(A6),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        LEA -1318(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1318(A6),A0
        MOVE.L A0,D0
        MOVE.L D0,-794(A6)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-798(A6)
        MOVE.L -798(A6),D0
        MOVE.L D0,-802(A6)
        MOVE.L -790(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -794(A6),D0
        MOVE.L D0,-(A7)
        LEA -802(A6),A0
        MOVE.L A0,-(A7)
        JSR 490(A5)
        ADDA.W #12,A7
        MOVE.L -802(A6),D1
        MOVEQ #42,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_87
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BRA.W LBL_88
LBL_87:
        LEA LBL_44(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
LBL_88:
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2858(A6)
LBL_89:
        MOVE.L A1,-(A7)
        MOVE.L -2858(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -264(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-2858(A6)
LBL_90:
        MOVE.L A1,-(A7)
        MOVE.L -2858(A6),D0
        MOVE.L D0,-(A7)
        JSR 458(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_57:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 194)
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
        BEQ.W LBL_92
        BRA.W LBL_93
LBL_92:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_94
        BRA.W LBL_95
LBL_94:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_96
        BRA.W LBL_97
LBL_96:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        BRA.W LBL_99
LBL_98:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_100
        BRA.W LBL_101
LBL_100:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_102
        BRA.W LBL_103
LBL_102:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_104
        BRA.W LBL_105
LBL_104:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
LBL_106:
LBL_105:
LBL_103:
LBL_101:
LBL_99:
LBL_97:
LBL_95:
LBL_93:
LBL_91:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 195)
        ;   param slot : 8(A6)  size 4
LBL_2:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_108
        BRA.W LBL_109
LBL_108:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_110
        BRA.W LBL_111
LBL_110:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_112
        BRA.W LBL_113
LBL_112:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_114
        BRA.W LBL_115
LBL_114:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        BRA.W LBL_117
LBL_116:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_118
        BRA.W LBL_119
LBL_118:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_120
        BRA.W LBL_121
LBL_120:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_122
LBL_122:
LBL_121:
LBL_119:
LBL_117:
LBL_115:
LBL_113:
LBL_111:
LBL_109:
LBL_107:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 196)
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
        BEQ.W LBL_124
        BRA.W LBL_125
LBL_124:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_126
        BRA.W LBL_127
LBL_126:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_128
        BRA.W LBL_129
LBL_128:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_130
        BRA.W LBL_131
LBL_130:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_132
        BRA.W LBL_133
LBL_132:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_134
        BRA.W LBL_135
LBL_134:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_136
        BRA.W LBL_137
LBL_136:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_138
LBL_138:
LBL_137:
LBL_135:
LBL_133:
LBL_131:
LBL_129:
LBL_127:
LBL_125:
LBL_123:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 197)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_4:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_140
        BRA.W LBL_141
LBL_140:
        MOVE.L 12(A6),D1
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
        ; func clar_lsn_fire_failed  (JT slot 198)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_5:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_144
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
        ; func clar_brs_fire_found  (JT slot 199)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_6:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
        BRA.W LBL_149
LBL_148:
        MOVE.L 16(A6),D1
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
        ; func clar_brs_fire_done  (JT slot 200)
        ;   param slot : 8(A6)  size 4
LBL_7:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_152
        BRA.W LBL_153
LBL_152:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
LBL_154:
LBL_153:
LBL_151:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 201)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_8:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_156
        BRA.W LBL_157
LBL_156:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_158
LBL_158:
LBL_157:
LBL_155:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 202)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_9:
        LINK A6,#-2100
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_160
        BRA.W LBL_161
LBL_160:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_162
LBL_162:
LBL_161:
LBL_159:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 203)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_10:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_164
        BRA.W LBL_165
LBL_164:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_166
LBL_166:
LBL_165:
LBL_163:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 204)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_11:
        LINK A6,#-2100
        LEA LBL_45(PC),A0
        MOVE.L A0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
        BSR.W LBL_56
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #4,A7
LBL_167:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 205)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_12:
        LINK A6,#-2100
        LEA LBL_46(PC),A0
        MOVE.L A0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
        BSR.W LBL_56
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #4,A7
LBL_168:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 206)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_13:
        LINK A6,#-2100
        LEA LBL_47(PC),A0
        MOVE.L A0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
        BSR.W LBL_56
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #4,A7
LBL_169:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 207)
        ;   param idx : 8(A6)  size 4
LBL_14:
        LINK A6,#-2100
        LEA LBL_48(PC),A0
        MOVE.L A0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
        BSR.W LBL_56
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #4,A7
LBL_170:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 208)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_15:
        LINK A6,#-2100
        LEA LBL_49(PC),A0
        MOVE.L A0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
        BSR.W LBL_56
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #4,A7
LBL_171:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 209)
        ;   param rowsIdx : 8(A6)  size 4
LBL_16:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVE.L #153,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_173
        LEA -7096(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_172
        BRA.W LBL_174
LBL_173:
        LEA LBL_50(PC),A0
        MOVE.L A0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
        BSR.W LBL_56
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1386(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_172
LBL_174:
LBL_172:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 210)
        ;   param path : 8(A6)  size 4
LBL_17:
        LINK A6,#-2100
LBL_175:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 211)
LBL_18:
        LINK A6,#-2100
LBL_176:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 212) -- pascal callback glue for aeQuitHandler
LBL_19:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 890(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 213) -- pascal callback glue for aeOappHandler
LBL_20:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 898(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 214) -- pascal callback glue for rtUiScrollbarAction
LBL_21:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1074(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 215) -- pascal callback glue for rtUiLdefDraw
LBL_22:
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
        JSR 1146(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_53:
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
LBL_54:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_177
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_52(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_177:
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
        BPL.W LBL_178
        NEG.L D2
        MOVE.L #1,D4
LBL_178:
        CLR.L D5
        TST.L D3
        BPL.W LBL_179
        NEG.L D3
        MOVE.L #1,D5
LBL_179:
        CLR.L D6
        MOVE.W #31,D7
LBL_180:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_181
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_181:
        DBRA D7,LBL_180
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_182
        NEG.L D2
LBL_182:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_55:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_183
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_52(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_183:
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
        BPL.W LBL_184
        NEG.L D2
        MOVE.L #1,D4
LBL_184:
        CLR.L D5
        TST.L D3
        BPL.W LBL_185
        NEG.L D3
        MOVE.L #1,D5
LBL_185:
        CLR.L D6
        MOVE.W #31,D7
LBL_186:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_187
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_187:
        DBRA D7,LBL_186
        TST.L D4
        BEQ.W LBL_188
        NEG.L D6
LBL_188:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_56:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L A1,-(A7)
        MOVE.L -6650(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6646(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6642(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6638(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6634(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6630(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6626(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L A1,-(A7)
        MOVE.L -6622(A5),D0
        MOVE.L D0,-(A7)
        JSR 154(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -7096(A5),D0
        MOVE.L D0,-4(A6)
LBL_189:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 226(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_52:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_24:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_25:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_51:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_26:
        DC.B $21
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$70,$75,$73,$68,$2F,$63,$6F,$75,$6E,$74,$2F,$69,$6E,$64,$65,$78,$2D,$72,$65,$61,$64,$20,$6F,$6B
LBL_27:
        DC.B $23
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$70,$75,$73,$68,$2F,$63,$6F,$75,$6E,$74,$2F,$69,$6E,$64,$65,$78,$2D,$72,$65,$61,$64,$20,$46,$41,$49,$4C
LBL_28:
        DC.B $05
        DC.B $47,$41,$4D,$4D,$41
LBL_29:
        DC.B $17
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$2D,$77,$72,$69,$74,$65,$20,$6F,$6B
LBL_30:
        DC.B $19
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$2D,$77,$72,$69,$74,$65,$20,$46,$41,$49,$4C
LBL_23:
        DC.B $00
        DC.B $00
LBL_31:
        DC.B $09
        DC.B $47,$41,$4D,$4D,$41,$62,$65,$74,$61
LBL_32:
        DC.B $1C
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$69,$74,$65,$72,$61,$74,$65,$20,$6F,$6B
        DC.B $00
LBL_33:
        DC.B $1E
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$69,$74,$65,$72,$61,$74,$65,$20,$46,$41,$49,$4C
        DC.B $00
LBL_34:
        DC.B $05
        DC.B $64,$65,$6C,$74,$61
LBL_35:
        DC.B $12
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$72,$65,$6D,$6F,$76,$65,$20,$6F,$6B
        DC.B $00
LBL_36:
        DC.B $14
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$72,$65,$6D,$6F,$76,$65,$20,$46,$41,$49,$4C
        DC.B $00
LBL_37:
        DC.B $0B
        DC.B $68,$65,$6C,$6C,$6F,$20,$77,$6F,$72,$6C,$64
LBL_38:
        DC.B $05
        DC.B $77,$6F,$72,$6C,$64
LBL_39:
        DC.B $20
        DC.B $73,$74,$72,$69,$6E,$67,$20,$73,$6C,$69,$63,$65,$20,$69,$6E,$20,$65,$78,$70,$72,$20,$70,$6F,$73,$69,$74,$69,$6F,$6E,$20,$6F,$6B
        DC.B $00
LBL_40:
        DC.B $22
        DC.B $73,$74,$72,$69,$6E,$67,$20,$73,$6C,$69,$63,$65,$20,$69,$6E,$20,$65,$78,$70,$72,$20,$70,$6F,$73,$69,$74,$69,$6F,$6E,$20,$46,$41,$49,$4C
        DC.B $00
LBL_41:
        DC.B $02
        DC.B $66,$6F
        DC.B $00
LBL_42:
        DC.B $01
        DC.B $6F
LBL_43:
        DC.B $2A
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$66,$72,$6F,$6D,$20,$63,$6F,$6E,$63,$61,$74,$20,$65,$78,$70,$72,$20,$28,$6D,$61,$74,$65,$72,$69,$61,$6C,$69,$7A,$65,$64,$29,$20,$6F,$6B
        DC.B $00
LBL_44:
        DC.B $2C
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$66,$72,$6F,$6D,$20,$63,$6F,$6E,$63,$61,$74,$20,$65,$78,$70,$72,$20,$28,$6D,$61,$74,$65,$72,$69,$61,$6C,$69,$7A,$65,$64,$29,$20,$46,$41,$49,$4C
        DC.B $00
LBL_45:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_46:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_47:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_48:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_49:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_50:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
