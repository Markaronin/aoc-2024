const std = @import("std");

pub fn listDiff(input: []const u8) [2]usize {
    var splitInput = std.mem.tokenizeAny(u8, input, "\n");

    const allocator = std.heap.page_allocator;

    var firstList = std.ArrayList(isize).init(allocator);
    defer firstList.deinit();

    var secondList = std.ArrayList(isize).init(allocator);
    defer secondList.deinit();

    while (splitInput.next()) |line| {
        var splitLine = std.mem.tokenizeAny(u8, line, " ");
        const firstNumber = std.fmt.parseInt(isize, splitLine.next().?, 10) catch unreachable;
        const secondNumber = std.fmt.parseInt(isize, splitLine.next().?, 10) catch unreachable;
        firstList.append(firstNumber) catch unreachable;
        secondList.append(secondNumber) catch unreachable;
    }

    std.debug.assert(firstList.items.len == secondList.items.len);
    const listLength = firstList.items.len;

    std.mem.sort(isize, firstList.items, {}, comptime std.sort.asc(isize));
    std.mem.sort(isize, secondList.items, {}, comptime std.sort.asc(isize));

    var sum: usize = 0;
    for (0..listLength) |i| {
        sum += @abs(firstList.items[i] - secondList.items[i]);
    }

    var secondListOccurances = std.AutoHashMap(isize, usize).init(allocator);
    for (secondList.items) |item| {
        const entryOpt = secondListOccurances.get(item);
        if (entryOpt) |entry| {
            secondListOccurances.put(item, entry + 1) catch unreachable;
        } else {
            secondListOccurances.put(item, 1) catch unreachable;
        }
    }

    var part2: usize = 0;
    for (firstList.items) |item| {
        const numOccurances = secondListOccurances.get(item) orelse 0;
        part2 += numOccurances * @as(usize, @intCast(item));
    }

    return .{ sum, part2 };
}

pub fn main() !void {
    const input = @embedFile("input");

    const diff = listDiff(input);
    std.debug.print("{d}, {d}\n", .{ diff[0], diff[1] });
}

test "listDiff" {
    const testInput = @embedFile("testinput");
    const diff = listDiff(testInput);
    try std.testing.expectEqual(diff[0], 11);
    try std.testing.expectEqual(diff[1], 31);
}
