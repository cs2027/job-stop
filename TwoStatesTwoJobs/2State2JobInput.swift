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
    // Outlets connecting to various UI storyboard elements
    @IBOutlet var stateTextView1: UITextView!
    @IBOutlet var stateTextView2: UITextView!
    @IBOutlet var searchBar1: UISearchBar!
    @IBOutlet var searchBar2: UISearchBar!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    // Variables to store filenames of two selected states
    var stateFilename1: String!
    var stateFilename2: String!
    
    // List of all states
    let stateList = Globals.singleton.stateList
    
    // Filtered list of states, based on whether user types into search bars
    var stateListFiltered1: [String] = []
    var stateListFiltered2: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateTextView1.text = "State 1"
        stateTextView2.text = "State 2"
        
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
    
    // Each time a state is selected, update the `state{1, 2}Filename` variable ...
    // ... and display the selected state on screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            let cell = self.tableView1.cellForRow(at: indexPath)
            stateTextView1.text = "State 1: \(cell?.textLabel?.text ?? "State 1")"
            stateFilename1 = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
        } else {
            let cell = self.tableView2.cellForRow(at: indexPath)
            stateTextView2.text = "State 2: \(cell?.textLabel?.text ?? "State 2")"
            stateFilename2 = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
        }
    }
    
    // Pass data regarding the two selected states to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "2State2JobInput2",
           let destination = segue.destination as? _2State2JobInput2 {
            destination.stateFilename1 = stateFilename1
            destination.stateFilename2 = stateFilename2
        }
    }
}
