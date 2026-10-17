const std = @import("std");
const process = std.process;

pub fn main(init: process.Init) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    const io = init.io;

    std.debug.print("Welcome to Simple Git (sgit)!\n\n", .{});

    var buffer: [1024]u8 = undefined;
    var stdin_reader = std.Io.File.stdin().reader(io, buffer[0..]);
    const stdin = &stdin_reader.interface;

    const username = try ask_for_input(allocator, stdin, "Please enter your username");
    const email = try ask_for_input(allocator, stdin, "Please enter your email");
    const pull_rebase = try ask_for_input(allocator, stdin, "Please enter your pull rebase preference (either true or false)");
    // TODO check for other inputs than true or false
    const init_default_branch = try ask_for_input(allocator, stdin, "Please enter your default branch name on git init");

    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "--unset", "user.name" });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "--unset", "user.email" });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "--unset", "init.defaultbranch" });

    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "user.name", username });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "user.email", email });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "pull.rebase", pull_rebase });
    _ = try run_executable(allocator, io, &.{ "git", "config", "--global", "init.defaultbranch", init_default_branch });

    std.debug.print("[!] - Configuration done! Don't forget to setup your ssh key!\n", .{});
}

fn ask_for_input(allocator: std.mem.Allocator, stdin: *std.Io.Reader, message: []const u8) ![]u8 {
    while (true) {
        std.debug.print("{s}: ", .{message});
        const read_string = try stdin.takeDelimiter('\n');
        if (read_string != null) {
            const result = try allocator.dupe(u8, read_string.?);
            return result;
        }
    }
}

/// Simple wrapper over std.process.run, taking argv and running the executable.
fn run_executable(allocator: std.mem.Allocator, io: std.Io, argv: []const []const u8) process.RunError!process.RunResult {
    const run_options: process.RunOptions = .{
        .argv = argv,
    };

    const proc = try process.run(allocator, io, run_options);
    return proc;
}
