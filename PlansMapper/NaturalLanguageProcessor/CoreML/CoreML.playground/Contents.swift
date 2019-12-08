/*:
# Building Machine Learning Custom models to classfy texts
*/
import Foundation
import CreateML
import NaturalLanguage


// MARK: 1- Loading plans dataset
let dataURL = URL(
	fileURLWithPath: "/Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/PlansData.json")
let plansDataset = try MLDataTable(contentsOf: dataURL)

// MARK: 2- getting training and test data
let (trainingDataSet, testDataSet) = plansDataset.randomSplit(by: 0.7, seed: 6)

// MARK: 3- Creating the Machine Learning model
let mlModel  = try MLTextClassifier(
	trainingData: trainingDataSet,
	textColumn: "planText",
	labelColumn: "planCategory"
)

let mlMetadata = MLModelMetadata(author: "Jules Maurice M.", shortDescription: "This model uses plans list to train and provides accuracy through testing iterations.", license: "PlansMapper", version: "2.0")

// MARK: 4- Evaluating the ML model with testAccuracy confusion matrix and precision recall
let planTestMetrics = mlModel.evaluation(on: testDataSet)
let testAccuracy = (1 - planTestMetrics.classificationError) * 100
let confusionMatrix = planTestMetrics.confusion
let precisionRecall = planTestMetrics.precisionRecall
let errorRate = planTestMetrics.error

// MARK: 5- Saving the ML model to be used in and iOS project
let outputModelURL = URL(
	fileURLWithPath: "/Users/maurice/Desktop/Temporary/PlansMapper/PlansCategorizer.mlmodel"
)
try mlModel.write(to: outputModelURL, metadata: mlMetadata)


Parsing JSON records from /Users/maurice/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/PlansData.json
Successfully parsed 14 elements from the JSON file /Users/maurice/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/PlansData.json
Skipping automatic creation of validation set; training set has fewer than 50 points.
