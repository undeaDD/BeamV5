import UIKit
import AVFoundation
import FloatingPanel

class CameraView: UIViewController {
    
    @IBOutlet weak var sessionView: UIView!
    var session = AVCaptureSession()
    var listPanel: FloatingPanelController?

    override func viewDidLoad() {
        super.viewDidLoad()
        session.sessionPreset = .high
        guard let camera = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: camera),
            session.canAddInput(input) else {
            fatalError("something went wrong :F")
        }
        
        session.addInput(input)
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = sessionView.bounds
        layer.videoGravity = .resizeAspectFill
        layer.connection?.videoOrientation = .portrait
        sessionView.layer.addSublayer(layer)
        session.startRunning()
    }
    
    @IBAction func buttonPressed() {
        if listPanel != nil {
            listPanel?.hide(animated: true)
            listPanel = nil
        } else {
            listPanel = FloatingPanelController()
            if let contentView = UIStoryboard(name: "ListView", bundle: .main).instantiateInitialViewController() as? ListView {
                listPanel?.surfaceView.backgroundColor = .clear
                listPanel?.surfaceView.cornerRadius = 16.0
                listPanel?.isRemovalInteractionEnabled = true
                listPanel?.surfaceView.containerMargins = .init(top: 0.0, left: 8.0, bottom: 16.0, right: 8.0)
                listPanel?.backdropView.dismissalTapGestureRecognizer.isEnabled = true
                listPanel?.set(contentViewController: contentView)
                listPanel?.track(scrollView: contentView.collectionView)
                listPanel?.addPanel(toParent: self)
            }
        }
    }

}
