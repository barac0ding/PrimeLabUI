//
//  DurationPickerView.swift
//  Simple Meditation Timer
//
//  Created by Sato on 11.12.2025.
//

import SwiftUI



struct DurationPicker: View {
    @Binding var duration: TimeInterval
    @State private var vm: DurationPickerViewModel
    
    @State private var unitsStyle: MeasurementFormatter.UnitStyle
    
    init(
        duration: Binding<TimeInterval>,
        format: DurationPickerFormat = .short,
        unitsStyle: MeasurementFormatter.UnitStyle = .medium,
        minimumDuration: Int = 1
    ) {
        vm = DurationPickerViewModel(initialDuration: duration.wrappedValue, format: format, minimumDuration: minimumDuration)
        self._duration = duration
        self.unitsStyle = unitsStyle
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
            
            HStack {
                if vm.format == .long || vm.format == .full {
                    
                    VStack {
                        Picker("", selection: $vm.selectedHour) {
                            ForEach(vm.hourRange, id: \.self) { hour in
                                Text(toDoubleDigit(hour)).tag(hour)
                            }
                        }
                        
                        localizedUnit(.hours, style: unitsStyle)
                    }
                }
                
                VStack {
                    HStack {
                        Picker("", selection: $vm.selectedMinute) {
                            ForEach(vm.minuteRange, id: \.self) { minute in
                                Text(toDoubleDigit(minute)).tag(minute)
                            }
                        }
                    }
                    localizedUnit(.minutes, style: unitsStyle)
                    
                }
                
                if vm.format == .short || vm.format == .full {
                    VStack {
                        Picker("", selection: $vm.selectedSecond) {
                            ForEach(vm.secondRange, id: \.self) { second in
                                Text(toDoubleDigit(second)).tag(second)
                            }
                        }
                        localizedUnit(.seconds, style: unitsStyle)
                    }
                }
            }
        }
        .pickerStyle(.wheel)
        .onChange(of: vm.duration) { _, newValue in
            self.duration = newValue
        }
    }
}

extension DurationPicker {
    
    func toDoubleDigit(_ num: Int) -> String {
        return num.description.count == 1 ? "0\(num)" : num.description
    }
    
    func localizedUnit(_ unit: UnitDuration, style: MeasurementFormatter.UnitStyle = .long) -> Text {
        let mf = MeasurementFormatter()
        mf.locale = .current
        mf.unitStyle = style
        mf.unitOptions = .providedUnit
        
        let formatted = mf.string(from: unit)
        let str = formatted.filter { $0.isLetter || $0.isWhitespace }
        
        return Text(str)
            .foregroundStyle(Color.accentColor)
            .fontWeight(.light)
        
    }
}


//#Preview("Minimum Time") {
//    NavigationStack {
//        DurationPicker(duration: .constant(11.0), format: .short, minimumTime: 10)
//        DurationPicker(duration: .constant(11.0), format: .long, minimumTime: 10)
//        DurationPicker(duration: .constant(11.0), format: .full, minimumTime: 10)
//    }
//}

#Preview("NO Minimum Time") {
    
    Preview()
}


fileprivate struct Preview: View {
    
    @State var duration1: TimeInterval = 3.0
    @State var duration2: TimeInterval = 3.0
    @State var duration3: TimeInterval = 3.0
    
    var body: some View {
        
        
        Group {
            Divider()
            Text(Duration.seconds(duration1), format: .time(pattern: .hourMinuteSecond))
            DurationPicker(duration: $duration1, format: .short)
                .padding(.bottom)
            Divider()

            Text(Duration.seconds(duration2), format: .time(pattern: .hourMinuteSecond))
            DurationPicker(duration: $duration2, format: .long)
                .padding(.bottom)
            
            Divider()
            Text(Duration.seconds(duration3), format: .time(pattern: .hourMinuteSecond))
            DurationPicker(duration: $duration3, format: .full)
                .padding(.bottom)

        }

    }
}
