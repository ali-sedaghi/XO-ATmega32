
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _c=R4
	.DEF _c_msb=R5
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x4C:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x4C,0x65,0x76,0x65,0x6C,0x20,0x25,0x31
	.DB  0x64,0x2F,0x25,0x64,0x20,0x20,0x20,0x20
	.DB  0x25,0x64,0x2D,0x25,0x64,0x0,0x50,0x6C
	.DB  0x61,0x79,0x65,0x72,0x20,0x52,0x45,0x44
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x50,0x6C
	.DB  0x61,0x79,0x65,0x72,0x20,0x47,0x52,0x45
	.DB  0x45,0x4E,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x50,0x6C,0x61,0x79,0x65,0x72,0x20,0x47
	.DB  0x52,0x45,0x45,0x4E,0x20,0x57,0x69,0x6E
	.DB  0x2E,0x2E,0x21,0x0,0x50,0x6C,0x61,0x79
	.DB  0x65,0x72,0x20,0x52,0x45,0x44,0x20,0x57
	.DB  0x69,0x6E,0x2E,0x2E,0x21,0x0,0x52,0x65
	.DB  0x73,0x65,0x74,0x69,0x6E,0x67,0x2E,0x2E
	.DB  0x2E,0x0,0x50,0x6C,0x61,0x79,0x65,0x72
	.DB  0x20,0x47,0x52,0x45,0x45,0x4E,0x3A,0x20
	.DB  0x25,0x64,0x0,0x50,0x6C,0x61,0x79,0x65
	.DB  0x72,0x20,0x52,0x45,0x44,0x3A,0x20,0x25
	.DB  0x64,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _0x54
	.DW  _0x0*2+22

	.DW  0x12
	.DW  _0x54+16
	.DW  _0x0*2+38

	.DW  0x14
	.DW  _0x54+34
	.DW  _0x0*2+56

	.DW  0x14
	.DW  _0x54+54
	.DW  _0x0*2+56

	.DW  0x14
	.DW  _0x54+74
	.DW  _0x0*2+56

	.DW  0x14
	.DW  _0x54+94
	.DW  _0x0*2+56

	.DW  0x14
	.DW  _0x54+114
	.DW  _0x0*2+56

	.DW  0x14
	.DW  _0x54+134
	.DW  _0x0*2+56

	.DW  0x14
	.DW  _0x54+154
	.DW  _0x0*2+56

	.DW  0x14
	.DW  _0x54+174
	.DW  _0x0*2+56

	.DW  0x12
	.DW  _0x54+194
	.DW  _0x0*2+76

	.DW  0x12
	.DW  _0x54+212
	.DW  _0x0*2+76

	.DW  0x12
	.DW  _0x54+230
	.DW  _0x0*2+76

	.DW  0x12
	.DW  _0x54+248
	.DW  _0x0*2+76

	.DW  0x12
	.DW  _0x54+266
	.DW  _0x0*2+76

	.DW  0x12
	.DW  _0x54+284
	.DW  _0x0*2+76

	.DW  0x12
	.DW  _0x54+302
	.DW  _0x0*2+76

	.DW  0x12
	.DW  _0x54+320
	.DW  _0x0*2+76

	.DW  0x0C
	.DW  _0x54+338
	.DW  _0x0*2+94

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;
;#define ROUNDS 3
;
;#define gled1 PORTC.0
;#define gled2 PORTC.1
;#define gled3 PORTC.2
;#define gled4 PORTC.3
;#define gled5 PORTC.4
;#define gled6 PORTC.5
;#define gled7 PORTC.6
;#define gled8 PORTC.7
;#define gled9 PORTB.6
;
;#define rled1 PORTD.0
;#define rled2 PORTD.1
;#define rled3 PORTD.2
;#define rled4 PORTD.3
;#define rled5 PORTD.4
;#define rled6 PORTD.5
;#define rled7 PORTD.6
;#define rled8 PORTD.7
;#define rled9 PORTB.7
;
;
;int pressed[9];
;int c=0;
;bit player=0;
;
;
;int read_key()
; 0000 0024 {

	.CSEG
_read_key:
; .FSTART _read_key
; 0000 0025 int i=0;
; 0000 0026 DDRB =0b11000111;
	CALL SUBOPT_0x0
;	i -> R16,R17
	LDI  R30,LOW(199)
	OUT  0x17,R30
; 0000 0027 PORTB=(PORTB.7<<7)|(PORTB.6<<6)|(0b111111);
	LDI  R26,0
	SBIC 0x18,7
	LDI  R26,1
	MOV  R30,R26
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x18,6
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	OR   R30,R0
	ORI  R30,LOW(0x3F)
	OUT  0x18,R30
; 0000 0028 
; 0000 0029 while(i==0)
_0x3:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x5
; 0000 002A  {
; 0000 002B   PORTB.0=0;
	CBI  0x18,0
; 0000 002C   delay_ms(1);
	CALL SUBOPT_0x1
; 0000 002D        if(PINB.3==0){i=1;break;}
	SBIC 0x16,3
	RJMP _0x8
	__GETWRN 16,17,1
	RJMP _0x5
; 0000 002E   else if(PINB.4==0){i=4;break;}
_0x8:
	SBIC 0x16,4
	RJMP _0xA
	__GETWRN 16,17,4
	RJMP _0x5
; 0000 002F   else if(PINB.5==0){i=7;break;}
_0xA:
	SBIC 0x16,5
	RJMP _0xC
	__GETWRN 16,17,7
	RJMP _0x5
; 0000 0030   PORTB.0=1;
_0xC:
	SBI  0x18,0
; 0000 0031   PORTB.1=0;
	CBI  0x18,1
; 0000 0032   delay_ms(1);
	CALL SUBOPT_0x1
; 0000 0033        if(PINB.3==0){i=2;break;}
	SBIC 0x16,3
	RJMP _0x11
	__GETWRN 16,17,2
	RJMP _0x5
; 0000 0034   else if(PINB.4==0){i=5;break;}
_0x11:
	SBIC 0x16,4
	RJMP _0x13
	__GETWRN 16,17,5
	RJMP _0x5
; 0000 0035   else if(PINB.5==0){i=8;break;}
_0x13:
	SBIC 0x16,5
	RJMP _0x15
	__GETWRN 16,17,8
	RJMP _0x5
; 0000 0036   PORTB.1=1;
_0x15:
	SBI  0x18,1
; 0000 0037   PORTB.2=0;
	CBI  0x18,2
; 0000 0038   delay_ms(1);
	CALL SUBOPT_0x1
; 0000 0039        if(PINB.3==0){i=3;break;}
	SBIC 0x16,3
	RJMP _0x1A
	__GETWRN 16,17,3
	RJMP _0x5
; 0000 003A   else if(PINB.4==0){i=6;break;}
_0x1A:
	SBIC 0x16,4
	RJMP _0x1C
	__GETWRN 16,17,6
	RJMP _0x5
; 0000 003B   else if(PINB.5==0){i=9;break;}
_0x1C:
	SBIC 0x16,5
	RJMP _0x1E
	__GETWRN 16,17,9
	RJMP _0x5
; 0000 003C   PORTB.2=1;
_0x1E:
	SBI  0x18,2
; 0000 003D  }
	RJMP _0x3
_0x5:
; 0000 003E 
; 0000 003F delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0040 return i;
	MOVW R30,R16
	RJMP _0x20C0003
; 0000 0041 }
; .FEND
;
;int check_key(int n)
; 0000 0044 {
_check_key:
; .FSTART _check_key
; 0000 0045 int i=0;
; 0000 0046 for(i=0;i<9;i++)
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x0
;	n -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x22:
	__CPWRN 16,17,9
	BRGE _0x23
; 0000 0047  {
; 0000 0048  if(n==pressed[i])
	CALL SUBOPT_0x2
	CALL __GETW1P
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x24
; 0000 0049  return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20C0004
; 0000 004A  }
_0x24:
	__ADDWRN 16,17,1
	RJMP _0x22
_0x23:
; 0000 004B pressed[c]=n;
	MOVW R30,R4
	LDI  R26,LOW(_pressed)
	LDI  R27,HIGH(_pressed)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 004C c++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 004D return n;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; 0000 004E }
