//
//  MainPostCell.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import UIKit

class MainPostCell: UICollectionViewCell, CollectionViewCellProtocol {

    static let reuseId = "MainPostCell"
    
    private var tags: [String] = []
    
    private var tagCollectionView: UICollectionView! //Колекция из тегов
    private var photoCountLabel = UILabel() //Счетчик фотографий в ячейке
    private var commentCountLabel = UILabel()// Счетчик коментарий
    private var postDescriptionLabel = UILabel()// Основная информация про пост
    
    lazy var postImage: UIImageView = { // Лицевая картинка
        $0.contentMode = .scaleAspectFill //На всю ширину
        $0.clipsToBounds = true //Обрезает части, которые выходят за границу ячейки
        return $0
    }(UIImageView(frame: bounds))
    
    lazy var countLabelsStack: UIStackView = { // Стек счетчиков фото и коментов
        .configure (view: $0) {[weak self] stack in
            guard let self = self else {return}
            stack.axis = .horizontal
            stack.spacing = 20
            stack.addArrangedSubview(self.photoCountLabel)
            stack.addArrangedSubview(self.commentCountLabel)
            stack.addArrangedSubview(UIView())
        }
    } (UIStackView())
    
    lazy var addFavoriteButton: UIButton = {
        $0.frame = CGRect(x: bounds.width - 60, y: 35, width: 25, height: 25)
        $0.setBackgroundImage(.heart, for: .normal)
        $0.tintColor = .black
        return $0
    }(UIButton(primaryAction: nil))
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        contentViewConfig()
    }
    
    private func contentViewConfig() { //Настроки отображения view и добавление тени
        [postImage, addFavoriteButton].forEach{addSubview($0)}
        layer.cornerRadius = 30
        clipsToBounds = true //Обрезает части, которые выходят за границу ячейки
        
        setViewGradient(frame: bounds, startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0.5), colors: [.black,.clear], locations: [0,1])
    }
    //Функция для переиспользования ячеек
    override func prepareForReuse() {
            tagCollectionView.removeFromSuperview()
            postDescriptionLabel.removeFromSuperview()
        }
    
    
    func configureCell(item: PostItem){ // Функция, которая вызывается из вне для настройки ячеки
        tags = item.tags ?? []
        
        let tagCollection: TagCollectionViewProtocol = TagCollectionView(dataSource: self)
        tagCollectionView = tagCollection.getCollectionView()
        
        postImage.image = UIImage(named: item.photos.first!)
        
        photoCountLabel = getCellLabel(text: "\(item.photos.count) фото")
        commentCountLabel = getCellLabel(text: "\(item.comments?.count ?? 0) коментарий")
        postDescriptionLabel = getCellLabel(text:item.description ?? "")
        
        [countLabelsStack, tagCollectionView,postDescriptionLabel].forEach{addSubview($0)}
        
        //Констренты
        NSLayoutConstraint.activate([
            
            countLabelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            countLabelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            countLabelsStack.bottomAnchor.constraint(equalTo: tagCollectionView.topAnchor, constant: -20),
            
            tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),//Слева
            tagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor), //Справа
            tagCollectionView.heightAnchor.constraint(equalToConstant: 40),//Высота
            tagCollectionView.bottomAnchor.constraint(equalTo: postDescriptionLabel.topAnchor, constant: -10),//От верхушки основного текста отталкиваемся
            
            postDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),//Слева
            postDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),//Справа
            postDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30) //Вниз
        ])
    }

    private func getCellLabel(text: String) -> UILabel {
        return {
            .configure(view: $0) { label in
                label.numberOfLines = 0 //Делает лэйбел с безграничным количеством строк
                label.font = UIFont.systemFont(ofSize: 14)
                label.text = text
                label.textColor = .white
            }
        }(UILabel())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPostCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionCell.reuseId, for: indexPath) as! TagCollectionCell
        let tag = tags[indexPath.item] //item - коллекция, row - ячеки в таблице
        cell.configureCell(tagText: tag)
        return cell
    }
    
    
}
