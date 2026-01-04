libpsvr assets
==============

Place the libpsvr headers and libraries in this directory so CMake can link
against them without downloading anything.

Expected layout:

```
third_party/libpsvr/
  include/
    <libpsvr headers>
  lib/
    libpsvr.lib   (Windows)
    libpsvr.so    (Linux)
    libpsvr.a     (optional static build)
```
