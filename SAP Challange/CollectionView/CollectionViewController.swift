//
//  CollectionVIewController.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

/// view controller of the CollectionView
class CollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    /// the viewModel for the collectionview
    private var viewModel: CollectionViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CollectionViewViewModel(collectionViewWidth: collectionView.frame.width)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updateCollectionviewWidth(collectionView.frame.width)
    
        setupCollectionView()
    }
    /// the initial setup of the collectionview
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .lightGray
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.minimumLineSpacing = viewModel.cellPadding
            flowLayout.minimumInteritemSpacing = viewModel.cellPadding
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: viewModel.cellPadding, bottom: 0, right: viewModel.cellPadding)
        }
    }

    /// the handler for the pinch gesture
    @objc private func pinchGestureDetected(_ gesture: UIPinchGestureRecognizer){
        guard let cell = gesture.view as? UICollectionViewCell else {return}
        guard let index = collectionView.indexPath(for: cell) else {return}
        
        if let newSize = viewModel.calculateSizeFor(pinch: gesture){
            cell.bounds.size = newSize
            collectionView.bringSubviewToFront(cell)
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
        }
        
        if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed{
            viewModel.setSizeForCellAt(indexPath: index, size: cell.bounds.size)
            cell.layer.borderWidth = 0
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }
    }
}

/// adds functionality for the UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCellIdentifier", for: indexPath) as? CustomCollectionViewCell else {return UICollectionViewCell()}
        
        cell.setupWithModel(viewModel.getCellModel(indexPath: indexPath))
        cell.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureDetected(_:))))
        return cell
    }
}

/// adds functionality for the UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.layoutObj[indexPath.row].size
    }
}
