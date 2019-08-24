
//
//  OSLogger.swift
//  spay
//
//  Created by Pasini, Nicolò on 18/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import os.log
import Foundation

class OSLogger {
    private static var categorizedLogObjects: [LogCategory: OSLog] = [:]
    
    private static func getCurrentThread() -> String {
        if Thread.isMainThread {
            return "main"
        } else {
            if let threadName = Thread.current.name, !threadName.isEmpty {
                return"\(threadName)"
            } else if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), !queueName.isEmpty {
                return"\(queueName)"
            } else {
                return String(format: "%p", Thread.current)
            }
        }
    }
    
    private static func createOSLog(category: LogCategory) -> OSLog {
        if let categoryLog = categorizedLogObjects[category] {
            return categoryLog
        } else {
            let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "spay", category: category.rawValue)
            categorizedLogObjects[category] = log
            return log
        }
    }
    
    private static func getOSLogType(type: LogType) -> OSLogType {
        switch type {
        case .info:
            return OSLogType.info
        case .fault:
            return OSLogType.fault
        case .error:
            return OSLogType.error
        case .debug:
            return OSLogType.debug
        case .default:
            return OSLogType.default
        }
    }
    
    private static func log(category: LogCategory, message: String, access: LogAccessLevel = LogAccessLevel.private, type: LogType = .debug, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        
        let file = (fileName as NSString).lastPathComponent
        let line = String(lineNumber)
        
        let osType = getOSLogType(type: type)
        
        switch access {
        case .public:
            os_log("[thread: %{public}@] [%{public}@:%{public}@ %{public}@] > %{public}@", log: createOSLog(category: category), type: osType, getCurrentThread(), file, line, functionName, message)
        case .private:
            os_log("[thread: %{private}@] [%{private}@:%{private}@ %{private}@] > %{private}@", log: createOSLog(category: category), type: osType, getCurrentThread(), file, line, functionName, message)
        }
    }
}

extension OSLogger {
    static func uiLog(message: String, access: LogAccessLevel = LogAccessLevel.private, type: LogType = .debug.self, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        log(category: .ui, message: message, access: access, type: type, fileName: fileName, functionName: functionName, lineNumber: lineNumber)
    }
    
    static func networkLog(message: String, access: LogAccessLevel = LogAccessLevel.private, type: LogType = .debug.self, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        log(category: .network, message: message, access: access, type: type, fileName: fileName, functionName: functionName, lineNumber: lineNumber)
    }
    
    static func dependencyInjectionLog(message: String, access: LogAccessLevel = LogAccessLevel.private, type: LogType = .debug.self, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        log(category: .dependencyInjection, message: message, access: access, type: type, fileName: fileName, functionName: functionName, lineNumber: lineNumber)
    }
}
