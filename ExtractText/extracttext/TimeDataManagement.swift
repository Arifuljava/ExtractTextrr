//
//  TimeDataManagement.swift
//  ExtractText
//
//  Created by sang on 28/8/24.
//

import Foundation

public class TimeDataManagement{
    func trackingList(targetList: [String]) -> [String] {
        var timeList: [String] = []
        
        for targetWord in targetList {
            if targetWord.isEmpty || targetWord.trimmingCharacters(in: .whitespaces).isEmpty {
                // Do nothing
            } else {
                timeList.append(targetWord)
            }
        }
        
        return timeList
    }

    func removeNullDataFromTimeList(groupsList: [[String: [String]]]) -> [String: [String]] {
        var timeListGroup: [String: [String]] = [:]
        if !groupsList.isEmpty {
            for map in groupsList {
                if !map.isEmpty {
                    for (key, values) in map {
                            let trackingList = trackingList(targetList: values)
                            timeListGroup[key] = trackingList
                    }
                }
            }
        }

        return timeListGroup
    }
    func sortByKey(map: [String: [String]]) -> [(key: String, value: [String])] {
        var sortedMap: [String: [String]] = [:]
        let tupleArray: [(key: String, value: [String])] = map.map { (key, value) in
            return (key: key, value: value)
        }
        let dictionary: [String: [String]] = Dictionary(uniqueKeysWithValues: tupleArray)
        var maindata: [(key: String, value: [String])] = []
        let datamanagement = DataManagement()
        maindata = datamanagement.sortDictionaryByKeys(dictionary: dictionary)
        return maindata
    }

