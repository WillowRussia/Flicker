//
//  AddPostFieldCell.swift
//  Flicker
//
//  Created by Илья Востров on 01.11.2024.
//

import UIKit

class AddPostFieldCell: UICollectionViewCell, CollectionViewCellProtocol {
    
    static var reuseId: String = "AddPostFieldCell"
    
    private lazy var tagField: UITextField = {
        $0.backgroundColor = .appBlack
        $0.attributedPlaceholder = NSAttributedString(string: "Добавить тег", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)]) // Настройка текста и цвета
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 1)) //Добавление отступа слева
        $0.leftViewMode = .always
        $0.layer.cornerRadius = 24
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UITextField(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 48), primaryAction: tagFieldAction))
    
    private lazy var tagFieldAction = UIAction { _ in
        self.endEditing(true)
    }
    
    
    
    lazy var placeholder: UILabel = {
        $0.text = "Описание"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .white
        $0.layer.opacity = 0.4
        return $0
    }(UILabel(frame: CGRect(x: 24, y: 19, width: 100, height: 20)))
    
    lazy var textView: UITextView = {
        $0.addSubview(placeholder)
        $0.delegate = self
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 30
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // Отступы для текста внутри вью
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UITextView(frame: CGRect(x: 0, y: 68, width: bounds.width, height: 115)))
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tagField)
        addSubview(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension AddPostFieldCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) { // При наличии текста скрываем placeholder
        if textView.text.count == 0{
            placeholder.isHidden = false
        } else {
            placeholder.isHidden = true
        }
    }
}
