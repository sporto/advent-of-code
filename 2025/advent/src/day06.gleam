import advent
import gleam/int
import gleam/list
import gleam/option
import gleam/result.{try}
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 6,
    parse:,
    part_a:,
    expected_a: option.Some(6_172_481_852_142),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(10_188_206_723_429),
    wrong_answers_b: [],
  )
}

fn parse(content) {
  // let assert Ok(parsed) = parse_result(content)
  // parsed
  content
}

fn parse_part_a(content) {
  content
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.transpose
  |> list.try_map(to_line)
}

fn parse_line(line) {
  line
  |> string.split(" ")
  |> list.filter(fn(frag) { frag != "" })
}

fn parse_part_b(content) {
  content
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.transpose
}

pub type Input =
  List(Block)

pub type Block {
  Block(op: Op, nums: List(Int))
}

fn to_line(row) {
  // the last column in the symbol, all the others are the numbers
  use last <- result.try(
    list.last(row) |> result.replace_error("Could not get last"),
  )

  use op <- result.try(parse_op(last))

  let nums = list.take(row, list.length(row) - 1)

  use parsed_nums <- result.try(list.try_map(nums, utils.parse_int))

  Ok(Block(op, parsed_nums))
}

pub type Op {
  Mul
  Sum
}

fn parse_op(char) {
  case char {
    "*" -> Ok(Mul)
    "+" -> Ok(Sum)
    _ -> Error("Invalid " <> char)
  }
}

fn part_a(input: String) -> Int {
  input
  |> parse_part_a
  |> result.unwrap([])
  |> list.map(resolve_op)
  |> int.sum
}

fn resolve_op(block: Block) {
  case block.op {
    Sum -> list.fold(block.nums, 0, fn(acc, n) { acc + n })
    Mul -> list.fold(block.nums, 1, fn(acc, n) { acc * n })
  }
}

fn part_b(input) -> Int {
  input
  |> parse_part_b
  |> list.map(parse_block_part_b)
  |> split_in_groups([], [], _)
  // |> echo
  |> list.try_map(to_block)
  |> result.unwrap([])
  |> list.map(resolve_op)
  |> int.sum
  //
  // todo
}

fn parse_block_part_b(line: List(String)) {
  line
  |> list.filter(fn(c) { c != " " })
  |> list.try_map(parse_char)
  |> result.unwrap([])
}

type Char {
  Num(Int)
  AsOp(Op)
}

fn parse_char(c) {
  case int.parse(c) {
    Ok(n) -> Ok(Num(n))
    Error(_) -> {
      case parse_op(c) {
        Ok(op) -> Ok(AsOp(op))
        _ -> Error("Invalid " <> c)
      }
    }
  }
}

fn split_in_groups(groups, current_group, elements: List(List(Char))) {
  case elements {
    [first, ..rest] ->
      case list.is_empty(first) {
        True -> split_in_groups(list.append(groups, [current_group]), [], rest)
        False ->
          split_in_groups(groups, list.append(current_group, [first]), rest)
      }
    _ -> list.append(groups, [current_group])
  }
}

fn to_block(elements: List(List(Char))) {
  // find the op
  use op <- result.try(
    list.find_map(elements, fn(el) {
      list.find_map(el, fn(char) {
        case char {
          AsOp(op) -> Ok(op)
          _ -> Error(Nil)
        }
      })
    }),
  )

  let nums =
    elements
    |> list.map(fn(el) {
      list.filter_map(el, fn(c) {
        case c {
          Num(n) -> Ok(n)
          _ -> Error(Nil)
        }
      })
    })
    |> list.map(utils.undigits)

  Ok(Block(op:, nums:))
}
