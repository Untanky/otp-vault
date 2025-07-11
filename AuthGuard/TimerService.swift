//
//  TimerService.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import Foundation

typealias TimerCallback = () -> Void

class TimerGroup {
    private var timer: Timer?
    private var callbacks: [UUID:TimerCallback] = [:]
    
    init(interval: TimeInterval) {
        let timeInTimeStep = floor(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: interval))
        let intervalToNextTimeStep = 30 - timeInTimeStep
        
        self.timer = Timer.scheduledTimer(withTimeInterval: intervalToNextTimeStep, repeats: false) { _ in
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.invokeCallbacks()
            }
            Task {
                self.invokeCallbacks()
            }
        }
    }
    
    func register(_ callback: @escaping TimerCallback) -> UUID {
        let uuid = UUID()
        self.callbacks[uuid] = callback
        return uuid
    }
    
    func unregister(_ id: UUID) {
        self.callbacks.removeValue(forKey: id)
    }
    
    private func invokeCallbacks() {
        for callback in self.callbacks.values {
            callback()
        }
    }
}

struct TimerId {
    let interval: TimeInterval
    let callbackId: UUID
}

class TimerService {
    private var callbackMap: [TimeInterval:TimerGroup]
    
    public static let shared = TimerService()
    
    fileprivate init() {
        self.callbackMap = [:]
    }
    
    func register(forInterval interval: TimeInterval, callback: @escaping TimerCallback) -> TimerId {
        let timerGroup = self.callbackMap[interval] ?? TimerGroup(interval: interval)
        
        let callbackId = timerGroup.register(callback)
        return TimerId(interval: interval, callbackId: callbackId)
    }
    
    func unregister(id: TimerId) {
        guard let timerGroup = self.callbackMap[id.interval] else {
            return
        }
        
        timerGroup.unregister(id.callbackId)
    }
}
