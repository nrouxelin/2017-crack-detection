function d=diver(p1,p2)

[n1 m1 l1] = size(p1);
[n2 m2 l2] = size(p2);

div1 = [p1(1,:,:); p1(2:end-1,:,:)-p1(1:end-2,:,:); -p1(end-1,:,:)];
div2 = [p2(:,1,:), p2(:,2:end-1,:)-p2(:,1:end-2,:), -p2(:,end-1,:)];

d = div1+div2;
end