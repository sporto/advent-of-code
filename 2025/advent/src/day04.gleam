import advent
import given
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 4,
    parse:,
    part_a:,
    expected_a: option.Some(1344),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(8112),
    wrong_answers_b: [],
  )
}

type Input =
  utils.Matrix(Int)

fn parse(content) {
  content
  |> string.split("\n")
  |> list.filter(fn(l) { !string.is_empty(l) })
  |> list.map(parse_line)
  |> utils.make_matrix
  // let assert Ok(parsed) = result

  // parsed
}

fn parse_line(line) {
  line
  |> string.to_graphemes
  |> list.map(parse_cell)
}

// type CellContent

fn parse_cell(char) {
  case char {
    "@" -> 1
    _ -> 0
  }
}

fn part_a(input: Input) -> Int {
  dict.fold(input, 0, fn(acc, key, value) {
    acc + score_for_cell(input, key, value)
  })
}

fn score_for_cell(matrix, cell_key, cell_value) {
  case cell_value {
    1 -> {
      let adjancents =
        [
          get_adjacent(matrix, cell_key, 0, -1),
          get_adjacent(matrix, cell_key, 1, -1),
          get_adjacent(matrix, cell_key, 1, 0),
          get_adjacent(matrix, cell_key, 1, 1),
          get_adjacent(matrix, cell_key, 0, 1),
          get_adjacent(matrix, cell_key, -1, 1),
          get_adjacent(matrix, cell_key, -1, 0),
          get_adjacent(matrix, cell_key, -1, -1),
        ]
        |> int.sum
      // Do a look up on all adjacent
      // Roll
      case adjancents < 4 {
        True -> 1
        False -> 0
      }
    }
    _ -> 0
  }
}

fn get_adjacent(matrix, coor, hor, ver) {
  let #(x, y) = coor

  dict.get(matrix, #(x + hor, y + ver))
  |> result.unwrap(0)
}

fn part_b(input: Input) -> Int {
  part_b_do([], input)
  |> list.length
}

fn part_b_do(acc, matrix: Input) {
  let removed = b_remove(matrix)

  case removed {
    [] -> acc
    _ -> {
      // make a new matrix with these elements zeroed
      let next_matrix =
        list.fold(removed, matrix, fn(acc, coor) {
          //
          dict.insert(acc, coor, 0)
        })

      let next_acc = list.append(acc, removed)
      part_b_do(next_acc, next_matrix)
    }
  }
}

fn b_remove(input) {
  dict.fold(input, [], fn(acc, key, value) {
    list.append(acc, removed_by_cell(input, key, value))
  })
}

fn removed_by_cell(matrix: Input, cell_key, cell_value) {
  case score_for_cell(matrix, cell_key, cell_value) {
    1 -> [cell_key]
    _ -> []
  }
}
