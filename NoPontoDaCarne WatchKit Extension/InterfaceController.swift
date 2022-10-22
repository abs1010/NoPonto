//
//  InterfaceController.swift
//  NoPontoDaCarne WatchKit Extension
//
//  Created by Alan Bezerra on 14/05/22.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    // MARK: - IBOutlets
    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var buttonTimer: WKInterfaceButton!
    @IBOutlet weak var labelWeight: WKInterfaceLabel!
    @IBOutlet weak var labelCook: WKInterfaceLabel!
    @IBOutlet weak var sliderCook: WKInterfaceSlider!
    @IBOutlet weak var groupText: WKInterfaceGroup!
    @IBOutlet weak var groupImages: WKInterfaceGroup!
    @IBOutlet weak var labelTemperature: WKInterfaceLabel!
    @IBOutlet weak var pickerWeight: WKInterfacePicker!
    @IBOutlet weak var pickerTemperature: WKInterfacePicker!
    
    private var kg = 0.1
    private var increment = 0.1
    private var maxKg = 2.0
    private var isTimerRunning = false
    private var meatTemperature: MeatTemperature = .rare
    
    // MARK: - Super Methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        onModeChange(true)
        setupPickers()
        update()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    // MARK: - Methods
    private func setupPickers() {
        //picker de peso
        var weightItens: [WKPickerItem] = []
        for weight in stride(from: kg, through: maxKg, by: increment) {
            let item = WKPickerItem()
            item.title = String(format: "%.1f", weight)
            weightItens.append(item)
        }
        
        pickerWeight.setItems(weightItens)
        pickerWeight.setSelectedItemIndex(0)
        
        //picker de temperatura
        var temperatureItens: [WKPickerItem] = []
        for index in 1...4 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "temp-\(index)")
            temperatureItens.append(item)
        }
        
        pickerTemperature.setItems(temperatureItens)
            
    }
    
    private func update() {
        labelWeight.setText("Total: \(String(format: "%.1f", kg)) kg")
        let index = Int(kg * 10) - 1
        pickerWeight.setSelectedItemIndex(index)
        labelTemperature.setText(meatTemperature.stringValue)
        labelCook.setText(meatTemperature.stringValue)
        sliderCook.setValue(Float(meatTemperature.rawValue))
        pickerTemperature.setSelectedItemIndex(meatTemperature.rawValue)
    }
    
    func setMeatTemperature(_ value: Int) {
        if let newMeatTemperature = MeatTemperature(rawValue: value) {
            meatTemperature = newMeatTemperature
            update()
        }
    }
    
    // MARK: - IBActions
    @IBAction func toggleTimer() {
        if isTimerRunning {
            timer.stop()
            buttonTimer.setTitle("Iniciar Timer")
        } else {
            let timeInSeconds = meatTemperature.cookTimeForKg(kg)
            timer.setDate(Date(timeIntervalSinceNow: timeInSeconds))
            timer.start()
            buttonTimer.setTitle("Parar Timer")
        }
        isTimerRunning.toggle()
    }
    
    @IBAction func decreaseWeight() {
        if kg > 0.19 {
            kg -= increment
            update()
        }
    }
    
    @IBAction func increaseWeight() {
        if kg < maxKg {
            kg += increment
            update()
        }
    }
    
    @IBAction func onSliderChange(_ value: Float) {
        setMeatTemperature(Int(value))
    }
    
    @IBAction func onWeightPickerChange(_ value: Int) {
        kg = Double(value+1) * increment
        update()
    }
    
    @IBAction func onTemperaturePickerChange(_ value: Int) {
        setMeatTemperature(value)
    }
    
    @IBAction func onModeChange(_ value: Bool) {
        groupImages.setHidden(!value)
        groupText.setHidden(value)
    }

}
