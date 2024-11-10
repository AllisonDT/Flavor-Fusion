//
//  UserManualView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 4/6/24.
//

import SwiftUI
import PDFKit

struct UserManualView: View {
    var body: some View {
        NavigationStack {
            PDFViewer(pdfName: "usermanual")
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("User Manual")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ShareLink(item: pdfURL()!, preview: SharePreview("User Manual", image: Image(systemName: "square.and.arrow.up"))) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
        }
    }
    
    // Helper to get the PDF URL from the bundle
    private func pdfURL() -> URL? {
        Bundle.main.url(forResource: "usermanual", withExtension: "pdf")
    }
}

struct PDFViewer: UIViewRepresentable {
    let pdfName: String
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        if let pdfPath = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: pdfPath)
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // Handle any updates if necessary
    }
}

// Preview Provider for UserManualView
#Preview {
    UserManualView()
}
