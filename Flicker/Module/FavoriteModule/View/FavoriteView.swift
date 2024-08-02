//
//  FavoriteView.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import UIKit

protocol FavotiteViewProtocol: AnyObject{
    func showPost()
}
class FavotiteView: UIViewController {
    
    var presenter: FavoriteViewPresenterProtocol!
    
    lazy var collectionView: UICollectionView = {
        
        let itemSize = ((view.bounds.width - 60) / 2) - 15 //Высчитываем размер ячейки
        
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 30 //отступ между ячейками по бокам
        //layout.minimumInteritemSpacing = 30 // отступ между ячейками снизу
        layout.sectionInset = UIEdgeInsets(top: 50, left: 30, bottom: 80, right: 30) // Отступы между секциями
        
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.alwaysBounceVertical = true //Скрол при малом количестве элементов
        $0.backgroundColor = .appMain
        $0.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseId)
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout()))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
    }
    //Настройка нав. контролера
    private func setupNavBar() {
        title = "Избранное"
        navigationController?.navigationBar.prefersLargeTitles = true // Поменяли вид тайтла
        navigationController?.navigationBar.barTintColor = .appMain // Настройка фона
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white // Цвет в большом
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white // Цвет текста в маленьком размере(свернут)
        ]
    }


}

extension FavotiteView: FavotiteViewProtocol {
    func showPost() {
        collectionView.reloadData()
    }
    
    
}

extension FavotiteView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.post?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        if let item = presenter.post?[indexPath.row] {
            cell.configureCell(item: item)
        }
        cell.backgroundColor = .red
        return cell
}
    
}

extension FavotiteView: UICollectionViewDelegate {
    
}
