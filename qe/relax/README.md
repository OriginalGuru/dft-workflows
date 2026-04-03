# QE Relaxation — SrTiO₃

Structural relaxation of SrTiO₃ using `pw.x` from
[Quantum ESPRESSO](https://www.quantum-espresso.org/). Follows on from the
SCF calculation and covers both fixed-cell (`relax`) and variable-cell
(`vc-relax`) relaxation on Lonestar6 (TACC).

---

## Repo structure
```
relax/
├── relax.in        # pw.x input file (configured for vc-relax)
├── jobscript       # Slurm submission script
└── README.md
```

Pseudopotentials are **not** stored in the repo. See
[Pseudopotentials](#pseudopotentials) below.

---

## Quick start
```bash
# 1. Set pseudo_dir in relax.in to your pseudopotential directory (see below)
# 2. Submit
sbatch jobscript
```

Output lands in `results_<JOBID>/` in the same directory you submitted from.

---

## Pseudopotentials

The path is set in `relax.in` under `&control`:
```fortran
pseudo_dir = '/work/XXXX/YOUR_USERNAME/ls6/qe/pseudos/pslibrary',
```

Replace `XXXX` and `YOUR_USERNAME` with your TACC allocation number and
username. If you have already run the SCF calculation, the pseudopotentials
are already in place — use the same path here.

---

## Calculation types

### `relax` — ionic relaxation, fixed cell

Relaxes atomic positions only. Cell shape and volume are held fixed. Use
this when you trust your starting cell parameters (e.g. from experiment or
a previous `vc-relax`). Set `calculation = 'relax'` in `&control`.

### `vc-relax` — variable-cell relaxation

Relaxes both atomic positions and the cell (shape and volume). Use this
when starting from an approximate or unrelaxed structure. The current
`relax.in` is configured for this.

---

## The relaxation input file (`relax.in`)

Full `pw.x` input documentation:
[INPUT_PW](https://www.quantum-espresso.org/Doc/INPUT_PW.html)

The `&control`, `&system`, and `&electrons` namelists and all cards follow
the same conventions as `scf.in`. The sections below cover what is new.

### `&ions` — ionic minimisation

Controls how atomic positions are updated. Empty in the current `relax.in`,
so all parameters take their defaults.
```fortran
&ions
  ion_dynamics  = 'bfgs'   ! default; BFGS quasi-Newton minimiser
  forc_conv_thr = 1.0e-3   ! default; force threshold (Ry/Bohr)
  etot_conv_thr = 1.0e-4   ! default; total energy change threshold (Ry)
/
```

Relaxation stops when both `forc_conv_thr` and `etot_conv_thr` are
satisfied. For most structural work, tightening to `1.0e-4` and `1.0e-5`
respectively is worthwhile. For follow-on calculations that are sensitive
to forces (e.g. phonons), tighten further.

`conv_thr` in `&electrons` should be smaller than `etot_conv_thr` — a
rough guide is `conv_thr` ~ `etot_conv_thr / nat` or tighter. The current
`relax.in` sets `conv_thr = 1.0e-9`, which is appropriate for either
threshold choice above.

### `&cell` — cell minimisation (`vc-relax` only)

Controls how the cell is updated. Empty in the current `relax.in`, so all
parameters take their defaults.
```fortran
&cell
  cell_dynamics  = 'bfgs'   ! default; BFGS cell minimiser
  press_conv_thr = 0.5      ! default; pressure threshold (kbar)
/
```

`press_conv_thr` is often the bottleneck for cell convergence. The default
of 0.5 kbar is adequate for most purposes; tighten for equation-of-state
work or when a precise equilibrium volume is needed.

> **Getting started**: run `relax.in` as-is with the defaults, then add
> these flags explicitly and adjust the thresholds to see how they affect
> convergence. Compare the number of ionic steps and the final forces in
> `relax.out`.

### Key parameters (as set in `relax.in`)

| Parameter | Value | Purpose |
|---|---|---|
| `calculation` | `'vc-relax'` | Relax ions and cell |
| `ecutwfc` | `60` Ry | Wavefunction cutoff |
| `ecutrho` | `600` Ry | Charge density cutoff (10× for PAW) |
| `conv_thr` | `1.0e-9` | SCF convergence (Ry) |
| `mixing_beta` | `0.2` | Charge mixing; lowered for stability |
| `diagonalization` | `'david'` | Davidson diagonalizer |

---

## The job script (`jobscript`)

The structure is the same as in the SCF jobscript. The differences are:

| Directive | SCF | Relax |
|---|---|---|
| `-n` (MPI tasks) | 64 | 32 |
| `-t` (wall time) | 00:30:00 | 00:05:00 |

Both are set for the development partition. A `vc-relax` on a real system
will need more tasks and a longer time limit.

---

## Output

- `relax.out` — ionic steps, forces, and stress tensor at each step
- `outdir/` — charge density and wavefunction files

The final relaxed structure is printed at the end of `relax.out`:
```bash
grep -A 100 "Begin final coordinates" relax.out | grep -B 100 "End final coordinates"
```

Always copy the final `CELL_PARAMETERS` and `ATOMIC_POSITIONS` blocks into
subsequent calculation input files.

### Large output files

The jobscript does not copy `outdir/*.save/` or `wfc*.dat` back to the
submission directory — these files can be very large. They remain in
`$SCRATCH`, which is not backed up and is purged periodically. If you need
these files for a follow-on calculation (e.g. restarting, DFPT, or NEB),
retrieve or archive them before they are purged.

---

## Notes

- After a `vc-relax`, the relaxed `CELL_PARAMETERS` and `ATOMIC_POSITIONS`
  should be copied back into `relax.in` and the calculation resubmitted.
  Repeat until the output structure matches the input — this is necessary
  because the k-point mesh is defined in reciprocal space, and its effective
  sampling changes as the lattice constants evolve.
- `outdir` and `prefix` must match across all calculations in a workflow
  so downstream runs can locate the charge density.
- The naming convention `relax.in` / `relax.out` extends naturally to
  sequential workflows (e.g. `scf.in`, `nscf.in`, `bands.in`); this is
  the convention used throughout these workflows.
