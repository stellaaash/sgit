const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const io = init.io;

    std.debug.print("Welcome to Simple Git (sgit)!\n\n", .{});

    try print_config(allocator, io);
}

fn print_config(allocator: std.mem.Allocator, io: std.Io) !void {
    std.debug.print("[!] - Printing current configuration...\n", .{});
    const run_options: std.process.RunOptions = .{
        .argv = &.{ "git", "config", "-l" },
    };
    const proc = try std.process.run(allocator, io, run_options);
    std.debug.print("{s}\n", .{proc.stdout});
}
