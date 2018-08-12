import Parse
import Grammar

printParseTrace :: String -> [[String]] -> IO ()
printParseTrace sentence listlist = do let stepList = map listToStr listlist
                                       mapM_ putStrLn stepList
                                       putStrLn sentence

main = do putStrLn "Enter a sentence: "
          inputStr <- getLine
          let wordList = breakStr inputStr
          let partsList = labelParts wordList
          let steps = reverse $ reduceMaximally grammar partsList
          printParseTrace inputStr steps
          if head steps == ["TP"]
             then putStrLn "SENTENCE IS VALID."
             else putStrLn "SENTENCE IS NOT VALID."
