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
    // Outlets connecting to appropriate storyboard elements
    @IBOutlet var job1TextView: UITextView!
    @IBOutlet var annualIncome1TextView: UITextView!
    @IBOutlet var hourlyIncome1TextView: UITextView!
    @IBOutlet var job2TextView: UITextView!
    @IBOutlet var annualIncome2TextView: UITextView!
    @IBOutlet var hourlyIncome2TextView: UITextView!
    @IBOutlet var costOfLivingButton: UIButton!
    
    // Variables to hold state names & income data info
    var state1Name: String!
    var state2Name: String!
    var state1CostOfLiving: Double!
    var state2CostOfLiving: Double!
    var selectedJob1: JobIncomeData!
    var selectedJob2: JobIncomeData!
    var annualIncome1Parsed: String!
    var annualIncome2Parsed: String!
    var adjustedAnnual1Parsed: String!
    var adjustedAnnual2Parsed: String!
    var adjustedHourly1Parsed: String!
    var adjustedHourly2Parsed: String!
    var adjustedForCOL = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format annual incomes nicely with commas, correct # of decimals
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        annualIncome1Parsed = numberFormatter.string(from: NSNumber(value: selectedJob1.annualSalary))
        annualIncome2Parsed = numberFormatter.string(from: NSNumber(value: selectedJob2.annualSalary))
        adjustedAnnual1Parsed = numberFormatter.string(from: NSNumber(value: Int(Double(selectedJob1.annualSalary) / state1CostOfLiving)))
        adjustedAnnual2Parsed = numberFormatter.string(from: NSNumber(value: Int(Double(selectedJob2.annualSalary) / state2CostOfLiving)))
        adjustedHourly1Parsed = numberFormatter.string(from: NSNumber(value: Double(selectedJob1.hourlySalary) / state1CostOfLiving))
        adjustedHourly2Parsed = numberFormatter.string(from: NSNumber(value: Double(selectedJob2.hourlySalary) / state2CostOfLiving))
        
        // Display the appropriate data in our view
        job1TextView.text = "Income Data (\(state1Name!)): \(selectedJob1.title)"
        job2TextView.text = "Income Data (\(state2Name!)): \(selectedJob2.title)"
        viewRawIncomes()
    }
    
    // Toggle between adjusted and raw income data
    @IBAction func adjustIncomeData() {
        if adjustedForCOL {
            viewRawIncomes()
        } else {
            viewAdjustedIncomes()
        }
    }
    
    // Display income data, adjusted for cost of living
    func viewAdjustedIncomes() {
        annualIncome1TextView.text = "Annual Salary: $\(adjustedAnnual1Parsed!)/yr"
        hourlyIncome1TextView.text = "Hourly Salary: $\(adjustedHourly1Parsed!)/hr"
        
        annualIncome2TextView.text = "Annual Salary: $\(adjustedAnnual2Parsed!)/yr"
        hourlyIncome2TextView.text = "Hourly Salary: $\(adjustedHourly2Parsed!)/hr"
        
        costOfLivingButton.setTitle("View Original Income Data", for: .normal)
        adjustedForCOL = true
    }
    
    // Display original, raw income data
    func viewRawIncomes() {
        annualIncome1TextView.text = "Annual Salary: $\(annualIncome1Parsed!)/yr"
        hourlyIncome1TextView.text = String(format: "Hourly Salary: $%.2f/hr", selectedJob1.hourlySalary)
        
        annualIncome2TextView.text = "Annual Salary: $\(annualIncome2Parsed!)/yr"
        hourlyIncome2TextView.text = String(format: "Hourly Salary: $%.2f/hr", selectedJob2.hourlySalary)
        
        costOfLivingButton.setTitle("Adjust for Cost of Living?", for: .normal)
        adjustedForCOL = false
    }
}
