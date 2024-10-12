//
//  PhotoView.swift
//  Flicker
//
//  Created by Илья Востров on 12.10.2024.
//

import UIKit

protocol PhotoViewProtocol: AnyObject {
    var closeButtonAction: UIAction {get set}
}

class PhotoView: UIViewController, PhotoViewProtocol {
    
    var comletion: (() -> ())?
    
    var presenter: PhotoViewPresenterProtocol!
    
    internal lazy var closeButtonAction = UIAction { [weak self] _ in
        self?.comletion?()
    }
    
    private lazy var closeButton: UIButton = {
        $0.setBackgroundImage(.closeIcon, for: .normal)
        return $0
    }(UIButton(frame: CGRect(x: view.bounds.width - 60, y: 60, width: 25, height: 25), primaryAction: closeButtonAction))
    
    private lazy var scrollView: UIScrollView = {
        $0.delegate = self
        $0.maximumZoomScale = 10
        $0.backgroundColor = .black
        $0.addSubview(image)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.addGestureRecognizer(tapGesture)
        return $0
    } (UIScrollView(frame: view.bounds))
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        $0.numberOfTapsRequired = 2
        $0.addTarget(self, action: #selector(zoomImage))
        return $0
    } (UITapGestureRecognizer())
    
    private lazy var image: UIImageView = {
        $0.image = presenter.image
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
    return $0
    } (UIImageView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        setImageSize()

        
    }
    
    @objc func zoomImage() { // Определяем текущий зум и меняем его в зависимости от значения
        UIView.animate(withDuration: 0.2) { [weak self] in
            if self?.scrollView.zoomScale ?? 1 > 1 {
                self?.scrollView.zoomScale = 1
            } else {
                self?.scrollView.zoomScale = 2
            }
        }
    }
    
    private func setImageSize() {
        let imageSize = image.image?.size //Получаем размер
        let imageHeight = imageSize?.height ?? 0
        let imageWidth = imageSize?.width ?? 0
        
        let ratio = imageHeight/imageWidth // Вычислаем соотношение сторон
        
        image.frame.size = CGSize(width: view.frame.width,
                                  height: view.frame.width * ratio) // Задаем размеры
        
        image.center = view.center
    }
   
}

extension PhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { // Задаем объект над которым будем скролиться
        return image
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > view.frame.height { // Когда размер контента будет больше высоты экрана
            image.center.y = scrollView.contentSize.height / 2
        }
        else {
            image.center.y = view.center.y
        }
    }
}
