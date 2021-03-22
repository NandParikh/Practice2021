//
//  PageVC.swift
//  Practise2021
//
//  Created by Nand Parikh on 21/03/21.
//

import UIKit

//struct Post: Decodable {
//    let userID, id: Int
//    let title, body: String
//}

public struct Post: Decodable {
    let userId: Int
    let id : Int
    let title: String
    let body: String
}

public struct Comment: Decodable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

protocol NumericType {
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    init(_ v: Int)
}

extension Int : NumericType {}


class PageVC: UIViewController {
    var numberOfPages : Int = 10
    var fetchPost : String = "https://jsonplaceholder.typicode.com/posts"
    var fetchComment : String = "https://jsonplaceholder.typicode.com/posts/1/comments"

    
    @IBOutlet weak var clvPageVC : UICollectionView!
    @IBOutlet weak var pageControlView : UIPageControl!
    @IBOutlet weak var imgViewTemp : UIImageView!
    
    func minusOneSquared<T : NumericType>(number: T) -> T {
        // uses init(_ v: Int) and the - operator
        let minusOne = number - T(1)
        // uses * operator
        return minusOne * minusOne
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(minusOneSquared(number: 5))              // 16

        clvPageVC.isPagingEnabled = true
        clvPageVC.showsVerticalScrollIndicator = false
        clvPageVC.showsHorizontalScrollIndicator = false
        
        clvPageVC.bounces = false
        pageControlView.numberOfPages = numberOfPages
        pageControlView.currentPage = 0
        
        self.arrayOperations()
    }
    
    
    func arrayOperations(){
        //Array related functions
        let arr1 = [3,4,54,4,5,7,89,9,3,5,1,11,10]
        let arr2 = [10,30,50]
        let arr3 = ["hi","how","are","you"]
        let arr4 = [3,4,nil,89,nil,10]
        let arr5 = ["John", "James", "Vincet", "Louis"]
        
        let setArr = Array(Set(arr1))
        print(setArr)
        //Output : [10, 5, 11, 3, 1, 54, 4, 7, 89, 9]
        
        let mapArr = arr1.map{ $0 * 10 }
        print(mapArr)
        //Output : [30, 40, 540, 40, 50, 70, 890, 90, 30, 50, 10, 110, 100]
        
        let results = [[10,20,30],[40,50],[60,70,80]]
        
        let flatMap = results.flatMap { $0 }
        print(flatMap)
        //Output : [10, 20, 30, 40, 50, 60, 70, 80]
        
        let sumOfArrayElements = arr2.reduce(0, +)
        print(sumOfArrayElements)
        //Output : 90
        
        let concateArrayElements = arr3.reduce("", +)
        print(concateArrayElements)
        //Output : hihowareyou
        
        let filterElementGreateThan5 = arr1.filter { $0 > 5 }
        print(filterElementGreateThan5)
        //Output : [54, 7, 89, 9, 11, 10]
        
        let removeNilFromArray = arr4.compactMap {$0}
        print(removeNilFromArray)
        //Output : [3, 4, 89, 10]
        
        let characterLengthOfArrayElement = arr3.map{ $0.count }
        print(characterLengthOfArrayElement)
        //Output : [2, 3, 3, 3]
        
        let sortArr = arr5.sorted()
        print(sortArr)
        //Output : ["James", "John", "Louis", "Vincet"]
        
        let d = ["john": 23, "james": 24, "vincent": 34, "louis": 29]
        print(d.sorted(by: {$0.1 < $1.1}))
        /*Output :
        [(key: "john", value: 23),
         (key: "james", value: 24),
         (key: "louis", value: 29),
         (key: "vincent", value: 34)] */
        
        
        
        let nameAndAgeTuple = (name:"Amar", age:25)
        print(nameAndAgeTuple)
        //Output : (name: "Amar", age: 25)

        var a = 1
        var b = 2
        genericFunction(a: &a, b: &b)
        
        
        var str1 = "hi"
        var str2 = "hello"
        genericFunction(a: &str1, b: &str2)
        

    }
    
