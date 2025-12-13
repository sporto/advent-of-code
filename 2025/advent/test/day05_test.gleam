import day05.{merge_many_ranges, merge_range, merge_two_ranges}

pub fn merge_two_ranges_test() {
  assert merge_two_ranges(#(1, 10), #(11, 20)) == [#(1, 10), #(11, 20)]
  assert merge_two_ranges(#(1, 10), #(10, 20)) == [#(1, 20)] as "a joins b"
  assert merge_two_ranges(#(10, 20), #(1, 10)) == [#(1, 20)] as "b joins a"
  assert merge_two_ranges(#(10, 20), #(11, 20)) == [#(10, 20)] as "a includes b"
  assert merge_two_ranges(#(10, 20), #(9, 21)) == [#(9, 21)] as "b includes a"
}

pub fn merge_range_test() {
  assert merge_range(
      [
        #(1, 10),
      ],
      #(9, 20),
    )
    == [#(1, 20)]

  assert merge_range(
      [
        #(1, 10),
        #(50, 100),
      ],
      #(9, 20),
    )
    == [
      #(1, 20),
      #(50, 100),
    ]
}

pub fn merge_many_ranges_test() {
  assert merge_many_ranges([#(1, 10), #(9, 20)]) == [#(1, 20)]
}
