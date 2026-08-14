        ; func nat_UiScreenBounds  (JT slot 180)
        ;   param out : 8(A6)  size 4
LBL_0:
        LINK A6,#-8296
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -462(A5),D1
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
        MOVE.L -462(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_46:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 181)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_1:
        LINK A6,#-8300
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -462(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -462(A5),D1
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
        MOVE.L -462(A5),D1
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
        MOVE.L -462(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_47:
        UNLK A6
        RTS
        ; func strcontainersRun  (JT slot 182)
        ;   local sl : -4(A6)  size 4
        ;   local joined : -260(A6)  size 256
        ;   local sm : -264(A6)  size 4
        ;   local ka : -520(A6)  size 256
        ;   local kb : -776(A6)  size 256
        ;   local x : -786(A6)  size 10
LBL_2:
        LINK A6,#-9082
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #10,-(A7)
        JSR 194(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -260(A6),A0
        MOVE.W #127,D0
LBL_50:
        CLR.W (A0)+
        DBRA D0,LBL_50
        LEA -264(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #4,-(A7)
        JSR 418(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -520(A6),A0
        MOVE.W #127,D0
LBL_51:
        CLR.W (A0)+
        DBRA D0,LBL_51
        LEA -776(A6),A0
        MOVE.W #127,D0
LBL_52:
        CLR.W (A0)+
        DBRA D0,LBL_52
        LEA -786(A6),A0
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        CLR.W (A0)+
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_14(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_53
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_55
        BRA.W LBL_56
LBL_55:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_56:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_42
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_14(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_54
LBL_53:
        MOVEQ #0,D0
LBL_54:
        TST.L D0
        BEQ.W LBL_57
        LEA LBL_16(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        BRA.W LBL_58
LBL_57:
        LEA LBL_17(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_58:
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_59
        BRA.W LBL_60
LBL_59:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_60:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_42
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_18(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_61
        BRA.W LBL_62
LBL_61:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_62:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_42
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_18(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_63
        LEA LBL_19(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        BRA.W LBL_64
LBL_63:
        LEA LBL_20(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_64:
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_13(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVE.L D0,-(A7)
        CLR.L -(A7)
LBL_65:
        MOVE.L (A7),D0
        MOVE.L 4(A7),D1
        CMP.L D1,D0
        BGE.W LBL_67
        MOVE.L 8(A7),D0
        MOVE.L (A7),D1
        MOVE.L D0,-(A7)
        MOVE.L D1,-(A7)
        JSR 226(A5)
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
LBL_66:
        ADDQ.L #1,(A7)
        BRA.W LBL_65
LBL_67:
        ADDA.W #12,A7
        LEA -260(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_21(PC),A0
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
        LEA LBL_22(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        BRA.W LBL_69
LBL_68:
        LEA LBL_23(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_69:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #8,D0
        MOVE.L D0,-(A7)
        LEA LBL_24(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        JSR 234(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-790(A6)
        MOVEQ #0,D0
        MOVE.L D0,-794(A6)
        MOVE.L -790(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -794(A6),D0
        MOVE.L D0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 250(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_72
        MOVE.L -4(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_74
        BRA.W LBL_75
LBL_74:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_75:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_42
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L A0,-(A7)
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_73
LBL_72:
        MOVEQ #0,D0
LBL_73:
        TST.L D0
        BEQ.W LBL_70
        MOVE.L -4(A6),D1
        MOVEQ #1,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_76
        BRA.W LBL_77
LBL_76:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_41(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_77:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_42
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
        BRA.W LBL_71
LBL_70:
        MOVEQ #0,D0
LBL_71:
        TST.L D0
        BEQ.W LBL_78
        LEA LBL_25(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        BRA.W LBL_79
LBL_78:
        LEA LBL_26(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_79:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA LBL_27(PC),A0
        MOVE.L A0,-(A7)
        MOVEQ #6,D0
        MOVE.L D0,-(A7)
        MOVEQ #5,D0
        MOVE.L D0,-(A7)
        JSR 106(A5)
        ADDA.W #16,A7
        LEA -1354(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1354(A6),A0
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
        BEQ.W LBL_80
        LEA LBL_29(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        BRA.W LBL_81
LBL_80:
        LEA LBL_30(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_81:
        LEA -520(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        LEA -776(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_32(PC),A0
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
        LEA -1354(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        LEA -794(A6),A0
        MOVE.L A0,-(A7)
        JSR 450(A5)
        ADDA.W #12,A7
        MOVE.L -264(A6),D0
        MOVE.L D0,-790(A6)
        MOVEQ #1,D0
        NEG.L D0
        MOVE.L D0,-794(A6)
        MOVE.L -794(A6),D0
        MOVE.L D0,-798(A6)
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
        LEA -1354(A6),A0
        MOVEA.L A7,A1
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        ADDA.W #256,A7
        LEA -1354(A6),A0
        MOVE.L A0,-(A7)
        LEA -798(A6),A0
        MOVE.L A0,-(A7)
        JSR 466(A5)
        ADDA.W #12,A7
        MOVE.L -798(A6),D1
        MOVEQ #42,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_82
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
        BRA.W LBL_83
LBL_82:
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 1290(A5)
        ADDQ.L #4,A7
LBL_83:
        LEA -4(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-9038(A6)
LBL_84:
        MOVE.L A1,-(A7)
        MOVE.L -9038(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -264(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-9038(A6)
LBL_85:
        MOVE.L A1,-(A7)
        MOVE.L -9038(A6),D0
        MOVE.L D0,-(A7)
        JSR 434(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_49:
        UNLK A6
        RTS
        ; func clar_ui_fire_winevent  (JT slot 183)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_3:
        LINK A6,#-8296
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_45
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_86:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 184)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_4:
        LINK A6,#-8296
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_45
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_87:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 185)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_5:
        LINK A6,#-8296
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_45
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_88:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 186)
        ;   param idx : 8(A6)  size 4
LBL_6:
        LINK A6,#-8296
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_45
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_89:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 187)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_7:
        LINK A6,#-8296
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_45
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
LBL_90:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 188)
        ;   param rowsIdx : 8(A6)  size 4
LBL_8:
        LINK A6,#-8296
        MOVE.L 8(A6),D1
        MOVEQ #51,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_92
        LEA -186(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_91
        BRA.W LBL_93
LBL_92:
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 1298(A5)
        ADDQ.L #4,A7
        BSR.W LBL_45
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1306(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_91
LBL_93:
LBL_91:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 189) -- pascal callback glue for aeQuitHandler
LBL_9:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 850(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 190) -- pascal callback glue for aeOappHandler
LBL_10:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 858(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 191) -- pascal callback glue for rtUiScrollbarAction
LBL_11:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1018(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 192) -- pascal callback glue for rtUiLdefDraw
LBL_12:
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
        JSR 1074(A5)
        ADDA.W #26,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #20,A7
        JMP (A0)
LBL_42:
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
LBL_43:
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
        BPL.W LBL_94
        NEG.L D2
        MOVE.L #1,D4
LBL_94:
        CLR.L D5
        TST.L D3
        BPL.W LBL_95
        NEG.L D3
        MOVE.L #1,D5
LBL_95:
        CLR.L D6
        MOVE.W #31,D7
LBL_96:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_97
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_97:
        DBRA D7,LBL_96
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_98
        NEG.L D2
LBL_98:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_44:
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
        BPL.W LBL_99
        NEG.L D2
        MOVE.L #1,D4
LBL_99:
        CLR.L D5
        TST.L D3
        BPL.W LBL_100
        NEG.L D3
        MOVE.L #1,D5
LBL_100:
        CLR.L D6
        MOVE.W #31,D7
LBL_101:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_102
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_102:
        DBRA D7,LBL_101
        TST.L D4
        BEQ.W LBL_103
        NEG.L D6
LBL_103:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_45:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -186(A5),D0
        MOVE.L D0,-4(A6)
LBL_104:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 210(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_14:
        DC.B $05
        DC.B $61,$6C,$70,$68,$61
LBL_15:
        DC.B $04
        DC.B $62,$65,$74,$61
        DC.B $00
LBL_41:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_16:
        DC.B $21
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$70,$75,$73,$68,$2F,$63,$6F,$75,$6E,$74,$2F,$69,$6E,$64,$65,$78,$2D,$72,$65,$61,$64,$20,$6F,$6B
LBL_17:
        DC.B $23
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$70,$75,$73,$68,$2F,$63,$6F,$75,$6E,$74,$2F,$69,$6E,$64,$65,$78,$2D,$72,$65,$61,$64,$20,$46,$41,$49,$4C
LBL_18:
        DC.B $05
        DC.B $47,$41,$4D,$4D,$41
LBL_19:
        DC.B $17
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$2D,$77,$72,$69,$74,$65,$20,$6F,$6B
LBL_20:
        DC.B $19
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$2D,$77,$72,$69,$74,$65,$20,$46,$41,$49,$4C
LBL_13:
        DC.B $00
        DC.B $00
LBL_21:
        DC.B $09
        DC.B $47,$41,$4D,$4D,$41,$62,$65,$74,$61
LBL_22:
        DC.B $1C
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$69,$74,$65,$72,$61,$74,$65,$20,$6F,$6B
        DC.B $00
LBL_23:
        DC.B $1E
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$66,$6F,$72,$2D,$6C,$69,$73,$74,$20,$69,$74,$65,$72,$61,$74,$65,$20,$46,$41,$49,$4C
        DC.B $00
LBL_24:
        DC.B $05
        DC.B $64,$65,$6C,$74,$61
LBL_25:
        DC.B $12
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$72,$65,$6D,$6F,$76,$65,$20,$6F,$6B
        DC.B $00
LBL_26:
        DC.B $14
        DC.B $73,$74,$72,$2D,$6C,$69,$73,$74,$20,$72,$65,$6D,$6F,$76,$65,$20,$46,$41,$49,$4C
        DC.B $00
LBL_27:
        DC.B $0B
        DC.B $68,$65,$6C,$6C,$6F,$20,$77,$6F,$72,$6C,$64
LBL_28:
        DC.B $05
        DC.B $77,$6F,$72,$6C,$64
LBL_29:
        DC.B $20
        DC.B $73,$74,$72,$69,$6E,$67,$20,$73,$6C,$69,$63,$65,$20,$69,$6E,$20,$65,$78,$70,$72,$20,$70,$6F,$73,$69,$74,$69,$6F,$6E,$20,$6F,$6B
        DC.B $00
LBL_30:
        DC.B $22
        DC.B $73,$74,$72,$69,$6E,$67,$20,$73,$6C,$69,$63,$65,$20,$69,$6E,$20,$65,$78,$70,$72,$20,$70,$6F,$73,$69,$74,$69,$6F,$6E,$20,$46,$41,$49,$4C
        DC.B $00
LBL_31:
        DC.B $02
        DC.B $66,$6F
        DC.B $00
LBL_32:
        DC.B $01
        DC.B $6F
LBL_33:
        DC.B $2A
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$66,$72,$6F,$6D,$20,$63,$6F,$6E,$63,$61,$74,$20,$65,$78,$70,$72,$20,$28,$6D,$61,$74,$65,$72,$69,$61,$6C,$69,$7A,$65,$64,$29,$20,$6F,$6B
        DC.B $00
LBL_34:
        DC.B $2C
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$66,$72,$6F,$6D,$20,$63,$6F,$6E,$63,$61,$74,$20,$65,$78,$70,$72,$20,$28,$6D,$61,$74,$65,$72,$69,$61,$6C,$69,$7A,$65,$64,$29,$20,$46,$41,$49,$4C
        DC.B $00
LBL_35:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_36:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_37:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_38:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_39:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_40:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
