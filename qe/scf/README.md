# QE SCF — SrTiO₃

Self-consistent field (SCF) calculation for SrTiO₃ using `pw.x` from
[Quantum ESPRESSO](https://www.quantum-espresso.org/). Computes the
ground-state charge density and total energy on Lonestar6 (TACC).

---

## Repo structure

```
scf/
├── scf.in          # pw.x input file
├── jobscript       # Slurm submission script
└── README.md
```

Pseudopotentials are **not** stored in the repo. See
[Pseudopotentials](#pseudopotentials) below.

---

## Quick start

```bash
# 1. Set pseudo_dir in scf.in to your pseudopotential directory (see below)
# 2. Submit
sbatch jobscript
```

Output lands in `results_<JOBID>/` in the same directory you submitted from.

---

## Pseudopotentials

Each user maintains their own pseudopotential directory. The path is set
once in `scf.in` under `&control`:

```fortran
pseudo_dir = '/work/XXXX/YOUR_USERNAME/ls6/qe/pseudos/pslibrary',
```

Replace `XXXX` and `YOUR_USERNAME` with your TACC allocation number and
username. You can find your work directory with:

```bash
echo $WORK
```

### Downloading the pseudopotentials

Download the three required files from the
[Quantum ESPRESSO pseudopotential library](https://pseudopotentials.quantum-espresso.org/legacy_tables):

```bash
mkdir -p $WORK/qe/pseudos/pslibrary
cd $WORK/qe/pseudos/pslibrary

wget https://pseudopotentials.quantum-espresso.org/upf_files/Sr.pbesol-spn-kjpaw_psl.1.0.0.UPF
wget https://pseudopotentials.quantum-espresso.org/upf_files/Ti.pbesol-spn-kjpaw_psl.1.0.0.UPF
wget https://pseudopotentials.quantum-espresso.org/upf_files/O.pbesol-n-kjpaw_psl.1.0.0.UPF
```

| File | Element | Type |
|---|---|---|
| `Sr.pbesol-spn-kjpaw_psl.1.0.0.UPF` | Sr | PBEsol PAW |
| `Ti.pbesol-spn-kjpaw_psl.1.0.0.UPF` | Ti | PBEsol PAW |
| `O.pbesol-n-kjpaw_psl.1.0.0.UPF`    | O  | PBEsol PAW |

---

## The Slurm scheduler

Lonestar6 uses [Slurm](https://slurm.schedmd.com/) to manage jobs. You do
not run `pw.x` directly on the login node — you write a job script and
*submit* it to a queue. Slurm allocates compute nodes, runs your script,
and writes stdout/stderr to a log file.

### Key `#SBATCH` directives in `jobscript`

| Directive | Value | Meaning |
|---|---|---|
| `-J qe_scf` | job name | Label shown in `squeue` |
| `-p development` | partition | Queue to submit to. `development` is for short test runs (≤ 30 min, ≤ 4 nodes). Change to `normal` for production. |
| `-N 1` | nodes | Number of compute nodes |
| `-n 32` | tasks | Total MPI ranks. LS6 nodes have 128 cores; 64 uses half a node. |
| `-A PHY24018` | allocation | Charge hours to this project account |
| `-o slurm-%j.log` | log file | Merged stdout and stderr; `%j` is replaced by the job ID |
| `-e slurm-%j.log` | log file | Pointed to the same file to merge stderr into the log |
| `-t 00:05:00` | time limit | Wall clock limit (HH:MM:SS). Job is killed if exceeded. |

### Useful Slurm commands

```bash
sbatch jobscript          # submit a job
squeue -u $USER           # check your jobs in the queue
scancel <JOBID>           # cancel a job
seff <JOBID>              # efficiency report after job completes
```

---

## The SCF input file (`scf.in`)

Full `pw.x` input documentation:
[INPUT_PW](https://www.quantum-espresso.org/Doc/INPUT_PW.html)

Input is organized into *namelists* (`&name ... /`) followed by *cards*
(uppercase keywords).

### `&control` — job control

```fortran
calculation  = 'scf'           ! single-point SCF (no relaxation)
restart_mode = 'from_scratch'  ! start fresh; use 'restart' to continue a stopped run
pseudo_dir   = '...'           ! absolute path to your pseudopotential directory
outdir       = './outdir/'     ! scratch space for wavefunctions and charge density
prefix       = 'SrTiO3'        ! filename prefix for all output files
```

### `&system` — crystal and basis set

```fortran
ibrav   = 0     ! supply cell vectors explicitly via CELL_PARAMETERS
nat     = 5     ! number of atoms in the unit cell
ntyp    = 3     ! number of atomic species (Sr, Ti, O)
ecutwfc = 60    ! plane-wave kinetic energy cutoff (Ry)
ecutrho = 600   ! charge density cutoff (Ry); 10× ecutwfc for PAW
```

> **Cutoffs:** For PAW pseudopotentials `ecutrho` should be ~4–10×
> `ecutwfc`. Here 600 Ry = 10 × 60 Ry, which is conservative and safe
> for transition metals.

### `&electrons` — SCF solver

```fortran
diagonalization = 'david'   ! Davidson iterative diagonalizer (default, efficient)
conv_thr        = 1.0e-9    ! SCF convergence threshold (Ry); 1e-6 is typical, 1e-9 is tight
mixing_beta     = 0.2       ! charge mixing fraction; lower = more stable but slower
```

### `&ions` and `&cell`

Empty here because this is a fixed-geometry SCF. They are required
placeholders if you later switch to `calculation = 'relax'` or `'vc-relax'`.

### Cards

**`ATOMIC_SPECIES`** — element, mass (amu), pseudopotential filename:
```
Sr 87.620 Sr.pbesol-spn-kjpaw_psl.1.0.0.UPF
Ti 47.867 Ti.pbesol-spn-kjpaw_psl.1.0.0.UPF
O  15.999 O.pbesol-n-kjpaw_psl.1.0.0.UPF
```

**`K_POINTS automatic`** — Monkhorst-Pack k-point mesh:
```
4 4 4  0 0 0
```
4×4×4 mesh, no offset. Converge this for your system.

**`CELL_PARAMETERS (angstrom)`** — lattice vectors. SrTiO₃ is cubic,
*a* = 3.905 Å:
```
3.905  0.000  0.000
0.000  3.905  0.000
0.000  0.000  3.905
```

**`ATOMIC_POSITIONS (crystal)`** — fractional coordinates of the 5-atom
perovskite unit cell (ABO₃, *Pm3̄m*):
```
Sr   0.5  0.5  0.5   ← A-site, body center
Ti   0.0  0.0  0.0   ← B-site, corner
O    0.5  0.0  0.0   ← face centers (×3)
O    0.0  0.5  0.0
O    0.0  0.0  0.5
```

---

## The job script (`jobscript`)

```bash
RUNDIR=$SCRATCH/qe_runs/${SLURM_JOB_ID}
```
QE is run from `$SCRATCH` (a fast parallel filesystem), not `$WORK` or
`$HOME`. Each job gets its own subdirectory named by job ID to avoid
collisions.

```bash
cp $WORKDIR/scf.in .
```
Only the input file is staged — pseudopotentials are read directly from
`pseudo_dir` in `scf.in` with no copying.

```bash
module purge
module load intel/19.1.1 impi/19.0.9
module load qe/7.3
```
`module purge` clears any inherited environment. The Intel compiler and MPI
stack are loaded before QE because the LS6 QE module depends on them.

```bash
ibrun pw.x -input scf.in > scf.out
```
`ibrun` is TACC's MPI launcher (equivalent to `mpirun`). Always use `ibrun`
on TACC systems.

```bash
rsync -av $RUNDIR/ $WORKDIR/results_${SLURM_JOB_ID}/
```
Results are copied back to `$WORK` at the end. `$SCRATCH` is not backed up
and files there may be purged after 10 days.

The script records a Unix timestamp before and after the run and prints
a formatted wall time at the end of `slurm-<JOBID>.log`.

---

## Output files

After the job completes, `results_<JOBID>/` will contain:

| File | Contents |
|---|---|
| `scf.out` | Main QE output: SCF iterations, total energy, timing |
| `slurm-<JOBID>.log` | Job-level log: start/end times, total wall time |
| `outdir/SrTiO3.save/` | Charge density and wavefunctions for follow-on calculations |

The total energy is reported in `scf.out`:
```
!    total energy              =    -XXX.XXXXX Ry
```

---

## Notes

- `outdir` and `prefix` must be consistent across SCF → bands → DOS
  calculations so downstream runs can find the charge density.
- SrTiO₃ is an insulator. You can add `occupations = 'fixed'` to `&system`
  and omit smearing parameters for a cleaner setup, though the defaults
  are harmless here.
- To run in production, change `#SBATCH -p development` to
  `#SBATCH -p normal` and increase the time limit.
