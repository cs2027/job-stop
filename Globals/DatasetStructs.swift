//
//  DatasetStructs.swift
//  JobStop
//
//  Created by Christopher Song on 1/17/21.
//

import Foundation

// Represents income data associated with a given job
struct JobIncomeData {
    var title: String
    var hourlySalary: Double
    var annualSalary: Int
    
    // Compare if two jobs are equal, field-by-field
    func equals(other: JobIncomeData) -> Bool {
        return self.title == other.title &&
                self.hourlySalary == other.hourlySalary &&
                self.annualSalary == other.annualSalary
    }
}

// Represents growth projection data for a given job
struct JobProjectionData {
    var title: String
    var currentJobs: Double
    var projectedJobs: Double
    var netChange: Double
    var percentChange: Double
    
    // Compare if two jobs are equal, field-by-field
    func equals(other: JobProjectionData) -> Bool {
        return self.title == other.title &&
                self.currentJobs == other.currentJobs &&
                self.projectedJobs == other.projectedJobs &&
                self.netChange == other.netChange &&
                self.percentChange == other.percentChange
    }
}
