//
//  2State2JobOutputA.swift
//  JobStop
//
//  Created by Christopher Song on 1/25/21.
//

import Foundation
import UIKit

// Displays income data about two selected jobs in two different states
class _2State2JobOutputA: UIViewController {
    // Outlets connecting to `TextViews` displaying income data
    @IBOutlet var job1TextView: UITextView!
    @IBOutlet var annualSalary1TextView: UITextView!
    @IBOutlet var hourlySalary1TextView: UITextView!
    @IBOutlet var job2TextView: UITextView!
    @IBOutlet var annualSalary2TextView: UITextView!
    @IBOutlet var hourlySalary2TextView: UITextView!
    
    // Variables to hold state names & income data info
    var state1Name: String!
    var state2Name: String!
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
        job1TextView.text = "Income Data (\(state1Name!)): \(selectedJob1.title)"
        annualSalary1TextView.text = "Annual Salary: $\(annualIncome1Parsed!)"
        hourlySalary1TextView.text = "Hourly Salary: $\(selectedJob1.hourlySalary)"
        job2TextView.text = "Income Data (\(state2Name!)): \(selectedJob2.title)"
        annualSalary2TextView.text = "Annual Salary: $\(annualIncome2Parsed!)"
        hourlySalary2TextView.text = "Hourly Salary: $\(selectedJob2.hourlySalary)"
    }
}
