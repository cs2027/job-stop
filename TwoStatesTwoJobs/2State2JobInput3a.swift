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
    @IBOutlet var jobTextView1: UITextView!
    @IBOutlet var jobTextView2: UITextView!
    @IBOutlet var stateTextView1: UITextView!
    @IBOutlet var stateTextView2: UITextView!
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables to hold (1) state filenames and (2) the jobs to compare
    var stateFilename1: String!
    var stateFilename2: String!
    var selectedJob1: JobIncomeData!
    var selectedJob2: JobIncomeData!
    
    // List of all jobs & filtered job lists from search bar
    var jobList1: [JobIncomeData] = []
    var jobList2: [JobIncomeData] = []
    var filteredList1: [JobIncomeData] = []
    var filteredList2: [JobIncomeData] = []
    
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
        
        // Add appropriate text to storyboard
        stateTextView1.text = "Incomes: (\(stateFilename1.capitalized.replacingOccurrences(of: "_", with: " ")))"
        stateTextView2.text = "& (\(stateFilename2.capitalized.replacingOccurrences(of: "_", with: " ")))"
        
        // Load all jobs for the selected states, initially set the filtered lists to these complete lists
        jobList1 = Globals.singleton.loadIncomeData(stateFilename: stateFilename1!)
        jobList2 = Globals.singleton.loadIncomeData(stateFilename: stateFilename2!)
        filteredList1 = jobList1
        filteredList2 = jobList2
    }
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == searchBar1 {
            filteredList1 = Globals.singleton.searchIncomes(jobList: jobList1, searchText: searchText)
            
            self.tableView1.reloadData()
        } else {
            filteredList2 = Globals.singleton.searchIncomes(jobList: jobList2, searchText: searchText)
            
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
    
    // When a row is selected, update the `selectedJob{1, 2}` variable ...
    // ... and display the selected job on screen
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
        if segue.identifier == "2State2JobOutputA",
           let destination = segue.destination as? _2State2JobOutputA {
            destination.stateName1 = stateFilename1.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.stateName2 = stateFilename2.capitalized.replacingOccurrences(of: "_", with: " ")
            destination.selectedJob1 = selectedJob1
            destination.selectedJob2 = selectedJob2
            destination.stateCostOfLiving1 = Globals.singleton.costOfLiving(stateFilename: stateFilename1!)
            destination.stateCostOfLiving2 = Globals.singleton.costOfLiving(stateFilename: stateFilename2!)
        }
    }
}
