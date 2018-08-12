module Parse where

import Data.Array
import Data.Char
import Data.List

import Grammar

-- Parses a string into a list of words
breakStr :: String -> [String]
breakStr = buildWordList [] []
  where
    buildWordList list word str =
      case str of
        []   -> reverse ((reverse word) : list)
        c:cs -> if isSpace c
                   then buildWordList ((reverse word) : list) [] cs
                   else if isAlpha c
                           then buildWordList list (toLower c : word) cs
                           else buildWordList list word cs

-- Converts a list into a printable string
listToStr :: [String] -> String
listToStr = buildStr []
  where
    buildStr :: String -> [String] -> String
    buildStr str list =
      let attachToFront :: String -> String -> String
          attachToFront word sentence =
            case word of
              []   -> sentence
              c:cs -> attachToFront cs (c : sentence)
      in case list of
           []   -> '[' : (reverse $ ']' : (tail str))
           s:ss -> buildStr (' ' : (attachToFront s str)) ss

-- Looks up a word in dictionary and returns part of speech
-- If word is not found, returns "?"
lookUp :: String -> String
lookUp = searchDict lexicon
  where
    searchDict dict str =
      case dict of
        []           -> "?"
        (part, list):ps -> if str `elem` list
                              then part
                              else searchDict ps str

-- Given a list of words, returns a list of parts of speech
labelParts :: [String] -> [String]
labelParts = map lookUp

-- Take a list of parts of speech and apply rules to reduce it one step
reduceOneStep :: [String] -> [String]
reduceOneStep ss =
  let -- Replaces all terminals with valid LHS
      reduceSingles :: [String] -> [String]
      reduceSingles ss =
        let substitute str =
              case validSingle termRules str of
                [] -> str
                _  -> head $ validSingle termRules str
        in map substitute ss
      -- Scans each pair of strings for valid reductions in ruleset, then replaces both words with single LHS
      reducePairs :: [Rule] -> [String] -> [String]
      reducePairs rules ss =
        let reductions = map (validDouble rules) (zip ss (tail ss))
            replacePairs acc origList pairList =
              case pairList of
                []       -> reverse (head origList : acc)
                [str]:[] -> reverse (str : acc)
                []:_     -> replacePairs (head origList : acc) (tail origList) (tail pairList)
                [str]:_  -> replacePairs (str : acc) (tail $ tail origList) (tail $ tail pairList)
        in replacePairs [] ss reductions
      --applies one of the four rulesets with the following priority: terminals, complements, adjuncts, specifiers
      applyOneRule :: [String] -> [String]
      applyOneRule ss =
        let terms = reduceSingles ss
            ruleOrder = [compRules, adjRules, specRules]
            applyDouble ruleOrder ss =
              case ruleOrder of
                []   -> ss
                r:rs -> let doubles = reducePairs r ss
                        in if doubles /= ss
                              then doubles
                              else applyDouble rs ss
        in if terms /= ss
              then terms
              else applyDouble ruleOrder ss
  in applyOneRule ss

-- Creates a list of lists of strings, each one smaller than the last, by reducing until no change results
reduceMaximally :: [Rule] -> [String] -> [[String]]
reduceMaximally rs ss =
  let reduce acc ss =
        let stepForward = reduceOneStep ss
        in if ss == stepForward
              then reverse acc
              else reduce (stepForward : acc) stepForward
  in reduce [ss] ss
