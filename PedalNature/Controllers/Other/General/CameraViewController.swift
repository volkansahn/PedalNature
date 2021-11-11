//
//  CameraViewController.swift
//  PedalNature
//
//  Created by Volkan on 26.09.2021.
//
import UIKit
import AVFoundation
import CoreLocation
import Photos

/// Create Post for Share
/// Reached from Activity Record View
final class CameraViewController: UIViewController {
    
    private let takePictureButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80,height: 80))
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.isHidden = false
        return button
    }()
    
    private let recordVideoButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100,height: 100))
        button.setImage(UIImage(systemName: "record.circle"), for: [])
        button.tintColor = UIColor.red
        button.backgroundColor = UIColor.white
        button.isHidden = true
        return button
    }()
    
    private let cameraUnavailableLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Camera Unavailable"
        return label
    }()
    
    private let changeCameraButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera.rotate.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var captureModeControl = UISegmentedControl()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var previewView = UIView()
    
    var capturedImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
        
    public var imageList = [RouteImage]()
    
    let locationManager = CLLocationManager()
    var location = CLLocation()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium

        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }

        do {
            let deviceInput = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(deviceInput) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(deviceInput)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        stillImageOutput = AVCapturePhotoOutput()

       
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(previewView)
        view.addSubview(takePictureButton)
        view.addSubview(changeCameraButton)
        view.addSubview(recordVideoButton)
        view.addSubview(capturedImageView)
        captureModeControl = UISegmentedControl (items: ["Photo","Video"])
        
        // Make second segment selected
        captureModeControl.selectedSegmentIndex = 0
        
        //Change text color of UISegmentedControl
        captureModeControl.tintColor = UIColor.yellow
        
        //Change UISegmentedControl background colour
        captureModeControl.backgroundColor = UIColor.black
        view.addSubview(captureModeControl)
        
        captureModeControl.addTarget(self, action: #selector(handleSelection), for: .valueChanged)
        
        takePictureButton.addTarget(self,
                                    action: #selector(takePicture), for: .touchUpInside)
        recordVideoButton.addTarget(self,
                                    action: #selector(recordVideo), for: .touchUpInside)
        changeCameraButton.addTarget(self,
                                    action: #selector(changeCamera), for: .touchUpInside)
        
        // Disable the UI. Enable the UI later, if and only if the session starts running.
        takePictureButton.isEnabled = false
        changeCameraButton.isEnabled = false
        captureModeControl.isEnabled = false
        recordVideoButton.isEnabled = false
        navigationController?.delegate = self

        
        // Request location authorization so photos and videos can be tagged with their location.
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewView.frame = view.bounds
        takePictureButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 80)
        recordVideoButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 80)

        captureModeControl.frame = CGRect(x: view.width/2 - takePictureButton.width,
                                          y: takePictureButton.top-70,
                                          width: 2*takePictureButton.width,
                                          height: 50)
        
        changeCameraButton.frame = CGRect(x: view.width-takePictureButton.width,
                                          y: takePictureButton.top+takePictureButton.width/4,
                                          width: takePictureButton.width/2 + 10,
                                          height: takePictureButton.width/2)
        cameraUnavailableLabel.center = view.center
        capturedImageView.frame = view.bounds
    }

    @objc func takePicture(){
        /*
         Retrieve the video preview layer's video orientation on the main queue before
         entering the session queue. Do this to ensure that UI elements are accessed on
         the main thread and session configuration is done on the session queue.
         */
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    @objc func changeCamera(){
        changeCameraButton.isEnabled = false
        takePictureButton.isEnabled = false
        recordVideoButton.isEnabled = false
        

    }

    @objc func handleSelection(){
        let title = captureModeControl.titleForSegment(at: captureModeControl.selectedSegmentIndex)
        if title == "Photo"{
            recordVideoButton.isEnabled = false
            recordVideoButton.isHidden = true
            takePictureButton.isEnabled = true

        }else{
            takePictureButton.isHidden = true
            takePictureButton.isEnabled = false
            recordVideoButton.isEnabled = true}

    }
    
    @objc func recordVideo(){

    }
    
}

extension CameraViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        var content = (viewController as? MapViewController)?.listOfContent
        if content != nil{
            content!.append(contentsOf: imageList)
            (viewController as? MapViewController)?.listOfContent = content!
        }
        (viewController as? MapViewController)?.cameraReturn = true

    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        capturedImageView.isHidden = false
        self.captureSession.stopRunning()
        let image = UIImage(data: imageData)
        capturedImageView.image = image
        let alertController = UIAlertController(title: "Photo Capture", message: "Your Photo Captured", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            self.capturedImageView.isHidden = true

            self.captureSession.startRunning()
        }))
        self.present(alertController, animated: true, completion: nil)

        
    }
}
