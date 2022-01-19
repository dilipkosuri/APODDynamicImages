import UIKit
import Combine
import WebKit

class APODDetailsVC: UIViewController {
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var poster: UIImageView!
    @IBOutlet private var header: UILabel!
    @IBOutlet private var date: UILabel!
    @IBOutlet private var overview: UILabel!
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmDateSelectionBtn: UIButton!
    @IBOutlet weak var wv: WKWebView!
    @IBOutlet weak var appSwitch: UISwitch!
    private let datePicker = DatePicker()
    
    private let viewModel: APODDetailsViewModelType
    private var cancellables: [AnyCancellable] = []
    private let appear = PassthroughSubject<Void, Never>()
    private let update = PassthroughSubject<String, Never>()
    private let baseSpace: CGFloat = 16
    
    init(viewModel: APODDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = AccessibilityIdentifiers.APODDetails.rootViewId
        contentView.accessibilityIdentifier = AccessibilityIdentifiers.APODDetails.contentViewId
        header.accessibilityIdentifier = AccessibilityIdentifiers.APODDetails.titleLabelId
        date.accessibilityIdentifier = AccessibilityIdentifiers.APODDetails.subtitleLabelId
        overview.accessibilityIdentifier = AccessibilityIdentifiers.APODDetails.descriptionLabelId
        loadingIndicator.accessibilityIdentifier = AccessibilityIdentifiers.APODDetails.loadingIndicatorId
        appSwitch.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)

        setupImage()
        bind(to: viewModel)
        dateTextField.delegate = self
        datePicker.dataSource = datePicker
        datePicker.delegate = datePicker
    }
    
    private func setupImage() {
        poster.layer.masksToBounds = false
        poster.layer.borderColor = UIColor.black.cgColor
        poster.layer.cornerRadius = poster.frame.height/2
        poster.clipsToBounds = true
        poster.backgroundColor = UIColor.gray
        poster.layer.borderWidth = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send(())
    }
    
    private func bind(to viewModel: APODDetailsViewModelType) {
        let input = APODDetailsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                              update: update.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: APODDetailsState) {
        switch state {
        case .loading:
            self.contentView.isHidden = true
            self.loadingIndicator.isHidden = false
        case .failure:
            self.contentView.isHidden = true
            self.loadingIndicator.isHidden = true
        case .success(let apodDetails):
            self.contentView.isHidden = false
            self.loadingIndicator.isHidden = true
            show(apodDetails)
        }
    }
    
    private func show(_ detailsViewModel: DetailsViewModel) {
        header.text = detailsViewModel.title
        date.text = detailsViewModel.date
        overview.text = detailsViewModel.overview
        
        if let imageURLForWebView = detailsViewModel.imageInWebViewURL {
            let request = URLRequest(url: imageURLForWebView)
            wv.isHidden = false
            poster.isHidden = true
            wv.load(request)
        } else {
            wv.isHidden = true
            poster.isHidden = false
            detailsViewModel.poster
                .assign(to: \UIImageView.image, on: self.poster)
                .store(in: &cancellables)
        }
    }
    
    @IBAction func getPicByDate(_ sender: UIButton) {
        let dateFromPicker = dateTextField.text ?? ""
        if !dateFromPicker.isEmpty {
            update.send((OtherUtils().formatDate(dateString: dateFromPicker, from: true)))
        }
    }
    
    @objc func doneDatePicker() {
        if dateTextField.text == "" {
            let date = OtherUtils().formatDate(date: Date())
            dateTextField.text = date
        }
        dateTextField.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: .dateChanged, object: nil)
    }
    
    @objc func dateChanged(notification:Notification) {
        let userInfo = notification.userInfo
        if let date = userInfo?["date"] as? String{
            self.dateTextField.text = date
        }
    }
    
    @objc func switchStateDidChange(_ sender:UISwitch!) {
        self.view.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
        self.customLabel.text = sender.isOn ? "Disable Dark Mode" : "Enable Dark Mode"
    }
}

extension APODDetailsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.selectRow(datePicker.selectedDate(), inComponent: 0, animated: true)
        textField.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: CGFloat(44))))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        
        toolBar.setItems([space,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        NotificationCenter.default.addObserver(self, selector: #selector(dateChanged(notification:)), name:.dateChanged, object: nil)
    }
}
