{-# language OverloadedStrings #-}

module Lib where

import Options.Applicative hiding (command)
import Database.SQLite.Simple
import Data.Monoid ((<>))

data Command = Test | GetOptions
  deriving (Eq, Show, Read)

data Options = Options
    { file :: String
    , command :: Command
    } deriving (Show, Eq)
    
parseOpts :: Parser Options
parseOpts = Options
    <$> strOption
        ( long "database"
        <> short 'f'
        <> help "SQLite3 database name"
        )
    <*> option auto
        ( long "command"
        <> short 'c'
        <> help "Command (Test or GetOptions)"
        )

application :: IO ()
application = do
    opts <- execParser opts
    case (command opts) of
        Test -> testFTS5 (file opts)
        GetOptions -> getCompileOptions (file opts)
  where
    opts = info (parseOpts <**> helper)
        ( fullDesc
        <> progDesc "Test direct-sqlite's FTS5 capabilities"
        )


getCompileOptions :: String -> IO ()
getCompileOptions name = do
    withConnection name $ \conn -> do
        compopts <- query_ conn "PRAGMA compile_options" :: IO [Only String]
        print "SQLite compile options:"
        printStrings compopts

printStrings :: [Only String] -> IO ()
printStrings = mapM_ (print. fromOnly)

testFTS5 :: String -> IO ()
testFTS5 name = do
    withConnection name $ \conn -> do
        print "Creating FTS5 virtual table"
        execute_ conn "CREATE VIRTUAL TABLE fts5test USING fts5(content)"
        execute_ conn "INSERT INTO fts5test values (\"This is only a test\")"
        matches <- query conn "SELECT * FROM fts5test WHERE content MATCH (?)" (Only "test" :: Only String) :: IO [Only String]
        print "Here's the search results:" 
        printStrings matches
        execute_ conn "DROP TABLE fts5test"
