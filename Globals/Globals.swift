//
//  Globals.swift
//  JobStop
//
//  Created by Christopher Song on 1/30/21.
//

import Foundation
import UIKit

// Holds common variables and functions used by multiple classes
class Globals {
    // Make this class a singleton b/c we are only using it to store common vars/functions
    static let singleton = Globals()
    private init() {}
    
    // Global list of all states
    var stateList = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", 
        "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
        "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
        "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
        "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma",
        "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas",
        "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    // Colors to use throughout app (default background color, highlighted cell color when selected)
    var defaultColor = UIColor(red: CGFloat(175.0 / 255.0), green: CGFloat(225.0 / 255.0), blue: CGFloat(175.0 / 255.0), alpha: 1)
    var selectedColor = UIColor(red: CGFloat(175.0 / 255.0), green: CGFloat(225.0 / 255.0), blue: CGFloat(175.0 / 255.0), alpha: 0.5)
    
    // Loads income data for all jobs associated with a given state
    func loadIncomeData(stateFilename: String!) -> [JobIncomeData] {
        // List to hold job income data for the given state
        var jobList: [JobIncomeData] = []
        
        // Get path to income data about the selected state
        guard let filePath = Bundle.main.path(forResource: stateFilename, ofType: "csv", inDirectory: "income_job_datasets/state_income_data", forLocalization: nil) else {
            return []
        }
        
        // Parse the file data as a string
        var fileData = ""
        do {
            fileData = try String(contentsOfFile: filePath)
        } catch {
            return []
        }
        
        // Split the data into rows and remove the first header row
        var fileRows = fileData.components(separatedBy: "\n")
        fileRows.removeFirst()
        
        // Loop over each row ...
        for row in fileRows {
            // If row contains no relevant data, we have reached the end of the file, so break
            if row == "" {
                break
            }
            
            if !(row.lowercased().contains(stateFilename.replacingOccurrences(of: "_", with: " "))) {
                break
            }
            
            // Parse the row data by separating different categories with semicolons, not commas ...
            // ... because some job titles include commas
            let rowCopy = row.replacingOccurrences(of: "\"", with: "")
            let commaIndices = Globals.singleton.findCommas(s: rowCopy)
            let comma1 = commaIndices[0]
            var index = commaIndices.count - 1
            var comma2 = commaIndices[index]
            
            while index >= 0 && commaIndices[index] - commaIndices[index - 1] == 1 {
                index = index - 1
            }
            
            comma2 = commaIndices[index - 7]
            
            let rowParsed = Globals.singleton.replaceSeparatorCommas(commaIndices: commaIndices, ignoreStart: comma1, ignoreEnd: comma2, s: rowCopy)
            
            // Separate the row data into categories & attempt to parse each category ...
            let rowData = rowParsed.components(separatedBy: ";")
            
            guard let title = rowData[1] as String? else {
                continue
            }
            guard let hourlySalary = Double(rowData[6]) as Double? else {
                continue
            }
            guard let annualSalary = Int(rowData[7]) as Int? else {
                continue
            }
            
            // ... and if successful, create a new `JobIncomeData` object from this^^ data
            let job = JobIncomeData(title: title, hourlySalary: hourlySalary, annualSalary: annualSalary)
            jobList.append(job)
        }
        
        // Return the income data of the specified state
        return jobList
    }
    
    // Function that loads growth projection data associated with all jobs in a given state
    func loadProjectionData(stateFilename: String!) -> [JobProjectionData] {
        // List of growth projection data for all jobs in a state
        var jobList: [JobProjectionData] = []
        
        // Obtain file path to job growth projection data
        guard let filePath = Bundle.main.path(forResource: stateFilename, ofType: "csv", inDirectory: "income_job_datasets/job_growth_projections", forLocalization: nil) else {
            return []
        }
        
        // Parse the file data as a string
        var fileData = ""
        do {
            fileData = try String(contentsOfFile: filePath)
        } catch {
            return []
        }
        
        // Split the data into rows and remove the first header row
        var fileRows = fileData.components(separatedBy: "\n")
        fileRows.removeFirst()
        
        // Loop over each row ...
        for row in fileRows {
            // If row contains no relevant data, we have reached the end of the file, so break
            if row == "" {
                break
            }
            
            if !(row.lowercased().contains(stateFilename.replacingOccurrences(of: "_", with: " "))) {
                break
            }
            
            // Parse the row data by separating different categories with semicolons, not commas ...
            // ... because some job titles include commas
            let rowCopy = row.replacingOccurrences(of: "\"", with: "")
            let commaIndices = Globals.singleton.findCommas(s: rowCopy)
            let comma1 = commaIndices[0]
            var index = commaIndices.count - 1
            var comma2 = commaIndices[index]
            
            while index >= 0 && commaIndices[index] - commaIndices[index - 1] == 1 {
                index = index - 1
            }
            
            comma2 = commaIndices[index - 5]
            
            let rowParsed = Globals.singleton.replaceSeparatorCommas(commaIndices: commaIndices, ignoreStart: comma1, ignoreEnd: comma2, s: rowCopy)
            
            // Separate the row data into categories & attempt to parse each category ...
            let rowData = rowParsed.components(separatedBy: ";")
            
            // If we reach an empty data row, there's no remaining job data, so exit the loop
            if rowData[0] == "" {
                break
            }
            
            // Attempt to parse the different data categories ...
            guard let title = rowData[1] as String? else {
                continue
            }
            guard let currentJobs = Double(rowData[2]) as Double? else {
                continue
            }
            guard let projectedJobs = Double(rowData[3]) as Double? else {
                continue
            }
            guard let netChange = Double(rowData[4]) as Double? else {
                continue
            }
            guard let percentChange = Double(rowData[5]) as Double? else {
                continue
            }

            // ... and if successful, create a new `JobProjectionData` object
            let job = JobProjectionData(title: title, currentJobs: currentJobs, projectedJobs: projectedJobs, netChange: netChange, percentChange: percentChange)
            jobList.append(job)
        }
        
        // Return growth projection data for the specified state
        return jobList
    }
    
