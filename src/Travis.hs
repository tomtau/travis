{-# LANGUAGE OverloadedStrings #-}
{-|
Module      : Travis
Description : A simple client implementation using Travis CI API.
Copyright   : (c) Tomas Tauber, 2015
License     : MIT
Maintainer  : Tomas Tauber <tomtau@hku.hk>
Stability   : experimental

A simple client implementation using Travis CI API: <http://docs.travis-ci.com/api/>.
-}
module Travis where

import           Data.Aeson           (decode)
import           Network.HTTP.Conduit
import           Travis.Types         (BuildRaw (..), BuildsRaw (..),
                                       RepoRaw (..), RepositoryRaw (..))

type AccountName = String

type RepositoryName = String

-- |Travis CI base API URL
travisAPIBaseURL = "https://api.travis-ci.org/repos/" :: String
-- |Travis CI API v2 headers
requestH = [("Accept", "application/vnd.travis-ci.2+json"),
            ("User-Agent", "HaskellHTTPConduit/2.1.8")]

-- |fetches information about public repository on Travis CI
-- may return a tuple of repository and its builds information
fetchRepository :: AccountName -> RepositoryName -> IO (Maybe RepositoryRaw, Maybe BuildsRaw)
fetchRepository acname reponame = do
  -- repository info
  let coreUrl = travisAPIBaseURL ++ acname ++ "/" ++ reponame
  req1 <- parseUrl coreUrl
  let request1 = req1 { requestHeaders = requestH}
  manager <- newManager conduitManagerSettings
  _response1 <- httpLbs request1 manager
  let repository = decode (responseBody _response1) :: Maybe RepoRaw
  -- build info
  let buildsUrl = coreUrl ++ "/builds"
  req2 <- parseUrl buildsUrl
  let request2 = req2 { requestHeaders = requestH}
  _response2 <- httpLbs request2 manager
  let repobuilds = decode (responseBody _response2) :: Maybe BuildsRaw
  return (fmap repo repository, repobuilds)
