% sudoku_general.pl

:- use_module(library(clpfd)).

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

blocks([], _).
blocks(Rows, BlockSize) :-
    length(BlockRows, BlockSize),
    append(BlockRows, RestRows, Rows),
    maplist(split_blocks(BlockSize), BlockRows, BlockLists),
    transpose(BlockLists, BlocksByColumn),
    maplist(merge_and_check_distinct, BlocksByColumn),
    blocks(RestRows, BlockSize).

split_blocks(_, [], []).
split_blocks(N, Row, [Block|Blocks]) :-
    append(Block, Rest, Row),
    length(Block, N),
    split_blocks(N, Rest, Blocks).

merge_and_check_distinct(Blocks) :-
    append(Blocks, Flat),
    all_distinct(Flat).

solve_and_print(Puzzle) :-
    sudoku(Puzzle),
    maplist(writeln, Puzzle),
    nl.

:- initialization(main).

main :-
    Puzzle4x4 = [[_,_,2,_],
                 [_,_,_,3],
                 [1,_,_,_],
                 [_,4,_,_]],
    writeln('4x4 Puzzle:'), solve_and_print(Puzzle4x4),

    Puzzle9x9 = [[5,3,_,_,7,_,_,_,_],
                 [6,_,_,1,9,5,_,_,_],
                 [_,9,8,_,_,_,_,6,_],
                 [8,_,_,_,6,_,_,_,3],
                 [4,_,_,8,_,3,_,_,1],
                 [7,_,_,_,2,_,_,_,6],
                 [_,6,_,_,_,_,2,8,_],
                 [_,_,_,4,1,9,_,_,5],
                 [_,_,_,_,8,_,_,7,9]],
    writeln('9x9 Puzzle:'), solve_and_print(Puzzle9x9),

    halt.