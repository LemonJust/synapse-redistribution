function Minv = itkSnap2affine(transform_file)
% takes a transform from itk Snap and turns into a matrix usable for
% affine transform in matlab
% Anna N. 2020

% load txt file from ITK-SNAP
t = readtable(transform_file,...
    'HeaderLines', 3,'ReadRowNames',true,'ReadVariableNames',false,...
    'Format','%s %f%f%f%f%f%f%f%f%f%f%f%f');
% get A 
A = table2array(t('Parameters',:));
matrix = transpose(reshape(A(1:9),3,3));
m_Translation = A(10:12);
% get Center
m_Center = rmmissing(table2array(t('FixedParameters',:)));

% compute offset (see ANTs documentation for details)
offset = zeros(3,1);
for i = 1:3
    offset(i) = m_Translation(i) + m_Center(i);
    for j = 1:3
        offset(i) = offset(i) - matrix(i,j)*m_Center(j);
    end
end

% compose matrix
M(1:3,1:3) = matrix;
M(4,1:3) = zeros(1,3);
M(1:3,4) = offset;
M(4,4) = 1;
Minv = inv(M);
Minv = Minv.';
end