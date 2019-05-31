function Skuld(varargin)
% Make the entire GUI for Skuld
% ----------------------------------------------------
% Optional argument can be a preset filename, which would be directly
% loaded into the GUI upon start-up.

% Make figure:
f=figure('Units','pixels',...
        'Position',[350 100 900 650],...
        'Resize','off',...
        'Renderer','zbuffer',...
        'NumberTitle','off',...
        'Menubar','none',...
        'Toolbar','none',...
        'Name','Skuld',...
        'DeleteFcn',@Skuld_DeleteFcn);
    

% Define axes
handles.axsMain = axes('Units','pixels',...
                        'Position',[100 150 400 400]);
                    
% Define panels

% Panel Network information
handles.pnlNwkInf = uipanel('Units','pixels',...
                            'Position',[600 520 275 100],...
                            'BackgroundColor',get(gcf,'Color'),...
                            'Title','Network information');

handles.lblCllTtl_fixed = uicontrol('Parent',handles.pnlNwkInf,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[10 50 165 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Number of cells:',...
                                    'HorizontalAlignment','right');
handles.lblCllTtl = uicontrol('Parent',handles.pnlNwkInf,...
                                'Style','text',...
                                'Units','pixels',...
                                'Position',[180 50 50 20],...
                                'BackgroundColor',get(gcf,'Color'),...
                                'String','--',...
                                'HorizontalAlignment','left');                                

handles.lblTypTtl_fixed = uicontrol('Parent',handles.pnlNwkInf,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[10 30 165 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Number of celltypes:',...
                                    'HorizontalAlignment','right');
handles.lblTypTtl = uicontrol('Parent',handles.pnlNwkInf,...
                                'Style','text',...
                                'Units','pixels',...
                                'Position',[180 30 50 20],...
                                'BackgroundColor',get(gcf,'Color'),...
                                'String','--',...
                                'HorizontalAlignment','left');                                

handles.lblConTtl_fixed = uicontrol('Parent',handles.pnlNwkInf,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[10 10 165 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Number of connections:',...
                                    'HorizontalAlignment','right');
handles.lblConTtl = uicontrol('Parent',handles.pnlNwkInf,...
                                'Style','text',...
                                'Units','pixels',...
                                'Position',[180 10 50 20],...
                                'BackgroundColor',get(gcf,'Color'),...
                                'String','--',...
                                'HorizontalAlignment','left');                                

% Panel Cell information
handles.pnlCllInf = uipanel('Units','pixels',...
                            'Position',[600 50 275 450],...
                            'BackgroundColor',get(gcf,'Color'),...
                            'Title','Cell information');

handles.lblCllId_fixed = uicontrol('Parent',handles.pnlCllInf,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[10 410 165 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Cell ID:',...
                                    'HorizontalAlignment','right');
handles.lblCllId = uicontrol('Parent',handles.pnlCllInf,...
                                'Style','text',...
                                'Units','pixels',...
                                'Position',[180 410 50 20],...
                                'BackgroundColor',get(gcf,'Color'),...
                                'String','--',...
                                'HorizontalAlignment','left');                                

handles.lblCllTyp_fixed = uicontrol('Parent',handles.pnlCllInf,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[10 390 165 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Type:',...
                                    'HorizontalAlignment','right');
handles.lblCllTyp = uicontrol('Parent',handles.pnlCllInf,...
                                'Style','text',...
                                'Units','pixels',...
                                'Position',[180 390 50 20],...
                                'BackgroundColor',get(gcf,'Color'),...
                                'String','--',...
                                'HorizontalAlignment','left');
                            
handles.lblIncCon_fixed = uicontrol('Parent',handles.pnlCllInf,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[10 370 165 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Connections in:',...
                                    'HorizontalAlignment','right');
handles.lblIncCon = uicontrol('Parent',handles.pnlCllInf,...
                                'Style','text',...
                                'Units','pixels',...
                                'Position',[180 370 50 20],...
                                'BackgroundColor',get(gcf,'Color'),...
                                'String','--',...
                                'HorizontalAlignment','left');
handles.axsIncCon = axes('Parent',handles.pnlCllInf,...
                            'Units','pixels',...
                            'Position',[10 205 255 160],...
                            'Visible','off');
                            
handles.lblOutCon_fixed = uicontrol('Parent',handles.pnlCllInf,...
                                    'Style','text',...
                                    'Units','pixels',...
                                    'Position',[10 180 165 20],...
                                    'BackgroundColor',get(gcf,'Color'),...
                                    'String','Connections out:',...
                                    'HorizontalAlignment','right');
handles.lblOutCon = uicontrol('Parent',handles.pnlCllInf,...
                                'Style','text',...
                                'Units','pixels',...
                                'Position',[180 180 50 20],...
                                'BackgroundColor',get(gcf,'Color'),...
                                'String','--',...
                                'HorizontalAlignment','left');                                
handles.axsOutCon = axes('Parent',handles.pnlCllInf,...
                            'Units','pixels',...
                            'Position',[10 10 255 160],...
                            'Visible','off');                    

% Menubar (in Depth-First-Search order)

% File menu
handles.mnFile = uimenu('Parent',gcf,...
                        'Label','File');
handles.mnLoadData = uimenu('Parent',handles.mnFile,...
                            'Label','Load data',...
                            'Callback',@mnLoadData_Callback);
handles.mnClose = uimenu('Parent',handles.mnFile,...
                            'Label','Close',...
                            'Callback',@mnClose_Callback);
                        
% Cell menu
handles.mnCell = uimenu('Parent',gcf,...
                        'Label','Cell');
handles.mnSltCll = uimenu('Parent',handles.mnCell,...
                            'Label','Select cell',...
                            'Callback',@mnSltCll_Callback);
                        
handles.mnShwVm = uimenu('Parent',handles.mnCell,...
                            'Separator','on',...
                            'Label','Vm trace',...
                            'Callback',@mnShwVm_Callback);
handles.mnCllISI = uimenu('Parent',handles.mnCell,...
                            'Label','ISI distribution',...
                            'Callback',@mnCllISI_Callback);                        
handles.mnAtSpec = uimenu('Parent',handles.mnCell,...
                            'Label','Auto spectrum',...
                            'Callback',@mnAtSpec_Callback);                        
handles.mnCllRst = uimenu('Parent',handles.mnCell,...
                            'Label','Raster plot',...
                            'Callback',@mnCllRst_Callback);
handles.mnIncCon = uimenu('Parent',handles.mnCell,...
                            'Separator','On',...
                            'Label','Incoming connections',...
                            'Callback',@mnIncCon_Callback);
handles.mnIncCll = uimenu('Parent',handles.mnCell,...
                            'Label','Incoming cells',...
                            'Callback',@mnIncCll_Callback);
handles.mnOutCon = uimenu('Parent',handles.mnCell,...
                            'Label','Outgoing connections',...
                            'Callback',@mnOutCon_Callback);
handles.mnOutCll = uimenu('Parent',handles.mnCell,...
                            'Label','Outgoing cells',...
                            'Callback',@mnOutCll_Callback);
                        
% Population menu
handles.mnPopInf = uimenu('Parent',gcf,...
                            'Label','Population');
handles.mnMnVm = uimenu('Parent',handles.mnPopInf,...
                            'Label','Mean Vm',...
                            'Callback',@mnMnVm_Callback);
handles.mnSpkBns = uimenu('Parent',handles.mnPopInf,...
                            'Label','Firing rates',...
                            'Callback',@mnSpkBns_Callback);
handles.mnPopRst = uimenu('Parent',handles.mnPopInf,...
                            'Label','Raster plot',...
                            'Callback',@mnPopRst_Callback);
                    
                        
% Network menu
handles.mnNetwork= uimenu('Parent',gcf,...
                            'Label','Network');
handles.mnShwEEG = uimenu('Parent',handles.mnNetwork,...
                            'Label','Show EEG/LFP',...
                            'Callback',@mnShwEEG_Callback);
                        
% Window menu
handles.mnWindow = uimenu('Parent',gcf,...
                            'Label','Window');
handles.mnCloseAll = uimenu('Parent',handles.mnWindow,...
                            'Label','Close all plots',...
                            'Callback',@mnCloseAll_Callback);
                        
% Help menu
handles.mnHelp = uimenu('Parent',gcf,...
                            'Label','Help');
handles.mnDoc = uimenu('Parent',handles.mnHelp,...
                        'Label','Documentation',...
                        'Callback',@mnDoc_Callback);
handles.mnAbt = uimenu('Parent',handles.mnHelp,...
                        'Label','About Skuld',...
                        'Callback',@mnAbt_Callback);
                    
                    
% Toolbar
% read icons first
iconDir = fullfile(matlabroot,'toolbox','matlab','icons');
iconOpen = load(fullfile(iconDir,'opendoc.mat'));
iconRot = load(fullfile(iconDir,'rotate.mat'));
% Make objects
handles.tbrToolbar = uitoolbar('Parent',gcf);
handles.tbrLoadData = uipushtool('Parent',handles.tbrToolbar,...
                                    'CData',iconOpen.cdata,...
                                    'TooltipString','Load Data',...
                                    'ClickedCallback',@tbrLoadData_ClickedCallback);
handles.tbrRotate = uitoggletool('Parent',handles.tbrToolbar,...
                                    'CData',iconRot.cdata,...
                                    'TooltipString','Rotate 3D',...
                                    'OnCallback','rotate3d on',...
                                    'OffCallback','rotate3d off');

% ----------------------------------------------------


% Choose default command line output for Skuld
% handles.FilePaths = {};
% handles.Network = {};
% handles.Data = {};
% handles.CellTypesRaw = {};

handles.ChangedNetwork = 0;
handles.ChangedData = 0;

handles.NeuronSelected = NaN;

handles.SecondaryPlots.LinkViewHandles = [];
handles.SecondaryPlots.FigureHandles = [];


handles.MenuOptions.CellSelected = [handles.mnShwVm, handles.mnCllISI, handles.mnAtSpec, handles.mnCllRst];
handles.MenuOptions.SpikeData = [handles.mnCllISI, handles.mnAtSpec, handles.mnCllRst, ...
                                    handles.mnSpkBns, handles.mnPopRst];
handles.MenuOptions.VmData = [handles.mnShwVm, handles.mnMnVm];


handles = InitializeMenu(handles);

% Update handles structure
guidata(gcf, handles);

% Check if preset file should be loaded:
if(~isempty(varargin))
    LoadData(gcf, varargin{1})
end

% --- Executes during object deletion, before destroying properties.
function Skuld_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to Skuld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);
close(handles.SecondaryPlots.FigureHandles);

% --------------------------------------------------------- FILE MENU ---
function mnLoadData_Callback(hObject, eventdata, handles)
% hObject    handle to mnLoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadData(gcbf);

function mnClose_Callback(hObject, eventdata, handles)
% hObject    handle to mnClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDAT A)
close(gcf);

% --------------------------------------------------------- CELL MENU ---
function mnSltCll_Callback(hObject, eventdata, handles)
% hObject    handle to mnSltCll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcbo);

% Popup a dialog to enter the cell number
RequestedID = str2double(inputdlg('Enter a cell ID','Select cell'));

% Check if a number has been entered
if(~isempty(RequestedID) && ~isnan(RequestedID))
    
    % Make an integer of the number
    ID = floor(RequestedID);
    
    % Determine if the value is within range
    if(ID>0 && ID<=handles.Data.nCells)
        
        % Deselect previous cell (if necessary)
        if(~isnan(handles.NeuronSelected))
            handles = DeselectNeuron(handles.NeuronSelected,handles);
        end
        
        % Select new cell
        handles.NeuronSelected = ID;
        handles = SelectNeuron(ID,handles);
        
        guidata(hObject,handles);
    end
end

function mnShwVm_Callback(hObject, eventdata, handles)
% hObject    handle to mnShwVm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

% Prepare data
time = (1:(handles.Data.Vm.Duration*handles.Data.Vm.SamplingRate))/handles.Data.Vm.SamplingRate;
Vm = handles.Data.Vm.Data(:,handles.NeuronSelected);

% Call window and plot
[Fig, Ax] = MakeSecondaryFigure(gcbf);
AddFilterMenu(Fig);     % Adds filter optionality to this figure
AddPlaySoundToolbar(Fig);     % Adds button to play recording
plot(time,Vm);
title(['Membrane potential of cell ' num2str(handles.NeuronSelected)]);
xlabel('time (s)');
ylabel('Vm (V)');
set(Ax,'YLimMode','manual');

% Obtain handles of the new figure to store data in the figure
FigHandles = guidata(Fig);

% Store data
FigHandles.Data.T = time;
FigHandles.Data.Y = Vm;
FigHandles.Data.SamplingRate = handles.Data.Vm.SamplingRate;

% Store filters
FigHandles.Filter.Low = [];
FigHandles.Filter.High = [];

guidata(Fig,FigHandles);


% Process new handles
handles.SecondaryPlots.LinkViewHandles = [handles.SecondaryPlots.LinkViewHandles Ax];
handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];

guidata(hObject,handles);

function mnCllISI_Callback(hObject, eventdata, handles)
% hObject    handle to mnShwVm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

[t, pd, mean, cv, tot_sp] = ISIdist(handles.Data.NeuronSpikes.Data{handles.NeuronSelected},2,200);

if(~isempty(pd))
    Fig=figure;
    Ax=axes;

    bar(Ax,t,pd);
    title(Ax,'ISI-distribution');
    xlabel(Ax,'interspike interval [msec]');
    ylabel(Ax,'probability per bin');
    meant = sprintf('mean = %.3g [msec]',mean);
    cvt = sprintf('cv = %.2g ',cv);
    totspkt = sprintf('number of spikes = %g',tot_sp);
    text(0.4,0.97,totspkt,'Units','normalized','Parent',Ax);
    text(0.4,0.90,meant,'Units','normalized','Parent',Ax);
    text(0.4,0.83,cvt,'Units','normalized','Parent',Ax);

    handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];
end

guidata(hObject,handles);

function mnAtSpec_Callback(hObject, eventdata, handles)
% hObject    handle to mnShwVm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

[Pxx,f,Fig] =  AutoSpectrum_SpikeTrain(handles.Data.NeuronSpikes.Data{handles.NeuronSelected},180,1);

if(~isempty(Fig))
    handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];
