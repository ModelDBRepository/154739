function h=LoadDataFig(MainFig,varargin)
% Optional arguments can be a string with a filename of a preset file, 
% which initiates direct loading of this preset.

h = figure('Units','pixels',...
			'Position',[150 100 700 450],...
			'Resize','off',...
			'NumberTitle','off',...
			'Menubar','none',...
			'Toolbar','none',...
			'Name','Data loader',...
            'CloseRequestFcn',@Close);

handles.MainFig = MainFig;

% File menu
handles.mnFile = uimenu('Parent',gcf,...
                        'Label','File');
handles.mnLoadData = uimenu('Parent',handles.mnFile,...
                            'Label','Load settings',...
                            'Callback',@mnLoadSetFile_Callback);
handles.mnSaveData = uimenu('Parent',handles.mnFile,...
                            'Label','Save settings',...
                            'Callback',@mnSaveSetFile_Callback);
handles.mnClose = uimenu('Parent',handles.mnFile,...
                            'Label','Close',...
                            'Callback',@Close);


% Define listbox at left for control
handles.lstCategories = uicontrol('Style','list',...
									'Units','pixels',...
									'Position',[25 95 150 315],...
									'BackgroundColor',[1 1 1],...
									'Callback',@lstCategories_Callback);

handles.btnOk = uicontrol('Style','pushbutton',...
							'Units','pixels',...
							'Position',[45 60 110 20],...
							'String','Ok',...
							'HorizontalAlignment','center',...
							'Callback', @SaveClose);

handles.btnCancel = uicontrol('Style','pushbutton',...
								'Units','pixels',...
								'Position',[45 25 110 20],...
								'String','Cancel',...
								'HorizontalAlignment','center',...
								'Callback', @Close);

% ==== Celltypes tab
handles.pnlCellTypes = uibuttongroup('Units','pixels',...
										'Position',[200 25 475 400],...
										'BackgroundColor',get(gcf,'Color'),...
										'Title','Neuron properties',...
										'SelectionChangeFcn',@pnlTab_Callback);

% --- Radio group No differentation
handles.rdoNeuronsNoDiff = uicontrol('Parent',handles.pnlCellTypes,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 340 200 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','No distinction',...
										'HorizontalAlignment','left');

handles = AddGroup2Tab(handles, handles.rdoNeuronsNoDiff, []);

% --- Radio group Differentiation
handles.rdoNeuronsDiff = uicontrol('Parent',handles.pnlCellTypes,...
									'Style','radiobutton',...
									'Units','pixels',...
									'Position',[20 310 200 20],...
									'BackgroundColor',get(gcf,'Color'),...
									'String','Multiple types',...
									'HorizontalAlignment','left');

% uitable is unsupported for matlabd r2007 and older
if(verlessthan('matlab','7.6'))
    handles.lblError = uicontrol('Parent',handles.pnlCellTypes,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[30 180 380 100],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String',{'This version of Matlab does not support a usertable.',...
                                        'Please upgrade to version R2008 or newer.',...
                                        '',...
                                        'Changes can still be made by modifying DefaultCellTypes.mat',...
                                        'and restarting Skuld'});

	handles.grpNeuronsDiff = handles.lblError;
                               
else                                    
    handles.tblCellTypes = uitable('Parent',handles.pnlCellTypes,...
                                    'Units','pixels',...
                                    'Position',[30 155 380 135],...
									'ColumnFormat',{'logical','char','numeric',{'-','E','I'},'char','char'},...
									'ColumnName',{'Show','Name','#','E/I','Symbol','Color'},...
									'ColumnWidth',{40,60,40,40,50,80},...
									'ColumnEditable',logical([1 1 1 1 1 1]),...
									'Data',cell(0,6));

	handles.btnAddCellType = uicontrol('Parent',handles.pnlCellTypes,...
										'Style','pushbutton',...
										'Units','pixels',...
										'Position',[135 125 80 20],...
										'String','Add',...
										'HorizontalAlignment','center',...
										'Callback', @btnAddCellType_Callback);

	handles.btnRemCellType = uicontrol('Parent',handles.pnlCellTypes,...
										'Style','pushbutton',...
										'Units','pixels',...
										'Position',[225 125 80 20],...
										'String','Remove',...
										'HorizontalAlignment','center',...
										'Callback', @btnRemCellType_Callback);

	handles.grpNeuronsDiff = [handles.tblCellTypes, handles.btnAddCellType, handles.btnRemCellType];
end                            

handles = AddGroup2Tab(handles, handles.rdoNeuronsDiff, handles.grpNeuronsDiff);

% === Positions tab
handles.pnlPositions = uibuttongroup('Units','pixels',...
										'Position',[200 25 475 400],...
										'BackgroundColor',get(gcf,'Color'),...
										'Title','Neuron positions',...
										'SelectionChangeFcn',@pnlTab_Callback);

% --- Radio group File
handles.rdoPositionsFile = uicontrol('Parent',handles.pnlPositions,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 340 200 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','Positions from file',...
										'HorizontalAlignment','left');

[handles, Objects1, handles.FilePathCllPosId] = MakeFileSelector(handles,handles.pnlPositions,'CellPositions.nwk',[30 290]);

handles.grpPositionsFile = Objects1;

handles = AddGroup2Tab(handles, handles.rdoPositionsFile, handles.grpPositionsFile);

% --- Radio group Structured
handles.rdoPositionsStrc = uicontrol('Parent',handles.pnlPositions,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 250 200 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','Structured positions',...
										'HorizontalAlignment','left');

handles = AddGroup2Tab(handles, handles.rdoPositionsStrc, []);

% --- Radio group Structured
handles.rdoPositionsRand = uicontrol('Parent',handles.pnlPositions,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 220 200 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','Random positions',...
										'HorizontalAlignment','left');

handles = AddGroup2Tab(handles, handles.rdoPositionsRand, []);



% ==== Network tab
handles.pnlNetwork = uibuttongroup('Units','pixels',...
									'Position',[200 25 475 400],...
									'BackgroundColor',get(gcf,'Color'),...
									'Title','Network properties',...
									'SelectionChangeFcn',@pnlTab_Callback);

