#include "ez/stdio/printf.h"

#include <cstdarg>
#include <cstddef>
#include <cstdio>
#include <cstring>

extern "C" {
  char *__ez_clang_inline_heap_acquire(size_t);
  void __ez_clang_report_string(const char *Data, size_t Size);
}

namespace ez {

void printf(const char* Fmt, ...) {
  va_list Args;
  va_start(Args, Fmt);
  size_t Capacity = strlen(Fmt) + 20;
  char *Buffer = __ez_clang_inline_heap_acquire(Capacity);
  int Length = vsnprintf(Buffer, Capacity, Fmt, Args);
  __ez_clang_report_string(Buffer, Length);
  va_end(Args);
}

}
