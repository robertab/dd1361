{-
Författare: Robert Åberg, Sara Ervik
Laboration: Inet, DD1361

Klientdelen för laboration i inet. Hanterar saldokoll genom
att skriva och läsa från filer. Detsamma gäller uttagskoder.

Skickar/mottager meddelande genom en socket handle.
-}


module Client where

import           Network.Socket
import           System.Directory (removeFile)
import           System.IO


{- Ta ut pengar. Tar in sträng och gör om till Integer för att kunna utföra aritmetiska
beräkningar. Konverterar tillbaka och lägger in i en kopia till indata-}
withdraw :: String -> String -> String
withdraw amount users = unwords $ (withdraw' amount (words users))
  where withdraw' amount (x1:x2:balance:xs) =
          x1:x2: show ((read balance :: Integer) - (read amount :: Integer)) : xs

{- Sätt in pengar. Tar in sträng och gör om till Integer för att kunna utföra aritmetiska
beräkningar. Konverterar tillbaka och lägger in i en kopia till indata-}
deposit :: String -> String -> String
deposit amount users = unwords $ (deposit' amount (words users))
  where deposit' amount (x1:x2:balance:xs) =
          x1:x2:show ((read balance :: Integer) + (read amount :: Integer)) : xs

-- Visar saldot
showBalance :: String -> String -> IO ()
showBalance msg amount = putStrLn $ ((lines msg)!!13) ++ amount

{-
Menyhantering. Beroende på menyval görs olika hanteringar.
Läser från filer för att hantera saldo och uttagskoder
-}
handle :: String -> String-> Handle -> IO ()
handle usersfile msg hdl = do loop usersfile msg hdl
  where loop usersfile msg hdl =
          do showMenu msg
             putStr "> "
             choice <- getLine
             case choice of
               "1" ->
                 do file <- readFile $ (words usersfile !! 0 ++ ".txt")
                    showBalance msg ((words file) !! 2) -- Show balance
                    loop file msg hdl
               "2" ->
                 do putStrLn ((lines msg)!!15) >> putStr "> " -- Ask for two digit code
                    code <- getLine
                    if elem code (drop 3 (words usersfile))
                       then do putStrLn ((lines msg)!!20) >> putStr "> " --Ask for amount
                               amount <- getLine
                               let updatedfile = withdraw amount usersfile
                               removeFile ((words updatedfile) !! 0 ++ ".txt")
                               writeFile ((words updatedfile) !! 0 ++ ".txt") updatedfile
                               showBalance msg ((words updatedfile) !! 2)
                               loop updatedfile msg hdl
                       else do putStrLn ((lines msg)!!17) >>  putStrLn ((lines msg)!!18) >> loop usersfile msg hdl -- Show error
               "3" ->
                 do putStrLn ((lines msg)!!20) >> putStr "> " -- Ask for amount
                    amount <- getLine
                    let updatedfile = deposit amount usersfile
                    removeFile ((words updatedfile) !! 0 ++ ".txt")
                    writeFile ((words updatedfile) !! 0 ++ ".txt") updatedfile
                    showBalance msg ((words updatedfile) !! 2)
                    loop updatedfile msg hdl
               "4" -> putStrLn ((lines msg)!!22) >> hPutStrLn hdl "Logged out "

-- Frågar efter kortnummer. Skickar och mottager från server
getCardNumber :: Handle -> String -> String ->  IO String
getCardNumber hdl message cdnr = do
             hPutStrLn hdl cdnr
             login <- hGetLine hdl
             return login

-- Frågar efter pinkod. Skickar och mottager från server
getPinCode :: Handle -> String -> IO String
getPinCode hdl message = do
             putStrLn ((lines message)!!9) >> putStr "> " --Enter pin code
             pincode <- getLine
             hPutStrLn hdl pincode
             verified <- hGetLine hdl
             return verified

{-
Intierar clienten. Ansluter till given port.

Frågar efter kortnummer och skickar detta till server för verifiering.
Fortsätter med pinkoden och gör likadant. Beroende på om det verifierades
eller ej skickas man vidare till meny för vidare hantering respektive felmeddelande
vilket gör att man frågar efter nytt kortnummer
-}
client :: IO ()
client =
  withSocketsDo $
  do h <- connecting (8036 :: PortNumber)
     welcomeMsg <- readFile "welcome.txt"
     putStr welcomeMsg >> putStr "> "
     language <- getLine
     message <- readFile (language ++ ".txt")
     loop h message
     hClose h
  where loop hdl message =  do
               putStrLn ((lines message)!!7) >> putStr "> "-- Enter cardnumber
               cardnumber <- getLine
               login <- getCardNumber hdl message cardnumber
               case login of
                 "1" -> do
                   usersfile <- readFile (cardnumber ++ ".txt")
                   verified <- getPinCode hdl message
                   case verified of
                     "1" -> do handle usersfile message hdl
                     "2" -> do putStrLn ((lines message)!!11) >> loop hdl message -- Error msg
                 "2" -> do loop hdl message

{-
Funktion för ansluting till server. Tar portnummer som indata
och skapar en socket handler (ReadWriteMode) för att kunna skicka info mellan server
och klient.
-}
connecting :: PortNumber -> IO Handle
connecting port =
  do skt <- socket AF_INET Stream 0
     localhost <- inet_addr "127.0.0.1"
     let sktAddr = SockAddrInet port localhost
       in connect skt sktAddr
     hdl <- socketToHandle skt ReadWriteMode
     return hdl

showMenu :: String -> IO ()
showMenu message = putStrLn $ unlines . take 5 . lines $ message -- Menu
