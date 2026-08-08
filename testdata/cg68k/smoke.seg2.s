        ; func smokeFilesBig  (JT slot 96)
        ;   local t : -4(A6)  size 4
        ;   local t2 : -8(A6)  size 4
        ;   local ok : -10(A6)  size 2
        ;   local pass : -12(A6)  size 2
        ;   local i : -16(A6)  size 4
        ;   local n : -20(A6)  size 4
        ;   local __store10 : -24(A6)  size 4
LBL_0:
        LINK A6,#-8320
        LEA -4(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        LEA -8(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVEQ #0,D0
        MOVE.B D0,-10(A6)
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
        MOVEQ #0,D0
        MOVE.L D0,-20(A6)
        LEA -24(A6),A0
        MOVE.L A0,-(A7)
        JSR 114(A5)
        MOVEA.L (A7)+,A0
        MOVE.L D0,(A0)
        MOVE.L #40000,D0
        MOVE.L D0,-20(A6)
        LEA -24(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        JSR 114(A5)
        MOVE.L D0,-28(A6)
        MOVE.L -28(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_4(PC),A0
        MOVE.L A0,-(A7)
        JSR 138(A5)
        ADDQ.L #8,A7
        MOVE.L -28(A6),D0
        MOVE.L D0,-24(A6)
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L -24(A6),D0
        MOVE.L D0,-4(A6)
        MOVEQ #0,D0
        MOVE.L D0,-24(A6)
        MOVEQ #0,D0
        MOVE.L D0,-16(A6)
LBL_40:
        MOVE.L -16(A6),D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_41
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D1
        MOVE.L #256,D0
        BSR.W LBL_37
        ANDI.L #255,D0
        MOVE.L D0,-(A7)
        JSR 202(A5)
        ADDQ.L #8,A7
        MOVE.L -16(A6),D1
        MOVEQ #1,D0
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_40
LBL_41:
        LEA LBL_5(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        LEA LBL_2(PC),A0
        MOVE.L A0,-(A7)
        LEA LBL_3(PC),A0
        MOVE.L A0,-(A7)
        JSR 594(A5)
        ADDA.W #16,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_6(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_42:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_42
        JSR 690(A5)
        ADDA.W #258,A7
        LEA LBL_5(PC),A0
        MOVE.L A0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 602(A5)
        ADDQ.L #8,A7
        MOVE.B D0,-10(A6)
        CLR.L D0
        MOVE.B -10(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_7(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_43:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_43
        JSR 690(A5)
        ADDA.W #258,A7
        MOVEQ #1,D0
        MOVE.B D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR 170(A5)
        ADDQ.L #4,A7
        MOVE.L D0,D1
        MOVE.L -20(A6),D0
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_44
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_44:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVEQ #0,D0
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_45
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_45:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D1
        MOVEQ #1,D0
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,D1
        MOVE.L #256,D0
        BSR.W LBL_37
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_46
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_46:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32767,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #32767,D1
        MOVE.L #256,D0
        BSR.W LBL_37
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_47
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_47:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #32768,D0
        MOVE.L D0,-(A7)
        JSR 178(A5)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #32768,D1
        MOVE.L #256,D0
        BSR.W LBL_37
        ANDI.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_48
        MOVEQ #0,D0
        MOVE.B D0,-12(A6)
LBL_48:
        CLR.L D0
        MOVE.B -12(A6),D0
        MOVE.B D0,-(A7)
        LEA LBL_8(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_49:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_49
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -4(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -8(A6),A0
        MOVE.L A1,-(A7)
        MOVE.L 0(A0),D0
        MOVE.L D0,-(A7)
        JSR 130(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_39:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 97)
        ;   local p : -48(A6)  size 48
        ;   local __store11 : -96(A6)  size 48
        ;   local q : -144(A6)  size 48
        ;   local e : -148(A6)  size 4
        ;   local n : -152(A6)  size 4
        ;   local __store12 : -200(A6)  size 48
        ;   local __store13 : -248(A6)  size 48
LBL_1:
        LINK A6,#-8544
        MOVEQ #3,D0
        MOVE.L D0,-48(A6)
        MOVEQ #4,D0
        MOVE.L D0,-44(A6)
        MOVEQ #5,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_51:
        CLR.W (A0)+
        DBRA D0,LBL_51
        MOVEQ #3,D0
        MOVE.L D0,-96(A6)
        MOVEQ #4,D0
        MOVE.L D0,-92(A6)
        MOVEQ #5,D0
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-84(A6)
        LEA -80(A6),A0
        MOVE.W #15,D0
LBL_52:
        CLR.W (A0)+
        DBRA D0,LBL_52
        MOVEQ #3,D0
        MOVE.L D0,-144(A6)
        MOVEQ #4,D0
        MOVE.L D0,-140(A6)
        MOVEQ #5,D0
        MOVE.L D0,-136(A6)
        MOVEQ #0,D0
        MOVE.L D0,-132(A6)
        LEA -128(A6),A0
        MOVE.W #15,D0
LBL_53:
        CLR.W (A0)+
        DBRA D0,LBL_53
        MOVEQ #0,D0
        MOVE.L D0,-148(A6)
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        MOVEQ #3,D0
        MOVE.L D0,-200(A6)
        MOVEQ #4,D0
        MOVE.L D0,-196(A6)
        MOVEQ #5,D0
        MOVE.L D0,-192(A6)
        MOVEQ #0,D0
        MOVE.L D0,-188(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_54:
        CLR.W (A0)+
        DBRA D0,LBL_54
        MOVEQ #3,D0
        MOVE.L D0,-248(A6)
        MOVEQ #4,D0
        MOVE.L D0,-244(A6)
        MOVEQ #5,D0
        MOVE.L D0,-240(A6)
        MOVEQ #0,D0
        MOVE.L D0,-236(A6)
        LEA -232(A6),A0
        MOVE.W #15,D0
LBL_55:
        CLR.W (A0)+
        DBRA D0,LBL_55
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #3,D0
        MOVE.L D0,0(A0)
        MOVEA.L A1,A0
        MOVEQ #4,D0
        MOVE.L D0,4(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.L D0,8(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,12(A0)
        MOVEA.L A1,A0
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_56:
        CLR.W (A0)+
        DBRA D0,LBL_56
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_57:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_57
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_9(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_58:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_58
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_10(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_59:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_59
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_11(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_60:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_60
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_12(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_61:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_61
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_13(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_62:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_62
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_14(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_63:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_63
        JSR 690(A5)
        ADDA.W #258,A7
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_15(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L #90210,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_16(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_64:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_64
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #90210,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_17(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_65:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_65
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
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
        MOVE.B D0,-(A7)
        LEA LBL_18(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_66:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_66
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -200(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_67:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_67
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_33
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -200(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_68:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_68
        MOVEQ #99,D0
        MOVE.L D0,-(A7)
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #11111,D0
        MOVE.L D0,-(A7)
        LEA -144(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_19(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_69:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_69
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_20(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_70:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_70
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #90210,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_21(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_71:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_71
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #11111,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_22(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_72:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_72
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -248(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        JSR 698(A5)
        ADDQ.L #8,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_73:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_73
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_23(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_74:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_74
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #555,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_24(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_75:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_75
        JSR 690(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        ADDA.L #-48,A7
        MOVEA.L A7,A1
        MOVE.W #23,D0
LBL_76:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_76
        JSR 706(A5)
        ADDA.W #48,A7
        MOVE.L D0,-152(A6)
        MOVE.L -152(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #555,D0
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_25(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_77:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_77
        JSR 690(A5)
        ADDA.W #258,A7
        MOVEQ #6,D0
        MOVE.L D0,D1
        LEA LBL_32(PC),A0
        MOVE.W #2,D2
LBL_79:
        CMP.L (A0)+,D1
        BEQ.W LBL_78
        DBRA D2,LBL_79
        ; enum conversion miss -> rtEnumCheck(v, false, <name arg unused>) panics
        MOVE.L D1,-(A7)
        CLR.W -(A7)
        ADDA.L #-256,A7
        JSR 74(A5)
        ADDA.W #262,A7
LBL_78:
        MOVE.L D0,-148(A6)
        MOVE.L -148(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_26(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_80:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_80
        JSR 690(A5)
        ADDA.W #258,A7
        MOVE.L -148(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_27(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_81:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_81
        JSR 690(A5)
        ADDA.W #258,A7
        JSR 714(A5)
        JSR 722(A5)
        JSR 730(A5)
        JSR 738(A5)
        JSR 746(A5)
        JSR 754(A5)
        JSR 762(A5)
        LEA LBL_28(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_82:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_82
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        JSR 778(A5)
        ADDA.W #260,A7
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_29(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_30(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_83:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_83
        JSR 690(A5)
        ADDA.W #258,A7
        JSR 794(A5)
        BSR.W LBL_0
        LEA LBL_31(PC),A0
        MOVE.L A0,-(A7)
        JSR 514(A5)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_38
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_34
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_50:
        UNLK A6
        RTS
LBL_35:
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
LBL_36:
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
        BPL.W LBL_84
        NEG.L D2
        MOVE.L #1,D4
LBL_84:
        CLR.L D5
        TST.L D3
        BPL.W LBL_85
        NEG.L D3
        MOVE.L #1,D5
LBL_85:
        CLR.L D6
        MOVE.W #31,D7
LBL_86:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_87
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_87:
        DBRA D7,LBL_86
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_88
        NEG.L D2
LBL_88:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_37:
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
        BPL.W LBL_89
        NEG.L D2
        MOVE.L #1,D4
LBL_89:
        CLR.L D5
        TST.L D3
        BPL.W LBL_90
        NEG.L D3
        MOVE.L #1,D5
LBL_90:
        CLR.L D6
        MOVE.W #31,D7
LBL_91:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_92
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_92:
        DBRA D7,LBL_91
        TST.L D4
        BEQ.W LBL_93
        NEG.L D6
LBL_93:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_38:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
LBL_94:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_33:
        ; cg_retain_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_34:
        ; cg_release_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_4:
        DC.B $00
        DC.B $00
LBL_5:
        DC.B $0C
        DC.B $73,$6D,$6F,$6B,$65,$62,$69,$67,$2E,$64,$61,$74
        DC.B $00
LBL_2:
        DC.B $04
        DC.B $54,$45,$58,$54
        DC.B $00
LBL_3:
        DC.B $04
        DC.B $3F,$3F,$3F,$3F
        DC.B $00
LBL_6:
        DC.B $16
        DC.B $66,$69,$6C,$65,$20,$77,$72,$69,$74,$65,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
        DC.B $00
LBL_7:
        DC.B $15
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$6F,$6B
LBL_8:
        DC.B $22
        DC.B $66,$69,$6C,$65,$20,$72,$65,$61,$64,$54,$65,$78,$74,$20,$3E,$63,$61,$70,$20,$63,$6F,$6E,$74,$65,$6E,$74,$20,$6D,$61,$74,$63,$68,$65,$73
        DC.B $00
LBL_9:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_10:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$79
        DC.B $00
LBL_11:
        DC.B $11
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_12:
        DC.B $17
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
LBL_13:
        DC.B $18
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_14:
        DC.B $1B
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_15:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_16:
        DC.B $0B
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$78
LBL_17:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
        DC.B $00
LBL_18:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$73,$74,$72
        DC.B $00
LBL_19:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$78
LBL_20:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$78
LBL_21:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_22:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_23:
        DC.B $17
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
LBL_24:
        DC.B $13
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$66,$69,$65,$6C,$64
LBL_25:
        DC.B $15
        DC.B $72,$65,$63,$6F,$72,$64,$20,$70,$61,$72,$61,$6D,$20,$62,$79,$20,$76,$61,$6C,$75,$65
LBL_26:
        DC.B $14
        DC.B $65,$6E,$75,$6D,$20,$69,$6E,$74,$2D,$3E,$65,$6E,$75,$6D,$20,$76,$61,$6C,$69,$64
        DC.B $00
LBL_27:
        DC.B $18
        DC.B $65,$6E,$75,$6D,$20,$65,$6E,$75,$6D,$2D,$3E,$69,$6E,$74,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70
        DC.B $00
LBL_28:
        DC.B $06
        DC.B $61,$62,$63,$64,$65,$66
        DC.B $00
LBL_29:
        DC.B $03
        DC.B $61,$62,$63
LBL_30:
        DC.B $1C
        DC.B $73,$74,$72,$69,$6E,$67,$28,$33,$29,$2D,$72,$65,$74,$75,$72,$6E,$20,$41,$42,$49,$20,$70,$61,$74,$68,$20,$6F,$6B
        DC.B $00
LBL_31:
        DC.B $0A
        DC.B $73,$6D,$6F,$6B,$65,$20,$64,$6F,$6E,$65
        DC.B $00
        ; constant pool: enum value tables
LBL_32:
        DC.L $00000005
        DC.L $00000006
        DC.L $00000007
        ; constant pool: serdesc tables
