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
    
    // Background color & highlighted color for selected cells
    let defaultColor = Globals.singleton.defaultColor
    let selectedColor = Globals.singleton.selectedColor
    
    // Variables to store state name & job projection data
    var stateName: String!
    var selectedJob: JobProjectionData!
    var currentJobsParsed: String!
    var projectedJobsParsed: String!
    
    // Called once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color for entire view & constituent components
        self.view.backgroundColor = defaultColor
       
        let components = [self.stateTextView, self.jobTextView, self.currentJobsTextView, self.projectedJobsTextView, self.growthTextView]
        for component in components {
            component?.backgroundColor = defaultColor
        }
        
        // Format the current & projected number of jobs nicely with commas
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        currentJobsParsed = numberFormatter.string(from: NSNumber(value: Int(selectedJob.currentJobs)))
        projectedJobsParsed = numberFormatter.string(from: NSNumber(value: Int(selectedJob.projectedJobs)))
        
        // Display relevant data in the storyboard view, adjusting font sizes if needed
        stateTextView.text = "State: \(stateName!)"
        let jobText = "Growth Projection: \(selectedJob.title)"
        let jobFontSize = Globals.singleton.maxFontSize(s: jobText, maxChars: 80, defaultSize: 32)
        jobTextView.text = jobText
        jobTextView.font = jobTextView.font?.withSize(CGFloat(jobFontSize))
        currentJobsTextView.text = "Current Jobs (2018): \(currentJobsParsed!)"
        projectedJobsTextView.text = "Projected Jobs (2028): \(projectedJobsParsed!)"
        growthTextView.text = "Growth Rate (2018 - 2028): \(selectedJob.percentChange)%"
    }
}
