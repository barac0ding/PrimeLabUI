//
//  DurationPickerTests.swift
//  PrimeLabUITests
//
//  Created by Sato on 05.02.2026.
//

import XCTest
@testable import PrimeLabUI

final class DurationPickerViewModelTests: XCTestCase {

    // MARK: - Init parsing

    func testInitialDurationParsing() {
        let vm = DurationPickerViewModel(
            initialDuration: 3661,
            format: .full,
            minimumDuration: 0
        )

        XCTAssertEqual(vm.selectedHour, 1)
        XCTAssertEqual(vm.selectedMinute, 1)
        XCTAssertEqual(vm.selectedSecond, 1)
    }

    // MARK: - Duration calculation

    func testDurationComputation() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 0
        )

        vm.selectedHour = 1
        vm.selectedMinute = 2
        vm.selectedSecond = 3

        XCTAssertEqual(vm.duration, 3723)
    }

    // MARK: - Minimum seconds constraint (.full / .short)

    func testMinimumSecondsApplied() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 10
        )

        XCTAssertEqual(vm.selectedSecond, 10)
    }

    // MARK: - Long format minute constraint

    func testLongFormatMinuteConstraint() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .long,
            minimumDuration: 5
        )

        XCTAssertEqual(vm.selectedMinute, 5)
    }

    // MARK: - Minute constraint when hour changes

    func testMinuteResetsWhenHourIsZero() {
        let vm = DurationPickerViewModel(
            initialDuration: 3600,
            format: .long,
            minimumDuration: 10
        )

        vm.selectedHour = 0

        XCTAssertEqual(vm.selectedMinute, 10)
    }

    // MARK: - Second constraint logic

    func testSecondConstraintWhenHourAndMinuteZero() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 7
        )

        vm.selectedHour = 0
        vm.selectedMinute = 0
        vm.selectedSecond = 0

        XCTAssertEqual(vm.selectedSecond, 7)
    }

    // MARK: - Picker ranges

    func testRangesRespectMinimums() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 10
        )

        XCTAssertEqual(vm.secondRange.first, 10)
        XCTAssertEqual(vm.secondRange.last, 59)
    }
}
