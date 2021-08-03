//
//  HistoryPdfGeneratorViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 05/07/2021.
//

import UIKit
import WebKit

class HistoryPdfGeneratorViewController: BaseViewController, TopBarDelegate, WKNavigationDelegate {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var webView: WKWebView!
    //MARK: - Var& Objects
    let imageLogo = UIImage(named: "login_logo")
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.createPDF()
        
        
        if let container = self.mainContainer{
            container.delegate = self
            
        }
    }
    
    
    //MARK: - Functions
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
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
        
        pdfData.write(toFile: "\(documentsPath)/ChecklistReport.pdf", atomically: true)
        drawImageOnPDF(path: "\(documentsPath)/ChecklistReport.pdf")
        loadPDF(filename: "ChecklistReport.pdf")
    }
    
    func loadPDF(filename: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent(filename)
        let urlRequest = URLRequest(url: url)
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
        
        
        
        
        
        
        
//        var text = """
//
// <table style="width:100%"> <tr> <td> <h1>Technician completed Task</h1> </td>  <td> <img src="breakFast.png"> </td>
// </tr> </table> <br> <br> <br> <table style="width:100%">
//            <tr> <th style="text-align: left;">Tech Name <hr style="width:110%"> </th>
//            <th style="text-align: left;">Checklist Name <hr style="width:110%"> </th>
//            <th style="text-align: left;">Check In <hr style="width:110%"> </th>
//            <th style="text-align: left;">Check Out <hr style="width:100%"> </th>
//
//            </tr>
// """
        
        
        
        //        var text1 = "<h1>Technician Completed Task </h1> <p><img src=\"\(imgData)\" alt=\"\" width=\"60\" height=\"72\" /></p> <hr> <br> </br> Tech name &emsp; CheckList Name &emsp; Check In &emsp; Check out <hr> "
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
            //UIColor.redColor().set()
            //UIRectFill(CGRectMake(20, 20, 100, 100));
        }
        
        
        UIGraphicsEndPDFContext()
    }
}

