const std = @import("std");
const termsize = @import("termsize");

pub fn main() !void {
    std.debug.print("{any}", .{termsize.termSize(std.io.getStdOut().handle)});
}
