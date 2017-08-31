VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Prim Statistic"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Private settings As New clsSettings

Private Sub btnAccommodations_Click()

    ' Open "Unterkünfte" and grey out the calling button
    enableAllButtons
    srReports.SourceObject = "Report.Rep Prim Accommodations"
    btnAccommodations.Enabled = False
End Sub

Private Sub btnHelpoffers_Click()

    ' Open "Hilfsangebote" and grey out the calling button
    enableAllButtons
    srReports.SourceObject = "Report.Rep Prim Help-Offers"
    btnHelpoffers.Enabled = False
End Sub

Private Sub btnLocalcoordinators_Click()

    ' Open "Ortskoordinatoren" and grey out the calling button
    enableAllButtons
    srReports.SourceObject = "Report.Rep Prim Local-Coordinators"
    btnLocalcoordinators.Enabled = False
End Sub

Private Sub btnMaintenance_Click()

    ' Open "Wartung" and grey out the calling button
    enableAllButtons
    srReports.SourceObject = "Report.Rep Prim Maintenance"
    btnMaintenance.Enabled = False
End Sub

Private Sub btnNonvolunteers_Click()

    ' Open "Nicht-Ehrenamtliche" and grey out the calling button
    enableAllButtons
    srReports.SourceObject = "Report.Rep Prim Non-Volunteers"
    btnNonvolunteers.Enabled = False
End Sub

Private Sub btnSupportcircles_Click()

    ' Open "Unterstützerkreise" and grey out the calling button
    enableAllButtons
    srReports.SourceObject = "Report.Rep Prim Support-Circles"
    btnSupportcircles.Enabled = False
End Sub

Private Sub btnVolunteers_Click()

    ' Open "Ehrenamtliche" and grey out the calling button
    enableAllButtons
    srReports.SourceObject = "Report.Rep Prim Volunteers"
    btnVolunteers.Enabled = False
End Sub

Private Sub btnHome_Click()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.sfrmMain.SourceObject = "Form Prim Menu"
    End If
End Sub

Private Sub Form_Load()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.descHeader.Caption = "Statistikformulare"
        Me.btnHome.Enabled = True
    Else
        Me.btnHome.Enabled = False
    End If
End Sub

Private Sub enableAllButtons()
    btnAccommodations.Enabled = True
    btnHelpoffers.Enabled = True
    btnLocalcoordinators.Enabled = True
    btnMaintenance.Enabled = True
    btnNonvolunteers.Enabled = True
    btnSupportcircles.Enabled = True
    btnVolunteers.Enabled = True
End Sub
