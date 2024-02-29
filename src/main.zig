const std = @import("std");
const builtin = @import("builtin");
const io = std.io;
const os = std.os;

/// Terminal size dimensions
pub const TermSize = struct {
    /// Terminal width as measured number of characters that fit into a terminal horizontally
    width: u16,
    /// terminal height as measured number of characters that fit into terminal vertically
    height: u16,
};

/// supports windows, linux, macos
///
/// ## example
///
/// ```zig
/// const std = @import("std");
/// const termSize = @import("termSize");
///
/// fn main() !void {
///   std.debug.print(
///     "{any}",
///     termSize.termSize(std.os.getStdOut().handle),
///   );
/// }
/// ```
pub fn termSize(fd: os.fd_t) !TermSize {
    return switch (builtin.os.tag) {
        .windows => blk: {
            var buf: os.windows.CONSOLE_SCREEN_BUFFER_INFO = undefined;
            break :blk switch (os.windows.kernel32.GetConsoleScreenBufferInfo(
                fd,
                &buf,
            )) {
                os.windows.TRUE => TermSize{
                    .width = buf.srWindow.Right - buf.srWindow.Left + 1,
                    .height = buf.srWindow.Bottom - buf.srWindow.Top + 1,
                },
                else => error.Unexpected,
            };
        },
        .linux, .macos => blk: {
            var buf: os.system.winsize = undefined;
            break :blk switch (os.errno(
                std.c.ioctl(
                    fd,
                    os.system.T.IOCGWINSZ,
                    @intFromPtr(&buf),
                ),
            )) {
                .SUCCESS => TermSize{
                    .width = buf.ws_col,
                    .height = buf.ws_row,
                },
                else => error.IoctlError,
            };
        },
        else => error.Unsupported,
    };
}

test "termSize" {
    std.debug.print("{any}", .{termSize(std.io.getStdOut().handle)});
}