; .FEND
;
;void clear()
; 0000 0051 {
_clear:
; .FSTART _clear
; 0000 0052 int i=0;
; 0000 0053 gled9=0;
	CALL SUBOPT_0x0
;	i -> R16,R17
	CBI  0x18,6
; 0000 0054 rled9=0;
	CBI  0x18,7
; 0000 0055 delay_ms(100);
	CALL SUBOPT_0x3
; 0000 0056 gled8=0;
	CBI  0x15,7
; 0000 0057 rled8=0;
	CBI  0x12,7
; 0000 0058 delay_ms(100);
	CALL SUBOPT_0x3
; 0000 0059 gled7=0;
	CBI  0x15,6
; 0000 005A rled7=0;
	CBI  0x12,6
; 0000 005B delay_ms(100);
	CALL SUBOPT_0x3
; 0000 005C gled4=0;
	CBI  0x15,3
; 0000 005D rled4=0;
	CBI  0x12,3
; 0000 005E delay_ms(100);
	CALL SUBOPT_0x3
; 0000 005F gled5=0;
	CBI  0x15,4
; 0000 0060 rled5=0;
	CBI  0x12,4
; 0000 0061 delay_ms(100);
	CALL SUBOPT_0x3
; 0000 0062 gled6=0;
	CBI  0x15,5
; 0000 0063 rled6=0;
	CBI  0x12,5
; 0000 0064 delay_ms(100);
	CALL SUBOPT_0x3
; 0000 0065 gled3=0;
	CBI  0x15,2
; 0000 0066 rled3=0;
	CBI  0x12,2
; 0000 0067 delay_ms(100);
	CALL SUBOPT_0x3
; 0000 0068 gled2=0;
	CBI  0x15,1
; 0000 0069 rled2=0;
	CBI  0x12,1
; 0000 006A delay_ms(100);
	CALL SUBOPT_0x3
; 0000 006B gled1=0;
	CBI  0x15,0
; 0000 006C rled1=0;
	CBI  0x12,0
; 0000 006D c=0;
	CLR  R4
	CLR  R5
; 0000 006E for(i=0;i<9;i++)
	__GETWRN 16,17,0
_0x4A:
	__CPWRN 16,17,9
	BRGE _0x4B
; 0000 006F  {
; 0000 0070   pressed[i]=0;
	CALL SUBOPT_0x2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 0071  }
	__ADDWRN 16,17,1
	RJMP _0x4A
_0x4B:
; 0000 0072 }
_0x20C0003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 0075 {
_main:
; .FSTART _main
; 0000 0076 // Declare your local variables here
; 0000 0077 int key,i,p1=0,p2=0;
; 0000 0078 char lcd_b[32];
; 0000 0079 int hasAi = 0;
; 0000 007A 
; 0000 007B // Input/Output Ports initialization
; 0000 007C // Port A initialization
; 0000 007D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007E DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,36
	LDI  R24,36
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x4C*2)
	LDI  R31,HIGH(_0x4C*2)
	CALL __INITLOCB
;	key -> R16,R17
;	i -> R18,R19
;	p1 -> R20,R21
;	p2 -> Y+34
;	lcd_b -> Y+2
;	hasAi -> Y+0
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 007F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0080 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0081 
; 0000 0082 // Port B initialization
; 0000 0083 // Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0084 DDRB=(1<<DDB7) | (1<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(192)
	OUT  0x17,R30
; 0000 0085 // State: Bit7=0 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0086 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0087 
; 0000 0088 // Port C initialization
; 0000 0089 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 008A DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 008B // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 008C PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 008D 
; 0000 008E // Port D initialization
; 0000 008F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0090 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0091 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0092 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0093 
; 0000 0094 // Alphanumeric LCD initialization
; 0000 0095 // Connections are specified in the
; 0000 0096 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0097 // RS - PORTA Bit 0
; 0000 0098 // RD - PORTA Bit 1
; 0000 0099 // EN - PORTA Bit 2
; 0000 009A // D4 - PORTA Bit 4
; 0000 009B // D5 - PORTA Bit 5
; 0000 009C // D6 - PORTA Bit 6
; 0000 009D // D7 - PORTA Bit 7
; 0000 009E // Characters/line: 16
; 0000 009F lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00A0 
; 0000 00A1 hasAi = PINA & (1 << PINA3);
	IN   R30,0x19
	ANDI R30,LOW(0x8)
	LDI  R31,0
	ST   Y,R30
	STD  Y+1,R31
; 0000 00A2 for(i=1;i<=ROUNDS;i++)
	__GETWRN 18,19,1
_0x4E:
	__CPWRN 18,19,4
	BRLT PC+2
	RJMP _0x4F
