VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Prim Menu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Private Sub btnStatistic_Click()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.sfrmMain.SourceObject = "Form Prim Statistic"
    End If
End Sub

Private Sub btnEdits_Click()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.sfrmMain.SourceObject = "Form Prim Edits"
    End If
End Sub

Private Sub btnInput_Click()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.sfrmMain.SourceObject = "Form Prim Input"
    End If
End Sub

Private Sub Form_Load()
    
    ' Set heading to "Main Menu" when on "Formular Primary"
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.descHeader.Caption = "Hauptmenü"
        Me.btnInput.Enabled = True
        Me.btnEdits.Enabled = True
        Me.btnStatistic.Enabled = True
    End If
End Sub