end

guidata(hObject,handles);


function mnCllRst_Callback(hObject, eventdata, handles)
% hObject    handle to mnShwRst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

if(handles.Options.Network)
    % Prepare data
    % Identify cell IDs first
    IDsIn = find(handles.Data.Network.ConnectionMatrix(:,handles.NeuronSelected));
    IDsOut = find(handles.Data.Network.ConnectionMatrix(handles.NeuronSelected,:));
    IDs = [IDsIn(:); handles.NeuronSelected; IDsOut(:)];

    % Determine corresponding delays next
    ConnectionsIn = nonzeros(handles.Data.Network.ConnectionMatrix(IDsIn,handles.NeuronSelected));
    ConnectionsOut = nonzeros(handles.Data.Network.ConnectionMatrix(handles.NeuronSelected,IDsOut));
    if(handles.Options.NeuroSimNetwork)
        Delays = [handles.Data.Network.ConnectionDetails.Delay(ConnectionsIn); 0; -handles.Data.Network.ConnectionDetails.Delay(ConnectionsOut)]; 
    else
        % No delays are present, set them all to zero:
        Delays = zeros(length(IDs),1);
    end
    
    % Values along Y-axis for each ID
    PlotLevel = 1+length(IDsIn)-(1:length(IDs));
    
else
    IDs = 1:handles.Data.nCells;
    PlotLevel = IDs;
    Delays = zeros(size(IDs));
