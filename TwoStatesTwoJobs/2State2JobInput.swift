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
    
    // Background color & highlighted color for selected cells
    let defaultColor = Globals.singleton.defaultColor
    let selectedColor = Globals.singleton.selectedColor
    
    // Variables to store: (1) state filenames, (2) list of all states,
    // (3) list of filtered states (by search bar query)
    var stateFilename1: String! = nil // (1)
    var stateFilename2: String! = nil
    let stateList = Globals.singleton.stateList // (2)
    var stateListFiltered1: [String] = [] // (3)
    var stateListFiltered2: [String] = []
    
    // Called once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateTextView1.text = "State 1"
        stateTextView2.text = "State 2"
        
        // Set background color for entire view & constituent components
        self.view.backgroundColor = defaultColor
        self.searchBar1.searchBarStyle = UISearchBar.Style.minimal
        self.searchBar2.searchBarStyle = UISearchBar.Style.minimal
        
        let components = [self.stateTextView1, self.stateTextView2, self.tableView1, self.tableView2]
        for component in components {
            component?.backgroundColor = defaultColor
        }
        
        // Initial setup for search bars & table views
        self.searchBar1.delegate = self
        self.searchBar2.delegate = self
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        
        // Initially, display all states in each table view
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
    
    // # of rows in table view = number of states in filtered list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return stateListFiltered1.count
        } else {
            return stateListFiltered2.count
        }
    }
    
    // For a given cell, display the appropriate state name from the filtered list
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
    
    // Have each table view cell set to the default background color
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = defaultColor
    }
    
    // Each time a state is selected, (1) highlight the selected cell and
    // (2) update the `state{1, 2}Filename` variable & display the state on screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            // (1)
            let cell = self.tableView1.cellForRow(at: indexPath)
            cell?.contentView.backgroundColor = selectedColor
            
            // (2)
            stateTextView1.text = "State 1: \(cell?.textLabel?.text ?? "State 1")"
            stateFilename1 = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
        } else {
            // (1)
            let cell = self.tableView2.cellForRow(at: indexPath)
            cell?.contentView.backgroundColor = selectedColor
            
            // (2)
            stateTextView2.text = "State 2: \(cell?.textLabel?.text ?? "State 2")"
            stateFilename2 = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
        }
    }
    
    // If a cell is de-selected, have it return to the default background color
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            let cell = self.tableView1.cellForRow(at: indexPath)
            cell?.contentView.backgroundColor = defaultColor
        } else {
            let cell = self.tableView2.cellForRow(at: indexPath)
            cell?.contentView.backgroundColor = defaultColor
        }
    }
    
    // Error catching to make sure user has selected valid inputs
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "2State2JobInput2" {
            if stateFilename1 == nil || stateFilename2 == nil || stateFilename1 == stateFilename2 {
                Globals.singleton.displayErrorMessage(message: "You must select two distinct states.", vc: self)
                return false
            }
            return true
        }
        return false
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
