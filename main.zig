const std = @import("std");
const process = std.process;

pub fn main(init: process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const io = init.io;

    std.debug.print("Welcome to Simple Git (sgit)!\n\n", .{});

    try print_config(allocator, io);
}

fn print_config(allocator: std.mem.Allocator, io: std.Io) !void {
    std.debug.print("[!] - Printing current configuration...\n", .{});

    const proc = try run_executable(allocator, io, &.{ "git", "config", "-l" });

    std.debug.print("{s}\n", .{proc.stdout});
}

/// Simple wrapper over std.process.run, taking argv and running the executable.
fn run_executable(allocator: std.mem.Allocator, io: std.Io, argv: []const []const u8) process.RunError!process.RunResult {
    const run_options: process.RunOptions = .{
        .argv = argv,
    };

    const proc = try process.run(allocator, io, run_options);
    return proc;
}
