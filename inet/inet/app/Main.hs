{-
Författare: Robert Åberg, Sara Ervik
Laboration: Inet, DD1361

Serverdelen för laborationen i inet. Startar upp server och skapar
socket för vidare användning. Skickar meddelande mellan sockets
genom en socket handle. Mer information i varje funktion nedan
-}


module Main where

import           Control.Concurrent (forkIO)
import           Network.Socket
import           System.IO

allusers = ["4444", "5555", "6666"]

-- Validera kortnummer
validateCard  :: String -> Bool
validateCard cdnr = elem cdnr allusers

-- Validera användare gneom pinkod
validateUser :: String -> [String] -> Bool
validateUser pin (_:usrpin:_) =   pin == usrpin

{-
Skapar socket och sätter den öppen för två användare.
Hårdkodad socket, beroende på serverns portnummer
-}
main :: IO ()
main =
  do sock <- socket AF_INET Stream 0
     setSocketOption sock ReuseAddr 1
     bind sock (SockAddrInet 8036 iNADDR_ANY)
     listen sock 2
     putStrLn "Starting bank..."
     mainLoop sock

{-
huvudloop. Snurrar runt för att kunna ta emot fler klienter.
"Forkar" ut varje ansluting till egen tråd
-}
mainLoop :: Socket -> IO ()
mainLoop sock =
  do conn <- accept sock
     forkIO $ runConn conn
     mainLoop sock

{-
Funktion som sköter all informationsbyte mellan klient och server
Väntar på meddelande från socket handeln och besvarar på samma
-}
runConn :: (Socket, SockAddr) -> IO ()
runConn (sock,_) =
  do hdl <- socketToHandle sock ReadWriteMode
     hSetBuffering hdl NoBuffering
     putStrLn "Client connected... "
     cardnumber <- hGetLine hdl
     usersfile <- readFile (cardnumber ++ ".txt")
     if validateCard cardnumber
        then do hPutStrLn hdl "1" >> putStrLn "Cardnumber entered"
        else do hPutStrLn hdl "2"
     pincode <- hGetLine hdl
     if validateUser pincode
                     (take 2 $ words usersfile)
        then do hPutStrLn hdl "1" >> putStrLn "Client verified"
        else do hPutStrLn hdl "2"
     hGetLine hdl >>= putStrLn
     hClose hdl
