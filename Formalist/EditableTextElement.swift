//
//  EditableTextElement.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-06-16.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

import Foundation

/// An element that displays an editable text field
public final class EditableTextElement<AdapterType: TextEditorAdapter>: FormElement, Validatable {
    public typealias ViewConfigurator = AdapterType.ViewType -> Void
    
    private let adapter: AdapterType
    private let value: FormValue<String>
    private let validationRules: [ValidationRule<String>]
    private let viewConfigurator: ViewConfigurator?
    
    /**
     Designated initializer
     
     - parameter adaptor:          The adapter used to interact with the
     underlying text view. Custom adapters can add support for editable text
     view types other than the built-in support for `UITextField`, `UITextView`,
     and `FloatLabel`
     - parameter value:            The string value to bind to the text view
     - parameter configuration:    Configuration options for the text view
     - parameter validationRules:  Rules used to validate the string value
     - parameter viewConfigurator: An optional block used to perform additional
     customization of the text view
     
     - returns: An initialized instance of the receiver
     */
    public init(value: FormValue<String>, configuration: TextEditorConfiguration = TextEditorConfiguration(), validationRules: [ValidationRule<String>] = [], viewConfigurator: ViewConfigurator? = nil) {
        self.value = value
        self.adapter = AdapterType(configuration: configuration)
        self.validationRules = validationRules
        self.viewConfigurator = viewConfigurator
    }
    
    // MARK: FormElement
    
    public func render() -> UIView {
        let view = adapter.createViewWithCallbacks(TextEditorAdapterCallbacks()) { [weak self] in
            self?.value.value = $0
        }
        adapter.setText(value.value, forView: view)
        viewConfigurator?(view)
        return view
    }
    
    // MARK: Validatable
    
    public func validate(completionHandler: ValidationResult -> Void) {
        ValidationRule.validateRules(validationRules, forValue: value.value,  completionHandler: completionHandler)
    }
}
