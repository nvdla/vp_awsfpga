# CL_NVDLA Simulation

The cl_nvdla includes a basic test that exercises the BAR1, DDR_C, and interrupt.

The test can be run from the [verif/scripts] (scripts) directory with one of three different simulators:

```
    $ make C_TEST=test_nvdla
    $ make C_TEST=test_nvdla VCS=1
    $ make C_TEST=test_nvdla QUESTA=1
```

Note that the appropriate simulators must be installed.

