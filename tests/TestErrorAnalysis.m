classdef TestErrorAnalysis < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addSource(testCase), root=fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src')); end
    end
    methods (Test)
        function metricsAndShapes(testCase)
            m=numapprox.errorMetrics([0 2 -4],[1 1 -2]);
            testCase.verifyEqual(m.absolute,[1 1 2]); testCase.verifyEqual(m.maxAbsolute,2);
            testCase.verifySize(m.ulpScaled,[1 3]); testCase.verifyEqual(m.relative,m.safeguardedRelative);
        end
        function remainderBound(testCase)
            x=0.7; d=11; e=abs(sin(x)-numapprox.sinTaylorRecurrence(x,d));
            b=numapprox.taylorRemainderBound(x,d); testCase.verifyLessThanOrEqual(e,b+20*eps);
        end
        function zeroBoundAndInvalidInputs(testCase)
            testCase.verifyEqual(numapprox.taylorRemainderBound(0,9),0);
            testCase.verifyError(@() numapprox.errorMetrics([0 Inf],[0 1]),'MATLAB:validators:mustBeFinite');
            testCase.verifyError(@() numapprox.errorMetrics([0 1],[0]),'numapprox:SizeMismatch');
        end
    end
end
