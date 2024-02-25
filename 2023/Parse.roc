interface Parse
    exposes [
        Parser,
        parseLines
    ]
    imports []

Parser parsed : Str -> ParseResult parsed

ParseResult parsed : Result parsed Str

parseLines : Str, Parser parsed -> ParseResult (List parsed)
parseLines = \input, parser ->
    Str.split input "\n"
    |> List.mapTry parser
