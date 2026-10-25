        ; func nat_UiScreenBits  (JT slot 195)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_0:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7414(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7414(A5),D1
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
        BEQ.W LBL_48
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_48:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7414(A5),D1
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
        MOVE.L -7414(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_47:
        UNLK A6
        RTS
        ; func recsMake  (JT slot 196)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -74(A6)  size 74
        ;   local __store5 : -148(A6)  size 74
        ;   local __ret5 : -222(A6)  size 74
LBL_1:
        LINK A6,#-274
        LEA -74(A6),A0
        MOVE.W #15,D0
LBL_50:
        CLR.W (A0)+
        DBRA D0,LBL_50
        MOVEQ #18,D0
        MOVE.L D0,-42(A6)
        MOVEQ #5,D0
        MOVE.W D0,-38(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_51:
        CLR.W (A0)+
        DBRA D0,LBL_51
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -148(A6),A0
        MOVE.W #36,D0
LBL_52:
        CLR.W (A0)+
        DBRA D0,LBL_52
        LEA -222(A6),A0
        MOVE.W #15,D0
LBL_53:
        CLR.W (A0)+
        DBRA D0,LBL_53
        MOVEQ #18,D0
        MOVE.L D0,-190(A6)
        MOVEQ #5,D0
        MOVE.W D0,-186(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_54:
        CLR.W (A0)+
        DBRA D0,LBL_54
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_55:
        CLR.W (A0)+
        DBRA D0,LBL_55
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
LBL_56:
        CLR.W (A0)+
        DBRA D0,LBL_56
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVE.L A0,-(A7)
        LEA -74(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_57:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_57
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        LEA -74(A6),A0
        LEA 38(A0),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A0,-(A7)
        LEA -222(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_58:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_58
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_59:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_59
        BRA.W LBL_49
LBL_49:
        UNLK A6
        RTS
        ; func recsMakeBox  (JT slot 197)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param label : 12(A6)  size 4
        ;   local b : -36(A6)  size 36
        ;   local __store6 : -72(A6)  size 36
        ;   local __ret6 : -108(A6)  size 36
LBL_2:
        LINK A6,#-160
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_61:
        CLR.W (A0)+
        DBRA D0,LBL_61
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -72(A6),A0
        MOVE.W #17,D0
LBL_62:
        CLR.W (A0)+
        DBRA D0,LBL_62
        LEA -108(A6),A0
        MOVE.W #15,D0
LBL_63:
        CLR.W (A0)+
        DBRA D0,LBL_63
        LEA -76(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -72(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -72(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_64:
        CLR.W (A0)+
        DBRA D0,LBL_64
        MOVEA.L A1,A0
        LEA 32(A0),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -72(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -36(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -72(A6),A0
        MOVE.L A0,-(A7)
        LEA -36(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_65:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_65
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        LEA -72(A6),A0
        LEA 32(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -36(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        MOVEA.L 12(A6),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -108(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -36(A6),A0
        MOVE.L A0,-(A7)
        LEA -108(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_66:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_66
        LEA -108(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -36(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -108(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_67:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_67
        BRA.W LBL_60
LBL_60:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 198)
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
LBL_3:
        LINK A6,#-1056
        LEA -74(A6),A0
        MOVE.W #15,D0
LBL_69:
        CLR.W (A0)+
        DBRA D0,LBL_69
        MOVEQ #18,D0
        MOVE.L D0,-42(A6)
        MOVEQ #5,D0
        MOVE.W D0,-38(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_70:
        CLR.W (A0)+
        DBRA D0,LBL_70
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -148(A6),A0
        MOVE.W #36,D0
LBL_71:
        CLR.W (A0)+
        DBRA D0,LBL_71
        LEA -222(A6),A0
        MOVE.W #15,D0
LBL_72:
        CLR.W (A0)+
        DBRA D0,LBL_72
        MOVEQ #18,D0
        MOVE.L D0,-190(A6)
        MOVEQ #5,D0
        MOVE.W D0,-186(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_73:
        CLR.W (A0)+
        DBRA D0,LBL_73
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        LEA -258(A6),A0
        MOVE.W #15,D0
LBL_74:
        CLR.W (A0)+
        DBRA D0,LBL_74
        LEA -226(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -294(A6),A0
        MOVE.W #15,D0
LBL_75:
        CLR.W (A0)+
        DBRA D0,LBL_75
        LEA -262(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
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
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -302(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-330(A6)
        MOVEQ #0,D0
        MOVE.L D0,-326(A6)
        LEA -322(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -318(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -404(A6),A0
        MOVE.W #36,D0
LBL_76:
        CLR.W (A0)+
        DBRA D0,LBL_76
        LEA -440(A6),A0
        MOVE.W #17,D0
LBL_77:
        CLR.W (A0)+
        DBRA D0,LBL_77
        LEA -476(A6),A0
        MOVE.W #17,D0
LBL_78:
        CLR.W (A0)+
        DBRA D0,LBL_78
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
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_79:
        CLR.W (A0)+
        DBRA D0,LBL_79
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
LBL_80:
        CLR.W (A0)+
        DBRA D0,LBL_80
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVE.L A0,-(A7)
        LEA -74(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_81:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_81
        LEA -74(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_25(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -74(A6),A0
        LEA 38(A0),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_26(PC),A0
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
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A0,-(A7)
        LEA -404(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_82:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_82
        LEA -404(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_35
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -404(A6),A0
        MOVE.L A0,-(A7)
        LEA -222(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_83:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_83
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
        BSR.W LBL_1
        ADDQ.L #8,A7
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-298(A6)
        MOVE.L A1,-(A7)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -1008(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_84:
        CLR.W (A0)+
        DBRA D0,LBL_84
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
LBL_85:
        CLR.W (A0)+
        DBRA D0,LBL_85
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        JSR 1546(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        MOVE.L A1,-(A7)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L (A7)+,D1
        MOVE.L (A7)+,D0
        MOVE.L D0,-298(A6)
        LEA -440(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_27(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        LEA -440(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_2
        ADDQ.L #8,A7
        LEA -258(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -440(A6),A0
        MOVE.L A0,-(A7)
        LEA -258(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_86:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_86
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
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -258(A6),A0
        MOVE.L A0,-(A7)
        LEA -476(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_87:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_87
        LEA -476(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_37
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -294(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -476(A6),A0
        MOVE.L A0,-(A7)
        LEA -294(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_88:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_88
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
        BSR.W LBL_42
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
        BSR.W LBL_41
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -330(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
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
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_36
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -258(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -294(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_38
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -314(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -330(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_42
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_68:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 199)
        ;   param slot : 8(A6)  size 4
LBL_4:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_90
        BRA.W LBL_91
LBL_90:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_92
        BRA.W LBL_93
LBL_92:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_94
        BRA.W LBL_95
LBL_94:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_96
        BRA.W LBL_97
LBL_96:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        BRA.W LBL_99
LBL_98:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_100
        BRA.W LBL_101
LBL_100:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_102
        BRA.W LBL_103
LBL_102:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_104
LBL_104:
LBL_103:
LBL_101:
LBL_99:
LBL_97:
LBL_95:
LBL_93:
LBL_91:
LBL_89:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 200)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_5:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
        BRA.W LBL_107
LBL_106:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_108
        BRA.W LBL_109
LBL_108:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_110
        BRA.W LBL_111
LBL_110:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_112
        BRA.W LBL_113
LBL_112:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_114
        BRA.W LBL_115
LBL_114:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        BRA.W LBL_117
LBL_116:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_118
        BRA.W LBL_119
LBL_118:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_120
LBL_120:
LBL_119:
LBL_117:
LBL_115:
LBL_113:
LBL_111:
LBL_109:
LBL_107:
LBL_105:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 201)
        ;   param slot : 8(A6)  size 4
LBL_6:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_122
        BRA.W LBL_123
LBL_122:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_124
        BRA.W LBL_125
LBL_124:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_126
        BRA.W LBL_127
LBL_126:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_128
        BRA.W LBL_129
LBL_128:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_130
        BRA.W LBL_131
LBL_130:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_132
        BRA.W LBL_133
LBL_132:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_134
        BRA.W LBL_135
LBL_134:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_136
LBL_136:
LBL_135:
LBL_133:
LBL_131:
LBL_129:
LBL_127:
LBL_125:
LBL_123:
LBL_121:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 202)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_7:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_138
        BRA.W LBL_139
LBL_138:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_140
        BRA.W LBL_141
LBL_140:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_142
        BRA.W LBL_143
LBL_142:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_144
        BRA.W LBL_145
LBL_144:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_146
        BRA.W LBL_147
LBL_146:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_148
        BRA.W LBL_149
LBL_148:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_150
        BRA.W LBL_151
LBL_150:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_152
LBL_152:
LBL_151:
LBL_149:
LBL_147:
LBL_145:
LBL_143:
LBL_141:
LBL_139:
LBL_137:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 203)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_8:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_154
        BRA.W LBL_155
LBL_154:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_156
LBL_156:
LBL_155:
LBL_153:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 204)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_158
        BRA.W LBL_159
LBL_158:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_160
LBL_160:
LBL_159:
LBL_157:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 205)
        ;   param slot : 8(A6)  size 4
LBL_10:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_162
        BRA.W LBL_163
LBL_162:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_164
LBL_164:
LBL_163:
LBL_161:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 206)
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
        BEQ.W LBL_166
        BRA.W LBL_167
LBL_166:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_168
LBL_168:
LBL_167:
LBL_165:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 207)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_170
        BRA.W LBL_171
LBL_170:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_172
LBL_172:
LBL_171:
LBL_169:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 208)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_13:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_174
        BRA.W LBL_175
LBL_174:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_176
LBL_176:
LBL_175:
LBL_173:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 209)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_14:
        LINK A6,#-52
        LEA LBL_28(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BSR.W LBL_46
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
LBL_177:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 210)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_15:
        LINK A6,#-52
        LEA LBL_29(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BSR.W LBL_46
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
LBL_178:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 211)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_16:
        LINK A6,#-52
        LEA LBL_30(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BSR.W LBL_46
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
LBL_179:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 212)
        ;   param idx : 8(A6)  size 4
LBL_17:
        LINK A6,#-52
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BSR.W LBL_46
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
LBL_180:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 213)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_18:
        LINK A6,#-52
        LEA LBL_32(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BSR.W LBL_46
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
LBL_181:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 214)
        ;   param rowsIdx : 8(A6)  size 4
LBL_19:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #155,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
        LEA -7104(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_182
        BRA.W LBL_184
LBL_183:
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 1370(A5)
        ADDQ.L #4,A7
        BSR.W LBL_46
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1378(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_182
LBL_184:
LBL_182:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 215)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_185
LBL_185:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 216) -- pascal callback glue for aeQuitHandler
LBL_21:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 778(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 217) -- pascal callback glue for aeOappHandler
LBL_22:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 786(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 218) -- pascal callback glue for rtUiScrollbarAction
LBL_23:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 962(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 219) -- pascal callback glue for rtUiLdefDraw
LBL_24:
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
        JSR 1050(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_43:
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
LBL_44:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_186
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_186:
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
        BPL.W LBL_187
        NEG.L D2
        MOVE.L #1,D4
LBL_187:
        CLR.L D5
        TST.L D3
        BPL.W LBL_188
        NEG.L D3
        MOVE.L #1,D5
LBL_188:
        CLR.L D6
        MOVE.W #31,D7
LBL_189:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_190
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_190:
        DBRA D7,LBL_189
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_191
        NEG.L D2
LBL_191:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_45:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_192
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_192:
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
        BPL.W LBL_193
        NEG.L D2
        MOVE.L #1,D4
LBL_193:
        CLR.L D5
        TST.L D3
        BPL.W LBL_194
        NEG.L D3
        MOVE.L #1,D5
LBL_194:
        CLR.L D6
        MOVE.W #31,D7
LBL_195:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_196
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_196:
        DBRA D7,LBL_195
        TST.L D4
        BEQ.W LBL_197
        NEG.L D6
LBL_197:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_46:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_198(PC),A0
        MOVE.L A0,-4(A6)
LBL_199:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_200
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_201
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_199
LBL_201:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_202:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_199
LBL_200:
        UNLK A6
        RTS
LBL_198:
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
        DC.W $E61A
        DC.W $0000
        DC.W $E440
        DC.W $0001
        DC.W $0000
        DC.W $0000
LBL_35:
        ; cg_retain_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_36:
        ; cg_release_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_37:
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
LBL_38:
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
LBL_39:
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
LBL_40:
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
LBL_41:
        ; cg_retain_recsOuter(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_39
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
LBL_42:
        ; cg_release_recsOuter(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_40
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
LBL_34:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_25:
        DC.B $08
        DC.B $4F,$72,$69,$67,$69,$6E,$61,$6C
        DC.B $00
LBL_26:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_27:
        DC.B $05
        DC.B $66,$69,$72,$73,$74
LBL_28:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_29:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_30:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_31:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_32:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_33:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
