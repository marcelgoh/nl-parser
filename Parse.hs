breakStr :: String -> [String]
breakStr = buildWordList [] []
    where
      buildWordList list word str =
          case str of
            []     -> reverse ((reverse word) : list)
            ' ':xs -> buildWordList ((reverse word) : list) [] xs
            x:xs   -> buildWordList list (x : word) xs


main = do
         putStrLn "Enter a sentence: "
         inputStr <- getLine
         let wordList = breakStr inputStr
         print $ show wordList
