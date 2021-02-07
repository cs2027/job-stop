//
//  ViewController.swift
//  JobStop
//
//  Created by Christopher Song on 1/16/21.
//

import UIKit

// Initial view when app loads
class ViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    let defaultColor = Globals.singleton.defaultColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color once initial landing page loads
        self.view.backgroundColor = defaultColor
        self.textView.backgroundColor = defaultColor
    }
}

