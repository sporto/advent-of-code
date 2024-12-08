import gleam/int
import gleam/list
import gleam/regexp
import gleam/result.{try}
import gleam/string
import utils

pub fn part_1() {
  use content <- try(utils.load_and_parse("./input/03/input", parse_line))
  let all = string.join(content, "")

  use re <- try(
    regexp.from_string("mul\\(\\d{1,3},\\d{1,3}\\)")
    |> result.replace_error("Invalid regex"),
  )

  let matches = regexp.scan(with: re, content: all)

  use nums <- try(
    matches
    |> list.map(fn(match) { match.content })
    |> list.map(to_tuple)
    |> result.all
    |> result.replace_error("Failed to parse"),
  )

  let results =
    nums
    |> list.map(fn(tuple) {
      let #(a, b) = tuple
      a * b
    })
    |> int.sum

  Ok(results)
}

fn parse_line(line: String) {
  Ok(line)
}

fn to_tuple(match: String) {
  let inner = match |> string.replace("mul(", "") |> string.replace(")", "")

  use splitted <- try(string.split_once(inner, on: ","))

  let #(a, b) = splitted
  use aint <- try(int.parse(a))
  use bint <- try(int.parse(b))
  Ok(#(aint, bint))
}
