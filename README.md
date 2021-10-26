//
//  CameraViewController.swift
//  PedalNature
//
//  Created by Volkan on 26.09.2021.
//

import UIKit

import AVFoundation

/// Create Post for Share
/// Reached from Activity Record View

final class CameraViewController: UIViewController {

	private let session = AVCaptureSession()
	private var camera : AVCaptureDevice?
	private var camera : AVCaptureVideoPreviewLayer?
	private var cameraCaptureOutput : AVCapturePhotoOutput?
	
	private let takePictureButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .label
        button.isHidden = true
        return button
    }()
	
	 override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(takePictureButton)
		initializeCaptureSession()
		takePictureButton.addTarget(self,
                           action: #selector(takePicture), for: .touchUpInside)
	}
	
	 override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cameraButtonSize = 100
        takePictureButton.frame = CGRect(x: view.width/2,
                               y: view.height-120,
                               width: Int(1.5*Double(cameraButtonSize),
                               height: cameraButtonSize)
	}
	private func displayedCapturedPhoto(capturedPhoto: UIImage){
		let vc = PicturePreviewViewController()
        vc.modalPresentationStyle = .fullScreen
		vc.image = capturedPhoto
        self.navigationController?.pushViewController(vc, animated: true)
		
	}
	
	private func initializeCaptureSession(){
	
		session.sessionPreset = AVCaptureSessionPresetMedium
		camera = AVCaptureDevice.default(withMediaType: AVMediaTypeVideo)
		
		do{
			let cameraCaptureInput = try AVCaptureDeviceInput(device : camera!)
			cameraCaptureOutput = AVCapturePhotoOutput()
			
			session.addInput(cameraCaptureInput)
			session.addInput(cameraCaptureOutput)
		} catch{
			print(error.localizedDescription)
		}
		
		cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
		cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
		cameraPreviewLayer?.frame = view.bounds
		cameraPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
		
		view.layer.insertSublayer(cameraPreviewLayer!, at:0)
		session.startRunning()
	}
	
	@objc func takePicture(){
		let settings = AVCapturePhotoSettings
		setings.flashMode = .auto
		cameraCaptureOutput?.capturePhoto(with: settings, delegate:self)
	}
}

extension CameraViewController: AVCapturePhotoCaptureDelegate{

	 func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
	 
		if let error = error{
			print(error.localizedDescription)
		}else {
            photoData = photo.fileDataRepresentation()
			
			if let finalImage = UImage(data: photoData){
				displayedCapturedPhoto(capturedPhoto: finalImage)
				
			}
			
		}
		
	 }
}
