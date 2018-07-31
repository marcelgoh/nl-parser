module Dictionary where

-- all parts of speech recognised by the program
parts :: [String]
parts = ["Det", "N", "V", "Adj"]

-- a list of pairs where:
-- the first element is a part of speech
-- the second element is a list of words corresponding to the part of speech
dict :: [(String, [String])]
dict = zip parts [-- list of Det
                  ["a", "the"],
                  -- list of N
                  ["dog", "fox"],
                  -- list of V
                  ["jumps"],
                  -- list of Adj
                  ["brown", "lazy", "quick"]]
