//
//  MainScreenView.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import UIKit

protocol MainScreenViewProtocol: AnyObject{
    func showPosts()
}

class MainScreenView: UIViewController {

    var presenter: MainScreenPresenterProtocol!

    private lazy var collectionView: UICollectionView = {

        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 60, height: view.frame.width - 60)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 40, right: 0)

        $0.backgroundColor = .appMain
        $0.dataSource = self
        $0.delegate = self
        $0.alwaysBounceVertical = true
        $0.register(MainPostCell.self, forCellWithReuseIdentifier: MainPostCell.reuseId)
        $0.register(MainPostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainPostHeader.reuseId)

        return $0

    }(UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout()))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appMain
        view.addSubview(collectionView)
    }


}

extension MainScreenView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.presenter.posts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.posts?[section].items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPostCell.reuseId, for: indexPath) as? MainPostCell
        else { return UICollectionViewCell() }

        cell.backgroundColor = .gray
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainPostHeader.reuseId, for: indexPath) as! MainPostHeader

        header.setHeaderText(header: presenter.posts?[indexPath.section].date.getDateDiference())
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width - 60, height: 40)
    }


}

extension MainScreenView: MainScreenViewProtocol{
    func showPosts() {
        collectionView.reloadData()
    }
}
