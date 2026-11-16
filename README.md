# melody2prog

turn a melody into a program and back. Notes are MIDI numbers; each interval between neighbouring notes is an instruction for an accumulator: a step up (1 or 2) adds one, a step down subtracts one, a repeat keeps it, a leap up (3 or more) doubles and a leap down halves. prog2melody/3 writes a canonical melody for a program, so programs round-trip through music, and transposing a melody never changes its program.

## Use

```prolog
?- use_module(prolog/melody2prog).
?- melody2prog([60, 62, 67, 65], P).   % P = [inc, double, dec]
?- run([inc, double, dec], 0, A).      % A = 1
?- prog2melody([inc, double, dec], 60, M).   % M = [60, 62, 67, 65]
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every program of length 0..5 over the five instructions; every melody of length 0..4 over notes 60..66.

1. Every program round-trips through its canonical melody.
2. Transposing a melody never changes its program.
3. A melody of N notes gives N - 1 instructions (none for 0 or 1 notes).
4. Reversing a melody swaps inc with dec and double with halve.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
