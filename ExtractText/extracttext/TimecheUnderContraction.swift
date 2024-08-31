//
//  TimecheUnderContraction.swift
//  ExtractText
//
//  Created by sang on 28/8/24.
//

import Foundation

public class TimecheUnderContraction{
    func checkingAlignment(timelistResult: [(key: String, value: [String])]) -> [(key: String, value: [String])] {
        var timelistGroup: [(key: String, value: [String])] = []
        
        // Convert array of tuples to dictionary for easier processing
        var dict: [String: [String]] = Dictionary(uniqueKeysWithValues: timelistResult)
        
        if !dict.isEmpty {
            for (key, dateValueList) in dict {
                guard let index = Int(key) else { continue }
                var dateValueList = dateValueList
                let countTotalColons = countTotalColons(valueList: dateValueList)
                let length = dateValueList.count
                
                if countTotalColons == length {
                    dateValueList.sort()
                    dateValueList = validateAndReplaceDigits(list: dateValueList)
                    dict[key] = dateValueList
                } else {
                    dateValueList = updateListWithColons(list: dateValueList)
                    dateValueList.sort()
                    dateValueList = validateAndReplaceDigits(list: dateValueList)
                    dict[key] = dateValueList
                }
            }
        }
        timelistGroup = dict.map { (key: $0.key, value: $0.value) }
        let dictionary: [String: [String]] = Dictionary(uniqueKeysWithValues: timelistGroup)
        let datamanagement = DataManagement()
        timelistGroup = datamanagement.sortDictionaryByKeys(dictionary: dictionary)
        
        return timelistGroup
    }
    func updateListWithColons(list: [String]) -> [String] {
        var updatedList = list
        
        for (index, value) in list.enumerated() {
            if !value.contains(":") {
                var getprevious: String
                if index - 1 < 0 {
                    getprevious = "07:58"
                } else {
                    getprevious = list[index - 1]
                }
                
                if getprevious.contains(":") {
                    if let colonIndex = getprevious.firstIndex(of: ":")?.utf16Offset(in: getprevious) {
                        if colonIndex < 2 {
                            if colonIndex == 0 {
                                getprevious = "00" + getprevious
                            } else {
                                getprevious = "0" + getprevious
                            }
                        } else {
                            getprevious = getprevious + "00"
                        }
                    }
                }
                let sanitizedPrevious = removeSpecialCharactersAndSpaces(getprevious)
                let newValue = splitIntoPairs(input: value, previousData: sanitizedPrevious)
                
                updatedList[index] = newValue
            }
        }
        return updatedList
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
    func validateAndReplaceDigits(list: [String]) -> [String] {
        var updatedList = list
        
        for (index, value) in list.enumerated() {
            let numbers = countNumbers(in: value)
            if numbers < 4 {
                let numbers222 = countNumbers(in: value)
                if numbers222 == 3 {
                    if value.contains(":") {
                        let parts = value.split(separator: ":")
                        if parts.count > 1 && parts[1].count < 2 {
                            let newValue = value + "0"
                            updatedList[index] = newValue
                        }
                    }
                } else {
                    var getprevious: String
                    if index - 1 < 0 {
                        getprevious = "07:58"
                    } else {
                        getprevious = list[index - 1]
                    }
                    
                    if getprevious.contains(":") {
                        let colonIndex = getprevious.firstIndex(of: ":")?.utf16Offset(in: getprevious) ?? 0
                        if colonIndex < 2 {
                            if colonIndex == 0 {
                                getprevious = "00" + getprevious
                            } else {
                                getprevious = "0" + getprevious
                            }
                        } else {
                            getprevious = getprevious + "00"
                        }
                    }
                    getprevious = removeSpecialCharactersAndSpaces(getprevious)
                    let newValue = splitIntoPairs(input: value, previousData: getprevious)
                    
                    updatedList[index] = newValue
                }
            }
        }
        return updatedList
    }
    func splitIntoPairs(input: String, previousData: String) -> String {
        var parts: [String] = []
        var previousDataParts: [String] = []

        // Split input into pairs
        for index in stride(from: 0, to: input.count, by: 2) {
            let start = input.index(input.startIndex, offsetBy: index)
            let end = input.index(start, offsetBy: min(2, input.count - index))
            parts.append(String(input[start..<end]))
        }

        // Split previousData into pairs
        for index in stride(from: 0, to: previousData.count, by: 2) {
            let start = previousData.index(previousData.startIndex, offsetBy: index)
            let end = previousData.index(start, offsetBy: min(2, previousData.count - index))
            previousDataParts.append(String(previousData[start..<end]))
        }

        var suffix = ""
        var prefix = "00"

        if parts.count > 1 {
            suffix = parts.count > 1 ? parts[1] : "00"
        }
        if parts.count > 2 {
            prefix = parts[2] // Safeguard for index 2
            if previousDataParts.count > 1 {
                let previousMin = removeSpecialCharactersAndSpaces(previousDataParts[1])
                if prefix.count < 2 {
                    if let previousMinValue = Int(previousMin), previousMinValue > 30 {
                        prefix = "5" + prefix
                    } else {
                        prefix = "0" + prefix
                    }
                }
            }
        }

        return suffix + ":" + prefix
    }
    func countTotalColons(valueList: [String]) -> Int {
        var totalColons = 0
        for value in valueList {
            totalColons += countColonskk(str: value)
        }
        return totalColons
    }

    // Function to count colons in a single string
    func countColonskk(str: String) -> Int {
        return str.filter { $0 == ":" }.count
    }
    func checkingTimeRange(timelistResult: [(key: String, value: [String])], rangelist: [String]) -> [(key: String, value: [String])] {
        var timelistrroup: [(key: String, value: [String])] = []
        
        for (i, datevalueList) in timelistResult.enumerated() {
            var datevalueList = datevalueList.value
            if datevalueList.count > 6 {
                datevalueList = makesix(listtarget: datevalueList)
            }
            print(datevalueList)
            print(rangelist)
            let validTimes = getValidTimes(datevalueList: datevalueList, rangelist: rangelist)
            if !validTimes.isEmpty {
                timelistrroup.append((key: "\(i)", value: validTimes))
             
            }
            
        }
        let datamanagement = DataManagement()
        let dictionary: [String: [String]] = Dictionary(uniqueKeysWithValues: timelistrroup)
        timelistrroup = datamanagement.sortDictionaryByKeys(dictionary: dictionary)
        return timelistrroup
    }
    private func getValidTimes(datevalueList: [String]?, rangelist: [String]) -> [String] {
        var validTimes = Array(repeating: "9999", count: 6)
        
        if let datevalueList = datevalueList {
            let timePattern = "^\\d{2}:\\d{2}$"
            
            for k in 0..<datevalueList.count {
                var time = datevalueList[k]
               
                var second = ""
                
                let matches = time.range(of: timePattern, options: .regularExpression) != nil
                if matches {
                    if time.contains("(B)") {
                        let parts = time.split(separator: "(B)").map { String($0).trimmingCharacters(in: .whitespaces) }
                        time = parts[0]
                        second = "(B)"
                    } else {
                        time = time.trimmingCharacters(in: .whitespaces)
                        second = ""
                    }
                    
                    let index = checkingTimeration(rangelist: rangelist, targettime: time)
                
                    
                    if index != "000" {
                        if let mainindex = Int(index) {
                            if validTimes[mainindex] == "9999" {
                                validTimes[mainindex] = time + second
                            } else {
                            
                                if mainindex == 5 {
                                    validTimes[mainindex] = time + second
                                } else {
                                    validTimes[mainindex + 1] = time + second
                                }
                            }
                        }
                    }
                } else {
                    var k = k
                    if k >= 6 {
                        k = 5
                    }
                    if validTimes[k] == "9999" {
                        validTimes[k] = time + second
                    } else {
                        validTimes[k] = time + second
                    }
                }
            }
        }
        return validTimes
    }
    func checkingTimeration(rangelist: [String], targettime: String) -> String {
        var index = "000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        do {
            guard let inputDate = dateFormatter.date(from: targettime),
                  let time1 = dateFormatter.date(from: rangelist[0]),
                  let time2 = dateFormatter.date(from: rangelist[1]),
                  let time3 = dateFormatter.date(from: rangelist[2]),
                  let time4 = dateFormatter.date(from: rangelist[3]),
                  let time5 = dateFormatter.date(from: rangelist[4]),
                  let time00 = dateFormatter.date(from: "07:00"),
                  let time06 = dateFormatter.date(from: "21:00") else {
                return index
            }
            
            if inputDate >= time00 && inputDate < time1 {
                index = "0"
            } else if inputDate >= time1 && inputDate < time2 {
                index = "1"
            } else if inputDate >= time2 && inputDate < time3 {
                index = "2"
            } else if inputDate >= time3 && inputDate < time4 {
                index = "3"
            } else if inputDate >= time4 && inputDate < time5 {
                index = "4"
            } else if inputDate >= time5 && inputDate < time06 {
                index = "5"
            }
            
        } catch {
            print("Error parsing dates: \(error)")
        }
        
        return index
    }
    func makesix(listtarget: [String]) -> [String] {
        var listupdate: [String] = []
        let size = 6
        
        for i in 0..<size {
            let kkk = listtarget[i]
            if !kkk.isEmpty {
                listupdate.append(kkk)
            }
        }
        
        return listupdate
    }

}