; 0000 00A3  {
; 0000 00A4 
; 0000 00A5  lcd_clear();
	CALL SUBOPT_0x4
; 0000 00A6  sprintf(lcd_b,"Level %1d/%d    %d-%d",i,ROUNDS,p1,p2);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CALL SUBOPT_0x5
	__GETD1N 0x3
	CALL __PUTPARD1
	MOVW R30,R20
	CALL SUBOPT_0x5
	LDD  R30,Y+50
	LDD  R31,Y+50+1
	CALL SUBOPT_0x5
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00A7  lcd_gotoxy(0,0);
	CALL SUBOPT_0x6
; 0000 00A8  lcd_puts(lcd_b);
; 0000 00A9  while (1)
_0x50:
; 0000 00AA       {
; 0000 00AB       lcd_gotoxy(0,1);
	CALL SUBOPT_0x7
; 0000 00AC 
; 0000 00AD         if(player==1){
	SBRS R2,0
	RJMP _0x53
; 0000 00AE             lcd_puts("Player RED     ");
	__POINTW2MN _0x54,0
	RJMP _0x298
; 0000 00AF         } else{
_0x53:
; 0000 00B0             lcd_puts("Player GREEN     ");
	__POINTW2MN _0x54,16
_0x298:
	CALL _lcd_puts
; 0000 00B1         }
; 0000 00B2 
; 0000 00B3       if (player || !hasAi){
	SBRC R2,0
	RJMP _0x57
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x56
_0x57:
; 0000 00B4           key=check_key(read_key());
	RCALL _read_key
	MOVW R26,R30
	RCALL _check_key
	MOVW R16,R30
; 0000 00B5       } else {
	RJMP _0x59
_0x56:
; 0000 00B6           key = -1;
	__GETWRN 16,17,-1
; 0000 00B7       }
_0x59:
; 0000 00B8       if(key!=0)
	MOV  R0,R16
	OR   R0,R17
	BRNE PC+2
	RJMP _0x5A
; 0000 00B9        {
; 0000 00BA        if(player==0)
	SBRC R2,0
	RJMP _0x5B
; 0000 00BB         {
; 0000 00BC             if (hasAi){
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x5C
; 0000 00BD 
; 0000 00BE                 int shouldContinue = 1;
; 0000 00BF                 key = ((rand() + 5) % 9) + 1;
	SBIW R28,2
	LDI  R30,LOW(1)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
;	p2 -> Y+36
;	lcd_b -> Y+4
;	hasAi -> Y+2
;	shouldContinue -> Y+0
	CALL _rand
	ADIW R30,5
	MOVW R26,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __MODW21
	ADIW R30,1
	MOVW R16,R30
; 0000 00C0                 while(shouldContinue){
_0x5D:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x5F
; 0000 00C1                     if (key==0){
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x60
; 0000 00C2                         key=9;
	__GETWRN 16,17,9
; 0000 00C3                     }
; 0000 00C4                     switch(key)
_0x60:
	CALL SUBOPT_0x8
; 0000 00C5                     {
; 0000 00C6                       case 1:
	BRNE _0x64
; 0000 00C7                         if (gled1 || rled1){
	SBIC 0x15,0
	RJMP _0x66
	SBIS 0x12,0
	RJMP _0x65
_0x66:
; 0000 00C8                             key--;
	__SUBWRN 16,17,1
; 0000 00C9                             break;
	RJMP _0x63
; 0000 00CA                         }
; 0000 00CB                         check_key(key);
_0x65:
	CALL SUBOPT_0x9
; 0000 00CC                         shouldContinue = 0;
; 0000 00CD                         delay_ms(700);
; 0000 00CE                         gled1=1;
	SBI  0x15,0
; 0000 00CF                         break;
	RJMP _0x63
; 0000 00D0                       case 2:
_0x64:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6A
; 0000 00D1                         if (gled2 || rled2){
	SBIC 0x15,1
	RJMP _0x6C
	SBIS 0x12,1
	RJMP _0x6B
_0x6C:
; 0000 00D2                             key--;
	__SUBWRN 16,17,1
; 0000 00D3                             break;
	RJMP _0x63
; 0000 00D4                         }
; 0000 00D5                         check_key(key);
_0x6B:
	CALL SUBOPT_0x9
; 0000 00D6                         shouldContinue = 0;
; 0000 00D7                         delay_ms(700);
; 0000 00D8                         gled2=1;
	SBI  0x15,1
; 0000 00D9                         break;
	RJMP _0x63
; 0000 00DA                       case 3:
_0x6A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x70
; 0000 00DB                         if (gled3 || rled3){
	SBIC 0x15,2
	RJMP _0x72
	SBIS 0x12,2
	RJMP _0x71
_0x72:
; 0000 00DC                             key--;
	__SUBWRN 16,17,1
; 0000 00DD                             break;
	RJMP _0x63
; 0000 00DE                         }
; 0000 00DF                         check_key(key);
_0x71:
	CALL SUBOPT_0x9
; 0000 00E0                         shouldContinue = 0;
; 0000 00E1                         delay_ms(700);
; 0000 00E2                         gled3=1;
	SBI  0x15,2
; 0000 00E3                         break;
	RJMP _0x63
; 0000 00E4                       case 4:
_0x70:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x76
; 0000 00E5                         if (gled4 || rled4) {
	SBIC 0x15,3
	RJMP _0x78
	SBIS 0x12,3
	RJMP _0x77
_0x78:
; 0000 00E6                             key--;
	__SUBWRN 16,17,1
; 0000 00E7                             break;
	RJMP _0x63
; 0000 00E8                         }
; 0000 00E9                         check_key(key);
_0x77:
	CALL SUBOPT_0x9
; 0000 00EA                         shouldContinue = 0;
; 0000 00EB                         delay_ms(700);
; 0000 00EC                         gled4=1;
	SBI  0x15,3
; 0000 00ED                         break;
	RJMP _0x63
; 0000 00EE                       case 5:
_0x76:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x7C
; 0000 00EF                         if (gled5 || rled5) {
	SBIC 0x15,4
	RJMP _0x7E
	SBIS 0x12,4
	RJMP _0x7D
_0x7E:
; 0000 00F0                             key--;
	__SUBWRN 16,17,1
; 0000 00F1                             break;
	RJMP _0x63
; 0000 00F2                         }
; 0000 00F3                         check_key(key);
_0x7D:
	CALL SUBOPT_0x9
; 0000 00F4                         shouldContinue = 0;
; 0000 00F5                         delay_ms(700);
; 0000 00F6                         gled5=1;
	SBI  0x15,4
; 0000 00F7                         break;
	RJMP _0x63
; 0000 00F8                       case 6:
_0x7C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x82
; 0000 00F9                         if (gled6 || rled6) {
	SBIC 0x15,5
	RJMP _0x84
	SBIS 0x12,5
	RJMP _0x83
_0x84:
; 0000 00FA                             key--;
	__SUBWRN 16,17,1
; 0000 00FB                             break;
	RJMP _0x63
; 0000 00FC                         }
; 0000 00FD                         check_key(key);
_0x83:
	CALL SUBOPT_0x9
; 0000 00FE                         shouldContinue = 0;
; 0000 00FF                         delay_ms(700);
; 0000 0100                         gled6=1;
	SBI  0x15,5
; 0000 0101                         break;
	RJMP _0x63
; 0000 0102                       case 7:
_0x82:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x88
; 0000 0103                         if (gled7 || rled7) {
	SBIC 0x15,6
	RJMP _0x8A
	SBIS 0x12,6
	RJMP _0x89
_0x8A:
; 0000 0104                             key--;
	__SUBWRN 16,17,1
; 0000 0105                             break;
	RJMP _0x63
; 0000 0106                         }
; 0000 0107                         check_key(key);
_0x89:
	CALL SUBOPT_0x9
; 0000 0108                         shouldContinue = 0;
; 0000 0109                         delay_ms(700);
; 0000 010A                         gled7=1;
	SBI  0x15,6
; 0000 010B                         break;
	RJMP _0x63
; 0000 010C                       case 8:
_0x88:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x8E
; 0000 010D                         if (gled8 || rled8) {
	SBIC 0x15,7
	RJMP _0x90
	SBIS 0x12,7
	RJMP _0x8F
_0x90:
; 0000 010E                             key--;
	__SUBWRN 16,17,1
; 0000 010F                             break;
	RJMP _0x63
; 0000 0110                         }
; 0000 0111                         check_key(key);
_0x8F:
	CALL SUBOPT_0x9
; 0000 0112                         shouldContinue = 0;
; 0000 0113                         delay_ms(700);
; 0000 0114                         gled8=1;
	SBI  0x15,7
; 0000 0115                         break;
	RJMP _0x63
; 0000 0116                       case 9:
_0x8E:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x63
; 0000 0117                         if (gled9 || rled9) {
	SBIC 0x18,6
	RJMP _0x96
	SBIS 0x18,7
	RJMP _0x95
_0x96:
; 0000 0118                             key--;
	__SUBWRN 16,17,1
; 0000 0119                             break;
	RJMP _0x63
; 0000 011A                         }
; 0000 011B                         check_key(key);
_0x95:
	CALL SUBOPT_0x9
; 0000 011C                         shouldContinue = 0;
; 0000 011D                         delay_ms(700);
; 0000 011E                         gled9=1;
	SBI  0x18,6
; 0000 011F                         break;
; 0000 0120                     }
_0x63:
; 0000 0121 
; 0000 0122                 }
	RJMP _0x5D
_0x5F:
; 0000 0123 
; 0000 0124             } else {
	ADIW R28,2
	RJMP _0x9A
_0x5C:
; 0000 0125                  switch(key)
	CALL SUBOPT_0x8
; 0000 0126                  {
; 0000 0127                   case 1:gled1=1;break;
	BRNE _0x9E
	SBI  0x15,0
	RJMP _0x9D
; 0000 0128                   case 2:gled2=1;break;
_0x9E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA1
	SBI  0x15,1
	RJMP _0x9D
; 0000 0129                   case 3:gled3=1;break;
_0xA1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA4
	SBI  0x15,2
	RJMP _0x9D
; 0000 012A                   case 4:gled4=1;break;
_0xA4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xA7
	SBI  0x15,3
	RJMP _0x9D
; 0000 012B                   case 5:gled5=1;break;
_0xA7:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xAA
	SBI  0x15,4
	RJMP _0x9D
; 0000 012C                   case 6:gled6=1;break;
_0xAA:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xAD
	SBI  0x15,5
	RJMP _0x9D
; 0000 012D                   case 7:gled7=1;break;
_0xAD:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB0
	SBI  0x15,6
	RJMP _0x9D
; 0000 012E                   case 8:gled8=1;break;
_0xB0:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB3
	SBI  0x15,7
	RJMP _0x9D
; 0000 012F                   case 9:gled9=1;break;
_0xB3:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x9D
	SBI  0x18,6
; 0000 0130                  }
_0x9D:
; 0000 0131             }
_0x9A:
; 0000 0132         }
; 0000 0133        else {
	RJMP _0xB9
_0x5B:
; 0000 0134             switch(key)
	CALL SUBOPT_0x8
; 0000 0135              {
; 0000 0136               case 1:rled1=1;break;
	BRNE _0xBD
	SBI  0x12,0
	RJMP _0xBC
; 0000 0137               case 2:rled2=1;break;
_0xBD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC0
	SBI  0x12,1
	RJMP _0xBC
; 0000 0138               case 3:rled3=1;break;
_0xC0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC3
	SBI  0x12,2
	RJMP _0xBC
; 0000 0139               case 4:rled4=1;break;
_0xC3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC6
	SBI  0x12,3
	RJMP _0xBC
; 0000 013A               case 5:rled5=1;break;
_0xC6:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC9
	SBI  0x12,4
	RJMP _0xBC
; 0000 013B               case 6:rled6=1;break;
_0xC9:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xCC
	SBI  0x12,5
	RJMP _0xBC
; 0000 013C               case 7:rled7=1;break;
_0xCC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xCF
	SBI  0x12,6
	RJMP _0xBC
; 0000 013D               case 8:rled8=1;break;
_0xCF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xD2
	SBI  0x12,7
	RJMP _0xBC
; 0000 013E               case 9:rled9=1;break;
_0xD2:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xBC
	SBI  0x18,7
; 0000 013F              }
_0xBC:
; 0000 0140         }
_0xB9:
; 0000 0141        //---------------------------------
; 0000 0142        if(gled1&&gled2&&gled3)
	SBIS 0x15,0
	RJMP _0xD9
	SBIS 0x15,1
	RJMP _0xD9
	SBIC 0x15,2
	RJMP _0xDA
_0xD9:
	RJMP _0xD8
_0xDA:
; 0000 0143         {
; 0000 0144         p1++;
	CALL SUBOPT_0xA
; 0000 0145         lcd_clear();
; 0000 0146         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,34
	CALL SUBOPT_0xB
; 0000 0147 
; 0000 0148         delay_ms(300);
; 0000 0149         gled1=0;
	CALL SUBOPT_0xC
; 0000 014A         gled2=0;
; 0000 014B         gled3=0;
; 0000 014C         delay_ms(300);
; 0000 014D         gled1=1;
; 0000 014E         gled2=1;
; 0000 014F         gled3=1;
; 0000 0150         delay_ms(300);
; 0000 0151         gled1=0;
	CALL SUBOPT_0xC
; 0000 0152         gled2=0;
; 0000 0153         gled3=0;
; 0000 0154         delay_ms(300);
; 0000 0155         gled1=1;
; 0000 0156         gled2=1;
; 0000 0157         gled3=1;
; 0000 0158         delay_ms(300);
; 0000 0159 
; 0000 015A         clear();
	RCALL _clear
; 0000 015B         break;
	RJMP _0x52
; 0000 015C         }
; 0000 015D        else if(gled4&&gled5&&gled6)
_0xD8:
	SBIS 0x15,3
	RJMP _0xF5
	SBIS 0x15,4
	RJMP _0xF5
	SBIC 0x15,5
	RJMP _0xF6
_0xF5:
	RJMP _0xF4
_0xF6:
; 0000 015E         {
; 0000 015F         p1++;
	CALL SUBOPT_0xA
; 0000 0160         lcd_clear();
; 0000 0161         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,54
	CALL SUBOPT_0xB
; 0000 0162 
; 0000 0163         delay_ms(300);
; 0000 0164         gled4=0;
	CALL SUBOPT_0xD
; 0000 0165         gled5=0;
; 0000 0166         gled6=0;
; 0000 0167         delay_ms(300);
; 0000 0168         gled4=1;
; 0000 0169         gled5=1;
; 0000 016A         gled6=1;
; 0000 016B         delay_ms(300);
; 0000 016C         gled4=0;
	CALL SUBOPT_0xD
; 0000 016D         gled5=0;
; 0000 016E         gled6=0;
; 0000 016F         delay_ms(300);
; 0000 0170         gled4=1;
; 0000 0171         gled5=1;
; 0000 0172         gled6=1;
; 0000 0173         delay_ms(300);
; 0000 0174 
; 0000 0175         clear();
	RCALL _clear
; 0000 0176         break;
	RJMP _0x52
; 0000 0177         }
; 0000 0178        else if(gled7&&gled8&&gled9)
_0xF4:
	SBIS 0x15,6
	RJMP _0x111
	SBIS 0x15,7
	RJMP _0x111
	SBIC 0x18,6
	RJMP _0x112
_0x111:
	RJMP _0x110
_0x112:
; 0000 0179         {
; 0000 017A         p1++;
	CALL SUBOPT_0xA
; 0000 017B         lcd_clear();
; 0000 017C         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,74
	CALL SUBOPT_0xB
; 0000 017D 
; 0000 017E         delay_ms(300);
; 0000 017F         gled7=0;
	CALL SUBOPT_0xE
; 0000 0180         gled8=0;
; 0000 0181         gled9=0;
; 0000 0182         delay_ms(300);
; 0000 0183         gled7=1;
; 0000 0184         gled8=1;
; 0000 0185         gled9=1;
; 0000 0186         delay_ms(300);
; 0000 0187         gled7=0;
	CALL SUBOPT_0xE
; 0000 0188         gled8=0;
; 0000 0189         gled9=0;
; 0000 018A         delay_ms(300);
; 0000 018B         gled7=1;
; 0000 018C         gled8=1;
; 0000 018D         gled9=1;
; 0000 018E         delay_ms(300);
; 0000 018F 
; 0000 0190         clear();
	RCALL _clear
; 0000 0191         break;
	RJMP _0x52
; 0000 0192         }
; 0000 0193        else if(gled1&&gled4&&gled7)
_0x110:
	SBIS 0x15,0
	RJMP _0x12D
	SBIS 0x15,3
	RJMP _0x12D
	SBIC 0x15,6
	RJMP _0x12E
_0x12D:
	RJMP _0x12C
_0x12E:
; 0000 0194         {
; 0000 0195         p1++;
	CALL SUBOPT_0xA
; 0000 0196         lcd_clear();
; 0000 0197         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,94
	CALL SUBOPT_0xB
; 0000 0198 
; 0000 0199         delay_ms(300);
; 0000 019A         gled1=0;
	CALL SUBOPT_0xF
; 0000 019B         gled4=0;
; 0000 019C         gled7=0;
; 0000 019D         delay_ms(300);
; 0000 019E         gled1=1;
; 0000 019F         gled4=1;
; 0000 01A0         gled7=1;
; 0000 01A1         delay_ms(300);
; 0000 01A2         gled1=0;
	CALL SUBOPT_0xF
; 0000 01A3         gled4=0;
; 0000 01A4         gled7=0;
; 0000 01A5         delay_ms(300);
; 0000 01A6         gled1=1;
; 0000 01A7         gled4=1;
; 0000 01A8         gled7=1;
; 0000 01A9         delay_ms(300);
; 0000 01AA 
; 0000 01AB         clear();
	RCALL _clear
; 0000 01AC         break;
	RJMP _0x52
; 0000 01AD         }
; 0000 01AE        else if(gled2&&gled5&&gled8)
_0x12C:
	SBIS 0x15,1
	RJMP _0x149
	SBIS 0x15,4
	RJMP _0x149
	SBIC 0x15,7
	RJMP _0x14A
_0x149:
	RJMP _0x148
_0x14A:
; 0000 01AF         {
; 0000 01B0         p1++;
	CALL SUBOPT_0xA
; 0000 01B1         lcd_clear();
; 0000 01B2         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,114
	CALL SUBOPT_0xB
; 0000 01B3 
; 0000 01B4         delay_ms(300);
; 0000 01B5         gled2=0;
	CALL SUBOPT_0x10
; 0000 01B6         gled5=0;
; 0000 01B7         gled8=0;
; 0000 01B8         delay_ms(300);
; 0000 01B9         gled2=1;
; 0000 01BA         gled5=1;
; 0000 01BB         gled8=1;
; 0000 01BC         delay_ms(300);
; 0000 01BD         gled2=0;
	CALL SUBOPT_0x10
; 0000 01BE         gled5=0;
; 0000 01BF         gled8=0;
; 0000 01C0         delay_ms(300);
; 0000 01C1         gled2=1;
; 0000 01C2         gled5=1;
; 0000 01C3         gled8=1;
; 0000 01C4         delay_ms(300);
; 0000 01C5 
; 0000 01C6         clear();
	RCALL _clear
; 0000 01C7         break;
	RJMP _0x52
; 0000 01C8         }
; 0000 01C9        else if(gled3&&gled6&&gled9)
_0x148:
	SBIS 0x15,2
	RJMP _0x165
	SBIS 0x15,5
	RJMP _0x165
	SBIC 0x18,6
	RJMP _0x166
_0x165:
	RJMP _0x164
_0x166:
; 0000 01CA         {
; 0000 01CB         p1++;
	CALL SUBOPT_0xA
; 0000 01CC         lcd_clear();
; 0000 01CD         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,134
	CALL SUBOPT_0xB
; 0000 01CE 
; 0000 01CF         delay_ms(300);
; 0000 01D0         gled3=0;
	CALL SUBOPT_0x11
; 0000 01D1         gled6=0;
; 0000 01D2         gled9=0;
; 0000 01D3         delay_ms(300);
; 0000 01D4         gled3=1;
; 0000 01D5         gled6=1;
; 0000 01D6         gled9=1;
; 0000 01D7         delay_ms(300);
; 0000 01D8         gled3=0;
	CALL SUBOPT_0x11
; 0000 01D9         gled6=0;
; 0000 01DA         gled9=0;
; 0000 01DB         delay_ms(300);
; 0000 01DC         gled3=1;
; 0000 01DD         gled6=1;
; 0000 01DE         gled9=1;
; 0000 01DF         delay_ms(300);
; 0000 01E0 
; 0000 01E1         clear();
	RCALL _clear
; 0000 01E2         break;
	RJMP _0x52
; 0000 01E3         }
; 0000 01E4         else if(gled1&&gled5&&gled9)
_0x164:
	SBIS 0x15,0
	RJMP _0x181
	SBIS 0x15,4
	RJMP _0x181
	SBIC 0x18,6
	RJMP _0x182
_0x181:
	RJMP _0x180
_0x182:
; 0000 01E5         {
; 0000 01E6         p1++;
	CALL SUBOPT_0xA
; 0000 01E7         lcd_clear();
; 0000 01E8         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,154
	CALL SUBOPT_0xB
; 0000 01E9 
; 0000 01EA         delay_ms(300);
; 0000 01EB         gled1=0;
	CALL SUBOPT_0x12
; 0000 01EC         gled5=0;
; 0000 01ED         gled9=0;
; 0000 01EE         delay_ms(300);
; 0000 01EF         gled1=1;
; 0000 01F0         gled5=1;
; 0000 01F1         gled9=1;
; 0000 01F2         delay_ms(300);
; 0000 01F3         gled1=0;
	CALL SUBOPT_0x12
; 0000 01F4         gled5=0;
; 0000 01F5         gled9=0;
; 0000 01F6         delay_ms(300);
; 0000 01F7         gled1=1;
; 0000 01F8         gled5=1;
; 0000 01F9         gled9=1;
; 0000 01FA         delay_ms(300);
; 0000 01FB 
; 0000 01FC         clear();
	RCALL _clear
; 0000 01FD         break;
	RJMP _0x52
; 0000 01FE         }
; 0000 01FF        else if(gled3&&gled5&&gled7)
_0x180:
	SBIS 0x15,2
	RJMP _0x19D
	SBIS 0x15,4
	RJMP _0x19D
	SBIC 0x15,6
	RJMP _0x19E
_0x19D:
	RJMP _0x19C
_0x19E:
; 0000 0200         {
; 0000 0201         p1++;
	CALL SUBOPT_0xA
; 0000 0202         lcd_clear();
; 0000 0203         lcd_puts("Player GREEN Win..!");
	__POINTW2MN _0x54,174
	CALL SUBOPT_0xB
; 0000 0204 
; 0000 0205         delay_ms(300);
; 0000 0206         gled3=0;
	CALL SUBOPT_0x13
; 0000 0207         gled5=0;
; 0000 0208         gled7=0;
; 0000 0209         delay_ms(300);
; 0000 020A         gled3=1;
; 0000 020B         gled5=1;
; 0000 020C         gled7=1;
; 0000 020D         delay_ms(300);
; 0000 020E         gled3=0;
	CALL SUBOPT_0x13
; 0000 020F         gled5=0;
; 0000 0210         gled7=0;
; 0000 0211         delay_ms(300);
; 0000 0212         gled3=1;
; 0000 0213         gled5=1;
; 0000 0214         gled7=1;
; 0000 0215         delay_ms(300);
; 0000 0216 
; 0000 0217         clear();
	RCALL _clear
; 0000 0218         break;
	RJMP _0x52
; 0000 0219         }
; 0000 021A        //-------------------------------------------------
; 0000 021B        if(rled1&&rled2&&rled3)
_0x19C:
	SBIS 0x12,0
	RJMP _0x1B8
	SBIS 0x12,1
	RJMP _0x1B8
	SBIC 0x12,2
	RJMP _0x1B9
_0x1B8:
	RJMP _0x1B7
_0x1B9:
; 0000 021C         {
; 0000 021D         p2++;
	CALL SUBOPT_0x14
; 0000 021E         lcd_clear();
; 0000 021F         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,194
	CALL SUBOPT_0xB
; 0000 0220 
; 0000 0221 
; 0000 0222         delay_ms(300);
; 0000 0223         rled1=0;
	CALL SUBOPT_0x15
; 0000 0224         rled2=0;
; 0000 0225         rled3=0;
; 0000 0226         delay_ms(300);
; 0000 0227         rled1=1;
; 0000 0228         rled2=1;
; 0000 0229         rled3=1;
; 0000 022A         delay_ms(300);
; 0000 022B         rled1=0;
	CALL SUBOPT_0x15
; 0000 022C         rled2=0;
; 0000 022D         rled3=0;
; 0000 022E         delay_ms(300);
; 0000 022F         rled1=1;
; 0000 0230         rled2=1;
; 0000 0231         rled3=1;
; 0000 0232         delay_ms(300);
; 0000 0233 
; 0000 0234         clear();
	RCALL _clear
; 0000 0235         break;
	RJMP _0x52
; 0000 0236         }
; 0000 0237        else if(rled4&&rled5&&rled6)
_0x1B7:
	SBIS 0x12,3
	RJMP _0x1D4
	SBIS 0x12,4
	RJMP _0x1D4
	SBIC 0x12,5
	RJMP _0x1D5
_0x1D4:
	RJMP _0x1D3
_0x1D5:
; 0000 0238         {
; 0000 0239         p2++;
	CALL SUBOPT_0x14
; 0000 023A         lcd_clear();
; 0000 023B         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,212
	CALL SUBOPT_0xB
; 0000 023C 
; 0000 023D         delay_ms(300);
; 0000 023E         rled4=0;
	CALL SUBOPT_0x16
; 0000 023F         rled5=0;
; 0000 0240         rled6=0;
; 0000 0241         delay_ms(300);
; 0000 0242         rled4=1;
; 0000 0243         rled5=1;
; 0000 0244         rled6=1;
; 0000 0245         delay_ms(300);
; 0000 0246         rled4=0;
	CALL SUBOPT_0x16
; 0000 0247         rled5=0;
; 0000 0248         rled6=0;
; 0000 0249         delay_ms(300);
; 0000 024A         rled4=1;
; 0000 024B         rled5=1;
; 0000 024C         rled6=1;
; 0000 024D         delay_ms(300);
; 0000 024E 
; 0000 024F         clear();
	RCALL _clear
; 0000 0250         break;
	RJMP _0x52
; 0000 0251         }
; 0000 0252        else if(rled7&&rled8&&rled9)
_0x1D3:
	SBIS 0x12,6
	RJMP _0x1F0
	SBIS 0x12,7
	RJMP _0x1F0
	SBIC 0x18,7
	RJMP _0x1F1
_0x1F0:
	RJMP _0x1EF
_0x1F1:
; 0000 0253         {
; 0000 0254         p2++;
	CALL SUBOPT_0x14
; 0000 0255         lcd_clear();
; 0000 0256         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,230
	CALL SUBOPT_0xB
; 0000 0257 
; 0000 0258         delay_ms(300);
; 0000 0259         rled7=0;
	CALL SUBOPT_0x17
; 0000 025A         rled8=0;
; 0000 025B         rled9=0;
; 0000 025C         delay_ms(300);
; 0000 025D         rled7=1;
; 0000 025E         rled8=1;
; 0000 025F         rled9=1;
; 0000 0260         delay_ms(300);
; 0000 0261         rled7=0;
	CALL SUBOPT_0x17
; 0000 0262         rled8=0;
; 0000 0263         rled9=0;
; 0000 0264         delay_ms(300);
; 0000 0265         rled7=1;
; 0000 0266         rled8=1;
; 0000 0267         rled9=1;
; 0000 0268         delay_ms(300);
; 0000 0269 
; 0000 026A         clear();
	RCALL _clear
; 0000 026B         break;
	RJMP _0x52
; 0000 026C         }
; 0000 026D        else if(rled1&&rled4&&rled7)
_0x1EF:
	SBIS 0x12,0
	RJMP _0x20C
	SBIS 0x12,3
	RJMP _0x20C
	SBIC 0x12,6
	RJMP _0x20D
_0x20C:
	RJMP _0x20B
_0x20D:
; 0000 026E         {
; 0000 026F         p2++;
	CALL SUBOPT_0x14
; 0000 0270         lcd_clear();
; 0000 0271         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,248
	CALL SUBOPT_0xB
; 0000 0272 
; 0000 0273         delay_ms(300);
; 0000 0274         rled1=0;
	CALL SUBOPT_0x18
; 0000 0275         rled4=0;
; 0000 0276         rled7=0;
; 0000 0277         delay_ms(300);
; 0000 0278         rled1=1;
; 0000 0279         rled4=1;
; 0000 027A         rled7=1;
; 0000 027B         delay_ms(300);
; 0000 027C         rled1=0;
	CALL SUBOPT_0x18
; 0000 027D         rled4=0;
; 0000 027E         rled7=0;
; 0000 027F         delay_ms(300);
; 0000 0280         rled1=1;
; 0000 0281         rled4=1;
; 0000 0282         rled7=1;
; 0000 0283         delay_ms(300);
; 0000 0284 
; 0000 0285         clear();
	RCALL _clear
; 0000 0286         break;
	RJMP _0x52
; 0000 0287         }
; 0000 0288        else if(rled2&&rled5&&rled8)
_0x20B:
	SBIS 0x12,1
	RJMP _0x228
	SBIS 0x12,4
	RJMP _0x228
	SBIC 0x12,7
	RJMP _0x229
_0x228:
	RJMP _0x227
_0x229:
; 0000 0289         {
; 0000 028A         p2++;
	CALL SUBOPT_0x14
; 0000 028B         lcd_clear();
; 0000 028C         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,266
	CALL SUBOPT_0xB
; 0000 028D 
; 0000 028E         delay_ms(300);
; 0000 028F         rled2=0;
	CALL SUBOPT_0x19
; 0000 0290         rled5=0;
; 0000 0291         rled8=0;
; 0000 0292         delay_ms(300);
; 0000 0293         rled2=1;
; 0000 0294         rled5=1;
; 0000 0295         rled8=1;
; 0000 0296         delay_ms(300);
; 0000 0297         rled2=0;
	CALL SUBOPT_0x19
; 0000 0298         rled5=0;
; 0000 0299         rled8=0;
; 0000 029A         delay_ms(300);
; 0000 029B         rled2=1;
; 0000 029C         rled5=1;
; 0000 029D         rled8=1;
; 0000 029E         delay_ms(300);
; 0000 029F 
; 0000 02A0         clear();
	RCALL _clear
; 0000 02A1         break;
	RJMP _0x52
; 0000 02A2         }
; 0000 02A3        else if(rled3&&rled6&&rled9)
_0x227:
	SBIS 0x12,2
	RJMP _0x244
	SBIS 0x12,5
	RJMP _0x244
	SBIC 0x18,7
	RJMP _0x245
_0x244:
	RJMP _0x243
_0x245:
; 0000 02A4         {
; 0000 02A5         p2++;
	CALL SUBOPT_0x14
; 0000 02A6         lcd_clear();
; 0000 02A7         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,284
	CALL SUBOPT_0xB
; 0000 02A8 
; 0000 02A9         delay_ms(300);
; 0000 02AA         rled3=0;
	CALL SUBOPT_0x1A
; 0000 02AB         rled6=0;
; 0000 02AC         rled9=0;
; 0000 02AD         delay_ms(300);
; 0000 02AE         rled3=1;
; 0000 02AF         rled6=1;
; 0000 02B0         rled9=1;
; 0000 02B1         delay_ms(300);
; 0000 02B2         rled3=0;
	CALL SUBOPT_0x1A
; 0000 02B3         rled6=0;
; 0000 02B4         rled9=0;
; 0000 02B5         delay_ms(300);
; 0000 02B6         rled3=1;
; 0000 02B7         rled6=1;
; 0000 02B8         rled9=1;
; 0000 02B9         delay_ms(300);
; 0000 02BA 
; 0000 02BB         clear();
	RCALL _clear
; 0000 02BC         break;
	RJMP _0x52
; 0000 02BD         }
; 0000 02BE        else if(rled1&&rled5&&rled9)
_0x243:
	SBIS 0x12,0
	RJMP _0x260
	SBIS 0x12,4
	RJMP _0x260
	SBIC 0x18,7
	RJMP _0x261
_0x260:
	RJMP _0x25F
_0x261:
; 0000 02BF         {
; 0000 02C0         p2++;
	CALL SUBOPT_0x14
; 0000 02C1         lcd_clear();
; 0000 02C2         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,302
	CALL SUBOPT_0xB
; 0000 02C3 
; 0000 02C4         delay_ms(300);
; 0000 02C5         rled1=0;
	CALL SUBOPT_0x1B
; 0000 02C6         rled5=0;
; 0000 02C7         rled9=0;
; 0000 02C8         delay_ms(300);
; 0000 02C9         rled1=1;
; 0000 02CA         rled5=1;
; 0000 02CB         rled9=1;
; 0000 02CC         delay_ms(300);
; 0000 02CD         rled1=0;
	CALL SUBOPT_0x1B
; 0000 02CE         rled5=0;
; 0000 02CF         rled9=0;
; 0000 02D0         delay_ms(300);
; 0000 02D1         rled1=1;
; 0000 02D2         rled5=1;
; 0000 02D3         rled9=1;
; 0000 02D4         delay_ms(300);
; 0000 02D5 
; 0000 02D6         clear();
	RCALL _clear
; 0000 02D7         break;
	RJMP _0x52
; 0000 02D8         }
; 0000 02D9        else if(rled7&&rled5&&rled3)
_0x25F:
	SBIS 0x12,6
	RJMP _0x27C
	SBIS 0x12,4
	RJMP _0x27C
	SBIC 0x12,2
	RJMP _0x27D
_0x27C:
	RJMP _0x27B
_0x27D:
; 0000 02DA         {
; 0000 02DB         p2++;
	CALL SUBOPT_0x14
; 0000 02DC         lcd_clear();
; 0000 02DD         lcd_puts("Player RED Win..!");
	__POINTW2MN _0x54,320
	CALL SUBOPT_0xB
; 0000 02DE 
; 0000 02DF         delay_ms(300);
; 0000 02E0         rled7=0;
	CALL SUBOPT_0x1C
; 0000 02E1         rled5=0;
; 0000 02E2         rled3=0;
; 0000 02E3         delay_ms(300);
; 0000 02E4         rled7=1;
; 0000 02E5         rled5=1;
; 0000 02E6         rled3=1;
; 0000 02E7         delay_ms(300);
; 0000 02E8         rled7=0;
	CALL SUBOPT_0x1C
; 0000 02E9         rled5=0;
; 0000 02EA         rled3=0;
; 0000 02EB         delay_ms(300);
; 0000 02EC         rled7=1;
; 0000 02ED         rled5=1;
; 0000 02EE         rled3=1;
; 0000 02EF         delay_ms(300);
; 0000 02F0 
; 0000 02F1         clear();
	RCALL _clear
; 0000 02F2         break;
	RJMP _0x52
; 0000 02F3         }
; 0000 02F4 
; 0000 02F5        //-------------------------------------------------
; 0000 02F6 
; 0000 02F7        player=~player;
_0x27B:
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 02F8        if(c==9)
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x296
; 0000 02F9         {
; 0000 02FA         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 02FB         lcd_gotoxy(0,1);
	CALL SUBOPT_0x7
; 0000 02FC         lcd_puts("Reseting...");
	__POINTW2MN _0x54,338
	RCALL _lcd_puts
; 0000 02FD         clear();
	RCALL _clear
; 0000 02FE         }
; 0000 02FF        }
_0x296:
; 0000 0300 
; 0000 0301       }
_0x5A:
	RJMP _0x50
_0x52:
; 0000 0302  player=~player;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 0303  }
	__ADDWRN 18,19,1
	RJMP _0x4E
