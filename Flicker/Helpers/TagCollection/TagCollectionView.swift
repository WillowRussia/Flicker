//
//  TagCollectionView.swift
//  Flicker
//
//  Created by Илья Востров on 24.07.2024.
//

import UIKit

protocol TagCollectionViewProtocol: AnyObject {
    var dataSource: UICollectionViewDataSource { get set}
    init(dataSource: UICollectionViewDataSource)
    func getCollectionView() -> UICollectionView
    var isEditin: Bool {get  set}
}
class TagCollectionView: TagCollectionViewProtocol {
    var isEditin: Bool = false
    
    var dataSource: UICollectionViewDataSource
    
    required init(dataSource: UICollectionViewDataSource) {
        self.dataSource = dataSource
    }
    
    func getCollectionView() -> UICollectionView { // Возращает саму коллекцию
        return {
            .configure(view: $0) { [weak self] collection in
                guard let self = self else {return}
                
                let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
                layout.scrollDirection = .horizontal
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // Делает размер ячеки динамической(зависит от размера контента)
                layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                
                collection.alwaysBounceHorizontal = true // Возможность скролить элементы при недостаточном их количестве
                collection.showsHorizontalScrollIndicator = false // Отключение индикатора скролинга
                collection.dataSource = self.dataSource
                collection.backgroundColor = .clear
                
                collection.register(TagCollectionCell.self, forCellWithReuseIdentifier: TagCollectionCell.reuseId) //Регистрация ячейки
                
                
                
            }
        }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    }
    
    
}
