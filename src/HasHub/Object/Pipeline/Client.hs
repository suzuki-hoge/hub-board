module HasHub.Object.Pipeline.Client
(
  referAll
, module HasHub.Object.Pipeline.Type
)
where


import HasHub.Object.Pipeline.IOType
import HasHub.Object.Pipeline.Type

import HasHub.Connection.Connector (getZenHub)


referAll :: IO [Pipeline]
referAll = do
  putStrLn "  refer all Pipelines"

  asPipelines <$> getZenHub ReferInput
