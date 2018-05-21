# CL_MEMDUT Simulation

The cl_memdut includes a basic test that exercises the BAR1, DDR_C, and interrupt.

The test can be run from the [verif/scripts] (scripts) directory with one of three different simulators:

```
    $ make C_TEST=test_memdut
    $ make C_TEST=test_memdut VCS=1
    $ make C_TEST=test_memdut QUESTA=1
```

Note that the appropriate simulators must be installed.