end

PlotHandles = zeros(size(IDs));
        
CumCell = cumsum(handles.Data.CellTypes.Number); 

[Fig,Ax] = MakeSecondaryFigure(gcbf);
AddAlignRasterMenu(Fig);

% Make contextmenu that is required for cell information
cmnRasterCellInfo = uicontextmenu('Callback',@cmnRasterRequestInfo);
mnRasterCellID = uimenu('Parent',cmnRasterCellInfo,'Enable','Off');

hold on
for iID = 1:length(IDs)
    SP = handles.Data.NeuronSpikes.Data{IDs(iID)};
    if(~isempty(SP))        
        Type = find(CumCell>=IDs(iID),1); % Identify type of neuron
 
%         PlotHandles(iID) = plot(SP,ones(size(SP))*(1+length(IDsIn)-iID),handles.Data.CellTypes.Symbol{Type}, ...
        PlotHandles(iID) = plot(SP,ones(size(SP))*PlotLevel(iID),handles.Data.CellTypes.Symbol{Type}, ...
            'MarkerFaceColor',handles.Data.CellTypes.Color(Type,:),...
            'MarkerSize',4,...
            'MarkerEdgeColor','none',...
            'UIContextMenu',cmnRasterCellInfo);
    end
end
title(['Rasterplot of cell ' num2str(handles.NeuronSelected) ' and connecting cells']);
xlabel('time (s)');
set(Ax,'YLimMode','manual');

% Process new handles for main struct
handles.SecondaryPlots.LinkViewHandles = [handles.SecondaryPlots.LinkViewHandles Ax];
handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];

guidata(hObject,handles);

% Process handles for this figure only
FigureHandles = guidata(Fig);
FigureHandles.Data.PlotCellIDs = IDs;
FigureHandles.Data.PlotHandles = PlotHandles;
FigureHandles.Data.Delays = Delays;
guidata(Fig,FigureHandles);

function mnIncCon_Callback(hObject, eventdata, handles)
% hObject    handle to mnIncCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);
handles.View.IncomingConnections = 1 - handles.View.IncomingConnections;
if(handles.View.IncomingConnections == 1)
    set(handles.mnIncCon,'Checked','on');
    if(~isnan(handles.NeuronSelected))
        handles.PlotHandles.IncomingConnections = PlotIncomingConnections(handles.NeuronSelected);
    end
else
    set(handles.mnIncCon,'Checked','off');
    try,
        delete(handles.PlotHandles.IncomingConnections);
        handles.PlotHandles.IncomingConnections = [];
    end
end
guidata(hObject,handles);

function mnIncCll_Callback(hObject, eventdata, handles)
% hObject    handle to mnIncCll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);
handles.View.IncomingCells = 1 - handles.View.IncomingCells;
if(handles.View.IncomingCells == 1)
    set(handles.mnIncCll,'Checked','on');
    if(~isnan(handles.NeuronSelected))
        handles.PlotHandles.IncomingCells = PlotIncomingCells(handles.NeuronSelected);
    end
else
    set(handles.mnIncCll,'Checked','off');
    try,
        set(handles.PlotHandles.IncomingCells,'MarkerEdgeColor','none');
        handles.PlotHandles.IncomingCells = [];
    end
end
guidata(hObject,handles);

function mnOutCon_Callback(hObject, eventdata, handles)
% hObject    handle to mnOutCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);
handles.View.OutgoingConnections = 1 - handles.View.OutgoingConnections;
if(handles.View.OutgoingConnections == 1)
    set(handles.mnOutCon,'Checked','on');
    if(~isnan(handles.NeuronSelected))
        handles.PlotHandles.OutgoingConnections = PlotOutgoingConnections(handles.NeuronSelected);
    end
else
    set(handles.mnOutCon,'Checked','off');
    try,
        delete(handles.PlotHandles.OutgoingConnections);
        handles.PlotHandles.OutgoingConnections = [];
    end
end
guidata(hObject,handles);

function mnOutCll_Callback(hObject, eventdata, handles)
% hObject    handle to mnOutCll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);
handles.View.OutgoingCells = 1 - handles.View.OutgoingCells;
if(handles.View.OutgoingCells == 1)
    set(handles.mnOutCll,'Checked','on');
    if(~isnan(handles.NeuronSelected))
        handles.PlotHandles.OutgoingCells = PlotOutgoingCells(handles.NeuronSelected);
    end
else
    set(handles.mnOutCll,'Checked','off');
    try,
        set(handles.PlotHandles.OutgoingCells,'MarkerEdgeColor','none');
        handles.PlotHandles.OutgoingCells = [];
    end
end
guidata(hObject,handles);

% --------------------------------------------------- POPULATION MENU ---
function mnMnVm_Callback(hObject, eventdata, handles)
% hObject    handle to mnMnVm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

% Request data to plot
if(length(handles.Data.CellTypes.Name)>1)
    [PlotTypes,Ok] = listdlg('ListString',handles.Data.CellTypes.Name,...
        'InitialValue',[1 2],'Name','Mean Vm',...
        'PromptString','Select populations to plot','ListSize',[200 180]);
else
    PlotTypes = [1];
    Ok = 1;
end

if(Ok)
    
    % Request data
    CumCell = cumsum([0 handles.Data.CellTypes.Number]);
    for iType = 1:length(PlotTypes)
        PlotData(:,iType) = mean(handles.Data.Vm.Data(:,[CumCell(PlotTypes(iType))+(1:handles.Data.CellTypes.Number(PlotTypes(iType)))]),2);
    end
    
    time = (1:(handles.Data.Vm.Duration*handles.Data.Vm.SamplingRate))/handles.Data.Vm.SamplingRate;
        
    % Call window and plot
    [Fig, Ax] = MakeSecondaryFigure(gcbf);
    AddFilterMenu(Fig);     % Adds filter optionality to this figure
    plot(time,PlotData);
    title('Mean membrane potential of populations');
    xlabel('time (s)');
    ylabel('Mean Vm (V)');
    set(Ax,'YLimMode','manual');
    legend({handles.Data.CellTypes.Name{PlotTypes}});
    
    % Obtain handles of the new figure to store data in the figure
    FigHandles = guidata(Fig);

    % Store data
    FigHandles.Data.T = time;
    FigHandles.Data.Y = PlotData;
    FigHandles.Data.SamplingRate = handles.Data.Vm.SamplingRate;

    % Store filters
    FigHandles.Filter.Low = [];
    FigHandles.Filter.High = [];

    guidata(Fig,FigHandles);

    % Process new handles
    handles.SecondaryPlots.LinkViewHandles = [handles.SecondaryPlots.LinkViewHandles Ax];
    handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];

    guidata(hObject,handles);
