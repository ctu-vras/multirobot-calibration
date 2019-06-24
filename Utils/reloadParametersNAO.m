function optProperties=reloadParametersNAO(optProperties)
        if ~optProperties.optSecond
            delimiterIn = ' ';
            headerlinesIn = 1;
            optProperties.DHFilename = importdata(optProperties.filename,delimiterIn,headerlinesIn);
            optProperties.DH2Filename = importdata(optProperties.filename2,delimiterIn,headerlinesIn);
            optProperties.triangles1Filename = importdata(optProperties.filenameT,delimiterIn,headerlinesIn);
            optProperties.triangles2Filename = importdata(optProperties.filenameT2,delimiterIn,headerlinesIn);
            optProperties.patches1Filename = importdata(optProperties.filenameP,delimiterIn,headerlinesIn);
            optProperties.patches2Filename = importdata(optProperties.filenameP2,delimiterIn,headerlinesIn);
            optProperties.DH3Filename=importdata(optProperties.filenameTwoChains,delimiterIn,headerlinesIn);
            optProperties.patches3Filename = importdata(optProperties.filenameTwoChainsP,delimiterIn,headerlinesIn);
            optProperties.triangles3Filename = importdata(optProperties.filenameTwoChainsT,delimiterIn,headerlinesIn);
        else
            %disp('DDDD')
            delimiterIn = ' ';
            headerlinesIn = 1;
            optProperties.DHFilename = importdata(optProperties.filename2,delimiterIn,headerlinesIn);
            optProperties.DH2Filename = importdata(optProperties.filenameBack,delimiterIn,headerlinesIn);
            optProperties.triangles1Filename = importdata(optProperties.filenameT2,delimiterIn,headerlinesIn);
            optProperties.triangles2Filename = importdata(optProperties.filenameT,delimiterIn,headerlinesIn);
            optProperties.patches1Filename = importdata(optProperties.filenameP2,delimiterIn,headerlinesIn);
            optProperties.patches2Filename = importdata(optProperties.filenameP,delimiterIn,headerlinesIn);
            optProperties.DH3Filename=importdata(optProperties.filenameTwoChains,delimiterIn,headerlinesIn);
            optProperties.patches3Filename = importdata(optProperties.filenameTwoChainsP,delimiterIn,headerlinesIn);
            optProperties.triangles3Filename = importdata(optProperties.filenameTwoChainsT,delimiterIn,headerlinesIn);
        end
        if optProperties.loadOptimizedOffsets==-1
            optProperties.DH=optProperties.DHFilename.data(end,:);
        else
            optProperties.DH=optProperties.DHFilename.data(optProperties.loadOptimizedOffsets+1,:);
        end

        if optProperties.loadOptimizedOffsets2==-1
            optProperties.DH2=optProperties.DH2Filename.data(end,:);
        else
            optProperties.DH2=optProperties.DH2Filename.data(optProperties.loadOptimizedOffsets2+1,:);
        end
        
        
        if optProperties.loadOptimizedOffsets3==-1
            optProperties.DH3=optProperties.DH3Filename.data(end,:);
        else
            optProperties.DH3=optProperties.DH3Filename.data(optProperties.loadOptimizedOffsets3+1,:);
        end

        if optProperties.loadOptimizedTriangles == -1
           optProperties.triangles1=optProperties.triangles1Filename.data(size(optProperties.triangles1Filename.data,1)-31:end,:); 
        else
           optProperties.triangles1=optProperties.triangles1Filename.data(32*optProperties.loadOptimizedTriangles+1:32*optProperties.loadOptimizedTriangles+1+31,:); 
        end

        if optProperties.loadOptimizedTriangles2 == -1
           optProperties.triangles2=optProperties.triangles2Filename.data(size(optProperties.triangles2Filename.data,1)-31:end,:); 
        else
           optProperties.triangles2=optProperties.triangles2Filename.data(32*optProperties.loadOptimizedTriangles2+1:32*optProperties.loadOptimizedTriangles2+1+31,:); 
        end
        
        if optProperties.loadOptimizedTriangles3 == -1
           optProperties.triangles3=optProperties.triangles3Filename.data(size(optProperties.triangles3Filename.data,1)-31:end,:); 
        else
           optProperties.triangles3=optProperties.triangles3Filename.data(32*optProperties.loadOptimizedTriangles3+1:32*optProperties.loadOptimizedTriangles3+1+31,:); 
        end

        if optProperties.loadOptimizedPatches==-1
            optProperties.patches1=optProperties.patches1Filename.data(size(optProperties.patches1Filename.data,1)-1:end,:);
        else
            optProperties.patches1=optProperties.patches1Filename.data(2*optProperties.loadOptimizedPatches+1:2*optProperties.loadOptimizedPatches+1+1,:); 
        end

        if optProperties.loadOptimizedPatches2==-1
            optProperties.patches2=optProperties.patches2Filename.data(size(optProperties.patches2Filename.data,1)-1:end,:);
        else
            optProperties.patches2=optProperties.patches2Filename.data(2*optProperties.loadOptimizedPatches2+1:2*optProperties.loadOptimizedPatches2+1+1,:); 
        end
        
        if optProperties.loadOptimizedPatches3==-1
            optProperties.patches3=optProperties.patches3Filename.data(size(optProperties.patches3Filename.data,1)-1:end,:);
        else
            optProperties.patches3=optProperties.patches3Filename.data(2*optProperties.loadOptimizedPatches3+1:2*optProperties.loadOptimizedPatches3+1+1,:); 
        end
    end