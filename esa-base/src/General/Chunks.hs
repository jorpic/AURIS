{-|
Module      : General.Chunks
Description : Various functions to split data into chunks
Copyright   : (c) Michael Oswald, 2019
License     : BSD-3
Maintainer  : michael.oswald@onikudaki.net
Stability   : experimental
Portability : POSIX

This module provides some chunking functions for several data types as convenience
-}
module General.Chunks
  ( chunkedBy
  , chunkedByBS
  , chunks
  , chunksIntersperse
  )
where

import           RIO

import qualified RIO.ByteString                as BS
import qualified RIO.ByteString.Lazy           as B
import           RIO.List

-- | Chunk a @bs@ into list of smaller byte strings of no more than @n elements
chunkedBy :: Int -> B.ByteString -> [B.ByteString]
chunkedBy n bs = if B.length bs == 0
  then []
  else case B.splitAt (fromIntegral n) bs of
    (as, zs) -> as : chunkedBy n zs
{-# INLINABLE chunkedBy #-}

-- | Chunk a @bs@ into list of smaller byte strings of no more than @n elements
chunkedByBS :: Int -> BS.ByteString -> [BS.ByteString]
chunkedByBS n bs = if BS.length bs == 0
  then []
  else case BS.splitAt n bs of
    (as, zs) -> as : chunkedByBS n zs
{-# INLINABLE chunkedByBS #-}



-- | divides a list into chunks of sice @n@. Last chunk my be smaller
{-# INLINABLE chunks #-}
chunks :: Int -> [a] -> [[a]]
chunks = go
 where
  go _ [] = []
  go n xs = let (bef, aft) = splitAt n xs in bef : chunks n aft


-- | divides a list into chunks of size @n@, then adds @is as a separator
-- to the next chunk
{-# INLINABLE chunksIntersperse #-}
chunksIntersperse :: Int -> [a] -> [a] -> [[a]]
chunksIntersperse = go
 where
  go _ _ [] = []
  go n is xs =
    let (bef, aft) = splitAt n xs in bef : is : chunksIntersperse n is aft
