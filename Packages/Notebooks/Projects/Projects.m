(* ::Package:: *)

(* Autogenerated Package *)

NewProjectFile::usage="Makes a new project file in the IDE";
SaveProjectFileAs::usage="Moves a project file to a new name";
SetProjectDirectory::usage="Sets the project directory for a notebook";


CreateProjectScratchFile::usage="Creates a scratch file for the project";


IDESetDirectory::usage="Same but for IDE";
EnsureIDEProject::usage="";


Begin["`Private`"];


(* ::Subsection:: *)
(*Project*)



(* ::Subsubsection::Closed:: *)
(*getIDETitleBar*)



getIDETitleBar[dir_]:=
  "EasyIDE: ``"~TemplateApply~FileBaseName[dir];


(* ::Subsubsection::Closed:: *)
(*NewProjectFile*)



NewProjectFile//Clear
NewProjectFile[nb_, fileName_String?(Not@*DirectoryQ)]:=
  Module[{fn=IDEPath[nb, fileName]},
    If[!FileExistsQ[fn], CreateFile[fn]];
    IDEOpen[nb, fn];
    ];
NewProjectFile[nb_, dir_String?DirectoryQ]:=
  Module[{f = SystemDialogInput["FileSave", dir, WindowTitle->"New file"]},
    NewProjectFile[nb, f]
    ];
NewProjectFile[nb_]:=
  NewProjectFile[nb, IDEPath[nb]]


(* ::Subsubsection::Closed:: *)
(*SaveProjectFileAs*)



SaveProjectFileAs//Clear
SaveProjectFileAs[nb_, file1_String?(FileExistsQ), fileName_String?(Not@*DirectoryQ)]:=
  Module[{tabs = IDEData[nb, "Tabs"], newTabName, fileHavingTab},
    Replace[
      RenameFile[file1, fileName],
      s_String:>(
        fileHavingTab = 
          SelectFirst[tabs, 
            Quiet[
              ExpandFileName@Lookup[#[[2]], "File"]==
                ExpandFileName@file1
              ]&
            ];
        If[!MissingQ[fileHavingTab],
          newTabName = GetFileTabName[nb, fileName];
          IDEData[nb, "Tabs"] = 
            Replace[tabs, 
              fileHavingTab:>(
                newTabName->
                  Replace[fileHavingTab[[2]], ("File"->_):>("File"->fileName), 1]
                ),
              1
              ];
          If[IDEData[nb, "ActiveTab"] == fileHavingTab[[1]],
            IDEData[nb, "ActiveTab"] = newTabName
            ]
          ]
        )
      ]
    ];
SaveProjectFileAs[nb_, file_String?(FileExistsQ)]:=
  Module[
    {
      f,
      p = IDEPath[nb]
      },
    If[StringStartsQ[ExpandFileName@file, ExpandFileName@p],
      p=DirectoryName[file]
      ];
    f = SystemDialogInput["FileSave", p, WindowTitle->"New name"];
    SaveProjectFileAs[nb, file, f]
    ];


(* ::Subsubsection::Closed:: *)
(*SetProjectDirectory*)



SetProjectDirectory[nb_, dir_]:=
  If[(StringQ[dir]&&DirectoryQ[dir]),
    IDEData[nb, {"Project", "Directory"}] = dir;
    SetOptions[nb, WindowTitle->getIDETitleBar[dir]];
    ];


(* ::Subsubsection::Closed:: *)
(*CreateProjectScratchFile*)



CreateProjectScratchFile[
  expr_, 
  loc:_String?DirectoryQ:$TemporaryDirectory,
  name:_String:"scratch"
  ]:=
  Module[{file=FileNameJoin@{loc, StringTrim[name, ".nb"]<>".nb"}},
    If[FileExistsQ[file],
      file=FileNameJoin@{
        loc, 
        StringTrim[name, ".nb"]<>"-m"<>ToString[RandomInteger[{1000, 9999}]]<>".nb"
        }
      ];
    Export[file, expr]
    ];
CreateProjectScratchFile[
  nb_NotebookObject, 
  expr_, 
  loc:_String:".scratch",
  name:_String:"scratch"
  ]:=
  Module[{d=FileNameJoin@{ExpandFileName@IDEPath[nb], loc}},
    If[!DirectoryQ[d], CreateDirectory[d]];
    CreateProjectScratchFile[expr, d, name]
    ];


(* ::Subsection:: *)
(*IDE*)



(* ::Subsubsection::Closed:: *)
(*EnsureIDEProject*)



EnsureIDEProject[nb_]:=
  Module[{p=IDEPath[nb]},
    If[!(StringQ[p]&&DirectoryQ[p]),
      PreemptiveQueued[
        nb,
        p = 
          SystemDialogInput[
            "Directory",
            $HomeDirectory,
            WindowTitle->"IDE Directory"
            ];
        SetProjectDirectory[nb, p]
        ]
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*IDESetDirectory*)



IDESetDirectory[nb_NotebookObject, dir_]:=
  SetProjectDirectory[nb, dir];
IDESetDirectory[ide_IDENotebookObject, dir_]:=
  IDESetDirectory[ide["Notebook"], dir];


End[];



