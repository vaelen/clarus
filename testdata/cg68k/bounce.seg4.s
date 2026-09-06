        ; func nat_SerFileWriteData  (JT slot 417)
        ;   param path : 20(A6)  size 4
        ;   param t : 16(A6)  size 4
        ;   param ftype : 12(A6)  size 4
        ;   param fcreator : 8(A6)  size 4
LBL_0:
        LINK A6,#-2100
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3314(A5)
        ADDA.W #16,A7
        TST.L D0
        BEQ.W LBL_46
        MOVEQ #1,D0
        BRA.W LBL_45
LBL_46:
        MOVEQ #0,D0
        BRA.W LBL_45
LBL_45:
        UNLK A6
        RTS
        ; func nat_SerFileReadTextInto  (JT slot 418)
        ;   param path : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_1:
        LINK A6,#-2100
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 3322(A5)
        ADDQ.L #8,A7
        TST.L D0
        BEQ.W LBL_48
        MOVEQ #1,D0
        BRA.W LBL_47
LBL_48:
        MOVEQ #0,D0
        BRA.W LBL_47
LBL_47:
        UNLK A6
        RTS
        ; func nat_UiTestEmit  (JT slot 419)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_2:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        JSR 3234(A5)
        MOVE.L -6896(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_50
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6896(A5)
LBL_50:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6896(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -6896(A5),D1
        MOVE.L -4(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        MOVE.L -6896(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 3218(A5)
        ADDQ.L #8,A7
        JSR 3226(A5)
LBL_49:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 420)
LBL_3:
        LINK A6,#-2100
        CLR.L D0
        MOVE.B -6898(A5),D0
        TST.L D0
        BEQ.W LBL_52
        BRA.W LBL_51
LBL_52:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-6902(A5)
        MOVE.L -6902(A5),D1
        MOVE.L #202,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        DC.W $A86E  ; NatInitGraf
        DC.W $A8FE  ; NatInitFonts
        DC.W $A036  ; NatMoreMasters
        DC.W $A912  ; NatInitWindows
        DC.W $A036  ; NatMoreMasters
        DC.W $A930  ; NatInitMenus
        DC.W $A036  ; NatMoreMasters
        DC.W $A9CC  ; NatTEInit
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        DC.W $A97B  ; NatInitDialogs
        MOVEQ #1,D0
        MOVE.B D0,-6898(A5)
        DC.W $A850  ; NatInitCursor
LBL_51:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 421)
        ;   param out : 8(A6)  size 4
LBL_4:
        LINK A6,#-2100
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
        MOVEQ #86,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_53:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 422)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_5:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -6902(A5),D1
        MOVEQ #84,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVE.L #32768,D0
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_55
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_55:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
        MOVEQ #86,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -6902(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_54:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 423)
LBL_6:
        LINK A6,#-2100
        MOVE.L #0,-(A7)
        JSR 1450(A5)
        ADDQ.L #4,A7
LBL_56:
        UNLK A6
        RTS
        ; func ui_every_0  (JT slot 424)
        ;   local g : -4(A6)  size 4
LBL_7:
        LINK A6,#-2104
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L #0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_58
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #12451840,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_59
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        BRA.W LBL_60
LBL_59:
        MOVEQ #1,D0
LBL_60:
        TST.L D0
        BEQ.W LBL_61
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_61:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 2130(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        TST.L D0
        BMI.W LBL_62
        MOVEQ #16,D1
        ASR.L D1,D0
        BRA.W LBL_63
LBL_62:
        NEG.L D0
        MOVEQ #16,D1
        ASR.L D1,D0
        NEG.L D0
LBL_63:
        MOVE.L D0,-(A7)
        MOVEQ #100,D0
        MOVE.L D0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        JSR 2154(A5)
        ADDA.W #20,A7
LBL_58:
LBL_57:
        UNLK A6
        RTS
        ; func ui_Game_opened  (JT slot 425)
        ;   param window : 8(A6)  size 4
LBL_8:
        LINK A6,#-2100
        MOVE.L #655360,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #131072,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEA.L D0,A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
LBL_64:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 426)
        ;   param slot : 8(A6)  size 4
LBL_9:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_66
        BRA.W LBL_67
LBL_66:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_68
        BRA.W LBL_69
LBL_68:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_70
        BRA.W LBL_71
LBL_70:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_72
        BRA.W LBL_73
LBL_72:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_74
        BRA.W LBL_75
LBL_74:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_76
        BRA.W LBL_77
LBL_76:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_78
        BRA.W LBL_79
LBL_78:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_80
LBL_80:
LBL_79:
LBL_77:
LBL_75:
LBL_73:
LBL_71:
LBL_69:
LBL_67:
LBL_65:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 427)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_10:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_82
        BRA.W LBL_83
LBL_82:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_84
        BRA.W LBL_85
LBL_84:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_86
        BRA.W LBL_87
LBL_86:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_88
        BRA.W LBL_89
LBL_88:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_90
        BRA.W LBL_91
LBL_90:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_92
        BRA.W LBL_93
LBL_92:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_94
        BRA.W LBL_95
LBL_94:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_96
LBL_96:
LBL_95:
LBL_93:
LBL_91:
LBL_89:
LBL_87:
LBL_85:
LBL_83:
LBL_81:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 428)
        ;   param slot : 8(A6)  size 4
LBL_11:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        BRA.W LBL_99
LBL_98:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_100
        BRA.W LBL_101
LBL_100:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_102
        BRA.W LBL_103
