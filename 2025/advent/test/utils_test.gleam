import utils

pub fn num_power_test() {
  assert utils.num_power(10, 0) == 10
  assert utils.num_power(10, 1) == 100
  assert utils.num_power(10, 2) == 1000
  assert utils.num_power(2, 0) == 2
  assert utils.num_power(2, 1) == 20
}

pub fn digits_test() {
  assert utils.digits(12_784) == [1, 2, 7, 8, 4]
  assert utils.digits(784) == [7, 8, 4]
  assert utils.digits(4) == [4]
  assert utils.digits(0) == [0]
}

pub fn undigits_test() {
  let actual = utils.undigits([9, 2, 3])

  assert actual == 923
}
