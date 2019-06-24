function runOptimization(robot)
    if strcmp(robot.name,'nao')
        for i=1:robot.optProperties.offsets.optRepetitions
            sprintf('Repetition %d of %d',i,robot.optProperties.offsets.optRepetitions)
            robot.optProperties=reloadParametersNAO(robot.optProperties);
            optAll2(robot);
            robot.optProperties.loadOptimizedPatches=-1;
            robot.optProperties.loadOptimizedPatches2=-1;
            robot.optProperties.loadOptimizedPatches3=-1;
            robot.optProperties.loadOptimizedTriangles=-1;
            robot.optProperties.loadOptimizedTriangles2=-1;
            robot.optProperties.loadOptimizedTriangles3=-1;
            callPythonParsing(robot);
        end
%         rng(0,'twister');
%         a = 0.03;
%         b = 0.25;
%         if robot.optProperties.offsets.optimize
%             %callPythonParsing(robot);
%             for i=1:robot.optProperties.offsets.optRepetitions
%                 robot.optProperties=reloadParametersNAO(robot.optProperties);
%                 optimizeOffsets(robot);
%                 robot.optProperties.loadOptimizedOffsets=-1;
%                 robot.optProperties.loadOptimizedOffsets2=-1;
%                 callPythonParsing(robot);
%             end
%         end
%         if robot.optProperties.patches.optimize
%             %callPythonParsing(robot);
%             for i=1:robot.optProperties.patches.optRepetitions
%                 robot.optProperties=reloadParametersNAO(robot.optProperties);
%                 optimizePatches(robot);
%                 robot.optProperties.loadOptimizedPatches=-1;
%                 robot.optProperties.loadOptimizedPatches2=-1;
%                 callPythonParsing(robot);
% %                 visualizeNAO(robot,'distances',strcat('patchesAfter',num2str(i)))
% %                 visualizeNAO(robot,'statistics',strcat('patchesAfter',num2str(i)))
%             end
%         end
%         if robot.optProperties.triangles.optimize
%             %callPythonParsing(robot);
%             for i=1:robot.optProperties.triangles.optRepetitions
%                 robot.optProperties=reloadParametersNAO(robot.optProperties);
%                 optimizeTriangles(robot);
%                 robot.optProperties.loadOptimizedTriangles=-1;
%                 robot.optProperties.loadOptimizedTriangles2=-1;
%                 callPythonParsing(robot);
%             end
%         end
    end
end