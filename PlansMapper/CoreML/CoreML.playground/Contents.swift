/*:
# Building Machine Learning Custom models to classfy texts
*/
import Foundation
import CreateML
import NaturalLanguage


// MARK: 1- Loading plans dataset
let dataURL = URL(
	fileURLWithPath: "/Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/CoreML/PlansData.json")
let plansDataset = try MLDataTable(contentsOf: dataURL)

// MARK: 2- getting training and test data
let (trainingDataSet, testDataSet) = plansDataset.randomSplit(by: 0.8, seed: 7)

// MARK: 3- Creating the Machine Learning model
let mlModel  = try MLTextClassifier(
	trainingData: trainingDataSet,
	textColumn: "planText",
	labelColumn: "planCategory"
)

// MARK: 4- Evaluating the ML model with testAccuracy confusion matrix and precision recall
let testMetrics = mlModel.evaluation(on: testDataSet)
let testAccuracy = (1 - testMetrics.classificationError) * 100
let confusionMatrix = testMetrics.confusion
let precisionRecall = testMetrics.precisionRecall
let errorRate = testMetrics.error

let mlMetadata = MLModelMetadata(author: "Jules Maurice M.", shortDescription: "This model uses plans list to train and provides accuracy through testing iterations.", license: "PlansMapper", version: "2.0")

// MARK: 5- Saving the ML model to be used in and iOS project
let outputModelURL = URL(
	fileURLWithPath: "/Users/falcon/Desktop/Temporary/PlansMapper/PlansCategorizer.mlmodel"
)
try mlModel.write(to: outputModelURL, metadata: mlMetadata)
