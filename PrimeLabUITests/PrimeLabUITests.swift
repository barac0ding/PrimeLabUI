//
//  PrimeLabUITests.swift
//  PrimeLabUITests
//
//  Created by Sato on 05.02.2026.
//

import XCTest
@testable import PrimeLabUI

final class PrimeLabUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - Changing minute updates second constraint

    func testChangingMinuteUpdatesSecondConstraint() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 15
        )

        vm.selectedHour = 0
        vm.selectedMinute = 0
        vm.selectedSecond = 0

        XCTAssertEqual(vm.selectedSecond, 15)
    }
    
    
    // MARK: - Changing hour updates minute constraint

    func testChangingHourUpdatesMinuteConstraint() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .long,
            minimumDuration: 15
        )

        vm.selectedHour = 0
        vm.selectedMinute = 3
        vm.selectedSecond = 0

        XCTAssertEqual(vm.selectedMinute, 15)
    }

    // MARK: - Second constraint removed when minute > 0

    func testSecondConstraintRemovedWhenMinuteGreaterZero() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 20
        )

        vm.selectedMinute = 1
        vm.selectedSecond = 0

        XCTAssertEqual(vm.minimumSecond, 0)
    }

    // MARK: - Hour removes minute constraint in long format

    func testHourRemovesMinuteConstraintInLongFormat() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .long,
            minimumDuration: 10
        )

        vm.selectedHour = 1

        XCTAssertEqual(vm.minimumMinute, 0)
    }
    

    // MARK: - Duration updates after picker changes

    func testDurationUpdatesAfterChanges() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 0
        )

        vm.selectedHour = 2
        vm.selectedMinute = 30
        vm.selectedSecond = 15

        XCTAssertEqual(vm.duration, 9015)
    }

    // MARK: - Second range updates dynamically

    func testSecondRangeUpdates() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 5
        )

        XCTAssertEqual(vm.secondRange.first, 5)

        vm.selectedMinute = 1

        XCTAssertEqual(vm.secondRange.first, 0)
    }

    // MARK: - Initial value above minimum remains unchanged

    func testInitialValueAboveMinimumNotModified() {
        let vm = DurationPickerViewModel(
            initialDuration: 120,
            format: .full,
            minimumDuration: 10
        )

        XCTAssertEqual(vm.selectedMinute, 2)
    }
    
    // MARK: - setupLongFormat behavior

    func testLongFormatResetsSecondsWhenDurationLessThanMinute() {
        let vm = DurationPickerViewModel(
            initialDuration: 30,
            format: .long,
            minimumDuration: 1
        )

        XCTAssertEqual(vm.selectedSecond, 0)
    }

    // MARK: - Minute forced to minimum in long format

    func testMinuteForcedToMinimum() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .long,
            minimumDuration: 10
        )

        vm.selectedMinute = 5
        XCTAssertEqual(vm.selectedMinute, 10)
    }

    // MARK: - Second forced to minimum in full format

    func testSecondForcedToMinimum() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 12
        )

        vm.selectedSecond = 3
        XCTAssertEqual(vm.selectedSecond, 12)
    }

    // MARK: - Minute range updates after hour change

    func testMinuteRangeUpdatesAfterHourChange() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .long,
            minimumDuration: 15
        )

        XCTAssertEqual(vm.minuteRange.first, 15)

        vm.selectedHour = 1

        XCTAssertEqual(vm.minuteRange.first, 0)
    }

    // MARK: - Zero minimum does not alter selection

    func testZeroMinimumDoesNotAlterSelection() {
        let vm = DurationPickerViewModel(
            initialDuration: 25,
            format: .full,
            minimumDuration: 0
        )

        XCTAssertEqual(vm.selectedSecond, 25)
    }

    // MARK: - Duration stable when constraints change

    func testDurationStableAfterConstraintChange() {
        let vm = DurationPickerViewModel(
            initialDuration: 120,
            format: .full,
            minimumDuration: 10
        )

        let before = vm.duration
        vm.selectedMinute = 2
        let after = vm.duration

        XCTAssertEqual(before, after)
    }

    // MARK: - Hour range correctness

    func testHourRangeBounds() {
        let vm = DurationPickerViewModel(
            initialDuration: 0,
            format: .full,
            minimumDuration: 0
        )

        XCTAssertEqual(vm.hourRange.first, 0)
        XCTAssertEqual(vm.hourRange.last, 23)
    }

}