end

function mnSpkBns_Callback(hObject, eventdata, handles)
% hObject    handle to mnSpkBns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

if(length(handles.Data.CellTypes.Name)>1)
    [PlotTypes,Ok] = listdlg('ListString',handles.Data.CellTypes.Name,...
        'InitialValue',[1 2],'Name','Mean Vm',...
        'PromptString','Select populations to plot','ListSize',[200 180]);
else
    PlotTypes = [1];
    Ok = 1;
end

% Cancel execution if 'cancel' is pressed
if(Ok==0)
    return;
end

% Ask for time resulution of the bins
BinTime = str2double(inputdlg('Enter a bin size in ms','Spike bins',1,{'1'}));



if(Ok && ~isempty(BinTime) && ~isnan(BinTime))
    % Determine binsize in datapoints
    BinSize = BinTime/1000; % Conversion from ms
    
    % Make empty array
    Bins = zeros(ceil(handles.Data.NeuronSpikes.Duration/BinSize),length(PlotTypes));
    BinCenters = (0.5:size(Bins,1))*BinSize;
    
    % Request data
    CumCell = cumsum([0 handles.Data.CellTypes.Number]);
    for iType = 1:length(PlotTypes)
%         for iCell = [CumCell(PlotTypes(iType))+(1:handles.Data.CellTypes.Number(PlotTypes(iType)))]
%             BinIDs = ceil(handles.Data.NeuronSpikes.Data{iCell}/BinSize);
%             Bins(BinIDs,iType) = Bins(BinIDs,iType)+1;
%         end
%         Bins(:,iType) = Bins(:,iType)/(handles.Data.CellTypes.Number(iType)*BinTime/1000);
        CellIDs = CumCell(PlotTypes(iType))+(1:handles.Data.CellTypes.Number(PlotTypes(iType)));
        SpikeTimes = cell2mat({handles.Data.NeuronSpikes.Data{CellIDs}}');
        Bins(:,iType) = hist(SpikeTimes,BinCenters)/(handles.Data.CellTypes.Number(iType)*BinTime/1000);
    end
    
    time = BinSize*(1:ceil(handles.Data.NeuronSpikes.Duration/BinSize));
        
    % Call window and plot
    [Fig, Ax] = MakeSecondaryFigure(gcbf);
%     plot(time',Bins);
    plot(BinCenters(:),Bins);
    title('Acitivity of populations');
    xlabel('time (s)');
    ylabel('Population firing rate');
    set(Ax,'YLimMode','manual');
    legend({handles.Data.CellTypes.Name{PlotTypes}});

    % Process new handles
    handles.SecondaryPlots.LinkViewHandles = [handles.SecondaryPlots.LinkViewHandles Ax];
    handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];

    guidata(hObject,handles);
end

function mnPopRst_Callback(hObject, eventdata, handles)
% hObject    handle to mnShwRst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

% Request data to plot
if(length(handles.Data.CellTypes.Name)>1)
    [PlotTypes,Ok] = listdlg('ListString',handles.Data.CellTypes.Name,...
        'InitialValue',[1 2],'Name','Mean Vm',...
        'PromptString','Select populations to plot','ListSize',[200 180]);
else
    PlotTypes = [1];
    Ok = 1;
end


if(Ok)
    PlotHandles = zeros(sum(handles.Data.CellTypes.Number(PlotTypes)),1);
    IDs = zeros(size(PlotHandles));

    CumCell = [0 cumsum(handles.Data.CellTypes.Number)]; 

    [Fig,Ax] = MakeSecondaryFigure(gcbf);
    hold on    

    % Make contextmenu that is required for cell information
    cmnRasterCellInfo = uicontextmenu('Callback',@cmnRasterRequestInfo);
    mnRasterCellID = uimenu('Parent',cmnRasterCellInfo,'Enable','Off');

    PlotID = 1;
    for Type = PlotTypes
        for iCell = (1:handles.Data.CellTypes.Number(Type))+CumCell(Type)
            SP = handles.Data.NeuronSpikes.Data{iCell};
            if(~isempty(SP))        

                PlotHandles(PlotID) = plot(SP,ones(size(SP))*PlotID,handles.Data.CellTypes.Symbol{Type}, ...
                    'MarkerFaceColor',handles.Data.CellTypes.Color(Type,:),...
                    'MarkerSize',4,...
                    'MarkerEdgeColor','none',...
                    'UIContextMenu',cmnRasterCellInfo);
            end
            IDs(PlotID) = iCell;
            PlotID = PlotID+1;
        end
    end
    title('Rasterplot of selected populations');
    xlabel('time (s)');
    set(Ax,'YLimMode','manual','YDir','reverse','YTickLabel',{});

    % Process new handles for main struct
    handles.SecondaryPlots.LinkViewHandles = [handles.SecondaryPlots.LinkViewHandles Ax];
    handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];

    guidata(hObject,handles);

    % Process handles for this figure only
    FigureHandles = guidata(Fig);
    FigureHandles.Data.PlotCellIDs = IDs;
    FigureHandles.Data.PlotHandles = PlotHandles;
    guidata(Fig,FigureHandles);
end


% ------------------------------------------------------ NETWORK MENU ---
function mnShwEEG_Callback(hObject, eventdata, handles)
% hObject    handle to mnShwEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

time = (1:(handles.Data.EEG.Duration*handles.Data.EEG.SamplingRate))/handles.Data.EEG.SamplingRate;

% Make axes and plot
[Fig,Ax] = MakeSecondaryFigure(gcbf);
AddFilterMenu(Fig);     % Adds filter optionality to this figure
plot(time,handles.Data.EEG.Data);
title('Artificial EEG');
xlabel('time (s)');
ylabel('Electrode (V)');
set(Ax,'YLimMode','manual');

% Obtain handles of the new figure to store data in the figure
FigHandles = guidata(Fig);

% Store data
FigHandles.Data.T = time;
FigHandles.Data.Y = handles.Data.EEG.Data(:);
FigHandles.Data.SamplingRate = handles.Data.EEG.SamplingRate;

% Store filters
FigHandles.Filter.Low = [];
FigHandles.Filter.High = [];

guidata(Fig,FigHandles);

% Process new handles
handles.SecondaryPlots.LinkViewHandles = [handles.SecondaryPlots.LinkViewHandles Ax];
handles.SecondaryPlots.FigureHandles = [handles.SecondaryPlots.FigureHandles Fig];

guidata(hObject,handles);

% ------------------------------------------------------- WINDOW MENU ---
function mnCloseAll_Callback(hObject, eventdata, handles)
% hObject    handle to mnCloseAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);

% This function closes all secondary plot windows
close(handles.SecondaryPlots.FigureHandles);
handles.SecondaryPlots.FigureHandles = [];
handles.SecondaryPlots.LinkViewHandles = [];

guidata(hObject,handles);

% --------------------------------------------------------- HELP MENU ---
function mnDoc_Callback(hObject, eventdata, handles)
% hObject    handle to mnDoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open Documentation.pdf

function mnAbt_Callback(hObject, eventdata, handles)
% hObject    handle to mnAbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figAbt = figure('Units','pixels',...
                'Position',[700 700 300 450],...
                'WindowStyle','modal',...
                'NumberTitle','off',...
                'Name','About',...
                'Resize','off');
