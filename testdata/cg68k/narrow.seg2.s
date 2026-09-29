        ; func nat_UiTestEmit  (JT slot 194)
        ;   param s : 8(A6)  size 4
        ;   local n : -4(A6)  size 4
LBL_0:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        CLR.L D0
        MOVE.B -7098(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_46
        CLR.L D0
        MOVE.B -7122(A5),D0
        TST.L D0
        BEQ.W LBL_47
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_1
        ADDQ.L #4,A7
LBL_47:
        BRA.W LBL_45
LBL_46:
        JSR 1346(A5)
        MOVE.L -7400(A5),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_48
        MOVE.L #512,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7400(A5)
LBL_48:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7400(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L #511,D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-4(A6)
        MOVE.L -7400(A5),D1
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
        MOVE.L -7400(A5),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 1330(A5)
        ADDQ.L #8,A7
        JSR 1338(A5)
LBL_45:
        UNLK A6
        RTS
        ; func natWlAddText  (JT slot 195)
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
        MOVE.B -7120(A5),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_50
        BRA.W LBL_49
LBL_50:
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
        BEQ.W LBL_51
        MOVE.L #511,D0
        MOVE.L D0,-8(A6)
LBL_51:
        MOVE.L -7118(A5),D1
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
        BEQ.W LBL_52
        JSR 1394(A5)
LBL_52:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7106(A5),D1
        MOVE.L -7118(A5),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 162(A5)
        ADDA.W #12,A7
        MOVE.L D0,-8(A6)
        MOVE.L -7106(A5),D1
        MOVE.L -7118(A5),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVEQ #10,D0
        MOVEA.L (A7)+,A0
        MOVE.B D0,(A0)
        MOVE.L -7118(A5),D1
        MOVE.L -8(A6),D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-7118(A5)
LBL_49:
        UNLK A6
        RTS
        ; func nat_UiMacInitToolbox  (JT slot 196)
LBL_2:
        LINK A6,#-52
        CLR.L D0
        MOVE.B -7402(A5),D0
        TST.L D0
        BEQ.W LBL_54
        BRA.W LBL_53
LBL_54:
        MOVE.L #206,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A31E  ; NatNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-7406(A5)
        MOVE.L -7406(A5),D1
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
        MOVE.B D0,-7402(A5)
        DC.W $A850  ; NatInitCursor
LBL_53:
        UNLK A6
        RTS
        ; func nat_UiScreenBounds  (JT slot 197)
        ;   param out : 8(A6)  size 4
LBL_3:
        LINK A6,#-52
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
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
        MOVE.L -7406(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_55:
        UNLK A6
        RTS
        ; func nat_UiScreenBits  (JT slot 198)
        ;   param baseAddrOut : 16(A6)  size 4
        ;   param rowBytesOut : 12(A6)  size 4
        ;   param boundsOut : 8(A6)  size 4
        ;   local rb : -4(A6)  size 4
LBL_4:
        LINK A6,#-56
        MOVEQ #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
        MOVEQ #80,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L -7406(A5),D1
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
        BEQ.W LBL_57
        MOVE.L -4(A6),D1
        MOVE.L #65536,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-4(A6)
LBL_57:
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -7406(A5),D1
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
        MOVE.L -7406(A5),D1
        MOVEQ #90,D0
        ADD.L D1,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
LBL_56:
        UNLK A6
        RTS
        ; func narrowAdd  (JT slot 199)
        ;   param x : 19(A6)  size 4
        ;   param y : 14(A6)  size 4
        ;   param z : 10(A6)  size 4
LBL_5:
        LINK A6,#-52
        CLR.L D0
        MOVE.B 19(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W 14(A6),D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.W 10(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_58
LBL_58:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 200)
        ;   local a : -2(A6)  size 2
        ;   local s : -4(A6)  size 2
        ;   local u : -6(A6)  size 2
        ;   local r : -16(A6)  size 10
        ;   local arr : -22(A6)  size 6
        ;   local l : -26(A6)  size 4
        ;   local m : -30(A6)  size 4
        ;   local i : -34(A6)  size 4
LBL_6:
        LINK A6,#-102
        MOVEQ #0,D0
        MOVE.B D0,-2(A6)
        MOVEQ #0,D0
        MOVE.W D0,-4(A6)
        MOVEQ #0,D0
        MOVE.W D0,-6(A6)
        MOVEQ #0,D0
        MOVE.B D0,-16(A6)
        MOVEQ #0,D0
        MOVE.W D0,-14(A6)
        MOVEQ #0,D0
        MOVE.W D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-10(A6)
        MOVEQ #0,D0
        MOVE.W D0,-22(A6)
        MOVEQ #0,D0
        MOVE.W D0,-20(A6)
        MOVEQ #0,D0
        MOVE.W D0,-18(A6)
        LEA -26(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #2,-(A7)
        JSR 202(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -30(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #2,-(A7)
        JSR 426(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.L D0,-34(A6)
        MOVE.L #200,D0
        MOVE.B D0,-2(A6)
        MOVE.L #32768,D0
        NEG.L D0
        MOVE.W D0,-4(A6)
        MOVE.L #65535,D0
        MOVE.W D0,-6(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        MOVE.B D0,-7416(A5)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.W D0,-7418(A5)
        CLR.L D0
        MOVE.B -2(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.B D0,(A0)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 2(A0),A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        CLR.L D0
        MOVE.W -6(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        LEA -22(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_41
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        MOVE.L -26(A6),D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.W -6(A6),D0
        MOVE.W D0,-38(A6)
        LEA -38(A6),A0
        MOVE.L A0,-(A7)
        JSR 242(A5)
        ADDQ.L #8,A7
        MOVE.L -30(A6),D0
        MOVE.L D0,-38(A6)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.W D0,-42(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        LEA -42(A6),A0
        MOVE.L A0,-(A7)
        JSR 458(A5)
        ADDA.W #12,A7
        MOVE.L -30(A6),D0
        MOVE.L D0,-38(A6)
        MOVEQ #7,D0
        MOVE.W D0,-42(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_32(PC),A0
        MOVE.L A0,-(A7)
        LEA -42(A6),A0
        MOVE.L A0,-(A7)
        JSR 458(A5)
        ADDA.W #12,A7
        MOVEQ #9,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D1
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
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_61:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_41
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        MOVE.L (A7)+,D0
        MOVE.W D0,(A0)
        CLR.L D0
        MOVE.B -2(A6),D0
        MOVE.L D0,-(A7)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        CLR.L D0
        MOVE.W -6(A6),D0
        MOVE.L D0,-(A7)
        BSR.W LBL_5
        ADDA.W #12,A7
        MOVE.L D0,-(A7)
        JSR 1578(A5)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-34(A6)
        MOVE.L -34(A6),D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 0(A0),A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 2(A0),A0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -16(A6),A0
        LEA 4(A0),A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        LEA -22(A6),A0
        MOVE.L A0,-(A7)
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D0
        MOVE.L D0,-(A7)
        JSR 74(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #2,D0
        BSR.W LBL_41
        MOVEA.L (A7)+,A1
        ADDA.L D0,A1
        MOVEA.L A1,A0
        MOVE.W (A0),D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -26(A6),D1
        MOVEQ #0,D0
        MOVEA.L D1,A0
        CMP.L 12(A0),D0
        BCC.W LBL_62
        BRA.W LBL_63
LBL_62:
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_39(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_63:
        MOVE.L D0,D1
        MOVE.L 8(A0),D0
        BSR.W LBL_41
        MOVE.L D0,D2
        MOVEA.L 4(A0),A1
        MOVEA.L (A1),A0
        ADDA.L D2,A0
        CLR.L D0
        MOVE.W (A0),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -30(A6),D0
        MOVE.L D0,-38(A6)
        LEA LBL_31(PC),A0
        MOVE.L A0,D0
        MOVE.L D0,-42(A6)
        MOVEQ #0,D0
        MOVE.W D0,-46(A6)
        MOVE.W -46(A6),D0
        MOVE.W D0,-50(A6)
        MOVE.L -38(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -42(A6),D0
        MOVE.L D0,-(A7)
        LEA -50(A6),A0
        MOVE.L A0,-(A7)
        JSR 474(A5)
        ADDA.W #12,A7
        MOVE.W -50(A6),D0
        EXT.L D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-34(A6)
        MOVE.L -34(A6),D0
        ANDI.L #255,D0
        MOVE.B D0,-2(A6)
        MOVE.L -34(A6),D0
        EXT.L D0
        MOVE.W D0,-4(A6)
        MOVE.L -34(A6),D0
        ANDI.L #65535,D0
        MOVE.W D0,-6(A6)
        MOVE.W -4(A6),D0
        EXT.L D0
        MOVE.L D0,D1
        MOVEQ #1,D0
        ASR.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-34(A6)
        LEA -26(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-58(A6)
LBL_64:
        MOVE.L A1,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -30(A6),A0
        MOVE.L 0(A0),D0
        MOVE.L D0,-58(A6)
LBL_65:
        MOVE.L A1,-(A7)
        MOVE.L -58(A6),D0
        MOVE.L D0,-(A7)
        JSR 442(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_59:
        UNLK A6
        RTS
        ; func clar_conn_fire_opened  (JT slot 201)
        ;   param slot : 8(A6)  size 4
LBL_7:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_67
        BRA.W LBL_68
LBL_67:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_69
        BRA.W LBL_70
LBL_69:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_71
        BRA.W LBL_72
LBL_71:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_73
        BRA.W LBL_74
LBL_73:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_75
        BRA.W LBL_76
LBL_75:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_77
        BRA.W LBL_78
LBL_77:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_79
        BRA.W LBL_80
LBL_79:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_81
LBL_81:
LBL_80:
LBL_78:
LBL_76:
LBL_74:
LBL_72:
LBL_70:
LBL_68:
LBL_66:
        UNLK A6
        RTS
        ; func clar_conn_fire_received  (JT slot 202)
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
        BEQ.W LBL_83
        BRA.W LBL_84
LBL_83:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_85
        BRA.W LBL_86
LBL_85:
        MOVE.L 12(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_87
        BRA.W LBL_88
LBL_87:
        MOVE.L 12(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_89
        BRA.W LBL_90
LBL_89:
        MOVE.L 12(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_91
        BRA.W LBL_92
LBL_91:
        MOVE.L 12(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_93
        BRA.W LBL_94
LBL_93:
        MOVE.L 12(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_95
        BRA.W LBL_96
LBL_95:
        MOVE.L 12(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_97
LBL_97:
LBL_96:
LBL_94:
LBL_92:
LBL_90:
LBL_88:
LBL_86:
LBL_84:
LBL_82:
        UNLK A6
        RTS
        ; func clar_conn_fire_closed  (JT slot 203)
        ;   param slot : 8(A6)  size 4
LBL_9:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_99
        BRA.W LBL_100
LBL_99:
        MOVE.L 8(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_101
        BRA.W LBL_102
LBL_101:
        MOVE.L 8(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_103
        BRA.W LBL_104
LBL_103:
        MOVE.L 8(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_105
        BRA.W LBL_106
LBL_105:
        MOVE.L 8(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        BRA.W LBL_108
LBL_107:
        MOVE.L 8(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_109
        BRA.W LBL_110
LBL_109:
        MOVE.L 8(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_111
        BRA.W LBL_112
LBL_111:
        MOVE.L 8(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_113
LBL_113:
LBL_112:
LBL_110:
LBL_108:
LBL_106:
LBL_104:
LBL_102:
LBL_100:
LBL_98:
        UNLK A6
        RTS
        ; func clar_conn_fire_failed  (JT slot 204)
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
        BEQ.W LBL_115
        BRA.W LBL_116
LBL_115:
        MOVE.L 16(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_117
        BRA.W LBL_118
LBL_117:
        MOVE.L 16(A6),D1
        MOVEQ #2,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_119
        BRA.W LBL_120
LBL_119:
        MOVE.L 16(A6),D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_121
        BRA.W LBL_122
LBL_121:
        MOVE.L 16(A6),D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_123
        BRA.W LBL_124
LBL_123:
        MOVE.L 16(A6),D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_125
        BRA.W LBL_126
LBL_125:
        MOVE.L 16(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_127
        BRA.W LBL_128
LBL_127:
        MOVE.L 16(A6),D1
        MOVEQ #7,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_129
LBL_129:
LBL_128:
LBL_126:
LBL_124:
LBL_122:
LBL_120:
LBL_118:
LBL_116:
LBL_114:
        UNLK A6
        RTS
        ; func clar_conn_pump  (JT slot 205)
LBL_11:
        LINK A6,#-52
LBL_130:
        UNLK A6
        RTS
        ; func clar_lsn_fire_accepted  (JT slot 206)
        ;   param slot : 12(A6)  size 4
        ;   param c : 8(A6)  size 4
LBL_12:
        LINK A6,#-52
        MOVE.L 12(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_132
        BRA.W LBL_133
LBL_132:
        MOVE.L 12(A6),D1
        MOVEQ #1,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_134
LBL_134:
LBL_133:
LBL_131:
        UNLK A6
        RTS
        ; func clar_lsn_fire_failed  (JT slot 207)
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
        BEQ.W LBL_136
        BRA.W LBL_137
LBL_136:
        MOVE.L 16(A6),D1
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
        ; func clar_brs_fire_found  (JT slot 208)
        ;   param slot : 16(A6)  size 4
        ;   param name : 12(A6)  size 4
        ;   param addr : 8(A6)  size 4
LBL_14:
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
        ; func clar_brs_fire_done  (JT slot 209)
        ;   param slot : 8(A6)  size 4
LBL_15:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_144
        BRA.W LBL_145
LBL_144:
        MOVE.L 8(A6),D1
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
        ; func clar_brs_fire_failed  (JT slot 210)
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
        ; func clar_svc_fire_request  (JT slot 211)
        ;   param slot : 20(A6)  size 4
        ;   param op : 16(A6)  size 4
        ;   param req : 12(A6)  size 4
        ;   param from : 8(A6)  size 4
LBL_17:
        LINK A6,#-52
        MOVE.L 20(A6),D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_152
        BRA.W LBL_153
LBL_152:
        MOVE.L 20(A6),D1
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
        ; func clar_svc_fire_failed  (JT slot 212)
        ;   param slot : 16(A6)  size 4
        ;   param code : 12(A6)  size 4
        ;   param msg : 8(A6)  size 4
LBL_18:
        LINK A6,#-52
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
        ; func clar_ui_fire_winevent  (JT slot 213)
        ;   param winIdx : 24(A6)  size 4
        ;   param inst : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_19:
        LINK A6,#-52
        LEA LBL_33(PC),A0
        MOVE.L A0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #4,A7
LBL_159:
        UNLK A6
        RTS
        ; func clar_ui_fire_widget  (JT slot 214)
        ;   param winIdx : 28(A6)  size 4
        ;   param inst : 24(A6)  size 4
        ;   param widgetIdx : 20(A6)  size 4
        ;   param ev : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
LBL_20:
        LINK A6,#-52
        LEA LBL_34(PC),A0
        MOVE.L A0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #4,A7
LBL_160:
        UNLK A6
        RTS
        ; func clar_ui_fire_menu  (JT slot 215)
        ;   param handlerIdx : 12(A6)  size 4
        ;   param frontInstOrNil : 8(A6)  size 4
LBL_21:
        LINK A6,#-52
        LEA LBL_35(PC),A0
        MOVE.L A0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #4,A7
LBL_161:
        UNLK A6
        RTS
        ; func clar_ui_fire_every  (JT slot 216)
        ;   param idx : 8(A6)  size 4
LBL_22:
        LINK A6,#-52
        LEA LBL_36(PC),A0
        MOVE.L A0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #4,A7
LBL_162:
        UNLK A6
        RTS
        ; func clar_ui_fire_releasevars  (JT slot 217)
        ;   param winIdx : 12(A6)  size 4
        ;   param inst : 8(A6)  size 4
LBL_23:
        LINK A6,#-52
        LEA LBL_37(PC),A0
        MOVE.L A0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #4,A7
LBL_163:
        UNLK A6
        RTS
        ; func clar_ui_fire_staterows  (JT slot 218)
        ;   param rowsIdx : 8(A6)  size 4
LBL_24:
        LINK A6,#-52
        MOVE.L 8(A6),D1
        MOVE.L #153,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_165
        LEA -7096(A5),A0
        MOVE.L A0,D0
        BRA.W LBL_164
        BRA.W LBL_166
LBL_165:
        LEA LBL_38(PC),A0
        MOVE.L A0,-(A7)
        JSR 1434(A5)
        ADDQ.L #4,A7
        BSR.W LBL_44
        MOVEQ #1,D0
        MOVE.L D0,-(A7)
        JSR 1442(A5)
        ADDQ.L #4,A7
        MOVEQ #0,D0
        BRA.W LBL_164
LBL_166:
LBL_164:
        UNLK A6
        RTS
        ; func clar_ui_fire_launchdoc  (JT slot 219)
        ;   param path : 8(A6)  size 4
LBL_25:
        LINK A6,#-52
LBL_167:
        UNLK A6
        RTS
        ; func clar_ui_fire_startempty  (JT slot 220)
LBL_26:
        LINK A6,#-52
LBL_168:
        UNLK A6
        RTS
        ; func clar_cb_aeQuitHandler (JT slot 221) -- pascal callback glue for aeQuitHandler
LBL_27:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 874(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_aeOappHandler (JT slot 222) -- pascal callback glue for aeOappHandler
LBL_28:
        LINK A6,#0
        ;   theAppleEvent : 16(A6)  pascal size 4
        MOVE.L 16(A6),-(A7)
        ;   reply : 12(A6)  pascal size 4
        MOVE.L 12(A6),-(A7)
        ;   handlerRefcon : 8(A6)  pascal size 4
        MOVE.L 8(A6),-(A7)
        JSR 882(A5)
        ADDA.W #12,A7
        MOVE.W D0,20(A6)
        UNLK A6
        MOVE.L (A7)+,A0
        ADDA.W #12,A7
        JMP (A0)
        ; func clar_cb_rtUiScrollbarAction (JT slot 223) -- pascal callback glue for rtUiScrollbarAction
LBL_29:
        LINK A6,#0
        ;   ctrl : 10(A6)  pascal size 4
        MOVE.L 10(A6),-(A7)
        ;   part : 8(A6)  pascal size 2
        MOVE.W 8(A6),D0
        EXT.L D0
        MOVE.L D0,-(A7)
        JSR 1058(A5)
        ADDQ.L #8,A7
        UNLK A6
        MOVE.L (A7)+,A0
        ADDQ.L #6,A7
        JMP (A0)
        ; func clar_cb_rtUiLdefDraw (JT slot 224) -- pascal callback glue for rtUiLdefDraw
LBL_30:
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
        JSR 1130(A5)
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
        BNE.W LBL_169
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_169:
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
        BPL.W LBL_170
        NEG.L D2
        MOVE.L #1,D4
LBL_170:
        CLR.L D5
        TST.L D3
        BPL.W LBL_171
        NEG.L D3
        MOVE.L #1,D5
LBL_171:
        CLR.L D6
        MOVE.W #31,D7
LBL_172:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_173
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_173:
        DBRA D7,LBL_172
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_174
        NEG.L D2
LBL_174:
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
        BNE.W LBL_175
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        MOVE.L #255,-(A7)
        LEA LBL_40(PC),A0
        MOVE.L A0,-(A7)
        JSR 90(A5)
        ADDA.W #12,A7
        MOVEA.L A7,A0
        MOVE.L A0,-(A7)
        JSR 50(A5)
LBL_175:
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
        BPL.W LBL_176
        NEG.L D2
        MOVE.L #1,D4
LBL_176:
        CLR.L D5
        TST.L D3
        BPL.W LBL_177
        NEG.L D3
        MOVE.L #1,D5
LBL_177:
        CLR.L D6
        MOVE.W #31,D7
LBL_178:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_179
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_179:
        DBRA D7,LBL_178
        TST.L D4
        BEQ.W LBL_180
        NEG.L D6
LBL_180:
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
        LINK A6,#-52
        LEA LBL_181(PC),A0
        MOVE.L A0,-4(A6)
LBL_182:
        MOVEA.L -4(A6),A0
        MOVE.W (A0)+,D0
        BEQ.W LBL_183
        MOVE.W (A0)+,D1
        MOVE.L A0,-4(A6)
        MOVEA.L A5,A0
        ADDA.W D0,A0
        CMPI.W #0,D1
        BNE.W LBL_184
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 146(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_182
LBL_184:
        MOVE.L 0(A0),D0
        MOVE.L D0,-8(A6)
LBL_185:
        MOVE.L A1,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 218(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BRA.W LBL_182
LBL_183:
        UNLK A6
        RTS
LBL_181:
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
LBL_40:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_31:
        DC.B $01
        DC.B $6B
LBL_32:
        DC.B $01
        DC.B $6A
LBL_39:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_33:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$6E,$65,$76,$65,$6E,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_34:
        DC.B $28
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$77,$69,$64,$67,$65,$74,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_35:
        DC.B $2A
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$6D,$65,$6E,$75,$3A,$20,$68,$61,$6E,$64,$6C,$65,$72,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_36:
        DC.B $24
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$65,$76,$65,$72,$79,$3A,$20,$69,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_37:
        DC.B $2D
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$72,$65,$6C,$65,$61,$73,$65,$76,$61,$72,$73,$3A,$20,$77,$69,$6E,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_38:
        DC.B $2C
        DC.B $63,$6C,$61,$72,$5F,$75,$69,$5F,$66,$69,$72,$65,$5F,$73,$74,$61,$74,$65,$72,$6F,$77,$73,$3A,$20,$72,$6F,$77,$73,$49,$64,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
        ; constant pool: enum value tables
        ; constant pool: serdesc tables
