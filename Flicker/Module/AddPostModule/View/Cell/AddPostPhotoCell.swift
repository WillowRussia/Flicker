//
//  AddPostPhotoCell.swift
//  Flicker
//
//  Created by Илья Востров on 01.11.2024.
//

import UIKit

class AddPostPhotoCell: UICollectionViewCell, CollectionViewCellProtocol {
    
    static let reuseId: String = "AddPostPhotoCell"
    
    var completion: ( () -> () )? // Через него перекидваем удаление фотографии
    private lazy var cellImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true //Логическое значение, которое определяет, игнорируются ли пользовательские события и удаляются из очереди событий
        return $0
    }(UIImageView(frame: bounds))
    
    private lazy var photoRemoveButton: UIButton = {
        $0.setBackgroundImage(.closeIcon, for: .normal)
        return $0
    }(UIButton(frame: CGRect(x: cellImage.frame.width - 30, y: 30, width: 15, height: 15), primaryAction: photoRemoveButtonAction))
    
    private lazy var photoRemoveButtonAction = UIAction { [weak self] _ in
        self?.completion?()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview (cellImage)
        layer.cornerRadius = 30
        clipsToBounds = true
        cellImage.addSubview(photoRemoveButton)
    }
    
    func setCellImage (image: UIImage) {
        self.cellImage.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