button = uicontrol('Style','pushbutton',...
                    'Units','pixels',...
                    'Position',[0 0 300 450],...
                    'CData',imread('About.png'),...
                    'Callback','close(gcf)');
                


% ----------------------------------------------------------- TOOLBAR ---
function tbrLoadData_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbrLoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadData(gcbf);


% ------------------------------------------------- GENERAL FUNCTIONS ---
function handles = InitializeMenu(handles)
% This function sets all checkmarks in the menu and adjusts the internal
% variables accordingly

set(handles.mnIncCon,'Checked','on');
handles.View.IncomingConnections = 1;

set(handles.mnOutCon,'Checked','on');
handles.View.OutgoingConnections = 1;

set(handles.mnIncCll,'Checked','off');
handles.View.IncomingCells = 0;

set(handles.mnOutCll,'Checked','off');
handles.View.OutgoingCells = 0;

% Some items are only available when data is loaded
set([handles.mnSltCll,handles.mnShwEEG],'Enable','Off');
set([handles.MenuOptions.CellSelected, handles.MenuOptions.SpikeData, handles.MenuOptions.VmData],'Enable','off');

function LoadData(MainFig,varargin)
handles = guidata(MainFig);

if(isempty(varargin))
    handles.Load = LoadDataFig(MainFig);
else
    handles.Load = LoadDataFig(MainFig,varargin{1});
end
uiwait(handles.Load);

handles = guidata(MainFig);
if(handles.DataLoaded == 0)
    return
end

set([handles.MenuOptions.CellSelected,handles.MenuOptions.SpikeData, handles.MenuOptions.VmData],'Enable','Off');

% if handles.ChangedNetwork
    % A new network is available
        
    % Simplify the information of the network
    handles.Data.CellTypes = InterpretCellTypes(handles.Data.CellTypesRaw);
    
    % Update network info panel
    set(handles.lblCllTtl,'String',num2str(handles.Data.nCells));
    set(handles.lblTypTtl,'String',num2str(length(handles.Data.CellTypes.Name)));


    handles.Options.Network = 0;
    handles.Options.NeuroSimNetwork = 0;

    if(isfield(handles.Data,'Network'))  % A network is given
        % Update network info panel
        set(handles.lblCllTtl,'String',num2str(handles.Data.nCells));
        set(handles.lblTypTtl,'String',num2str(length(handles.Data.CellTypes.Name)));

        if(isfield(handles.Data.Network,'ConnectionDetails'))   % NeuroSim network
            handles.Options.NeuroSimNetwork = 1;
            set(handles.lblConTtl,'String',num2str(sum(handles.Data.Network.ConnectionCount)));
        else
%             handles.Data.Network.ConnectionMatrix = (handles.Data.Network.ConnectionMatrix ~= 0);
            set(handles.lblConTtl,'String',num2str(nnz(handles.Data.Network.ConnectionMatrix)));
        end



        handles.Options.Network = 1;

    end
    
    set(handles.mnSltCll,'Enable','On');

    % Deselect current cell
    if(~isnan(handles.NeuronSelected))
        handles = DeselectNeuron(handles.NeuronSelected,handles);
    end

    % Plot the new network
    handles.NeuronSelected = NaN; % No neuron can be selected in the new plot
    handles.PlotHandles.Cells = PlotNewCells(handles.axsMain,handles.Data.CellPositions,handles.Data.CellTypes);

    handles.ChangedNetwork = 0;
% end

% if handles.ChangedData
    % A new dataset is available
    
    % Close all secondary plots, because the data is not valid anymore
    close(handles.SecondaryPlots.FigureHandles);
    handles.SecondaryPlots.FigureHandles = [];
    handles.SecondaryPlots.LinkViewHandles = [];

    % Look at spike data
    handles.Options.Vm = 0;
    handles.Options.NeuronSpikes = 0;
    if(isfield(handles.Data,'Vm'))
        % Vm is given
        % Determine the SpikeTimes of the System
        handles.Data.NeuronSpikes.Data = Vm2NeuronSpikes(handles.Data.Vm.Data,handles.Data.Vm.Threshold,handles.Data.Vm.SamplingRate);
        handles.Data.NeuronSpikes.Duration = handles.Data.Vm.Duration;

        handles.Options.Vm = 1;
        handles.Options.NeuronSpikes = 1;
        set([handles.MenuOptions.SpikeData, handles.MenuOptions.VmData],'Enable','On');

    elseif(isfield(handles.Data,'SpikeTimes'))
        % Spike times are given
        handles.Data.NeuronSpikes.Data = SpikeTimes2NeuronSpikes(handles.Data.SpikeTimes,handles.Data.nCells);
        handles.Data.NeuronSpikes.Duration = max(handles.Data.SpikeTimes(:,1));
        handles.Options.NeuronSpikes = 1;
        set(handles.MenuOptions.SpikeData,'Enable','On');

    else
        % No spike data
        try
            handles.Data = rmfield(handles.Data,'NeuronSpikes');
        end
    end

    handles.Options.EEG = 0;
    if(isfield(handles.Data,'EEG'))
        handles.Options.EEG = 1;
        set(handles.mnShwEEG,'Enable','On');
    end

    handles.ChangedData = 0;
% end

set(handles.MenuOptions.CellSelected,'Enable','Off');

guidata(MainFig,handles);


function CellTypes = InterpretCellTypes(Raw)
% This functions returns a struct containing the information of the Raw
% CellTypes, which is formated in a Nx6 cell array

nType = size(Raw,1);
CellTypes.Show = [Raw{:,1}];
CellTypes.Name = {Raw{:,2}};
CellTypes.Number = [Raw{:,3}];
CellTypes.EIType = {Raw{:,4}};
CellTypes.Symbol = {Raw{:,5}};
for iType = 1:nType
    CellTypes.Color(iType,:) = sscanf(Raw{iType,6},'[%f %f %f]',3);
end



% -------------------------------------------- NETWORK PLOT FUNCTIONS ---
function PlotHandles = PlotNewCells(axeshandle,CellPositions,CellTypes)
% This function plots all cells when a new network has to be plotted
axes(axeshandle);
reset(axeshandle);
cla
set(axeshandle,'ZDir','reverse');
hold on
box on
% daspect([1,1,15]);


PlotHandles = zeros(1,sum(CellTypes.Number));

nType = length(CellTypes.Show);

CumCell = cumsum([0 CellTypes.Number]);
for iType = 1:nType
    for iCell = CumCell(iType)+(1:CellTypes.Number(iType))
        PlotHandles(iCell) = plot3(CellPositions(iCell,1),CellPositions(iCell,2),CellPositions(iCell,3), ...
            CellTypes.Symbol{iType},'MarkerFaceColor',CellTypes.Color(iType,:), 'MarkerEdgeColor','none',...
            'ButtonDownFcn',@ClickCell);
    end
end
axis vis3d


function PlotHandles = PlotOutgoingConnections(CellId)
% This function plots the lines for the outgoing synaptic connections from
% a single neuron given by CellId
% The handles to all the plotted lines are returned in an array

handles = guidata(gcbo);

ConnectIds = find(handles.Data.Network.ConnectionMatrix(CellId,:));
nConnect = length(ConnectIds);

PlotHandles = zeros(length(ConnectIds));

