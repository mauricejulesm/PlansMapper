/*:
# Building Machine Learning Custom models to classfy texts
*/
import Foundation
import CreateML
import NaturalLanguage


// MARK: 1- Loading plans dataset
let dataURL = URL(
//	fileURLWithPath: "/Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/RestaurantReviews.json")
fileURLWithPath: "/Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/PlansData.json")


let plansDataset = try MLDataTable(contentsOf: dataURL)

// MARK: 2- getting training and test data
let (trainingDataSet, testDataSet) = plansDataset.randomSplit(by: 0.7, seed: 6)

// MARK: 3- Creating the Machine Learning model
let mlModel  = try MLTextClassifier(
	trainingData: trainingDataSet,
	textColumn: "planText", labelColumn: "planCategory"
//	textColumn: "text", labelColumn: "label"
)

let mlMetadata = MLModelMetadata(author: "Jules Maurice M.", shortDescription: "This model uses plans list to train and provides accuracy through testing iterations.", license: "PlansMapper", version: "2.0")

// MARK: 4- Evaluating the ML model with testAccuracy confusion matrix and precision recall
let evaluationMetrics = mlModel.evaluation(on: testDataSet)

print("Training Metrics\n", mlModel.trainingMetrics)
print("Validation Metrics\n", mlModel.validationMetrics)
print("Evaluation Metrics\n", evaluationMetrics)


// MARK: 5- Saving the ML model to be used in and iOS project
let outputModelURL = URL(
	fileURLWithPath: "/Users/maurice/Desktop/Temporary/PlansMapper/PlansCategorizer.mlmodel"
)
try mlModel.write(to: outputModelURL, metadata: mlMetadata)








Parsing JSON records from /Users/maurice/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/PlansData.json
Successfully parsed 14 elements from the JSON file /Users/maurice/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/PlansData.json
Skipping automatic creation of validation set; training set has fewer than 50 points.

Parsing JSON records from /Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/RestaurantReviews.json
Successfully parsed 1000 elements from the JSON file /Users/falcon/Desktop/Academics/honors_project/THE_APP/PlansMapper/PlansMapper/NaturalLanguageProcessor/CoreML/RestaurantReviews.json
Automatically generating validation set from 5% of the data.
Tokenizing data and extracting features
50% complete
100% complete
Starting MaxEnt training with 667 samples
Iteration 1 training accuracy 0.491754
Iteration 2 training accuracy 0.881559
Iteration 3 training accuracy 0.968516
Iteration 4 training accuracy 0.995502
Finished MaxEnt training in 0.02 seconds
Training Metrics
----------------------------------
Number of examples: 667
Number of classes: 2
Accuracy: 100.00%

******CONFUSION MATRIX******
----------------------------------
True\Pred NEGATIVE  POSITIVE
NEGATIVE  339       0
POSITIVE  0         328

******PRECISION RECALL******
----------------------------------
Class    Precision(%)   Recall(%)
NEGATIVE 100.00         100.00
POSITIVE 100.00         100.00


Validation Metrics
----------------------------------
Number of examples: 34
Number of classes: 2
Accuracy: 97.06%

******CONFUSION MATRIX******
----------------------------------
True\Pred NEGATIVE  POSITIVE
NEGATIVE  14        1
POSITIVE  0         19

******PRECISION RECALL******
----------------------------------
Class    Precision(%)   Recall(%)
NEGATIVE 100.00         93.33
POSITIVE 95.00          100.00


Evaluation Metrics
----------------------------------
Number of examples: 299
Number of classes: 2
Accuracy: 78.60%

******CONFUSION MATRIX******
----------------------------------
True\Pred NEGATIVE  POSITIVE
NEGATIVE  110       36
POSITIVE  28        125

******PRECISION RECALL******
----------------------------------
Class    Precision(%)   Recall(%)
NEGATIVE 79.71          75.34
POSITIVE 77.64          81.70


