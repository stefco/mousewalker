function FolderName = AddSlash(FolderName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function FolderName = AddSlash(FolderName)
%
% Put slash ('/' or '\') to the end of a folder name if it's not there
% already. Determine which one to put there based on what else is in the
% folder name.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if FolderName(end) ~= '/' &  FolderName(end) ~= '\'
  ind = find(FolderName=='/' | FolderName=='\');
  if ~isempty(ind)
    FolderName = [FolderName FolderName(ind(end))];
  else
    FolderName = [FolderName '/'];
  end;    
end;



return;