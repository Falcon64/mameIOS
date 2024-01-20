// license:BSD-3-Clause
// copyright-holders:Vas Crabb
/*
    Epson C33 disassembler
*/

#ifndef MAME_CPU_C33_C33DASM_H
#define MAME_CPU_C33_C33DASM_H

#pragma once


class c33_disassembler : public util::disasm_interface
{
public:
	c33_disassembler();

	virtual u32 opcode_alignment() const override;
	virtual offs_t disassemble(std::ostream &stream, offs_t pc, data_buffer const &opcodes, data_buffer const &params) override;

private:
	offs_t dasm_class_0(std::ostream &stream, offs_t pc, u16 op, u32 ext_imm, unsigned ext_count) const;
	offs_t dasm_class_1(std::ostream &stream, u16 op, u32 ext_imm, unsigned ext_count) const;
	offs_t dasm_class_2_3(std::ostream &stream, u16 op, u32 ext_imm, unsigned ext_count) const;
	offs_t dasm_class_4(std::ostream &stream, u16 op, u32 ext_imm, unsigned ext_count) const;
	offs_t dasm_class_6(std::ostream &stream, u16 op, u32 ext_imm, unsigned ext_count) const;
	offs_t dasm_class_5(std::ostream &stream, u16 op, u32 ext_imm, unsigned ext_count) const;
	offs_t dasm_class_7(std::ostream &stream, u16 op, u32 ext_imm, unsigned ext_count) const;

	offs_t max_ext(std::ostream &stream, unsigned max, u32 ext_imm, unsigned ext_count) const;
};

#endif // MAME_CPU_C33_C33DASM_H
