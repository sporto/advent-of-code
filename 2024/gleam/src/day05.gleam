import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/regexp
import gleam/result.{try}
import gleam/string
import utils

pub type Ordering =
  dict.Dict(Int, List(Int))

pub type Instructions {
  Instructions(ordering_rules: Ordering, updates: List(List(Int)))
}

pub fn part_1() {
  use content <- try(utils.load("./input/05/input"))

  use instructions <- try(parse_content(content))

  let in_order =
    instructions.updates
    |> list.filter_map(fn(update) {
      let is_correct = is_update_in_order(update, instructions.ordering_rules)
      case is_correct {
        True -> Ok(update)
        False -> Error(Nil)
      }
    })

  let sum =
    in_order
    // |> io.debug
    |> list.map(take_middle)
    // |> io.debug
    |> int.sum

  Ok(sum)
}

fn parse_content(content: String) {
  use #(top, bottom) <- try(
    string.split_once(content, "\n\n")
    |> result.replace_error("Invalid instruction"),
  )

  use ordering_rules <- try(parse_instructions_ordering_rules(top))
  use updates <- try(parse_instructions_updates(bottom))

  Ok(Instructions(ordering_rules, updates))
}

fn parse_instructions_ordering_rules(content) -> Result(Ordering, String) {
  use tuples <- try(
    content
    |> string.split("\n")
    |> list.try_map(fn(line) {
      use #(a, b) <- try(
        string.split_once(line, "|")
        |> result.replace_error("Invalid instruction"),
      )
      use a_int <- try(utils.parse_int(a))
      use b_int <- try(utils.parse_int(b))
      Ok(#(a_int, b_int))
    }),
  )

  list.group(tuples, by: pair.first)
  |> dict.map_values(fn(_, values) { list.map(values, pair.second) })
  |> Ok
}

fn parse_instructions_updates(content) {
  string.split(content, "\n")
  |> list.try_map(fn(line) {
    string.split(line, ",")
    |> list.try_map(utils.parse_int)
  })
}

fn is_update_in_order(update: List(Int), ordering_rules: Ordering) {
  case update {
    [first, ..rest] -> is_update_in_order_do([], first, rest, ordering_rules)
    _ -> False
  }
}

fn is_update_in_order_do(
  prev_pages: List(Int),
  current: Int,
  next_pages: List(Int),
  ordering_rules: Ordering,
) {
  let ok_previous =
    list.all(prev_pages, fn(previous) {
      // Previous cannot be in the array for the current number
      dict.get(ordering_rules, current)
      |> result.unwrap([])
      |> list.contains(previous)
      |> bool.negate
    })

  case ok_previous {
    True -> {
      case next_pages {
        [next, ..new_next_pages] -> {
          is_update_in_order_do(
            list.append(prev_pages, [current]),
            next,
            new_next_pages,
            ordering_rules,
          )
        }
        _ -> True
      }
    }
    False -> False
  }
}

fn take_middle(update: List(Int)) {
  update
  |> list.drop(list.length(update) / 2)
  |> list.first
  |> result.unwrap(0)
}
