function SaveResults(v,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function SaveResults(v,p)
%
% Save results and parameters for later use.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define filename where results should be saved
  if strcmp(p.outputFolderName, '<default>')
    FileName = [AddSlash(p.inputFolderName) 'Results/' 'MouseDataRecords.mat'];
  else
    FileName = [AddSlash(p.outputFolderName) 'MouseDataRecords.mat'];
  end;
% clear variables that we don't want to save
  clear v.pic;  
  
% save results
  save(FileName, 'v', 'p');

return