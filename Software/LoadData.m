function handles = LoadData(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = LoadData(handles)
%
% Load data for MouseWalker() given the directories of raw and
% processed data
%
% (c) Imre Bartos, 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Loading data...')
% Load Image
try
    % identify input frames folder name
      inputFolderName = get(handles.InputDirectory_edit,'String');
      % make sure inputFolderName ends with / or \
        inputFolderName = AddSlash(inputFolderName);
    % identify output data folder name
      outputFolderName = get(handles.OutputDirectory_edit,'String');
      % Substitute default folder name if nothing's given
        if strcmp(outputFolderName,'<default>') 
            outputFolderName = [AddSlash(inputFolderName) 'Results'];
        end
        % make sure results_directory_path ends with /
            outputFolderName = AddSlash(outputFolderName);
        % create results folder if it doesn't exist
          DoesFolderExist = exist(outputFolderName);
          if DoesFolderExist ~= 7
              % run window that asks whether to create folder
                handlespoutputfoldername = outputFolderName;
              % get gui handle
                hMouseTracker = getappdata(0,'hMouseTracker');
              % write data into gui handle that will be readable by the other file
                setappdata(hMouseTracker,'handlespoutputfoldername',handlespoutputfoldername);

              CreateFolderQuestion();
              waitfor(CreateFolderQuestion);
              CreateNewProcessedFolder = getappdata(hMouseTracker,'CreateNewProcessedFolder');            
              if CreateNewProcessedFolder == 0
                  return;
              end;
          end;

        % create Images folder if it doesn't exist
          imageFolderName = [outputFolderName 'Images' ];
          DoesFolderExist = exist(imageFolderName);
          if DoesFolderExist ~= 7
              mkdir(imageFolderName);
          end;

    % get current frame number
      FrameIndex  = str2num(get(handles.frame_edit,'String'));

catch ME
    % if there is an error with the file names return;
    disp('There was some error with loading data... [1]');
    return;
end

% Load results from automatic analysis
  resultsFileName = sprintf('%sMouseDataRecords.mat', outputFolderName);


% load saved data
  % initialize
    p = [];
    v = [];
  try
    % load data if there is saved data
      load(resultsFileName, 'p', 'v');
    % add parameters determined above to p
      p.inputFolderName = inputFolderName;
      p.outputFolderName = outputFolderName;
      p.imageFolderName = imageFolderName;      
      p.resultsFileName = resultsFileName;

    % Obtain list of frame files OR video from input folder  
      [p.FileList, p.VideoInput, p.VideoObject] = ReadInInputFiles(p.inputFolderName);
      
  catch ME
    disp('Need to initialize...');
    % initialize
      [v, p]                   = Initialization();
      
    % add parameters determined above to p
      p.inputFolderName  = inputFolderName;
      p.outputFolderName = outputFolderName;
      p.imageFolderName  = imageFolderName;
      p.resultsFileName  = resultsFileName;

    % Obtain list of frame files OR video from input folder  
      [p.FileList, p.VideoInput, p.VideoObject] = ReadInInputFiles(p.inputFolderName);
       
    % calculate background for filter
      [p.DPM, p.picMedian] = Masks(p); 

  end
  
% add parameters that were not present in older versions
  if ~isfield(p,'lengthbar'),       p.lengthbar = 0;        end;
  if ~isfield(p,'FixedBodyLength'), p.FixedBodyLength = -1; end;
  
% save what we have so far
  save(p.resultsFileName, 'p', 'v');

% update window title so it now includes the name of the folder the data is in.
  WindowTitle = ['MouseWalker  -  ' p.inputFolderName '   -   ' num2str(length(p.FileList)) ' frames'];
  set(gcf,'Name',WindowTitle);
  
% write number of frames in window
  set(handles.frame_panel,'Title',['Select Frame   /   ' num2str(length(p.FileList)) ' frames']);
      
% set up slider to the right scale   
  set(handles.frame_slider,'Min', 1);
  set(handles.frame_slider,'Max', length(p.FileList));

% set up mousenumber_popupmenu to have the number of mice available
  set(handles.mousenumber_popupmenu, 'String', num2cell(1:max(1,v.MouseTrack.NumberOfMice)));
  set(handles.mousenumber_popupmenu, 'Value', 1);
% save backup
  handles.pbackup = p;
  handles.vbackup = v;

% save parameters and variables
  handles.v = v;
  handles.p = p;
  
% go back to frame 1 for new video
  set(handles.frame_edit,'String',num2str(1));

% plot results to image_axes
  handles = PlotMouse(handles);  
  
% disp successful load  
  disp('Load complete.')


% set(handles.ellipse_checkbox,'Value',handles.p.ellipse);
% set(handles.bodytrack_checkbox,'Value',handles.p.drawbodytrack);



return;