% --- Radio group No Network
handles.rdoNetworkNone = uicontrol('Parent',handles.pnlNetwork,...
									'Style','radiobutton',...
									'Units','pixels',...
									'Position',[20 340 200 20],...
									'BackgroundColor',get(gcf,'Color'),...
									'String','No connectivity',...
									'HorizontalAlignment','left');

handles = AddGroup2Tab(handles, handles.rdoNetworkNone, []);

% --- Radio group Network NeuroSim
handles.rdoNetworkNeuroSim = uicontrol('Parent',handles.pnlNetwork,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 310 100 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','Verdandi',...
										'HorizontalAlignment','left');

[handles, Objects1, handles.FilePathConCntId] = MakeFileSelector(handles,handles.pnlNetwork,'ConnectionCount',[30 260]);
[handles, Objects2, handles.FilePathConLstId] = MakeFileSelector(handles,handles.pnlNetwork, 'ConnectionList',[30 210]);

handles.popConLstFormat = uicontrol('Parent',handles.pnlNetwork,...
                                    'Style','popupmenu',...
                                    'Units','pixels',...
                                    'Position',[30 175 180 20],...
                                    'String',{'Native format','Big-endian','Little-endian (x86)', 'ASCII'},...
                                    'HorizontalAlignment','left',...
                                    'Value',1);

handles.grpNetworkNeuroSim = [Objects1, Objects2, handles.popConLstFormat];

handles = AddGroup2Tab(handles, handles.rdoNetworkNeuroSim, handles.grpNetworkNeuroSim);

% --- Radio group Connection Matrix
handles.rdoNetworkMatrix = uicontrol('Parent',handles.pnlNetwork,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 135 200 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','Connectivity matrix',...
										'HorizontalAlignment','left');

[handles, handles.grpNetworkMatrix, handles.FilePathConMatId] = MakeFileSelector(handles,handles.pnlNetwork, 'Matrix file',[30 85]);

handles = AddGroup2Tab(handles, handles.rdoNetworkMatrix, handles.grpNetworkMatrix);

% === Spike data tab
handles.pnlSpikeData = uibuttongroup('Units','pixels',...
										'Position',[200 25 475 400],...
										'BackgroundColor',get(gcf,'Color'),...
										'Title','Spike data',...
										'SelectionChangeFcn',@pnlTab_Callback);

handles.rdoSpikeDataNone = uicontrol('Parent',handles.pnlSpikeData,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 340 200 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','No spike data',...
										'HorizontalAlignment','left');

handles = AddGroup2Tab(handles, handles.rdoSpikeDataNone, []);

% --- Radio group Membrane potentials
handles.rdoSpikeDataVm = uicontrol('Parent',handles.pnlSpikeData,...
									'Style','radiobutton',...
									'Units','pixels',...
									'Position',[20 310 200 20],...
									'BackgroundColor',get(gcf,'Color'),...
									'String','Membrane potentials',...
									'HorizontalAlignment','left');

[handles, Objects1, handles.FilePathVmId] = MakeFileSelector(handles,handles.pnlSpikeData, 'Vm.dat',[30 260]);
[handles, Objects2, handles.NumberSampRateVm] = MakeNumberBox(handles,handles.pnlSpikeData,'Sampling rate (Hz)',[30 225]);
[handles, Objects3, handles.NumberDurationVm] = MakeNumberBox(handles,handles.pnlSpikeData,'Duration (s)',[30 200]);
[handles, Objects4, handles.NumberThresVm] = MakeNumberBox(handles,handles.pnlSpikeData,'Spike threshold',[30 175]);

handles.grpSpikeDataVm = [Objects1, Objects2, Objects3, Objects4];

handles = AddGroup2Tab(handles, handles.rdoSpikeDataVm, handles.grpSpikeDataVm);

% --- Radio group Spike times
handles.rdoSpikeDataSpkTms = uicontrol('Parent',handles.pnlSpikeData,...
										'Style','radiobutton',...
										'Units','pixels',...
										'Position',[20 135 200 20],...
										'BackgroundColor',get(gcf,'Color'),...
										'String','Spike times',...
										'HorizontalAlignment','left');

