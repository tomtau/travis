Haskell Travis Client
=====================

A simple client implementation using [Travis CI API](http://docs.travis-ci.com/api/).
[![travis build status](https://img.shields.io/travis/tomtau/travis.svg)](https://travis-ci.org/tomtau/travis)

Usage
-----

```Haskell
import Travis
import qualified Travis.Types as T
import Data.Maybe

example :: IO ()
example = do
    (Just repository, Just builds) <- fetchRepository "ghc" "ghc"

    putStrLn $ show $ T.id repository
    putStrLn $ T.slug repository
    putStrLn $ show $ T.last_build_id repository
    putStrLn "Builds:"
    mapM_ (\build -> putStrLn $ show $ T._id build) builds
```
Plans/Open Issues
-----------------
- [ ] More precise parsing / types (dates, config, ...)
- [ ] Github Authentication
- [ ] Github Private and Enterprise repos
- [ ] Remaining Travis CI API (cancelling and restarting jobs, account info, ...)

Contributing
------------

There are no specific guidelines as of yet, however feel free to submit pull requests
and/or open issues.
