import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleam/result.{try}
import gleam/set
import gleam/string
import utils

pub fn part_1() {
  use content <- try(utils.load_and_parse("./input/07/input", parse_line))

  let valid = list.filter(content, check_valid)
  let test_values = list.map(valid, pair.first)
  let total = int.sum(test_values)

  Ok(total)
}

pub fn part_2() {
  use content <- try(utils.load_and_parse("./input/07/input", parse_line))

  let valid = list.filter(content, check_valid_part_2)
  let test_values = list.map(valid, pair.first)
  let total = int.sum(test_values)

  // 492383931656533

  Ok(total)
}

fn parse_line(line) {
  use #(a, b) <- try(
    string.split_once(line, ":")
    |> result.replace_error("Invalid line " <> line),
  )

  use test_value <- try(utils.parse_int(a))

  let nums = b |> string.trim |> string.split(on: " ")

  use nums <- try(list.try_map(nums, utils.parse_int))

  Ok(#(test_value, nums))
}

type Op {
  Add
  Mul
}

fn check_valid(tuple: #(Int, List(Int))) {
  let #(test_value, nums) = tuple

  let answers =
    list.flatten([resolve(0, 0, nums, Add), resolve(1, 0, nums, Mul)])

  list.contains(answers, test_value)
}

fn resolve(previous: Int, current: Int, rest: List(Int), op: Op) -> List(Int) {
  let acc = case op {
    Add -> previous + current
    Mul -> previous * current
  }

  case rest {
    [first, ..rest] ->
      list.flatten([
        resolve(acc, first, rest, Add),
        resolve(acc, first, rest, Mul),
      ])
    _ -> [acc]
  }
}

type Op2 {
  Add2
  Mul2
  Concat
}

fn check_valid_part_2(tuple: #(Int, List(Int))) {
  let #(test_value, nums) = tuple

  let answers =
    list.flatten([
      resolve_part_2(None, 0, nums, Add2),
      resolve_part_2(None, 0, nums, Mul2),
    ])

  list.contains(answers, test_value)
}

fn resolve_part_2(
  previous: Option(Int),
  current: Int,
  rest: List(Int),
  op: Op2,
) -> List(Int) {
  let acc = case previous {
    Some(previous_value) -> {
      case op {
        Add2 -> Some(previous_value + current)
        Mul2 -> Some(previous_value * current)
        Concat ->
          case utils.concat_ints(previous_value, current) {
            Ok(value) -> Some(value)
            Error(_) -> {
              io.println("Error")
              None
            }
          }
      }
    }
    None -> Some(current)
  }

  case rest {
    [first, ..rest] ->
      list.flatten([
        resolve_part_2(acc, first, rest, Add2),
        resolve_part_2(acc, first, rest, Mul2),
        resolve_part_2(acc, first, rest, Concat),
      ])
    _ ->
      case acc {
        Some(acc) -> [acc]
        None -> []
      }
  }
}
