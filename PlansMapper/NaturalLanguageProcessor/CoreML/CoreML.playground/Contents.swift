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
	textColumn: "planText", labelColumn: "planCategory"
)

let mlMetadata = MLModelMetadata(author: "Jules Maurice M.", shortDescription: "This model uses plans list to train and provides accuracy through testing iterations.", license: "PlansMapper", version: "2.0")

// MARK: 4- Evaluating the ML model with testAccuracy confusion matrix and precision recall
let evaluationMetrics = mlModel.evaluation(on: testDataSet)

print("Training Metrics\n", mlModel.trainingMetrics)
print("Validation Metrics\n", mlModel.validationMetrics)
print("Evaluation Metrics\n", evaluationMetrics)


// MARK: 5- Saving the ML model to be used in and iOS project
let outputModelURL = URL(
	fileURLWithPath: "/Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansCategorizer.mlmodel"
)
try mlModel.write(to: outputModelURL, metadata: mlMetadata)
