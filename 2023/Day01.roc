interface Day01
    exposes [
        run
    ]
    imports [
        Parse,
        pf.Stdout,
        pf.Task,
        "data/01/input.txt" as input : Str,
    ]

utf8ToNum = \byte ->
    when byte is
        48 -> Ok 0
        49 -> Ok 1
        50 -> Ok 2
        51 -> Ok 3
        52 -> Ok 4
        53 -> Ok 5
        54 -> Ok 6
        55 -> Ok 7
        56 -> Ok 8
        57 -> Ok 9
        _ -> Err byte

lineParser : Str -> Result (List U16) Str
lineParser = \line ->
    Str.toUtf8 line
    |> List.keepOks utf8ToNum
    |> Ok

getLineNum : List U16 -> U16
getLineNum = \line ->
    a =
        List.first line |> Result.withDefault 0
    b =
        List.last line |> Result.withDefault 0
    a * 10 + b


run =
    Parse.parseLines "\(input)" lineParser
    |> Result.map (\lines -> List.map lines getLineNum)
    |> Result.map List.sum
    |> Result.map (Num.toStr)
