VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Sec Input Persons"
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
    inputFields.Add Me.cmbSalutation
    inputFields.Add Me.txtTitle
    inputFields.Add Me.txtFirstname
    inputFields.Add Me.txtLastname
    inputFields.Add Me.txtPhonenumber
    inputFields.Add Me.txtMobilephonenumber
    inputFields.Add Me.txtEmailaddress
    inputFields.Add Me.txtStreet
    inputFields.Add Me.cmbPostalcode
    inputFields.Add Me.lstLanguages
    inputFields.Add Me.cmbVolunteercertificate
    inputFields.Add Me.txtNotes
    inputFields.Add Me.chkContacted
    inputFields.Add Me.chkReplied
    
    Set getInputFields = inputFields
End Function

Public Function getInputFieldsRequired() As Collection
    Dim inputFieldsRequired As Collection
    Dim contactCollection As Collection
    
    Set inputFieldsRequired = New Collection
    Set contactCollection = New Collection
    
    contactCollection.Add Me.txtPhonenumber
    contactCollection.Add Me.txtMobilephonenumber
    contactCollection.Add Me.txtEmailaddress
    
    ' Add every input field to collection
    inputFieldsRequired.Add Me.txtLastname
    inputFieldsRequired.Add contactCollection
    
    Set getInputFieldsRequired = inputFieldsRequired
End Function

Public Function getDuplicateinfoDict() As Dictionary
    Dim duplicateInfoDict, duplicateInfoFieldDict As Scripting.Dictionary
    
    Dim nameDuplicateCollection As Collection
    Dim emailDuplicateCollection As Collection
    Dim phoneDuplicateCollection As Collection
    Dim mobileDuplicateCollection As Collection
    
    Set duplicateInfoDict = New Scripting.Dictionary
    Set duplicateInfoFieldDict = New Scripting.Dictionary
    
    Set nameDuplicateCollection = New Collection
    Set emailDuplicateCollection = New Collection
    Set phoneDuplicateCollection = New Collection
    Set mobileDuplicateCollection = New Collection
    
    nameDuplicateCollection.Add Me.txtFirstname.value & ";" & Me.txtLastname.value
    nameDuplicateCollection.Add "dem Namen"
    emailDuplicateCollection.Add Me.txtEmailaddress.value
    emailDuplicateCollection.Add "der E-Mail-Adresse"
    phoneDuplicateCollection.Add Me.txtPhonenumber.value
    phoneDuplicateCollection.Add "der Telefonnummer"
    mobileDuplicateCollection.Add Me.txtMobilephonenumber.value
    mobileDuplicateCollection.Add "der Mobilfunknummer"
    
    duplicateInfoFieldDict.Add "[First Name];[Last Name]", nameDuplicateCollection
    duplicateInfoFieldDict.Add "[E-Mail Address]", emailDuplicateCollection
    duplicateInfoFieldDict.Add "[Phone Number]", phoneDuplicateCollection
    duplicateInfoFieldDict.Add "[Mobile Phone Number]", mobileDuplicateCollection
    
    duplicateInfoDict.Add "[Table Persons]", duplicateInfoFieldDict
    
    Set getDuplicateinfoDict = duplicateInfoDict
End Function

Private Sub lstLanguages_Click()
    UpdatePreviewList Me.lstLanguages, Me.lstLanguagesPrev
End Sub

Private Sub txtEmailaddress_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub txtLastname_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub txtMobilephonenumber_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub txtPhonenumber_Change()
    TryUpdateSaveButton Me
End Sub
