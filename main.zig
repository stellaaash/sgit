const std = @import("std");
const process = std.process;

pub fn main(init: process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const io = init.io;

    std.debug.print("Welcome to Simple Git (sgit)!\n\n", .{});

    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "--unset", "user.name" });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "--unset", "user.email" });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "--unset", "init.defaultbranch" });

    const username = "Aisling Fontaine";
    const email = "aisling.fontaine@pm.me";
    const pull_rebase = "true";
    const init_defaultbranch = "main";

    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "user.name", username });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "user.email", email });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "pull.rebase", pull_rebase });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "init.defaultbranch", init_defaultbranch });

    std.debug.print("[!] - Configuration done! Don't forget to setup your ssh key!\n", .{});
}

/// Simple wrapper over std.process.run, taking argv and running the executable.
fn run_executable(allocator: std.mem.Allocator, io: std.Io, argv: []const []const u8) process.RunError!process.RunResult {
    const run_options: process.RunOptions = .{
        .argv = argv,
    };

    const proc = try process.run(allocator, io, run_options);
    return proc;
}
