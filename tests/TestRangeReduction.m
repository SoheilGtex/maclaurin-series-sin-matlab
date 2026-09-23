classdef TestRangeReduction < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addSource(testCase), root=fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src')); testCase.TestData.root=root; end
    end
    methods (Test)
        function reducedInterval(testCase)
            x=linspace(-100*pi,100*pi,1001); [r,q]=numapprox.rangeReduce(x);
            testCase.verifyLessThanOrEqual(max(abs(r)),pi/4+10*eps);
            testCase.verifyTrue(all(q>=0 & q<=3));
        end
        function reconstructionAtBoundaries(testCase)
            x=[-pi/4,pi/4,-3*pi/4,3*pi/4,pi/2,-pi/2];
            testCase.verifyLessThan(max(abs(numapprox.sinTaylorReduced(x,21)-sin(x))),1e-14);
        end
        function deterministicModerateOffsets(testCase)
            k=[-100 -17 -3 0 2 11 80]; delta=[0.13 -0.2 0.07 0.31 -0.11 0.19 -0.23];
            x=k*pi+delta; testCase.verifyLessThan(max(abs(numapprox.sinTaylorReduced(x,25)-sin(x))),1e-13);
        end
        function shapePreservation(testCase)
            testCase.verifySize(numapprox.sinTaylorReduced([0 1],15),[1 2]);
            testCase.verifySize(numapprox.sinTaylorReduced([0;1],15),[2 1]);
        end
        function invalidInputs(testCase)
            testCase.verifyError(@() numapprox.rangeReduce([0 Inf]),'MATLAB:validators:mustBeFinite');
            testCase.verifyError(@() numapprox.sinTaylorReduced([0 NaN],15),'MATLAB:validators:mustBeFinite');
        end
    end
end
