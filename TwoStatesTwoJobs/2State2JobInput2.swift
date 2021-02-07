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
    // Variables to hold: (1) state filename, (2) background color,
    // (3) various storyboard outlets
    var stateFilename1: String! // (1)
    var stateFilename2: String!
    let defaultColor = Globals.singleton.defaultColor // (2)
    @IBOutlet var textView: UITextView! // (3)
    @IBOutlet var incomeImageView: UIImageView!
    @IBOutlet var growthImageView: UIImageView!
    
    // Once the view loads, (1) display some pre-loaded images &
    // (2) set its background color
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeImageView.image = UIImage(named: "income") // (1)
        growthImageView.image = UIImage(named: "growth")
        self.view.backgroundColor = defaultColor // (2)
        self.textView.backgroundColor = defaultColor
    }
    
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
