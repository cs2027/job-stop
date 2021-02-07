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
    @IBOutlet var imageView: UIImageView!
    let defaultColor = Globals.singleton.defaultColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display image on initial landing screen
        imageView.image = UIImage(named: "main")
        
        // Set background color once initial landing page loads
        self.view.backgroundColor = defaultColor
        self.textView.backgroundColor = defaultColor
    }
}

