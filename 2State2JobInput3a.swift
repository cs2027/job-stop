//
//  2State2JobInput3a.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit
import SwiftUI

// View where user selects two jobs to compare income data for
class _2State2JobInput3a: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Various outlets connecting to storyboard UI features
    @IBOutlet var state1TextView: UITextView!
    @IBOutlet var state2TextView: UITextView!
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables to hold (1) state filenames and (2) the jobs to compare
    var state1Filename: String!
    var state2Filename: String!
    var selectedJob1: JobIncomeData!
    var selectedJob2: JobIncomeData!
    
    // List of all jobs & filtered job lists from search bar
    var jobList1: [JobIncomeData] = []
    var jobList2: [JobIncomeData] = []
    var filteredList1: [JobIncomeData] = []
    var filteredList2: [JobIncomeData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar1.delegate = self
        self.searchBar2.delegate = self
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        
        // Add appropriate text to storyboard
        state1TextView.text = "Compare Income Data For: \(state1Filename.capitalized)"
        state2TextView.text = "And: \(state2Filename.capitalized)"
        
        // Load all jobs for the selected states, initially set the filtered lists to these complete lists
        jobList1 = loadIncomeData(stateFilename: state1Filename!)
        jobList2 = loadIncomeData(stateFilename: state2Filename!)
        filteredList1 = jobList1
        filteredList2 = jobList2
    }
    
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
            
            if !(row.contains(stateFilename.capitalized)) {
                break
            }
            
            // Parse the row data by separating different categories with semicolons, not commas ...
            // ... because some job titles include commas
            let rowCopy = row.replacingOccurrences(of: "\"", with: "")
            let commaIndices = findCommas(s: rowCopy)
            let comma1 = commaIndices[0]
            var index = commaIndices.count - 1
            var comma2 = commaIndices[index]
            
            while index >= 0 && commaIndices[index] - commaIndices[index - 1] == 1 {
                index = index - 1
            }
            
            comma2 = commaIndices[index - 7]
            
            let rowParsed = replaceSeparatorCommas(commaIndices: commaIndices, ignoreStart: comma1, ignoreEnd: comma2, s: rowCopy)
            
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
        if searchBar == searchBar1 {
            if searchText == "" {
                filteredList1 = jobList1
            } else {
                filteredList1.removeAll()
                
                for job in jobList1 {
                    if job.title.lowercased().contains(searchText.lowercased()) {
                        filteredList1.append(job)
                    }
                }
            }
            
            self.tableView1.reloadData()
        } else {
            if searchText == "" {
                filteredList2 = jobList2
            } else {
                filteredList2.removeAll()
                
                for job in jobList2 {
                    if job.title.lowercased().contains(searchText.lowercased()) {
                        filteredList2.append(job)
                    }
                }
            }
            
            self.tableView2.reloadData()
        }
    }
    
    // Implement standard `TableView` methods, dispatching based on `tableView1` vs. `tableView2`
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return filteredList1.count
        } else {
            return filteredList2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCell(withIdentifier: "JobIncomeCell", for: indexPath)
            cell.textLabel?.text = filteredList1[indexPath.row].title
            return cell
        } else {
            let cell = tableView2.dequeueReusableCell(withIdentifier: "JobIncomeCell", for: indexPath)
            cell.textLabel?.text = filteredList2[indexPath.row].title
            return cell
        }
    }
    
    // Update appropriate variable each time the user selects a job in either TableView object
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            selectedJob1 = filteredList1[indexPath.row]
        } else {
            selectedJob2 = filteredList2[indexPath.row]
        }
    }
    
    // Send data about selected states & jobs to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "2State2JobOutputA",
           let destination = segue.destination as? _2State2JobOutputA {
            destination.state1Name = state1Filename.capitalized
            destination.state2Name = state2Filename.capitalized
            destination.selectedJob1 = selectedJob1
            destination.selectedJob2 = selectedJob2
        }
    }
}
