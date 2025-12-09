import advent
import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn day() {
  advent.Day(
    day: 2,
    parse:,
    part_a:,
    expected_a: option.Some(5_398_419_778),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(15_704_845_910),
    wrong_answers_b: [],
  )
}

fn parse(content) {
  let result =
    content
    |> string.split(",")
    |> list.try_map(parse_range)

  let assert Ok(parsed) = result
  parsed
}

fn parse_range(pair) -> Result(#(Int, Int), Nil) {
  string.split_once(pair, "-")
  |> result.try(fn(range) {
    let #(a, b) = range
    use an <- result.try(int.parse(a))
    use bn <- result.try(int.parse(b))
    Ok(#(an, bn))
  })
}

fn part_a(input: List(#(Int, Int))) {
  input
  |> list.flat_map(get_invalid_ids)
  // |> echo
  |> int.sum
}

fn get_invalid_ids(tuple: #(Int, Int)) -> List(Int) {
  let #(a, b) = tuple

  list.range(a, b)
  |> list.filter(is_invalid_id)
}

fn is_invalid_id(id: Int) {
  let str = int.to_string(id)
  let len = string.length(str)
  let half = len / 2

  case len == half * 2 {
    True -> {
      let prefix = string.drop_end(str, half)
      let suffix = string.drop_start(str, half)
      prefix == suffix
    }
    False -> False
  }
}

fn part_b(input) {
  input
  |> list.flat_map(get_invalid_ids_b)
  // |> echo
  |> int.sum
}

fn get_invalid_ids_b(tuple: #(Int, Int)) -> List(Int) {
  let #(a, b) = tuple

  list.range(a, b)
  |> list.filter(is_invalid_id_b)
}

fn is_invalid_id_b(id: Int) {
  let str = int.to_string(id)
  let chars = string.to_graphemes(str)

  let len = string.length(str)
  let half = len / 2
  is_invalid_recursive(chars, half)
}

fn is_invalid_recursive(chars: List(String), size: Int) {
  case size {
    0 -> False
    _ -> {
      let chunks = list.sized_chunk(chars, size)

      let groups = list.group(chunks, function.identity)

      case dict.size(groups) {
        1 -> True
        _ -> is_invalid_recursive(chars, size - 1)
      }
    }
  }
}
