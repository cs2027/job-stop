//
//  1State2JobOutputB.swift
//  JobStop
//
//  Created by Christopher Song on 1/24/21.
//

import Foundation
import UIKit

// View comparing growth projection data for two jobs
class _1State2JobOutputB: UIViewController {
    // Outlets connecting to various `TextView` objects
    @IBOutlet var stateTextView: UITextView!
    @IBOutlet var job1TextView: UITextView!
    @IBOutlet var current1TextView: UITextView!
    @IBOutlet var projected1TextView: UITextView!
    @IBOutlet var growth1TextView: UITextView!
    @IBOutlet var job2TextView: UITextView!
    @IBOutlet var current2TextView: UITextView!
    @IBOutlet var projected2TextView: UITextView!
    @IBOutlet var growth2TextView: UITextView!
    
    // Variables to store state name & job income data
    var stateName: String!
    var selectedJob1: JobProjectionData!
    var selectedJob2: JobProjectionData!
    var currentJobs1: String!
    var projectedJobs1: String!
    var currentJobs2: String!
    var projectedJobs2: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format the current & projected number of jobs nicely with commas
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        currentJobs1 = numberFormatter.string(from: NSNumber(value: Int(selectedJob1.currentJobs)))
        projectedJobs1 = numberFormatter.string(from: NSNumber(value: Int(selectedJob1.projectedJobs)))
        currentJobs2 = numberFormatter.string(from: NSNumber(value: Int(selectedJob2.currentJobs)))
        projectedJobs2 = numberFormatter.string(from: NSNumber(value: Int(selectedJob2.projectedJobs)))
        
        // Display relevant data in the storyboard view
        stateTextView.text = "State: \(stateName!)"
        job1TextView.text = "Income Data: \(selectedJob1.title)"
        current1TextView.text = "Current Jobs (2018): \(currentJobs1!)"
        projected1TextView.text = "Projected Jobs (2028): \(projectedJobs1!)"
        growth1TextView.text = "Growth Rate (2018 - 2028): \(selectedJob1.percentChange)%"
        job2TextView.text = "Income Data: \(selectedJob2.title)"
        current2TextView.text = "Current Jobs (2018): \(currentJobs2!)"
        projected2TextView.text = "Projected Jobs (2028): \(projectedJobs2!)"
        growth2TextView.text = "Growth Rate (2018 - 2028): \(selectedJob2.percentChange)%"
        
    }
}
