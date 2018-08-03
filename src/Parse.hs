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

-- Converts a dictionary to printable form
-- * Primarily for debugging, inefficient! *
dictToStr :: [(String, [String])] -> String
dictToStr = buildStr []
  where
    buildStr str list =
      case list of
        []   -> str
        t:ts -> buildStr (str ++ (fst t) ++ ": " ++ (listToStr $ snd t) ++ "\n") ts

-- Looks up a word in dictionary and returns part of speech
-- If word is not found, returns "?"
lookUp :: String -> String
lookUp = searchDict Grammar.lexicon
  where
    searchDict dict str =
      case dict of
        []           -> "?"
        (part, list):ps -> if str `elem` list
                              then part
                              else searchDict ps str

labelParts :: [String] -> [String]
labelParts = map lookUp

-- An implementation of the CYK algorithm to determine if a list of terminals
-- adheres to the grammar's rules.
-- Based on this implementation: https://github.com/agorenst/cyk/blob/master/cyk.pdf
cyk :: [Rule] -> [String] -> Bool
cyk rules list =
  let n = length list
      matrix :: [Rule] -> [String] -> Array (Int, Int) [String]
      matrix rs ss =
        let terms = validTerm rules
            nonTerms = validNonTerm rules
            m = array ((0, 0), (n-1, n-1))
                      ([((i, i), terms (ss!!i))     | i <- [0 .. n-1]] ++
                       [((r, r+1), generators r l)  | l <- [1 .. n-1],
                                                      r <- [0 .. n-l-1]])
                         where generators :: Int -> Int -> [String]
                               generators r l =
                                 nub $ concat [nonTerms (b, c) | t <- [0 .. l-1],
                                                                 b <- m!(r, r+t),
                                                                 c <- m!(r+t+1, r+1)]
        in m
  in "TP" `elem` ((matrix rules list) ! (0, n-1))
