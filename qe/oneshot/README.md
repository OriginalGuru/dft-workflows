# QE Oneshot Workflow

Sequential calculation workflow that runs the following in a single
Slurm job using pw.x and ph.x:

1. SCF — ground state charge density
2. DOS — density of states (NSCF + dos.x)
3. Bands — electronic band structure (pw.x + bands.x)
4. Zone-center phonons — Gamma-point ph.x
5. Born effective charges — epsil=.true.
6. Dielectric tensor — macroscopic dielectric response
7. Elasticity — elastic constant tensor

## Files

| File | Description |
|---|---|
| `01_setup.sh` | All input files live here; sets PSEUDO_DIR |
| `jobscript.sh` | Slurm script that calls 01_setup.sh then runs each stage |

## Usage

```bash
# Edit PSEUDO_DIR in 01_setup.sh to point to your pseudopotential directory
bash 01_setup.sh    # verify inputs look correct
sbatch jobscript.sh
```

## Directory structure created by 01_setup.sh

```
run/
    scf/
        pw.in
    dos/
        pw.in  dos.in  projwfc.in
    bands/
        pw.in  bands.in
    phonons_zone_center/
        pw.in  ph.in
    born_charges/
        pw.in  ph.in
    dielectric/
        pw.in  ph.in
    elasticity/
        pw.in  ph.in
    tmp/              # shared outdir for all pw.x calculations
```

All pw.x calculations share the same `outdir` (`run/tmp/`) and `prefix`
so that SCF charge density and wavefunctions are available to all
subsequent steps without copying.

## Output

Each stage writes its output to its own subdirectory under `run/`.
Key output files:

| Stage | Key output |
|---|---|
| scf | `run/scf/pw.out` |
| dos | `run/dos/prefix.dos`, `prefix.pdos_*` |
| bands | `run/bands/prefix.bands.dat` |
| phonons_zone_center | `run/phonons_zone_center/ph.out`, `*.dyn` |
| born_charges | `run/born_charges/ph.out` |
| dielectric | `run/dielectric/ph.out` |
| elasticity | `run/elasticity/ph.out` |

## Notes

- Total wall time for SrTiO3 (5-atom primitive cell) is roughly 2-4 hours
  on a single LS6 node depending on k-mesh density.
- The jobscript checks the exit code of each step and stops on failure.
- Phonon dispersion is not included in oneshot — it requires a full
  q-point grid ph.x run which is substantially more expensive.
  See `../phonons_dispersion/`.
- Born charges and dielectric are combined into a single ph.x run
  (`epsil=.true.`, `trans=.true.`) for efficiency.