    func createDateAndTimeGroup(groupsList: [[String: [String]]]) -> ([String: [String]], [String: [String]]) {
        var datelistrroup: [String: [String]] = [:]
        var timelistgroup: [String: [String]] = [:]

        if !groupsList.isEmpty {
            for (i, currentMap) in groupsList.enumerated() {
                if let targetList = currentMap["\(i)"], !targetList.isEmpty {
                    let formattedList = formatTimes(targetList)
                    timelistgroup["\(i)"] = formattedList
                }
            }
        }

        return (datelistrroup, timelistgroup)
    }
    func formatTimes(_ originalList: [String]) -> [String] {
        var formattedList: [String] = []

        for (i, item) in originalList.enumerated() {
            var word = ""

            if item.count > 2 {
                if item.contains(":") {
                    let colons = countColons(item)
                    
                    if colons > 1 {
                        let timeParts = extractTimeParts(item)
                        for var timePart in timeParts {
                            timePart = replacedData(in: timePart)
                            word = extractDate(from: timePart)
                            word = replacedData(in: word)
                            formattedList.append(word)
                        }
                    } else {
                        let colonIndex = item.firstIndex(of: ":")?.utf16Offset(in: item) ?? -1
                        let count = item.count - colonIndex - 1
                        if count > 3 {
                            let timeParts = extractTimeParts(item)
                            for var timePart in timeParts {
                                timePart = replacedData(in:timePart)
                                word = extractDate(from: timePart)
                                word = replacedData(in:word)
                                formattedList.append(word)
                            }
                            
                            let startIndex = item.index(item.startIndex, offsetBy: colonIndex + 2)
                            let extractedSubstring = String(item[startIndex...])
                            var numbers = countNumbers(in: extractedSubstring)
                            
                            if numbers >= 6 {
                                if numbers == 6 {
                                    let secondItem = i > 0 ? originalList[i-1] : "50"
                                    word = splitIntoPairs(extractedSubstring, previousData: secondItem)
                                    word = replacedData(in:word)
                                    formattedList.append(word)
                                } else {
                                    let secondItem = i > 0 ? originalList[i-1] : "50"
                                    word = splitIntoPairs(extractedSubstring, previousData: secondItem)
                                    word = replacedData(in:word)
                                    formattedList.append(word)
                                }
                            } else if numbers == 5 {
                                let secondItem = i > 0 ? originalList[i-1] : "50"
                                let kk = extractedSubstring.dropFirst(2)
                                word = String(extractedSubstring.prefix(2)) + ":" + kk
                                word = replacedData(in:word)
                                formattedList.append(word)
                            } else if numbers < 5 {
                                word = extractedSubstring
                                formattedList.append(word)
                            }
                        } else {
                            let countBefore = colonIndex
                            if countBefore <= 8 {
                                let timeParts = extractTimeParts(item)
                                for var timePart in timeParts {
                                    timePart = replacedData(in:timePart)
                                    word = extractDate(from: timePart)
                                    word = replacedData(in:word)
                                    formattedList.append(word)
                                }
                            } else {
                                let extractedSubstring = String(item.prefix(6))
                                var numbers = countNumbers(in: extractedSubstring)
                                
                                if numbers >= 6 {
                                    if numbers == 6 {
                                        let secondItem = i > 0 ? originalList[i-1] : "50"
                                        word = splitIntoPairs(extractedSubstring, previousData: secondItem)
                                        word = replacedData(in:word)
                                        formattedList.append(word)
                                    } else {
                                        let secondItem = i > 0 ? originalList[i-1] : "50"
                                        word = splitIntoPairs(extractedSubstring, previousData: secondItem)
                                        word = replacedData(in:word)
                                        formattedList.append(word)
                                    }
                                } else if numbers == 5 {
                                    let secondItem = i > 0 ? originalList[i-1] : "50"
                                    let kk = extractedSubstring.dropFirst(2)
                                    word = String(extractedSubstring.prefix(2)) + ":" + kk
                                    word = replacedData(in:word)
                                    formattedList.append(word)
                                } else if numbers < 5 {
                                    word = extractedSubstring
                                    formattedList.append(word)
                                }
                                
                                let timeParts = extractTimeParts(item)
                                for var timePart in timeParts {
                                    timePart = replacedData(in:timePart)
                                    word = extractDate(from: timePart)
                                    word = replacedData(in:word)
                                    formattedList.append(word)
                                }
                            }
                        }
                    }
                } else {
                    let numbers = countNumbers(in: item)
                    
                    if numbers >= 6 {
                        if numbers == 6 {
                            let secondItem = i > 0 ? originalList[i-1] : "50"
                            word = splitIntoPairs(item, previousData: secondItem)
                            word = replacedData(in:word)
                            formattedList.append(word)
                        } else {
                            let secondItem = i > 0 ? originalList[i-1] : "50"
                            word = splitIntoPairs(item, previousData: secondItem)
                            word = replacedData(in: word)
                            formattedList.append(word)
                        }
                    } else if numbers == 5 {
                        let secondItem = i > 0 ? originalList[i-1] : "50"
                        let kk = item.dropFirst(2)
                        word = String(item.prefix(2)) + ":" + kk
                        word = replacedData(in: word)
                        formattedList.append(word)
                    } else if numbers < 5 {
                        word = item
                        formattedList.append(word)
                    }
                }
            }
        }
        
        return formattedList
    }
    private func countColons(_ text: String?) -> Int {
        guard let text = text, !text.isEmpty else {
            return 0
        }

        var count = 0
        for char in text {
            if char == ":" {
                count += 1
            }
        }
        return count
    }
    func extractTimeParts(_ input: String) -> [String] {
        var result = [String]()
        let regex = try! NSRegularExpression(pattern: "(\\d{0,2}):(\\d{0,2})", options: [])
        let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        for match in matches {
            if let leftRange = Range(match.range(at: 1), in: input),
               let rightRange = Range(match.range(at: 2), in: input) {
                var leftPart = String(input[leftRange])
                var rightPart = String(input[rightRange])
                
                if leftPart.count == 1 {
                    leftPart = "0" + leftPart
                }
                if rightPart.count == 1 {
                    rightPart = "0" + rightPart
                }
                
                result.append("\(leftPart):\(rightPart)")
            }
        }
        
        return result
    }
    func replacedData(in input: String) -> String {
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
    private func extractDate(from targetWord: String) -> String {
        var extractDate = ""

        if targetWord.count >= 7 {
            if targetWord.count == 7 {
                if targetWord.range(of: "\\d{4}:\\d{2}", options: .regularExpression) != nil {
                    extractDate = String(targetWord.dropFirst(2))
                } else {
                    extractDate = String(targetWord.dropFirst(2))
                }
            } else if targetWord.count >= 7 {
                if targetWord.range(of: "\\d{4}:\\d{2}", options: .regularExpression) != nil {
                    extractDate = String(targetWord.dropFirst(3))
                } else {
                    extractDate = String(targetWord.dropFirst(3))
                }
            }
        } else if targetWord.count == 6 {
            let count = countDigitsAfterColon(targetWord)
            
            if count > 1 {
                extractDate = String(targetWord.dropFirst(1))
            } else {
                print("KKIIIII \(targetWord): \(count)")
                extractDate = String(targetWord.dropFirst(2)) + "0"
            }
        } else {
            extractDate = targetWord
        }

        extractDate = replacedData(in: extractDate)
        return extractDate
    }
    func countDigitsAfterColon(_ input: String) -> Int {
        guard let colonIndex = input.firstIndex(of: ":") else {
            return 0
        }
        
        let afterColon = input[input.index(after: colonIndex)...]
        let digitsOnly = afterColon.filter { $0.isNumber }
        return digitsOnly.count
    }
    func splitIntoPairs(_ input: String, previousData: String) -> String {
        var word = " "
        var parts: [String] = []
        var previousDataParts: [String] = []

        for j in stride(from: 0, to: input.count, by: 2) {
            let endIndex = min(j + 2, input.count)
            let startIndex = input.index(input.startIndex, offsetBy: j)
            let endIndexIndex = input.index(input.startIndex, offsetBy: endIndex)
            let substring = String(input[startIndex..<endIndexIndex])
            parts.append(substring)
        }

        for j in stride(from: 0, to: previousData.count, by: 2) {
            let endIndex = min(j + 2, previousData.count)
            let startIndex = previousData.index(previousData.startIndex, offsetBy: j)
            let endIndexIndex = previousData.index(previousData.startIndex, offsetBy: endIndex)
            let substring = String(previousData[startIndex..<endIndexIndex])
            previousDataParts.append(substring)
        }

        var suffix = ""
        var prefix = "00" // Default value if not enough parts are available

        if parts.count > 1 {
            suffix = parts[1]
        }
        if parts.count > 2 {
            prefix = parts[2]
            if previousDataParts.count > 1 {
                var previousMin = removeSpecialCharactersAndSpaces(previousDataParts[1])
                if prefix.count < 2, let previousMinInt = Int(previousMin) {
                    if previousMinInt > 30 {
                        prefix = "5" + prefix
                    } else {
                        prefix = "0" + prefix
                    }
                }
            }
        }

        word = suffix + ":" + prefix
        return word
    }

    func removeSpecialCharactersAndSpaces(_ input: String) -> String {
        let allowedCharacters = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return input.filter { allowedCharacters.contains($0) }
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
    func createRange(userdataGiven: [String]) -> [String] {
        var createRangeList: [String] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        for i in 0..<userdataGiven.count - 1 {
            do {
                if let time1 = dateFormatter.date(from: userdataGiven[i]),
                   let time2 = dateFormatter.date(from: userdataGiven[i + 1]) {
                    let time1Millis = time1.timeIntervalSince1970 * 1000
                    let time2Millis = time2.timeIntervalSince1970 * 1000
                    let midpointMillis = time1Millis + (time2Millis - time1Millis) / 2
                    createRangeList.append(String(midpointMillis))
                }
            } catch {
                print("Error parsing dates: \(error)")
            }
        }

        createRangeList = convertLongListToTimeList(timeInMillisList: createRangeList)
        return createRangeList
    }
    func convertLongListToTimeList(timeInMillisList: [String]) -> [String] {
        var formattedTimeList: [String] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        for timeInMillis in timeInMillisList {
            if let millis = Double(timeInMillis) {
                let date = Date(timeIntervalSince1970: millis / 1000)
                let formattedTime = dateFormatter.string(from: date)
                formattedTimeList.append(formattedTime)
            }
        }

        return formattedTimeList
    }
    
}
