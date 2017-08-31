VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Sec Input Accommodations"
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
    inputFields.Add Me.cmbType
    inputFields.Add Me.txtName
    inputFields.Add Me.txtStreet
    inputFields.Add Me.cmbPostalcode
    inputFields.Add Me.txtCapacity
    inputFields.Add Me.cmbWardrobe
    inputFields.Add Me.cmbMaincontactpersonId
    inputFields.Add Me.lstMainemployeeIds
    inputFields.Add Me.txtNotes
    
    Set getInputFields = inputFields
End Function

Public Function getInputFieldsRequired() As Collection
    Dim inputFieldsRequired As Collection
    
    Set inputFieldsRequired = New Collection
    
    ' Add every input field to collection
    inputFieldsRequired.Add Me.txtName
    inputFieldsRequired.Add Me.cmbType
    inputFieldsRequired.Add Me.cmbPostalcode
    
    Set getInputFieldsRequired = inputFieldsRequired
End Function

Public Function getDuplicateinfoDict() As Dictionary
    Dim duplicateInfoDict, duplicateInfoFieldDict As Scripting.Dictionary
    
    Dim nameDuplicateCollection As Collection
    Dim streetDuplicateCollection As Collection
    Dim maincontactpersonDuplicateCollection As Collection
    
    Set duplicateInfoDict = New Scripting.Dictionary
    Set duplicateInfoFieldDict = New Scripting.Dictionary
    
    Set nameDuplicateCollection = New Collection
    Set streetDuplicateCollection = New Collection
    Set maincontactpersonDuplicateCollection = New Collection
    
    nameDuplicateCollection.Add Me.txtName
    nameDuplicateCollection.Add "dem Namen"
    streetDuplicateCollection.Add Me.txtStreet
    streetDuplicateCollection.Add "der Straße"
    maincontactpersonDuplicateCollection.Add Me.cmbMaincontactpersonId
    maincontactpersonDuplicateCollection.Add "dem Hauptansprechpartner"
    
    duplicateInfoFieldDict.Add "[Accommodation Name]", nameDuplicateCollection
    duplicateInfoFieldDict.Add "[Street]", streetDuplicateCollection
    duplicateInfoFieldDict.Add "[Main Contact Person ID]", maincontactpersonDuplicateCollection
    
    duplicateInfoDict.Add "[Table Accommodations]", duplicateInfoFieldDict
    
    Set getDuplicateinfoDict = duplicateInfoDict
End Function

Private Sub cmbPostalcode_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub cmbType_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub lstMainemployeeIds_Click()
    UpdateIdPreviewList Me.lstMainemployeeIds, Me.lstMainemployees, "[Salutation], [First Name], [Last Name]", "[Table Persons]"
End Sub

Private Sub txtName_Change()
    TryUpdateSaveButton Me
End Sub
