module Grammar where

-- All parts of speech recognised by the program.
-- Terminals in the context-free grammar
parts :: [String]
parts = ["Det", "N", "V", "Adj", "Adv", "P"]

-- A list of pairs where:
-- The first element is a part of speech
-- The second element is a list of words corresponding to the part of speech
lexicon :: [(String, [String])]
lexicon = zip parts [-- list of Det
                     ["a", "the"],
                     -- list of N
                     ["dog", "fox"],
                     -- list of V
                     ["jumps"],
                     -- list of Adj
                     ["brown", "lazy", "quick"],
                     -- list of Adv
                     ["dangerously", "furiously", "happily"],
                     -- list of P
                     ["over"]]

-- Represents context-free grammar in Chomsky normal form:
-- A variable goes to either two more variables or a terminal (a part of speech)
data Rule = NonTerm String String String
          | Term String String

-- Given a rule, returns the left-hand side of the production
ruleLHS :: Rule -> String
ruleLHS r =
  case r of
    NonTerm s _ _ -> s
    Term s _      -> s

-- List of rules in the context-free grammar
grammar :: [Rule]
grammar = [NonTerm "TP" "NP" "VP",
           NonTerm "NP" "DetP" "NP",
           NonTerm "NP" "AdjP" "NP",
           Term "NP" "N",
           NonTerm "VP" "VP" "PP",
           NonTerm "VP" "VP" "NP",
           NonTerm "VP" "AdvP" "VP",
           NonTerm "VP" "VP" "AdvP",
           Term "VP" "V",
           Term "AdjP" "Adj",
           Term "AdvP" "Adv",
           NonTerm "PP" "P'" "NP",
           -- special case: we do not allow a single preposition to be a PP
           Term "P'" "P",
           Term "DetP" "Det"]
