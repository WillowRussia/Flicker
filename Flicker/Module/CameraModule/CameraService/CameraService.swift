//
//  CameraService.swift
//  Flicker
//
//  Created by Илья Востров on 27.10.2024.
//

import AVFoundation

protocol CameraServiceProtocol: AnyObject {
    var captureSession: AVCaptureSession { get set } //Главная сессия
    var output: AVCapturePhotoOutput { get set } // Вывод изображения с камеры
    
    func setupCaptureSession () //Настройка сессии
    func stopSession ( ) // Остановка сессии
    func switchCamera () //Смена камеры
    
}

class CameraService: CameraServiceProtocol {
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    
    var output: AVCapturePhotoOutput = AVCapturePhotoOutput()
    
    private var captureDevice: AVCaptureDevice? // Объект захвата текущей камеры
    
    private var backInput: AVCaptureDeviceInput! //Вход задней камеры
    private var backCamera: AVCaptureDevice? // Объект захвата задней камеры
    private var frontInput: AVCaptureDeviceInput! //Вход фронтальной камеры
    private var frontCamera: AVCaptureDevice? // Объект захвата фронтальной камеры
    private var isBackCamera = true // Текущая камера
    
    private let cameraQueue = DispatchQueue(label: "ru.flicker.CaptureQueue") // Очередь для работы с камерой
    
    func setupCaptureSession() {
        cameraQueue.async { [weak self] in // Асинхоронно
            self?.captureSession.beginConfiguration() //Начинаем конфигурацию
            
            if let isSetPreset = self?.captureSession.canSetSessionPreset(.photo),
            isSetPreset {
                self?.captureSession.sessionPreset = .photo // Устанавливаем формат сеанса захвата - фото
            }
            self?.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true //Расширяем цветовой диапозон
            self?.setInputs()
            self?.setOutputs()
            
            self?.captureSession.commitConfiguration() //Вносит изменения в конфигурацию запущенного сеанса захвата
            self?.captureSession.startRunning() //Запуск сессии
        }
    }
    
    private func setInputs (){ //Настройка входа
        
        backCamera = currentDevice() // Добавляем заднюю камеру
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) // Добавляем фронтальную камеру
        
        guard let backCamera = backCamera, let frontCamera = frontCamera else { return }
        do {
            backInput = try AVCaptureDeviceInput (device: backCamera) // Попытка установить заднюю камеру в качестве точки входа
            guard captureSession.canAddInput(backInput) else { return } // Определяет, можем ли добавить камеру в качестве ввода
            
            frontInput = try AVCaptureDeviceInput (device: frontCamera)//Попытка установить фронтальную камеру в качестве точки входа
            guard captureSession.canAddInput(frontInput) else { return } // Определяет, можно ли добавить входные данные в сеанс
            
            captureSession.addInput(backInput) // По умолчанию в качестве точки входа ставим заднюю камеру
            captureDevice = backCamera //Устанавливаем объект
        }
        catch {
            fatalError("not connected camera")
        }
    }
    private func setOutputs (){//Настройка вывода
        guard captureSession.canAddOutput(output) else { return } //Можем ли установить output в качестве вывода
        output.maxPhotoQualityPrioritization = .balanced //Выбираем сбалансированое качество вывода
        captureSession.addOutput(output) //Добавляем точку вывода
        
        
    }
    
    func stopSession() {
        captureSession.stopRunning() //Останавливаем сессию
        captureSession.removeInput(backInput) //Удаляем точку входа для задней
        captureSession.removeInput(frontInput) //Удаляем точку входа для фронтальной
         isBackCamera = true
    }
    
    func switchCamera() {
        captureSession.beginConfiguration ()
        if isBackCamera {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            captureDevice = frontCamera
            isBackCamera = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            captureDevice = backCamera
            isBackCamera = true
        }
        captureSession.commitConfiguration()
    }
    
    private func currentDevice() -> AVCaptureDevice? { // Настройка задней камеры
        let sessionDevice = AVCaptureDevice.DiscoverySession( deviceTypes: [ .builtInTripleCamera, .builtInDualCamera, .builtInWideAngleCamera, .builtInDualWideCamera],mediaType: .video, position: .back)

        guard let device = sessionDevice.devices.first else { return nil}
        return device
        
    }
    
    
}
