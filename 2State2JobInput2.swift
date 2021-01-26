//
//  2State2JobInput2.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit

// View where users selects whether to compare income data or job growth projections
class _2State2JobInput2: UIViewController {
    // Filenames of states selected by the user
    var state1Filename: String!
    var state2Filename: String!
    
    // Pass data regarding these^^ state filenames to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "2State2JobInput3a",
           let destination = segue.destination as? _2State2JobInput3a {
            destination.state1Filename = state1Filename
            destination.state2Filename = state2Filename
        }
        
        if segue.identifier == "2State2JobInput3b",
           let destination = segue.destination as? _2State2JobInput3b {
            destination.state1Filename = state1Filename
            destination.state2Filename = state2Filename
        }
    }
}
