VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Sec Input Help-Offer-Specifications"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Public Function getInputFields() As Collection
    Dim inputFields As Collection
    
    Set inputFields = New Collection
    
    ' Add every input field to collection
    inputFields.Add Me.cmbCategory
    inputFields.Add Me.txtSpecification
    
    Set getInputFields = inputFields
End Function

Public Function getInputFieldsRequired() As Collection
    Dim inputFieldsRequired As Collection
    
    Set inputFieldsRequired = New Collection
    
    ' Add every input field to collection
    inputFieldsRequired.Add Me.cmbCategory
    inputFieldsRequired.Add Me.txtSpecification
    
    Set getInputFieldsRequired = inputFieldsRequired
End Function

Public Function getDuplicateinfoDict() As Dictionary
    Dim duplicateInfoDict, duplicateInfoFieldDict As Scripting.Dictionary
    
    Dim helpofferspecificationDuplicateCollection As Collection
    
    Set duplicateInfoDict = New Scripting.Dictionary
    Set duplicateInfoFieldDict = New Scripting.Dictionary
    
    Set helpofferspecificationDuplicateCollection = New Collection
    
    helpofferspecificationDuplicateCollection.Add Me.cmbCategory & ";" & Me.txtSpecification
    helpofferspecificationDuplicateCollection.Add "der Hilfsangebotsspezifizierung"
    
    duplicateInfoFieldDict.Add "[Help Offer Category];[Help Offer Specification]", helpofferspecificationDuplicateCollection
    
    duplicateInfoDict.Add "[Table Help-Offer-Specifications]", duplicateInfoFieldDict
    
    Set getDuplicateinfoDict = duplicateInfoDict
End Function

Private Sub cmbCategory_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub txtSpecification_Change()
    TryUpdateSaveButton Me
End Sub
