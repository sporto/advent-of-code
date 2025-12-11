import advent
import day01
import day02
import day03
import day04

pub fn main() -> Nil {
  advent.year(2025)
  |> advent.timed
  |> advent.add_day(day01.day())
  |> advent.add_day(day02.day())
  |> advent.add_day(day03.day())
  |> advent.add_day(day04.day())
  |> advent.add_padding_days(up_to: 12)
  |> advent.run
}
