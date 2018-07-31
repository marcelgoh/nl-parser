import Data.Char
import Dictionary

-- parses a string into a list of words
breakStr :: String -> [String]
breakStr = buildWordList [] []
  where
    buildWordList list word str =
      case str of
        []   -> reverse ((reverse word) : list)
        c:cs -> if isSpace c
                   then buildWordList ((reverse word) : list) [] cs
                   else if isAlpha c
                           then buildWordList list (c : word) cs
                           else buildWordList list word cs

-- converts a list into a printable string
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

-- converts a dictionary to printable form
dictToStr :: [(String, [String])] -> String
dictToStr = buildStr []
  where
    buildStr str list =
      case list of
        []   -> str
        t:ts -> buildStr (str ++ (fst t) ++ ": " ++ (listToStr $ snd t) ++ "\n") ts

main = do putStrLn "Enter a sentence: "
          inputStr <- getLine
          let wordList = breakStr inputStr
          print $ show wordList
          putStrLn $ listToStr wordList
          putStrLn $ dictToStr Dictionary.dict
