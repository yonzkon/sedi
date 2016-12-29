#ifndef _SYS_ELF_RELOCS_H
#define _SYS_ELF_RELOCS_H

/* Intel 80386 specific definitions.  */

/* i386 relocs.  */

#define R_386_NONE	   0		/* No reloc */
#define R_386_32	   1		/* Direct 32 bit  */
#define R_386_PC32	   2		/* PC relative 32 bit */
#define R_386_GOT32	   3		/* 32 bit GOT entry */
#define R_386_PLT32	   4		/* 32 bit PLT address */
#define R_386_COPY	   5		/* Copy symbol at runtime */
#define R_386_GLOB_DAT	   6		/* Create GOT entry */
#define R_386_JMP_SLOT	   7		/* Create PLT entry */
#define R_386_RELATIVE	   8		/* Adjust by program base */
#define R_386_GOTOFF	   9		/* 32 bit offset to GOT */
#define R_386_GOTPC	   10		/* 32 bit PC relative offset to GOT */
#define R_386_32PLT	   11
#define R_386_TLS_TPOFF	   14		/* Offset in static TLS block */
#define R_386_TLS_IE	   15		/* Address of GOT entry for static TLS
					   block offset */
#define R_386_TLS_GOTIE	   16		/* GOT entry for static TLS block
					   offset */
#define R_386_TLS_LE	   17		/* Offset relative to static TLS
					   block */
#define R_386_TLS_GD	   18		/* Direct 32 bit for GNU version of
					   general dynamic thread local data */
#define R_386_TLS_LDM	   19		/* Direct 32 bit for GNU version of
					   local dynamic thread local data
					   in LE code */
#define R_386_16	   20
#define R_386_PC16	   21
#define R_386_8		   22
#define R_386_PC8	   23
#define R_386_TLS_GD_32	   24		/* Direct 32 bit for general dynamic
					   thread local data */
#define R_386_TLS_GD_PUSH  25		/* Tag for pushl in GD TLS code */
#define R_386_TLS_GD_CALL  26		/* Relocation for call to
					   __tls_get_addr() */
#define R_386_TLS_GD_POP   27		/* Tag for popl in GD TLS code */
#define R_386_TLS_LDM_32   28		/* Direct 32 bit for local dynamic
					   thread local data in LE code */
#define R_386_TLS_LDM_PUSH 29		/* Tag for pushl in LDM TLS code */
#define R_386_TLS_LDM_CALL 30		/* Relocation for call to
					   __tls_get_addr() in LDM code */
#define R_386_TLS_LDM_POP  31		/* Tag for popl in LDM TLS code */
#define R_386_TLS_LDO_32   32		/* Offset relative to TLS block */
#define R_386_TLS_IE_32	   33		/* GOT entry for negated static TLS
					   block offset */
#define R_386_TLS_LE_32	   34		/* Negated offset relative to static
					   TLS block */
#define R_386_TLS_DTPMOD32 35		/* ID of module containing symbol */
#define R_386_TLS_DTPOFF32 36		/* Offset in TLS block */
#define R_386_TLS_TPOFF32  37		/* Negated offset in static TLS block */
#define R_386_SIZE32	   38 		/* 32-bit symbol size */
#define R_386_TLS_GOTDESC  39		/* GOT offset for TLS descriptor.  */
#define R_386_TLS_DESC_CALL 40		/* Marker of call through TLS
					   descriptor for
					   relaxation.  */
#define R_386_TLS_DESC     41		/* TLS descriptor containing
					   pointer to code and to
					   argument, returning the TLS
					   offset for the symbol.  */
#define R_386_IRELATIVE	   42		/* Adjust indirectly by program base */
/* Keep this the last entry.  */
#define R_386_NUM	   43

/* AMD x86-64 relocations.  */
#define R_X86_64_NONE		0	/* No reloc */
#define R_X86_64_64		1	/* Direct 64 bit  */
#define R_X86_64_PC32		2	/* PC relative 32 bit signed */
#define R_X86_64_GOT32		3	/* 32 bit GOT entry */
#define R_X86_64_PLT32		4	/* 32 bit PLT address */
#define R_X86_64_COPY		5	/* Copy symbol at runtime */
#define R_X86_64_GLOB_DAT	6	/* Create GOT entry */
#define R_X86_64_JUMP_SLOT	7	/* Create PLT entry */
#define R_X86_64_RELATIVE	8	/* Adjust by program base */
#define R_X86_64_GOTPCREL	9	/* 32 bit signed PC relative
					   offset to GOT */
