import advent
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn day01() {
  advent.Day(
    day: 1,
    parse:,
    part_a:,
    expected_a: option.Some(1021),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(5933),
    wrong_answers_b: [5485, 5570],
  )
}

fn parse(content) {
  let result =
    content
    |> string.split("\n")
    |> list.filter(fn(l) { !string.is_empty(l) })
    |> list.try_map(parse_line)

  let assert Ok(parsed) = result
  parsed
}

fn parse_line(line) {
  case line {
    "L" <> rest -> parse_dir(-1, rest)
    "R" <> rest -> parse_dir(1, rest)
    _ -> Error("Invalid line " <> line)
  }
}

fn parse_dir(mul: Int, str: String) {
  use n <- result.try(
    int.parse(str) |> result.replace_error("Cannot parse " <> str),
  )
  Ok(n * mul)
}

const start = 50

fn part_a(input: List(Int)) {
  let ns =
    list.scan(input, start, fn(value, inst) {
      let assert Ok(re) = int.remainder(value + inst, 100)
      re
    })

  list.count(ns, fn(n) { n == 0 })
}

fn part_b(input: List(Int)) {
  let ns =
    list.scan(input, #(start, start, 0), fn(tuple, inst) {
      let #(_, previous_value, _) = tuple

      let assert Ok(next_value) = int.modulo(previous_value + inst, 100)

      let count =
        list.range(previous_value, previous_value + inst)
        |> list.count(fn(i) { i % 100 == 0 && i != previous_value })

      #(previous_value, next_value, count)
    })

  // echo ns

  list.map(ns, fn(pair) {
    let #(_, _, count) = pair
    count
  })
  |> int.sum
}
