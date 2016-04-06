module Paths_inet (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/robert/KTH/dd1361/inet/inet/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/bin"
libdir     = "/home/robert/KTH/dd1361/inet/inet/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/lib/x86_64-linux-ghc-7.10.3/inet-0.1.0.0-1OTwqVeVV1pITWTigucZJK"
datadir    = "/home/robert/KTH/dd1361/inet/inet/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/share/x86_64-linux-ghc-7.10.3/inet-0.1.0.0"
libexecdir = "/home/robert/KTH/dd1361/inet/inet/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/libexec"
sysconfdir = "/home/robert/KTH/dd1361/inet/inet/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "inet_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "inet_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "inet_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "inet_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "inet_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
