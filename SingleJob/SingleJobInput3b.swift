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
        
        // Load all job projection data for the selected state
        jobList = Globals.singleton.loadProjectionData(stateFilename: stateFilename!)
        
        // Initially, display all jobs in the text view
        jobListFiltered = jobList
    }
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        jobListFiltered = Globals.singleton.searchProjections(jobList: jobList, searchText: searchText)
        
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
            destination.stateName = stateFilename.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.selectedJob = selectedJob
        }
    }
}