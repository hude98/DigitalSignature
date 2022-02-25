//
//  PDFSelectionViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 16/02/2022.
//

import Foundation
import UIKit
import PDFKit

class PDFSelectionViewController: UIViewController, PDFViewDelegate {
    let urlFile: URL
    var pdfView: PDFView!
    
    init(with url: URL) {
        self.urlFile = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: urlFile)
        pdfView.delegate = self
        pdfView.isUserInteractionEnabled = false
    }
    
    var startPoint: CGPoint?
    
    let rectShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        return shapeLayer
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = nil
        rectShapeLayer.removeFromSuperlayer()
        guard let touch = touches.first else { return }

        startPoint = touch.location(in: pdfView)

        // you might want to initialize whatever you need to begin showing selected rectangle below, e.g.

        rectShapeLayer.path = nil

        pdfView.layer.addSublayer(rectShapeLayer)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let startPoint = startPoint else { return }

        let currentPoint: CGPoint

        if let predicted = event?.predictedTouches(for: touch), let lastPoint = predicted.last {
            currentPoint = lastPoint.location(in: pdfView)
        } else {
            currentPoint = touch.location(in: pdfView)
        }

        let frame = rect(from: startPoint, to: currentPoint)

        // you might do something with `frame`, e.g. show bounding box

        rectShapeLayer.path = UIBezierPath(rect: frame).cgPath
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let startPoint = startPoint else { return }
//
//        let currentPoint = touch.location(in: pdfView)
//        let frame = rect(from: startPoint, to: currentPoint)

        // you might do something with `frame`, e.g. remove bounding box but take snapshot of selected `CGRect`

        
        // do something with this `image`
    }

    private func rect(from: CGPoint, to: CGPoint) -> CGRect {
        return CGRect(x: min(from.x, to.x),
               y: min(from.y, to.y),
               width: abs(to.x - from.x),
               height: abs(to.y - from.y))
    }
    
}



