app "advent"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [
        Day01,
        pf.Stdout,
        pf.Task,
    ]
    provides [main] to pf

main =
    when Day01.run is
        Ok answer -> Stdout.line answer
        Err err -> Stdout.line err
