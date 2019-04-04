Attribute VB_Name = "ModInit"
Public Const SHOW_CIRCLE = False

Public Const P2P_TOL = 100    ' 1~100: 1 ------100 �ΰ�
Public Const PD_TOL = 0.1     ' 0.1~1: �ΰ� 0.1 ------ 1
Public Const FAR_OVER = 10    '������ �������ε� ���� �ָ� ��������츦 ã�� skip. () <- �̷����


Public Const KEY_TOL = "userr1"
Public Const KEY_RAD = "userr2"
Public Const KEY_CHA = "userr3"
Public Const DEF_TOL = 0.1
Public Const DEF_RAD = 3
Public Const DEF_CHA = 3


Public Const LYR_ADD = "!!�߰�_"
Public Const LYR_DEL = "!!����_"



Public Function initConstant()

    Dim tol As Double
    Dim rad As Double
    
    tol = ThisDrawing.GetVariable(KEY_TOL)
    rad = ThisDrawing.GetVariable(KEY_RAD)


    If tol = 0 Then
        tol = DEF_TOL
        ThisDrawing.SetVariable KEY_TOL, tol
    End If


    If rad = 0 Then
        rad = DEF_RAD
        ThisDrawing.SetVariable KEY_RAD, rad
    End If


End Function


Public Function setDefaultFilletRadius(rad As Double)

    ThisDrawing.SetVariable KEY_RAD, rad

End Function

Public Function getDefaultFilletRadius() As Double

    Dim rad As Double
    rad = ThisDrawing.GetVariable(KEY_RAD)
    
    If rad = 0 Then
        rad = DEF_RAD
        ThisDrawing.SetVariable KEY_RAD, rad
    End If
    
    getDefaultFilletRadius = rad
    
End Function


Public Function setDefaultTolerance(tol As Double)

    ThisDrawing.SetVariable KEY_TOL, tol

End Function


Public Function getDefaultTolerance()

    Dim tol As Double
    tol = ThisDrawing.GetVariable(KEY_TOL)
   
    If tol = 0 Then
        tol = DEF_TOL
        ThisDrawing.SetVariable KEY_TOL, tol
    End If

    getDefaultTolerance = tol
    
End Function


Public Function setDefaultChamferDistance(cd As Double)

    ThisDrawing.SetVariable KEY_CHA, cd

End Function


Public Function getDefaultChamferDistance()

    Dim cd As Double
    cd = ThisDrawing.GetVariable(KEY_CHA)
   
    If cd = 0 Then
        cd = DEF_CHA
        ThisDrawing.SetVariable KEY_CHA, cd
    End If

    getDefaultChamferDistance = cd
    
End Function

