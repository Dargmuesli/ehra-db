VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Sec Input Support-Circles"
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
    inputFields.Add Me.txtSupportcircle
    inputFields.Add Me.lstVolunteercontactpersonIds
    
    Set getInputFields = inputFields
End Function

Public Function getInputFieldsRequired() As Collection
    Dim inputFieldsRequired As Collection
    
    Set inputFieldsRequired = New Collection
    
    ' Add every input field to collection
    inputFieldsRequired.Add Me.txtSupportcircle
    
    Set getInputFieldsRequired = inputFieldsRequired
End Function

Public Function getDuplicateinfoDict() As Dictionary
    Dim duplicateInfoDict, duplicateInfoFieldDict As Scripting.Dictionary
    
    Dim nameDuplicateCollection As Collection
    
    Set duplicateInfoDict = New Scripting.Dictionary
    Set duplicateInfoFieldDict = New Scripting.Dictionary
    
    Set nameDuplicateCollection = New Collection
    
    nameDuplicateCollection.Add Me.txtSupportcircle
    nameDuplicateCollection.Add "dem Namen"
    
    duplicateInfoFieldDict.Add "[Support Circle]", nameDuplicateCollection
    
    duplicateInfoDict.Add "[Table Support-Circles]", duplicateInfoFieldDict
    
    Set getDuplicateinfoDict = duplicateInfoDict
End Function

Private Sub lstVolunteercontactpersonIds_Click()
    UpdateIdPreviewList Me.lstVolunteercontactpersonIds, Me.lstVolunteercontactpersons, "[Salutation], [First Name], [Last Name]", "[Table Persons]"
End Sub

Private Sub txtName_Change()
    TryUpdateSaveButton Me
End Sub
