function myString = transform2text(Minv)
% returns transform as text formated as python array ( to pase into
% the database )

myString = (['[[',num2str(Minv(1,1)),',',num2str(Minv(1,2)),',',num2str(Minv(1,3)),',',num2str(Minv(1,4)),'],'...
    '[',num2str(Minv(2,1)),',',num2str(Minv(2,2)),',',num2str(Minv(2,3)),',',num2str(Minv(2,4)),'],'...
    '[',num2str(Minv(3,1)),',',num2str(Minv(3,2)),',',num2str(Minv(3,3)),',',num2str(Minv(3,4)),'],'...
    '[',num2str(Minv(4,1)),',',num2str(Minv(4,2)),',',num2str(Minv(4,3)),',',num2str(Minv(4,4)),']]']);
end