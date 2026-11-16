% melody2prog: turn a melody into a program and back. Notes are MIDI numbers; each interval
% between neighbouring notes is an instruction for an accumulator: a step up (1 or 2) adds one, a
% step down subtracts one, a repeat keeps it, a leap up (3 or more) doubles and a leap down halves.
% prog2melody/3 writes a canonical melody for a program, so programs round-trip through music, and
% transposing a melody never changes its program.
%?- melody2prog([60, 62, 67, 65], P).   % P = [inc, double, dec]
%?- run([inc, double, dec], 0, A).      % A = 1
%?- prog2melody([inc, double, dec], 60, M).   % M = [60, 62, 67, 65]
:- module(melody2prog, [melody2prog/2, prog2melody/3, run/3, instr/2, transpose/3]).
:- use_module(library(lists)).
:- use_module(library(apply)).

instr(D, I) :- ( D =:= 0 -> I = keep ; D >= 3 -> I = double ; D > 0 -> I = inc ; D =< -3 -> I = halve ; I = dec ).

melody2prog(Ns, P) :- findall(I, ( nextto(A, B, Ns), D is B - A, instr(D, I) ), P).

step_of(inc, 2).
step_of(dec, -2).
step_of(keep, 0).
step_of(double, 5).
step_of(halve, -5).
prog2melody(P, Start, [Start|Ns]) :- foldl([I, N0-A0, N-[N|A0]]>>( step_of(I, D), N is N0 + D ), P, Start-[], _-Rev), reverse(Rev, Ns).

run(P, A0, A) :- foldl([I, X, Y]>>op_(I, X, Y), P, A0, A).
op_(inc, X, Y) :- Y is X + 1.
op_(dec, X, Y) :- Y is X - 1.
op_(keep, X, X).
op_(double, X, Y) :- Y is X * 2.
op_(halve, X, Y) :- Y is X // 2.

transpose(Ns, K, Ms) :- maplist([N, M]>>( M is N + K ), Ns, Ms).
