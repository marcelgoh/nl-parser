module Grammar where

-- All parts of speech recognised by the program
-- Terminals in the context-free grammar
parts :: [String]
parts = ["Det", "N", "V", "Adj", "Adv", "P", "C"]

-- A list of pairs where:
-- The first element is a part of speech
-- The second element is a list of words corresponding to the part of speech. Words must be in lowercase.
lexicon :: [(String, [String])]
lexicon = zip parts [-- list of Det
                     ["a", "the"],
                     -- list of N
                     ["articles", "berkeley", "bicycle", "boy", "breweries", "collection", "cover",
                      "dog", "fox", "girl", "ideas", "john", "jig", "leg", "man", "me", "room",
                      "stick", "students", "syntax", "tucson", "thursday"],
                     -- list of V
                     ["abound", "bores", "danced", "eat", "jumps", "hit", "hurts", "pleases", "said", "sleep"],
                     -- list of Adj
                     ["biggest", "brown", "colourless", "green", "lazy", "my", "quick", "red"],
                     -- list of Adv
                     ["dangerously", "furiously", "greatly", "happily"],
                     -- list of P
                     ["in", "of", "on", "over", "with"],
                     -- list of C
                     ["that"]]

-- Represents context-free grammar. Chomsky normal form is not required.
data Rule = Double String String String
          | Single String String

-- Given a rule, returns the left-hand side of the production
ruleLHS :: Rule -> String
ruleLHS r =
  case r of
    Double s _ _ -> s
    Single s _      -> s

-- Given the RHS of a double rule, return all valid LHS
validDouble :: [Rule] -> (String, String) -> [String]
validDouble rules (b, c) =
  let valid rhs =
        case rhs of
          (Double _ x y) -> x == b && y == c
          _               -> False
  in map ruleLHS (filter valid rules)

-- Given RHS of single rule, return all valid LHS
validSingle :: [Rule] -> String -> [String]
validSingle rules alpha =
  let valid rhs =
        case rhs of
          (Single _ x) -> x == alpha
          _          -> False
  in map ruleLHS (filter valid rules)

-- List of rules in the context-free grammar
-- Double rules are sorted into those governing complements, adjuncts, and specifiers
termRules = [Single "NP" "N",
             Single "VP" "V",
             Single "AdjP" "Adj",
             Single "AdvP" "Adv"]

compRules = [Double "PP" "P" "NP",
             Double "VP" "VP" "NP",
             Double "VP" "VP" "CP",
             Double "CP" "C" "TP"]

adjRules = [Double "VP" "VP" "PP",
            Double "NP" "AdjP" "NP",
            Double "VP" "AdvP" "VP",
            Double "VP" "VP" "AdvP",
            Double "NP" "NP" "PP"]

specRules = [Double "NP" "Det" "NP",
             Double "TP" "CP" "VP",
             Double "TP" "NP" "VP"]

grammar = termRules ++ adjRules ++ compRules ++ specRules
