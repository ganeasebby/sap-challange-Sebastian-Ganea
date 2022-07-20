//
//  CollectionVIewController.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

class CollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    /// the model for the viewcontroller
    var viewModel: CollectionViewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CollectionViewViewModel(collectionView: collectionView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updateCollectionviewWidth(collectionView.frame.width)

        setupCollectionView()
    }
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .lightGray
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.minimumLineSpacing = viewModel.cellPadding
            flowLayout.minimumInteritemSpacing = viewModel.cellPadding
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: viewModel.cellPadding, bottom: 0, right: viewModel.cellPadding)
        }
    }

    @objc private func pinchGestureDetected(_ gesture: UIPinchGestureRecognizer){
        guard let cell = gesture.view as? UICollectionViewCell else {return}
        guard let index = collectionView.indexPath(for: cell) else {return}
        
        if let newSize = viewModel.calculateSizeFor(pinchGesture: gesture){
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

extension CollectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCellIdentifier", for: indexPath) as? CustomCollectionViewCell else {return UICollectionViewCell()}
        
        let model = viewModel.getCellModel(indexPath: indexPath)
        cell.setupWithModel(model)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureDetected(_:)))
        cell.addGestureRecognizer(pinch)

        return cell
    }
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = viewModel.datasource[indexPath.row].cellSize
        return size
    }
}
