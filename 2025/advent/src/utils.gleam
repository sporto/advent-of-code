import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn parse_lines(content: String, parse_line) {
  content
  |> string.split("\n")
  |> list.filter(fn(l) { !string.is_empty(l) })
  |> list.try_map(parse_line)
}

pub fn parse_int(c) {
  c |> int.parse |> result.replace_error("Couldnt parse " <> c)
}

pub fn undigits(nums) {
  // result = 9*100 + 2*10 + 3*1  # = 923

  nums
  |> list.reverse
  |> list.index_map(num_power)
  |> int.sum
}

pub fn digits(num: Int) {
  let len = num |> int.to_string |> string.length
  digits_do([], num, len - 2)
}

fn digits_do(acc, num, power) {
  case power {
    -1 -> list.append(acc, [num])
    _ -> {
      let divider = num_power(10, power)
      let res = num / divider
      let next_acc = list.append(acc, [res])
      let next_num = num - { res * divider }
      digits_do(next_acc, next_num, power - 1)
    }
  }
}

// index represent the position from to the decimal
// 0 -> units
// 1 -> tenths
// 2 -> hundreds
pub fn num_power(n, index) {
  case index {
    0 -> n
    _ -> num_power(n * 10, index - 1)
  }
}

pub type Coordinate =
  #(Int, Int)

pub type Matrix(a) =
  dict.Dict(Coordinate, a)

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
