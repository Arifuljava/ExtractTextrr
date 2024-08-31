//
//  ExtractTextFromImage.swift
//  ExtractText
//
//  Created by sang on 26/8/24.
//
protocol TextClassificationelegate: AnyObject {
    func canextractdata(extracttext : String,xcordinated : String)
    func cannotgetdata()
   
}

import Foundation
import Vision
import UIKit
class TextClassification{
    weak var delegate: TextClassificationelegate?
    static let shared = TextClassification()
    func recognizeText(from cgImage: CGImage) {
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error during text recognition: \(error)")
                self.delegate?.cannotgetdata()
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text recognized")
                self.delegate?.cannotgetdata()
                return
            }
            var groupedTimes = [String: [String]]()
            var recognizedText = ""
            var xcordinated = ""
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    var nextString = topCandidate.string

                    let countAlphabets = self.countAlphabets(in: nextString)
                    let countNumbers = self.countNumbers(in: nextString)
                    let countSpecialCharacters = self.countSpecialCharacters(in: nextString)
                    if countNumbers > countAlphabets && countNumbers > countSpecialCharacters{
                        if countNumbers >= 3 {
                            nextString = self.replaceCharacters(in: nextString)
                          
                            let boundingBox = observation.boundingBox
                                                    let x = boundingBox.origin.x * 100
                                                    let y = boundingBox.origin.y * 100
                            let xString = String(format: "%.0f", x)
                            let xcordinatedArray = nextString.components(separatedBy: " ")
                            for data in xcordinatedArray {
                              var   datakk = data + "(" + xString.description + ")"
                                recognizedText += datakk + " "
                                
                                xcordinated += xString.description + " "
                            }
                            
//print("Recognized string: \(nextString) at coordinates: (\(x), \(y))")
                                                    
                        
                        }
                    }
                }
            }
            self.delegate?.canextractdata(extracttext: recognizedText,xcordinated: xcordinated)
        }
        textRecognitionRequest.recognitionLevel = .accurate
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Failed to perform text recognition request: \(error)")
            self.delegate?.cannotgetdata()
        }
        
    }
    func countSpecialCharacters(in string: String) -> Int {
        let specialCharacters = CharacterSet.alphanumerics.inverted
        let specialCharCount = string.unicodeScalars.filter { specialCharacters.contains($0) }.count
        return specialCharCount
    }

    private func countNumbers(in text: String) -> Int {
        let pattern = "[0-9]"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return matches.count
        } catch {
            print("Invalid regex pattern")
            return 0
        }
    }
    private func countAlphabets(in text: String) -> Int {
        return text.filter { $0.isLetter }.count
    }
    func replaceCharacters(in input: String) -> String {
        return input
            .replacingOccurrences(of: "X", with: ":")
            .replacingOccurrences(of: "x", with: ":")
            .replacingOccurrences(of: "J", with: "1")
            .replacingOccurrences(of: "j", with: "1")
            .replacingOccurrences(of: "L", with: "1")
            .replacingOccurrences(of: "l", with: "1")
            .replacingOccurrences(of: "s", with: "5")
            .replacingOccurrences(of: "S", with: "5")
            .replacingOccurrences(of: "a", with: "8")
            .replacingOccurrences(of: "A", with: "8")
            .replacingOccurrences(of: "o", with: "0")
            .replacingOccurrences(of: "O", with: "0")
            .replacingOccurrences(of: "B", with: "8")
            .replacingOccurrences(of: "b", with: "2")
            .replacingOccurrences(of: "Þ", with: "2")
            .replacingOccurrences(of: "P", with: "9")
            .replacingOccurrences(of: "D", with: "0")
            .replacingOccurrences(of: "$", with: "3")
            .replacingOccurrences(of: ".", with: ":")
            .replacingOccurrences(of: "H", with: "4")
            .replacingOccurrences(of: "\"", with: ":")
            .replacingOccurrences(of: "*\"", with: " ")
            .replacingOccurrences(of: "\'", with: ":")
            .replacingOccurrences(of: "(", with: " ")
            .replacingOccurrences(of: ")", with: " ")
            .replacingOccurrences(of: "I", with: "1")
            .replacingOccurrences(of: "T", with: "1")
            .replacingOccurrences(of: "Z", with: "2")
            .replacingOccurrences(of: "z", with: "2")
            .replacingOccurrences(of: "|", with: " ")
            .replacingOccurrences(of: "į", with: "1")
            .replacingOccurrences(of: "þ", with: "1")
            .replacingOccurrences(of: "?", with: "2")
            .replacingOccurrences(of: "%", with: "3")
            .replacingOccurrences(of: "p", with: "2")
            .replacingOccurrences(of: "h", with: "1")
            .replacingOccurrences(of: "İ", with: "1")
            .replacingOccurrences(of: "i", with: "1")
            .replacingOccurrences(of: "*", with: ":")
            .replacingOccurrences(of: "\\", with: " ")
            .replacingOccurrences(of: "/", with: " ")
            .replacingOccurrences(of: "g", with: "0")
            .replacingOccurrences(of: "U", with: " ")
            .replacingOccurrences(of: "::", with: ":0")
            .replacingOccurrences(of: "-", with: ":")
            .replacingOccurrences(of: "N", with: ":")
            .replacingOccurrences(of: "[", with: ":")
            .replacingOccurrences(of: "\\/:", with: ":")
            .replacingOccurrences(of: "|/", with: " ")
            .replacingOccurrences(of: "T\"\\", with: ":")
            .replacingOccurrences(of: "|(", with: " ")
            .replacingOccurrences(of: " \"", with: ":")
            .replacingOccurrences(of: "#", with: "0")
            .replacingOccurrences(of: "]", with: "1")
    }
}
