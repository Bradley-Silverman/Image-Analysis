function out = findPercentile(numTable,percentile)
labels = numTable(:,1);
weight = numTable(:,2);
targetNum = percentile*sum(weight);
x = 0;
y = 0;
while x<targetNum
    y=y+1;
    x = x+ weight(y);
    
end
out = labels(y);