    // Determine the cost of living index for a given state
    func costOfLiving(stateFilename: String!) -> Double {
        // Parse the state name & create a variable to store the cost of living
        let stateName = stateFilename.replacingOccurrences(of: "_", with: " ")
        var costOfLiving: Double = 1.00
        
        // Obtain a path to the file w/ cost of living data
        guard let filePath = Bundle.main.path(forResource: "cost_of_living_data", ofType: "csv", inDirectory: "income_job_datasets", forLocalization: nil) else {
            return costOfLiving
        }
        
        // Parse the file data as a string
        var fileData = ""
        do {
            fileData = try String(contentsOfFile: filePath)
        } catch {
            return costOfLiving
        }
        
        // Split the data into rows and remove the first header row
        var fileRows = fileData.components(separatedBy: "\n")
        fileRows.removeFirst()
        
        // Loop over each row ...
        for row in fileRows {
            let rowData = row.components(separatedBy: ",")
            
            if rowData[0].lowercased() == stateName {
                costOfLiving = Double(rowData[1])! / 100.00
                break
            }
        }
        
        return costOfLiving
    }
    
    // Search bar functionality to filter down list of states
    func searchStates(stateList: [String], searchText: String) -> [String] {
        var stateListFiltered: [String] = []
        
        if searchText == "" {
            stateListFiltered = stateList
        } else {
            stateListFiltered.removeAll()
            
            for state in stateList {
                if state.lowercased().contains(searchText.lowercased()) {
                    stateListFiltered.append(state)
                }
            }
        }
        
        return stateListFiltered
        
    }
    
    // Search bar functionality to filter down list of jobs (for income data)
    func searchIncomes(jobList: [JobIncomeData], searchText: String) -> [JobIncomeData] {
        var jobListFiltered: [JobIncomeData] = []
        
        if searchText == "" {
            jobListFiltered = jobList
        } else {
            jobListFiltered.removeAll()
            
            for job in jobList {
                if job.title.lowercased().contains(searchText.lowercased()) {
                    jobListFiltered.append(job)
                }
            }
        }
            
        return jobListFiltered
    }
    
    // Search bar functionality to filter down list of jobs (for growth projection data)
    func searchProjections(jobList: [JobProjectionData], searchText: String) -> [JobProjectionData] {
        var jobListFiltered: [JobProjectionData] = []
        
        if searchText == "" {
            jobListFiltered = jobList
        } else {
            jobListFiltered.removeAll()
            
            for job in jobList {
                if job.title.lowercased().contains(searchText.lowercased()) {
                    jobListFiltered.append(job)
                }
            }
        }
        
        return jobListFiltered
    }
    
    // Replaces commas with semicolons in string `s` besides indices `ignoreStart...ignoreEnd`
    func replaceSeparatorCommas(commaIndices: [Int], ignoreStart: Int, ignoreEnd: Int, s: String) -> String {
        var sCopy = s
        
        for i in 0...(s.count - 1) {
            if i > ignoreStart && i < ignoreEnd {
                continue
            }
            
            if commaIndices.contains(i) {
                let index = s.index(s.startIndex, offsetBy: i)
                sCopy.replaceSubrange(index...index, with: [";"])
            }
        }
        
        return sCopy
    }
    
    // Finds comma indices in a string
    func findCommas(s: String) -> [Int] {
        var commaIndices: [Int] = []
        
        for i in 0...(s.count - 1) {
            let index = s.index(s.startIndex, offsetBy: i)
            
            if s[index] == "," {
                commaIndices.append(i)
            }
        }
        
        return commaIndices
    }
    
    // Determines the maximum reasonable font size for a string `s` in a fixed-sized 'TextView`
    func maxFontSize(s: String, maxChars: Int, defaultSize: Int) -> Int {
        let stringLen = s.count
        
        if stringLen <= maxChars {
            return defaultSize
        } else {
            return Int((maxChars * defaultSize) / stringLen)
        }
    }
}
