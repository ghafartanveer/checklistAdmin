//
//  HistoryPdfGeneratorViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 05/07/2021.
//

import UIKit
import WebKit

import PDFKit
class HistoryPdfGeneratorViewController: BaseViewController, TopBarDelegate, WKNavigationDelegate {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageCountLbl: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var containerLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var containerTrailConst: NSLayoutConstraint!
    
    //MARK: - Var& Objects
    let imageLogo = UIImage(named: "login_logo")
    var pdfView = PDFView()
    var lable = UILabel()
    
    var numberOfPages = 0
    var pageNumber = 0
    
    var isNext = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // webView.navigationDelegate = self
        pdfView.backgroundColor = .clear
        
        pdfView = PDFView(frame: self.containerView.bounds)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let container = self.mainContainer{
            container.delegate = self
            
        }
        self.createPDF()
        togleIsNext()
    }
        

    func pageIndex(page: PDFPage) -> Int? {
        guard let pdfDocument = pdfView.document else { return nil }
        
        return pdfDocument.index(for: page)
    }
    
    //MARK: - Functions
    func actionBack() {
        if isNext {
            togleIsNext()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func createPDF() {
        
        let text = getHistoryDetails()
        
        let html = "\(text)"
        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        
        // 2. Assign print formatter to UIPrintPageRenderer
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 20, dy: 80)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        
        // 5. Save PDF file
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ChecklistReport").appendingPathExtension("pdf")
        else { fatalError("Destination URL not created") }
        //{ self.showAlertView(message: PopupMessages.pdfCreatedSuccess) }
        pdfData.write(toFile: "\(documentsPath)/ChecklistReport.pdf", atomically: true)
        
        drawImageOnPDF(path: "\(documentsPath)/ChecklistReport.pdf")
        
        openInpdfKit(path:"\(documentsPath)/ChecklistReport.pdf")
        //loadPDFInWebVie(filename: "ChecklistReport.pdf")
    }
    
    func openInpdfKit(path: String) {
        
        let url = URL(fileURLWithPath: path)
        pdfView.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.interPageSpacing: 20])
        
        pdfView.document = PDFDocument(url: url)
        pdfView.displayDirection = .horizontal
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.maxScaleFactor = 4.0
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.backgroundColor = .clear
        pdfView.tintColor = .clear
        pdfView.document?.pageCount
        self.containerView.addSubview(pdfView)
    }
    
    func loadPDFInWebVie(filename: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent(filename)
        let urlRequest = URLRequest(url: url)
        pdfView.usePageViewController(true)

        webView.load(urlRequest)
    }
    
    func getHistoryDetails() -> String {
        
        var text = """
<h1>Technician completed Task</h1>
   
<br>

<table style="width:  100%; border-collapse: collapse;">
    <thead style="border-top: 1px solid black; border-bottom: 1px solid black;">
        <tr>
            <th style="text-align: left; font-weight: 600;">Tech Name</th>
            <th style="text-align: left; font-weight: 600;">Checklist Name</th>
            <th style="text-align: left; font-weight: 600;">Check In</th>
            <th style="text-align: left; font-weight: 600;">Check Out</th>
        </tr>
    </thead>
    <tbody style="border-bottom: 1px solid black;">
"""

        for record in pdfRecordsList {
            
            let  name = (record.technician?.firstName ?? "") + " " + (record.technician?.lastName ?? "")
            
            let catName = record.categoryName ?? ""
            let checkIn = record.activity?.checkIn ?? ""
            var checkOut = record.activity?.checkOut ?? ""
            if checkOut.isEmpty {
                checkOut = "N/A"
            }
            
            text = text + """
 <tr>
            <td>\(name)</td>
            <td>\(catName)</td>
            <td>\(checkIn)</td>
            <td>\(checkOut)</td>
        </tr>
 """
        }
        
        text = text + """
            </tbody>
            </table>
            """
        return text
    }
    
    func drawImageOnPDF(path: String) {
        
        // Get existing Pdf reference
        let pdf = CGPDFDocument(NSURL(fileURLWithPath: path))
        // Get page count of pdf, so we can loop through pages and draw them accordingly
        let pageCount = pdf?.numberOfPages
        // Write to file
        UIGraphicsBeginPDFContextToFile(path, CGRect.zero, nil)
        // Write to data
        //var data = NSMutableData()
        //UIGraphicsBeginPDFContextToData(data, CGRectZero, nil)
        
        for index in 1...pageCount! {
            print(index)
            let page =  pdf?.page(at: index)
            
            let pageFrame = page?.getBoxRect(.mediaBox)
            
            
            UIGraphicsBeginPDFPageWithInfo(pageFrame!, nil)
            
            let ctx = UIGraphicsGetCurrentContext()
            
            // Draw existing page
            ctx?.saveGState()
            
            ctx?.scaleBy(x: 1, y: -1)
            
            ctx?.translateBy(x: 0, y: -pageFrame!.size.height)
            //CGContextTranslateCTM(ctx, 0, -pageFrame.size.height);
            ctx?.drawPDFPage(page!)
            ctx?.restoreGState()
            
            // Draw image on top of page
            //let image = signatureImage
            if index == 1 {
            imageLogo!.draw(in: CGRect(x: 455.2, y: 40, width: 95, height: 65))
            }
            // Draw red box on top of page
//            UIColor.red.set()
//            UIRectFill(CGRect(x: 20, y: 20, width: 100, height: 100));
            lable.text = "Page " + String(index)
            pageCountLbl.text = "1 OF " + String(index)
            numberOfPages = index
            lable.drawText(in: CGRect(x: 595.2/2, y: 750.0, width: 60, height: 30))
        }
        UIGraphicsEndPDFContext()
    }
    
    func togleIsNext() {
        if !isNext {
            isNext = true
            bottomViewHeight.constant = 0
            bottomView.isHidden = true
            containerLeadingConst.constant = 10
            containerTrailConst.constant = 10
            containerView.isUserInteractionEnabled = true
            containerView.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: self.view.frame.height)
            pdfView.frame = containerView.bounds
            pdfView.layoutIfNeeded()
            pdfView.reloadInputViews()

            
        } else {
            isNext = false
            bottomViewHeight.constant = 80
            bottomView.isHidden = false
            containerLeadingConst.constant = 50
            containerTrailConst.constant = 50
            containerView.isUserInteractionEnabled = false
            containerView.frame = CGRect(x: 60, y: 10, width: self.view.frame.width - 120, height: self.view.frame.height - 80)
            pdfView.frame = containerView.bounds
            pdfView.layoutIfNeeded()
            pdfView.reloadInputViews()
            //self.viewWillAppear(true)
           // self.viewWillLayoutSubviews()
            pageCountLbl.text = "1 OF " + String(numberOfPages)
            
        }
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        openInpdfKit(path:"\(documentsPath)/ChecklistReport.pdf")
    }
    
    @IBAction func previousPage(_ sender: Any) {
        //pdfView.canGoForward = true
        pdfView.goToNextPage(Any?.self)
        pageCountLbl.text = String(pdfView.currentPage!.pageRef?.pageNumber ?? 0) + " OF " + String(pdfView.document?.pageCount ?? 0)

    }
    
    @IBAction func nextGoPage(_ sender: Any) {
        pdfView.goToPreviousPage(self)
        pageCountLbl.text = String(pdfView.currentPage!.pageRef?.pageNumber ?? 0) + " OF " + String(pdfView.document?.pageCount ?? 0)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        togleIsNext()
    }
    
}

