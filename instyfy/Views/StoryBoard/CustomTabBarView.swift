import UIKit


protocol CutomTabBarDelegate: AnyObject {
    func selectedTab(index: Int)
}

class CustomTabBarView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tabView1: UIView!
    @IBOutlet weak var tabView2: UIView!
    @IBOutlet weak var tabView3: UIView!
    @IBOutlet weak var tabView4: UIView!
    @IBOutlet weak var tabView5: UIView!
    
    @IBOutlet weak var tabImage1: UIImageView!
    @IBOutlet weak var tabImage2: UIImageView!
    @IBOutlet weak var tabImage3: UIImageView!
    @IBOutlet weak var tabImage4: UIImageView!
    @IBOutlet weak var tabImage5: UIImageView!
    
    weak var customTabBarDelegate: CutomTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let nib = UINib(nibName: "CustomTabBarView", bundle: Bundle(for: type(of: self)))
        guard let loadedView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("❌ Could not load CustomTabBarView from nib")
        }

        contentView = loadedView
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindValues()
        addTapGestureRecognizer()
        updateSelection(index: 0) // Home selected initially
    }

    private func bindValues() {
        tabImage1.image = UIImage(systemName: "house.fill")
        tabImage2.image = UIImage(systemName: "magnifyingglass")
        tabImage3.image = UIImage(systemName: "plus.circle")
        tabImage4.image = UIImage(systemName: "heart")
        tabImage5.image = UIImage(systemName: "person.crop.circle")

        tabImage1.tintColor = .systemBlue
        tabImage2.tintColor = .black
        tabImage3.tintColor = .black
        tabImage4.tintColor = .black
        tabImage5.tintColor = .black
    }
    
    private func addTapGestureRecognizer() {
        let tabViews = [tabView1, tabView2, tabView3, tabView4, tabView5]
        for (index, view) in tabViews.enumerated() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            view?.addGestureRecognizer(tap)
            view?.tag = index
            view?.isUserInteractionEnabled = true
        }
    }
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        let index = tappedView.tag
        print("Tapped tab index: \(index)")
        updateSelection(index: index)
        customTabBarDelegate?.selectedTab(index: index)
    }
    
    func updateSelection(index: Int) {
        let icons = [tabImage1, tabImage2, tabImage3, tabImage4, tabImage5]
        let iconPairs = [
            ("house", "house.fill"),
            ("magnifyingglass", "magnifyingglass.circle.fill"),
            ("plus.circle", "plus.circle.fill"),
            ("heart", "heart.fill"),
            ("person.crop.circle", "person.crop.circle.fill")
        ]
        
        for (i, icon) in icons.enumerated() {
            let iconNames = iconPairs[i]
            icon?.image = UIImage(systemName: i == index ? iconNames.1 : iconNames.0)
            icon?.tintColor = .black
        }
    }
    
    
}
