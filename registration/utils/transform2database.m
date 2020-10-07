function transform2database(transform,fish_id,save_to)
% saves matrix in a python format to a specified line of xls file
%Input:
% transform - 4x4 matrix, affine transform for row-vectors

transform_as_string = [fish_id,':\n',transform2text(transform),'\n'];

fid = fopen(save_to,'at');
fprintf(fid, transform_as_string);
fclose(fid);

% TODO:
%     if display
%         disp(' ')
%         disp('Paste into Synapse Database : ')
%         disp(matrix2text);
%     end
end