#define R_X86_64_32		10	/* Direct 32 bit zero extended */
#define R_X86_64_32S		11	/* Direct 32 bit sign extended */
#define R_X86_64_16		12	/* Direct 16 bit zero extended */
#define R_X86_64_PC16		13	/* 16 bit sign extended pc relative */
#define R_X86_64_8		14	/* Direct 8 bit sign extended  */
#define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
#define R_X86_64_DTPMOD64	16	/* ID of module containing symbol */
#define R_X86_64_DTPOFF64	17	/* Offset in module's TLS block */
#define R_X86_64_TPOFF64	18	/* Offset in initial TLS block */
#define R_X86_64_TLSGD		19	/* 32 bit signed PC relative offset
					   to two GOT entries for GD symbol */
#define R_X86_64_TLSLD		20	/* 32 bit signed PC relative offset
					   to two GOT entries for LD symbol */
#define R_X86_64_DTPOFF32	21	/* Offset in TLS block */
#define R_X86_64_GOTTPOFF	22	/* 32 bit signed PC relative offset
					   to GOT entry for IE symbol */
#define R_X86_64_TPOFF32	23	/* Offset in initial TLS block */
#define R_X86_64_PC64		24	/* PC relative 64 bit */
#define R_X86_64_GOTOFF64	25	/* 64 bit offset to GOT */
#define R_X86_64_GOTPC32	26	/* 32 bit signed pc relative
					   offset to GOT */
#define R_X86_64_GOT64		27	/* 64-bit GOT entry offset */
#define R_X86_64_GOTPCREL64	28	/* 64-bit PC relative offset
					   to GOT entry */
#define R_X86_64_GOTPC64	29	/* 64-bit PC relative offset to GOT */
#define R_X86_64_GOTPLT64	30 	/* like GOT64, says PLT entry needed */
#define R_X86_64_PLTOFF64	31	/* 64-bit GOT relative offset
					   to PLT entry */
#define R_X86_64_SIZE32		32	/* Size of symbol plus 32-bit addend */
#define R_X86_64_SIZE64		33	/* Size of symbol plus 64-bit addend */
#define R_X86_64_GOTPC32_TLSDESC 34	/* GOT offset for TLS descriptor.  */
#define R_X86_64_TLSDESC_CALL   35	/* Marker for call through TLS
					   descriptor.  */
#define R_X86_64_TLSDESC        36	/* TLS descriptor.  */
#define R_X86_64_IRELATIVE	37	/* Adjust indirectly by program base */
#define R_X86_64_RELATIVE64	38	/* 64-bit adjust by program base */

#define R_X86_64_NUM		39

/* ARM relocs.  */

#define R_ARM_NONE		0	/* No reloc */
#define R_ARM_PC24		1	/* Deprecated PC relative 26
					   bit branch.  */
#define R_ARM_ABS32		2	/* Direct 32 bit  */
#define R_ARM_REL32		3	/* PC relative 32 bit */
#define R_ARM_PC13		4
#define R_ARM_ABS16		5	/* Direct 16 bit */
#define R_ARM_ABS12		6	/* Direct 12 bit */
#define R_ARM_THM_ABS5		7	/* Direct & 0x7C (LDR, STR).  */
#define R_ARM_ABS8		8	/* Direct 8 bit */
#define R_ARM_SBREL32		9
#define R_ARM_THM_PC22		10	/* PC relative 24 bit (Thumb32 BL).  */
#define R_ARM_THM_PC8		11	/* PC relative & 0x3FC
					   (Thumb16 LDR, ADD, ADR).  */
#define R_ARM_AMP_VCALL9	12
#define R_ARM_SWI24		13	/* Obsolete static relocation.  */
#define R_ARM_TLS_DESC		13      /* Dynamic relocation.  */
#define R_ARM_THM_SWI8		14	/* Reserved.  */
#define R_ARM_XPC25		15	/* Reserved.  */
#define R_ARM_THM_XPC22		16	/* Reserved.  */
#define R_ARM_TLS_DTPMOD32	17	/* ID of module containing symbol */
#define R_ARM_TLS_DTPOFF32	18	/* Offset in TLS block */
#define R_ARM_TLS_TPOFF32	19	/* Offset in static TLS block */
#define R_ARM_COPY		20	/* Copy symbol at runtime */
#define R_ARM_GLOB_DAT		21	/* Create GOT entry */
#define R_ARM_JUMP_SLOT		22	/* Create PLT entry */
#define R_ARM_RELATIVE		23	/* Adjust by program base */
#define R_ARM_GOTOFF		24	/* 32 bit offset to GOT */
#define R_ARM_GOTPC		25	/* 32 bit PC relative offset to GOT */
#define R_ARM_GOT32		26	/* 32 bit GOT entry */
#define R_ARM_PLT32		27	/* Deprecated, 32 bit PLT address.  */
#define R_ARM_CALL		28	/* PC relative 24 bit (BL, BLX).  */
#define R_ARM_JUMP24		29	/* PC relative 24 bit
					   (B, BL<cond>).  */
