package main

import "core:fmt"
import "core:os"
import "core:text/regex"
import "core:strconv"

part1:: proc(input: string) -> int {
    using strconv
    local_input := input
    acc := 0

    reg :: `mul\((\d{1,3}),(\d{1,3})\)`
    r, rerr := regex.create(reg, {.Global})
    defer regex.destroy_regex(r)
    assert(rerr == nil)

    for capture in regex.match(r, local_input) {
        defer regex.destroy_capture(capture)
        result := atoi(capture.groups[1]) * atoi(capture.groups[2])
        local_input = local_input[capture.pos[0][1]:]
        acc += result
    }
    return acc
}

part2 ::proc(input: string) -> int {
    using strconv
    local_input := input
    acc := 0

    reg :: `don't\(\)|do\(\)|mul\((\d{1,3}),(\d{1,3})\)`
    r, rerr := regex.create(reg, {.Global})
    defer regex.destroy_regex(r)
    assert(rerr == nil)

    enabled := true
    for capture in regex.match(r, local_input) {
        defer regex.destroy_capture(capture)
        if capture.groups[0] == "do()" {
            enabled = true
            local_input = local_input[capture.pos[0][1]:]
            continue
        }
        if capture.groups[0] == "don't()" {
            enabled = false
            local_input = local_input[capture.pos[0][1]:]
            continue
        }
        local_input = local_input[capture.pos[0][1]:]
        if enabled {
            acc += atoi(capture.groups[1]) * atoi(capture.groups[2])
        }
    }
    return acc
}

main :: proc() {
    input := #load("input.txt", string) or_else "Input file not found."
    fmt.println("Part 1:", part1(input[:]))
    fmt.println("Part 2:", part2(input[:]))
}
