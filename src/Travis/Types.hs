{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module Travis.Types where

import           Data.Aeson       (FromJSON (..), ToJSON (..), Value (..),
                                   withObject, (.:))
import           Data.Aeson.Types (Object (..), Parser (..), defaultOptions,
                                   fieldLabelModifier, genericParseJSON,
                                   genericToJSON)
import           GHC.Generics     (Generic)

-- |Data types representing: <http://docs.travis-ci.com/api/?http#repositories>
-- TODO: more precise parsing / types
data RepoRaw =
  RepoRaw { repo :: RepositoryRaw
    } deriving (Show, Generic)

data RepositoryRaw =
  RepositoryRaw {  id                     :: Int
                 , slug                   :: String
                 , active                 :: Bool
                 , description            :: String
                 , last_build_id          :: Int
                 , last_build_number      :: String
                 , last_build_state       :: String
                 , last_build_duration    :: Int
                 , last_build_started_at  :: String
                 , last_build_finished_at :: String
                 , github_language        :: String
           } deriving (Show, Generic)

instance FromJSON RepositoryRaw
instance ToJSON RepositoryRaw

instance FromJSON RepoRaw
instance ToJSON RepoRaw

-- |Data types representing: <http://docs.travis-ci.com/api/?http#builds>
-- TODO: more precise parsing / types
data BuildsRaw =
  BuildsRaw { builds  :: [BuildRaw]
            , jobs    :: Maybe [Object]
            , commits :: [Object]
   } deriving (Show, Generic)

data BuildRaw =
  BuildRaw { _commit_id           :: Int
           , _config              :: Object
           , _duration            :: Int
           , _finished_at         :: String
           , _id                  :: Int
           , _job_ids             :: [Int]
           , _number              :: String
           , _pull_request        :: Bool
           , _pull_request_number :: Maybe Int
           , _pull_request_title  :: Maybe String
           , _repository_id       :: Int
           , _started_at          :: String
           , _state               :: String
           } deriving (Show, Generic)

instance FromJSON BuildsRaw
instance ToJSON BuildsRaw

instance FromJSON BuildRaw where
  parseJSON = genericParseJSON defaultOptions {
                fieldLabelModifier = drop 1 }

instance ToJSON BuildRaw where
  toJSON = genericToJSON defaultOptions {
             fieldLabelModifier = drop 1 }
