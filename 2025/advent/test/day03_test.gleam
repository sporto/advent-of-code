import day03

pub fn pick_num_test() {
  let actual = day03.pick_num([1, 2, 3, 4, 5, 2, 3], 3, 5)

  assert actual == Ok(#(3, [4, 5, 2, 3]))
}

pub fn pick_num_not_enough_test() {
  let actual = day03.pick_num([1, 2, 3, 4, 5, 2, 3], 3, 8)

  assert actual == Error(Nil)
}

pub fn find_next_highest_test() {
  let actual = day03.find_next_highest([1, 2, 3, 4, 5, 2, 5], 3)

  assert actual == Ok(#(5, [2, 5]))
}

pub fn find_next_highest_non_enough_test() {
  let actual = day03.find_next_highest([1, 2, 3, 4, 5, 2, 5], 12)

  assert actual == Error(Nil)
}

pub fn find_nums_test() {
  let input = [2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8]
  let expected = [4, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8]

  let actual = day03.find_nums([], input, 12)

  assert actual == Ok(expected)
}
