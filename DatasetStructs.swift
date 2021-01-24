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
}

// Represents growth projection data for a given job
struct JobProjectionData {
    var title: String
    var currentJobs: Double
    var projectedJobs: Double
    var netChange: Double
    var percentChange: Double
}
