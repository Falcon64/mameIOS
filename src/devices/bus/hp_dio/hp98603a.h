// license:BSD-3-Clause
// copyright-holders:Sven Schnelle

#ifndef MAME_BUS_HPDIO_98603A_H
#define MAME_BUS_HPDIO_98603A_H

#pragma once

#include "hp_dio.h"

namespace bus::hp_dio {

class dio16_98603a_device :
		public device_t,
		public device_dio16_card_interface
{
public:
	// construction/destruction
	dio16_98603a_device(const machine_config &mconfig, const char *tag, device_t *owner, uint32_t clock);
	uint16_t rom_r(offs_t offset);
	void rom_w(offs_t offset, uint16_t data);

protected:
	dio16_98603a_device(const machine_config &mconfig, device_type type, const char *tag, device_t *owner, uint32_t clock);

	// device-level overrides
	virtual void device_start() override;
	virtual void device_reset() override;

	// optional information overrides
	virtual void device_add_mconfig(machine_config &config) override;
	virtual const tiny_rom_entry *device_rom_region() const override;

private:
	uint8_t *m_rom = nullptr;
};

} // namespace bus::hp_dio

DECLARE_DEVICE_TYPE_NS(HPDIO_98603A, bus::hp_dio, dio16_98603a_device)

#endif // MAME_BUS_HPDIO_98603A_H
