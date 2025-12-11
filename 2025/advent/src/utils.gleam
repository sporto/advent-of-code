import gleam/int
import gleam/list

pub fn join_nums(nums) {
  // result = 9*100 + 2*10 + 3*1  # = 923

  nums
  |> list.reverse
  |> list.index_map(num_power)
  |> int.sum
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
