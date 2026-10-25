        ; func nat_UiTestEmit  (JT slot 193)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_0:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7106(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_56
        CLR.L D0
        MOVE.B -7130(A5),D0
        TST.L D0
        BEQ.W LBL_57
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_57:
        BRA.W LBL_55
LBL_56:
        JSR 1322(A5)
        MOVE.L -7408(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_58
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7408(A5)
LBL_58:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7408(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7408(A5),D1
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
        MOVE.L -7408(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #8,A7
        JSR 1314(A5)
LBL_55:
        UNLK A6
        RTS
        ; func natWlAddText  (JT slot 194)
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_1:
        LINK A6,#-60
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-8(A6)
        CLR.L D0
        MOVE.B -7128(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_60
        BRA.W LBL_59
LBL_60:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVEA.L D0,A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -8(A6),D1
        MOVE.L #511,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_61
        MOVE.L #511,D0
        MOVE.L D0,-8(A6)
LBL_61:
        MOVE.L -7126(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #4096,D0
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_62
        JSR 1370(A5)
LBL_62:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7114(A5),D1
        MOVE.L -7126(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -7114(A5),D1
        MOVE.L -7126(A5),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7126(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-7126(A5)
LBL_59:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 195)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_2:
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
        BEQ.W LBL_64
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_64:
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
LBL_63:
        UNLK A6
        RTS
        ; func recsMake  (JT slot 196)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param zip : 12(A6)  size 4
        ;   local p : -74(A6)  size 74
        ;   local __store5 : -148(A6)  size 74
        ;   local __ret5 : -222(A6)  size 74
LBL_3:
        LINK A6,#-274
        LEA -74(A6),A0
        MOVE.W #15,D0
LBL_66:
        CLR.W (A0)+
        DBRA D0,LBL_66
        MOVEQ #18,D0
        MOVE.L D0,-42(A6)
        MOVEQ #5,D0
        MOVE.W D0,-38(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_67:
        CLR.W (A0)+
        DBRA D0,LBL_67
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -148(A6),A0
        MOVE.W #36,D0
LBL_68:
        CLR.W (A0)+
        DBRA D0,LBL_68
        LEA -222(A6),A0
        MOVE.W #15,D0
LBL_69:
        CLR.W (A0)+
        DBRA D0,LBL_69
        MOVEQ #18,D0
        MOVE.L D0,-190(A6)
        MOVEQ #5,D0
        MOVE.W D0,-186(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_70:
        CLR.W (A0)+
        DBRA D0,LBL_70
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_71:
        CLR.W (A0)+
        DBRA D0,LBL_71
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
LBL_72:
        CLR.W (A0)+
        DBRA D0,LBL_72
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVE.L A0,-(A7)
        LEA -74(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_73:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_73
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
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A0,-(A7)
        LEA -222(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_74:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_74
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_75:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_75
        BRA.W LBL_65
LBL_65:
        UNLK A6
        RTS
        ; func recsSum  (JT slot 197)
        ;   param p : 8(A6)  size 4
LBL_4:
        LINK A6,#-52
        MOVEA.L 8(A6),A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVEA.L 8(A6),A0
        LEA 38(A0),A0
        LEA 32(A0),A0
        MOVE.L (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_76
LBL_76:
        UNLK A6
        RTS
        ; func recsMakeBox  (JT slot 198)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param label : 12(A6)  size 4
        ;   local b : -36(A6)  size 36
        ;   local __store6 : -72(A6)  size 36
        ;   local __ret6 : -108(A6)  size 36
LBL_5:
        LINK A6,#-160
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_78:
        CLR.W (A0)+
        DBRA D0,LBL_78
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -72(A6),A0
        MOVE.W #17,D0
LBL_79:
        CLR.W (A0)+
        DBRA D0,LBL_79
        LEA -108(A6),A0
        MOVE.W #15,D0
LBL_80:
        CLR.W (A0)+
        DBRA D0,LBL_80
        LEA -76(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -72(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -72(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_81:
        CLR.W (A0)+
        DBRA D0,LBL_81
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
        BSR.W LBL_45
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -36(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -72(A6),A0
        MOVE.L A0,-(A7)
        LEA -36(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_82:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_82
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
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -36(A6),A0
        MOVE.L A0,-(A7)
        LEA -108(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_83:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_83
        LEA -108(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -36(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -108(A6),A0
        MOVE.L A0,-(A7)
        MOVEA.L 8(A6),A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_84:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_84
        BRA.W LBL_77
LBL_77:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 199)
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
LBL_6:
        LINK A6,#-1056
        LEA -74(A6),A0
        MOVE.W #15,D0
LBL_86:
        CLR.W (A0)+
        DBRA D0,LBL_86
        MOVEQ #18,D0
        MOVE.L D0,-42(A6)
        MOVEQ #5,D0
        MOVE.W D0,-38(A6)
        LEA -36(A6),A0
        MOVE.W #15,D0
LBL_87:
        CLR.W (A0)+
        DBRA D0,LBL_87
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        LEA -148(A6),A0
        MOVE.W #36,D0
LBL_88:
        CLR.W (A0)+
        DBRA D0,LBL_88
        LEA -222(A6),A0
        MOVE.W #15,D0
LBL_89:
        CLR.W (A0)+
        DBRA D0,LBL_89
        MOVEQ #18,D0
        MOVE.L D0,-190(A6)
        MOVEQ #5,D0
        MOVE.W D0,-186(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_90:
        CLR.W (A0)+
        DBRA D0,LBL_90
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        LEA -258(A6),A0
        MOVE.W #15,D0
LBL_91:
        CLR.W (A0)+
        DBRA D0,LBL_91
        LEA -226(A6),A0
        MOVE.L A0,-(A7)
        JSR 130(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -294(A6),A0
        MOVE.W #15,D0
LBL_92:
        CLR.W (A0)+
        DBRA D0,LBL_92
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
LBL_93:
        CLR.W (A0)+
        DBRA D0,LBL_93
        LEA -440(A6),A0
        MOVE.W #17,D0
LBL_94:
        CLR.W (A0)+
        DBRA D0,LBL_94
        LEA -476(A6),A0
        MOVE.W #17,D0
LBL_95:
        CLR.W (A0)+
        DBRA D0,LBL_95
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
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_96:
        CLR.W (A0)+
        DBRA D0,LBL_96
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
LBL_97:
        CLR.W (A0)+
        DBRA D0,LBL_97
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -148(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -148(A6),A0
        MOVE.L A0,-(A7)
        LEA -74(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_98:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_98
        LEA -74(A6),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -74(A6),A0
        LEA 38(A0),A0
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_34(PC),A0
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
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -74(A6),A0
        MOVE.L A0,-(A7)
        LEA -404(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_99:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_99
        LEA -404(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_43
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -404(A6),A0
        MOVE.L A0,-(A7)
        LEA -222(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #36,D0
LBL_100:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_100
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
        BSR.W LBL_3
        ADDQ.L #8,A7
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_4
        ADDQ.L #4,A7
        MOVE.L D0,-298(A6)
        MOVE.L A1,-(A7)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -1008(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        LEA 0(A0),A0
        MOVE.W #15,D0
LBL_101:
        CLR.W (A0)+
        DBRA D0,LBL_101
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
LBL_102:
        CLR.W (A0)+
        DBRA D0,LBL_102
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,70(A0)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_4
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        MOVE.L A1,-(A7)
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L (A7)+,D1
        MOVE.L (A7)+,D0
        MOVE.L D0,-298(A6)
        LEA -440(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1008(A6),A0
        MOVE.L A0,-(A7)
        LEA -440(A6),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_5
        ADDQ.L #8,A7
        LEA -258(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -440(A6),A0
        MOVE.L A0,-(A7)
        LEA -258(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_103:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_103
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
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -258(A6),A0
        MOVE.L A0,-(A7)
        LEA -476(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_104:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_104
        LEA -476(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_45
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -294(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -476(A6),A0
        MOVE.L A0,-(A7)
        LEA -294(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #17,D0
LBL_105:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_105
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
        BSR.W LBL_50
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
        BSR.W LBL_49
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -330(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
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
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -222(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_44
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -258(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -294(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_46
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -314(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -330(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_50
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_85:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 200)
        ;   param slot : 8(A6)  size 4
LBL_7:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        BRA.W LBL_108
LBL_107:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_109
        BRA.W LBL_110
LBL_109:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_111
        BRA.W LBL_112
LBL_111:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_113
        BRA.W LBL_114
LBL_113:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_115
        BRA.W LBL_116
LBL_115:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_117
        BRA.W LBL_118
LBL_117:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_119
        BRA.W LBL_120
LBL_119:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
LBL_121:
LBL_120:
LBL_118:
LBL_116:
LBL_114:
LBL_112:
LBL_110:
LBL_108:
LBL_106:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 201)
        ;   param slot : 12(A6)  size 4
        ;   param data : 8(A6)  size 4
LBL_8:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_123
        BRA.W LBL_124
LBL_123:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_125
        BRA.W LBL_126
LBL_125:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_127
        BRA.W LBL_128
LBL_127:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_129
        BRA.W LBL_130
LBL_129:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_131
        BRA.W LBL_132
LBL_131:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
        BRA.W LBL_134
LBL_133:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_135
        BRA.W LBL_136
LBL_135:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_137
LBL_137:
LBL_136:
LBL_134:
LBL_132:
LBL_130:
LBL_128:
LBL_126:
LBL_124:
LBL_122:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 202)
        ;   param slot : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_139
        BRA.W LBL_140
LBL_139:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_141
        BRA.W LBL_142
LBL_141:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_143
        BRA.W LBL_144
LBL_143:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_145
        BRA.W LBL_146
LBL_145:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_147
        BRA.W LBL_148
LBL_147:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_149
        BRA.W LBL_150
LBL_149:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_151
        BRA.W LBL_152
LBL_151:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_153
LBL_153:
LBL_152:
LBL_150:
LBL_148:
LBL_146:
LBL_144:
LBL_142:
LBL_140:
LBL_138:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 203)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_10:
        LINK A6,#-52
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
        BRA.W LBL_158
LBL_157:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_159
        BRA.W LBL_160
LBL_159:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_161
        BRA.W LBL_162
LBL_161:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_163
        BRA.W LBL_164
LBL_163:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_165
        BRA.W LBL_166
LBL_165:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_167
        BRA.W LBL_168
LBL_167:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_169
LBL_169:
LBL_168:
LBL_166:
LBL_164:
LBL_162:
LBL_160:
LBL_158:
LBL_156:
LBL_154:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 204)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_11:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_171
        BRA.W LBL_172
LBL_171:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_173
LBL_173:
LBL_172:
LBL_170:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 205)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_175
        BRA.W LBL_176
LBL_175:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_177
LBL_177:
LBL_176:
LBL_174:
        UNLK A6
        RTS
        ; func clar_brs_fire_found  (JT slot 206)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_13:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_179
        BRA.W LBL_180
LBL_179:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_181
LBL_181:
LBL_180:
LBL_178:
        UNLK A6
        RTS
        ; func clar_brs_fire_done  (JT slot 207)
        ;   param slot : 8(A6)  size 4
LBL_14:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_183
        BRA.W LBL_184
LBL_183:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_185
LBL_185:
LBL_184:
LBL_182:
        UNLK A6
        RTS
        ; func clar_brs_fire_failed  (JT slot 208)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_15:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_187
        BRA.W LBL_188
LBL_187:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_189
LBL_189:
LBL_188:
LBL_186:
        UNLK A6
        RTS
        ; func clar_svc_fire_request  (JT slot 209)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_16:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_191
        BRA.W LBL_192
LBL_191:
        MOVE.L 20(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_193
LBL_193:
LBL_192:
LBL_190:
        UNLK A6
        RTS
        ; func clar_svc_fire_failed  (JT slot 210)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_17:
        LINK A6,#-52
        MOVE.L 16(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_195
        BRA.W LBL_196
LBL_195:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_197
LBL_197:
LBL_196:
LBL_194:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 211)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_18:
        LINK A6,#-52
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
LBL_198:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 212)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_19:
        LINK A6,#-52
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
LBL_199:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 213)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
LBL_200:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 214)
        ;   param idx : 8(A6)  size 4
LBL_21:
        LINK A6,#-52
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
LBL_201:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 215)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_22:
        LINK A6,#-52
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
LBL_202:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 216)
        ;   param rowsIdx : 8(A6)  size 4
LBL_23:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #155,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_204
        LEA -7104(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_203
        BRA.W LBL_205
LBL_204:
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 1410(A5)
        ADDQ.L #4,A7
        BSR.W LBL_54
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1418(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_203
LBL_205:
LBL_203:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 217)
        ;   param path : 8(A6)  size 4
LBL_24:
        LINK A6,#-52
LBL_206:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 218)
LBL_25:
        LINK A6,#-52
LBL_207:
        UNLK A6
        RTS
        ; func clar_ui_fire_logop  (JT slot 219)
        ;   param op : 24(A6)  size 4
        ;   param instV : 20(A6)  size 4
        ;   param wIdx : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_26:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_208
LBL_208:
        UNLK A6
        RTS
        ; func clar_ui_fire_colfmt  (JT slot 220)
        ;   param fmtId : 16(A6)  size 4
        ;   param rec : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_27:
        LINK A6,#-52
        MOVEQ #0,D0
        BRA.W LBL_209
LBL_209:
        UNLK A6
        RTS
        ; func clar_ui_fire_geomapply  (JT slot 221)
LBL_28:
        LINK A6,#-52
LBL_210:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 222) -- pascal callback glue for aeQuitHandler
LBL_29:
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
        ; func clar_cb_aeOappHandler (JT slot 223) -- pascal callback glue for aeOappHandler
LBL_30:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 794(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 224) -- pascal callback glue for rtUiScrollbarAction
LBL_31:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1002(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 225) -- pascal callback glue for rtUiLdefDraw
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
        JSR 1090(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_51:
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
LBL_52:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        TST.L D0
        BNE.W LBL_211
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_211:
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
        BPL.W LBL_212
        NEG.L D2
        MOVE.L #1,D4
LBL_212:
        CLR.L D5
        TST.L D3
        BPL.W LBL_213
        NEG.L D3
        MOVE.L #1,D5
LBL_213:
        CLR.L D6
        MOVE.W #31,D7
LBL_214:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_215
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_215:
        DBRA D7,LBL_214
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_216
        NEG.L D2
LBL_216:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_53:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        TST.L D0
        BNE.W LBL_217
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_217:
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
        BPL.W LBL_218
        NEG.L D2
        MOVE.L #1,D4
LBL_218:
        CLR.L D5
        TST.L D3
        BPL.W LBL_219
        NEG.L D3
        MOVE.L #1,D5
LBL_219:
        CLR.L D6
        MOVE.W #31,D7
LBL_220:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_221
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_221:
        DBRA D7,LBL_220
        TST.L D4
        BEQ.W LBL_222
        NEG.L D6
LBL_222:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_54:
        ; cg_free_globals
        LINK A6,#-52
        LEA LBL_223(PC),A0
        MOVE.L A0,-4(A6)
LBL_224:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_225
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_226
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_224
LBL_226:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_227:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_224
LBL_225:
        UNLK A6
        RTS
LBL_223:
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
LBL_43:
        ; cg_retain_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_44:
        ; cg_release_recsPerson(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_45:
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
LBL_46:
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
LBL_47:
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
LBL_48:
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
LBL_49:
        ; cg_retain_recsOuter(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_47
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
LBL_50:
        ; cg_release_recsOuter(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVE.L A1,-(A7)
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_48
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
LBL_42:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_33:
        DC.B $08
        DC.B $4F,$72,$69,$67,$69,$6E,$61,$6C
        DC.B $00
LBL_34:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_35:
        DC.B $05
        DC.B $66,$69,$72,$73,$74
LBL_36:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_37:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_38:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_39:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_40:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_41:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
