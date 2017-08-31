VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_Form Prim Input"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

Private settings As New clsSettings

Private Sub regInput_Change()

    ' Disable all subforms
    Me.sfrmVolunteers.Enabled = False
    Me.sfrmHelpofferspecifications.Enabled = False
    Me.sfrmPersons.Enabled = False
    Me.sfrmAccommodations.Enabled = False
    Me.sfrmSupportcircles.Enabled = False
    
    ' Enable the selected subform to prevent a page jump to its last element
    Select Case Me.regInput.value
        Case 0
            Me.sfrmVolunteers.Enabled = True
            UpdateSaveButton Me.sfrmVolunteers.Form
            Me.lblTitle.Caption = "Neuer Datensatz ""Ehrenamtlicher"" #" & GetSeedValue("Table Volunteers", "ID")
        Case 1
            Me.sfrmHelpofferspecifications.Enabled = True
            UpdateSaveButton Me.sfrmHelpofferspecifications.Form
            Me.lblTitle.Caption = "Neuer Datensatz ""Hilfsangebotsspezifizierung"" #" & GetSeedValue("Table Help-Offer-Specifications", "ID")
        Case 2
            Me.sfrmPersons.Enabled = True
            UpdateSaveButton Me.sfrmPersons.Form
            Me.lblTitle.Caption = "Neuer Datensatz ""Person"" #" & GetSeedValue("Table Persons", "ID")
        Case 3
            Me.sfrmAccommodations.Enabled = True
            UpdateSaveButton Me.sfrmAccommodations.Form
            Me.lblTitle.Caption = "Neuer Datensatz ""Unterkunft"" #" & GetSeedValue("Table Accommodations", "ID")
        Case 4
            Me.sfrmSupportcircles.Enabled = True
            UpdateSaveButton Me.sfrmSupportcircles.Form
            Me.lblTitle.Caption = "Neuer Datensatz ""Unterstützerkreis"" #" & GetSeedValue("Table Support-Circles", "ID")
    End Select
End Sub

Private Sub btnHome_Click()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.sfrmMain.SourceObject = "Form Prim Menu"
    End If
End Sub

Private Sub Form_Current()
    Call regInput_Change
End Sub

Private Sub Form_Load()
    If mdlTools.HasParent(Me) And CurrentProject.AllForms("Form Prim").IsLoaded Then
        Me.parent.descHeader.Caption = "Eingabe"
        Me.btnHome.Enabled = True
    Else
        Me.btnHome.Enabled = False
    End If
    
    Me.regInput.Enabled = True
End Sub

Public Sub UpdateSaveButton(context As Form)
    Dim enableCount As Integer
    Dim inputFields As Collection
    Dim varItem, varItemItem As Variant
    Dim valid As Boolean

    enableCount = 0

    Set inputFields = context.getInputFieldsRequired

    For Each varItem In inputFields
        If TypeOf varItem Is Collection Then
            For Each varItemItem In varItem
                valid = ValidateInput(varItemItem, context)
                
                If valid Then
                    enableCount = enableCount + 1
                    Exit For
                End If
            Next
        Else
            valid = ValidateInput(varItem, context)
            
            If valid Then
                enableCount = enableCount + 1
            End If
        End If
    Next
    
    If enableCount = context.getInputFieldsRequired.Count Then
        Me.btnSave.Enabled = True
    Else
        Me.btnSave.Enabled = False
    End If
End Sub

