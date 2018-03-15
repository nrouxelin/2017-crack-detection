function [gx gy]=grad(u)
[n m l] = size(u);

gx = [u(2:end,:,:)-u(1:end-1,:,:); zeros(1,m,l)];
gy = [u(:,2:end,:)-u(:,1:end-1,:) zeros(n,1,l)];

end