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

% LEG PLOTS
% Error using matlab.graphics.internal.name (line 101)
% Cannot create output file 'C:/Users/Nina/Desktop/test case - xls/Results/Mouse_1/Leg_Distance_test case - xls.png'.

% Error in print (line 71)
% pj = matlab.graphics.internal.name( pj );

% Error in saveas (line 181)
%         print( h, name, ['-d' dev{i}] )

% Error in MouseEvaluate>PlotResults (line 3942)
% saveas(h,outputfilename,'png');
