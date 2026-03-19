# VASP Workflows

VASP 6.4.2 calculation workflows for TACC Lonestar6.

Load the module before running any calculation:
```bash
module load vasp/6.4.2
```

## Calculation types

| Directory | INCAR key tags | Purpose |
|---|---|---|
| `scf/` | `IBRION=-1`, `NSW=0` | Ground state energy and charge density |
| `relax/` | `IBRION=2`, `NSW>0`, `ISIF=3` | Relax ions and cell |
| `bands/` | `ICHARG=11`, `IBRION=-1` | Band structure along k-path |
| `dos/` | `ICHARG=11`, `NEDOS`, `EMIN/EMAX` | Density of states |
| `phonons_zone_center/` | `IBRION=8`, `LEPSILON=.FALSE.` | Zone-center phonon frequencies |
| `phonons_dispersion/` | `IBRION=8` + phonopy | Full phonon dispersion |
| `born_charges/` | `IBRION=8`, `LEPSILON=.TRUE.` | Born effective charges + dielectric |
| `dielectric/` | `IBRION=8`, `LEPSILON=.TRUE.` | Macroscopic dielectric tensor |
| `elasticity/` | `IBRION=6`, `ISIF=3` | Elastic constants |
| `oneshot/` | all of the above | Sequential workflow |

## General notes

- All calculations use non-spin-polarized settings (`ISPIN=1`) by default.
- POTCAR files are not included (licensed). Place your POTCAR in the
  calculation directory. `01_setup.sh` checks for it on startup.
- The `bands/` and `dos/` calculations require a converged CHGCAR from
  a prior `scf/` run. See their READMEs for details.
- The `phonons_dispersion/` workflow requires phonopy to be installed.
  See that directory's README for setup instructions.
