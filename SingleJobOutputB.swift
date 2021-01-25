//
//  SingleJobOutputB.swift
//  JobStop
//
//  Created by Christopher Song on 1/24/21.
//

import Foundation
import UIKit

// View displaying growth projection data about the selected job
class SingleJobOutputB: UIViewController {
    // Outlets connecting to different `TextView` elements
    @IBOutlet var stateTextView: UITextView!
    @IBOutlet var jobTextView: UITextView!
    @IBOutlet var currentJobsTextView: UITextView!
    @IBOutlet var projectedJobsTextView: UITextView!
    @IBOutlet var growthTextView: UITextView!
    
    // Variables to store state name & job projection data
    var stateName: String!
    var selectedJob: JobProjectionData!
    var currentJobsParsed: String!
    var projectedJobsParsed: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format the current & projected number of jobs nicely with commas
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        currentJobsParsed = numberFormatter.string(from: NSNumber(value: Int(selectedJob.currentJobs)))
        projectedJobsParsed = numberFormatter.string(from: NSNumber(value: Int(selectedJob.projectedJobs)))
        
        // Display relevant data in the storyboard view
        stateTextView.text = "State: \(stateName!)"
        jobTextView.text = "Income Data: \(selectedJob.title)"
        currentJobsTextView.text = "Current Jobs (2018): \(currentJobsParsed!)"
        projectedJobsTextView.text = "Projected Jobs (2028): \(projectedJobsParsed!)"
        growthTextView.text = "Growth Rate (2018 - 2028): \(selectedJob.percentChange)%"
    }
}
