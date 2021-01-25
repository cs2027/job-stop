//
//  1State2JobInput.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit
import SwiftUI

// View where user selects a state (to load the appropriate CSV file)
class _1State2JobInput: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Connections to search bar & table view
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // Variable to store the filename of the selected state
    var stateFilename: String!
    
    // List of all states
    let stateList = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
        "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
        "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
        "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
        "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma",
        "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas",
        "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    // List of states, filtered by search bar query
    var stateListFiltered: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.stateListFiltered = self.stateList
    }
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            stateListFiltered = stateList
        } else {
            stateListFiltered.removeAll()
            
            for state in stateList {
                if state.lowercased().contains(searchText.lowercased()) {
                    stateListFiltered.append(state)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    // Implement necessary methods for 'TableView' object
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateListFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath)
        cell.textLabel?.text = stateListFiltered[indexPath.row]
        return cell
    }
    
    // Update the `stateFilename` variable each time a new row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        stateFilename = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    
    // Pass the selected state filename via the segue to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "1State2JobInput2",
           let destination = segue.destination as? _1State2JobInput2 {
            destination.stateFilename = stateFilename
        }
    }
    
}
