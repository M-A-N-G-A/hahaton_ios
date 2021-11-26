//
//  Log.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import Foundation
import CocoaLumberjack

struct LogPrefix {
    static let debug = "[DEBUG]: "
    static let function = "[FUNCTION]: "
    static let warning = "[WARNING]: "
    static let error = "[ERROR]: "
}

class Log {
    class func initializeLogging() {
        DDLog.add(DDOSLogger.sharedInstance)
        Log.thisFunction()
    }
    
    static var showTime: Bool = true
    static var showLine: Bool = true
    static var timeFormat: String = "[HH:mm:ss]"
    static let separatorLength: Int = 10
    
    class func debug(_ object:Any?, line: Int = #line) {
        let value = object != nil ? object : "nil"
        DDLogDebug("\(LogPrefix.debug) \(functionPrefix(line: line)) \(value!)\n")
    }
    
    class func thisFunction(file: String = #file, functionName: String = #function, line: Int = #line) {
        let functionName = Log.functionName(file: file, functionName: functionName, line: line)
        DDLogDebug("\(LogPrefix.function) \(prefixTime()) \(functionName)\n")
    }
    
    class func warning(_ object:Any?, line: Int = #line) {
        let value = object != nil ? object : "nil"
        DDLogWarn("\(LogPrefix.warning) \(functionPrefix(line: line)) \(value!)\n")
    }
    
    class func error(_ object:Any?, file: String = #file, functionName: String = #function, line: Int = #line) {
        let value = object != nil ? object : "nil"
        let functionName = Log.functionName(file: file, functionName: functionName, line: line)
        DDLogError("\(LogPrefix.error) \(functionName) \(prefixTime()): \(value!)\n")
    }
    
    class func separator(file: String = #file, functionName: String = #function, line: Int = #line) {
        let functionName = Log.functionName(file: file, functionName: functionName, line: line)
        DDLogDebug("\(prefixTime()) \(functionName) \(makeSeparatorString())")
    }
}

private extension Log {
    class func functionPrefix(line: Int) -> String {
        "\(showLine ? "[\(line)]" : "") \(prefixTime())"
    }
    
    class func prefixTime() -> String {
        "\(showTime ? functionTime() : "")"
    }
    
    class func functionName(file: String, functionName: String, line: Int) -> String {
        let fileName = file.components(separatedBy: "/").last!.components(separatedBy: ".").first!
        return "\(fileName).\(functionName)[\(line)]"
    }
    
    class func functionTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: Date())
    }
    
    class func makeSeparatorString() -> String {
        String(repeating: "-", count: separatorLength)
    }
}
