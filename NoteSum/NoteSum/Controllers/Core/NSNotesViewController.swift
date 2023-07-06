//
//  NSNotesViewController.swift
//  NoteSum
//
//  Created by Yuxuan Wu on 3/19/23.
//

// It's a KNOWN ISSUE that the red flower image CAN'T be selected using the simulator.

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class NSNotesViewController: UIViewController, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private var currentUid = Auth.auth().currentUser!.uid
    
    private let notesCreateView = NSNotesCreateView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notes"
        setUpCreateView()
        // Do any additional setup after loading the view.
    }

    private func setUpCreateView() {
        view.addSubview(notesCreateView)
        notesCreateView.cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        notesCreateView.photoButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        NSLayoutConstraint.activate([
            notesCreateView.heightAnchor.constraint(equalToConstant: 300),
            notesCreateView.widthAnchor.constraint(equalToConstant: 300),
            notesCreateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesCreateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // Take a picture with camera
    @objc func openCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let nextVC = NSNotesProcessingViewController()
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // Print out the image size as a test
        print(image.size)
        let ocrText = nextVC.processPhoto(image)!
        let summary = nextVC.processPrompt(prompt: "Summarize this text in 50 words or fewer:" + ocrText)!
        let ti = nextVC.processPrompt(prompt: "Give me a summary title (the title must be less than 5 words) for the following sentance:" + summary)!
        print(ti, "Summary for ocr text:", summary)
        
        // Upload to Firebase Storage
        self.uploadImageToFirebaseStorage(image: image) { result in
            switch result {
            case .success(let url):
                print("Image url: \(url.absoluteString)")
                let id = "\(self.currentUid)-\(UUID().uuidString)"
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                let currentDate = Date()
                let dateString = formatter.string(from: currentDate)
                let data: [String: Any] = [
                    "id": id,
                    "summary": summary,
                    "title": ti,
                    "date": dateString,
                    "url": url.absoluteString,
                    "user_id": self.currentUid
                ]
                self.uploadDataToFirebaseFirestore(collection: "notes", documentId: id, data: data) { result in
                    switch result {
                    case .success(let documentId):
                        print("Data uploaded successfully with document ID: \(documentId)")
                        // Jump to the history detail view controller
                        let record = NSDoc(id: data["id"] as! String, title: data["title"] as! String, date: data["date"] as! String, url: data["url"] as! String, summary: data["summary"] as! String)
                        let viewModel = NSHistoryDetailViewViewModel(doc: record)
                        let detailVC = NSHistoryDetailViewController(viewModel: viewModel)
                        detailVC.navigationController?.navigationItem.largeTitleDisplayMode = .never
                        self.navigationController?.pushViewController(detailVC, animated: true)
        //                self.present(nextVC, animated: true)
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        print("Error uploading data: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Failed to upload image: \(error.localizedDescription)")
            }
        }
    }

    // Select a photo from library
    @objc func selectPhoto() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // Selection limit. Set to 0 for unlimited.
        configuration.filter = .images // the types of media that can be get.
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        // Instantiate the next view controller and process the selected images
        let nextVC = NSNotesProcessingViewController()
        
        for result in results {
            // Get the UIImage representation of the selected asset
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let image = image as? UIImage else { return }
                print("Selected image: \(image)")

                // Upload to Firebase Storage
                let ocrText = nextVC.processPhoto(image)!
                let summary = nextVC.processPrompt(prompt: "Summarize this text in 50 words or fewer:" + ocrText)!
                let ti = nextVC.processPrompt(prompt: "Give me a summary title (the title must be less than 5 words) for the following sentance:" + summary)!
                print(ti, "Summary for ocr text:", summary)
                self.uploadImageToFirebaseStorage(image: image) { result in
                    switch result {
                    case .success(let url):
                        print("Image url: \(url.absoluteString)")
                        let id = "\(self.currentUid)-\(UUID().uuidString)"
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let currentDate = Date()
                        let dateString = formatter.string(from: currentDate)
                        let data: [String: Any] = [
                            "id": id,
                            "summary": summary,
                            "title": ti,
                            "date": dateString,
                            "url": url.absoluteString,
                            "user_id": self.currentUid
                        ]
                        self.uploadDataToFirebaseFirestore(collection: "notes", documentId: id, data: data) { result in
                            switch result {
                            case .success(let documentId):
                                print("Data uploaded successfully with document ID: \(documentId)")
                                // Jump to the history detail view controller
                                let record = NSDoc(id: data["id"] as! String, title: data["title"] as! String, date: data["date"] as! String, url: data["url"] as! String, summary: data["summary"] as! String)
                                let viewModel = NSHistoryDetailViewViewModel(doc: record)
                                let detailVC = NSHistoryDetailViewController(viewModel: viewModel)
                                detailVC.navigationController?.navigationItem.largeTitleDisplayMode = .never
                                self.navigationController?.pushViewController(detailVC, animated: true)
        //                        self.present(nextVC, animated: true)
                            case .failure(let error):
                                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                print("Error uploading data: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        print("Failed to upload image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func pickerDidCancel(_ picker: PHPickerViewController) {
        dismiss(animated: true)
    }
    
    // Upload the image to Firebase Storage
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let imagePath = "images/\(currentUid)/\(UUID().uuidString).jpg"
        print("Image path: \(imagePath)")
        let storageRef = Storage.storage().reference().child(imagePath)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "notesum-489d3.appspot.com", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
                    return
        }
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                completion(.failure(error ?? NSError(domain: "notesum-489d3.appspot.com", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred when uploading image to storage"])))
                            return
            }
            print("Metadata: \(metadata)")
            storageRef.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error ?? NSError(domain: "notesum-489d3.appspot.com", code: 400, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred when fetching download url"])))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    // Upload the data to Firebase Firestore
    func uploadDataToFirebaseFirestore(collection: String, documentId: String, data: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection(collection).document(documentId)
        documentRef.setData(data) { error in
            if let error = error {
                print("Error fetching notes: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(documentId))
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
