//
//  1State2JobInput3b.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit

// View where user selects two jobs to compare in a given state
class _1State2JobInput3b: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Outlets connecting to various storyboard UI elements
    @IBOutlet var jobTextView1: UITextView!
    @IBOutlet var jobTextView2: UITextView!
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables for state filename & jobs selected from each table view
    var stateFilename: String!
    var selectedJob1: JobProjectionData!
    var selectedJob2: JobProjectionData!
    
    // List of all jobs & filtered job lists from search bar
    var jobList: [JobProjectionData] = []
    var filteredList1: [JobProjectionData] = []
    var filteredList2: [JobProjectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTextView1.text = "<Job 1 Goes Here>"
        jobTextView2.text = "& <Job 2 Goes Here>"
        
        self.searchBar1.delegate = self
        self.searchBar2.delegate = self
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
    
        // Load all job projection data for the selected state
        jobList = Globals.singleton.loadProjectionData(stateFilename: stateFilename!)
        
        // Initially, display all jobs in both text views
        filteredList1 = jobList
        filteredList2 = jobList
    }
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == searchBar1 {
            filteredList1 = Globals.singleton.searchProjections(jobList: jobList, searchText: searchText)
            
            self.tableView1.reloadData()
        } else {
            filteredList2 = Globals.singleton.searchProjections(jobList: jobList, searchText: searchText)
            
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
            let cell = tableView1.dequeueReusableCell(withIdentifier: "JobProjectionCell", for: indexPath)
            cell.textLabel?.text = filteredList1[indexPath.row].title
            return cell
        } else {
            let cell = tableView2.dequeueReusableCell(withIdentifier: "JobProjectionCell", for: indexPath)
            cell.textLabel?.text = filteredList2[indexPath.row].title
            return cell
        }
    }
    
    // When a new job job is selected, update the relevant class variable and ...
    // ... display the selected job on screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            selectedJob1 = filteredList1[indexPath.row]
            let jobFontSize = Globals.singleton.maxFontSize(s: selectedJob1.title, maxChars: 30, defaultSize: 24)
            jobTextView1.text = "\(selectedJob1.title)"
            jobTextView1.font = jobTextView1.font?.withSize(CGFloat(jobFontSize))
        } else {
            selectedJob2 = filteredList2[indexPath.row]
            let jobFontSize = Globals.singleton.maxFontSize(s: selectedJob2.title, maxChars: 30, defaultSize: 24)
            jobTextView2.text = "& \(selectedJob2.title)"
            jobTextView2.font = jobTextView2.font?.withSize(CGFloat(jobFontSize))
        }
    }
    
    // Send data about selected state & jobs to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "1State2JobOutputB",
           let destination = segue.destination as? _1State2JobOutputB {
            destination.stateName = stateFilename.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.selectedJob1 = selectedJob1
            destination.selectedJob2 = selectedJob2
        }
    }
}
