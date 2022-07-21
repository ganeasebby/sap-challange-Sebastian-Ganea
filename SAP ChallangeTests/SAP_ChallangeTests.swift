//
//  SAP_ChallangeTests.swift
//  SAP ChallangeTests
//
//  Created by Sebastian Ganea on 20.07.2022.
//

import XCTest
@testable import SAP_Challange

class SAP_ChallangeTests: XCTestCase {

    func testCollectionViewModelDefualtCellSize(){
        let collectionViewWidth: CGFloat = 300
        let model = CollectionViewViewModel(collectionViewWidth: collectionViewWidth)
        let size = model.calculateDefaultCellSize()
        
        // expect
        let cells = CGFloat(model.nrOfCellsInRow)
        let emptySpace = (cells + 1) * model.cellPadding
        let width = floor((collectionViewWidth - emptySpace) / cells)
        
        XCTAssertEqual(size.width, width)
        XCTAssertEqual(size.height, width)
        
    }
    
    func testCollectionViewModelMaxCellWidth(){
        let collectionViewWidth: CGFloat = 300
        let model = CollectionViewViewModel(collectionViewWidth: collectionViewWidth)
        let width = model.calculateMaxCellWidth()
        
        
        // expect
        let cells = CGFloat(model.nrOfCellsInRow)
        let emptySpace = (cells + 1) * model.cellPadding
        let expectedWidth = collectionViewWidth - (model.minCellWidth * cells + emptySpace)
        
        XCTAssertEqual(width, expectedWidth)
        
    }
    
    func testCollectionViewModelUpdateCollectionviewWidth(){
        // the model is intialized with a given width
        var collectionViewWidth: CGFloat = 300
        let model = CollectionViewViewModel(collectionViewWidth: collectionViewWidth)
        let initialDefaultCellWidth = model.calculateDefaultCellSize()
        let initialMaxCellWidth = model.calculateMaxCellWidth()
        
        // update the width of the collectionview
        collectionViewWidth = 400
        model.updateCollectionviewWidth(collectionViewWidth)
        let crtDefaultCellWidth = model.calculateDefaultCellSize()
        let crtMaxCellWidth = model.calculateMaxCellWidth()
        XCTAssertNotEqual(initialMaxCellWidth, crtMaxCellWidth)
        XCTAssertNotEqual(initialDefaultCellWidth, crtDefaultCellWidth)
        
        let cellsNr = CGFloat(model.nrOfCellsInRow)
        let emptySpace = (cellsNr + 1) * model.cellPadding
        let expectedDefaultCellSize = floor((collectionViewWidth - emptySpace) / cellsNr)
        let expectedMaxWidth = collectionViewWidth - (model.minCellWidth * cellsNr + emptySpace)
        
        
        XCTAssertEqual(crtDefaultCellWidth.width, expectedDefaultCellSize)
        XCTAssertEqual(crtMaxCellWidth, expectedMaxWidth)
        
    }
    
    func testCollectionViewModelGetPositionInRow(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
       let index = IndexPath(row: 25, section: 0)
        let position = model.getPositionInRowFor(indexPath: index)
        
        // expect
        let expectedPosition = index.row % model.nrOfCellsInRow
        XCTAssertEqual(position, expectedPosition)
        
    }
    
    func testCollectionViewModelDeterminegestureTypeForTouchLocations(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        var loc1 = CGPoint(x: 0, y: 5)
        var loc2 = CGPoint(x: 0, y: 2)
        var result = model.determinegestureTypeForTouchLocations(loc1: loc1, loc2: loc2)
        XCTAssertEqual(result, .vertical)
        
        loc1 = CGPoint(x: 0, y: 0)
        loc2 = CGPoint(x: 4, y: 6)
        result = model.determinegestureTypeForTouchLocations(loc1: loc1, loc2: loc2)
        XCTAssertEqual(result, .diagonal)
        
        loc1 = CGPoint(x: 0, y: 0)
        loc2 = CGPoint(x: 50, y: 10)
        result = model.determinegestureTypeForTouchLocations(loc1: loc1, loc2: loc2)
        XCTAssertEqual(result, .horizontal)
        
    }
    
    func testCollectionViewModelCalculateCellSizeForPinchGestureType(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        var gestureType = CollectionViewViewModel.GestureType.vertical
        let cellSize = CGSize(width: 20, height: 20)
        var scale: CGFloat = 10
        model.focusedCellSize = cellSize
        var result = model.calculateCellSizeForPinchGestureType(gestureType, scale: scale)

        var expectedsize = CGSize(width: cellSize.width, height: cellSize.width * scale)
        XCTAssertEqual(result, expectedsize)
        
        gestureType = .horizontal
        model.focusedCellSize = cellSize
        scale = 2
        result = model.calculateCellSizeForPinchGestureType(gestureType, scale: scale)
        expectedsize = CGSize(width: cellSize.width * scale, height: cellSize.width * 10)
        XCTAssertEqual(result, expectedsize)
        
        gestureType = .vertical
        result = model.calculateCellSizeForPinchGestureType(gestureType, scale: scale)
        expectedsize = CGSize(width: cellSize.width * scale, height: cellSize.width * scale)
        XCTAssertEqual(result, expectedsize)
        
    }
    
    func testCollectionViewModelValidateFocusedCellSize(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        var result = model.validateFocusedCellSize(CGSize(width: 20, height: 20))
        XCTAssertEqual(result.width, 50)
        
        result = model.validateFocusedCellSize(CGSize(width: 5000, height: 20))
        XCTAssertEqual(result.width, model.calculateMaxCellWidth())
        
    }

}
