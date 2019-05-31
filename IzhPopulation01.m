function dX = Izh03(t,X,P)

V = X(1);
u = X(2);
S = X(3);


a = P.a;
b = P.b;
c = P.c;
d = P.d;

I = P.I(t);

% fmin = 0.45;
fmin = 0.2;

% if(V>c)
%     
%     T=@(j,g) (log(12.5+g/5-j/2)-log(12.5+g/5+j/2))*5/j;
%     i = sqrt(65-4*(I-u));
%     
% %     f = 1/2.2;
%     f=1/(T(i,30)-T(i,c));
% else
%     f = 0;
% end

H = 1/(1+exp(-20*(V-(c-0))));

T=@(j,g) (log(12.5+g/5-j/2)-log(12.5+g/5+j/2))*5/j;
i = sqrt(65-4*(I-u));

f=fmin;
% if(V>c)
%     f=1/(T(i,30)-T(i,c));
%     if(~isreal(f))
%         f = fmin;
%     end
%     f = max(f,fmin);
% else
% %     f=0;
% end

if(0.04*c*c+5*c+140+I-u>0)
    f=1/(T(i,30)-T(i,c));
    f = max(f,fmin);
else
    f = fmin;
end
f = f*H;



% Determine coefficients for new branch beta*exp(alpha*V)
gamma=0.8;
f_c = 0.04*c*c+5*c+140+I-u;
f_cg = 0.04*(c+gamma)*(c+gamma)+5*(c+gamma) + 140+I-u;
df_cg = 0.08*(c+gamma)+5;
alpha = df_cg/(f_cg-f_c);
beta = (f_cg-f_c)/exp(alpha*gamma);

dV = (0.04*V*V + 5*V + 140 + I - u) - beta*exp(alpha*(V-c)) + S*P.g*(P.ESyn - V);
du = a*(b*V-u) + f*d;
dS = f - S / P.tauSyn;


dX = [dV; du; dS];