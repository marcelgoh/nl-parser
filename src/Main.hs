import Parse
import Grammar

main = do putStrLn "Enter a sentence: "
          inputStr <- getLine
          let wordList = breakStr inputStr
          putStrLn $ listToStr $ labelParts wordList
          print (cyk grammar wordList)
