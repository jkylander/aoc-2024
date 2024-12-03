package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

safe :: proc(report: []int, direction: int) -> bool {
    safe := true
    for i := 1; i < len(report); i += 1 {
        distance := abs(report[i] - report[i - 1])
        if distance < 1 || distance > 3 do safe = false
        current_direction := report[i] - report[i - 1] < 0 ? -1 : 1
        if current_direction != direction do safe = false
    }
    return safe
}

main :: proc() {
    input := #load("input.txt", string) or_else "Input file not found."
    reports := 0
    dampener := 0
    for s in strings.split_lines_iterator(&input) {
        line := strings.split(s, " ")
        report : [dynamic]int
        defer delete(report)

        for i := 0; i < len(line); i += 1{
            append(&report, strconv.atoi(line[i]))
        }

        // Part 1
        direction := report[1] - report[0] < 0 ? -1 : 1
        if safe(report[:], direction) do reports += 1
        else { // Part 2
            safer := false
            for i := 0; i < len(report); i += 1 {
                removed := report[i]
                ordered_remove(&report, i)
                direction = report[1] - report[0] < 0 ? -1 : 1
                if safe(report[:], direction) {
                    safer = true
                }
                inject_at(&report, i, removed)
            }
            if safer do dampener += 1
        }
    }
    fmt.println("Part 1:", reports)
    fmt.println("Part 2:", reports + dampener)
}
