//
//  SingleJobInput3a.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit
import SwiftUI

// View where user searches for job in selected state
class SingleJobInput3a: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Outlets connecting to search bar & table view
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // Variables for state filename and job selected from table view
    var stateFilename: String!
    var selectedJob: JobIncomeData!
    
    // Variables to hold list of all jobs in selected states and ...
    // ... filtered job list from search bar
    var jobList: [JobIncomeData] = []
    var jobListFiltered: [JobIncomeData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
            
            // Else, attempt to parse the row data ...
            let rowData = row.components(separatedBy: ",")
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
        
        // Initially, display all jobs in the text view
        jobListFiltered = jobList
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        cell.textLabel?.text = jobListFiltered[indexPath.row].title
        return cell
    }
    
    // When the user selects a TableView row, update the `selectedJob` variable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJob = jobListFiltered[indexPath.row]
    }
}
