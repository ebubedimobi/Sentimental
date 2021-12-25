//
//  Manager.swift
//  Sentimental
//
//  Created by Ebubechukwu Dimobi on 25.12.2021.
//

import Foundation

class Manager {
    
    let textClassifier = try? TextSentimentClassifier(configuration: .init())
    
    func getPrediction(on text: String) -> TextClassifierResult? {
        
        if let predictedText = try? textClassifier?.prediction(text: text).label {
            return TextClassifierResult(rawValue: predictedText)
        } else {
            return nil
        }
    }
}


enum TextClassifierResult: String {
    case pos = "Pos"
    case neutral = "Neutral"
    case negative = "Neg"
    
    var AnimationName: String {
        switch self {
        case .pos:
            return ["cat_happy", "mascot", "star"].randomElement() ?? "cat"
        case .neutral:
            return ["emoji_neutral", "swinging_neutral"].randomElement() ?? "emoji"
        case .negative:
            return ["cat_sad", "emoji_sad", "swinging_sad", "heart"].randomElement() ?? "heart"
        }
    }
    
    var outputText: String {
        switch self {
        case .pos:
            return "Positive: You are feeling good today!"
        case .neutral:
            return "Neutral: Don't worry it will get better"
        case .negative:
            return "Negative: I am scared! Who are you??!"
        }
    }
}
