{-# LANGUAGE OverloadedStrings #-}


module HasHub.Yaml.ParserSpec where


import Test.Hspec

import Data.Either.Validation (Validation(..))

import HasHub.Yaml.Parser

import HasHub.Object.Object.Data
import HasHub.Object.Milestone.Data

import qualified HasHub.Fixture as F


spec :: Spec
spec = do
  describe "parse objects yaml file" $ do
    it "minimum parameter epic" $ do
      1 `shouldBe` 1
    describe "parse success" $ do
      it "minimum parameter epic" $ do
        let exp = Success $ [EpicYamlObject F.epicLinkNumber F.title F.emptyBody F.noEpicLinkNumbers F.noEstimate F.noMilestoneTitle F.noLabels F.noCollaborators F.noPipelineName]
        let act = parseObjects "test/yaml/objects/success/minimum_parameter_epic.yaml"
        act `shouldReturn` exp

      it "full parameter epic" $ do
        let exp = Success $ [EpicYamlObject F.epicLinkNumber F.title F.body F.parentEpicNumbers F.justEstimate F.justMilestoneTitle F.labels F.collaborators F.justPipelineName]
        let act = parseObjects "test/yaml/objects/success/full_parameter_epic.yaml"
        act `shouldReturn` exp

      it "epic and issue" $ do
        let exp = Success $ [EpicYamlObject F.epicLinkNumber F.title F.body F.noEpicLinkNumbers F.noEstimate F.noMilestoneTitle F.noLabels F.noCollaborators F.noPipelineName, IssueYamlObject F.title2 F.body2 F.noEpicLinkNumbers F.justEstimate F.justMilestoneTitle F.labels F.collaborators F.justPipelineName]
        let act = parseObjects "test/yaml/objects/success/epic_and_issue.yaml"
        act `shouldReturn` exp

      it "contained unknown key" $ do
        let exp = Success $ [EpicYamlObject F.epicLinkNumber F.title F.emptyBody F.noEpicLinkNumbers F.noEstimate F.noMilestoneTitle F.noLabels F.noCollaborators F.noPipelineName]
        let act = parseObjects "test/yaml/objects/success/contained_unknown_key.yaml"
        act `shouldReturn` exp

    describe "parse failure" $ do
      it "invalid yaml" $ do
        let exp = Failure ["invalid yaml file"]
        let act = parseObjects "test/yaml/failure/invalid_yaml.yaml"
        act `shouldReturn` exp

      it "no yaml file" $ do
        let exp = Failure ["no such File(test/yaml/failure/no_yaml_file.yaml)"]
        let act = parseObjects "test/yaml/failure/no_yaml_file.yaml"
        act `shouldReturn` exp

  describe "parse milestones yaml file" $ do
    let noStartOn = Nothing
    let noDueOn = Nothing

    describe "parse success" $ do
      it "minimum parameter milestone" $ do
        let exp = Success $ [YamlWrappedMilestone "sprint 1" noStartOn noDueOn]
        let act = parseMilestones "test/yaml/milestones/success/minimum_parameter_milestone.yaml"
        act `shouldReturn` exp

      it "full parameter milestone" $ do
        let exp = Success $ [YamlWrappedMilestone "sprint 1" (Just "2018-01-01") (Just "2018-01-31")]
        let act = parseMilestones "test/yaml/milestones/success/full_parameter_milestone.yaml"
        act `shouldReturn` exp

    describe "parse failure" $ do
      it "invalid yaml" $ do
        let exp = Failure ["invalid yaml file"]
        let act = parseObjects "test/yaml/failure/invalid_yaml.yaml"
        act `shouldReturn` exp

      it "no yaml file" $ do
        let exp = Failure ["no such File(test/yaml/failure/no_yaml_file.yaml)"]
        let act = parseObjects "test/yaml/failure/no_yaml_file.yaml"
        act `shouldReturn` exp
