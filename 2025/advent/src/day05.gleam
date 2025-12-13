import advent
import gleam/int
import gleam/list
import gleam/option
import gleam/pair
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
    expected_b: option.Some(344_323_629_240_733),
    wrong_answers_b: [308_693_638_312_832],
  )
}

pub type Range {
  Range(start: Int, end: Int)
}

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

  Ok(Range(start, end))
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
  n >= range.start && n <= range.end
}

fn part_b(input: Input) -> Int {
  input.ranges
  |> sort_and_merge
  // |> echo
  |> list.map(fn(range) { range.end - range.start + 1 })
  |> int.sum
}

pub fn sort_and_merge(ranges: List(Range)) {
  ranges
  |> sorted_ranges
  |> merge
}

fn sorted_ranges(ranges: List(Range)) -> List(Range) {
  ranges
  |> list.sort(fn(a, b) { int.compare(a.start, b.start) })
}

fn merge(ranges: List(Range)) {
  case ranges {
    [first, ..rest] -> merge_next([], first, rest)
    _ -> []
  }
}

fn merge_next(accumulated: List(Range), current: Range, remaining: List(Range)) {
  case remaining {
    [next, ..rest] -> merge_range(accumulated, current, next, rest)
    _ -> list.append(accumulated, [current])
  }
}

fn merge_range(
  accumulated: List(Range),
  previous: Range,
  current: Range,
  remaining: List(Range),
) -> List(Range) {
  case previous.end >= current.start {
    True -> {
      let together =
        Range(start: previous.start, end: int.max(previous.end, current.end))
      merge_next(accumulated, together, remaining)
    }
    False -> {
      merge_next(list.append(accumulated, [previous]), current, remaining)
    }
  }
}
