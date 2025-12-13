import advent
import gleam/int
import gleam/list
import gleam/option
import gleam/result.{try}
import gleam/set
import gleam/string

pub fn day() {
  advent.Day(
    day: 5,
    parse:,
    part_a:,
    expected_a: option.Some(690),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.None,
    wrong_answers_b: [],
  )
}

pub type Range =
  #(Int, Int)

pub type Input {
  Input(ranges: List(Range), ingredients: List(Int))
}

fn parse(content) {
  let assert Ok(parsed) = parse_result(content)
  parsed
}

fn parse_result(content) {
  use #(a, b) <- try(string.split_once(content, "\n\n"))

  use ranges <- try(parse_ranges(a))
  use ingredients <- try(parse_ingredients(b))

  Ok(Input(ranges, ingredients))
}

fn parse_ranges(content) {
  content
  |> string.split("\n")
  |> list.try_map(parse_range_line)
}

fn parse_range_line(line) {
  use #(a, b) <- try(string.split_once(line, "-"))
  use start <- try(int.parse(a))
  use end <- try(int.parse(b))

  Ok(#(start, end))
}

fn parse_ingredients(content) {
  content
  |> string.split("\n")
  |> list.try_map(int.parse)
}

fn part_a(input: Input) -> Int {
  list.map(input.ingredients, is_fresh(input.ranges, _))
  |> list.map(fn(v) {
    case v {
      True -> 1
      False -> 0
    }
  })
  |> int.sum
}

fn is_fresh(ranges: List(Range), ingredient: Int) {
  list.any(ranges, is_in_range(_, ingredient))
}

fn is_in_range(range: Range, n: Int) {
  let #(start, end) = range
  n >= start && n <= end
}

fn part_b(input: Input) -> Int {
  // Make sets, join them all
  // count
  //
  input.ranges
  |> list.map(range_to_set)
  |> list.fold(set.new(), fn(acc, other) { set.union(acc, other) })
  |> set.size
}

fn range_to_set(range: Range) {
  let #(a, b) = range
  list.range(a, b)
  |> set.from_list
}
