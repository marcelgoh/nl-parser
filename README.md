# Natural-Language Parser

A program that parses English sentences. To compile and run, enter the following lines into a terminal (requires that you have the [Glasgow Haskell Compiler](https://www.haskell.org/ghc/) installed on your system):
```
$ ghc -o bin/Main -outputdir obj -isrc --make src/Main.hs
$ ./bin/Main
```
Enter a sentence into the prompt and the program will determine if the sentence is recognised by the grammar and print out some of the steps it went through in its computation. Example:
```
Enter a sentence:
The quick brown fox jumps over the lazy dog.
[TP]
[NP VP]
[NP VP PP]
[NP VP P NP]
[Det NP VP P Det NP]
[Det AdjP NP VP P Det NP]
[Det AdjP AdjP NP VP P Det AdjP NP]
[Det Adj Adj N V P Det Adj N]
The quick brown fox jumps over the lazy dog.
SENTENCE IS VALID.
```
A sentence is considered recognised by the grammar if it reduces to `[TP]`. For example, the following sentence is not recognised by the grammar:
```
Enter a sentence:
That the red dog jumps with the girl red.
[CP AdjP]
[C TP AdjP]
[C NP VP AdjP]
[C NP VP PP AdjP]
[C NP VP P NP AdjP]
[C Det NP VP P Det NP AdjP]
[C Det AdjP NP VP P Det NP AdjP]
[C Det Adj N V P Det N Adj]
That the red dog jumps with the girl red.
SENTENCE IS NOT VALID.
```
To add words to the lexicon or rules to the grammar, edit `/src/Grammar.hs`.