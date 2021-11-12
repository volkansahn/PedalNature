//
//  CameraViewController.swift
//  PedalNature
//
//  Created by Volkan on 26.09.2021.
//
import UIKit
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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80,height: 80))
        button.setImage(UIImage(systemName: "record.circle"), for: [])
        button.tintColor = UIColor.red
        button.isHidden = true
        return button
    }()
    
    private let changeCameraButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera.rotate.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var cameraView = UIView()

    private lazy var imagePickerController : UIImagePickerController = {
      let imagePickers = UIImagePickerController()
      imagePickers.mediaTypes = ["public.image", "public.movie"]
      imagePickers.sourceType = .camera
     
      return imagePickers
    }()

    public var imageList = [RouteImage]()
    
    let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D()
    var captureModeControl = UISegmentedControl()
    
    var selectionTitle = "Photo"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(cameraView)
        cameraView.addSubview(imagePickerController.view)

        view.addSubview(takePictureButton)
        view.addSubview(changeCameraButton)
        view.addSubview(recordVideoButton)
        
        captureModeControl = UISegmentedControl (items: ["Photo","Video"])
        
        // Make second segment selected
        captureModeControl.selectedSegmentIndex = 0
        
        //Change text color of UISegmentedControl
        captureModeControl.tintColor = UIColor.yellow
        
        //Change UISegmentedControl background colour
        captureModeControl.backgroundColor = UIColor.black
        view.addSubview(captureModeControl)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.showsCameraControls = false
        captureModeControl.addTarget(self, action: #selector(handleSelection), for: .valueChanged)
        
        takePictureButton.addTarget(self,
                                    action: #selector(takePicture), for: .touchUpInside)
        recordVideoButton.addTarget(self,
                                    action: #selector(recordVideo), for: .touchUpInside)
        changeCameraButton.addTarget(self,
                                    action: #selector(changeCamera), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        takePictureButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 80)
        recordVideoButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 80)

        captureModeControl.frame = CGRect(x: view.width/2 - takePictureButton.width,
                                          y: takePictureButton.top-70,
                                          width: 2*takePictureButton.width,
                                          height: 50)
        
        cameraView.frame = CGRect(x: 5,
                                          y: view.safeAreaInsets.top + 5,
                                          width: view.width - 10,
                                          height: 200)
        imagePickerController.view.frame = cameraView.bounds

        changeCameraButton.frame = CGRect(x: view.width-takePictureButton.width,
                                          y: takePictureButton.top+takePictureButton.width/4,
                                          width: takePictureButton.width/2 + 10,
                                          height: takePictureButton.width/2)
        
    }

     @objc func takePicture(){
         if UIImagePickerController.isSourceTypeAvailable(.camera){
             
             imagePickerController.cameraCaptureMode = UIImagePickerController.CameraCaptureMode.photo
             imagePickerController.takePicture()
         }else{
             print("Error on taking Picture")
         }
        
    }
    
    @objc func changeCamera(){
        if imagePickerController.cameraDevice == UIImagePickerController.CameraDevice.rear{
            imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.front
      }else{
          imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.rear
      }
    }

    @objc func handleSelection(){
        selectionTitle = captureModeControl.titleForSegment(at: captureModeControl.selectedSegmentIndex)!
        if selectionTitle == "Photo"{
            recordVideoButton.isEnabled = false
            recordVideoButton.isHidden = true
            takePictureButton.isEnabled = true
            takePictureButton.isHidden = false
        }else{
            takePictureButton.isHidden = true
            takePictureButton.isEnabled = false
            recordVideoButton.isEnabled = true
            recordVideoButton.isHidden = false
        }

    }
    
    @objc func recordVideo(){
      if recordVideoButton.currentImage == UIImage(systemName: "record.circle"){
          if UIImagePickerController.isSourceTypeAvailable(.camera){
              imagePickerController.cameraCaptureMode = UIImagePickerController.CameraCaptureMode.video
              imagePickerController.videoMaximumDuration = 30
              imagePickerController.startVideoCapture()
          }else{
              print("Error on taking Picture")
          }
      }else{
        imagePickerController.stopVideoCapture()
      }
      

    }

    
}

extension CameraViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        (viewController as? MapViewController)?.cameraReturn = true

    }
}

extension CameraViewController: UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true, completion: {})
        self.dismiss(animated:true, completion: {})

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if selectionTitle == "Photo"{
          guard let image = info[.originalImage] as? UIImage else {
              print("No image found")
              return
          }
          let routeImage = RouteImage(image: image, videoURL: nil, coordinate: self.location)
          imageList.append(routeImage)
          
          let vc = MapViewController()
          vc.listOfContent.append(routeImage)
          
          let actionSheet = UIAlertController(title: "Save Photo?", message: "Would you like to save image to library ?", preferredStyle: .actionSheet)
          actionSheet.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
              UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
              
          }))
          actionSheet.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
              picker.dismiss(animated: true)
          }))
          self.present(actionSheet,animated: true)
          
      }else{
        guard let videoURL = info[.mediaURL] as? URL else {
            print("No video found")
            return
        }
          
          let routeImage = RouteImage(image: nil, videoURL: videoURL, coordinate: self.location)
          self.imageList.append(routeImage)
          let actionSheet = UIAlertController(title: "Save Video?", message: "Would you like to save video to library ?", preferredStyle: .actionSheet)
          actionSheet.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
              //UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
              
          }))
          actionSheet.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
              picker.dismiss(animated: true)
          }))
          self.present(actionSheet,animated: true)
          
      }
      
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
