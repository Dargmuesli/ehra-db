VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Sec Edits Persons"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Private Sub btnHome_Click()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.sfrmMain.SourceObject = "Form Prim Menu"
    End If
End Sub

Private Sub Form_Current()
    If Me.CurrentRecord <= 1 Then
        btnHeaderFirst.Enabled = False
        btnHeaderPrevious.Enabled = False
        btnHeaderNext.Enabled = True
        btnHeaderLast.Enabled = True
    ElseIf Me.CurrentRecord > 1 And Me.CurrentRecord < Me.Recordset.RecordCount Then
        btnHeaderFirst.Enabled = True
        btnHeaderPrevious.Enabled = True
        btnHeaderNext.Enabled = True
        btnHeaderLast.Enabled = True
    ElseIf Me.CurrentRecord >= Me.Recordset.RecordCount Then
        btnHeaderFirst.Enabled = True
        btnHeaderPrevious.Enabled = True
        btnHeaderNext.Enabled = False
        btnHeaderLast.Enabled = False
    End If
    
    lstLanguages_Click
End Sub

Private Sub lstLanguages_Click()
    UpdatePreviewList Me.lstLanguages, Me.lstLanguagesPrev
End Sub
