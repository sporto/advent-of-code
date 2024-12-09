import gleam/dict
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

type Coordinate =
  #(Int, Int)

type Matrix(a) =
  dict.Dict(Coordinate, a)

// #(x, y)
pub fn make_matrix(content: List(List(a))) -> Matrix(a) {
  list.index_fold(
    over: content,
    from: dict.new(),
    with: fn(acc, row, row_index) {
      list.index_fold(over: row, from: acc, with: fn(acc, cell, cell_index) {
        dict.insert(acc, #(cell_index, row_index), cell)
      })
    },
  )
}

pub fn list_max(nums: List(Int), base: Int) -> Int {
  list.fold(nums, base, int.max)
}