[handles, Objects1, handles.FilePathSpkTmsId] = MakeFileSelector(handles,handles.pnlSpikeData, 'File',[30 85]);
[handles, Objects2, handles.SpkTmsNumberColumnTime] = MakeNumberBox(handles,handles.pnlSpikeData, 'Time column',[30 50]);
[handles, Objects3, handles.SpkTmsNumberColumnNeur] = MakeNumberBox(handles,handles.pnlSpikeData, 'Cell column',[30 25]);
handles.chkSpkTmsOffset = uicontrol('Parent',handles.pnlSpikeData,...
                                    'Style','checkbox',...
                                    'Units','pixels',...
                                    'Position',[250, 27, 200 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Contains ID 0',...
                                    'HorizontalAlignment','left');

handles.grpSpikeDataSpkTms = [Objects1, Objects2, Objects3, handles.chkSpkTmsOffset];

handles = AddGroup2Tab(handles, handles.rdoSpikeDataSpkTms, handles.grpSpikeDataSpkTms);

% === EEG data tab
handles.pnlEEGData = uibuttongroup('Units','pixels',...
									'Position',[200 25 475 400],...
									'BackgroundColor',get(gcf,'Color'),...
									'Title','EEG/LFP data',...
									'SelectionChangeFcn',@pnlTab_Callback);

handles.rdoEEGDataNone = uicontrol('Parent',handles.pnlEEGData,...
									'Style','radiobutton',...
									'Units','pixels',...
									'Position',[20 340 200 20],...
									'BackgroundColor',get(gcf,'Color'),...
									'String','No EEG data',...
									'HorizontalAlignment','left');

handles = AddGroup2Tab(handles, handles.rdoEEGDataNone, []);

% --- Radio group Membrane potentials
handles.rdoEEGDataIm = uicontrol('Parent',handles.pnlEEGData,...
									'Style','radiobutton',...
									'Units','pixels',...
									'Position',[20 310 200 20],...
									'BackgroundColor',get(gcf,'Color'),...
									'String','Transmembrane currents',...
									'HorizontalAlignment','left');

[handles, Objects1, handles.FilePathImId] = MakeFileSelector(handles,handles.pnlEEGData, 'Im.dat',[30 260]);
[handles, Objects2, handles.NumberSampRateIm] = MakeNumberBox(handles,handles.pnlEEGData,'Sampling rate (Hz)',[30 225]);
[handles, Objects3, handles.NumberDurationIm] = MakeNumberBox(handles,handles.pnlEEGData,'Duration (s)',[30 200]);
[handles, Objects4, handles.NumberNumNeurIm] = MakeNumberBox(handles,handles.pnlEEGData,'Number of neurons',[30 175]);

handles.grpEEGDataIm = [Objects1, Objects2, Objects3, Objects4];

handles = AddGroup2Tab(handles, handles.rdoEEGDataIm, handles.grpEEGDataIm);

% --- Radio group Time series
handles.rdoEEGDataEEG = uicontrol('Parent',handles.pnlEEGData,...
									'Style','radiobutton',...
									'Units','pixels',...
									'Position',[20 135 200 20],...
									'BackgroundColor',get(gcf,'Color'),...
									'String','Time series',...
									'HorizontalAlignment','left');

[handles, Objects1, handles.FilePathEEGId] = MakeFileSelector(handles,handles.pnlEEGData, 'EEG.dat',[30 85]);
[handles, Objects2, handles.NumberSampRateEEG] = MakeNumberBox(handles,handles.pnlEEGData,'Sampling rate (Hz)',[30 50]);
[handles, Objects3, handles.NumberDurationEEG] = MakeNumberBox(handles,handles.pnlEEGData,'Duration (s)',[30 25]);

handles.grpEEGDataEEG = [Objects1, Objects2, Objects3];

handles = AddGroup2Tab(handles, handles.rdoEEGDataEEG, handles.grpEEGDataEEG);


handles.Categories.Names = {'Neurons','Positions','Network','Spike data','EEG/LFP data'};
handles.Categories.Panels = [handles.pnlCellTypes, handles.pnlPositions, handles.pnlNetwork, handles.pnlSpikeData, handles.pnlEEGData];
for iPanel = 1:length(handles.Categories.Panels)
	handles = SelectRadio(handles,iPanel,1);
end

MainHandles = guidata(handles.MainFig);
if(isfield(MainHandles,'Settings'))
    handles = LoadPreset(handles,MainHandles.Settings,0);
end



guidata(h,handles);
set(handles.lstCategories,'String',handles.Categories.Names,'Value',1);
CategorySelected(handles,1);

if(~isempty(varargin))
    LoadPresetFromFile(h,varargin{1});
end


% Navigation and option selection
function lstCategories_Callback(hObject, eventdata, handles)
handles = guidata(gcbf);
CategorySelected(handles, get(handles.lstCategories,'Value'));

function CategorySelected(handles, Id)
% Turn all tabs invisible and make selected tab visible again
set(handles.Categories.Panels,'Visible','off');
set(handles.Categories.Panels(Id),'Visible','on');

function handles = AddGroup2Tab(handles, Radio, Group)
% This function adds a radiobutton and corresponding group to a struct
if(isfield(handles,'Tab'))
	Id = find([handles.Tab(:).Panel]==get(Radio,'Parent'));
	if(~isempty(Id))
		% Add Group to existing tab
		nRadio = length(handles.Tab(Id).Radio);
		handles.Tab(Id).Radio(nRadio+1) = Radio;
		handles.Tab(Id).Group{nRadio+1} = Group;
	else
		% Add new tab
		nTab = length(handles.Tab);
		handles.Tab(nTab+1).Panel = get(Radio,'Parent');
		handles.Tab(nTab+1).Radio(1) = Radio;
		handles.Tab(nTab+1).Group{1} = Group;
	end
else
	% Make Tab struct
	handles.Tab(1).Panel = get(Radio,'Parent');
	handles.Tab(1).Radio(1) = Radio;
	handles.Tab(1).Group{1} = Group;
end

function pnlTab_Callback(source, eventdata)
% Funcion called when a radiobutton is changed. 
handles = guidata(gcbf);
TabId = find([handles.Tab(:).Panel]==source);
RadioId = find([handles.Tab(TabId).Radio(:)]==eventdata.NewValue);
handles = SelectRadio(handles, TabId, RadioId);
guidata(gcbf,handles);

function handles = SelectRadio(handles, TabId, RadioId)
% Set the correct radio button to active
set(handles.Tab(TabId).Panel,'SelectedObject',handles.Tab(TabId).Radio(RadioId));

% Set enable field of all groups on the tab
Groups = [handles.Tab(TabId).Group{:}];
set(Groups,'Enable','off');
set(handles.Tab(TabId).Group{RadioId},'Enable','on');

handles.RadioSelected(TabId) = RadioId;

% File Selectors
function [handles, ObjectHandles, Id] = MakeFileSelector(handles, Parent, Label, Pos)
% This function adds a typical file selector to the figure FigHandle with a given Parent (either figure or panel).
% The fileselector contains a label for the description, a textbox for the filepath and a button to browse files.
% The automated functions ensure proper operation of the browse buttons etc.

% Make the three required elements: label, textbox and button.
% Link objects to generic callback function that identify the object again
temp.lbl = uicontrol('Parent',Parent,...
						'Style','text',...
						'Units','pixels',...
						'Position',[(Pos+[20, 20]), 150, 20],...
						'BackgroundColor',get(gcf,'Color'),...
						'String',Label,...
						'HorizontalAlignment','left');
temp.txt = uicontrol('Parent',Parent,...
						'Style','edit',...
						'Units','pixels',...
						'Position',[(Pos+[0, 0]), 300, 24],...
						'BackgroundColor',[1 1 1],...
						'HorizontalAlignment','left',...
						'Callback',@txtFileSelector_Callback);
temp.btn = uicontrol('Parent',Parent,...
						'Style','pushbutton',...
						'Units','pixels',...
						'Position',[(Pos+[308, 2]), 70, 20],...
						'String','Browse',...
						'HorizontalAlignment','center',...
						'Callback',@btnFileSelector_Callback);
ObjectHandles = [temp.lbl, temp.txt, temp.btn];

temp.Path = '';	% Initial directory is set to current directory
temp.PathValid = 0;
temp.PathChanged = 0;

% Add this FileSelector to the list of others. Check first if the list is already defined
if(isfield(handles,'FileSelector'))
	Id = length(handles.FileSelector)+1;
	handles.FileSelector(Id) = temp;
else
	Id = 1;
	handles.FileSelector = temp;
end

function handles = SetFileSelector(handles,SelectorId,Path)
% Function sets a path to a certain FileSelector
hObject = handles.FileSelector(SelectorId).txt;
set(hObject,'String',Path);
% Check path and set flags accordingly
if (exist(Path)==2)
    handles.FileSelector(SelectorId).Path = Path;
    handles.FileSelector(SelectorId).PathValid = 1;
    set(hObject,'ForeGroundColor',[0 0 0]);
else
    set(hObject,'ForeGroundColor',[1 0 0]);
    handles.FileSelector(SelectorId).PathValid = 0;
end

function txtFileSelector_Callback(hObject, eventdata, handles)
% This function gets called when a textfield of a FileSelector is edited.
% It checks whether the entered file exists or not and flags are set accordingly
handles=guidata(gcbf);

% Find Id of this selector in the handles.FileSelector
temp = [handles.FileSelector(:).txt];
Id = find(temp==hObject);

% Check path and set flags
Path = get(hObject,'String');
handles = SetFileSelector(handles,Id,Path);
handles.FileSelector(Id).PathChanged = 1;
guidata(gcbf,handles);

function btnFileSelector_Callback(hObject, eventdata, handles)
% This function gets called when the browse button of a FileSelector is clicked
% It pops up a file selector window and it processes the data accordingly
handles=guidata(gcbf);

% Find Id of this selector in the handles.FileSelector
temp = [handles.FileSelector(:).btn];
Id = find(temp==hObject);

F = handles.FileSelector(Id).Path;
% Determine the directory in which the browser should start
if(exist(F) == 2)
    % Existing file: point to directory of file
    Dir = fileparts(F);
elseif(exist(F) == 7)
    % F is a folder, use this:
    Dir = F;
else
    % In all other cases, use current directory:
    Dir = pwd;
end
% Open dialog for file selection
[FileName,PathName,FilterIndex] = uigetfile({'*.txt;*.nwk;*.dat;*.mat','Data files (*.txt, *.nwk, *.dat, *.mat)';...
												'*.*','All Files (*.*)'},...
												'Locate file',[Dir filesep]);

% If a file is selected
if(PathName~=0)
    handles.FileSelector(Id).Path = [PathName FileName];
    % The delsected file is valid:
    handles.FileSelector(Id).PathValid = 1;
    handles.FileSelector(Id).PathChanged = 1;
    set(handles.FileSelector(Id).txt,'String',handles.FileSelector(Id).Path,'ForeGroundColor',[0 0 0]);
    guidata(gcbf,handles);
end

% Number boxes
function [handles, ObjectHandles, Id] = MakeNumberBox(handles, Parent, Label, Pos)
% This function adds a typical textbox for numbers to the figure FigHandle with a given Parent (either figure or panel).
% The NumberBox contains a label for the description and a textbox for the input
% The automated functions ensure proper operation of the callback options

% Make the two required elements: label and textbox
% Link objects to generic callback function that identify the object again
temp.lbl = uicontrol('Parent',Parent,...
						'Style','text',...
						'Units','pixels',...
						'Position',[Pos, 150, 20],...
						'BackgroundColor',get(gcf,'Color'),...
						'String',Label,...
						'HorizontalAlignment','left');
temp.txt = uicontrol('Parent',Parent,...
						'Style','edit',...
						'Units','pixels',...
						'Position',[(Pos+[120, 0]), 80, 24],...
						'BackgroundColor',[1 1 1],...
						'HorizontalAlignment','left',...
						'Callback',@txtNumberBox_Callback);

ObjectHandles = [temp.lbl, temp.txt];

temp.Value = [];
temp.ValueChanged = 0;

% Add this NumberBox to the list of others. Check first if the list is already defined
if(isfield(handles,'NumberBox'))
	Id = length(handles.NumberBox)+1;
	handles.NumberBox(Id) = temp;
else
	Id = 1;
	handles.NumberBox = temp;
end

function handles = SetNumberBox(handles, BoxId, Value)
% Sets the value of a NumberBox
set(handles.NumberBox(BoxId).txt,'String',num2str(Value));
handles.NumberBox(BoxId).Value = Value;

function txtNumberBox_Callback(hObject, eventdata, handles)
% This function gets called when a NumberBox is edited.
% It checks whether the entered input is valid or not and flags are set accordingly
handles=guidata(gcf);

% Find Id of this element in the handles.NumberBox
temp = [handles.NumberBox(:).txt];
Id = find(temp==hObject);

% Check input and set flags
Str = get(hObject,'String');
if(~isempty(Str))
	Val = str2double(Str);
	if(~isnan(Val))
		handles.NumberBox(Id).Value = Val;
		handles.NumberBox(Id).ValueChanged=1;
	else
		set(hObject,'String',handles.NumberBox(Id).Value);
	end
else
	handles.NumberBox(Id).Value = [];
	handles.NumberBox(Id).ValueChanged=1;
end

guidata(gcf,handles);

% Cell type table functions
function btnAddCellType_Callback(hObject, eventdata, handles)
% This function adds a line to uitable that contains the celltypes
handles=guidata(gcbo);

CellTypes = get(handles.tblCellTypes,'Data');
CellTypes(end+1,1:6) = {true,'New',0,'-','o','[0 0 0]'};
set(handles.tblCellTypes,'Data',CellTypes);

guidata(gcbo, handles);

function btnRemCellType_Callback(hObject, eventdata, handles)
% This function adds a line to uitable that contains the celltypes
handles=guidata(gcbo);

CellTypes = get(handles.tblCellTypes,'Data');
if(size(CellTypes,1)>0)
	set(handles.tblCellTypes,'Data',CellTypes(1:(end-1),:));
end

guidata(gcbo, handles);


% Set, Save and Close
function mnLoadSetFile_Callback(hObject, eventdata, handles)
[FileName,PathName,FilterIndex] = uigetfile({'*.mat','Preset'},'Locate file');

if(PathName~=0)
    LoadPresetFromFile(gcbf,[PathName FileName]);
end
        
function mnSaveSetFile_Callback(hObject, eventdata, handles)
handles = guidata(gcbo);
[FileName,PathName,FilterIndex] = uiputfile({'*.mat','*.mat Preset'},'Save');

% If a file is selected
if(PathName~=0)
    Preset = SaveSettings(handles);
    save([PathName FileName],'Preset')
end

function LoadPresetFromFile(h,File)
handles = guidata(h);

% If a file is selected
try 
    File = load(File);
catch
    warning('Error loading file');
    return;
end
if(~isfield(File,'Preset'))
    warning('Invalid preset file');
    return;
end
T = isfield(File.Preset,{'RadioSelected','FilePath','NumberBox','CellTypes'});
if(nnz(1-T) == 0)
    try,
        handles = LoadPreset(handles,File.Preset,1);
        guidata(h,handles);
    catch
        warning('Invalid preset file');
    end
else
    warning('Invalid preset file');
end

function handles = LoadPreset(handles, Preset, New)
% This function loads a preset file into the GUI
% The New flag determines whether a different file has been loaded and
% the according Changed flags have to be modified.

% Set all the radio buttons to the selected ones:
for iTab = 1:length(Preset.RadioSelected)
    handles = SelectRadio(handles,iTab,Preset.RadioSelected(iTab));
end

% Set FileSelectors
for iSelect = 1:length(Preset.FilePath)
    handles = SetFileSelector(handles,iSelect,Preset.FilePath{iSelect});
    if(New)
        handles.FileSelector(iSelect).PathChanged = 1;
    end
end

% Set NumberBoxes
for iBox = 1:length(Preset.NumberBox)
    handles = SetNumberBox(handles,iBox,Preset.NumberBox{iBox});
    if(New)
        handles.NumberBox(iBox).ValueChanged = 1;
    end

end

if(isfield(Preset,'ConnectionListEndian')) % Support for v2.1 and older
    set(handles.popConLstFormat,'Value',Preset.ConnectionListEndian);
end
if(isfield(Preset,'ConnectionListFormat'))
    set(handles.popConLstFormat,'Value',Preset.ConnectionListFormat);
end

if(isfield(Preset,'SpikeTimesOffset'))
    set(handles.chkSpkTmsOffset,'Value',Preset.SpikeTimesOffset);
end

% Set CellTypes Array
if(~verlessthan('matlab','7.6'))
    set(handles.tblCellTypes,'Data',Preset.CellTypes);
end

function Settings = SaveSettings(handles)
% This function saves the settings made in the current window
Settings.RadioSelected = handles.RadioSelected;
Settings.FilePath = {handles.FileSelector(:).Path};
Settings.NumberBox = {handles.NumberBox(:).Value};
Settings.ConnectionListFormat = get(handles.popConLstFormat,'Value');
Settings.SpikeTimesOffset = get(handles.chkSpkTmsOffset,'Value');
if(verlessthan('matlab','7.6'))
    Settings.CellTypes = load(DefaultCellTypes.mat);
else
    Settings.CellTypes = get(handles.tblCellTypes,'Data');
end
  

function Close(hObject, eventdata, handles)
handles = guidata(gcbf);
try
    MainHandles = guidata(handles.MainFig);
    MainHandles.DataLoaded = 0;
    guidata(handles.MainFig,MainHandles);
end
delete(gcbf)

function SaveClose(hObject, eventdata, handles)
% This function loads the data according to all the selected options.
handles = guidata(gcbf);
MainHandles = guidata(handles.MainFig);

% Check whether given data is sufficient
disp('Checking input...')
ValidData = 1;

% === Positions tab
switch get(handles.pnlPositions,'SelectedObject')
	case handles.rdoPositionsFile,
		% Check if files are valid
		if(handles.FileSelector(handles.FilePathCllPosId).PathValid==0)
			ValidData = 0;
		end
	case handles.rdoPositionsStrc,

	case handles.rdoPositionsRand,
end

% === Network tab
switch get(handles.pnlNetwork,'SelectedObject')
	case handles.rdoNetworkNone,
	
	case handles.rdoNetworkNeuroSim,
		% Check if files are valid
		if(handles.FileSelector(handles.FilePathConCntId).PathValid==0)
			ValidData = 0;
		end
		if(handles.FileSelector(handles.FilePathConLstId).PathValid==0)
			ValidData = 0;
		end

	case handles.rdoNetworkMatrix,
		% Check if file is valid
		if(handles.FileSelector(handles.FilePathConMatId).PathValid==0)
			ValidData = 0;
		end
end

% === Spike data tab
switch get(handles.pnlSpikeData,'SelectedObject')
	case handles.rdoSpikeDataNone,
	
	case handles.rdoSpikeDataVm,
		% Check if file is valid
		if(handles.FileSelector(handles.FilePathVmId).PathValid==0)
			ValidData = 0;
		end
		% Check if the required Numberboxes are filled out
		if(isempty(handles.NumberBox(handles.NumberSampRateVm).Value))
			ValidData = 0;
		end
		if(isempty(handles.NumberBox(handles.NumberThresVm).Value))
			ValidData = 0;
		end

	case handles.rdoSpikeDataSpkTms,
		% Check if file is valid
		if(handles.FileSelector(handles.FilePathSpkTmsId).PathValid==0)
			ValidData = 0;
        end
        
        if(isempty(handles.NumberBox(handles.SpkTmsNumberColumnTime).Value))
            ValidData = 0;
        end
        if(isempty(handles.NumberBox(handles.SpkTmsNumberColumnNeur).Value))
            ValidData = 0;
        end
        
end

% === EEG/LFP tab
switch get(handles.pnlEEGData,'SelectedObject')
	case handles.rdoEEGDataNone,
	
	case handles.rdoEEGDataIm,
		% Check if file is valid
		if(handles.FileSelector(handles.FilePathImId).PathValid==0)
			ValidData = 0;
		end
		% Check if the required Numberboxes are filled out
		if(isempty(handles.NumberBox(handles.NumberSampRateIm).Value))
			ValidData = 0;
		end

	case handles.rdoEEGDataEEG,
		% Check if file is valid
		if(handles.FileSelector(handles.FilePathEEGId).PathValid==0)
			ValidData = 0;
		end
		% Check if the required Numberboxes are filled out
		if(isempty(handles.NumberBox(handles.NumberSampRateEEG).Value))
			ValidData = 0;
		end
end

if(ValidData==0)
	msgbox('Incomplete form. Provide more data.');
	return;
end

% Start reading data

if(isfield(MainHandles,'Data'))
	Data = MainHandles.Data;
else
	Data = struct([]);
end

MainHandles.ChangedNetwork = 0;
MainHandles.ChangedData = 0;

% First find a way to determine the number of neurons in the given dataset
if(get(handles.pnlCellTypes,'SelectedObject') == handles.rdoNeuronsDiff)
	% CellTypes are given. Determine number of neurons by adding up the number fields
	if(verlessthan('matlab','7.6'))
		CellTypes = load(DefaultCellTypes.mat);
	else
		CellTypes = get(handles.tblCellTypes,'Data');
	end
	nCells = sum([CellTypes{:,3}]);
elseif(get(handles.pnlNetwork,'SelectedObject') == handles.rdoNetworkNeuroSim)
	% A NeuroSim network is given. Determine number of neurons by looking at ConnectionCount.nwk
	ConnectionCount = load(handles.FileSelector(handles.FilePathConCntId).Path);
	nCells = length(ConnectionCount);
elseif(get(handles.pnlPositions,'SelectedObject') == handles.rdoPositionsFile)
	% Neuron positions are given. Determine number of neurons by looking at
	% number of positions
	CellPositions = load(handles.FileSelector(handles.FilePathCllPosId).Path);
	nCells = size(CellPositions,1);
elseif(get(handles.pnlNetwork,'SelectedObject') == handles.rdoNetworkMatrix)
	% A connection matrix is given. Determine number of neurons by looking at the size of matrix
	ConnectionMatrix = load(handles.FileSelector(handles.FilePathConMatIf).Path);
	nCells = size(ConnectionMatrix,1);
elseif(get(handles.pnlSpikeData,'SelectedObject') == handles.rdoSpikeDataVm)
	% Determine nCells by the number of columns of Vm
	Vm = load(handles.FileSelector(handles.FilePathVmId).Path);
	nCells = size(Vm,2);
elseif(get(handles.pnlSpikeData,'SelectedObject') == handles.rdoSpikeDataSpkTms)
	% Determine nCells by the highest neuron ID.
	SpikeTimes = load(handles.FileSelector(handles.FilePathSpkTmsId).Path);
	ColN = handles.NumberBox(handles.SpkTmsNumberColumnNeur).Value;
    nCells = max(SpikeTimes(:,ColN)) + get(handles.chkSpkTmsOffset,'Value');
else
    % No way can be found to determine total number of cells!
    warning('Number of cells could not be determined from given data.');
end


% This one is only interesting if the number of cells is known
if(exist('nCells'))
    if(nCells > 0)
        % Store number of cells.
        Data(1).nCells = nCells;

        % Celltypes tab first.
        disp('Handling cell positions...')
        switch get(handles.pnlCellTypes,'SelectedObject')
            case handles.rdoNeuronsNoDiff,
                % No distinction
                Data.CellTypesRaw = {true, 'Cell', Data.nCells, '-', 'o', '[0 0 1]'};

            case handles.rdoNeuronsDiff,
                % Distinction between celltypes
                if(verlessthan('matlab','7.6'))
                    % Matlab version too old, see if preference file is available, return warning otherwise.
                    if(exist('DefaultCellTypes.mat') == 2)
                        Data.CellTypesRaw = load('DefaultCellTypes.mat')
                    else
                        warning('The file DefaultCellTypes.mat does not exist. \n Cells are treated as if \''No distinction\'' option was chosen');
                        Data.CellTypesRaw = {true, 'Cell', Data.nCells, '-', 'o', '[0 0 1]'};
                    end
                else
                    % Matlab version high enough, read settings from uitable
                    Data.CellTypesRaw = get(handles.tblCellTypes,'Data');
                    if(isempty(Data.CellTypesRaw))
                        warning('No cell types specified. \n Cells are treated as if \''No distinction\'' option was chosen');
                        Data.CellTypesRaw = {true, 'Cell', Data.nCells, '-', 'o', '[0 0 1]'};
                    end
                end
        end


        % Positions tab is next. Only interesting when nCells is known
        switch get(handles.pnlPositions,'SelectedObject')
            case handles.rdoPositionsFile,
                % Read file if necessary
                if(~exist('CellPositions'))
                    CellPositions = load(handles.FileSelector(handles.FilePathCllPosId).Path);
                end
                % Check format
                if(size(CellPositions,1)==nCells && size(CellPositions,2)==3)
                    Data.CellPositions = CellPositions;
                else
                    warning('Incosistent size of cell positions. \n Cells are treated as if \''Structured\'' option was chosen');

                    % Order neurons neatly in layers for every indicated celltype
                    nType = size(Data.CellTypesRaw,1);
                    Data.CellPositions = zeros(0,3);
                    for iType = 1:nType
                        n = Data.CellTypesRaw{iType,3};
                        nRoot = ceil(sqrt(n));
                        x = mod(0:(n-1),nRoot);
                        y = floor((0:(n-1))/nRoot);
                        Pos = zeros(n,3);
                        Pos(:,1) = x/(nRoot-1);
                        Pos(:,2) = y/(nRoot-1);
                        if(nType > 1)
                            Pos(:,3) = (iType-1)/(nType-1);
                        else
                            Pos(:,3) = 0;
                        end
                        Data.CellPositions = [Data.CellPositions; Pos];
                    end
                end

            case handles.rdoPositionsStrc,
                % Order neurons neatly in layers for every indicated celltype
                nType = size(Data.CellTypesRaw,1);
                Data.CellPositions = zeros(0,3);
                for iType = 1:nType
                    n = Data.CellTypesRaw{iType,3};
                    nRoot = ceil(sqrt(n));
                    x = mod(0:(n-1),nRoot);
                    y = floor((0:(n-1))/nRoot);
                    Pos = zeros(n,3);
                    Pos(:,1) = x/(nRoot-1);
                    Pos(:,2) = y/(nRoot-1);
                    if(nType > 1)
                        Pos(:,3) = (iType-1)/(nType-1);
                    else
                        Pos(:,3) = 0;
                    end
                    Data.CellPositions = [Data.CellPositions; Pos];

                end
            case handles.rdoPositionsRand,
                % Pick random numbers. Dimensions do not matter, so the range (0,1) should be ok
                Data.CellPositions = rand(nCells,3);
        end

        % Network tab
        switch get(handles.pnlNetwork,'SelectedObject')
            case handles.rdoNetworkNone,
                % No network is given. Delete all possible
                if(isfield(Data,'Network'))
%                     if(isfield(Data.Network,'ConnectionCount'))
%                         Data.Network = rmfield(Data.Network,'ConnectionCount');
%                     end
%                     if(isfield(Data.Network,'ConnectionList'))
%                         Data.Network = rmfield(Data.Network,'ConnectionList');
%                     end
%                     if(isfield(Data.Network,'ConnectionMatrix'))
%                         Data.Network = rmfield(Data.Network,'ConnectionMatrix');
%                     end
                    Data = rmfield(Data,'Network');
                end
            case handles.rdoNetworkNeuroSim,
                disp('Reading NeuroSim network...')
                Error = 0;
                if(~isfield(Data,'Network'))
                    Data.Network = [];
                end
                % Read files if they have changed.
                if(~isfield(Data.Network,'ConnectionCount') || handles.FileSelector(handles.FilePathConCntId).PathChanged==1)
                    % Read ConnectionCount to a temporary variable and check number of elements before copying
                    if(~exist('ConnectionCount'))
                        ConnectionCount = load(handles.FileSelector(handles.FilePathConCntId).Path);
                    end
                    if(numel(ConnectionCount) == Data.nCells)			
                        Data.Network.ConnectionCount = ConnectionCount(:);
                    else
                        Error = 1;
                    end
                end

                % Try reading ConnectionList.
                if(~isfield(Data.Network,'ConnectionList') || handles.FileSelector(handles.FilePathConLstId).PathChanged==1)
                    switch(get(handles.popConLstFormat,'Value'))
                        case 1
                            Format = 'n';
                        case 2
                            Format = 'b';
                        case 3
                            Format = 'l';
                        case 4
                            Format = 'a';
                    end
                    
                    try
                        [Data.Network.ConnectionMatrix, Data.Network.ConnectionDetails] = ReadConnectionList(...
                                    handles.FileSelector(handles.FilePathConLstId).Path,Data.Network.ConnectionCount, Format);
                    catch
                        Error = 1;
                    end
                end

                if(Error == 1)
%                     % Error during reading one of the files. Clean up
%                     warning('Error while reading network. \n Treated as if \''No network\'' option was chosen');
%                     if(isfield(Data.Network,'ConnectionCount'))
%                         Data.Network = rmfield(Data.Network,'ConnectionCount');
%                     end
%                     if(isfield(Data.Network,'ConnectionList'))
%                         Data.Network = rmfield(Data.Network,'ConnectionList');
%                     end
                    if(isfield(Data,'Network'))
                        Data = rmfield(Data,'Network');
                    end
                end


            case handles.rdoNetworkMatrix,
                disp('Reading connection matrix...')
                if(~isfield(Data,'Network'))
                    Data.Network = [];
                end
                % Read connectionmatrix
                if(~isfield(Data.Network,'ConnectionMatrix') || handles.FileSelector(handles.FilePathConMatId).PathChanged==1)
                    if(~exist('ConnectionMatrix'))
                        ConnectionMatrix = load(handles.FileSelector(handles.FilePathConMatId).Path);
                    end
                    if(size(ConnectionMatrix,1)==Data.nCells && size(ConnectionMatrix,2)==Data.nCells)
                        Data.Network.ConnectionMatrix = ConnectionMatrix;
                    else
                        warning('Size of connection matrix does not match number of cells. \n Network treated as if \''No network\'' option was chosen');

                        % Possibly remove previous network
                        if(isfield(Data.Network,'ConnectionMatrix'))
                            Data.Network = rmfield(Data.Network,'ConnectionMatrix');
                        end
                    end
                end

                % Delete other networks
                if(isfield(Data.Network,'ConnectionCount'))
                    Data.Network = rmfield(Data.Network,'ConnectionCount');
                end
                if(isfield(Data.Network,'ConnectionDetails'))
                    Data.Network = rmfield(Data.Network,'ConnectionDetails');
                end
        end

        % Spike data tab
        switch get(handles.pnlSpikeData,'SelectedObject')
            case handles.rdoSpikeDataNone,
                % No data is given. Delete all possible
                if(isfield(Data,'Vm'))
                    Data = rmfield(Data,'Vm');
                end
                if(isfield(Data,'SpikeTimes'))
                    Data = rmfield(Data,'SpikeTimes');
                end

            case handles.rdoSpikeDataVm,
                disp('Reading membrane potentials...')
                Error = 0;
                if(~isfield(Data,'Vm') || handles.FileSelector(handles.FilePathVmId).PathChanged == 1)
                    Data.Vm.SamplingRate = handles.NumberBox(handles.NumberSampRateVm).Value;
                    Data.Vm.Duration = handles.NumberBox(handles.NumberDurationVm).Value;
                    tmp = handles.NumberBox(handles.NumberThresVm).Value;
                    if(~isempty(tmp))
                        Data.Vm.Threshold = tmp;
                    else
                        Data.Vm.Threshold = 0;
                    end	

                    if(~isempty(Data.Vm.Duration))
                        % Duration is given. Try reading it with the fast data reader
                        try
                            Data.Vm.Data = readASCII(handles.FileSelector(handles.FilePathVmId).Path,...
                                                        Data.Vm.SamplingRate*Data.Vm.Duration,...
                                                        Data.nCells);
                            % Redefine duration to prevent inconsistencies:
                            Data.Vm.Duration = size(Data.Vm.Data,1)/Data.Vm.SamplingRate;

                        catch
                            Error = 1;
                        end
                    else
                        % No duration given. Read file using generic reader and check later
                        if(~exist('Vm'))
                            try
                                Vm = readASCII(handles.FileSelector(handles.FilePathVmId).Path,...
                                                Inf,...
                                                Data.nCells);
                            catch
                                Error = 1;
                            end
                        end
                        if(size(Vm,2) == Data.nCells && Error == 0)
                            Data.Vm.Data = Vm;
                            Data.Vm.Duration = size(Vm,1)/Data.Vm.SamplingRate;
                        else
                            Error = 1;
                        end	
                    end
                end

                % Check if errors are produced. If so; clean up
                if(Error == 1)
                    % File incorrect. Give warning and clean up
                    warning('Invalid file for Vm.dat. Data treated as if ''No spike data'' option was chosen');
                    Data = rmfield(Data,'Vm');				
                end	

                % Clear other 
                if(isfield(Data,'SpikeTimes'))
                    Data = rmfield(Data,'SpikeTimes');
                end

            case handles.rdoSpikeDataSpkTms,
                disp('Reading spikes...')
                
                if(handles.NumberBox(handles.SpkTmsNumberColumnNeur).ValueChanged == 1 || ...
                        handles.NumberBox(handles.SpkTmsNumberColumnTime).Value == 1)
                    ColumnsChanged = 1;
                else
                    ColumnsChanged = 0;
                end
               
                
                if(~isfield(Data,'SpikeTimes') || ...
                        handles.FileSelector(handles.FilePathSpkTmsId).PathChanged == 1 || ...
                        ColumnsChanged == 1)
                    if(~exist('SpikeTimes'))
                        temp = load(handles.FileSelector(handles.FilePathSpkTmsId).Path);
                    else
                        temp = SpikeTimes;
                    end
                

                    % Column numbers of Neurons IDs and Time

                    ColN = handles.NumberBox(handles.SpkTmsNumberColumnNeur).Value;
                    ColT = handles.NumberBox(handles.SpkTmsNumberColumnTime).Value;

                    Data.SpikeTimes = temp(:,[ColT, ColN]);
                    if(get(handles.chkSpkTmsOffset,'Value') == 1)
                        Data.SpikeTimes(:,2) = Data.SpikeTimes(:,2)+1;
                    end
                end    

                % Clear other
                if(isfield(Data,'Vm'))
                    Data = rmfield(Data,'Vm');
                end
        end

    else
        warning('Number of neurons is non-positive');
        % cleanup: delete all data fields:
        Data = struct([]);

    end
end

% EEG Tab
switch get(handles.pnlEEGData,'SelectedObject')
	case handles.rdoEEGDataNone,
		% Clear all data
		if(isfield(Data,'EEG'))
			Data = rmfield(Data,'EEG');
		end

	case handles.rdoEEGDataIm,
		if(~isfield(Data,'EEG') || handles.FileSelector(handles.FilePathImId).PathChanged==1)
			% Read EEG data	
			Data(1).EEG.SamplingRate = handles.NumberBox(handles.NumberSampRateIm).Value;
			Data.EEG.Duration = handles.NumberBox(handles.NumberDurationIm).Value;

			NumNeur = handles.NumberBox(handles.NumberNumNeurIm).Value;

            Error = 0;
			if(~isempty(Data.EEG.Duration) && ~isempty(NumNeur))
				% Duration is given. Try reading it with the fast data reader
				try
					disp('reading EEG...')
					Im = readASCII(handles.FileSelector(handles.FilePathImId).Path,...
									Data.EEG.SamplingRate*Data.EEG.Duration,...
									NumNeur);

				catch
					% File incorrect. Give warning and clean up
					warning('Invalid file for EEG.dat. Data treated as if \''No EEG data\'' option was chosen');
					Error = 1;
				end
			else
				% No duration given. Read file using generic reader and check later
                disp('Reading EEG...')
                Im = load(handles.FileSelector(handles.FilePathImId).Path);
                Data.EEG.Duration = size(Im,1)/Data.EEG.SamplingRate;
                if(~isempty(NumNeur))
                    if(size(Im,2) ~= NumNeur)
                        warning('Inconsistent number of neurons for EEG.dat');
                        Error = 1;
                    end
                end
                if(exist('nCells'))
                    if(size(Im,2) > nCells)
                        warning('Inconsistent number of neurons for EEG.dat');
                        Error = 1;
                    end
                end
                              
            end
            
            if(Error == 0)            
                % if CellPositions exist try converting Im data to EEG. Use identical depths otherwise
                try
                    Data.EEG.Data = MakeEEG(Im, Data.Network.CellPositions);
                catch
                    Data.EEG.Data = MakeEEG(Im, ones(size(Im,2),3));
                end
                % Redefine time to prevent inconsistencies:
                Data.EEG.Duration = length(Data.EEG.Data)/Data.EEG.SamplingRate;
            else
                Data = rmfield(Data,'EEG');
            end
                
		end
		
	case handles.rdoEEGDataEEG,
		if(~isfield(Data,'EEG') || handles.FileSelector(handles.FilePathEEGId).PathChanged==1)
			% Read EEG data	
			Data(1).EEG.SamplingRate = handles.NumberBox(handles.NumberSampRateEEG).Value;
			Data.EEG.Duration = handles.NumberBox(handles.NumberDurationEEG).Value;
			
			if(~isempty(Data.EEG.Duration))
				% Duration is given. Try reading it with the fast data reader
				try
                    disp('Reading EEG...')
					Data.EEG.Data = readASCII(handles.FileSelector(handles.FilePathEEGId).Path,...
												1,...
												Data.EEG.SamplingRate*Data.EEG.Duration);
				catch
					% File incorrect. Give warning and clean up
					warning('Invalid file for EEG.dat. Data treated as if \''No EEG data\'' option was chosen');
					Data = rmfield(Data,'EEG');
				end
			else
				% No duration given. Read file using generic reader and check later
                disp('Reading EEG...')
				tmp = load(handles.FileSelector(handles.FilePathEEGId).Path);
				if(size(tmp,2) == 1)
					Data.EEG.Data = tmp;
					Data.EEG.Duration = size(tmp,1)/Data.EEG.SamplingRate;
				else
					% File incorrect. Give warning and clean up
					warning('Invalid file for EEG.dat. Data treated as if \''No EEG data\'' option was chosen');
					Data = rmfield(Data,'EEG');
				end	
			end
		end
end

if(exist('Data'))
    disp('Done!')
    MainHandles.Data = Data;
    MainHandles.DataLoaded = 1;
else
	disp('Data not available')
    MainHandles.DataLoaded = 0;

end


MainHandles.Settings = SaveSettings(handles);

guidata(handles.MainFig,MainHandles);
delete(gcbf)

