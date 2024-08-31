//
//  DataManagement .swift
//  ExtractText
//
//  Created by sang on 27/8/24.
//

import Foundation
public class DataManagement {
    func extractTimeSequence(from input: String, using sequence: [[String]]) -> [String] {
        let pattern = #"(\d{2,4}:\d{2})(?:\((\d+)\))?"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let nsRange = NSRange(input.startIndex..<input.endIndex, in: input)
        let matches = regex.matches(in: input, range: nsRange)
        let flatSequence = sequence.flatMap { $0 }
        var result: [String] = []
        var sequenceIndex = 0
        for match in matches {
            if let timeRange = Range(match.range(at: 1), in: input),
               let numberRange = Range(match.range(at: 2), in: input) {
                let time = String(input[timeRange])
                let number = String(input[numberRange])
                if sequenceIndex < flatSequence.count && number == flatSequence[sequenceIndex] {
                    result.append(time)
                    sequenceIndex += 1
                }
            }
        }
        
        return result
    }
    
    func sortDictionaryByKeys(dictionary: [String: [String]]) -> [(key: String, value: [String])] {
        let sortedDictionary = dictionary.sorted {
            guard let firstKey = Int($0.key), let secondKey = Int($1.key) else {
                return false
            }
            return firstKey < secondKey
        }
        return sortedDictionary
    }
    static func createMapUsingSize(_ integerList: [Int], detector: Int) -> [String: [String]] {
        var xListMap: [String: [String]] = [:]
        var index = 0
        var i = 0
        while i < integerList.count {
            var currentGroup: [String] = []
            var currentValue = integerList[i]
            currentGroup.append(String(currentValue))
            while i + 1 < integerList.count && abs(integerList[i + 1] - currentValue) < detector {
                i += 1
                currentValue = integerList[i]
                currentGroup.append(String(currentValue))
            }
            xListMap[String(index)] = currentGroup
            index += 1
            i += 1
        }
        return xListMap
    }
   
}