#define R_ARM_THM_JUMP24	30	/* PC relative 24 bit (Thumb32 B.W).  */
#define R_ARM_BASE_ABS		31	/* Adjust by program base.  */
#define R_ARM_ALU_PCREL_7_0	32	/* Obsolete.  */
#define R_ARM_ALU_PCREL_15_8	33	/* Obsolete.  */
#define R_ARM_ALU_PCREL_23_15	34	/* Obsolete.  */
#define R_ARM_LDR_SBREL_11_0	35	/* Deprecated, prog. base relative.  */
#define R_ARM_ALU_SBREL_19_12	36	/* Deprecated, prog. base relative.  */
#define R_ARM_ALU_SBREL_27_20	37	/* Deprecated, prog. base relative.  */
#define R_ARM_TARGET1		38
#define R_ARM_SBREL31		39	/* Program base relative.  */
#define R_ARM_V4BX		40
#define R_ARM_TARGET2		41
#define R_ARM_PREL31		42	/* 32 bit PC relative.  */
#define R_ARM_MOVW_ABS_NC	43	/* Direct 16-bit (MOVW).  */
#define R_ARM_MOVT_ABS		44	/* Direct high 16-bit (MOVT).  */
#define R_ARM_MOVW_PREL_NC	45	/* PC relative 16-bit (MOVW).  */
#define R_ARM_MOVT_PREL		46	/* PC relative (MOVT).  */
#define R_ARM_THM_MOVW_ABS_NC	47	/* Direct 16 bit (Thumb32 MOVW).  */
#define R_ARM_THM_MOVT_ABS	48	/* Direct high 16 bit
					   (Thumb32 MOVT).  */
#define R_ARM_THM_MOVW_PREL_NC	49	/* PC relative 16 bit
					   (Thumb32 MOVW).  */
#define R_ARM_THM_MOVT_PREL	50	/* PC relative high 16 bit
					   (Thumb32 MOVT).  */
#define R_ARM_THM_JUMP19	51	/* PC relative 20 bit
					   (Thumb32 B<cond>.W).  */
#define R_ARM_THM_JUMP6		52	/* PC relative X & 0x7E
					   (Thumb16 CBZ, CBNZ).  */
#define R_ARM_THM_ALU_PREL_11_0	53	/* PC relative 12 bit
					   (Thumb32 ADR.W).  */
#define R_ARM_THM_PC12		54	/* PC relative 12 bit
					   (Thumb32 LDR{D,SB,H,SH}).  */
#define R_ARM_ABS32_NOI		55	/* Direct 32-bit.  */
#define R_ARM_REL32_NOI		56	/* PC relative 32-bit.  */
#define R_ARM_ALU_PC_G0_NC	57	/* PC relative (ADD, SUB).  */
#define R_ARM_ALU_PC_G0		58	/* PC relative (ADD, SUB).  */
#define R_ARM_ALU_PC_G1_NC	59	/* PC relative (ADD, SUB).  */
#define R_ARM_ALU_PC_G1		60	/* PC relative (ADD, SUB).  */
#define R_ARM_ALU_PC_G2		61	/* PC relative (ADD, SUB).  */
#define R_ARM_LDR_PC_G1		62	/* PC relative (LDR,STR,LDRB,STRB).  */
#define R_ARM_LDR_PC_G2		63	/* PC relative (LDR,STR,LDRB,STRB).  */
#define R_ARM_LDRS_PC_G0	64	/* PC relative (STR{D,H},
					   LDR{D,SB,H,SH}).  */
#define R_ARM_LDRS_PC_G1	65	/* PC relative (STR{D,H},
					   LDR{D,SB,H,SH}).  */
