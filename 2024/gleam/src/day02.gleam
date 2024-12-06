import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result.{try}
import gleam/string
import utils

pub fn part_1() {
  use content <- try(utils.load_and_parse("./input/02/input", parse_line))

  let qualified = list.map(content, qualify_report)

  let count = list.count(qualified, function.identity)

  Ok(count)
}

fn parse_line(line: String) {
  string.split(line, on: " ")
  |> list.try_map(utils.parse_int)
}

fn qualify_report(report: List(Int)) {
  let pairs = report |> list.window_by_2
  let pairs_reversed = report |> list.reverse |> list.window_by_2
  // io.debug(pairs)

  check_report_pairs(pairs) || check_report_pairs(pairs_reversed)
}

fn check_report_pairs(pairs: List(#(Int, Int))) {
  list.fold_until(pairs, True, fn(_, tuple) {
    let #(a, b) = tuple
    case a - b {
      1 | 2 | 3 -> {
        list.Continue(True)
      }
      _ -> list.Stop(False)
    }
  })
}
