const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const io = init.io;

    std.debug.print("Welcome to Simple Git (sgit)!\n\n", .{});

    std.debug.print("Printing current configuration...\n", .{});
    const run_options: std.process.RunOptions = .{
        .argv = &.{ "git", "config", "-l" },
    };
    const proc = try std.process.run(allocator, io, run_options);
    std.debug.print("{s}\n", .{proc.stdout});
}
