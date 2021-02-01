//
//  2State2JobOutputB.swift
//  JobStop
//
//  Created by Christopher Song on 1/25/21.
//

import Foundation
import UIKit

// Displays growth projection data for two selected jobs in two different statess
class _2State2JobOutputB: UIViewController {
    // Outlets to `TextViews` displaying job growth projection data
    @IBOutlet var jobTextView1: UITextView!
    @IBOutlet var currentTextView1: UITextView!
    @IBOutlet var projectedTextView1: UITextView!
    @IBOutlet var growthTextView1: UITextView!
    @IBOutlet var jobTextView2: UITextView!
    @IBOutlet var currentTextView2: UITextView!
    @IBOutlet var projectedTextView2: UITextView!
    @IBOutlet var growthTextView2: UITextView!
    
    // Variables to hold state names & growth projections for selected jobs
    var stateName1: String!
    var stateName2: String!
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
        
        // Display relevant data in the storyboard view, adjusting the font size if necessary
        let jobText1 = "Growth Projection \(stateName1!): \(selectedJob1.title)"
        let jobFontSize1 = Globals.singleton.maxFontSize(s: jobText1, maxChars: 60, defaultSize: 32)
        jobTextView1.text = jobText1
        jobTextView1.font = jobTextView1.font?.withSize(CGFloat(jobFontSize1))
        
        currentTextView1.text = "Current Jobs (2018): \(currentJobs1!)"
        projectedTextView1.text = "Projected Jobs (2028): \(projectedJobs1!)"
        growthTextView1.text = "Growth Rate (2018 - 2028): \(selectedJob1.percentChange)%"
    
        let jobText2 = "Growth Projection \(stateName2!): \(selectedJob2.title)"
        let jobFontSize2 = Globals.singleton.maxFontSize(s: jobText2, maxChars: 60, defaultSize: 32)
        jobTextView2.text = jobText2
        jobTextView2.font = jobTextView2.font?.withSize(CGFloat(jobFontSize2))
        
        currentTextView2.text = "Current Jobs (2018): \(currentJobs2!)"
        projectedTextView2.text = "Projected Jobs (2028): \(projectedJobs2!)"
        growthTextView2.text = "Growth Rate (2018 - 2028): \(selectedJob2.percentChange)%"
    }
}
