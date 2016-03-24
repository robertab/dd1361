module Paths_f21 (
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

bindir     = "/home/robert/KTH/dd1361/f2/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/bin"
libdir     = "/home/robert/KTH/dd1361/f2/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/lib/x86_64-linux-ghc-7.10.3/f21-0.1.0.0-LARnh0NxYjEFZDws62w3zx"
datadir    = "/home/robert/KTH/dd1361/f2/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/share/x86_64-linux-ghc-7.10.3/f21-0.1.0.0"
libexecdir = "/home/robert/KTH/dd1361/f2/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/libexec"
sysconfdir = "/home/robert/KTH/dd1361/f2/.stack-work/install/x86_64-linux/lts-5.9/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "f21_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "f21_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "f21_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "f21_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "f21_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
