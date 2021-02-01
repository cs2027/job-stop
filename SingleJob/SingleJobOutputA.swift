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
    // Outlets connecting to appropriate storyboard elements
    @IBOutlet var stateTextView: UITextView!
    @IBOutlet var jobTextView: UITextView!
    @IBOutlet var annualIncomeTextView: UITextView!
    @IBOutlet var hourlyIncomeTextView: UITextView!
    @IBOutlet var newSearchButton: UIButton!
    @IBOutlet var costOfLivingButton: UIButton!
    
    // Variables to store state name & job income data
    var stateName: String!
    var stateCostOfLiving: Double!
    var selectedJob: JobIncomeData!
    var annualIncomeParsed: String!
    var adjustedAnnualParsed: String!
    var adjustedHourlyParsed: String!
    var adjustedForCOL = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format annual incomes nicely with commas, correct # of decimals
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        annualIncomeParsed = numberFormatter.string(from: NSNumber(value: selectedJob.annualSalary))
        adjustedAnnualParsed = numberFormatter.string(from: NSNumber(value: Int(Double(selectedJob.annualSalary) / stateCostOfLiving)))
        adjustedHourlyParsed = numberFormatter.string(from: NSNumber(value: Double(selectedJob.hourlySalary) / stateCostOfLiving))
        
        // Display relevant data in the storyboard view, adjusting font sizes where necessary
        stateTextView.text = "State: \(stateName!)"
        let jobText = "Income Data: \(selectedJob.title)"
        let jobFontSize = Globals.singleton.maxFontSize(s: jobText, maxChars: 80, defaultSize: 32)
        jobTextView.text = jobText
        jobTextView.font = jobTextView.font?.withSize(CGFloat(jobFontSize))
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
        annualIncomeTextView.text = "Annual Salary: $\(adjustedAnnualParsed!)/yr"
        hourlyIncomeTextView.text = "Hourly Salary: $\(adjustedHourlyParsed!)/hr"
        
        costOfLivingButton.setTitle("View Original Income Data", for: .normal)
        adjustedForCOL = true
        
    }
    
    // Display original, raw income data
    func viewRawIncomes() {
        annualIncomeTextView.text = "Annual Salary: $\(annualIncomeParsed!)/yr"
        hourlyIncomeTextView.text = String(format: "Hourly Salary: $%.2f/hr", selectedJob.hourlySalary)
        
        costOfLivingButton.setTitle("Adjust for Cost of Living?", for: .normal)
        adjustedForCOL = false
    }
}
