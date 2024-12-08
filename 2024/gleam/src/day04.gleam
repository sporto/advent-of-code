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

  let count =
    dict.fold(over: matrix, from: 0, with: fn(acc, coordinate, _) {
      acc + check_p1_coordinate(matrix, coordinate)
    })

  Ok(count)
}

pub fn part_2() {
  use content <- try(utils.load_and_parse("./input/04/input", parse_line))
  let matrix = make_matrix(content)

  let count =
    dict.fold(over: matrix, from: 0, with: fn(acc, coordinate, _) {
      acc + check_p2_coordinate(matrix, coordinate)
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

fn move(coordinate, direction, steps) {
  let #(x, y) = coordinate
  let #(mx, my) = get_movement(direction)
  #(x + { steps * mx }, y + { steps * my })
}

fn check_p1_coordinate(matrix: Matrix, coordinate: Coordinate) {
  directions
  |> list.filter_map(fn(direction) {
    check_p1_direction(matrix, coordinate, direction)
  })
  |> int.sum()
}

fn check_p1_direction(matrix: Matrix, coordinate, direction) {
  let #(x, y) = coordinate
  let #(mx, my) = get_movement(direction)

  use lx <- try(dict.get(matrix, coordinate))
  use lm <- try(dict.get(matrix, move(coordinate, direction, 1)))
  use la <- try(dict.get(matrix, move(coordinate, direction, 2)))
  use ls <- try(dict.get(matrix, move(coordinate, direction, 3)))
  let xmas = lx <> lm <> la <> ls

  case xmas {
    "XMAS" -> Ok(1)
    _ -> Ok(0)
  }
}

fn check_p2_coordinate(matrix: Matrix, coordinate: Coordinate) {
  check_p2_coordinate_do(matrix, coordinate)
  |> result.unwrap(0)
}

fn check_p2_coordinate_do(matrix: Matrix, coordinate: Coordinate) {
  use center <- try(dict.get(matrix, coordinate))

  case center {
    "A" -> {
      use nw <- try(dict.get(matrix, move(coordinate, NW, 1)))
      use ne <- try(dict.get(matrix, move(coordinate, NE, 1)))
      use se <- try(dict.get(matrix, move(coordinate, SE, 1)))
      use sw <- try(dict.get(matrix, move(coordinate, SW, 1)))

      let d1 = nw <> center <> se
      let d2 = ne <> center <> sw

      let d1_ok = d1 == "MAS" || d1 == "SAM"
      let d2_ok = d2 == "MAS" || d2 == "SAM"

      case d1_ok && d2_ok {
        True -> Ok(1)
        False -> Ok(0)
      }
    }
    _ -> Ok(0)
  }
}
