import gleam/dict
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/result.{try}
import gleam/set
import gleam/string
import utils

type Matrix =
  dict.Dict(utils.Coordinate, String)

type Walked =
  dict.Dict(utils.Coordinate, Int)

pub type Direction {
  Up
  Down
  Left
  Right
}

pub type Guard {
  Guard(position: utils.Coordinate, direction: Direction)
}

pub fn part_1() {
  use content <- try(utils.load_and_parse("./input/06/input", parse_line))
  let matrix = utils.make_matrix(content)
  use guard_position <- try(find_guard_position(matrix))
  let guard = Guard(position: guard_position, direction: Up) |> io.debug
  let walked = dict.new()
  let res = run(matrix, walked, guard)

  // draw(res)

  Ok(res |> dict.size)
}

fn parse_line(line: String) {
  line
  |> string.split(on: "")
  |> Ok
}

fn find_guard_position(matrix) {
  matrix
  |> dict.to_list
  |> list.find_map(fn(tuple) {
    let #(coor, value) = tuple
    case value == "^" {
      True -> Ok(coor)
      False -> Error(Nil)
    }
  })
  |> result.replace_error("No guard found")
}

fn run(matrix: Matrix, walked: Walked, guard: Guard) {
  // Current position is added to walked
  let next_walked =
    dict.upsert(walked, guard.position, fn(x) {
      case x {
        Some(i) -> i + 1
        None -> 0
      }
    })

  let next_wanted_position = walk(guard)
  // io.debug(next_wanted_position)
  let what_is_in_there = dict.get(matrix, next_wanted_position)

  case what_is_in_there {
    Ok(something) -> {
      case something {
        "#" -> {
          // turn 90 degrees to the right
          let next_direction = turn(guard.direction)
          let next_guard = Guard(..guard, direction: next_direction)
          run(matrix, next_walked, next_guard)
        }
        _ -> {
          // Continue
          let next_guard = Guard(..guard, position: next_wanted_position)
          run(matrix, next_walked, next_guard)
        }
      }
    }
    Error(Nil) -> {
      // If position is outside the bounds, then finish
      next_walked
    }
  }
}

fn walk(guard: Guard) {
  let #(x, y) = guard.position
  case guard.direction {
    Up -> #(x, y - 1)
    Down -> #(x, y + 1)
    Left -> #(x - 1, y)
    Right -> #(x + 1, y)
  }
}

fn turn(direction) {
  case direction {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}
// fn draw(walked: Walked) {
//   let xs = set.map(walked, pair.first) |> set.to_list
//   let ys = set.map(walked, pair.second) |> set.to_list
//   let max_x = utils.list_max(xs, 0)
//   let max_y = utils.list_max(ys, 0)
//   list.each(list.range(0, max_y), fn(y) {
//     let line =
//       list.map(list.range(0, max_x), fn(x) {
//         case set.contains(walked, #(x, y)) {
//           True -> "X"
//           False -> "."
//         }
//       })
//       |> string.join("")

//     io.println(line)
//   })
// }
