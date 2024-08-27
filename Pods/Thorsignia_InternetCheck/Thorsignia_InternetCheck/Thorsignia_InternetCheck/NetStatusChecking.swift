//
//  NetStatus.swift
//  NetStatusDemo
//
//  Created by Thorsignia.
//  Copyright © 2021 Thorsignia. All rights reserved.
//

import Foundation
import Network

public class NetStatus {
    
    // MARK: - Properties
    
    public static let shared = NetStatus()
    
    public static var monitor: NWPathMonitor?
    
    public static var isMonitoring = false
    
    public static var didStartMonitoringHandler: (() -> Void)?
    
    public static var didStopMonitoringHandler: (() -> Void)?
    
    public static var netStatusChangeHandler: (() -> Void)?
    
    
    public static var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    
    public static var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    
    public static var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    
    public static  var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    
    // MARK: - Init & Deinit
    
    private init() {
        
    }
    
    
    deinit {
        NetStatus.stopMonitoring()
    }
    
    
    // MARK: - Method Implementation
    
    public static func startMonitoring() {
        guard !NetStatus.isMonitoring else { return }
        
        NetStatus.monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        NetStatus.monitor?.start(queue: queue)
        
        NetStatus.monitor?.pathUpdateHandler = { _ in
            NetStatus.netStatusChangeHandler?()
        }
        
        NetStatus.isMonitoring = true
        NetStatus.didStartMonitoringHandler?()
    }
    
    
    public static func stopMonitoring() {
        guard isMonitoring, let monitor = NetStatus.monitor else { return }
        monitor.cancel()
        NetStatus.monitor = nil
        NetStatus.isMonitoring = false
        NetStatus.didStopMonitoringHandler?()
    }
    
}
