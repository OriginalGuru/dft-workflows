# VASP Density of States

Total and projected density of states.
Requires a converged charge density (CHGCAR) from a prior SCF calculation.

## Files

| File | Description |
|---|---|
| `POSCAR` | SrTiO3 relaxed structure |
| `INCAR` | DOS input tags |
| `KPOINTS` | Dense k-mesh for DOS (denser than SCF) |
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
| `ISMEAR` | `-5` | Tetrahedron method (best for DOS) |
| `LORBIT` | `11` | Write projected DOS per atom and orbital |
| `NEDOS` | `2000` | Number of DOS grid points |
| `EMIN` | `-10` | Lower energy bound for DOS (eV, relative to Fermi) |
| `EMAX` | `10` | Upper energy bound for DOS (eV, relative to Fermi) |

## Output

- `DOSCAR` — total and projected DOS; parse with vaspkit or pymatgen
- `vasprun.xml` — full output including DOS data
- `PROCAR` — orbital projections (if `LORBIT=11`)

## Notes

- Use a denser k-mesh than SCF for a well-converged DOS. A good rule of
  thumb is 2x the SCF mesh in each direction.
- `ISMEAR=-5` (tetrahedron) gives the best DOS quality for insulators
  and semiconductors. Do not use it for metals.
- The Fermi energy is written in OUTCAR and vasprun.xml. DOS energies
  in DOSCAR are referenced to the Fermi level.
