# VASP Dielectric Tensor

Macroscopic static dielectric tensor via DFPT.

Note: in practice this calculation is run together with Born effective
charges using a single VASP run with `IBRION=8` and `LEPSILON=.TRUE.`.
See `../born_charges/` for the combined workflow. This directory is
provided as a standalone reference for cases where only the dielectric
tensor is needed.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 relaxed structure |
| `INCAR` | DFPT input tags |
| `KPOINTS` | Gamma-centered k-point mesh |
| `POTCAR` | Not included — place your POTCAR here |
| `01_setup.sh` | Checks inputs and prepares the run directory |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
bash 01_setup.sh
sbatch jobscript.sh
```

## Key INCAR tags

| Tag | Value | Purpose |
|---|---|---|
| `IBRION` | `8` | DFPT |
| `NSW` | `1` | Required for IBRION=8 |
| `LEPSILON` | `.TRUE.` | Compute dielectric tensor |
| `EDIFF` | `1E-8` | Tight electronic convergence |

## Output

- `OUTCAR` — ionic and electronic contributions to the dielectric tensor
- `vasprun.xml` — dielectric tensor under `<varray name="dielectric_dft">`

## Notes

- The dielectric tensor has two contributions: electronic (clamped-ion)
  and ionic. VASP with `LEPSILON=.TRUE.` gives the electronic contribution
  only. The ionic contribution requires the Born charges and phonon
  frequencies and is computed in post-processing.
- For the full static dielectric constant (electronic + ionic), use
  structural-symmetry-tools or phonopy with the Born charges and
  phonon frequencies from `born_charges/`.
