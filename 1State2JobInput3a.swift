//
//  1State2JobInput3a.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit
import SwiftUI

// View where user selects two jobs to compare in a given state
class _1State2JobInput3a: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Outlets for both search bars & table views
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables for state filename & jobs selected from each table view
    var stateFilename: String!
    var selectedJob1: JobIncomeData!
    var selectedJob2: JobIncomeData!
    
    // List of all jobs & filtered job lists from search bar
    var jobList: [JobIncomeData] = []
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
        
        // Get path to income data about the selected state
        guard let filePath = Bundle.main.path(forResource: stateFilename, ofType: "csv", inDirectory: "income_job_datasets/state_income_data", forLocalization: nil) else {
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
            // If we reach an empty row, there's no remaining data, so exit the loop
            if row == "" {
                break
            }
            
            // Parse the row data by separating different categories with semicolons, not commas ...
            // ... because some job titles include commas
            let rowCopy = row.replacingOccurrences(of: "\"", with: "")
            let commaIndices = findCommas(s: rowCopy)
            let comma1 = commaIndices[0]
            let comma2 = commaIndices[commaIndices.count - 7]
            
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
        
        // Initially, display all jobs in both text views
        filteredList1 = jobList
        filteredList2 = jobList
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
                filteredList1 = jobList
            } else {
                filteredList1.removeAll()
                
                for job in jobList {
                    if job.title.lowercased().contains(searchText.lowercased()) {
                        filteredList1.append(job)
                    }
                }
            }
            
            self.tableView1.reloadData()
        } else {
            if searchText == "" {
                filteredList2 = jobList
            } else {
                filteredList2.removeAll()
                
                for job in jobList {
                    if job.title.lowercased().contains(searchText.lowercased()) {
                        filteredList2.append(job)
                    }
                }
            }
            
            self.tableView2.reloadData()
        }
    }
    
    // Implement necessary methods for TableView object, dispatching based on `tableView1` vs. `tableView2`
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
    
    // Send data about selected state & jobs to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "1State2JobOutputA",
           let destination = segue.destination as? _1State2JobOutputA {
            destination.stateName = stateFilename.capitalized
            destination.selectedJob1 = selectedJob1
            destination.selectedJob2 = selectedJob2
        }
    }
}
