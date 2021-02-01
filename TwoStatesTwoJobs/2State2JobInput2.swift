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
    var stateFilename1: String!
    var stateFilename2: String!
    
    // Pass data regarding these^^ state filenames to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "2State2JobInput3a",
           let destination = segue.destination as? _2State2JobInput3a {
            destination.stateFilename1 = stateFilename1
            destination.stateFilename2 = stateFilename2
        }
        
        if segue.identifier == "2State2JobInput3b",
           let destination = segue.destination as? _2State2JobInput3b {
            destination.stateFilename1 = stateFilename1
            destination.stateFilename2 = stateFilename2
        }
    }
}
