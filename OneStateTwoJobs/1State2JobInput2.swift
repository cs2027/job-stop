//
//  1State2JobInput2.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation
import UIKit

// View where users chooses to view income data or job growth projections
class _1State2JobInput2: UIViewController {
    // Variables to hold: (1) state filename, (2) textView label,
    // (3) background color
    var stateFilename: String! // (1)
    @IBOutlet var textView: UITextView! // (2)
    let defaultColor = Globals.singleton.defaultColor // (3)
    
    // Once the view loads, set its backround color
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = defaultColor
        self.textView.backgroundColor = defaultColor
    }
    
    // Pass the selected state filename via the segue to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "1State2JobInput3a",
           let destination = segue.destination as? _1State2JobInput3a {
            destination.stateFilename = stateFilename
        }
        
        if segue.identifier == "1State2JobInput3b",
           let destination = segue.destination as? _1State2JobInput3b {
            destination.stateFilename = stateFilename
        }
    }
}
