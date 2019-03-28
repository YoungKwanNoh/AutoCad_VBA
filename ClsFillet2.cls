VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ClsFillet2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private oldroad As AcadEntity
Private newroad As AcadEntity
Private fillet As AcadEntity

Private ptIntersection As Variant


Public Function load()

    Dim retArc As AcadEntity
    Dim tmp As Variant
    
    
    Dim np1 As New clsPoint
    Dim np2 As New clsPoint
    Dim np3 As New clsPoint
    
    Dim splitter As New clsSplitter
    Dim pr As New clsPolygonReader
    
    Dim newroadsplit() As Double
    Dim oldroadsplit() As Double
    Dim filletsplit() As Double
    
    Dim merge As New ClsMerger
    Dim resultd() As Double
    Dim test As Boolean
    
    Dim pt1 As New clsPoint
    Dim pt3 As New clsPoint
    
    
    Dim pr1 As New clsPolygonReader
    Dim pr2 As New clsPolygonReader
    
    Dim line1 As AcadLine
    Dim line2 As AcadLine
    Dim resultpl As AcadLine
    Dim ssetObj As AcadSelectionSet
    Dim result As AcadEntity

  
    Dim selec1 As New ClsSelEntity
    Dim selec2 As New ClsSelEntity
    
    
    Dim seler As New ClsSelReal
    Dim frad As Double
    
    Dim selecs As New clsSelSets
    
    selec1.selectPolyline ("Get Polyline 1: ")
    Set newroad = selec1.getEntity
    Set pt1 = selec1.getPoint
    
    selec2.selectPolyline ("Get Polyline 2: ")
    Set oldroad = selec2.getEntity
    Set pt3 = selec2.getPoint
    
    
    
    
    ptIntersection = searchCrossVertext(newroad, oldroad)
    
    Set np3 = getNearPoint2(ptIntersection, pt3)
    
    'addDonut5 pt1.x, pt1.y
    'addDonut5 pt3.x, pt3.y
    'addDonut5 np3.x, np3.y
    
    
    pr1.init newroad
    Set line1 = pr1.getLine(pt1)
    
     
    pr2.init oldroad
    Set line2 = pr2.getLine(pt3)
    
     
    
    Set resultpl = getShortestLine(line2, pt3, np3)
    
    
    frad = seler.selectReal
    
    
    'Application.ActiveDocument.SendCommand "_chamfer" & vbCr & "D" & vbCr & "1" & vbCr & "1" & vbCr & "(HandEnt """ & line1.Handle & """)" & vbCr & "(HandEnt """ & line2.Handle & """)" & vbCr
    Application.ActiveDocument.SendCommand "_fillet" & vbCr & "T" & vbCr & "N" & vbCr & "r" & vbCr & frad & vbCr & "(HandEnt """ & line1.Handle & """)" & vbCr & "(HandEnt """ & resultpl.Handle & """)" & vbCr
    
    
    Set retArc = selecs.selectArc
    
    'Set retArc = selectArcObj
    
    'Set ssetObj = ThisDrawing.ActiveSelectionSet
    '
    'ssetObj.Select acSelectionSetLast
    '
    'For Each ent In ssetObj
    '   Set retArc = ent
    'Next
    
    If line2.Handle <> resultpl.Handle Then
        resultpl.Delete
    End If
    
    line1.Delete
    line2.Delete
    
    
    
    Set fillet = arc2line(retArc)  '��ũ�� �������� ����
    filletsplit = fillet.Coordinates
    
    retArc.Delete
    
    
    Debug.Print "fillet created"
    
    
    ptIntersection = searchCrossVertext(newroad, oldroad)
    
    newp1 = findVertex(newroad, fillet)   '��ũ�� ����(������)�� ���� �߰�
    newp2 = findVertex(oldroad, fillet)   '��ũ�� ����(������)�� ���� �߰�
   
   
    np1.initXy newp1(0), newp1(1)
    np2.initXy newp2(0), newp2(1)
    
    
    Debug.Print "np1: " & np1.x & ", " & np1.y
    Debug.Print "np2: " & np2.x & ", " & np2.y
    
   
    Set np3 = getFarPoint2(ptIntersection, np2)     '�������� ��ũ �������� �� ������ ã�´�
    
    
    addVertex oldroad, np3.x, np3.y     '�������ο� �����߰�
    

    
    Debug.Print "cross point created"
    
    pr.init newroad
    pr.setIndexByPoint np1
    pr.checkDirection pt3
    
    'addDonut5 np3.x, np3.y
    'addDonut5 np1.x, np1.y
    Debug.Print "newroad direction processed"
    
    newroadsplit = pr.splitInnerLine(np3, np1)
    'addLine newroadsplit
 
    Debug.Print "newroad split created"
   
    pr.init oldroad
    pr.setIndexByPoint np2
    pr.checkDirection pt1
    
    Debug.Print "oldroad direction processed"
    
    oldroadsplit = pr.splitInnerLine(np2, np3)
    'addLine oldroadsplit
    
    
    
    Debug.Print "oldroad split created"
        
    size1 = UBound(newroadsplit)
    size2 = UBound(filletsplit)
    size3 = UBound(oldroadsplit)
    
    merge.setSize size1 + size2 + size3 + 2
    
    
    merge.add newroadsplit
    merge.add filletsplit
    merge.add oldroadsplit
    
    
    Set result = addLine(merge.getMerged)
    newroad.Delete
    fillet.Delete
    
    
    
    ThisDrawing.SendCommand "sob" & vbCr
    
    Set temp = ThisDrawing.ActiveLayer
    result.Layer = ThisDrawing.ActiveLayer.Name
    
    
End Function


Private Function getArcBy3P(p1() As Double, p2() As Double, p3() As Double) As AcadArc
    Dim centerPoint(0 To 2) As Double
    Dim retOjb As AcadArc
    
    x1 = p1(0)
    y1 = p1(1)
    
    x2 = p2(0)
    y2 = p2(1)
     
    x3 = p3(0)
    y3 = p3(1)
    
    d1 = (x2 - x1) / (y2 - y1)
    d2 = (x3 - x2) / (y3 - y2)
    
    cx = ((y3 - y1) + (x2 + x3) * d2 - (x1 + x2) * d1) / (2 * (d2 - d1))
    cy = -d1 * (cx - (x1 + x2) / 2) + (y1 + y2) / 2
     
    r = VBA.Sqr((x1 - cx) ^ 2 + (y1 - cy) ^ 2)
    
    centerPoint(0) = cx
    centerPoint(1) = cy
    
    StartAngle = ArcTan2((x1 - cx), (y1 - cy))
    EndAngle = ArcTan2((x3 - cx), (y3 - cy))
    
    If StartAngle >= 0 And EndAngle >= 0 Then
        If StartAngle > EndAngle Then
            tmp = StartAngle
            StartAngle = EndAngle
            EndAngle = tmp
        End If
    ElseIf StartAngle < 0 And EndAngle < 0 Then
        If StartAngle > EndAngle Then
            tmp = StartAngle
            StartAngle = EndAngle
            EndAngle = tmp
        End If
    ElseIf StartAngle > 0 And EndAngle < 0 Then
        If (PI - StartAngle) + (PI + EndAngle) > PI Then
            tmp = StartAngle
            StartAngle = EndAngle
            EndAngle = tmp
        End If
    ElseIf StartAngle < 0 And EndAngle > 0 Then
        If Abs(StartAngle) + EndAngle > PI Then
            tmp = StartAngle
            StartAngle = EndAngle
            EndAngle = tmp
        End If
            
    End If
    
    
    Set retOjb = ThisDrawing.ModelSpace.AddArc(centerPoint, r, StartAngle, EndAngle)
     
    
    Set getArcBy3P = retOjb

End Function



Private Function searchCrossVertext(src As AcadEntity, dst As AcadEntity) As Variant

    Dim size As Integer
    
    searchCrossVertext = src.IntersectWith(dst, acExtendOtherEntity)   'find vertex
    
End Function
 
