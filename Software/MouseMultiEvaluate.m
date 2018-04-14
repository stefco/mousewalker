function MouseMultiEvaluate(filename, outputfilename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function MouseMultiEvaluate(foldername, outputfilename)
%
% Evaluates multiple files with MouseEvaluate(handles,filename). 
%
% INPUT:
%    filename - ASCII file containing folder names in each row. Each folder
%    contains the analyzed data. Analyzed data should be within the folder
%    in <foldername>/Results/ 
%
%    outputfilename - file name specifying excel file where output will go.
%    if no outputfilename is given output will be saved to default file
%    'ResultSummary.xls'.
%
%
% (c) Imre Bartos, 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% choose default outpufilename if nothing is given. Otherwise put .xls to
% end of filename.
  if nargin < 2
      outputfilename = 'ResultSummary.xls';
  else
      if length(outputfilename > 4) & ~strcmp(outputfilename(end-3:end),'.xls')
        outputfilename = [outputfilename '.xls'];
      end;
  end;

% load file name list from filename
  fid = fopen(filename, 'r');
  
% read in files one by one  
  counter = 0;
  while 1
      line = fgetl(fid); % read in line
      % exit if there are no more lines
        if ~ischar(line) | length(line)<2,   break,   end; 

      % evaluate data in file name defined by line
%         try
          disp(['Evaluating data in ' line]);
          % convert folder format to compatible one
            line(line == '\') = '/';
            if line(end) ~= '/'
                line = [line '/'];
            end;
          % determine excel file name
            MatFileName = [line 'Results/MouseDataRecords.mat']
%             disp(['Evaluating ' MatFileName]);
          % evaluate file          
            MouseEvaluate(-1, MatFileName);
          % write summary of results to excel file
            % find mouse folders
              FolderList = dir([line 'Results/Mouse_*']);
            % loop over mice
              for j = 1:length(FolderList)
                % determine excel file name
                  % let user know if no excel file is found
                    if isempty(LS([line 'Results/' FolderList(j).name '/*.xls']))
                      disp(['Error! No excel file found in directory: ' line 'Results/' FolderList(j).name]);
                    end;
                  ExcelFileName = [line 'Results/' FolderList(j).name '/' LS([line 'Results/' FolderList(j).name '/*.xls'])];
                  disp(['  Reading data from ' ExcelFileName]);
                % read data
                  [num,txt,raw] = xlsread(ExcelFileName,'1.Info_Sheet', 'A40:AN41');
                % save data in matrix
                  counter = counter + 1;
                  % save header
                    if counter == 1
                        Data(1,:) = raw(1,:);
                        counter = counter + 1;
                    end;
                  Data(counter,:) = raw(2,:);     
              end;
%         catch ME
%           disp('Something went wrong with this file. Skipping...');
%         end;
  end;

  % save data in new excel file
    xlswrite(outputfilename, Data,'1');
  
  
  disp('Multi-evaluation done.');

return;