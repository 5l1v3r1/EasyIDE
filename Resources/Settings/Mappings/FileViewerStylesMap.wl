(* ::Package:: *)

{
  FrontEnd`FileName[{___}, 
    _String?(StringEndsQ["-CodePackage.nb"]),
    ___
    ]:>
    FrontEnd`FileName[{"EasyIDE", "Extensions"},
      "FileViewer-CodePackage.nb"
      ]
}