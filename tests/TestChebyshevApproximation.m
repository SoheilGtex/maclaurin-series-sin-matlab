classdef TestChebyshevApproximation < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addSource(testCase), root=fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src')); testCase.TestData.root=root; end
    end
    methods (Test)
        function coefficientShapeAndGenericOutput(testCase)
            c=numapprox.chebyshevCoefficients(@(z) sin(z(:)).',[-pi,pi],12);
            testCase.verifySize(c,[13 1]);
        end
        function intervalAccuracy(testCase)
            x=linspace(-pi,pi,1001); y=numapprox.sinChebyshev(x,20,[-pi,pi]);
            testCase.verifyLessThan(max(abs(y-sin(x))),1e-14);
        end
        function clenshawConstantPreservesShapes(testCase)
            c=[4;0];
            testCase.verifyEqual(numapprox.clenshaw(c,0.2),2,'AbsTol',eps);
            testCase.verifyEqual(numapprox.clenshaw(c,[-1 0 1]),2*ones(1,3),'AbsTol',eps);
            testCase.verifyEqual(numapprox.clenshaw(c,[-1;0;1]),2*ones(3,1),'AbsTol',eps);
            testCase.verifyEqual(numapprox.clenshaw(c,reshape(-1:2,2,2)),2*ones(2,2),'AbsTol',eps);
        end
        function clenshawKnownPolynomial(testCase)
            t=[-1 -0.3 0.2 1];
            testCase.verifyEqual(numapprox.clenshaw([0;0;1],t),2*t.^2-1,'AbsTol',10*eps);
            testCase.verifyEqual(numapprox.clenshaw([1;2;3],t),1/2+2*t+3*(2*t.^2-1),'AbsTol',10*eps);
        end
        function oddSymmetry(testCase)
            x=linspace(-pi,pi,101); y=numapprox.sinChebyshev(x,17,[-pi,pi]);
            testCase.verifyLessThan(max(abs(y+numapprox.sinChebyshev(-x,17,[-pi,pi]))),1e-14);
        end
        function invalidIntervalAndCoefficients(testCase)
            testCase.verifyError(@() numapprox.sinChebyshev(0,5,[1 1]),'numapprox:InvalidInterval');
            testCase.verifyError(@() numapprox.sinChebyshev(0,5,[-1 1],[1;2]),'numapprox:InvalidCoefficients');
            testCase.verifyError(@() numapprox.chebyshevCoefficients(@(z) z,[1 1],3),'numapprox:InvalidInterval');
        end
        function invalidInputs(testCase)
            testCase.verifyError(@() numapprox.sinChebyshev(Inf,5,[-1 1]),'MATLAB:validators:mustBeFinite');
            testCase.verifyError(@() numapprox.clenshaw([1;2],[0 NaN]),'MATLAB:validators:mustBeFinite');
        end
    end
end
