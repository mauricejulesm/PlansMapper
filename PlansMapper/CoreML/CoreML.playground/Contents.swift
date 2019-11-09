/*:
# Building Machine Learning Custom models to classfy texts
*/
import Foundation
import CreateML
import NaturalLanguage


// 1 - Loading dataset
let inputURL = URL(
	fileURLWithPath: "/Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/CoreML/RestaurantReviews.json")
let dataset = try MLDataTable(contentsOf: inputURL)

// 2 - Splitting into training and test sets
let (trainingSet, testSet) = dataset.randomSplit(by: 0.8, seed: 7)

// 3 - Creating the model
let model  = try MLTextClassifier(
	trainingData: trainingSet,
	textColumn: "text",
	labelColumn: "label"
)

// 4 - Evaluating the model
let testMetrics = model.evaluation(on: testSet)
let testAccuracy = (1 - testMetrics.classificationError) * 100
let confusionMatrix = testMetrics.confusion
let precisionRecall = testMetrics.precisionRecall
let errorRate = testMetrics.error

// 5 - Saving the model
let outputURL = URL(
	fileURLWithPath: "/Users/falcon/Desktop/Temporary/PlansMapper/PlansCategorizer.mlmodel"
)
try model.write(to: outputURL)
