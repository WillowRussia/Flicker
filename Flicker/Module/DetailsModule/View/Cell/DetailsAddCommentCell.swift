//
//  DetailsAddCommentCell.swift
//  Flicker
//
//  Created by Илья Востров on 10.10.2024.
//

import UIKit

class DetailsAddCommentCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseId: String = "DetailsAddCommentCell"
    
    var completion: ((String) -> ())?
    lazy var action = UIAction {[weak self] sender in
        let textField = sender.sender as! UITextField
        self?.completion? (textField.text ?? "")
        self?.endEditing(true) //Скрытие клавиатуры
    }
    
    lazy var textField: UITextField = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = bounds.height/2
        $0.clipsToBounds = true
        $0.attributedPlaceholder = NSAttributedString(
            string: "Добавить комментарий",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        $0.textColor = .gray
        $0.setLeftOffSet()
        return $0
    }(UITextField(frame: bounds, primaryAction: action))
    
    required override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
