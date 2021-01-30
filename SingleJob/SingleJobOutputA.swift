//
//  SingleJobOutputA.swift
//  JobStop
//
//  Created by Christopher Song on 1/24/21.
//

import Foundation
import UIKit

// View displaying income data about the selected job
class SingleJobOutputA: UIViewController {
    // Outlets connecting to different `TextView` elements
    @IBOutlet var stateTextView: UITextView!
    @IBOutlet var jobTextView: UITextView!
    @IBOutlet var annualIncomeTextView: UITextView!
    @IBOutlet var hourlyIncomeTextView: UITextView!
    @IBOutlet var newSearchButton: UIButton!
    
    // Variables to store state name & job income data
    var stateName: String!
    var selectedJob: JobIncomeData!
    var annualIncomeParsed: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format the annual income nicely with commas
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        annualIncomeParsed = numberFormatter.string(from: NSNumber(value: selectedJob.annualSalary))
        
        // Display relevant data in the storyboard view
        stateTextView.text = "State: \(stateName!)"
        jobTextView.text = "Income Data: \(selectedJob.title)"
        annualIncomeTextView.text = "Annual Salary: $\(annualIncomeParsed!)/yr"
        hourlyIncomeTextView.text = "Hourly Salary: $\(selectedJob.hourlySalary)/hr"
    }
}
