{-# LANGUAGE OverloadedStrings #-}

module HubBoard.Yaml.Parser (
    module HubBoard.Yaml.Parser.Converter
  , parse
  , parse'
) where

import           Data.Yaml                   ( decodeFileEither, ParseException(..) )

import           HubBoard.Yaml.Parser.RawType
import           HubBoard.Yaml.Parser.Converter
import           HubBoard.Yaml.Parser.Validator as V
import qualified HubBoard.Object.Milestone      as M
import qualified HubBoard.Object.Pipeline       as P

type SetupMilestone = RawMilestone -> IO (Maybe MilestoneNumber)
type FetchPipelines = IO [Pipeline]
type Validator = [RawEpic] -> RawMilestone -> RawDefaultPipelineName -> IO [ErrorMessage]

parse :: FilePath -> IO (Either [ErrorMessage] [Epic])
parse yaml = parse' yaml setupMilestone P.refer V.validateAll

parse' :: FilePath -> SetupMilestone -> FetchPipelines -> Validator -> IO (Either [ErrorMessage] [Epic])
parse' yaml setupMilestone fetchPipelines validator = do
    (Contents rawEpics rawMilestone rawDefaultPipelineName) <- read yaml 

    errorMessages <- validator rawEpics rawMilestone rawDefaultPipelineName
    
    case errorMessages of
        [] -> do
            milestoneNumber <- setupMilestone rawMilestone
            pipelines <- fetchPipelines

            return $ Right $ asEpics rawEpics milestoneNumber pipelines rawDefaultPipelineName
        es -> return $ Left es
  where
    read :: FilePath -> IO Contents
    read yaml = either (error . show) id <$> decodeFileEither yaml

setupMilestone :: RawMilestone -> IO (Maybe MilestoneNumber)
setupMilestone (RawMilestone Nothing Nothing) = return Nothing
setupMilestone (RawMilestone (Just (RawNewMilestone title startOn dueOn)) Nothing) =
    Just <$> M.create (title, startOn ++ "T00:00:00Z", dueOn ++ "T23:59:59Z")
setupMilestone (RawMilestone Nothing (Just (ExistingMilestone title))) =
    Just . MilestoneNumber . (!! 0) . concatMap (\(Milestone n t) -> [n | t == title]) <$> M.refer
