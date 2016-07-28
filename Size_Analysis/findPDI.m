function out = findPDI(table)
numberWeightedAverage = sum(table(:,1).*table(:,2))/sum(table(:,2));
weightWeightedAverage = sum(table(:,2).*table(:,1).^2)/sum(table(:,1).*table(:,2));
out = weightWeightedAverage/numberWeightedAverage;
end