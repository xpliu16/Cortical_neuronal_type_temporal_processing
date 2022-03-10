function exportxls(xls_filename, sheetname, ID, x, y, xlab, ylab, indsxls, i)

range_unit = ['A' num2str((length(indsxls)+2)*(i-1)+1) ':A' num2str((length(indsxls)+2)*(i-1)+1)];
range_xlab = ['B' num2str((length(indsxls)+2)*(i-1)+1) ':B' num2str((length(indsxls)+2)*(i-1)+1)];
range_ylab = ['C' num2str((length(indsxls)+2)*(i-1)+1) ':C' num2str((length(indsxls)+2)*(i-1)+1)];
xlswrite(xls_filename,{ID},sheetname,range_unit); 
xlswrite(xls_filename,{xlab},sheetname,range_xlab);
xlswrite(xls_filename,{ylab},sheetname,range_ylab); 

range1 = ['B' num2str((length(indsxls)+2)*(i-1)+2) ':B' num2str((length(indsxls)+2)*i-1)];
xlswrite(xls_filename,x(:),sheetname,range1);
%range2 = ['C' num2str((length(indsxls)+2)*(i-1)+2) ':C' num2str((length(indsxls)+2)*i-1)];
range2 = ['C' num2str((length(indsxls)+2)*(i-1)+2)];
if min(size(y))==1
    % If vector, make a column
    xlswrite(xls_filename,y(:),sheetname,range2);
else
    xlswrite(xls_filename,y,sheetname,range2);
end