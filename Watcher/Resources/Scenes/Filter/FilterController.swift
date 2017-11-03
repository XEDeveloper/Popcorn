//
//  FilterController.swift
//  Watcher
//
//  Created by Rj on 24/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

protocol FilterControllerDelegate {
    func didTappedSave(controller: FilterController)
}

class FilterController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var segmented: UISegmentedControl!
    let textField = UITextField()
    let pickerView = UIPickerView()
    
    var values = [Default.year(), Default.adult(), Default.sortBy()]
    let movieFilters = ["Year", "Adult", "Sort By"]
    var years = ["None"]
    let genres = ["None", "Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"]
    let adults = ["No", "Yes"]
    let sortBy = ["Popularity Descending", "Popularity Ascending", "Rating Descending", "Rating Ascending", "Release Date Descending", "Release Date Ascending", "Title (A-Z)", "Title (Z-A)"]
    
    var selectedGenres: [String] = []
    var selectedIndex = 0
    
//    let tvshowFilter = []
    
    var delegate: FilterControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.tintColor = .purple
        view.addSubview(textField)
        textField.inputView = pickerView
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        
        tableView.tableFooterView = UIView()
        
        for i in (1990 ... 2017).reversed() {
            years.append(String(i))
        }
        
        DispatchQueue.main.async {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.view.sendSubview(toBack: blurEffectView)
        }
        
        let toolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = .orange
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        let select: UIBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(selectButtonAction))
        
        let items = [done, flexSpace, select]
        toolbar.items = items
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
        
        segmented.selectedSegmentIndex = Default.isSeries() ? 1 : 0
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        textField.resignFirstResponder()
        
        Default.setIsSeries(segmented.selectedSegmentIndex == 0 ? false : true)
        
        Default.setYear(values[0])
        Default.setAdult(values[1])
        Default.setSortBy(values[2])
        
        delegate?.didTappedSave(controller: self)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonAction() {
        textField.resignFirstResponder()
    }
    
    @objc func selectButtonAction() {
        switch selectedIndex {
        case 0:
            values[0] = years[pickerView.selectedRow(inComponent: 0)]
        case 1:
            values[1] = adults[pickerView.selectedRow(inComponent: 0)]
        case 2:
            values[2] = sortBy[pickerView.selectedRow(inComponent: 0)]
        default:
            print("default")
        }
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }

    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }
}

extension FilterController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Default.isSeries() ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Default.isSeries() {
            return 1
        }
        return section == 0 ? 3 : genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = indexPath.section == 0 ? movieFilters[indexPath.row] : genres[indexPath.row]
        
        if indexPath.section == 0 {
            let valueLabel = UILabel(frame: CGRect(x: tableView.bounds.width / 2 - 20, y: 0, width: tableView.bounds.width / 2, height: cell.bounds.height))
            valueLabel.text = values[indexPath.row]
            valueLabel.textColor = .orange
            valueLabel.textAlignment = .right
            valueLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.contentView.addSubview(valueLabel)

        } else if indexPath.section == 1 && selectedGenres.contains(genres[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
}

extension FilterController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 50.0))
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = sectionView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sectionView.addSubview(blurEffectView)
        
        let sectionLabel = UILabel(frame: CGRect(x: 16, y: 20, width: tableView.bounds.width - 40, height: 20))
        sectionLabel.text = "Select Genres"
        sectionLabel.textColor = .orange
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        sectionView.addSubview(sectionLabel)
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            selectedIndex = indexPath.row
            pickerView.reloadAllComponents()
            textField.becomeFirstResponder()
            
            switch indexPath.row {
            case 0:
                let index = years.index(of: values[indexPath.row])
                pickerView.selectRow(index ?? 0, inComponent: 0, animated: false)
            case 1:
                let index = adults.index(of: values[indexPath.row])
                pickerView.selectRow(index ?? 0, inComponent: 0, animated: false)
            case 2:
                let index = sortBy.index(of: values[indexPath.row])
                pickerView.selectRow(index ?? 0, inComponent: 0, animated: false)
            default:
                print("default")
            }
            
        } else if indexPath.section == 1 {
            
            if selectedGenres.contains(genres[indexPath.row]) {
                selectedGenres = selectedGenres.filter{ $0 != genres[indexPath.row] }
            } else {
                selectedGenres.append(genres[indexPath.row])
            }
            
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
}

extension FilterController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch selectedIndex {
        case 0:
            return years.count
        case 1:
            return adults.count
        case 2:
            return sortBy.count
        default:
            return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedIndex {
        case 0:
            return years[row]
        case 1:
            return adults[row]
        case 2:
            return sortBy[row]
        default:
            return ""
        }
    }
    
}

