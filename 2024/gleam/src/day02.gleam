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

  let qualified = list.map(content, p_1_qualify_report)

  let count = list.count(qualified, function.identity)

  Ok(count)
}

pub fn part_2() {
  use content <- try(utils.load_and_parse("./input/02/input", parse_line))

  let qualified = list.map(content, p_2_qualify_report)

  let count = list.count(qualified, function.identity)

  Ok(count)
}

fn parse_line(line: String) {
  string.split(line, on: " ")
  |> list.try_map(utils.parse_int)
}

fn p_1_qualify_report(report: List(Int)) -> Bool {
  let pairs = report |> list.window_by_2
  let pairs_reversed = report |> list.reverse |> list.window_by_2
  // io.debug(pairs)

  p_1_check_report_pairs(pairs) || p_1_check_report_pairs(pairs_reversed)
}

fn p_1_check_report_pairs(pairs: List(#(Int, Int))) {
  list.fold_until(pairs, True, fn(_, tuple) {
    case is_in_range(tuple) {
      True -> {
        list.Continue(True)
      }
      False -> list.Stop(False)
    }
  })
}

fn p_2_qualify_report(report: List(Int)) {
  let versions = make_versions(report)

  p_1_qualify_report(report)
  || list.any(versions, fn(version) { p_1_qualify_report(version) })
}

fn make_versions(report: List(Int)) {
  let range = list.range(0, list.length(report))

  list.map(range, fn(index) {
    list.index_fold(report, [], fn(acc, n, i) {
      case i == index {
        True -> acc
        False -> list.append(acc, [n])
      }
    })
  })
}

fn is_in_range(tuple: #(Int, Int)) {
  let #(a, b) = tuple
  case a - b {
    1 | 2 | 3 -> True
    _ -> False
  }
}