for iConnection = 1:nConnect
    Cells = [CellId ConnectIds(iConnection)];
    PlotHandles(iConnection) = plot3(handles.Data.CellPositions(Cells,1),handles.Data.CellPositions(Cells,2), ...
        handles.Data.CellPositions(Cells,3),'k');
end

% Order the children of the axes such that the lines will be behind the
% other plots
Children = get(handles.axsMain,'Children');
Children = Children([(nConnect+1):end, 1:nConnect]);
set(handles.axsMain,'Children',Children);

function PlotHandles = PlotOutgoingCells(CellId)
% This function highlights the cells for the outgoing synaptic connections from
% a single neuron given by CellId
% The handles to all the plotted lines are returned in an array

handles = guidata(gcbo);

ConnectIds = find(handles.Data.Network.ConnectionMatrix(CellId,:));

PlotHandles = handles.PlotHandles.Cells(ConnectIds);

set(PlotHandles,'MarkerEdgeColor',[0 0 0]);

function PlotHandles = PlotIncomingConnections(CellId)
% This function plots the lines for the incoming synaptic connections from
% a single neuron given by CellId
% The handles to all the plotted lines are returned in an array

handles = guidata(gcbo);

ConnectIds = find(handles.Data.Network.ConnectionMatrix(:,CellId));
nConnect = length(ConnectIds);

PlotHandles = zeros(length(ConnectIds));

for iConnection = 1:nConnect
    Cells = [CellId ConnectIds(iConnection)];
    PlotHandles(iConnection) = plot3(handles.Data.CellPositions(Cells,1),handles.Data.CellPositions(Cells,2), ...
        handles.Data.CellPositions(Cells,3),'c');
end

% Order the children of the axes such that the lines will be behind the
% other plots
Children = get(handles.axsMain,'Children');
Children = Children([(nConnect+1):end, 1:nConnect]);
set(handles.axsMain,'Children',Children);

function PlotHandles = PlotIncomingCells(CellId)
% This function highlights the cells for the outgoing synaptic connections from
% a single neuron given by CellId
% The handles to all the plotted lines are returned in an array

handles = guidata(gcbo);

ConnectIds = find(handles.Data.Network.ConnectionMatrix(:,CellId));

PlotHandles = handles.PlotHandles.Cells(ConnectIds);

set(PlotHandles,'MarkerEdgeColor',[0 1 1]);

function ClickCell(src,eventdata)
handles = guidata(gcbo);


% Check if a neuron was already selected
if isnan(handles.NeuronSelected)
    % No neuron was selected before
    handles.NeuronSelected = find(handles.PlotHandles.Cells == src);
    
    handles = SelectNeuron(handles.NeuronSelected,handles);
    
else
    % A neuron was selected already
    % Check if it was the same or another
    if handles.PlotHandles.Cells(handles.NeuronSelected) == src
        % Same neuron has been clicked, deselect is
        handles = DeselectNeuron(handles.NeuronSelected,handles);
        
        handles.NeuronSelected = NaN;
        
    else
        % A different neuron has been clicked: select this and deselect old
        handles = DeselectNeuron(handles.NeuronSelected,handles);
        
        handles.NeuronSelected = find(handles.PlotHandles.Cells == src);
        
        handles = SelectNeuron(handles.NeuronSelected,handles);
    end
end
guidata(gcbo,handles);

function handles = SelectNeuron(CellId,handles)
% This function performs all actions to select a neuron

% Update the info panel
set(handles.lblCllId,'String',num2str(CellId));
CumCell = cumsum(handles.Data.CellTypes.Number); 
Type = find(CumCell>=CellId,1); % Identify type of neuron
set(handles.lblCllTyp,'String',handles.Data.CellTypes.Name{Type});
if(handles.Options.Network)
    % Find connections and count them:
    ConIn = find(handles.Data.Network.ConnectionMatrix(:,CellId));
    set(handles.lblIncCon,'String',num2str(length(ConIn)));
    
    ConOut = find(handles.Data.Network.ConnectionMatrix(CellId,:));
    set(handles.lblOutCon,'String',num2str(length(ConOut)));
    
    % Make histograms of the connections, categorize by cell type:
    Borders = 1+[0 CumCell];
    CountIn = histc(ConIn,Borders);
    CountOut = histc(ConOut,Borders);
    
    TypeIn = find(CountIn);
    TypeOut = find(CountOut);
    
    if(length(ConIn)>0)
        H = pie(handles.axsIncCon,CountIn(TypeIn),{handles.Data.CellTypes.Name{TypeIn}});
        % The ColorMap option seems to be buggy, use for-loop instead:
        for iFace=1:length(TypeIn)
            set(H(2*iFace-1),'FaceColor',handles.Data.CellTypes.Color(TypeIn(iFace),:));
        end
    end
       
    if(length(ConOut)>0)
        H = pie(handles.axsOutCon,CountOut(TypeOut),{handles.Data.CellTypes.Name{TypeOut}});
        for iFace=1:length(TypeOut)
            set(H(2*iFace-1),'FaceColor',handles.Data.CellTypes.Color(TypeOut(iFace),:));
        end    
    end

end

% Change appearance of neuron
ColorSelect = [1 0 1];
set(handles.PlotHandles.Cells(handles.NeuronSelected),'MarkerEdgeColor',ColorSelect);

% See if other stuff has to be plotted:
if(handles.Options.Network)
    if(handles.View.OutgoingConnections == 1)
        handles.PlotHandles.OutgoingConnections = PlotOutgoingConnections(handles.NeuronSelected);
    end
    if handles.View.OutgoingCells
        handles.PlotHandles.OutgoingCells = PlotOutgoingCells(handles.NeuronSelected);
    end

    if(handles.View.IncomingConnections == 1)
        handles.PlotHandles.IncomingConnections = PlotIncomingConnections(handles.NeuronSelected);
    end
    if handles.View.IncomingCells
        handles.PlotHandles.IncomingCells = PlotIncomingCells(handles.NeuronSelected);
    end
end

% Update items in the menu
if(handles.Options.Vm)
    set(intersect(handles.MenuOptions.CellSelected,handles.MenuOptions.VmData),'Enable','On');
end
if(handles.Options.NeuronSpikes)
    set(intersect(handles.MenuOptions.CellSelected,handles.MenuOptions.SpikeData),'Enable','On');
end

function handles = DeselectNeuron(CellId,handles)
% This function performs all actions to deselect a neuron

% Update the info panel
set(handles.lblCllId,'String','--');
set(handles.lblCllTyp,'String','--');
set(handles.lblIncCon,'String','--');
set(handles.lblOutCon,'String','--');

cla(handles.axsIncCon);
cla(handles.axsOutCon);

% Change appearance of neuron
set(handles.PlotHandles.Cells(CellId),'MarkerEdgeColor','none');

% See if stuff has to be cleaned up:
try,
    delete(handles.PlotHandles.OutgoingConnections);
    handles.PlotHandles.OutgoingConnections = [];
end
try,
set(handles.PlotHandles.OutgoingCells,'MarkerEdgeColor','none');
handles.PlotHandles.OutgoingCells = [];
end
try,
    delete(handles.PlotHandles.IncomingConnections);
    handles.PlotHandles.IncomingConnections = [];
end
try,
set(handles.PlotHandles.IncomingCells,'MarkerEdgeColor','none');
handles.PlotHandles.IncomingCells = [];
end

% Update items in the menu
set(handles.MenuOptions.CellSelected,'Enable','Off');