_0x4F:
; 0000 0304 
; 0000 0305 lcd_clear();
	CALL SUBOPT_0x4
; 0000 0306 sprintf(lcd_b,"Player GREEN: %d", p1);
	__POINTW1FN _0x0,106
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	CALL SUBOPT_0x5
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0307 lcd_gotoxy(0,0);
	CALL SUBOPT_0x6
; 0000 0308 lcd_puts(lcd_b);
; 0000 0309 sprintf(lcd_b, "Player RED: %d", p2);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,123
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	CALL SUBOPT_0x5
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 030A lcd_gotoxy(0,1);
	CALL SUBOPT_0x7
; 0000 030B lcd_puts(lcd_b);
	MOVW R26,R28
	ADIW R26,2
	RCALL _lcd_puts
; 0000 030C 
; 0000 030D }
	ADIW R28,36
_0x297:
	RJMP _0x297
; .FEND

	.DSEG
_0x54:
	.BYTE 0x15E
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20C0002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R7,Y+1
	LDD  R6,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1D
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1D
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R7,R9
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	MOV  R26,R6
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0002
_0x2000007:
_0x2000004:
	INC  R7
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x1F
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x1F
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x20
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x21
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x1F
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x21
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x21
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x24
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x24
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG
_rand:
; .FSTART _rand
	LDS  R30,__seed_G102
	LDS  R31,__seed_G102+1
	LDS  R22,__seed_G102+2
	LDS  R23,__seed_G102+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G102,R30
	STS  __seed_G102+1,R31
	STS  __seed_G102+2,R22
	STS  __seed_G102+3,R23
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG
_pressed:
	.BYTE 0x12
