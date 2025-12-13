import day05.{Range}

pub fn sort_and_merge_test() {
  assert day05.sort_and_merge([
      //
      Range(2, 25),
      Range(30, 40),
      Range(9, 20),
    ])
    == [
      Range(2, 25),
      Range(30, 40),
    ]
}
