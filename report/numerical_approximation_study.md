# Numerical Approximation of the Sine Function

## 1. Problem

The question is how accurately and efficiently `sin(x)` can be approximated under IEEE binary64 arithmetic when different mathematically valid algorithms are used. MATLAB's `sin` is the practical reference implementation.

## 2. Mathematical Background

### Taylor series

\[
\sin x = \sum_{k=0}^{\infty}(-1)^k\frac{x^{2k+1}}{(2k+1)!}.
\]

The direct baseline forms powers and factorials explicitly. The recurrence starts with `t_0=x` and uses \(t_{k+1}=-t_kx^2/((2k+2)(2k+3))\), reducing repeated work and large intermediate constructions.

### Taylor remainder

For the polynomial through degree `m`, the Lagrange bound used by the code is \(|R_m(x)|\le |x|^{m+1}/(m+1)!\), because every derivative of sine has magnitude at most one. This is a truncation bound, not a bound on total floating-point error.

### Chebyshev approximation

On `[a,b]`, the implementation maps `x` to `t=(2x-a-b)/(b-a)` and computes coefficients from Chebyshev nodes. The expansion convention is `c_0/2 + sum(c_k T_k(t))`. The construction targets an interval rather than only local behavior near zero.

### Floating-point arithmetic

For binary64 round-to-nearest, MATLAB `eps` is the spacing from `1` to the next representable value, while the conventional unit roundoff near one is `u = eps/2`. They are related but are not exact synonyms. The experiments also use `eps(reference)` as a local spacing estimate for finite values.

## 3. Implemented Algorithms

`numapprox.sinTaylorDirect` is an explicit baseline. `numapprox.sinTaylorRecurrence` reuses consecutive terms. `numapprox.rangeReduce` computes a transparent moderate-range representation `x=q*pi/2+r`, and `sinTaylorReduced` evaluates sine and cosine near zero before quadrant reconstruction. `chebyshevCoefficients` constructs interval-specific coefficients, while `clenshaw` evaluates them without explicitly forming high powers.

All public approximation routines accept finite real double inputs. Non-finite inputs are rejected rather than converted into plausible-looking outputs.

## 4. Experimental Methodology

Convergence studies vary odd degree and report the degree attaining minimum observed error. Range-reduction studies use deterministic positive and negative values formed from `k*pi+delta`, `k*pi/2+delta`, and logarithmically spaced moderate magnitudes. Taylor and Chebyshev studies use the common interval `[-pi,pi]` and maximum interval error as the primary metric. The floating-point study overlays observed error, the theoretical truncation bound, and a unit-roundoff scale. Benchmarks sweep degrees `3:2:25`, precompute Chebyshev coefficients outside timed evaluation, warm each function, and use `timeit` where available.

## 5. Results

The test suite and full reproduction pipeline completed successfully in GitHub Actions using MATLAB R2026a Update 5 on `GLNXA64`. The reviewed outputs are stored under `results/reference/` and `results/figures/`.

For Taylor recurrence, the observed minimum absolute errors at the selected points were approximately `1.39e-17` at `x=0.1`, `0` at `x=1` in double-precision comparison with MATLAB's `sin`, `5.55e-17` at `x=3`, and `5.44e-15` at `x=7`. The zero reported at `x=1` denotes equality of the two computed double-precision values, not exact real-arithmetic equality.

On `[-pi,pi]`, the degree-17 Chebyshev approximation produced maximum absolute error of approximately `1.56e-13`. In the benchmark sweep, range-reduced Taylor reached a maximum absolute error of approximately `1.11e-15` at degree 15 and approximately `3.33e-16` from degree 17 onward for the tested grid.

The benchmark timings are environment-specific. Chebyshev timing measures evaluation with coefficients precomputed outside the timed region, so it should be interpreted as repeated-evaluation cost rather than end-to-end coefficient-construction cost.

## 6. Numerical Stability Discussion

Taylor evaluation around zero becomes less attractive as the argument grows because large alternating terms can create cancellation and because the local polynomial must represent a periodic function away from its expansion point. Range reduction changes the evaluation to a small interval. Chebyshev approximation allocates approximation effort across an interval, and Clenshaw is the natural recurrence for its basis. The magnitude and onset of these effects must be read from generated data rather than asserted universally.

## 7. Accuracy–Performance Trade-offs

The benchmark sweep records runtime and maximum/mean error for several degrees and marks calculated nondominated points. A fixed-interval Chebyshev expansion can amortize coefficient setup across repeated evaluations, while reduced Taylor evaluation is simpler to configure. These observations are domain-dependent; MATLAB's own `sin` remains the appropriate general-purpose implementation.

## 8. Limitations

The transparent reducer is not a Payne–Hanek implementation and is not claimed to be correctly rounded for arbitrary huge arguments. Chebyshev approximations are interval-specific. Runtime depends on hardware, MATLAB release, JIT behavior, and grid size. Tests validate the documented domain but cannot prove correctness for every floating-point edge case.

## 9. Conclusions

The repository isolates one function so that mathematical approximation theory and implementation effects can be examined together. The current reference results are generated by MATLAB and retained separately from machine-specific raw outputs so that implemented methods, verified evidence, and reproducible experiments remain distinguishable.