#define R_ARM_LDRS_PC_G2	66	/* PC relative (STR{D,H},
					   LDR{D,SB,H,SH}).  */
#define R_ARM_LDC_PC_G0		67	/* PC relative (LDC, STC).  */
#define R_ARM_LDC_PC_G1		68	/* PC relative (LDC, STC).  */
#define R_ARM_LDC_PC_G2		69	/* PC relative (LDC, STC).  */
#define R_ARM_ALU_SB_G0_NC	70	/* Program base relative (ADD,SUB).  */
#define R_ARM_ALU_SB_G0		71	/* Program base relative (ADD,SUB).  */
#define R_ARM_ALU_SB_G1_NC	72	/* Program base relative (ADD,SUB).  */
#define R_ARM_ALU_SB_G1		73	/* Program base relative (ADD,SUB).  */
#define R_ARM_ALU_SB_G2		74	/* Program base relative (ADD,SUB).  */
#define R_ARM_LDR_SB_G0		75	/* Program base relative (LDR,
					   STR, LDRB, STRB).  */
#define R_ARM_LDR_SB_G1		76	/* Program base relative
					   (LDR, STR, LDRB, STRB).  */
#define R_ARM_LDR_SB_G2		77	/* Program base relative
					   (LDR, STR, LDRB, STRB).  */
#define R_ARM_LDRS_SB_G0	78	/* Program base relative
					   (LDR, STR, LDRB, STRB).  */
#define R_ARM_LDRS_SB_G1	79	/* Program base relative
					   (LDR, STR, LDRB, STRB).  */
#define R_ARM_LDRS_SB_G2	80	/* Program base relative
					   (LDR, STR, LDRB, STRB).  */
#define R_ARM_LDC_SB_G0		81	/* Program base relative (LDC,STC).  */
#define R_ARM_LDC_SB_G1		82	/* Program base relative (LDC,STC).  */
#define R_ARM_LDC_SB_G2		83	/* Program base relative (LDC,STC).  */
#define R_ARM_MOVW_BREL_NC	84	/* Program base relative 16
					   bit (MOVW).  */
#define R_ARM_MOVT_BREL		85	/* Program base relative high
					   16 bit (MOVT).  */
#define R_ARM_MOVW_BREL		86	/* Program base relative 16
					   bit (MOVW).  */
#define R_ARM_THM_MOVW_BREL_NC	87	/* Program base relative 16
					   bit (Thumb32 MOVW).  */
#define R_ARM_THM_MOVT_BREL	88	/* Program base relative high
					   16 bit (Thumb32 MOVT).  */
#define R_ARM_THM_MOVW_BREL	89	/* Program base relative 16
					   bit (Thumb32 MOVW).  */
#define R_ARM_TLS_GOTDESC	90
#define R_ARM_TLS_CALL		91
#define R_ARM_TLS_DESCSEQ	92	/* TLS relaxation.  */
#define R_ARM_THM_TLS_CALL	93
#define R_ARM_PLT32_ABS		94
#define R_ARM_GOT_ABS		95	/* GOT entry.  */
#define R_ARM_GOT_PREL		96	/* PC relative GOT entry.  */
#define R_ARM_GOT_BREL12	97	/* GOT entry relative to GOT
					   origin (LDR).  */
#define R_ARM_GOTOFF12		98	/* 12 bit, GOT entry relative
					   to GOT origin (LDR, STR).  */
#define R_ARM_GOTRELAX		99
#define R_ARM_GNU_VTENTRY	100
#define R_ARM_GNU_VTINHERIT	101
#define R_ARM_THM_PC11		102	/* PC relative & 0xFFE (Thumb16 B).  */
#define R_ARM_THM_PC9		103	/* PC relative & 0x1FE
					   (Thumb16 B/B<cond>).  */
#define R_ARM_TLS_GD32		104	/* PC-rel 32 bit for global dynamic
					   thread local data */
#define R_ARM_TLS_LDM32		105	/* PC-rel 32 bit for local dynamic
					   thread local data */
#define R_ARM_TLS_LDO32		106	/* 32 bit offset relative to TLS
					   block */
#define R_ARM_TLS_IE32		107	/* PC-rel 32 bit for GOT entry of
					   static TLS block offset */
#define R_ARM_TLS_LE32		108	/* 32 bit offset relative to static
					   TLS block */
#define R_ARM_TLS_LDO12		109	/* 12 bit relative to TLS
					   block (LDR, STR).  */
