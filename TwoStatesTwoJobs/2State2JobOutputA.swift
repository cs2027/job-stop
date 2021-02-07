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
    @IBOutlet var jobTextView1: UITextView!
    @IBOutlet var jobTextView2: UITextView!
    @IBOutlet var annualIncomeTextView1: UITextView!
    @IBOutlet var annualIncomeTextView2: UITextView!
    @IBOutlet var hourlyIncomeTextView1: UITextView!
    @IBOutlet var hourlyIncomeTextView2: UITextView!
    @IBOutlet var costOfLivingButton: UIButton!
    
    // Background color & highlighted color for selected cells
    let defaultColor = Globals.singleton.defaultColor
    let selectedColor = Globals.singleton.selectedColor
    
    // Variables to hold state names & income data info
    var stateName1: String!
    var stateName2: String!
    var stateCostOfLiving1: Double!
    var stateCostOfLiving2: Double!
    var selectedJob1: JobIncomeData!
    var selectedJob2: JobIncomeData!
    var annualIncomeParsed1: String!
    var annualIncomeParsed2: String!
    var adjustedAnnualParsed1: String!
    var adjustedAnnualParsed2: String!
    var adjustedHourlyParsed1: String!
    var adjustedHourlyParsed2: String!
    var adjustedForCOL = false
    
    // Called once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color for entire view & constituent components
        self.view.backgroundColor = defaultColor
        
        let components = [self.jobTextView1, self.jobTextView2, self.annualIncomeTextView1, self.annualIncomeTextView2, self.hourlyIncomeTextView1, self.hourlyIncomeTextView2]
        for component in components {
            component?.backgroundColor = defaultColor
        }
        
        // Format annual incomes nicely with commas, correct # of decimals
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        annualIncomeParsed1 = numberFormatter.string(from: NSNumber(value: selectedJob1.annualSalary))
        annualIncomeParsed2 = numberFormatter.string(from: NSNumber(value: selectedJob2.annualSalary))
        adjustedAnnualParsed1 = numberFormatter.string(from: NSNumber(value: Int(Double(selectedJob1.annualSalary) / stateCostOfLiving1)))
        adjustedAnnualParsed2 = numberFormatter.string(from: NSNumber(value: Int(Double(selectedJob2.annualSalary) / stateCostOfLiving2)))
        adjustedHourlyParsed1 = numberFormatter.string(from: NSNumber(value: Double(selectedJob1.hourlySalary) / stateCostOfLiving1))
        adjustedHourlyParsed2 = numberFormatter.string(from: NSNumber(value: Double(selectedJob2.hourlySalary) / stateCostOfLiving2))
        
        // Display the appropriate data in our view, adjusting the font size as needed
        let jobText1 = "Income Data \(stateName1!): \(selectedJob1.title)"
        let jobFontSize1 = Globals.singleton.maxFontSize(s: jobText1, maxChars: 70, defaultSize: 32)
        jobTextView1.text = jobText1
        jobTextView1.font = jobTextView1.font?.withSize(CGFloat(jobFontSize1))
        
        let jobText2 = "Income Data \(stateName2!): \(selectedJob2.title)"
        let jobFontSize2 = Globals.singleton.maxFontSize(s: jobText2, maxChars: 70, defaultSize: 32)
        jobTextView2.text = jobText2
        jobTextView2.font = jobTextView2.font?.withSize(CGFloat(jobFontSize2))
        
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
        annualIncomeTextView1.text = "Annual Salary: $\(adjustedAnnualParsed1!)/yr"
        hourlyIncomeTextView1.text = "Hourly Salary: $\(adjustedHourlyParsed1!)/hr"
        
        annualIncomeTextView2.text = "Annual Salary: $\(adjustedAnnualParsed2!)/yr"
        hourlyIncomeTextView2.text = "Hourly Salary: $\(adjustedHourlyParsed2!)/hr"
        
        costOfLivingButton.setTitle("View Original Income Data", for: .normal)
        adjustedForCOL = true
    }
    
    // Display original, raw income data
    func viewRawIncomes() {
        annualIncomeTextView1.text = "Annual Salary: $\(annualIncomeParsed1!)/yr"
        hourlyIncomeTextView1.text = String(format: "Hourly Salary: $%.2f/hr", selectedJob1.hourlySalary)
        
        annualIncomeTextView2.text = "Annual Salary: $\(annualIncomeParsed2!)/yr"
        hourlyIncomeTextView2.text = String(format: "Hourly Salary: $%.2f/hr", selectedJob2.hourlySalary)
        
        costOfLivingButton.setTitle("Adjust for Cost of Living?", for: .normal)
        adjustedForCOL = false
    }
}
