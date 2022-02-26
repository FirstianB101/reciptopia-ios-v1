//
//  BackCameraView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/22.
//

import AVFoundation
import UIKit

public final class BackCameraView: NiblessView {
  
  // MARK: - Properties
  private var captureSession: AVCaptureSession!
  private var stillImageOutput: AVCapturePhotoOutput!
  private var previewLayer: AVCaptureVideoPreviewLayer!
  private var backCamera: AVCaptureDevice!
  private var isAlreadyPresented: Bool = false
  
  public weak var delegate: AVCapturePhotoCaptureDelegate!
  
  // MARK: - Methods
  public override func didMoveToWindow() {
    super.didMoveToWindow()
    guard !isAlreadyPresented else { return }
    backgroundColor = .lightGray
    getBackCamera()
    configurePreviewView()
    isAlreadyPresented = true
  }
  
  private func getBackCamera() {
    guard let backCamera = AVCaptureDevice.default(for: .video) else {
      print("Fail to call back camera.")
      return
    }
    self.backCamera = backCamera
  }
  
  private func configurePreviewView() {
    guard let backCamera = backCamera else {
      print("Fail to assign back camera.")
      return
    }
    
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = .medium
    
    do {
      let input = try AVCaptureDeviceInput(device: backCamera)
      stillImageOutput = AVCapturePhotoOutput()
      
      if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
        captureSession.addInput(input)
        captureSession.addOutput(stillImageOutput)
        
        setUpLivePreview()
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func setUpLivePreview() {
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    previewLayer.videoGravity = .resizeAspectFill
    previewLayer.connection?.videoOrientation = .portrait
    self.layer.addSublayer(previewLayer)
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.captureSession.startRunning()
      DispatchQueue.main.async {
        self.previewLayer.frame = self.bounds
      }
    }
  }
  
  @objc public func takePhoto() {
    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    stillImageOutput.capturePhoto(with: settings, delegate: delegate)
  }
  
  @objc public func toggleFlash() {
    if backCamera.hasTorch {
      do {
        try backCamera.lockForConfiguration()
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        backCamera.torchMode = backCamera.isTorchActive ? .off : .on
        backCamera.unlockForConfiguration()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
