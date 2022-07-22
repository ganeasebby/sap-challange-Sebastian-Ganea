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
    
    func testCOllectionViewModeldistributeTheRemainingSpaceBetweenAllCellsInRow(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        var rowWidths: [CGFloat] = [50, 50]
        
        //test cell increase
        var spaceToDistribute: CGFloat = 100
        var result = model.distributeTheRemainingSpaceBetweenAllCellsInRow(rowWidths, spaceToDistribute: spaceToDistribute)
        var spacePerCell = spaceToDistribute / ( CGFloat(model.nrOfCellsInRow) - 1)
        var expected = rowWidths.map({$0 + spacePerCell})
        XCTAssertEqual(result, expected)
        
        // test cell decrease
        rowWidths = [140, 140]
        spaceToDistribute = -100
        result = model.distributeTheRemainingSpaceBetweenAllCellsInRow(rowWidths, spaceToDistribute: spaceToDistribute)
        spacePerCell = spaceToDistribute / ( CGFloat(model.nrOfCellsInRow) - 1)
        expected = rowWidths.map({$0 + spacePerCell})
        XCTAssertEqual(result, expected)
        
        // test cell decrease below minimum cell size
        rowWidths = [60, 60]
        spaceToDistribute = -110
        result = model.distributeTheRemainingSpaceBetweenAllCellsInRow(rowWidths, spaceToDistribute: spaceToDistribute)
        spacePerCell = spaceToDistribute / ( CGFloat(model.nrOfCellsInRow) - 1)
        expected = [model.minCellWidth, model.minCellWidth]
        XCTAssertEqual(result, expected)
        
        //test cell increase above maximum cell width
        spaceToDistribute = 500
        result = model.distributeTheRemainingSpaceBetweenAllCellsInRow(rowWidths, spaceToDistribute: spaceToDistribute)
        spacePerCell = spaceToDistribute / ( CGFloat(model.nrOfCellsInRow) - 1)
        let max = model.calculateMaxCellWidth()
        expected = [max, max]
        XCTAssertEqual(result, expected)
    }
    
    func testCollectionViewModelgetAllRowIndexpathsFor(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        let indexPath = IndexPath(row: 23, section: 0)
        let result = model.getAllRowIndexpathsFor(indexPath: indexPath)
        
        let position = model.getPositionInRowFor(indexPath: indexPath)
        let rowStart = indexPath.row - position
        var rowEnd = rowStart + model.nrOfCellsInRow - 1
        if rowEnd >= model.datasource.count {
            rowEnd = model.datasource.count - 1
        }
        
        XCTAssertEqual(result[0], IndexPath(row: rowStart, section: 0))
        XCTAssertEqual(result.last, IndexPath(row: rowEnd, section: 0))
        
    }
    
    func testCollectionViewModelsetSizeForCell(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        let indexpath = IndexPath(row: 5, section: 0)
        let size = CGSize(width: 100, height: 280)
        model.setSizeForCellAt(indexPath: indexpath, size: size)
        
        let cell = model.layoutObj[indexpath.row]
        
        XCTAssertEqual(cell.size, size)
    }
    
    func testDataSourceFactoryGetData(){
        let count = 34
        let resutl = DataSourceFactory.generateDummyModels(count)
        XCTAssertEqual(resutl.count, count)
    }

}
