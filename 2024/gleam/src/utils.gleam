import gleam/int
import gleam/list
import gleam/result.{try}
import gleam/string
import simplifile

pub fn load(path: String) -> Result(String, String) {
  use content <- try(
    simplifile.read(path)
    |> result.replace_error("Failed to load file"),
  )
  // Remove the trailing blank line
  Ok(string.drop_end(content, 1))
}

pub fn load_lines(path: String) -> Result(List(String), String) {
  load(path)
  |> result.map(string.split(_, on: "\n"))
  |> result.map(list.filter(_, fn(line) { line != "" }))
}

pub fn load_and_parse(path: String, parse) {
  load_lines(path)
  |> result.then(list.try_map(_, parse))
}

pub fn parse_int(s: String) {
  int.parse(s) |> result.replace_error("Invalid number " <> s)
}
