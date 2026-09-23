classdef TestTaylorApproximation < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addSource(testCase)
            root = fileparts(fileparts(mfilename('fullpath')));
            addpath(fullfile(root,'src'));
        end
    end
    methods (Test)
        function zeroAndDegreeZero(testCase)
            testCase.verifyEqual(numapprox.sinTaylorRecurrence(0,15),0,'AbsTol',0);
            testCase.verifyEqual(numapprox.sinTaylorRecurrence(0.7,0),0,'AbsTol',0);
        end
        function accuracyOnSafeDomain(testCase)
            x = linspace(-1,1,101);
            testCase.verifyLessThan(max(abs(numapprox.sinTaylorRecurrence(x,21)-sin(x))),1e-15);
        end
        function explicitOddSymmetry(testCase)
            x = [-2 -0.4 0 0.7 2];
            yPositive = numapprox.sinTaylorRecurrence(x,25);
            yNegative = numapprox.sinTaylorRecurrence(-x,25);
            testCase.verifyLessThan(max(abs(yNegative + yPositive)),1e-14);
        end
        function rowColumnAndMatrixShapes(testCase)
            row = numapprox.sinTaylorRecurrence([0 0.2 0.5],15);
            col = numapprox.sinTaylorRecurrence([0;0.2;0.5],15);
            matrix = numapprox.sinTaylorRecurrence(reshape(1:6,2,3),15);
            testCase.verifySize(row,[1 3]); testCase.verifySize(col,[3 1]); testCase.verifySize(matrix,[2 3]);
        end
        function directMatchesRecurrence(testCase)
            x = linspace(-1,1,31);
            testCase.verifyLessThan(max(abs(numapprox.sinTaylorDirect(x,15)-numapprox.sinTaylorRecurrence(x,15))),1e-14);
        end
        function evenDegreeRoundsDown(testCase)
            x=0.8; testCase.verifyEqual(numapprox.sinTaylorRecurrence(x,10),numapprox.sinTaylorRecurrence(x,9),'AbsTol',0);
        end
        function invalidInputs(testCase)
            testCase.verifyError(@() numapprox.sinTaylorRecurrence([0 Inf],15),'MATLAB:validators:mustBeFinite');
            testCase.verifyError(@() numapprox.sinTaylorRecurrence([0 NaN],15),'MATLAB:validators:mustBeFinite');
            testCase.verifyError(@() numapprox.sinTaylorRecurrence(0,-1),'MATLAB:validators:mustBeNonnegative');
        end
    end
end
