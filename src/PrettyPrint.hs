module PrettyPrint where

import Data.List (transpose)
import Text.PrettyPrint.Boxes

import DataTypes

class Boxable a where
  toBox :: a -> Box

instance Boxable Bool where
  toBox b = text (show b)

instance Boxable Integer where
  toBox i = text (show i)

instance Boxable Int where
  toBox i = text (show i)

instance Show a => Boxable [a] where
  toBox = text . show

instance (Show a, Show b) => Boxable (a,b) where
  toBox p  =  text (show p)

instance (Show a, Show b, Show c) => Boxable (a,b,c) where
  toBox p  =  text (show p)

instance (Show a, Show b, Show c, Show d) => Boxable (a,b,c,d) where
  toBox p  =  text (show p)

distToBox d = tabulate (map (\(e, p) -> [text (show p), toBox e]) (unpackD d))

instance (Boxable a, Ord a) => Boxable (Dist a) where
  toBox = distToBox

instance Ord a => Eq (Dist a) where
  d1 == d2  =  unpackD d1 == unpackD d2

instance Ord a => Ord (Dist a) where
  d1 <= d2  =  unpackD d1 <= unpackD d2

instance (Ord a, Boxable a) => Show (Dist a) where
  show = render . distToBox

tabulate :: [[Box]] -> Box
tabulate rs = table
  where
   heights  = map (maximum . map rows) rs
   rs''     = zipWith (\r h -> map (alignVert top h) r) rs heights
   columns  = transpose rs''
   widths   = map (maximum . map cols) columns
   rs'      = transpose (zipWith (\c w -> map (alignHoriz left w) c) columns widths)
   columns' = map (hsep 3 top) rs'
   table    = vsep 0 left columns'