Private Sub btnSave_Click()
    Dim context As Form
    Dim duplicateInfoDict As Scripting.Dictionary
    Dim duplicateinfoFields, matchItem, inputField, formnameDictKey, formnameKey, inputKey, multiInsertQ As Variant
    Dim inputFields As Collection
    
    Dim key As String
    Dim value As String
    Dim matchCollection As Collection
    Dim matchString As String
    Dim result As VbMsgBoxResult
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim cnn As ADODB.Connection
    Dim sqlInsert, sqlValues As String
    Dim inputKeys, inputValues As Collection
    Dim i As Integer

    i = 0

    Set matchCollection = New Collection
    Set db = CurrentDb
    Set cnn = CurrentProject.Connection
    Set inputKeys = New Collection
    Set inputValues = New Collection
    
    On Error GoTo Problem
    
    ' Get correct register
    Select Case Me.regInput.value
        Case 0
            Set context = Me.sfrmVolunteers.Form
        Case 1
            Set context = Me.sfrmHelpofferspecifications.Form
        Case 2
            Set context = Me.sfrmPersons.Form
        Case 3
            Set context = Me.sfrmAccommodations.Form
        Case 4
            Set context = Me.sfrmSupportcircles.Form
    End Select
    
    ' Get information about duplicate checking
    Set duplicateInfoDict = context.getDuplicateinfoDict
    
    ' Check for existing duplicates
    For Each duplicateinfoFields In duplicateInfoDict.Items(0).Keys
        Dim duplicateinfoFieldArray
        Dim duplicateinfoValueArray
        
        ' Gather key-value pairs that need to match existing records
        duplicateinfoFieldArray = Split(duplicateinfoFields, ";")
        
        If IsNull(duplicateInfoDict.Items(0)(duplicateinfoFields).Item(1)) Or duplicateInfoDict.Items(0)(duplicateinfoFields).Item(1) = "" Then
            duplicateinfoValueArray = Array(1)
            duplicateinfoValueArray(0) = ""
        Else
            duplicateinfoValueArray = Split(duplicateInfoDict.Items(0)(duplicateinfoFields).Item(1), ";")
        End If
        
        If UBound(duplicateinfoFieldArray) <> UBound(duplicateinfoValueArray) Then
            Err.Raise vbObjectError + 1000, , "Key/Value count does not match!"
        End If
        
        Dim whereString As String
        
        whereString = ""
        
        For i = LBound(duplicateinfoFieldArray) To UBound(duplicateinfoFieldArray)
            If duplicateinfoValueArray(i) <> "" Then
                If whereString <> "" Then
                    whereString = whereString & " AND "
                End If
            
                If EndsWith(CStr(duplicateinfoFieldArray(i)), " ID]") Or EndsWith(CStr(duplicateinfoFieldArray(i)), " IDs]") Then
                    If duplicateinfoValueArray(i) = "" Then
                        whereString = whereString & duplicateinfoFieldArray(i) & " IS NULL"
                    Else
                        whereString = whereString & duplicateinfoFieldArray(i) & " = " & duplicateinfoValueArray(i)
                    End If
                Else
                    whereString = whereString & duplicateinfoFieldArray(i) & " = '" & duplicateinfoValueArray(i) & "'"
                End If
            End If
        Next
        
        ' Query for existing records with matching data
        If whereString <> "" Then
            Set rs = db.OpenRecordset("SELECT * FROM " & duplicateInfoDict.Keys(0) & " WHERE " & whereString & ";")
            
            If Not rs.EOF Then
                rs.MoveLast
                
                ' Save a match for use in a warning message
                If rs.RecordCount = 1 Then
                    matchCollection.Add "ein Eintrag mit " & duplicateInfoDict.Items(0)(duplicateinfoFields).Item(2) & " '" & duplicateInfoDict.Items(0)(duplicateinfoFields).Item(1) & "'"
                ElseIf rs.RecordCount > 1 Then
                    matchCollection.Add rs.RecordCount & " Einträge mit " & duplicateInfoDict.Items(0)(duplicateinfoFields).Item(2) & " '" & duplicateInfoDict.Items(0)(duplicateinfoFields).Item(1) & "'"
                End If
            End If
        End If
    Next
    
    ' Display a warning for found matches
    If matchCollection.Count > 0 Then
        matchString = "Folgende Daten sind bereits vorhanden:" & vbCrLf & vbCrLf
        
        For Each matchItem In matchCollection
            matchString = matchString & " - " & Replace(matchItem, ";", " ") & vbCrLf
        Next
        
        matchString = matchString & vbCrLf & "Soll der neue Datensatz dennoch eingefügt werden?"
        
        result = MsgBox(matchString, vbYesNo)
        
        If result = vbNo Then
            Exit Sub
        End If
    End If
    
    Set inputFields = context.getInputFields()
    
    For Each inputField In inputFields
        key = ""
        value = ""

        ' Get input key
        For Each formnameDictKey In settings.pformnameDict.Keys
            If formnameDictKey = context.name Then
                For Each formnameKey In settings.pformnameDict(formnameDictKey).Keys
                    If inputField.name = formnameKey Then
                        key = settings.pformnameDict(formnameDictKey)(formnameKey)
                        Exit For
                    End If
                Next
            End If
            
            If key <> "" Then
                Exit For
            End If
        Next

        ' Get input value
        If TypeOf inputField Is TextBox Or TypeOf inputField Is ComboBox Then
            If inputField.value <> "" Then
                value = inputField.value
            End If
        ElseIf TypeOf inputField Is ListBox Then
            For i = 0 To inputField.ListCount - 1
                If inputField.Selected(i) Then
                    'If value <> "" Then
                    '    value = value & ";"
                    'End If

                    value = value & inputField.ItemData(i) & ";"
                End If
            Next
        ElseIf TypeOf inputField Is CheckBox Then
            If Not inputField.value = 0 Then
                value = inputField.value
            End If
        End If

        If key <> "" And value <> "" Then
            inputKeys.Add key
            inputValues.Add value
        End If
    Next

    ' Insert new and changed entries
    sqlInsert = "INSERT INTO " + duplicateInfoDict.Keys(0) + " ("
    sqlValues = "VALUES ("
    i = 0

    ' Add all new values
    If inputKeys.Count = inputValues.Count Then
        For Each inputKey In inputKeys
            i = i + 1

            sqlInsert = sqlInsert & "[" & inputKey & "]"
            sqlValues = sqlValues & "'" & inputValues(i) & "'"

            If i < inputKeys.Count Then
                sqlInsert = sqlInsert & ", "
                sqlValues = sqlValues & ", "
            End If
        Next
    Else
        Err.Raise vbObjectError + 1000, , "Key/Value count does not match!"
    End If

    sqlInsert = sqlInsert & ") "
    sqlValues = sqlValues & ") "

    If i > 0 Then
        Dim multiInsertQCollection As Collection

        ' Try to split into multiple SQL strings for multi-value fields
        Set multiInsertQCollection = GetMultiInsertQCollection(sqlInsert & sqlValues)

        For Each multiInsertQ In multiInsertQCollection
            Debug.Print multiInsertQ
            cnn.Execute multiInsertQ
        Next

        MsgBox "Daten wurden erfolgreich eingefügt!"

        regInput_Change
        ClearAllControls inputFields, context
        UpdateSaveButton context
    End If

    ' End all resources
    rs.Close
    Set rs = Nothing
    cnn.Close
    Set cnn = Nothing

    Exit Sub
Problem:
    MsgBox "Daten konnten nicht eingefügt werden! " & Err.Description
End Sub
