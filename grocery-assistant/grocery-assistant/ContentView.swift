//
//  ContentView.swift
//  grocery-assistant
//
//  Created by arachnothrone on 2023-01-13.
//


import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}


struct ContentView: View {
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                } else {
                    Image(systemName: "snow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                }
                
                Button("Camera") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
//                Button("photo") {
//                    self.sourceType = .photoLibrary
//                    self.isImagePickerDisplay.toggle()
//                }.padding()
            }
            .navigationBarTitle("Demo")
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            }
            
        }
    }
}




//import SwiftUI
//import Vision
//import VisionKit
//import Foundation

//class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
//    var recognizedText: Binding<String>
//    var parent: ScanDocumentView
//
//    init(recognizedText: Binding<String>, parent: ScanDocumentView) {
//        self.recognizedText = recognizedText
//        self.parent = parent
//    }
//
//    func documentCameraViewController (_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//        let extractedImages = extractImages(from: scan)
//        let processedText = recognizeText(from: extractedImages)
//        recognizedText.wrappedValue = processedText
//
//        parent.presentationMode.wrappedValue.dismiss()
//    }
//
//    fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
//        var extractedImages = [CGImage]()
//        for index in 0..<scan.pageCount {
//            let extractedImage = scan.imageOfPage(at: index)
//            guard let cgImage = extractedImage.cgImage else { continue }
//
//            extractedImages.append(cgImage)
//        }
//        return extractedImages
//    }
//
//    fileprivate func recognizeText(from images: [CGImage]) -> String {
//        var entireRecognizedText = ""
//        let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
//            guard error == nil else { return }
//
//            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//
//            let maximumRecognitionCandidates = 1
//            for observation in observations {
//                guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
//
//                entireRecognizedText += "\(candidate.string)\n"
//
//            }
//        }
//        recognizeTextRequest.recognitionLevel = .accurate // .fast //.accurate
//
//        for image in images {
//            let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
//
//            try? requestHandler.perform([recognizeTextRequest])
//        }
//
//        return entireRecognizedText
//    }
//
//
//}
//
//struct ScanDocumentView: UIViewControllerRepresentable {
//    @Binding var recognizedText: String
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(recognizedText: $recognizedText, parent: self)
//    }
//
//    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
//        let documentViewController = VNDocumentCameraViewController()
//        documentViewController.delegate = context.coordinator
//        return documentViewController
//    }
//
//    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
//    }
//
//}
//
//struct ContentView: View {
//    @State private var recognizedText = "Start scanning."
//    @State private var showingScanningView = false
//    @State private var totalSum: Float = 0.0
//    @State private var itemsList: [Float] = []
//
//    typealias UIViewControllerType = VNDocumentCameraViewController
//
//    var body: some View {
//        //InfoNavigationView {
//            VStack {
//                ScrollView {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 20, style: .continuous)
//                            .fill(Color.gray.opacity(0.2))
//
////                        Text(recognizedText)
////                            .padding()
//                        Text("List: \(makeStringFromList(lst: itemsList))")
//                    }
//                    .padding()
//                }
//
//                Spacer()
//
//                Text("Total: \(getValue(fullTextString: recognizedText))").font(.largeTitle)
//
//                Spacer()
//
//                HStack {
////                    Button(action: updateList(lst: &itemsList)) {
////                        Text("Remove Last")
////                    }
//                    Spacer()
//                    Button(action: {
//                        self.showingScanningView = true
//                    }) {
//                        Text("Start Scanning")
//                    }
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Capsule().fill(Color.blue))
//                }.padding()
//
//            }.sheet(isPresented: $showingScanningView) {
//                ScanDocumentView(recognizedText: self.$recognizedText)
//            }
//        //}.navigationBarTite("Grocery List")
//    }
//
//    func getValue (fullTextString: String) -> Float {
//        var res: Float = 0.0
//        print("received text: \(fullTextString)")
//
////        let stringfull = "asdffd 9.43 sdfsdf 4.332 ddf"
////
////        let decimalRegex = "[0-9]+(\\.[0-9]+)?"
////        let decimal = stringfull.matches(for: decimalRegex)
////        print(decimal)
//
////        let string = "882843 0 000008 828439 OXO SOFTWORKS 6PC SINKWARE SET Piece Set Include • Conductable Nose Stip Giap 2 Dish Scrub Heals •Interchangeable Relib 2 Dish Brush Heads • Durablic Notion Bavates Soap Dapensing Ha 9.97"
//        let decimalRegex = "[0-9]+(\\.[0-9]+)?"
//        let range = NSRange(location: 0, length: fullTextString.utf16.count)
//        let regex = try! NSRegularExpression(pattern: decimalRegex)
//        let decimal = regex.matches(in: fullTextString, options: [], range: range).compactMap {
//            Range($0.range, in: fullTextString)
//        }.map { String(fullTextString[$0]) }
//
//        print(decimal)
//
//        var extractedPrice = Float(decimal.last ?? "0.0") ?? 0.0
//        print("Extracted price: \(extractedPrice)")
//
//        if (extractedPrice > 99.0) {
//            extractedPrice = 0.0
//        }
//
//        res = self.totalSum + extractedPrice
//        self.totalSum += extractedPrice
//        //itemsList.append(extractedPrice) Modifying state during view update, this will cause undefined behavior.
//
//        return res
//    }
//
//    func makeStringFromList (lst: [Float]) -> String {
//        //let string = lst.map(String.init).joined(separator: ", ")
//        let strings = lst.map { String($0) }
//        let string = strings.joined(separator: ", ")
//        return string
//    }
//
//    func updateList (lst: inout [Float]) {
//        lst.removeLast()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
