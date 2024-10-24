//
//  Model.swift
//

import Foundation

class Document: ObservableObject {
    @Published var model: Model
    // @Published var items:[ItemModel]
    
    // file name to store JSON for model items
    let saveFileName = "model.json"
    
    // true to initialize model items with sample items
    let initSampleItems = true
    
    init() {
        print("Model init")
        
        // For testing:
//         remove(fileName: saveFileName)
        
        model = Model(JSONfileName: saveFileName);
        if initSampleItems && model.items.isEmpty {
            // items for testing
            model.items = []
            addItem(selectedTime: 60, meditationCount:0, selectedBackground:"Default");
            saveModel();
        }
    }
    
    func addItem(selectedTime:Int, meditationCount: Int, selectedBackground: String) {
        let item = ItemModel(id: UUID(), selectedTime: selectedTime, meditationCount: meditationCount, selectedBackground: selectedBackground);
        model.addItem(item: item);
        saveModel();
    }
    
    func addItem(item: ItemModel) {
        model.addItem(item: item);
        saveModel();
    }

    func updateItem(item: ItemModel) {
        model.updateItem(item: item);
        saveModel();
    }
    
    func updateItems(){
        saveModel();
    }
    
    func deleteItem(id: UUID) {
        model.deleteItem(id: id)
        saveModel();
    }
    
    func saveModel() {
        print("Document saveModel")
        model.saveAsJSON(fileName: saveFileName)
    }
    
    // Not used
    //    func newItem() {
    //        addItem(urlStr: "", label: "", assetName: "", systemName: "")
    //    }
}

