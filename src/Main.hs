import Parse
import Grammar

main = do putStrLn "Enter a sentence: "
          inputStr <- getLine
          let wordList = breakStr inputStr
          print $ show wordList
          putStrLn $ listToStr $ labelParts wordList
          putStrLn (ruleLHS (head grammar))
