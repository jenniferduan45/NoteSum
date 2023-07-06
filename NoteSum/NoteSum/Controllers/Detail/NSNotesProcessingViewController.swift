//
//  NSNotesProcessingViewController.swift
//  NoteSum
//
//  Created by Jennifer Duan on 4/11/23.
//

import UIKit
import Vision
import Foundation
class NSNotesProcessingViewController: UIViewController {
    
    private let notesProcessingView = NSNotesProcessingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()

        // Do any additional setup after loading the view.
    }
    
    private func setUpView() {
        view.addSubview(notesProcessingView)
        NSLayoutConstraint.activate([
            notesProcessingView.widthAnchor.constraint(equalToConstant: 100),
            notesProcessingView.heightAnchor.constraint(equalToConstant: 100),
            notesProcessingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesProcessingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func processPhoto(_ image : UIImage) -> Optional<String>{
         var ocrText = ""
         let ocrRequest = VNRecognizeTextRequest { (request, error) in
             guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
             let text = observations.compactMap({     $0.topCandidates(1).first?.string     }).joined(separator: ", ")
            
             ocrText += "\n"+text
         }
         ocrRequest.recognitionLevel = .accurate
         ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
         ocrRequest.usesLanguageCorrection = true
        
//         var p = UIImage(named: "text")!
//         guard let cgImage = p.cgImage else { return }
//         let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//         do {
//             try requestHandler.perform([ocrRequest])
//         } catch let error {
//             print(error)
//         }
         var logoImages: [UIImage] = []
         logoImages.append(image)
//         logoImages.append(UIImage(named: "text")!)
//         logoImages.append(UIImage(named: "text1")!)
        
         for p in logoImages {
             guard let cgImage = p.cgImage else { return nil}
             let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
             do {
                 try requestHandler.perform([ocrRequest])
             } catch let error {
                 print(error)
             }
         }
    
         print("OCR output:", ocrText)
         return ocrText
     }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let openAIURL = URL(string: "https://api.openai.com/v1/engines/text-davinci-002/completions")
    var openAIKey: String {
        return "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"
    }
    
    /// DO NOT  TOUCH THIS FUNCTION.
    private func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if (sessionConfig != nil) {
            session = URLSession(configuration: sessionConfig!)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
        let task = session.dataTask(with: request as URLRequest, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!.localizedDescription)")
            } else if data != nil {
                requestData = data
            }
            
            print("Semaphore signalled")
            semaphore.signal()
        })
        task.resume()
        
        // Handle async with semaphores. Max wait of 10 seconds
        let timeout = DispatchTime.now() + .seconds(20)
        print("Waiting for semaphore signal")
        let retVal = semaphore.wait(timeout: timeout)
        print("Done waiting, obtained - \(retVal)")
        return requestData
    }
    
    public func processPrompt(prompt: String) -> Optional<String> {
        /// cURL stuff.
        var request = URLRequest(url: self.openAIURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        
        let httpBody: [String: Any] = [
            "prompt" : prompt,
            /// Adjust this to control the maxiumum amount of tokens OpenAI can respond with. They charge you per token, so be careful.
            "max_tokens" : 1000
            /// You can add more parameters below, but make sure they match the ones in the OpenAI API Reference.
        ]
        
        var httpBodyJson: Data
        
        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            print("Unable to convert to JSON \(error)")
            return nil
        }
        
        request.httpBody = httpBodyJson
        if let requestData = executeRequest(request: request, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            print(jsonStr)
            /// I know there's an error below, but we'll fix it later on in the article, so make sure not to change anything
            let responseHandler = OpenAIResponseHandler()

            return responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].text
            
        }
        
        return nil
    }
}

struct OpenAIResponseHandler {
    func decodeJson(jsonString: String) -> OpenAIResponse? {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(OpenAIResponse.self, from: json)
            return product
            
        } catch {
            print("Error decoding OpenAI API Response")
        }
        
        return nil
    }
}

struct OpenAIResponse: Codable {
    var id: String
    var object: String
    var created: Int
    var model: String
    var choices: [Choice]
}

struct Choice: Codable {
    var text: String
    var index: Int
    var logprobs: String?
    var finish_reason: String
}
