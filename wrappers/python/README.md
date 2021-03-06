# Using the scatteringpath python wrapper

When feff85exafs is built and installed, the basic SWIG wrapper files
(`feffpathwrapper.py` and `feffpath_wrap.c`) will be installed into
this folder.  This folder contains the file `scatteringpath.py`, which
is a Larch plugin encasulating much prettier syntax for the wrapper
generated by SWIG.

This folder contains an example of its use in a Larch script.  The larch
script `makepath.lar` will read from `phase.pad` (this example is
calculated from copper metal) and write the files `feff0001.dat` and
`feff0004.dat`.

You **must** build and install feff85exafs before attempting to build
this wrapper.

To compile the python wrapper:

	~> python setup.py build_ext --inplace

To install:

    >~ sudo python setup.py install_data

I know that's not the standard python installation incantation, but
those commands will see the files installed into Larch's space (which
is required for `scatteringpath` to be recognized as a plugin) rather
than into Python's space.


## Sample program

Once installed, here is the simplest larch program using the python wrapper:

```python
a=scatteringpath()

a.phpad = '../fortran/phase.pad
a.deg   = 12
a.index = 1

a.atom(0,0,-3.61,1)

a.make()

show a
```

1. The scatteringpath plugin is imported into the Larch session

2. A FeffPath Group is made

3. The FeffPath Group is pointed at a `phase.pad` file on disk.  The
   degeneracy and path index are set.  The flag for friting out the
   `feffNNNN.dat` file is set to True.

4. A scattering atom (in this case a Cu atom in the first coordination
   shell of Cu metal) is added to the path.  This increments the nleg
   attribute of the Group.

5. F_eff is calcuated using the make method.  This writes the
   `feff0001.dat` file and stores the columns of that file in the `k`,
   `real_phc`, `mag_feff`, `pha_feff`, `red_fact`, `lam`, and `rep`
   attributes of the Group.


## Attributes of the FeffPath Group

### Input:

| element   | type     | description                           | default              |
| ----------| -------- | ------------------------------------- | -------------------- |
| phpad     | string   | path to `phase.pad`                   |  `phase.pad`         |
| index     | integer  | path index                            |  9999                |
| deg       | float    | path degeneracy                       |  required input      |
| nleg      | integer  | number of legs in path                |  set using atom method (read-only)         |
| rat       | array    | cartesian positions of atoms in path  |  set using atom method (not yet available) |
| ipot      | integer  | unique potentials of atoms in path    |  set using atom method (not yet available) |
| iorder    | integer  | order of approximation in genfmt      |  2                   |
| nnnn      | boolean  | flag to write `feffNNNN.dat` file     |  False               |
| json      | boolean  | flag to write `feffNNNN.json` file    |  False               |
| verbose   | boolean  | flag to write screen messages         |  False               |
| ipol      | boolean  | flag to do polarization calculation   |  False (set True when evec|xivec|elpty set) |
| evec      | array    | polarization vector                   |  (0,0,0)             |
| elpty     | float    | ellipticity                           |  0                   |
| xivec     | array    | direction of X-ray propagation        |  (0,0,0)             |

### Output:

| element      | type     | description                                                 |
| ------------ | -------- | ----------------------------------------------------------- |
| ri           | array    | leg lengths                                                 |
| beta         | array    | beta angles                                                 |
| eta          | array    | eta angles                                                  |
| reff         | float    | half path length (computed from ri)                         |
| ne           | integer  | number of energy points actually used by Feff (read-only)   |
| k            | array    | k grid for feff path calculation, column 1 in `feffNNNN.dat`|
| real_phc     | array    | central atom phase shifts. column 2 in `feffNNNN.dat`       |
| mag_feff     | array    | magnitude of F_eff, column 3 in `feffNNNN.dat`              |
| pha_feff     | array    | phase of F_eff, column 4 in `feffNNNN.dat`                  |
| red_fact     | array    | reduction factor, column 5 in `feffNNNN.dat`                |
| lam          | array    | mean free path, column 6 in `feffNNNN.dat`                  |
| rep          | array    | real part of complex momentum, column 7 in `feffNNNN.dat`   |
| errorcode    | integer  | error code from `atom` or `make`                            |
| errormessage | string   | error message from `atom` or `make`                         |

Additionally, several bits of information about the potential model
are capture.  These are things that Feff writes to the header of the
`feffNNNN.dat` file:

| attribute  | type    |  description                             |
| ---------- | ------- | ---------------------------------------- |
|  edge      | float   |  energy threshold relative to atomic value (a poor estimate) |
|  gam\_ch   | float   |  core level energy width |
|  kf        | float   |  k value at Fermi level |
|  mu        | float   |  Fermi level, eV |
|  rnorman   | float   |  average Norman radius |
|  version   | string  |  Feff version |
|  exch      | string  |  brief description of the electronic exchange model |
|  rs\_int   | float   |  interstitial radius |
|  vint      | float   |  interstitial potential |
|  version   | string  |  the version of feff and the feffpath revision |


A polarization calculation is enabled by setting the `ipol` element to
a true value.  `evec` has 3 elements and represents the polarization
vector of the incident beam.  `elpty` and `xivec` are the ellipticity
and Poynting vector of the incident beam for a calculation with
ellipticity.

When `make` is called, the `ri`, `beta`, and `eta` arrays are
filled to be `nleg` elements long and contain the geometry of the
scattering path.

Also when `make` is called, the arrays containing the columns of a
traditional `feffNNNN.dat` file are filled to be `ne` elements long.
These arrays are the same (besides precision) as the corresponding
columns.  While a `feffNNNN.dat` file can be exported (using the
`nnnn` flag), the need to write/read that file is obviated.

Direct access to `rat` and `ipot` is not provided.  Use `atom`.

## A comment on the atom method

The way of building the geometry of the scattering path was
purposefully kept completely general.  While a program might use the
output of Feff's pathfinder, we also want to suport any other way of
generating path geometries.

To use the output of Feff's pathfinder, one would parse the
`paths.dat` file, making a path for each "paragraph" in the file and
calling `atom` for each atom in the path.

As a more complicated example, a reverse Monte Carlo approach to a fit
will move atoms to minimize difference between a model and the data.
As the atoms move about, the RMC program will generate new SS and MS
paths based on the current atom positions.  In that case, the current
coordinates can be used as the input to `atom` (with the caveat that
the `feffpath` library expects the absorber to be at the origin, so
the arguments to `atom` should have the absorber position subtracted
off).

