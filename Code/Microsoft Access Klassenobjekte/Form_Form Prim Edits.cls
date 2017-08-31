VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Prim Edits"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Private settings As New clsSettings

Private Sub regEdits_Change()

    ' Disable all subforms
    Me.sfrmVolunteers.Enabled = False
    Me.sfrmHelpofferspecifications.Enabled = False
    Me.sfrmPersons.Enabled = False
    Me.sfrmAccommodations.Enabled = False
    Me.sfrmSupportcircles.Enabled = False
    
    ' Enable the selected subform to prevent a page jump to its last element
    Select Case Me.regEdits.value
        Case 0
            Me.sfrmVolunteers.Enabled = True
        Case 1
            Me.sfrmHelpofferspecifications.Enabled = True
        Case 2
            Me.sfrmPersons.Enabled = True
        Case 3
            Me.sfrmAccommodations.Enabled = True
        Case 4
            Me.sfrmSupportcircles.Enabled = True
    End Select
End Sub

Private Sub btnHome_Click()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.sfrmMain.SourceObject = "Form Prim Menu"
    End If
End Sub

Private Sub Form_Current()
    Call regEdits_Change
End Sub

Private Sub Form_Load()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.descHeader.Caption = "Eingabe"
        Me.btnHome.Enabled = True
    Else
        Me.btnHome.Enabled = False
    End If
    
    Me.regEdits.Enabled = True
End Sub
