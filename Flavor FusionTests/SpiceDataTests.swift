import XCTest
@testable import Flavor_Fusion

class SpiceDataTests: XCTestCase {
    
    // Test Spice initialization
    func testSpiceInitialization() {
        let spice = Spice(name: "Test Spice", spiceAmount: 0.5, selectedAmount: 0.0, containerNumber: 101)
        XCTAssertEqual(spice.name, "Test Spice")
        XCTAssertEqual(spice.spiceAmount, 0.5)
        XCTAssertEqual(spice.selectedAmount, 0.0)
        XCTAssertEqual(spice.containerNumber, 101)
    }
    
    // Test if all spices are initialized properly
    func testAllSpicesInitialization() {
        XCTAssertEqual(spiceData.count, 10)
        
        let firstSpice = spiceData[0]
        XCTAssertEqual(firstSpice.name, "Spice 1")
        XCTAssertEqual(firstSpice.spiceAmount, 1.0)
        XCTAssertEqual(firstSpice.selectedAmount, 0.0)
        XCTAssertEqual(firstSpice.containerNumber, 101)
        
        let lastSpice = spiceData[spiceData.count - 1]
        XCTAssertEqual(lastSpice.name, "Spice 10")
        XCTAssertEqual(lastSpice.spiceAmount, 0.7)
        XCTAssertEqual(lastSpice.selectedAmount, 0.0)
        XCTAssertEqual(lastSpice.containerNumber, 110)
    }
    
    // Test Spice selection
    func testSpiceSelection() {
        var spice = Spice(name: "Test Spice", spiceAmount: 0.5, selectedAmount: 0.0, containerNumber: 101)
        XCTAssertFalse(spice.isSelected)
        
        spice.isSelected = true
        XCTAssertTrue(spice.isSelected)
    }
}
