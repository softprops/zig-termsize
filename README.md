<h1 align="center">
    termsize
</h1>

<div align="center">
    terminal size matters
</div>

---

[![Main](https://github.com/softprops/zig-termsize/actions/workflows/main.yml/badge.svg)](https://github.com/softprops/zig-termsize/actions/workflows/main.yml) ![License Info](https://img.shields.io/github/license/softprops/zig-termsize) ![Release](https://img.shields.io/github/v/release/softprops/zig-termsize) [![Zig Support](https://img.shields.io/badge/zig-0.11.0-black?logo=zig)](https://ziglang.org/documentation/0.11.0/)

## 🍬 features

Termsize is a zig library providing a multi-platform interface for resolving your terminal's current size in rows and columns. On most unix systems, this is similar invoking the stty(1) program, requesting the terminal size.

## examples

```zig
const std = @import("std");
const termsize = @import("termsize");

pub fn main() !void {
    std.ebug.println("{any}", .{ termsize.termSize(std.io.getStdOut().handle) });
}
```

## 📼 installing

Create a new exec project with `zig init-exe`. Copy the echo handler example above into `src/main.zig`

Create a `build.zig.zon` file to declare a dependency

> .zon short for "zig object notation" files are essentially zig structs. `build.zig.zon` is zigs native package manager convention for where to declare dependencies

```zig
.{
    .name = "my-app",
    .version = "0.1.0",
    .dependencies = .{
        // 👇 declare dep properties
        .termsize = .{
            // 👇 uri to download
            .url = "https://github.com/softprops/zig-termsize/archive/refs/tags/v0.1.0.tar.gz",
            // 👇 hash verification
            .hash = "{current-hash}",
        },
    },
}
```

> the hash below may vary. you can also depend any tag with `https://github.com/softprops/zig-termsize/archive/refs/tags/v{version}.tar.gz` or current main with `https://github.com/softprops/zig-termsize/archive/refs/heads/main/main.tar.gz`. to resolve a hash omit it and let zig tell you the expected value.

Add the following in your `build.zig` file

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});
    // 👇 de-reference termsize dep from build.zig.zon
    const termsize = b.dependency("termsize", .{
        .target = target,
        .optimize = optimize,
    });
    var exe = b.addExecutable(.{
        .name = "your-exe",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    // 👇 add the termsize module to executable
    exe.addModule("termsize", termsize.module("termsize"));

    b.installArtifact(exe);
}
```

## 🥹 for budding ziglings

Does this look interesting but you're new to zig and feel left out? No problem, zig is young so most us of our new are as well. Here are some resources to help get you up to speed on zig

- [the official zig website](https://ziglang.org/)
- [zig's one-page language documentation](https://ziglang.org/documentation/0.11.0/)
- [ziglearn](https://ziglearn.org/)
- [ziglings exercises](https://github.com/ratfactor/ziglings)

\- softprops 2023
