import advent
import day01

pub fn main() -> Nil {
  advent.year(2025)
  |> advent.timed
  |> advent.add_day(day01.day01())
  |> advent.add_padding_days(up_to: 12)
  |> advent.run
}
