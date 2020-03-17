function writeColumn(xlFile,col,top,bottom,data)
% a wrapper for xlswrite
    xlRange = [col,num2str(top),':',col,num2str(bottom)];
    xlswrite(xlFile,data,xlRange)
end