#define R_ARM_TLS_LE12		110	/* 12 bit relative to static
					   TLS block (LDR, STR).  */
#define R_ARM_TLS_IE12GP	111	/* 12 bit GOT entry relative
					   to GOT origin (LDR).  */
#define R_ARM_ME_TOO		128	/* Obsolete.  */
#define R_ARM_THM_TLS_DESCSEQ	129
#define R_ARM_THM_TLS_DESCSEQ16	129
#define R_ARM_THM_TLS_DESCSEQ32	130
#define R_ARM_THM_GOT_BREL12	131	/* GOT entry relative to GOT
					   origin, 12 bit (Thumb32 LDR).  */
#define R_ARM_IRELATIVE		160
#define R_ARM_RXPC25		249
#define R_ARM_RSBREL32		250
#define R_ARM_THM_RPC22		251
#define R_ARM_RREL32		252
#define R_ARM_RABS22		253
#define R_ARM_RPC24		254
#define R_ARM_RBASE		255
/* Keep this the last entry.  */
#define R_ARM_NUM		256

/* MIPS relocs.  */

#define R_MIPS_NONE		0	/* No reloc */
#define R_MIPS_16		1	/* Direct 16 bit */
#define R_MIPS_32		2	/* Direct 32 bit */
#define R_MIPS_REL32		3	/* PC relative 32 bit */
#define R_MIPS_26		4	/* Direct 26 bit shifted */
#define R_MIPS_HI16		5	/* High 16 bit */
#define R_MIPS_LO16		6	/* Low 16 bit */
#define R_MIPS_GPREL16		7	/* GP relative 16 bit */
#define R_MIPS_LITERAL		8	/* 16 bit literal entry */
#define R_MIPS_GOT16		9	/* 16 bit GOT entry */
#define R_MIPS_PC16		10	/* PC relative 16 bit */
#define R_MIPS_CALL16		11	/* 16 bit GOT entry for function */
#define R_MIPS_GPREL32		12	/* GP relative 32 bit */

#define R_MIPS_SHIFT5		16
#define R_MIPS_SHIFT6		17
#define R_MIPS_64		18
#define R_MIPS_GOT_DISP		19
#define R_MIPS_GOT_PAGE		20
#define R_MIPS_GOT_OFST		21
#define R_MIPS_GOT_HI16		22
#define R_MIPS_GOT_LO16		23
#define R_MIPS_SUB		24
#define R_MIPS_INSERT_A		25
#define R_MIPS_INSERT_B		26
#define R_MIPS_DELETE		27
#define R_MIPS_HIGHER		28
#define R_MIPS_HIGHEST		29
#define R_MIPS_CALL_HI16	30
#define R_MIPS_CALL_LO16	31
#define R_MIPS_SCN_DISP		32
#define R_MIPS_REL16		33
#define R_MIPS_ADD_IMMEDIATE	34
#define R_MIPS_PJUMP		35
#define R_MIPS_RELGOT		36
#define R_MIPS_JALR		37
#define R_MIPS_TLS_DTPMOD32	38	/* Module number 32 bit */
#define R_MIPS_TLS_DTPREL32	39	/* Module-relative offset 32 bit */
#define R_MIPS_TLS_DTPMOD64	40	/* Module number 64 bit */
#define R_MIPS_TLS_DTPREL64	41	/* Module-relative offset 64 bit */
#define R_MIPS_TLS_GD		42	/* 16 bit GOT offset for GD */
#define R_MIPS_TLS_LDM		43	/* 16 bit GOT offset for LDM */
#define R_MIPS_TLS_DTPREL_HI16	44	/* Module-relative offset, high 16 bits */
#define R_MIPS_TLS_DTPREL_LO16	45	/* Module-relative offset, low 16 bits */
#define R_MIPS_TLS_GOTTPREL	46	/* 16 bit GOT offset for IE */
#define R_MIPS_TLS_TPREL32	47	/* TP-relative offset, 32 bit */
#define R_MIPS_TLS_TPREL64	48	/* TP-relative offset, 64 bit */
#define R_MIPS_TLS_TPREL_HI16	49	/* TP-relative offset, high 16 bits */
#define R_MIPS_TLS_TPREL_LO16	50	/* TP-relative offset, low 16 bits */
#define R_MIPS_GLOB_DAT		51
#define R_MIPS_COPY		126
#define R_MIPS_JUMP_SLOT        127
/* Keep this the last entry.  */
#define R_MIPS_NUM		128

#endif
