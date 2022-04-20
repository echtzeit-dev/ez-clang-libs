#ifndef EZ_FIXPOINT_MAPRANGE_H
#define EZ_FIXPOINT_MAPRANGE_H

#include <cstdint>

namespace {

template <uint32_t Value>
constexpr uint32_t max_shift() {
  static_assert((Value & 0xFF000000) == 0, "Not enough free leading bits");
  if constexpr (((Value << 4) & 0x80000000) != 0)
    return 4;
  if constexpr (((Value << 5) & 0x80000000) != 0)
    return 5;
  if constexpr (((Value << 6) & 0x80000000) != 0)
    return 6;
  if constexpr (((Value << 7) & 0x80000000) != 0)
    return 7;
  if constexpr (((Value << 8) & 0x80000000) != 0)
    return 8;
  if constexpr (((Value << 9) & 0x80000000) != 0)
    return 9;
  if constexpr (((Value << 10) & 0x80000000) != 0)
    return 10;
  if constexpr (((Value << 11) & 0x80000000) != 0)
    return 11;
  if constexpr (((Value << 12) & 0x80000000) != 0)
    return 12;
  if constexpr (((Value << 13) & 0x80000000) != 0)
    return 13;
  if constexpr (((Value << 14) & 0x80000000) != 0)
    return 14;
  if constexpr (((Value << 15) & 0x80000000) != 0)
    return 15;
  if constexpr (((Value << 16) & 0x80000000) != 0)
    return 16;
  if constexpr (((Value << 17) & 0x80000000) != 0)
    return 17;
  if constexpr (((Value << 18) & 0x80000000) != 0)
    return 18;
  if constexpr (((Value << 19) & 0x80000000) != 0)
    return 19;
  if constexpr (((Value << 20) & 0x80000000) != 0)
    return 20;
  if constexpr (((Value << 21) & 0x80000000) != 0)
    return 21;
  if constexpr (((Value << 22) & 0x80000000) != 0)
    return 22;
  if constexpr (((Value << 23) & 0x80000000) != 0)
    return 23;
  if constexpr (((Value << 24) & 0x80000000) != 0)
    return 24;
  if constexpr (((Value << 25) & 0x80000000) != 0)
    return 25;
  if constexpr (((Value << 26) & 0x80000000) != 0)
    return 26;
  if constexpr (((Value << 27) & 0x80000000) != 0)
    return 27;
  if constexpr (((Value << 28) & 0x80000000) != 0)
    return 28;
  if constexpr (((Value << 29) & 0x80000000) != 0)
    return 29;
  if constexpr (((Value << 30) & 0x80000000) != 0)
    return 30;
  if constexpr (((Value << 31) & 0x80000000) != 0)
    return 31;
  static_assert(Value > 0, "Zero is not a valid max value");
}

template <uint32_t Value1, uint32_t Value2>
constexpr uint32_t min_value() {
  return Value1 < Value2 ? Value1 : Value2;
}

}

namespace ez {

template <uint32_t in_min, uint32_t in_max, uint32_t out_min, uint32_t out_max>
uint32_t mapRange(uint32_t x) {
  constexpr uint32_t shift = min_value<max_shift<in_max + 1>(),
                                       max_shift<out_max + 1>()>();
  constexpr uint32_t factor =
      ((out_max - out_min + 1) << shift) / (in_max - in_min + 1);
  return (((x - in_min) * factor) >> shift) + out_min;
}

}

#endif // EZ_FIXPOINT_MAPRANGE_H
