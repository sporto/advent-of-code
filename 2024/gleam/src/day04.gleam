import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/result.{try}
import gleam/string
import utils

type Coordinate =
  #(Int, Int)

type Matrix =
  dict.Dict(Coordinate, String)

pub fn part_1() {
  use content <- try(utils.load_and_parse("./input/04/input", parse_line))
  let matrix = make_matrix(content)

  // io.debug(dict.size(matrix))

  let count =
    dict.fold(over: matrix, from: 0, with: fn(acc, coordinate, _) {
      acc + check_coordinate(matrix, coordinate)
    })

  Ok(count)
}

fn parse_line(line: String) {
  Ok(string.split(line, on: ""))
}

fn make_matrix(content: List(List(String))) {
  list.index_fold(
    over: content,
    from: dict.new(),
    with: fn(acc, row, row_index) {
      list.index_fold(over: row, from: acc, with: fn(acc, cell, cell_index) {
        dict.insert(acc, #(row_index, cell_index), cell)
      })
    },
  )
}

type Direction {
  E
  SE
  S
  SW
  W
  NW
  N
  NE
}

const directions = [E, SE, S, SW, W, NW, N, NE]

fn get_movement(direction) {
  case direction {
    E -> #(1, 0)
    SE -> #(1, 1)
    S -> #(0, 1)
    SW -> #(-1, 1)
    W -> #(-1, 0)
    NW -> #(-1, -1)
    N -> #(0, -1)
    NE -> #(1, -1)
  }
}

fn check_coordinate(matrix: Matrix, coordinate: Coordinate) {
  directions
  |> list.filter_map(fn(direction) {
    check_direction(matrix, coordinate, direction)
  })
  |> int.sum()
}

fn check_direction(matrix: Matrix, coordinate, direction) {
  let #(x, y) = coordinate
  let #(mx, my) = get_movement(direction)

  use lx <- try(dict.get(matrix, coordinate))
  use lm <- try(dict.get(matrix, #(x + mx, y + my)))
  use la <- try(dict.get(matrix, #(x + { 2 * mx }, y + { 2 * my })))
  use ls <- try(dict.get(matrix, #(x + { 3 * mx }, y + { 3 * my })))
  let xmas = lx <> lm <> la <> ls

  case xmas {
    "XMAS" -> Ok(1)
    _ -> Ok(0)
  }
}
