import XCTest
@testable import GymTrackerCore
class ImportExportTest: XCTestCase {
	private var importExpectation: XCTestExpectation!
	override func setUp() {
        super.setUp()
		importExpectation = XCTestExpectation(description: "Workout imported")
    }
    override func tearDown() {
		dataManager.discardAllChanges()
        super.tearDown()
    }
	func testImportVersion_1_1_1() {
		let f = Bundle(for: type(of: self)).url(forResource: "oldVersion_1.1.1", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertTrue(valid)
			XCTAssertEqual(count, 9)
			XCTAssertNotNil(doPerform)
			doPerform?()
		}) { wrkt in
			XCTAssertEqual(wrkt?.count, 9)
			self.importExpectation.fulfill()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testImportVersion_2_0() {
		let f = Bundle(for: type(of: self)).url(forResource: "oldVersion_2.0", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertTrue(valid)
			XCTAssertEqual(count, 8)
			XCTAssertNotNil(doPerform)
			doPerform?()
		}) { wrkt in
			XCTAssertEqual(wrkt?.count, 8)
			let w = wrkt![6]
			XCTAssertEqual(w.parts.count, 12)
			XCTAssertEqual(w.parts.filter { $0 is GTCircuit }.count, 2)
			for p in [w[8], w[11]] {
				if let c = p as? GTCircuit {
					XCTAssertEqual(c.exercizes.count, 2)
				} else {
					XCTFail("Circuit expected")
				}
			}
			self.importExpectation.fulfill()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testImportVersion_3_0() {
		let f = Bundle(for: type(of: self)).url(forResource: "oldVersion_3.0", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertTrue(valid)
			XCTAssertEqual(count, 12)
			XCTAssertNotNil(doPerform)
			doPerform?()
		}) { wrkt in
			XCTAssertEqual(wrkt?.count, 12)
			let w = wrkt![10]
			XCTAssertEqual(w.parts.count, 11)
			XCTAssertEqual(w.parts.filter { $0 is GTCircuit }.count, 2)
			XCTAssertEqual(w.parts.filter { $0 is GTChoice }.count, 1)
			for p in [w[7], w[10]] {
				if let c = p as? GTCircuit {
					XCTAssertEqual(c.exercizes.count, 2)
				} else {
					XCTFail("Circuit expected")
				}
			}
			if let ch = w[0] as? GTChoice {
				XCTAssertEqual(ch.exercizes.count, 2)
			} else {
				XCTFail("Choice expected")
			}
			self.importExpectation.fulfill()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testXsdInvalidSet() {
		let f = Bundle(for: type(of: self)).url(forResource: "invalidSet", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertFalse(valid)
			XCTAssertNil(count)
			XCTAssertNil(doPerform)
			self.importExpectation.fulfill()
		}) { _ in
			XCTFail()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testXsdInvalidRest() {
		let f = Bundle(for: type(of: self)).url(forResource: "invalidRest", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertFalse(valid)
			XCTAssertNil(count)
			XCTAssertNil(doPerform)
			self.importExpectation.fulfill()
		}) { _ in
			XCTFail()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testXsdInvalidExercize() {
		let f = Bundle(for: type(of: self)).url(forResource: "invalidExercize", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertFalse(valid)
			XCTAssertNil(count)
			XCTAssertNil(doPerform)
			self.importExpectation.fulfill()
		}) { _ in
			XCTFail()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testXsdInvalidChoice() {
		let f = Bundle(for: type(of: self)).url(forResource: "invalidChoice", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertFalse(valid)
			XCTAssertNil(count)
			XCTAssertNil(doPerform)
			self.importExpectation.fulfill()
		}) { _ in
			XCTFail()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testXsdInvalidCircuit() {
		let f = Bundle(for: type(of: self)).url(forResource: "invalidCircuit", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertFalse(valid)
			XCTAssertNil(count)
			XCTAssertNil(doPerform)
			self.importExpectation.fulfill()
		}) { _ in
			XCTFail()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testXsdInvalidWorkout() {
		let f = Bundle(for: type(of: self)).url(forResource: "xsdInvalidWorkout", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertFalse(valid)
			XCTAssertNil(count)
			XCTAssertNil(doPerform)
			self.importExpectation.fulfill()
		}) { _ in
			XCTFail()
		}
		wait(for: [importExpectation], timeout: 5)
	}
	func testInvalidWorkout() {
		let f = Bundle(for: type(of: self)).url(forResource: "invalidWorkout", withExtension: "xml")!
		dataManager.importExportManager.import(f, isRestoring: false, performCallback: { (valid, count, doPerform) in
			XCTAssertTrue(valid)
			XCTAssertEqual(count, 1)
			XCTAssertNotNil(doPerform)
			doPerform?()
		}) { wrkt in
			XCTAssertEqual(wrkt?.count, 0)
			self.importExpectation.fulfill()
		}
		wait(for: [importExpectation], timeout: 5)
	}
}
