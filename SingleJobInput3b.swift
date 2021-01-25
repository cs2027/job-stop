//
//  SingleJobInput3b.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit
import SwiftUI

// View where users searches for a job in the selected state
class SingleJobInput3b: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Outlets connecting to search bar & table view
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // Variables for state filename and job selected from table view
    var stateFilename: String!
    var selectedJob: JobProjectionData!
    
    // Variables to hold list of all jobs in selected states and ...
    // ... filtered job list from search bar
    var jobList: [JobProjectionData] = []
    var jobListFiltered: [JobProjectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Get path to job projection data for the selected state
        guard let filePath = Bundle.main.path(forResource: stateFilename, ofType: "csv", inDirectory: "income_job_datasets/job_growth_projections", forLocalization: nil) else {
            return
        }
        
        // Parse the file data as a string
        var fileData = ""
        do {
            fileData = try String(contentsOfFile: filePath)
        } catch {
            return
        }
        
        // Split the data into rows and remove the first header row
        var fileRows = fileData.components(separatedBy: "\n")
        fileRows.removeFirst()
        
        // Loop over each row ...
        for row in fileRows {
            // Parse the row data by separating different categories with semicolons, not commas ...
            // ... because some job titles include commas
            let rowCopy = row.replacingOccurrences(of: "\"", with: "")
            let commaIndices = findCommas(s: rowCopy)
            let comma1 = commaIndices[0]
            let comma2 = commaIndices[commaIndices.count - 7]
            
            let rowParsed = replaceSeparatorCommas(commaIndices: commaIndices, ignoreStart: comma1, ignoreEnd: comma2, s: rowCopy)
            
            // Separate the row data into categories
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
        
        // Initially, display all jobs in the text view
        jobListFiltered = jobList
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
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
        
        self.tableView.reloadData()
    }
    
    // Implement necessary methods for TableView object
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobListFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobProjectionCell", for: indexPath)
        cell.textLabel?.text = jobListFiltered[indexPath.row].title
        return cell
    }
    
    // When the user selects a TableView row, update the `selectedJob` variable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJob = jobListFiltered[indexPath.row]
    }
    
    // Send data about selected state & job to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SingleJobOutputB",
           let destination = segue.destination as? SingleJobOutputB {
            destination.stateName = stateFilename.capitalized
            destination.selectedJob = selectedJob
        }
    }
}
