# Quantum ESPRESSO Workflows

Quantum ESPRESSO 7.2 calculation workflows for TACC Lonestar6.

Load the module before running any calculation:
```bash
module load qe/7.2
```

## Calculation types

| Directory | QE executable | Purpose |
|---|---|---|
| `scf/` | `pw.x` | Ground state energy and charge density |
| `relax/` | `pw.x` | Ionic and cell relaxation |
| `bands/` | `pw.x` + `bands.x` | Electronic band structure |
| `dos/` | `pw.x` + `dos.x` + `projwfc.x` | Density of states |
| `phonons_zone_center/` | `pw.x` + `ph.x` | Zone-center phonon frequencies |
| `phonons_dispersion/` | `pw.x` + `ph.x` + `q2r.x` + `matdyn.x` | Full phonon dispersion |
| `born_charges/` | `pw.x` + `ph.x` | Born effective charges |
| `dielectric/` | `pw.x` + `ph.x` | Dielectric tensor |
| `elasticity/` | `pw.x` + `ph.x` | Elastic constants |
| `oneshot/` | all of the above | Sequential workflow |

## General notes

- All calculations use non-spin-polarized settings by default.
- Pseudopotential files (`.UPF`) are not included. Each directory's
  README specifies which pseudopotentials are required. Download from
  https://www.quantum-espresso.org/pseudopotentials or
  https://pseudopotentials.quantum-espresso.org/
- Set the `PSEUDO_DIR` variable in `01_setup.sh` to point to your
  pseudopotential directory.
- The `bands/` and `dos/` calculations require a converged charge
  density from a prior `scf/` run.
- QE writes output to stdout by default. The jobscripts redirect this
  to `.out` files in each calculation directory.

## Input file conventions

Each QE calculation uses a pw.x input file (`pw.in`) with namelist
format. Key namelists:

- `&CONTROL` — calculation type, file paths, output options
- `&SYSTEM` — structure, cutoffs, smearing
- `&ELECTRONS` — SCF convergence
- `&IONS` — ionic relaxation (relax only)
- `&CELL` — cell relaxation (relax only)
- `ATOMIC_SPECIES` — element, mass, pseudopotential file
- `ATOMIC_POSITIONS` — atomic coordinates
- `K_POINTS` — k-point mesh
- `CELL_PARAMETERS` — lattice vectors (if not using ibrav)
