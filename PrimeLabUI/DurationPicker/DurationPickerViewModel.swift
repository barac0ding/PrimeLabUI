//
//  DurationPickerViewModel.swift
//  Simple Meditation Timer
//
//  Created by Sato on 04.02.2026.
//


import SwiftUI

enum DurationPickerFormat {
    case short, long, full
}


@Observable
class DurationPickerViewModel {
    
    // MARK: - Configuration
    
    let format: DurationPickerFormat
    private let minimumDuration: Int
    
    // MARK: - Picker selections
    
    var selectedHour = 0 {
        didSet {
            updateMinuteConstraint()
            updateSecondConstraint()
        }
    }
    var selectedMinute = 0 {
        didSet {
            updateSecondConstraint()
            
            if format == .long {
                if selectedMinute < minimumMinute {
                    selectedMinute = minimumMinute
                }
            }
        }
    }
    var selectedSecond = 0 {
        didSet {
            switch format {
            case .short, .full:
                if selectedSecond < minimumSecond {
                    selectedSecond = minimumSecond
                }
            case .long:
                if selectedSecond != 0 {
                    selectedSecond = 0
                }
            }
        }
    }
    
    // MARK: - Picker constraints
    
    var minimumMinute = 0
    var minimumSecond = 0
    
    // MARK: - Init
    
    init(
        initialDuration: TimeInterval,
        format: DurationPickerFormat,
        minimumDuration: Int
    ) {
        let value = Int(initialDuration)
        
        selectedHour = value / 3600
        selectedMinute = (value % 3600) / 60
        selectedSecond = value % 60
        
        self.format = format
        self.minimumDuration = minimumDuration
        
        applyMinimumConstraints()
        setupLongFormat()
    }
}

extension DurationPickerViewModel {
    
    func setupLongFormat() {
        guard format == .long else {return }
        
            if duration < 60 {
                selectedMinute = minimumMinute
                selectedSecond = 0
            }
    }
    
    private func updateMinuteConstraint() {
        guard format == .long else { return }
        
        minimumMinute = selectedHour == 0 ? minimumDuration : 0
        
        if selectedMinute <= minimumMinute {
            selectedMinute = minimumMinute
        }
    }
    
    private func updateSecondConstraint() {
        guard format != .long else { return }
        
        minimumSecond = (selectedHour == 0 && selectedMinute == 0) ? minimumDuration : 0
        
        if selectedSecond <= minimumSecond {
            selectedSecond = minimumSecond
        }
    }
}


extension DurationPickerViewModel {
    // MARK: - Picker ranges
    
    var hourRange: [Int] {
        Array(0...23)
    }
    
    var minuteRange: [Int] {
        Array(minimumMinute...59)
    }
    
    var secondRange: [Int] {
        Array(minimumSecond...59)
    }
    
    // MARK: - Result duration
    
    var duration: TimeInterval {
        TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
    }
    
    // MARK: - Constraints logic
    
    private func applyMinimumConstraints() {
        switch format {
        case .long:
            minimumMinute = minimumDuration
            minimumSecond = 0
            
            if duration < TimeInterval(minimumMinute) {
                selectedMinute = minimumMinute
                selectedSecond = 0
            }
            
        case .short, .full:
            minimumMinute = 0
            minimumSecond = minimumDuration
            
            if duration < TimeInterval(minimumSecond) {
                selectedSecond = minimumSecond
            }
        }
    }
}
