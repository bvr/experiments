module Kth where

import Data.List

findKth :: Ord a => Int -> [a] -> Maybe a
findKth k [] = Nothing
findKth k as = Just (loop (sort ls) rs)
  where (ls,rs) = splitAt k as

loop (k:_) [] = k
loop (k:ls) (r:rs)
  | r > k     = loop (insert r ls) rs
  | otherwise = loop (k:ls) rs
