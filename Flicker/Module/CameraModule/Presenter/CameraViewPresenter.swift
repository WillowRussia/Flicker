//
//  CameraViewPresenter.swift
//  Flicker
//
//  Created by Илья Востров on 18.10.2024.
//

import UIKit

protocol CameraViewPresenterProtocol: AnyObject {
    
    init (view: CameraViewProtocol, cameraService: CameraServiceProtocol)
    var photos: [UIImage] {get set}
    var cameraService: CameraServiceProtocol {get set}
    var closeViewAction: UIAction? { get set }
    var switchCameraAction: UIAction? { get set }
    
    func deletePhoto(index: Int)
    
}

class CameraViewPresenter: CameraViewPresenterProtocol {

    private weak var view: CameraViewProtocol?
    
    var cameraService: CameraServiceProtocol
    
    var photos: [UIImage] = []
    
    lazy var closeViewAction: UIAction? = UIAction{ [weak self] _ in
        self?.closeView()
    }
    
    lazy var switchCameraAction: UIAction? = UIAction{ [weak self] _ in
        self?.cameraService.switchCamera()
    }
    
    func deletePhoto(index: Int) {
        photos.remove(at: index)
    }
    
    @objc func closeView() {
        NotificationCenter.default.post(name: .goToMain, object: nil)
        cameraService.stopSession()
    }
    
    required init(view: CameraViewProtocol, cameraService: CameraServiceProtocol) {
        self.view = view
        self.cameraService = cameraService
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeView), name: .dismissCameraView, object: nil)
    }
    
}
