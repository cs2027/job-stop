//
//  1State2JobOutputA.swift
//  JobStop
//
//  Created by Christopher Song on 1/24/21.
//

import Foundation
import UIKit

// View comparing income data about the two selected jobs
class _1State2JobOutputA: UIViewController {
    // Outlets connecting to the various `TextView` objects
    @IBOutlet var stateTextView: UITextView!
    @IBOutlet var job1TextView: UITextView!
    @IBOutlet var annualSalary1TextView: UITextView!
    @IBOutlet var hourlySalary1TextView: UITextView!
    @IBOutlet var job2TextView: UITextView!
    @IBOutlet var annualSalary2TextView: UITextView!
    @IBOutlet var hourlySalary2TextView: UITextView!
    
    // Variables to store state name & job income data
    var stateName: String!
    var selectedJob1: JobIncomeData!
    var selectedJob2: JobIncomeData!
    var annualIncome1Parsed: String!
    var annualIncome2Parsed: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format annual incomes nicely with commas
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        annualIncome1Parsed = numberFormatter.string(from: NSNumber(value: selectedJob1.annualSalary))
        annualIncome2Parsed = numberFormatter.string(from: NSNumber(value: selectedJob2.annualSalary))
        
        // Display the appropriate data in our view
        stateTextView.text = "State: \(stateName!)"
        job1TextView.text = "Income Data (Job 1): \(selectedJob1.title)"
        annualSalary1TextView.text = "Annual Salary: $\(annualIncome1Parsed!)"
        hourlySalary1TextView.text = "Hourly Salary: $\(selectedJob1.hourlySalary)"
        job2TextView.text = "Income Data (Job 2): \(selectedJob2.title)"
        annualSalary2TextView.text = "Annual Salary: $\(annualIncome2Parsed!)"
        hourlySalary2TextView.text = "Hourly Salary: $\(selectedJob2.hourlySalary)"
    }
}
