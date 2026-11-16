:- module(cases, [title/1, case/3]).
:- use_module('../prolog/melody2prog').
:- use_module(engine).
title('melody2prog').
melody_g(M) :- rnd_int(0, 8, N), length(M, N), maplist([X]>>rnd_int(55, 79, X), M).
prog_g(P) :- rnd_int(0, 7, N), length(P, N), maplist([I]>>rnd_pick([inc, dec, keep, double, halve], I), P).
case(melody2prog, [M], melody2prog) :- melody_g(M).
case(prog2melody, [P, 60], prog2melody) :- prog_g(P).
case(run, [P, A], run) :- prog_g(P), rnd_int(0, 20, A).
