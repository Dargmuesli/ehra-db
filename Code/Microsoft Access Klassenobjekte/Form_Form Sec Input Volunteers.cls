VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Sec Input Volunteers"
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
    inputFields.Add Me.cmbPersonid
    inputFields.Add Me.cmbSupportcircle
    inputFields.Add Me.lstHelpoffers
    inputFields.Add Me.txtBeginning
    inputFields.Add Me.txtEnding
    inputFields.Add Me.lstTargetgroups
    
    Set getInputFields = inputFields
End Function

Public Function getInputFieldsRequired() As Collection
    Dim inputFieldsRequired As Collection
    
    Set inputFieldsRequired = New Collection
    
    ' Add every input field to collection
    inputFieldsRequired.Add Me.cmbPersonid
    inputFieldsRequired.Add Me.cmbSupportcircle
    
    Set getInputFieldsRequired = inputFieldsRequired
End Function

Public Function getDuplicateinfoDict() As Dictionary
    Dim duplicateInfoDict, duplicateInfoFieldDict As Scripting.Dictionary
    
    Dim idDuplicateCollection As Collection
    
    Set duplicateInfoDict = New Scripting.Dictionary
    Set duplicateInfoFieldDict = New Scripting.Dictionary
    
    Set idDuplicateCollection = New Collection
    
    idDuplicateCollection.Add Me.cmbPersonid
    idDuplicateCollection.Add "der ID"
    
    duplicateInfoFieldDict.Add "[Person ID]", idDuplicateCollection
    
    duplicateInfoDict.Add "[Table Volunteers]", duplicateInfoFieldDict
    
    Set getDuplicateinfoDict = duplicateInfoDict
End Function

Private Sub cmbPersonId_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub cmbSupportcircle_Change()
    TryUpdateSaveButton Me
End Sub

Private Sub lstTargetgroups_Click()
    UpdatePreviewList Me.lstTargetgroups, Me.lstTargetgroupsPrev
End Sub

Private Sub lstHelpoffers_Click()
    UpdatePreviewList Me.lstHelpoffers, Me.lstHelpoffersPrev
End Sub
