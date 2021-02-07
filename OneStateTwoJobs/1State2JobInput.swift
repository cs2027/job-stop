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
    // Outlets connecting to various storyboard UI elements
    @IBOutlet var stateTextView: UITextView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // Background color & highlighted color for selected cells
    let defaultColor = Globals.singleton.defaultColor
    let selectedColor = Globals.singleton.selectedColor
    
    // Variables to store: (1) state filename, (2) list of all states,
    // and (3) list of filtered states (by search bar query)
    var stateFilename: String! = nil // (1)
    let stateList = Globals.singleton.stateList // (2)
    var stateListFiltered: [String] = [] // (3)
    
    // Called once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateTextView.text = "State"
        
        // Set background color for entire view & constituent components
        self.view.backgroundColor = defaultColor
        self.searchBar.searchBarStyle = UISearchBar.Style.minimal
        
        let components = [self.stateTextView, self.tableView]
        for component in components {
            component?.backgroundColor = defaultColor
        }
        
        // Initial setup for search bar & table view
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Initially, display all states in the table view
        self.stateListFiltered = self.stateList
    }
    
    // Implement search bar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        stateListFiltered = Globals.singleton.searchStates(stateList: stateList, searchText: searchText)
        self.tableView.reloadData()
    }
    
    // # of rows in table view = number of states in filtered list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateListFiltered.count
    }
    
    // For a given cell, display the appropriate state name from the filtered list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath)
        cell.textLabel?.text = stateListFiltered[indexPath.row]
        return cell
    }
    
    // Have each table view cell set to the default background color
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = defaultColor
    }
    
    // When a new state is selected, (1) highlight the selected cell and
    // (2) update the `stateFilename` variable & display the selected state on screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = selectedColor
        stateTextView.text = "State: \(cell?.textLabel?.text ?? "State")"
        stateFilename = cell?.textLabel?.text?.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    
    // If a cell is de-selected, have it return to the default background color
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = defaultColor
    }
    
    // Error catching to make sure user has selected valid inputs
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "1State2JobInput2" {
            if stateFilename == nil {
                Globals.singleton.displayErrorMessage(message: "You must select a state.", vc: self)
                return false
            }
            return true
        }
        return false
    }
    
    // Pass the selected state filename via the segue to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "1State2JobInput2",
           let destination = segue.destination as? _1State2JobInput2 {
            destination.stateFilename = stateFilename
        }
    }
}
