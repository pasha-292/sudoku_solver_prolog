% sudoku.pl

:- use_module(library(clpfd)).

% Main Sudoku solver
sudoku(Rows) :-
    length(Rows, N),
    maplist(same_length(Rows), Rows),
    append(Rows, Cells),
    Cells ins 1..N,
    maplist(all_distinct, Rows),
    transpose(Rows, Columns),
    maplist(all_distinct, Columns),
    SquareSize is integer(sqrt(N)),
    blocks(Rows, SquareSize),
    label(Cells).

% Extract blocks and enforce distinct values
blocks([], _).
blocks([Row1, Row2|Rest], N) :-  % handles 4×4 (2×2 blocks)
    block_rows(Row1, Row2, N),
    blocks(Rest, N).

block_rows([], [], _).
block_rows(Row1, Row2, N) :-
    append(Block1, Rest1, Row1), length(Block1, N),
    append(Block2, Rest2, Row2), length(Block2, N),
    append(Block1, Block2, Block),
    all_distinct(Block),
    block_rows(Rest1, Rest2, N).

% Print solution
solve_and_print(Puzzle) :-
    (   once(sudoku(Puzzle)) ->
        maplist(writeln, Puzzle),
        nl
    ;   writeln('No solution found.'), nl
    ).

% Run all examples
:- initialization(main).

main :-
    writeln('Puzzle 1:'), solve_and_print([[_,_,2,_],[_,_,_,3],[1,_,_,_],[_,4,_,_]]),
    writeln('Puzzle 2:'), solve_and_print([[1,_,_,_],[_,_,_,2],[_,3,_,_],[_,_,4,_]]),
    writeln('Puzzle 3:'), solve_and_print([[_,2,_,_],[3,_,_,_],[_,_,_,1],[_,_,4,_]]),
    writeln('Puzzle 4:'), solve_and_print([[_,_,_,_],[_,1,_,2],[_,_,4,_],[3,_,_,_]]),
    writeln('Puzzle 5:'), solve_and_print([[2,_,_,_],[_,_,_,1],[_,3,_,_],[_,_,2,_]]),
    halt.