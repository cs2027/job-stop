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
        state1TextView.text = "Compare Projections For: \(state1Filename.capitalized.replacingOccurrences(of: "_", with: " "))"
        state2TextView.text = "And: \(state2Filename.capitalized.replacingOccurrences(of: "_", with: " "))"
        
        // Load the job growth projection data for both states
        // Initially set the filtered lists equal to the complete list as well
        jobList1 = Globals.singleton.loadProjectionData(stateFilename: state1Filename!)
        jobList2 = Globals.singleton.loadProjectionData(stateFilename: state2Filename!)
        filteredList1 = jobList1
        filteredList2 = jobList2
    }
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == searchBar1 {
            filteredList1 = Globals.singleton.searchProjections(jobList: jobList1, searchText: searchText)
            
            self.tableView1.reloadData()
        } else {
            filteredList2 = Globals.singleton.searchProjections(jobList: jobList2, searchText: searchText)
            
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
            destination.state1Name = state1Filename.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.state2Name = state2Filename.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.selectedJob1 = selectedJob1
            destination.selectedJob2 = selectedJob2
        }
    }
}
