import Cocoa
import CreateML

//1. Import Data as .csv
let dataSetFilePath = URL(fileURLWithPath: "/Users/ebubed/Desktop/Masters_first_year/Practical/Sentimental/DataSett.csv")
let data = try MLDataTable(contentsOf: dataSetFilePath)

//2. Preparing Data for Training and Evaluation
/// split training data and testingData to 80% to random data
let(trainigData, testingData) = data.randomSplit(by: 0.8, seed: 5)
///create a machine learning module using ML which uses NLP under the hood
let sentimentClassifier = try MLTextClassifier(trainingData: trainigData, textColumn: "text", labelColumn: "class")
let trainingMetrics = sentimentClassifier.evaluation(on: trainigData, textColumn: "text", labelColumn: "class")

//3. Evaluating the Classifier’s Accuracy
let trainingAccuracy = (1.0 - trainingMetrics.classificationError) * 100
/// test our data
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")
let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

//4. Saving the Model
///create metadata
let metadata = MLModelMetadata(author: "Dimobi Ebubechukwu", shortDescription: "A model trained to classify sentiments", license: nil, version: "1.0.0")
/// write to file path
let destinationPath = URL(fileURLWithPath: "/Users/ebubed/Desktop/Masters_first_year/Practical/Sentimental/TextSentimentClassifier")
try sentimentClassifier.write(to: destinationPath, metadata: metadata)

//trials
try sentimentClassifier.prediction(from: "I hate you")
try sentimentClassifier.prediction(from: "@apple i hate you")
try sentimentClassifier.prediction(from: "@apple Today is great")
try sentimentClassifier.prediction(from: "you are annoing but i like you")
try sentimentClassifier.prediction(from: "i just found the best restaurant ever")
