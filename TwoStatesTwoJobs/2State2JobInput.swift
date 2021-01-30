//
//  2State2JobInput.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit
import SwiftUI

// View where user selects two states to compare
class _2State2JobInput: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // Outlets for both search bars & table views
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables to store filenames of two selected states
    var state1Filename: String!
    var state2Filename: String!
    
    // List of all states
    let stateList = Globals.singleton.stateList
    
    // Filtered list of states, based on whether user types into search bars
    var stateListFiltered1: [String] = []
    var stateListFiltered2: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar1.delegate = self
        self.searchBar2.delegate = self
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        
        self.stateListFiltered1 = self.stateList
        self.stateListFiltered2 = self.stateList
    }
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == searchBar1 {
            stateListFiltered1 = Globals.singleton.searchStates(stateList: stateList, searchText: searchText)
            
            self.tableView1.reloadData()
        } else {
            stateListFiltered2 = Globals.singleton.searchStates(stateList: stateList, searchText: searchText)
            
            self.tableView2.reloadData()
        }
    }
    
    // Implement standard `TableView` methods, dispatching based on whether `tableView{1 or 2}` was selected
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return stateListFiltered1.count
        } else {
            return stateListFiltered2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath)
            cell.textLabel?.text = stateListFiltered1[indexPath.row]
            return cell
        } else {
            let cell = tableView2.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath)
            cell.textLabel?.text = stateListFiltered2[indexPath.row]
            return cell
        }
    }
    
    // Update the state filename variables each time a new state is selected in each `TableView` obj.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            let cell = self.tableView1.cellForRow(at: indexPath)
            state1Filename = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
        } else {
            let cell = self.tableView2.cellForRow(at: indexPath)
            state2Filename = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
        }
    }
    
    // Pass data regarding the two selected states to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "2State2JobInput2",
           let destination = segue.destination as? _2State2JobInput2 {
            destination.state1Filename = state1Filename
            destination.state2Filename = state2Filename
        }
    }
}
