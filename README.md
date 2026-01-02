# Maclaurin Series Demo for sin(x) (MATLAB)

A self-contained MATLAB demo illustrating **Maclaurin series approximations of sin(x)** using a fully numerical approach (no Symbolic Toolbox required).

The script visualizes approximation quality, error behavior, convergence via an animated GIF, a 3D error surface, and includes a classic **non-analytic counterexample** where the Maclaurin series fails.

---

## Features

- Overlay plots of `sin(x)` and multiple Maclaurin polynomials  
- Approximation vs absolute error for a selected polynomial degree  
- Animated GIF showing convergence as the degree increases  
- Comparison of true error with the “next-term” error proxy  
- 3D surface plot: error vs `x` and number of included terms  
- Non-analytic counterexample at `x = 0` where the Maclaurin series fails  

---

## File

- **`maclaurin_sin_demo.m`**

---

## Requirements

- MATLAB (standard installation)
- No Symbolic Math Toolbox required
- Uses built-in MATLAB functions for plotting and GIF generation

---

## How to Run

1. Open MATLAB and set the **Current Folder** to the project directory.
2. Run the script:

```matlab
maclaurin_sin_demo
```

The script will generate several figures and optionally save a GIF file in the current folder.

---

## Output

- Multiple MATLAB figures:
  - `sin(x)` vs Maclaurin approximations
  - Approximation and absolute error (two-panel plot)
  - Error vs next-term proxy
  - 3D error surface
  - Non-analytic counterexample plot
- Animated GIF:
  - `maclaurin_sin.gif` (if enabled)

---

## Configuration

You can easily customize the demo by editing the parameters at the top of the script:

- Domain and resolution of `x`
- Polynomial degrees used for approximation
- Degree used for error analysis
- GIF generation options (enable/disable, delay time)
- 3D error surface resolution

---

## Notes

- The “next-term proxy” provides an intuitive estimate of the error near `x = 0`, but it is **not a strict bound** for all `x`.
- The non-analytic example demonstrates that even when all derivatives at a point exist and are zero, the Maclaurin series may still fail to represent the function.

---

## License

MIT License (recommended).  
Feel free to use, modify, and share for educational purposes.
