function [ret, err] = FindValue(C,Label,Kind,n)
% returns the value of a variable described in cell array C of form:
% err-flag takes following values:
%   0 = no error
%   1 = No occurence of Label in C
%   2 = Multiple occurences of Label in C
%   3 = Return value not specified
%   4 = Return value not of specified Kind
%   5 = Return value not of proper size (if provided as array)
%   6 = Numeric return value misses distribution arguments
%   7 = Numeric return value has distribution other than 'Uniform' or 'Normal'
%   8 = Numeric return value has incorrect distribution arguments

ret = 0;
err = 0;
% Find position of Label in C:
ID = find(strcmp(Label,C));
% Check for non-unique occurences:
if(numel(ID) == 0)
    err = 1; return;
elseif(numel(ID) > 1)
    err = 2; return;
end

if(ID==numel(C))
    err = 3; return;
end

Arg = ID + 1;
% If result should be string:
if(strcmp('s',Kind))
    ret = C{Arg};
end

% If result should be numeric:
if(strcmp('n',Kind))
    if(isnumeric(C{Arg})) % C{Arg} is number or an array
        if(numel(C{Arg})==1) % constant expression, return array of proper size:    
            ret = C{Arg}*ones(n,1); return;
        elseif(numel(C{Arg})==n) % Array is given, check if     
            ret = reshape(C{Arg},n,1); return;
        else % Provided array does not contain proper amount of elements
            err = 5; return;
        end
    else % return value is given by a distribution
        if(Arg == numel(C))
            err = 6; return;
        end
        dArg = Arg + 1;
        
        if(~isnumeric(C{dArg}) && numel(C{dArg}) ~= 2)
            err = 8; return;
        end
        
        switch(C{Arg})
            case('Uniform')
                ret = diff(C{dArg})*rand(n,1)+C{dArg}(1);
                return;
            case('Normal')
                ret = C{dArg}(2)*randn(n,1)+C{dArg}(1);
                return;
        end
%     else
%         err = 4;
%         return
    end
end
        