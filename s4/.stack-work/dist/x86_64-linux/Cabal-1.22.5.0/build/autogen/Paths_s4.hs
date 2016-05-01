module Paths_s4 (
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

bindir     = "/home/robert/KTH/dd1361/s4/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/bin"
libdir     = "/home/robert/KTH/dd1361/s4/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/lib/x86_64-linux-ghc-7.10.3/s4-0.1.0.0-EFgflZrg4kFIOeFDBXukdQ"
datadir    = "/home/robert/KTH/dd1361/s4/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/share/x86_64-linux-ghc-7.10.3/s4-0.1.0.0"
libexecdir = "/home/robert/KTH/dd1361/s4/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/libexec"
sysconfdir = "/home/robert/KTH/dd1361/s4/.stack-work/install/x86_64-linux/lts-5.14/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "s4_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "s4_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "s4_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "s4_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "s4_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