% ------------------------------------------ SECONDARY PLOT FUNCTIONS ---
function [FigHandle, AxesHandle] = MakeSecondaryFigure(ParentHandle)
% This functions generates a modified secondary plot window for details of
% the network

% Make figure and axes
FigHandle = figure;
AxesHandle = axes;
set(FigHandle,'DeleteFcn',@DeleteSecondaryPlot)
handles = guidata(FigHandle);

% Add some stuff to the menu
handles.mnSkuld = uimenu(FigHandle,'Label','Skuld');
handles.mnLinkView = uimenu(handles.mnSkuld,'Label','Link view',...
                                            'Checked','On',...
                                            'Callback',@secplotmnLinkView);

% Modify the view tools
ZoomFunc = zoom(FigHandle);
PanFunc = pan(FigHandle);
set([ZoomFunc PanFunc],'ActionPostCallback',@secplotLinkView);

% Set variables

handles.Handles.Parent = ParentHandle;
handles.Handles.Axes = AxesHandle;

handles.LinkView = 1;
%handles.Handles.mnLinkView = mnLinkView;

guidata(FigHandle,handles);


function secplotmnLinkView(src,eventdata)
% This function toggles the LinkView option of the figure

handles = guidata(gcbf);

handles.LinkView = 1 - handles.LinkView;
if(handles.LinkView == 1)
    % Update menu
    set(handles.mnLinkView,'Checked','On');
    
    % Obtain handles from main figure and add this axes handle
    MainHandles = guidata(handles.Handles.Parent);
    MainHandles.SecondaryPlots.LinkViewHandles = [MainHandles.SecondaryPlots.LinkViewHandles handles.Handles.Axes];
    
    % Store new MainHandles
    guidata(handles.Handles.Parent,MainHandles);
    
else
    % Update menu
    set(handles.mnLinkView,'Checked','Off');

    % Obtain data from main figure and delete this axes handle
    MainHandles = guidata(handles.Handles.Parent);
    ID = find(MainHandles.SecondaryPlots.LinkViewHandles == handles.Handles.Axes);
    MainHandles.SecondaryPlots.LinkViewHandles(ID) = [];
    
    % Store new data
    guidata(handles.Handles.Parent,MainHandles);
end

guidata(gcbf,handles);

function secplotLinkView(src, eventdata)
% This function sets the X-limits of all linked windows similar to this one

fighandle = get(eventdata.Axes,'Parent');
handles = guidata(fighandle);

% If figure set to LinkView, zoom others as well
if(handles.LinkView == 1)
    % Obtain handle of main figure and retrieve the list of linked windows
    MainHandles = guidata(handles.Handles.Parent);
    HandleList =  MainHandles.SecondaryPlots.LinkViewHandles;

    % Obtain XLim from this window (hence new view range) and apply to other
    rng = get(eventdata.Axes,'XLim');
    set(HandleList,'XLim',rng);
end

function DeleteSecondaryPlot(src,eventdata)
% This functions is called when a secondary plot window is closed. It
% removes the related handles from all lists
handles = guidata(src);
MainHandles = guidata(handles.Handles.Parent); % handles from main figure

IDax = find(MainHandles.SecondaryPlots.LinkViewHandles == handles.Handles.Axes);
MainHandles.SecondaryPlots.LinkViewHandles(IDax) = [];

IDfig = find(MainHandles.SecondaryPlots.FigureHandles == src);
MainHandles.SecondaryPlots.FigureHandles(IDfig) = [];

% Updata MainHandles
guidata(handles.Handles.Parent,MainHandles);

% ---------------------------------------------- BUTTERWORTH FILTERS ----
function AddFilterMenu(FigHandle)
% This function adds the filter options to the plot window

% Obtain handles:
handles = guidata(FigHandle);

% Add menu items
handles.mnHighPassSwitch = uimenu(handles.mnSkuld,'Label','High pass filter',...
                                                    'Separator','on',...
                                                    'Checked','off',...
                                                    'Callback',@secplotmnHighPassSwitch_Callback);
handles.mnHighPassEdit = uimenu(handles.mnSkuld,'Label','  Modify',...
                                                    'Callback',@secplotmnHighPassEdit_Callback);

handles.mnLowPassSwitch = uimenu(handles.mnSkuld,'Label','Low pass filter',...
                                                    'Separator','on',...
                                                    'Checked','off',...
                                                    'Callback',@secplotmnLowPassSwitch_Callback);
handles.mnLowPassEdit = uimenu(handles.mnSkuld,'Label','  Modify',...
                                                    'Callback',@secplotmnLowPassEdit_Callback);
                                                
% Set both modify buttons to idle
set([handles.mnHighPassEdit handles.mnLowPassEdit],'Enable','off');
handles.Filter.HighPassOn = 0;
handles.Filter.LowPassOn = 0;

guidata(FigHandle,handles);

function secplotmnLowPassSwitch_Callback(src,eventdata)
% This function turns the low pass filter on the data on/off
handles = guidata(gcf);

handles.Filter.LowPassOn = 1 - handles.Filter.LowPassOn;


if(handles.Filter.LowPassOn == 1)
    set(handles.mnLowPassSwitch,'Checked','on');
    set(handles.mnLowPassEdit,'Enable','on');
    
    % If no filter has been set previously, new settings are prompted
    if(numel(handles.Filter.Low) == 0) 
        % Give dialog box for settings
        Prefs=inputdlg({'Order','Cut-off (Hz)'},'Low-pass Butterworth',1,{'2','80'});

        % Check whether OK has been pressed
        if(~isempty(Prefs))
            % Design filter
            [b,a] = butter(str2num(Prefs{1}),2*str2num(Prefs{2})/handles.Data.SamplingRate,'low');
            handles.Filter.Low = [a;b];
            handles.Filter.LowSettings = Prefs;
        else
            % Filter activation has been cancelled, restore everything
            handles.Filter.LowPassOn = 0;
            set(handles.mnLowPassSwitch,'Checked','off');
            set(handles.mnLowPassEdit,'Enable','off');

            handles.Filter.Low = [];
        end
    end
    
    % Store filter 'locally'
    Low = handles.Filter.Low;
else
    set(handles.mnLowPassSwitch,'Checked','off');
    set(handles.mnLowPassEdit,'Enable','off');

    Low = [];
end

% Determine whether the High-pass filter is activated
if(handles.Filter.HighPassOn == 1)
    High = handles.Filter.High;
else
    High = [];
end
    
% Apply filters to data and plot
FilterAndPlot(handles.Handles.Axes,...
                handles.Data.T, handles.Data.Y,...
                High, Low);
            
% Store handles
guidata(gcf,handles);

function secplotmnLowPassEdit_Callback(src,eventdata)
% This function turns the low pass filter on the data on/off
handles = guidata(gcf);

Prefs=inputdlg({'Order','Cut-off (Hz)'},'Low-pass Butterworth',1,handles.Filter.LowSettings);

if(~isempty(Prefs))
    % OK has been clicked, store new filter
    handles.Filter.LowSettings = Prefs;
else
    % Don't change filter when cancel has been hit
    Prefs = handles.Filter.LowSettings;
end

% Design filter
[b,a] = butter(str2num(Prefs{1}),2*str2num(Prefs{2})/handles.Data.SamplingRate,'low');
handles.Filter.Low = [a;b];

% Store filter 'locally'
Low = handles.Filter.Low;

% Determine whether the High-pass filter is activated
if(handles.Filter.HighPassOn == 1)
    High = handles.Filter.High;