LBL_102:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_104
        BRA.W LBL_105
LBL_104:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
        BRA.W LBL_107
LBL_106:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_108
        BRA.W LBL_109
LBL_108:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_110
        BRA.W LBL_111
LBL_110:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_112
LBL_112:
LBL_111:
LBL_109:
LBL_107:
LBL_105:
LBL_103:
LBL_101:
LBL_99:
LBL_97:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 429)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_12:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_114
        BRA.W LBL_115
LBL_114:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        BRA.W LBL_117
LBL_116:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_118
        BRA.W LBL_119
LBL_118:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_120
        BRA.W LBL_121
LBL_120:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_122
        BRA.W LBL_123
LBL_122:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_124
        BRA.W LBL_125
LBL_124:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_126
        BRA.W LBL_127
LBL_126:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_128
LBL_128:
LBL_127:
LBL_125:
LBL_123:
LBL_121:
LBL_119:
LBL_117:
LBL_115:
LBL_113:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 430)
LBL_13:
        LINK A6,#-2100
LBL_129:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 431)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_14:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
        BRA.W LBL_132
LBL_131:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
LBL_133:
LBL_132:
LBL_130:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 432)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_15:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_135
        BRA.W LBL_136
LBL_135:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_137
LBL_137:
LBL_136:
LBL_134:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 433)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_16:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_139
        BRA.W LBL_140
LBL_139:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_141
LBL_141:
LBL_140:
LBL_138:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 434)
        ;   param slot : 8(A6)  size 4
LBL_17:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_143
        BRA.W LBL_144
LBL_143:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_145
LBL_145:
LBL_144:
LBL_142:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 435)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_18:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_147
        BRA.W LBL_148
LBL_147:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_149
LBL_149:
LBL_148:
LBL_146:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 436)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_19:
        LINK A6,#-2100
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_151
        BRA.W LBL_152
LBL_151:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_153
LBL_153:
LBL_152:
LBL_150:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 437)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_20:
        LINK A6,#-2100
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_155
        BRA.W LBL_156
LBL_155:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_157
LBL_157:
LBL_156:
LBL_154:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 438)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_21:
        LINK A6,#-2100
        MOVE.L 24(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_159
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
        MOVE.L 20(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_8
        ADDQ.L #4,A7
LBL_161:
        BRA.W LBL_160
LBL_159:
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3258(A5)
        ADDQ.L #4,A7
LBL_160:
LBL_158:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 439)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_22:
        LINK A6,#-2100
        MOVE.L 28(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_163
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_165
        BRA.W LBL_166
LBL_165:
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3258(A5)
        ADDQ.L #4,A7
LBL_166:
        BRA.W LBL_164
LBL_163:
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3258(A5)
        ADDQ.L #4,A7
LBL_164:
LBL_162:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 440)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_23:
        LINK A6,#-2100
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3258(A5)
        ADDQ.L #4,A7
LBL_167:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 441)
        ;   param idx : 8(A6)  size 4
LBL_24:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_169
        BSR.W LBL_7
        BRA.W LBL_170
LBL_169:
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3258(A5)
        ADDQ.L #4,A7
LBL_170:
LBL_168:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 442)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_25:
        LINK A6,#-2100
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_172
        BRA.W LBL_173
LBL_172:
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3258(A5)
        ADDQ.L #4,A7
LBL_173:
LBL_171:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 443)
        ;   param rowsIdx : 8(A6)  size 4
LBL_26:
        LINK A6,#-2100
        MOVE.L 8(A6),D1
        MOVEQ #124,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_175
        LEA -6618(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_174
        BRA.W LBL_176
LBL_175:
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 3250(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 3258(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_174
LBL_176:
LBL_174:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 444)
        ;   param path : 8(A6)  size 4
LBL_27:
        LINK A6,#-2100
LBL_177:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 445)
LBL_28:
        LINK A6,#-2100
LBL_178:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 446) -- pascal callback glue for aeQuitHandler
LBL_29:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1362(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 447) -- pascal callback glue for aeOappHandler
LBL_30:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 1370(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 448) -- pascal callback glue for rtUiScrollbarAction
LBL_31:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 2274(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 449) -- pascal callback glue for rtUiLdefDraw
LBL_32:
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
        JSR 2434(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_41:
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
LBL_42:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_179
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_179:
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
        BPL.W LBL_180
        NEG.L D2
        MOVE.L #1,D4
LBL_180:
        CLR.L D5
        TST.L D3
        BPL.W LBL_181
        NEG.L D3
        MOVE.L #1,D5
LBL_181:
        CLR.L D6
        MOVE.W #31,D7
LBL_182:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_183
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_183:
        DBRA D7,LBL_182
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_184
        NEG.L D2
LBL_184:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_43:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_185
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_185:
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
        BPL.W LBL_186
        NEG.L D2
        MOVE.L #1,D4
LBL_186:
        CLR.L D5
        TST.L D3
        BPL.W LBL_187
        NEG.L D3
        MOVE.L #1,D5
LBL_187:
        CLR.L D6
        MOVE.W #31,D7
LBL_188:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_189
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_189:
        DBRA D7,LBL_188
        TST.L D4
        BEQ.W LBL_190
        NEG.L D6
LBL_190:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_44:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -6618(A5),D0
        MOVE.L D0,-4(A6)
LBL_191:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_40:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_33:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_34:
        DC.B $2B
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$64,$67,$65,$74,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_35:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_36:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_37:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_38:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_39:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
