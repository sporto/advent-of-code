import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result.{try}
import gleam/string
import utils

pub fn part_1() {
  use content <- try(utils.load_and_parse("./input/01/input.txt", parse_day_01))

  let list_left = list.map(content, pair.first) |> list.sort(int.compare)

  let list_right = list.map(content, pair.second) |> list.sort(int.compare)

  let zipped = list.zip(list_left, list_right)

  let distances =
    list.map(zipped, fn(tuple) {
      let #(a, b) = tuple
      int.absolute_value(a - b)
    })

  let sum = int.sum(distances)

  Ok(sum)
}

pub fn part_2() {
  use content <- try(utils.load_and_parse("./input/01/input.txt", parse_day_01))

  let list_left = list.map(content, pair.first)
  let list_right = list.map(content, pair.second)

  let list_similarity =
    list.map(list_left, fn(n) { n * list.count(list_right, fn(m) { n == m }) })

  // io.debug(list_similarity)

  let sum = int.sum(list_similarity)

  Ok(sum)
}

fn parse_day_01(content: List(String)) {
  list.try_map(content, parse_day_01_line)
}

fn parse_day_01_line(line: String) {
  case string.split(line, on: "   ") {
    [a, b] -> {
      use a_num <- try(int.parse(a) |> result.replace_error("Invalid a"))
      use b_num <- try(int.parse(b) |> result.replace_error("Invalid b"))
      Ok(#(a_num, b_num))
    }
    _ -> Error("Invalid line " <> line)
  }
}
