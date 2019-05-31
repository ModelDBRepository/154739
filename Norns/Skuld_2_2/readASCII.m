function Data = readASCII(FileName,nRow,nCol)
% This function reads a large ASCII files indicated by FileName
Data = zeros(nRow,nCol);

Fid = fopen(FileName, 'r');

% for iRow = 1:nRow
%     temp = textscan(Fid,'%f',nCol);
%     Data(iRow,:) = temp{1};
% end

Data = fscanf(Fid,'%f',[nCol,nRow])';

fclose(Fid);