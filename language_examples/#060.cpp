void func() {
stream << static_cast<uint8_t>(val >> 56) << static_cast<uint8_t>(val >> 48)
       << static_cast<uint8_t>(val >> 40) << static_cast<uint8_t>(val >> 32)
       << static_cast<uint8_t>(val >> 24) << static_cast<uint8_t>(val >> 16)
       << static_cast<uint8_t>(val >> 8) << static_cast<uint8_t>(val);
}