else
    High = [];
end
    
% Apply filters to data and plot
FilterAndPlot(handles.Handles.Axes,...
                handles.Data.T, handles.Data.Y,...
                High, Low);
            
% Store handles
guidata(gcf,handles);

function secplotmnHighPassSwitch_Callback(src,eventdata)
% This function turns the low pass filter on the data on/off
handles = guidata(gcf);

handles.Filter.HighPassOn = 1 - handles.Filter.HighPassOn;


if(handles.Filter.HighPassOn == 1)
    set(handles.mnHighPassSwitch,'Checked','on');
    set(handles.mnHighPassEdit,'Enable','on');
    
    % If no filter has been set previously, new settings are prompted
    if(numel(handles.Filter.High) == 0) 
        % Give dialog box for settings
        Prefs=inputdlg({'Order','Cut-off (Hz)'},'High-pass Butterworth',1,{'1','2'});

        % Check whether OK has been pressed
        if(~isempty(Prefs))
            % Design filter
            [b,a] = butter(str2num(Prefs{1}),2*str2num(Prefs{2})/handles.Data.SamplingRate,'high');
            handles.Filter.High = [a;b];
            handles.Filter.HighSettings = Prefs;
        else
            % Filter activation has been cancelled, restore everything
            handles.Filter.HighPassOn = 0;
            set(handles.mnHighPassSwitch,'Checked','off');
            set(handles.mnHighPassEdit,'Enable','off');

            handles.Filter.High = [];
        end
    end
    
    % Store filter 'locally'
    High = handles.Filter.High;
else
    set(handles.mnHighPassSwitch,'Checked','off');
    set(handles.mnHighPassEdit,'Enable','off');

    High = [];
end

% Determine whether the High-pass filter is activated
if(handles.Filter.LowPassOn == 1)
    Low = handles.Filter.Low;
else
    Low = [];
end
    
% Apply filters to data and plot
FilterAndPlot(handles.Handles.Axes,...
                handles.Data.T, handles.Data.Y,...
                High, Low);
            
% Store handles
guidata(gcf,handles);

function secplotmnHighPassEdit_Callback(src,eventdata)
% This function turns the low pass filter on the data on/off
handles = guidata(gcf);

Prefs=inputdlg({'Order','Cut-off (Hz)'},'High-pass Butterworth',1,handles.Filter.HighSettings);

if(~isempty(Prefs))
    % OK has been clicked, store new filter
    handles.Filter.HighSettings = Prefs;
else
    % Don't change filter when cancel has been hit
    Prefs = handles.Filter.HighSettings;
end

% Design filter
[b,a] = butter(str2num(Prefs{1}),2*str2num(Prefs{2})/handles.Data.SamplingRate,'high');
handles.Filter.High = [a;b];

% Store filter 'locally'
High = handles.Filter.High;

% Determine whether the High-pass filter is activated
if(handles.Filter.LowPassOn == 1)
    Low = handles.Filter.Low;
else
    Low = [];
end
    
% Apply filters to data and plot
FilterAndPlot(handles.Handles.Axes,...
                handles.Data.T, handles.Data.Y,...
                High, Low);
            
% Store handles
guidata(gcf,handles);

function FilterAndPlot(AxesHandle,T,Y,High,Low)
% This function applies the specified filters to the given data set and
% plots the result in the axes indicated by AxesHandle.

% First store the current figure settings:
Lims = get(AxesHandle,{'XLim','YLim'});

% A high pass filter is defined:
if(~isempty(High))
    Y = filter(High(2,:),High(1,:),Y,[],1);
end
% A low pass filter is defined:
if(~isempty(Low))
    Y = filter(Low(2,:),Low(1,:),Y,[],1);
end

% Plot and set axes limits to original values.
plot(AxesHandle,T,Y);
axis(AxesHandle,[Lims{:}]);

% ------------------------------------------- RASTER PLOT EXTENSIONS ----
function AddAlignRasterMenu(FigHandle)
% Obtain handles:
handles = guidata(FigHandle);

% Add menu item
handles.mnAlignRaster = uimenu(handles.mnSkuld,'Label','Delay correction',...
                                                'Separator','on',...
                                                'Checked','off',...
                                                'Callback',@secplotmnAlignRaster_Callback);
                                                
% Currently not aligned
handles.AlignRaster = 0;

guidata(FigHandle,handles);

function cmnRasterRequestInfo(src,eventdata)
% This function is called when the UIContextMenu is requested to show the
% cell ID of a slected cell

% Get handles of this figure
handles = guidata(gcf);

% Find cell ID
plotID = find(handles.Data.PlotHandles == gco); % find the ID of the plot
ID = handles.Data.PlotCellIDs(plotID);

mnName = get(src,'Children'); % Get the menu item that actually displays the name
set(mnName,'Label',num2str(ID));

function secplotmnAlignRaster_Callback(src,eventdata)
% This function aligns the APs in the rasterplot such that the dots
% represent PSPs

handles = guidata(gcf);

% First store the current figure settings:
Lims = get(handles.Handles.Axes,{'XLim','YLim'});

% Change state:
handles.AlignRaster = 1 - handles.AlignRaster;

if(handles.AlignRaster == 1)
    set(handles.mnAlignRaster,'Checked','on');
    
    % Re-align spikes by adding Delays
    for iCell = 1:length(handles.Data.Delays)
        
        % Access XData of plot and shift it
        if(handles.Data.PlotHandles(iCell) ~= 0)
            X = get(handles.Data.PlotHandles(iCell),'XData');
            set(handles.Data.PlotHandles(iCell),'XData',X + handles.Data.Delays(iCell));
        end
    end
else
    set(handles.mnAlignRaster,'Checked','off');
    
    % Align spikes by subtracting Delays
    for iCell = 1:length(handles.Data.Delays)
        
        % Access XData of plot and shift it
        if(handles.Data.PlotHandles(iCell) ~= 0)
            X = get(handles.Data.PlotHandles(iCell),'XData');
            set(handles.Data.PlotHandles(iCell),'XData',X - handles.Data.Delays(iCell));
        end
    end
end

% Restore axis limits
axis(handles.Handles.Axes,[Lims{:}]);


guidata(gcf,handles);

% ----------------------------------------------- VM PLOT EXTENSIONS ----
function AddPlaySoundToolbar(FigHandle)
% Fetch handles
handles = guidata(FigHandle);

% Get picture:
iconDir = fullfile(matlabroot,'toolbox','matlab','icons');
[Temp,map] = imread(fullfile(iconDir,'greenarrowicon.gif'));
iconPlay = ind2rgb(Temp,map);

% Find handle of current toolbar:
ht = findall(FigHandle,'Tag','FigureToolBar');
 
% Make objects
if(~isempty(ht))
    handles.tbrLoadData = uipushtool('Parent',ht,...
                                    'CData',iconPlay,...
                                    'TooltipString','Play as sound',...
                                    'ClickedCallback',@secplottbrPlaySound_ClickedCallback);
else
    handles.tbrLoadData = uipushtool('CData',iconPlay,...
                                    'TooltipString','Play as sound',...
                                    'ClickedCallback',@secplottbrPlaySound_ClickedCallback);
end

guidata(FigHandle,handles);

function secplottbrPlaySound_ClickedCallback(hObject, eventdata)

handles = guidata(hObject);
soundsc(handles.Data.Y,handles.Data.SamplingRate);
    
    