__base_y_G100:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	MOVW R30,R16
	LDI  R26,LOW(_pressed)
	LDI  R27,HIGH(_pressed)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL _lcd_clear
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	MOVW R26,R28
	ADIW R26,2
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MOVW R30,R16
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x9:
	MOVW R26,R16
	CALL _check_key
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	__ADDWRN 20,21,1
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xB:
	CALL _lcd_puts
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	CBI  0x15,0
	CBI  0x15,1
	CBI  0x15,2
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,0
	SBI  0x15,1
	SBI  0x15,2
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	CBI  0x15,3
	CBI  0x15,4
	CBI  0x15,5
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,3
	SBI  0x15,4
	SBI  0x15,5
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	CBI  0x15,6
	CBI  0x15,7
	CBI  0x18,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,6
	SBI  0x15,7
	SBI  0x18,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	CBI  0x15,0
	CBI  0x15,3
	CBI  0x15,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,0
	SBI  0x15,3
	SBI  0x15,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	CBI  0x15,1
	CBI  0x15,4
	CBI  0x15,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,1
	SBI  0x15,4
	SBI  0x15,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	CBI  0x15,2
	CBI  0x15,5
	CBI  0x18,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,2
	SBI  0x15,5
	SBI  0x18,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	CBI  0x15,0
	CBI  0x15,4
	CBI  0x18,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,0
	SBI  0x15,4
	SBI  0x18,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	CBI  0x15,2
	CBI  0x15,4
	CBI  0x15,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x15,2
	SBI  0x15,4
	SBI  0x15,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x14:
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	ADIW R30,1
	STD  Y+34,R30
	STD  Y+34+1,R31
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	CBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,0
	SBI  0x12,1
	SBI  0x12,2
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	CBI  0x12,3
	CBI  0x12,4
	CBI  0x12,5
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,3
	SBI  0x12,4
	SBI  0x12,5
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	CBI  0x12,6
	CBI  0x12,7
	CBI  0x18,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,6
	SBI  0x12,7
	SBI  0x18,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	CBI  0x12,0
	CBI  0x12,3
	CBI  0x12,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,0
	SBI  0x12,3
	SBI  0x12,6
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	CBI  0x12,1
	CBI  0x12,4
	CBI  0x12,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,1
	SBI  0x12,4
	SBI  0x12,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	CBI  0x12,2
	CBI  0x12,5
	CBI  0x18,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,2
	SBI  0x12,5
	SBI  0x18,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	CBI  0x12,0
	CBI  0x12,4
	CBI  0x18,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,0
	SBI  0x12,4
	SBI  0x18,7
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	CBI  0x12,6
	CBI  0x12,4
	CBI  0x12,2
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
	SBI  0x12,6
	SBI  0x12,4
	SBI  0x12,2
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
