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
    // Outlets connecting to various storyboard UI elements
    @IBOutlet var headerTextView: UITextView!
    @IBOutlet var jobTextView: UITextView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // Background color & highlighted color for selected cells
    let defaultColor = Globals.singleton.defaultColor
    let selectedColor = Globals.singleton.selectedColor
    
    // Variables for state filename and job selected from table view
    var stateFilename: String!
    var selectedJob: JobIncomeData!
    
    // Variables to hold list of all jobs in selected states and ...
    // ... filtered job list from search bar
    var jobList: [JobIncomeData] = []
    var jobListFiltered: [JobIncomeData] = []
    
    // Called once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTextView.text = "<Job Title Goes Here>"
        
        // Set background color for entire view & constituent components
        self.view.backgroundColor = defaultColor
        self.searchBar.searchBarStyle = UISearchBar.Style.minimal
        
        let components = [self.headerTextView, self.jobTextView, self.tableView]
        for component in components {
            component?.backgroundColor = defaultColor
        }
        
        // Initial setup for search bar & table view
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        // Load all job income data for the selected state
        jobList = Globals.singleton.loadIncomeData(stateFilename: stateFilename!)
        
        // Initially, display all jobs in the table view
        jobListFiltered = jobList
    }

    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        jobListFiltered = Globals.singleton.searchIncomes(jobList: jobList, searchText: searchText)
        
        self.tableView.reloadData()
    }
    
    // # of rows in table view = number of jobs in filtered list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobListFiltered.count
    }
    
    // For a given cell, display the appropriate title from the filtered job list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobIncomeCell", for: indexPath)
        cell.textLabel?.text = jobListFiltered[indexPath.row].title
        return cell
    }
    
    // Have each table view cell set to the default background color
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = defaultColor
    }
    
    // When a new job is selected, (1) highlight the selected cell and
    // (2) update the `selectedJob` variable & display the selected job on screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // (1)
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = selectedColor
        
        // (2)
        selectedJob = jobListFiltered[indexPath.row]
        let jobFontSize = Globals.singleton.maxFontSize(s: selectedJob.title, maxChars: 30, defaultSize: 24)
        jobTextView.text = selectedJob.title
        jobTextView.font = jobTextView.font?.withSize(CGFloat(jobFontSize))
    }
    
    // If a cell is de-selected, have it return to the default background color
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = defaultColor
    }
    
    // Send data about selected state & job to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SingleJobOutputA",
           let destination = segue.destination as? SingleJobOutputA {
            destination.stateName = stateFilename.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.selectedJob = selectedJob
            destination.stateCostOfLiving = Globals.singleton.costOfLiving(stateFilename: stateFilename)
        }
    }
}
