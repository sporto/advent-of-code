import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn load(path: String) -> Result(List(String), String) {
  simplifile.read(path)
  |> result.replace_error("Failed to load file")
  |> result.map(string.split(_, on: "\n"))
  |> result.map(list.filter(_, fn(line) { line != "" }))
}

pub fn load_and_parse(path: String, parse) {
  load(path)
  |> result.then(parse)
}