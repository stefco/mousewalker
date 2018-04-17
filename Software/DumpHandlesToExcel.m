function DumpHandlesToExcel(resultsFileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function DumpHandlesToExcel(handles)
%
% Read the "v" and "p" structs from "resultsFileName" and feed them to
% "MouseEvaluate", which will process the data and save it to an Excel file.
% Read "MouseWalker" to see what the "v" and "p" fields, which ordinarily
% belong to a "handle" struct ("handle.v" and "handle.p"), represent.
%
% (c) Stefan Countryman, Nina Moiseiwitsch 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handles = load(resultsFileName);

[outputFolderName, name, ext] = fileparts(resultsFileName);
% check whether the file is in the current folder, in which case
% outputFolderName will be a 0x0 empty logical array.
if length(outputFolderName) == 0
    outputFolderName = pwd();
else
    oldDir = pwd();
    cd(outputFolderName);
    outputFolderName = pwd();
    cd(oldDir);
end
resultsFileName = fullfile(outputFolderName, [name ext]);
[inputFolderName, name, ext] = fileparts(outputFolderName);
imageFolderName = fullfile(outputFolderName, 'Images');

handles.p.outputFolderName = outputFolderName;
handles.p.resultsFileName = resultsFileName;
handles.p.inputFolderName = inputFolderName;
handles.p.imageFolderName = imageFolderName;

MouseEvaluate(handles);
