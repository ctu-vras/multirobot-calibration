function [training,testing]=splitDataset(robot, len, repetitions)

    newPerm=randperm(len); %Random numbers from 1 to dataset length
    testing=newPerm(round(len*0.7)+1:end); % Last 30% is testing dataset
    trainingPart=newPerm(1:round((len)*0.7)); %First 70% is for training

    training=cell(len,1);
    for i=1:repetitions
        trainingPermed=trainingPart(randperm(length(trainingPart))); %New permuation of training part 
        trainingBatch=trainingPermed(1:round(length(trainingPermed))); %Get only batchSize percents
        training{i}=trainingBatch;
    end
    
end