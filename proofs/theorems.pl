% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/melody2prog').

% Domain: every program of length 0..5 over the five instructions; every melody of length 0..4 over notes 60..66.
prog(P) :- between(0, 5, N), length(P, N), maplist([I]>>member(I, [inc, dec, keep, double, halve]), P).
melody(M) :- between(0, 4, N), length(M, N), maplist([X]>>between(60, 66, X), M).

% 1. Every program round-trips through its canonical melody.
theorem(program_roundtrips) :- forall(prog(P), ( prog2melody(P, 60, M), melody2prog(M, P) )).

% 2. Transposing a melody never changes its program.
theorem(transposition_invariant) :- forall(( melody(M), between(-12, 12, K) ), ( melody2prog(M, P), transpose(M, K, M2), melody2prog(M2, P) )).

% 3. A melody of N notes gives N - 1 instructions (none for 0 or 1 notes).
theorem(length_matches) :- forall(melody(M), ( melody2prog(M, P), length(M, N), length(P, L), L =:= max(0, N - 1) )).

% 4. Reversing a melody swaps inc with dec and double with halve.
theorem(reverse_inverts) :- forall(melody(M), ( melody2prog(M, P), reverse(M, R), melody2prog(R, PR), reverse(P, P1), maplist([X, Y]>>( member(X-Y, [inc-dec, dec-inc, keep-keep, double-halve, halve-double]) -> true ), P1, PR) )).
