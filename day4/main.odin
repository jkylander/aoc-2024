package main

import "core:fmt"
import "core:os"
import "core:strings"

is_valid :: proc(r, c, rows, cols: int) -> bool {
    return r >= 0 && c >= 0 && r < rows && c < cols
}

part1 :: proc(grid: []string) -> int {
    rows := len(grid) - 1
    cols := len(grid[0])
    xmas_count := 0

    directions : [][2]int= {
        { 0,  1},  // right
        { 1,  0},  // down
        { 1,  1},  // down-right
        { 1, -1},  // down-left
        { 0, -1},  // left
        {-1,  0},  // up
        {-1, -1},  // up-left
        {-1,  1},  // up-right
    }

    check_word :: proc(r, c, dr, dc: int, grid:[]string) -> bool {
        rows := len(grid) - 1
        cols := len(grid[0])
        word := make([]u8, 4)
        defer delete(word)
        curr_r, curr_c := r, c

        for i in 0..<4 {
            if !is_valid(curr_r, curr_c, rows, cols) do return false

            word[i] = grid[curr_r][curr_c]
            curr_r += dr
            curr_c += dc
        }
        return string(word) == "XMAS"
    }

    for r in 0..<rows {
        for c in 0..<cols {
            for dir in directions {
                if check_word(r, c, dir[0], dir[1], grid[:]) {
                    xmas_count += 1
                }
            }
        }
    }
    return xmas_count
}

part2 :: proc(grid: []string) -> int {
    rows := len(grid) - 1
    cols := len(grid[0])
    x_mas_count := 0

    is_x_mas :: proc(r, c: int, grid: []string) -> bool {
        rows := len(grid) - 1
        cols := len(grid[0])
        str1 := make([]u8, 3)
        str2 := make([]u8, 3)
        defer delete(str1)
        defer delete(str2)

        if grid[r][c] == 'A' {
            if !is_valid(r,c, rows, cols) do return false
            str1[0] = grid[r-1][c+1]
            str1[1] = grid[r][c]
            str1[2] = grid[r+1][c-1]

            str2[0] = grid[r+1][c+1]
            str2[1] = grid[r][c]
            str2[2] = grid[r-1][c-1]

        }

        if (string(str1) == "SAM" || string(str1) == "MAS") &&
           (string(str2) == "SAM" || string(str2) == "MAS") { return true }
        return false
    }

    // 'A' can't be in corners or edges
    for r in 1..<rows - 1 {
        for c in 1..<cols - 1 {
            if is_x_mas(r, c, grid[:]) {
                x_mas_count += 1
            }
        }
    }
    return x_mas_count
}

main :: proc() {
    input := #load("input.txt", string) or_else "Input file not found."
    grid := strings.split_lines(input)
    fmt.println("Part 1:", part1(grid[:]))
    fmt.println("Part 2:", part2(grid[:]))
}