    func genericFunction<T>(a: inout T, b: inout T){
        let temp = a
        a = b
        b = temp
        
        print(a)
        print(b)
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
        let pageNumber : Int = sender.currentPage
        print("Selected Page Number is \(pageNumber + 1)")
        let indexPath : IndexPath = IndexPath(row: pageNumber, section: 0)
        clvPageVC.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == clvPageVC {
            let offset : CGFloat = scrollView.contentOffset.x
            let currentPageNumber : Int = Int(offset / clvPageVC.frame.size.width)
            pageControlView.currentPage = currentPageNumber
        }
    }
    
    
    func fetchPostData(){
        //https://medium.com/the-andela-way/understanding-generic-functions-and-types-in-swift-4-7978e8ae35d6
        
        let url : URL = URL(string: fetchPost)!
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                
                do {
                    let arrPostData : [Post] = try JSONDecoder().decode([Post].self, from: data!)
                    print(arrPostData.count)
                    
                    print("\n----\n")
                    print("\nTitle : ",arrPostData[0].title)
                    print("\nBody : ",arrPostData[0].body)
                    print("\nUserId : ",arrPostData[0].userId)
                    print("\nID : ",arrPostData[0].id)
                    
                    let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(jsonString!)
                } catch {
                    print(error.localizedDescription)
                }
            }else {
                print(error?.localizedDescription)
            }
        }.resume()
    
    }
    
    
    func fetchCommentData(){
        
        let url : URL = URL(string: fetchComment)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                do {
                    let arrComment : [Comment] = try JSONDecoder().decode([Comment].self, from: data!)
                    print(arrComment.count)
                    
                    print("\n----\n")
                    print("\nPostId : ",arrComment[0].postId)
                    print("\nid : ",arrComment[0].id)
                    print("\nname : ",arrComment[0].name)
                    print("\nemail : ",arrComment[0].email)
                    print("\nbody : ",arrComment[0].body)

                    
                    let jsonString : String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                    print(jsonString)
                } catch  {
                    
                }
            }else{
                print(error?.localizedDescription)
            }
        }.resume()
        
    }

    
    func completionBlockExample(){
        
        let completionHandlerExample : String = DatabaseHelper.shareInstance.completionHandlerExample(name: "hello") { (intData, boolData, stringData) in
            if boolData {
                print(intData)
                print(stringData)
            }
        }
        print(completionHandlerExample)
    }
    
    @IBAction func btnFetchPostClicked(_ sender: UIButton) {
        self.fetchPostData()
    }

    @IBAction func btnFetchCommentClicked(_ sender: UIButton) {
        self.fetchCommentData()
    }

    
    @IBAction func btnCompletionBlockExampleClicked(_ sender: UIButton) {
        
//        let alert = UIAlertController(title: "AlertView", message: "Message", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//            print("Ok clicked")
//        }))
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
//            print("Cancel clicked")
//        }))
//
//        alert.addAction(UIAlertAction(title: "Destructive", style: .destructive, handler: { (UIAlertAction) in
//            print("Destructive Clicked")
//        }))
//
//        self.present(alert, animated: true, completion: nil)

        // create an actionSheet
//        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        // create an action
//        let firstAction: UIAlertAction = UIAlertAction(title: "First Action", style: .default) { action -> Void in
//
//            print("First Action pressed")
//        }
//
//        let secondAction: UIAlertAction = UIAlertAction(title: "Second Action", style: .default) { action -> Void in
//
//            print("Second Action pressed")
//        }
//
//        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
//
//        // add actions
//        actionSheetController.addAction(firstAction)
//        actionSheetController.addAction(secondAction)
//        actionSheetController.addAction(cancelAction)
//
//        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
//
//        present(actionSheetController, animated: true) {
//            print("option menu presented")
//        }

        
        self.completionBlockExample()
    }
 
    @IBAction func btnDownloadImageClicked(_ sender: UIButton) {
        self.imgViewTemp.downloadImage()
    }
    

}

class cellPage : UICollectionViewCell {
    
    @IBOutlet weak var lblPageNumber : UILabel!
    override class func awakeFromNib() {
        
    }
}

extension PageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : cellPage = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPage", for: indexPath) as! cellPage
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .yellow
        }else {
            cell.backgroundColor = .green
        }
        cell.lblPageNumber.text = "PageNumber\(indexPath.row + 1)"
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
}


extension UIImageView {
    
    func downloadImage(){
        URLSession.shared.dataTask(with: URL(string: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg")!) { (data, response, error) in
            if error == nil {
                
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let image = UIImage(data: data!)
                else { return }
                DispatchQueue.main.async {
                    self.contentMode = .scaleAspectFill
                    self.image = image
                }

            }else {
                print(error?.localizedDescription)
            }
        }.resume()
    }
    
//    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
    

}

