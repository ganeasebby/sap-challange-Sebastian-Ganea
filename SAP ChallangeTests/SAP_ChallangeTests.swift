//
//  SAP_ChallangeTests.swift
//  SAP ChallangeTests
//
//  Created by Sebastian Ganea on 20.07.2022.
//

import XCTest
@testable import SAP_Challange

class SAP_ChallangeTests: XCTestCase {

    /// tests if the default cell size is correctly calculated. The cells need to fill the width of the screen
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
    
    /// tests if the maximumCellWidth is calculated correctly. Each cell width size can only be increased to the point where the other cells in that row reach the minimum allowed size, Because increasing one cell will decreasee the other cells in that row
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
    
    /// tests if the cells are correctly placed on collectionviews of different widths
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
    
    /// tests if the "position in row" is correctly calculated
    func testCollectionViewModelGetPositionInRow(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
       let index = IndexPath(row: 25, section: 0)
        let position = model.getPositionInRowFor(indexPath: index)
        
        // expect
        let expectedPosition = index.row % model.nrOfCellsInRow
        XCTAssertEqual(position, expectedPosition)
        
    }
    
    /// tests if the pinch gesture direction type is calculated correctly
    func testCollectionViewModelDeterminegestureTypeForTouchLocations(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        var loc1 = CGPoint(x: 0, y: 5)
        var loc2 = CGPoint(x: 0, y: 2)
        var result = model.getGestureTypeForTouchPoints(loc1: loc1, loc2: loc2)
        XCTAssertEqual(result, .vertical)
        
        loc1 = CGPoint(x: 0, y: 0)
        loc2 = CGPoint(x: 4, y: 6)
        result = model.getGestureTypeForTouchPoints(loc1: loc1, loc2: loc2)
        XCTAssertEqual(result, .diagonal)
        
        loc1 = CGPoint(x: 0, y: 0)
        loc2 = CGPoint(x: 50, y: 10)
        result = model.getGestureTypeForTouchPoints(loc1: loc1, loc2: loc2)
        XCTAssertEqual(result, .horizontal)
        
    }
    
    /// tests if the cell size is calculated correctly after a specific pinch gesture type is applied
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
        
        gestureType = .diagonal
        result = model.calculateCellSizeForPinchGestureType(gestureType, scale: scale)
        expectedsize = CGSize(width: cellSize.width * scale, height: cellSize.width * scale)
        XCTAssertEqual(result, expectedsize)
        
    }
    
    /// tests if a cell size is valid... if it's size is within the min/max bounds
    func testCollectionViewModelValidateFocusedCellSize(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        var result = model.validateFocusedCellSize(CGSize(width: 20, height: 20))
        XCTAssertEqual(result.width, 50)
        
        result = model.validateFocusedCellSize(CGSize(width: 5000, height: 20))
        XCTAssertEqual(result.width, model.calculateMaxCellWidth())
        
    }
    
    /// tests if the other cells in a row are correctly increased or decreased after the user interacts with a cells in that row
    func testCollectionViewModeldistributeTheRemainingSpaceBetweenAllCellsInRow(){
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
    
    /// tests if the correct indexpaths are returned for the provided indexpath. Basically it should return all de indexpaths that are on the same row with the provided indexpath
    func testCollectionViewModelgetAllRowIndexpathsFor(){
        DataSourceFactory.shared = DataSourceFactory(factory: TestDataSourceFactory())
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
    
    
    /// tests if the cell that the user interacts with is correctly resized
    func testCollectionViewModelsetSizeForCell(){
        let model = CollectionViewViewModel(collectionViewWidth: 300)
        let indexpath = IndexPath(row: 5, section: 0)
        let size = CGSize(width: 100, height: 280)
        model.setSizeForCellAt(indexPath: indexpath, size: size)
        
        let cell = model.layoutObj[indexpath.row]
        
        XCTAssertEqual(cell.size, size)
    }
    
    /// tests if the datasource is being generated
    func testDataSourceFactoryGetData(){
        DataSourceFactory.shared = DataSourceFactory(factory: TestDataSourceFactory())
        let result = DataSourceFactory.shared?.getData()
        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result!.count, 10)
    }
    
    /// tests if the content for the cells is correcly built based on the model
    func testCustomCellViewModelGetContent(){
        let str = "labelTest"
        var model: SAPModel = LabelModel(text: str)
        var viewModel = CustomCollectionViewCellViewModel(model: model)
        var result = viewModel.getContent()
        
        XCTAssertTrue(result.isMember(of: LabelContent.self))
        XCTAssertEqual((result as? UILabel)?.text, str)
        
        model = TextViewModel(text: str)
        viewModel = CustomCollectionViewCellViewModel(model: model)
        result = viewModel.getContent()
        
        XCTAssertTrue(result.isMember(of: TextViewContent.self))
        XCTAssertEqual((result as? UITextView)?.text, str)
    }
    
    /// tests if the setup and prepare for reuse for the customCellView is done correctly
    func testCustomCollectionViewCellsetupWithModel(){
        let str = "labelTest"
        let cell = CustomCollectionViewCell()
        let model: SAPModel = LabelModel(text: str)
        let viewModel = CustomCollectionViewCellViewModel(model: model)
        cell.setupWithModel(viewModel)
        
        let label = cell.contentView.subviews.first as? LabelContent
        XCTAssertEqual(label?.text, str)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        XCTAssertEqual(label?.frame.size, cell.contentView.frame.size)
        
        cell.prepareForReuse()
        XCTAssertEqual(cell.contentView.subviews, [])
    }
    
    func test(){
//       let label = LabelModel(text: "dsds")
//        let textview = TextViewModel(text: "ddddd")
//        
//        if label.self == LabelModel{
//            
//        }
    }

}
