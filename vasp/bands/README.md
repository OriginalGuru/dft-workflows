# VASP Band Structure

Electronic band structure along a k-path through the Brillouin zone.
Requires a converged charge density (CHGCAR) from a prior SCF calculation.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 relaxed structure |
| `INCAR` | Band structure input tags |
| `KPOINTS` | Explicit k-path through high-symmetry points |
| `POTCAR` | Not included — place your POTCAR here |
| `01_setup.sh` | Copies CHGCAR from SCF directory, checks inputs |
| `jobscript.sh` | Slurm submission script |

## Usage

```bash
# Requires completed SCF run in ../scf/
bash 01_setup.sh
sbatch jobscript.sh
```

## Key INCAR tags

| Tag | Value | Purpose |
|---|---|---|
| `IBRION` | `-1` | No ionic movement |
| `NSW` | `0` | No ionic steps |
| `ICHARG` | `11` | Read and fix charge density from CHGCAR |
| `LORBIT` | `11` | Write projected DOS and band character |
| `NEDOS` | `2000` | Number of DOS grid points |

## KPOINTS format

The KPOINTS file uses an explicit k-path format:
```
k-path SrTiO3
40
Line-mode
Reciprocal
  0.0  0.0  0.0    ! Gamma
  0.5  0.0  0.0    ! X
  ...
```
Adjust the number of k-points per segment (line 3) and the path
to match your structure and space group.

## Output

- `EIGENVAL` — eigenvalues at each k-point; used for band plotting
- `PROCAR` — projected band character (if `LORBIT=11`)
- `vasprun.xml` — full output including band data

## Notes

- `01_setup.sh` copies or symlinks CHGCAR from `../scf/`. If the SCF
  directory is elsewhere, edit the path in `01_setup.sh`.
- For SrTiO3 (cubic, Pm-3m), the standard k-path is
  Gamma -> X -> M -> Gamma -> R -> X.
- Post-processing with pymatgen, vaspkit, or sumo is recommended
  for publication-quality band plots.
