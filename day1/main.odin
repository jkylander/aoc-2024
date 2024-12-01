package main

import "core:fmt"
import "core:os"
import "core:sort"
import "core:strconv"
import "core:strings"

part1 :: proc(a: []int, b: []int) -> int {
    accum := 0
    for i := 0; i < len(a); i += 1 {
        accum += abs(a[i] - b[i])
    }
    return accum
}

part2 :: proc(a: []int, b: []int) -> int {
    accum := 0
    for i in a {
        count := 0
        for j in b {
            if i == j {count += 1}
        }
        accum += i * count
    }
    return accum
}

main :: proc() {
    data, ok := os.read_entire_file_from_filename("input.txt")
    if !ok {
        fmt.eprintln("Failed to load file.")
        return
    }
    defer delete(data)
    it := string(data)
    left, right: [dynamic]int
    defer delete(left)
    defer delete(right)

    for line in strings.split_lines_iterator(&it) {
        s := strings.split(line, "   ")
        s0, _ := strconv.parse_int(s[0])
        s1, _ := strconv.parse_int(s[1])
        append(&left, s0)
        append(&right, s1)
    }

    sort.quick_sort(left[:])
    sort.quick_sort(right[:])

    distance := part1(left[:], right[:])
    similarity := part2(left[:], right[:])
    fmt.println("Distance:", distance)
    fmt.println("Similarity:", similarity)

}
