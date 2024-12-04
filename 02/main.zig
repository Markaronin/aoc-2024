const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn absDiff(a: usize, b: usize) usize {
    if (a >= b) {
        return a - b;
    } else {
        return b - a;
    }
}

pub fn isSafe(line: std.ArrayList(usize)) bool {
    var lastNumber = line.items[0];
    var optIncreasing: ?bool = null;

    for (1..line.items.len) |i| {
        const nextNumber = line.items[i];

        const diff = absDiff(lastNumber, nextNumber);
        if (diff < 1 or diff > 3) {
            return false;
        }

        const localIncreasing = nextNumber >= lastNumber;
        if (optIncreasing) |increasing| {
            if (increasing != localIncreasing) {
                return false;
            }
        } else {
            optIncreasing = localIncreasing;
        }

        lastNumber = nextNumber;
    }
    return true;
}

pub fn isSafeWithAnyRemoved(line: std.ArrayList(usize)) bool {
    for (0..line.items.len) |i| {
        var shorterLine = line.clone() catch unreachable;
        _ = shorterLine.orderedRemove(i);
        if (isSafe(shorterLine)) {
            return true;
        }
    }

    return false;
}

pub fn getSolution(input: []const u8) [2]usize {
    var lines = std.mem.tokenizeAny(u8, input, "\n");

    var answer1: usize = 0;
    var answer2: usize = 0;
    while (lines.next()) |line| {
        var splitLine = std.mem.tokenizeAny(u8, line, " ");
        var parsedLine = std.ArrayList(usize).init(allocator);
        defer parsedLine.deinit();

        while (splitLine.next()) |unparsedNumber| {
            const nextNumber = std.fmt.parseInt(usize, unparsedNumber, 10) catch unreachable;
            parsedLine.append(nextNumber) catch unreachable;
        }

        if (isSafe(parsedLine)) {
            answer1 += 1;
        }
        if (isSafeWithAnyRemoved(parsedLine)) {
            answer2 += 1;
        }
    }

    return .{ answer1, answer2 };
}

pub fn main() !void {
    const input = @embedFile("input");

    const solution = getSolution(input);
    std.debug.print("{d}, {d}\n", .{ solution[0], solution[1] });
}

test "listDiff" {
    const testInput = @embedFile("testinput");
    const solution = getSolution(testInput);
    try std.testing.expectEqual(2, solution[0]);
    try std.testing.expectEqual(4, solution[1]);
}
