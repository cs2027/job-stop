//
//  2State2JobInput3b.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit

// View where user selects two jobs to compare growth projections for
class _2State2JobInput3b: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Outlets connecting to various storyboard UI elements
    @IBOutlet var state1TextView: UITextView!
    @IBOutlet var state2TextView: UITextView!
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables to hold state filenames & jobs selected for comparison
    var state1Filename: String!
    var state2Filename: String!
    var selectedJob1: JobProjectionData!
    var selectedJob2: JobProjectionData!
    
    // List of all jobs in both states, filtered list of jobs in both states (based on search bar queries)
    var jobList1: [JobProjectionData] = []
    var jobList2: [JobProjectionData] = []
    var filteredList1: [JobProjectionData] = []
    var filteredList2: [JobProjectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar1.delegate = self
        self.searchBar2.delegate = self
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        
        // Display appropriate text in storyboard based on selected states
        state1TextView.text = "Compare Projections For: \(state1Filename.capitalized)"
        state2TextView.text = "And: \(state2Filename.capitalized)"
        
        // Load the job growth projection data for both states
        // Initially set the filtered lists equal to the complete list as well
        jobList1 = loadProjectionData(stateFilename: state1Filename!)
        jobList2 = loadProjectionData(stateFilename: state2Filename!)
        filteredList1 = jobList1
        filteredList2 = jobList2
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
            
            comma2 = commaIndices[index - 5]
            
            let rowParsed = replaceSeparatorCommas(commaIndices: commaIndices, ignoreStart: comma1, ignoreEnd: comma2, s: rowCopy)
            
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
    
    // Implement standard `TableView` methods, dispatching on `tableView1` vs. `tableView2`
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return filteredList1.count
        } else {
            return filteredList2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCell(withIdentifier: "JobProjectionCell", for: indexPath)
            cell.textLabel?.text = filteredList1[indexPath.row].title
            return cell
        } else {
            let cell = tableView2.dequeueReusableCell(withIdentifier: "JobProjectionCell", for: indexPath)
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
        if segue.identifier == "2State2JobOutputB",
           let destination = segue.destination as? _2State2JobOutputB {
            destination.state1Name = state1Filename.capitalized
            destination.state2Name = state2Filename.capitalized
            destination.selectedJob1 = selectedJob1
            destination.selectedJob2 = selectedJob2
        }
    }
}
