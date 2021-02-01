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
    @IBOutlet var jobTextView1: UITextView!
    @IBOutlet var jobTextView2: UITextView!
    @IBOutlet var stateTextView1: UITextView!
    @IBOutlet var stateTextView2: UITextView!
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables to hold state filenames & jobs selected for comparison
    var stateFilename1: String!
    var stateFilename2: String!
    var selectedJob1: JobProjectionData!
    var selectedJob2: JobProjectionData!
    
    // List of all jobs in both states, filtered list of jobs in both states (based on search bar queries)
    var jobList1: [JobProjectionData] = []
    var jobList2: [JobProjectionData] = []
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
        
        // Display appropriate text in storyboard based on selected states
        stateTextView1.text = "Projections: (\(stateFilename1.capitalized.replacingOccurrences(of: "_", with: " ")))"
        stateTextView2.text = "& (\(stateFilename2.capitalized.replacingOccurrences(of: "_", with: " ")))"
        
        // Load the job growth projection data for both states
        // Initially set the filtered lists equal to the complete list as well
        jobList1 = Globals.singleton.loadProjectionData(stateFilename: stateFilename1!)
        jobList2 = Globals.singleton.loadProjectionData(stateFilename: stateFilename2!)
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
    
    // When a new job is selected, update the `selectedJob{1, 2}` variables and ...
    // ... display the selected job title on screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            selectedJob1 = filteredList1[indexPath.row]
            let jobFontSize = Globals.singleton.maxFontSize(s: selectedJob1.title, maxChars: 30, defaultSize: 24)
            jobTextView1.text = "\(selectedJob1.title)"
            jobTextView1.font = jobTextView1.font?.withSize(CGFloat(jobFontSize))
        } else {
            selectedJob2 = filteredList2[indexPath.row]
            let jobFontSize = Globals.singleton.maxFontSize(s: selectedJob2.title, maxChars: 30, defaultSize: 24)
            jobTextView2.text = "\(selectedJob2.title)"
            jobTextView2.font = jobTextView2.font?.withSize(CGFloat(jobFontSize))
        }
    }
    
    // Send data about selected states & jobs to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "2State2JobOutputB",
           let destination = segue.destination as? _2State2JobOutputB {
            destination.stateName1 = stateFilename1.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.stateName2 = stateFilename2.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.selectedJob1 = selectedJob1
            destination.selectedJob2 = selectedJob2
        }
    }
}
