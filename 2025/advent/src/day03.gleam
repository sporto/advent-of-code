import advent
import given
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 3,
    parse:,
    part_a:,
    expected_a: option.Some(17_155),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(169_685_670_469_164),
    wrong_answers_b: [],
  )
}

type Input =
  List(List(Int))

fn parse(content) -> Input {
  let result =
    content
    |> string.split("\n")
    |> list.filter(fn(l) { !string.is_empty(l) })
    |> list.try_map(parse_line)

  let assert Ok(parsed) = result
  parsed
}

fn parse_line(line) {
  line
  |> string.to_graphemes
  |> list.try_map(int.parse)
}

fn part_a(input: Input) {
  // echo "---"
  input
  |> list.map(get_joltage)
  |> int.sum
}

fn get_joltage(bank: List(Int)) {
  list.window_by_2(bank)
  |> list.fold(#(0, 0), fn(acc, pair) {
    let #(picked_a, picked_b) = acc
    let #(a, b) = pair

    case a > picked_a {
      True -> pair
      False -> {
        case b > picked_b {
          True -> #(picked_a, b)
          False -> acc
        }
      }
    }
  })
  // |> echo
  |> fn(pair) {
    let #(a, b) = pair
    a * 10 + b
  }
}

fn part_b(input: Input) {
  input
  |> list.map(get_joltage_2)
  |> int.sum
}

fn get_joltage_2(bank: List(Int)) {
  // echo "bank"
  // echo bank

  find_nums([], bank, 12)
  |> result.unwrap([])
  // |> echo
  |> utils.undigits
}

pub fn find_nums(acc, nums, needed) {
  use <- given.that(needed > 0, else_return: fn() { Ok(acc) })

  use #(n, rest) <- result.try(find_next_highest(nums, needed))

  let next_acc = list.append(acc, [n])

  find_nums(next_acc, rest, needed - 1)
}

pub fn find_next_highest(nums, needed) {
  let to_try = list.range(9, 1)

  list.fold_until(to_try, Error(Nil), fn(_, num_to_try) {
    case pick_num(nums, num_to_try, needed) {
      Ok(d) -> list.Stop(Ok(d))
      Error(_) -> list.Continue(Error(Nil))
    }
  })
}

pub fn pick_num(nums, num_to_pick, needed) {
  let len = list.length(nums)

  use <- given.that(len >= needed, else_return: fn() { Error(Nil) })

  case nums {
    [first, ..rest] -> {
      case first == num_to_pick {
        True -> Ok(#(first, rest))
        False -> pick_num(rest, num_to_pick, needed)
      }
    }
    _ -> Error(Nil)
  }
}
// 234234234234278
// 434234234278
//
// 818181911112111
// 888911112111
//
