//
//  AddPostView.swift
//  Flicker
//
//  Created by Илья Востров on 31.10.2024.
//

import UIKit

protocol AddPostViewProtocol: AnyObject {
    
}

class AddPostView: UIViewController, AddPostViewProtocol {
    
    private var menuViewHeight = UIApplication.topSafeArea + 50
    
    var presenter: AddPostPresenterProtocol!
    
    lazy var collectionView: UICollectionView = {
        $0.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0) //Добавляет расстояние вокруг коллекции
        $0.backgroundColor = .none
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "self")
        $0.register(AddPostPhotoCell.self, forCellWithReuseIdentifier: AddPostPhotoCell.reuseId)
        $0.register(AddPostTagCell.self, forCellWithReuseIdentifier: AddPostTagCell.reuseId)
        $0.register(AddPostFieldCell.self, forCellWithReuseIdentifier: AddPostFieldCell.reuseId)
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionLayout()))
    
    lazy var saveButton: UIButton = {
        $0.backgroundColor = .appBlack
        $0.setTitle("Сохранить", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.layer.cornerRadius = 27.5
        return $0
    }(UIButton(frame: CGRect(x: 30, y: view.bounds.height - 98 , width: view.bounds.width - 60, height: 55), primaryAction: saveBtnAction))
    
    lazy var saveBtnAction = UIAction { _ in
        
    }
    
    lazy var topMenuView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
        $0.backgroundColor = .appMain
        return $0
    }(UIView())
    
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader (backAction: self.backAction, date: Date())
    }()
    
    lazy var backAction = UIAction {[weak self] _ in
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(topMenuView)
        view.addSubview(saveButton)
        setupHeader()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing))) //Добавляем жест для скрытия клавиатуры при нажатии на любую область
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil) // Отслеживаем появление клавиатуры,указыва keyboardWillChangeFrameNotification
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillHideNotification, object: nibName) // Отслеживаем исчезание клавиатуры,указыва keyboardWillHideNotification
    }
    
    @objc func keyboardChange(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return } //Достаем размеры клавиатуры
        
        let keyboardViewFrame = view.convert(keyboardValue.cgRectValue, from: view.window) //Переводим разсер относительно экрана устройства
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionView.contentInset.bottom = 100 // Возращаем стандартный отступ у коллекции
        } else {
            collectionView.contentInset.bottom = keyboardViewFrame.height
        }
            
        }
        
        @objc func endEditing() {
            view.endEditing(true) //Скрытие клавиатуры
        }
    
    private func setupHeader() {
        let header = navigationHeader.getNavigationHeader(type: .close)
        header.frame.origin.y = UIApplication.topSafeArea
        view.addSubview(header)
    }

}

extension AddPostView {
    
    private func getCompositionLayout() -> UICollectionViewCompositionalLayout {
            UICollectionViewCompositionalLayout { [weak self] section, _ in
                switch section{
                case 0:
                    return self?.createPhotoSection()
                case 1:
                    return self?.createTagSection()
                default:
                    return self?.createFormSection()
                }
            }
        }
    
    private func createPhotoSection() -> NSCollectionLayoutSection {
        
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(185),
                                               heightDimension: .absolute(260))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 30, bottom: 30, trailing: 30)
            
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    
    private func createTagSection() -> NSCollectionLayoutSection {
        
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(110),
                                                   heightDimension: .estimated(10))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [.init(layoutSize: groupSize)])
            
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30)
            
            
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
    private func createFormSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(185))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        return section
    }
    
}

extension AddPostView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return presenter.photos.count
        case 1:
            return presenter.tags.count
        default:
            return 1
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
                case 0:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostPhotoCell.reuseId, for: indexPath) as! AddPostPhotoCell
                    let image = presenter.photos[indexPath.row]
                    cell.setCellImage(image: image)
                    
                    return cell
                case 1:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostTagCell.reuseId, for: indexPath) as! AddPostTagCell
                    let tag = presenter.tags[indexPath.row]
                    cell.setTagText(tagText: tag)
            
                    return cell
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostFieldCell.reuseId, for: indexPath) as! AddPostFieldCell
                    
                    return cell
                }
    }
    
    
}
