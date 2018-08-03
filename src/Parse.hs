module Parse where

import Data.Char
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

