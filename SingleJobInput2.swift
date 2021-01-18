//
//  SingleJobInput2.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit

class SingleJobInput2: UIViewController {
    // Variable to hold filename of selected state
    var stateFilename: String!
    
    // Pass the selected state filename via the segue to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SingleJobInput3a",
           let destination = segue.destination as? SingleJobInput3a {
            destination.stateFilename = stateFilename
        }
        
        if segue.identifier == "SingleJobInput3b",
           let destination = segue.destination as? SingleJobInput3b {
            destination.stateFilename = stateFilename
        }
    }
}
