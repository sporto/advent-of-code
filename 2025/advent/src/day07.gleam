import advent
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result.{try}
import gleam/set
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 7,
    parse:,
    part_a:,
    expected_a: option.Some(1711),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.None,
    wrong_answers_b: [],
  )
}

fn parse(content) {
  let assert Ok(parsed) = parse_result(content)
  parsed
}

type Input =
  List(List(String))

// utils.Matrix(String)

fn parse_result(content) -> Result(Input, Nil) {
  content
  |> string.split("\n")
  |> list.map(parse_line)
  // |> utils.make_matrix
  |> Ok
}

fn parse_line(line) {
  line
  |> string.to_graphemes
}

type Acc {
  Acc(beams: set.Set(Int), splits: Int)
}

fn part_a(input: Input) {
  let acc = walk_next(input, Acc(set.new(), 0))
  acc.splits
}

fn walk_next(rows, acc: Acc) {
  case rows {
    [first, ..rest] -> walk(first, rest, acc)
    _ -> acc
  }
}

fn walk(first, rest, acc) {
  let next_acc =
    list.index_fold(first, acc, fn(acc, char, index) {
      case char {
        "S" -> {
          Acc(..acc, beams: set.insert(acc.beams, index))
        }
        "^" -> {
          let has_beam = set.contains(acc.beams, index)

          case has_beam {
            True -> {
              let next_splits = acc.splits + 1

              let next_beams =
                acc.beams
                |> set.delete(index)
                |> set.insert(index - 1)
                |> set.insert(index + 1)

              Acc(beams: next_beams, splits: next_splits)
            }
            False -> acc
          }
        }
        _ -> {
          acc
        }
      }
    })

  // echo next_acc.beams
  // echo next_acc.splits

  walk_next(rest, next_acc)
}

fn part_b(input) {
  todo
}
