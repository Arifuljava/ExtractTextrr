//
//  ViewController.swift
//  ExtractText
//
//  Created by sang on 26/8/24.
//

import UIKit
import Vision

class ViewController: UIViewController, TextClassificationelegate {
    func canextractdata(extracttext: String,xcordinated : String) {
        print(extracttext)
        let xcordinatedArray = xcordinated.components(separatedBy: " ")
        let intArray = xcordinatedArray.compactMap { Int($0) }
        let detector = 3
        var result = DataManagement.createMapUsingSize(intArray, detector: detector)
        let sortedDictionary = datamanagement.sortDictionaryByKeys(dictionary: result)
        datalist.removeAll()
        maindata.removeAll()
        for (key, value) in sortedDictionary {
            let sequence = [value]
            let extractedTimes = datamanagement.extractTimeSequence(from: extracttext, using: sequence)
            datalist[String(key)] = extractedTimes
        }
        maindata = datamanagement.sortDictionaryByKeys(dictionary: datalist)
        let convertedData: [[String: [String]]] = maindata.map { dict in
            return [dict.key: dict.value]
        }
        var (dateGroup, timeGroup) = timedatamanagement.createDateAndTimeGroup(groupsList: convertedData)
        timeGroup = timedatamanagement.removeNullDataFromTimeList(groupsList: [timeGroup])
        maindata.removeAll()
        maindata =  timedatamanagement.sortByKey(map: timeGroup)
        maindata =  timecheUnderContraction.checkingAlignment(timelistResult: maindata)
        let userDataGiven = ["08:00", "12:00", "13:00","17:00", "18:00", "20:00"]
        let timerangelist = timedatamanagement.createRange(userdataGiven: userDataGiven)
        maindata =  timecheUnderContraction.checkingTimeRange(timelistResult: maindata, rangelist: timerangelist)
    
        print(maindata)
    }
    
    func cannotgetdata() {
        print("VVVVV")
    }
    var datalist: [String: [String]] = [:]
    let textClassifier = TextClassification()
    let datamanagement = DataManagement()
    let timedatamanagement = TimeDataManagement()
    let timecheUnderContraction = TimecheUnderContraction()
    var maindata: [(key: String, value: [String])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        textClassifier.delegate = self
        
    }

    @IBAction func extracttext(_ sender: UIButton) {
        if let image = UIImage(named: "realimage_reed"),
           let cgImage = image.cgImage {
            textClassifier.recognizeText(from: cgImage);
        } else {
            print("Image not found")
        }

    }
    func groupTimesByDate(from inputString: String) -> [String: [String]] {
        let timeStrings = inputString.components(separatedBy: " ")
        var groupedTimes = [String: [String]]()
        for time in timeStrings {
            let date = String(time.prefix(2))
            if groupedTimes[date] != nil {
                if time.isEmpty || time == ""
                {
                    
                }
                else{
                    groupedTimes[date]?.append(time)
                }
                
            } else {
                if time.isEmpty || time == ""
                {
                    
                }
                else{
                    groupedTimes[date] = [time]
                }
                
            }
        }

        return groupedTimes
    }
}

